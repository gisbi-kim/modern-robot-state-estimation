# build.ps1 — XeLaTeX + Korean font Docker builder
# Usage:
#   .\build.ps1              # build all lecture*.tex
#   .\build.ps1 lecture04    # build single file (with or without .tex)
#   .\build.ps1 -Rebuild     # force rebuild Docker image

param(
    [string]$File  = "all",
    [switch]$Rebuild
)

$ErrorActionPreference = "Stop"
$ImageName = "eskf-lecture-builder"
$WorkDir   = $PSScriptRoot
$BuildDir  = Join-Path $WorkDir "__build"
$OutputDir = Join-Path $WorkDir "output"

# ---- Dirs ----------------------------------------------------------------
if (-not (Test-Path $BuildDir))  { New-Item -ItemType Directory -Path $BuildDir  | Out-Null }
if (-not (Test-Path $OutputDir)) { New-Item -ItemType Directory -Path $OutputDir | Out-Null }

# ---- Docker image --------------------------------------------------------
$exists = docker images -q $ImageName 2>$null
if ($Rebuild -or -not $exists) {
    Write-Host "[build] Building Docker image '$ImageName' ..."
    docker build -t $ImageName "$WorkDir"
    if ($LASTEXITCODE -ne 0) { throw "Docker build failed" }
}

# ---- Helper: compile one .tex (twice for correct page refs) --------------
function Build-Tex {
    param([string]$TexFile)
    $base = [System.IO.Path]::GetFileNameWithoutExtension($TexFile)
    Write-Host "`n[build] ===== $TexFile ====="

    foreach ($pass in 1,2) {
        Write-Host "[build]   pass $pass ..."
        docker run --rm `
            -v "${WorkDir}:/workspace" `
            $ImageName `
            xelatex -interaction=nonstopmode -halt-on-error `
                -output-directory=/workspace/__build `
                /workspace/$TexFile
        if ($LASTEXITCODE -ne 0) {
            throw "xelatex failed on $TexFile (pass $pass)"
        }
    }
    # Move PDF to output/, leave aux files in __build/
    Move-Item -Force "$BuildDir/${base}.pdf" "$OutputDir/${base}.pdf"
    Write-Host "[build]   -> output/${base}.pdf  OK"
}

# ---- Main ----------------------------------------------------------------
if ($File -eq "all") {
    $texFiles = Get-ChildItem -Path $WorkDir -Filter "lecture*.tex" |
                Sort-Object Name
    Write-Host "[build] Found $($texFiles.Count) lecture files."
    foreach ($f in $texFiles) {
        Build-Tex $f.Name
    }
} else {
    $name = if ($File.EndsWith(".tex")) { $File } else { "$File.tex" }
    Build-Tex $name
}

Write-Host "`n[build] All done."
