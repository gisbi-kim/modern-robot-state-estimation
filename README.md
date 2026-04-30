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

## 누가 들어야 하나 — 타겟 독자 & 난이도

**한 줄 요약**: 대학원 1학년 \~ 박사 1년차 SLAM / VIO 입문자.
학부 4학년에게는 상당히 무거운 자료, 현업 SLAM 엔지니어에게는
``체계적 정리본''으로 적합.

**체감 난이도**: ⭐⭐⭐⭐ (5점 만점)

세 축으로 보는 근거:

### 1. 수학 prerequisite이 꽤 셉니다

2회차에서 SO(3), Exp/Log map, Right Jacobian $J_r$, BCH, Adjoint를 56장에
걸쳐 다룹니다. 일반 학부 SLAM 강의에서는 거의 생략하거나 ``그냥 회전행렬''로
퉁치는 부분이에요. Barfoot 책이나 Solà의 *micro Lie theory* 노트를 직접
따라가는 깊이라, 다음에 익숙해야 따라갈 수 있습니다:

- 다변수 미적분 (편미분, 연쇄 법칙)
- 선형대수 (행렬 곱/역행렬/고유값)
- 확률론 (가우시안 분포 곱)
- 행렬 미분 (Jacobian, Hessian)

학부 3\~4학년 수준에서는 2회차에서 이미 한 번 휘청할 수 있습니다.

### 2. 이론 → 실제 오픈소스 코드 매핑이 핵심 차별점

README에 명시했듯 ``OpenVINS `Propagator.cpp`, FAST-LIO2 IEKF, GTSAM
`ImuFactor`를 한 줄씩 왜 이렇게 짰는지 설명할 수 있게'' 만드는 게 목표 —
\*Probabilistic Robotics\* (Thrun) 같은 정통 교재보다 \*\*한 단계 위의
실전 깊이\*\*입니다. 다음과 같은 \*\*보통 논문 구현하면서 며칠씩
헤매야 알게 되는 함정\*\*들까지 짚어줍니다:

- JPL vs Hamilton quaternion convention 차이
- OpenVINS의 상태 순서 $[\delta\boldsymbol{\phi}, \delta\boldsymbol{p}, \delta\boldsymbol{v}, \delta\boldsymbol{b}_g, \delta\boldsymbol{b}_a]$
- $B_k Q_d B_k^\top$의 부호 소거
- $J_r$ 소각 근사가 실제 IMU 200 Hz에서 충분한 이유
- ESKF의 ``Inject \& Reset'' 후 공분산 보정에서 등장하는 Reset Jacobian

### 3. 후반부(7\~9회차)는 본격 연구자 수준

관측가능성, FEJ (First-Estimate Jacobian), Schur complement,
Marginalization, MSCKF의 null-space projection (QR), iSAM2, ikd-tree —
전부 ICRA / IROS / TRO 논문 읽을 때 등장하는 개념들. **7회차 한 회에
76장**이 들어간 건 사실상 mini-textbook입니다.

### 누가 들으면 잘 맞을지

|   | 누구 |
|---|---|
| ✅ **딱 맞는 사람** | SLAM 랩 박사과정 1년차, ESKF / VIO 처음 구현해보는 석사 후반 / 박사 초반, EKF는 알지만 manifold-based estimation을 정리하고 싶은 현업 엔지니어 |
| ⚠️ **버거울 사람** | SO(3) Lie group을 처음 보는 학부생 — 2회차에서 별도 보강 필요 (Solà 2018 또는 Barfoot Ch.7) |
| 😴 **너무 쉬울 사람** | 이미 OpenVINS / FAST-LIO2 코드를 읽고 수정해본 시니어 — 이 자료는 \*그 단계로 올라가는 사다리\*이지, 그 위 단계는 아닙니다 |

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
