# Modern Robot State Estimation

**ESKF**(Error-State Kalman Filter)를 중심으로 현대 로봇 state estimation을
처음부터 끝까지 다루는 **10회차 통합 Beamer 강의자료**.

> **이 코스가 도달하는 한 줄:**
>
> $$ \text{ESKF} \subset \text{IEKF} \equiv \text{Gauss-Newton on MAP} \subset \text{Factor Graph} $$
>
> *— Bell & Cathey, IEEE TAC 1993.*
>
> 필터와 스무더는 \*다른 알고리즘\*이 아니다.
> **같은 MAP cost를 푸는 서로 다른 스케줄**일 뿐이다.

---

## 무엇이 들어 있나

- `lecture_all_v2.tex` — 10회차 통합 Beamer 소스 (약 12,000 줄, 437 frames)
- `preamble.tex` — Beamer + metropolis + 한국어 폰트(Noto CJK KR) preamble
- `Dockerfile` — XeLaTeX + 한국어 폰트 빌드 환경
- `build.ps1` — PowerShell 빌드 헬퍼
- `output/lecture_all_v2.pdf` — 사전 빌드된 PDF (약 917쪽)

---

## 회차별 구성

| 회차 | 주제 | 슬라이드 수 |
|---|---|---|
| 0 | 2025 필드 지형도 (filter / smoother 생태계) | 9 |
| 1 | Bayes filter, Gaussian | 30 |
| 2 | SO(3) 입문 + Jacobians ($J_r$, BCH, Adjoint) | 56 |
| 3 | 선형 Kalman Filter (5줄 유도, Joseph form) | 34 |
| 4 | **ESKF 핵심** (15D 오차 상태, F 행렬, Inject & Reset) | 22 |
| 5 | IMU 물리 + ESKF Predict + Preintegration (Forster 2017) | 57 |
| 6 | 멀티센서 Update (GPS / wheel / camera H 행렬) | 16 |
| 7 | 관측가능성 + Factor Graph + MAP + Marginalization | 76 |
| 8 | MSCKF + Visual-Inertial Odometry (OpenVINS) | 62 |
| 9 | LiDAR — FAST-LIO / FAST-LIO2 / FAST-LIVO2 | 72 |

이 코스의 목표는 매 회차가 **실제 오픈소스 코드와 직접 매핑**되는 것 —
수료 후에 OpenVINS `Propagator.cpp`, FAST-LIO2의 IEKF, GTSAM `ImuFactor`,
VINS-Mono sliding-window 코드를 한 줄씩 ``왜 이렇게 짰는지'' 설명할 수 있도록 설계됨.

---

## 빌드 방법

### 한 줄 (PowerShell, Windows)

```powershell
.\build.ps1
```

### 직접 (Docker, 모든 OS)

```bash
docker build -t eskf-lecture-builder .

docker run --rm -v "$(pwd):/workspace" eskf-lecture-builder \
  bash -c "cd /workspace && \
           xelatex -interaction=nonstopmode lecture_all_v2.tex && \
           xelatex -interaction=nonstopmode lecture_all_v2.tex && \
           xelatex -interaction=nonstopmode lecture_all_v2.tex"
```

XeLaTeX는 **3번** 돌려야 함 — 1번째는 본문, 2번째는 cross-reference,
3번째는 PDF outline (`.out` 파일) 정정.

---

## 핵심 참고문헌

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

## 코스 설계 메모

- **표기 컨벤션**: Hamilton 쿼터니언 $(q_w, q_x, q_y, q_z)$, right perturbation
  $\boldsymbol{R} = \hat{\boldsymbol{R}}\\,\mathrm{Exp}(\delta\boldsymbol{\phi})$,
  OpenVINS 상태 순서
  $[\delta\boldsymbol{\phi},\\ \delta\boldsymbol{p},\\ \delta\boldsymbol{v},\\ \delta\boldsymbol{b}_g,\\ \delta\boldsymbol{b}_a]$.
- **OpenVINS는 JPL 컨벤션 $(q_x, q_y, q_z, q_w)$** 사용 — 두 컨벤션의
  차이는 처음 등장하는 슬라이드에서 명시.
- **노이즈 부호 컨벤션**: $\boldsymbol{\omega}_m = \boldsymbol{\omega} + \boldsymbol{b}_g + \boldsymbol{n}_g$
  (additive). 그 결과 $B_k$ 행렬에 음의 부호가 명시적으로 등장.
  공분산 전파 $B_k Q_d B_k^\top$에서는 부호가 자동 소거되어 결과는 동일.

---

## 라이선스

강의자료는 \*\*교육 목적의 자유 사용\*\*으로 제공됨 (as-is).
인용한 코드 레포지토리는 \*\*각자의 원본 라이선스\*\*를 따름
(OpenVINS / FAST-LIO: GPLv3, GTSAM / Ceres / LIO-SAM: BSD/Apache — upstream 확인).

---

*APRL · DGIST · Modern Edition*
*Built with Claude Code.*
