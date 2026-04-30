# Modern Robot State Estimation

10-lecture Beamer course on modern robot state estimation, centered on the
**Error-State Kalman Filter (ESKF)** and its connection to factor-graph
optimization. Written in Korean with English math/code.

> **Core message of this course:**
>
> $$ \text{ESKF} \subset \text{IEKF} \equiv \text{Gauss-Newton on MAP} \subset \text{Factor Graph} $$
>
> *— Bell & Cathey, IEEE TAC 1993.*
>
> Filters and smoothers aren't different algorithms. They're different
> *schedules* for solving the same MAP cost.

---

## What's inside

- `lecture_all_v2.tex` — single-file, 10-lecture Beamer source (~12,000 lines, 437 frames)
- `preamble.tex` — Beamer + metropolis + Korean fonts (Noto CJK KR) preamble
- `Dockerfile` — XeLaTeX + Korean font build environment
- `build.ps1` — PowerShell helper for the Docker build
- `output/lecture_all_v2.pdf` — pre-built PDF (~917 pages)

---

## Lecture map

| 회차 (Lecture) | Topic | Frames |
|---|---|---|
| 0 | 2025 필드 지형도 (filter/smoother ecosystem) | 9 |
| 1 | Bayes filter, Gaussian | 30 |
| 2 | SO(3) 입문 + Jacobians ($J_r$, BCH, Adjoint) | 56 |
| 3 | 선형 Kalman Filter (5-line derivation, Joseph form) | 34 |
| 4 | **ESKF 핵심** (15D error state, F matrix, Inject & Reset) | 22 |
| 5 | IMU 물리 + ESKF Predict + Preintegration (Forster 2017) | 57 |
| 6 | 멀티센서 Update (GPS / wheel / camera H) | 16 |
| 7 | 관측가능성 + Factor Graph + MAP + Marginalization | 76 |
| 8 | MSCKF + Visual-Inertial Odometry (OpenVINS) | 62 |
| 9 | LiDAR — FAST-LIO / FAST-LIO2 / FAST-LIVO2 | 72 |

Each lecture maps directly to real codebases — students should be able to
read OpenVINS `Propagator.cpp`, FAST-LIO2's IEKF, GTSAM's `ImuFactor`, and
VINS-Mono's sliding-window optimization line by line after finishing.

---

## Build

### One-shot (PowerShell, Windows)

```powershell
.\build.ps1
```

### Manual (Docker, any OS)

```bash
docker build -t eskf-lecture-builder .

docker run --rm -v "$(pwd):/workspace" eskf-lecture-builder \
  bash -c "cd /workspace && \
           xelatex -interaction=nonstopmode lecture_all_v2.tex && \
           xelatex -interaction=nonstopmode lecture_all_v2.tex && \
           xelatex -interaction=nonstopmode lecture_all_v2.tex"
```

XeLaTeX needs to run **3 times** — first for content, second for
cross-references, third to fix PDF outlines (`.out` file).

---

## Key references

- **Solà**, *A micro Lie theory for state estimation in robotics*, arXiv:1812.01537 (2018)
- **Solà**, *Quaternion kinematics for the error-state Kalman filter*, arXiv:1711.02508 (2017)
- **Forster et al.**, *On-manifold preintegration for real-time visual–inertial odometry*, IEEE TRO (2017)
- **Bell & Cathey**, *The iterated Kalman filter update as a Gauss-Newton method*, IEEE TAC (1993)
- **Barfoot**, *State Estimation for Robotics* (2017)
- **Geneva et al.**, *OpenVINS: A research platform for visual-inertial estimation*, ICRA (2020)
- **Xu & Zhang**, *FAST-LIO2: Fast direct LiDAR-inertial odometry*, IEEE TRO (2022)
- **Mourikis & Roumeliotis**, *A multi-state constraint Kalman filter for vision-aided inertial navigation*, ICRA (2007)
- **Qin et al.**, *VINS-Mono: A robust and versatile monocular visual-inertial state estimator*, IEEE TRO (2018)
- **Shan et al.**, *LIO-SAM: Tightly-coupled lidar inertial odometry via smoothing and mapping*, IROS (2020)

---

## Course design notes

- **Convention**: Hamilton quaternion $(q_w, q_x, q_y, q_z)$, right perturbation
  $\boldsymbol{R} = \hat{\boldsymbol{R}}\\,\mathrm{Exp}(\delta\boldsymbol{\phi})$, OpenVINS state order
  $[\delta\boldsymbol{\phi},\\ \delta\boldsymbol{p},\\ \delta\boldsymbol{v},\\ \delta\boldsymbol{b}_g,\\ \delta\boldsymbol{b}_a]$.
- **OpenVINS uses JPL convention $(q_x, q_y, q_z, q_w)$** — the difference
  is flagged at first appearance.
- **Noise sign convention**: $\boldsymbol{\omega}_m = \boldsymbol{\omega} + \boldsymbol{b}_g + \boldsymbol{n}_g$
  (additive). $B_k$ has explicit minus signs as a result; covariance
  propagation is unaffected.

---

## License

Course material is provided as-is for educational use.
Cited code repositories retain their original licenses
(GPLv3 for OpenVINS, FAST-LIO; BSD/Apache for others — check upstream).

---

*Authored at APRL · DGIST. Built with Claude Code.*
