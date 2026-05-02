# Refresh Checklist — 슬라이드를 추가/삭제했을 때

`lecture_all_v2.tex` 의 frame을 추가하거나 삭제하면 PDF 페이지 번호가 그
뒤로 밀리거나 줄어든다. 이 문서는 그때 함께 손봐야 하는 메타 정보 +
빌드 절차를 정리한다.

---

## 1. 빌드

PDF는 `output/lecture_all_v2.pdf` 한 개로 합쳐져 있다.

```powershell
.\build.ps1 lecture_all_v2
```

PowerShell 실행 정책에 막힐 때:

```powershell
PowerShell -ExecutionPolicy Bypass -File .\build.ps1 lecture_all_v2
```

Docker 직접 호출 (build.ps1 안에서 하는 일과 동일):

```powershell
docker run --rm -v "C:/Users/.../modern-robot-state-estimation:/workspace" `
  eskf-lecture-builder `
  xelatex -interaction=nonstopmode -halt-on-error `
  -output-directory=/workspace/__build /workspace/lecture_all_v2.tex
```

XeLaTeX는 **2번** 돌려야 cross-reference (`\ref`, `\pageref`,
PDF outline `.out`) 가 안정된다. 3번 돌리면 더 보수적.

> Git Bash 에서 `docker run -v "/c/..."` 형태로 호출하면 MSYS의 path
> translation 으로 컨테이너 내부 경로(`/workspace/...`)까지 Windows 경로로
> 바뀌어 `! I can't find file ...` 로 실패한다. PowerShell을 쓰거나
> `MSYS_NO_PATHCONV=1` 를 앞에 붙인다.

---

## 2. 페이지 번호가 박혀 있는 곳 — 함께 갱신

### `README.md`

- "사전 빌드된 PDF (약 N쪽)" — 새 총 페이지 수로 갱신
- "## 회차별 구성" 표의 해당 회차 슬라이드 수 컬럼

  ```
  | 0 | 2025 필드 지형도 | 9  |
  | 1 | Bayes filter ... | 30 |
  ```

  추가/삭제한 frame이 속한 회차 행을 ±1.

### `index.html` — 웹 뷰어

PDF outline (`\section` bookmark) 에서 자동으로 사이드바에 잡히는 항목은
**갱신 불필요**. pdf.js의 `getOutline()` 이 PDF에서 직접 페이지 번호를
끌어온다.

**수동으로 박혀 있는 페이지 번호만 손보면 된다:**

- `FINAL_PAGE_IDX = 902` — 마무리 챕터 시작 페이지 (0-based, 즉 p.903)
  → 추가/삭제된 frame이 마무리 챕터 *이전* 이라면 ±1 갱신.

검색:

```
grep -nE "FINAL_PAGE_IDX|PAGE_IDX" index.html
```

다른 정적 페이지 항목을 추가했다면 그 위치도 같이.

### URL 공유 링크

브라우저 주소창의 `?page=N` 같은 링크는 사용자 측에서 갱신해야 함
(슬랙/메신저에 공유한 링크가 있다면 주의).

---

## 3. 영향받지 않는 것

- 사이드바 회차 목차 (PDF outline에서 동적 추출)
- 검색 인덱스 (사용자가 검색창 첫 포커스 시 매번 새로 빌드)
- 줌/레이아웃/스킨/페이지 input 등 UI 상태 — PDF 내용과 무관

---

## 4. Frame 추가 시 매크로 주의

기존 frame의 표기 컨벤션을 따른다 — Hamilton 쿼터니언, right perturbation,
OpenVINS 상태 순서 등. `preamble.tex` 에 정의된 매크로만 사용:

```
\hatR, \dphivec, \Exp, \Log, \skewx{...}, \sothree
\bF, \bG, \bH, \bK, \bm{...}
```

새 매크로가 필요하면 `preamble.tex` 에 먼저 추가한 다음 본문에서 사용.
정의 없는 매크로를 쓰면 빌드는 `! Undefined control sequence.` 에서 멈춘다
(`-halt-on-error` 옵션 때문).

---

## 5. push 체크리스트

한 커밋에 묶기 (PDF가 tex와 어긋난 상태로 푸시되지 않도록):

- [ ] `lecture_all_v2.tex` / `preamble.tex` 변경 반영
- [ ] `output/lecture_all_v2.pdf` 재빌드
- [ ] `README.md` — 총 페이지 수 + 해당 회차 슬라이드 수
- [ ] `index.html` — 정적 페이지 번호 (`FINAL_PAGE_IDX` 등)
- [ ] 위 파일들 한 커밋으로 commit 후 push

---

## 6. 자주 만나는 빌드 에러

- `! Undefined control sequence. ... \bG` — 매크로 미정의. preamble에
  `\newcommand{\bG}{\bm{G}}` 같은 줄 추가.
- `LaTeX Warning: Reference 'LastPage' on page N undefined` — 1st pass
  warning. 2nd pass에서 사라짐. 무시.
- `Class beamer Warning: Frame text is shrunk by ...` — frame 안 컨텐츠
  과다. `[shrink=N]` 인자 키우거나 컨텐츠 줄임.
- `! I can't find file "C:/Program Files/Git/workspace/..."` — Git Bash의
  경로 변환 문제. §1 의 PowerShell 또는 `MSYS_NO_PATHCONV=1` 사용.
