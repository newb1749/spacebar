# spacebar
## Spring MVC 기반 공간 렌탈, 예약 플랫폼
> PPT:
> https://drive.google.com/file/d/1t6AHIRF21UiMPsJeyUO_Fam_4Q-dvu_r/view?usp=drive_link <br />
> 관리자 깃허브 주소:
> https://github.com/JKH9797/spacebarManager <br />

## 🚨 브랜치 전략

### ✅ `main` 브랜치 규칙
- **절대 직접 작업 금지!**
- 모든 작업은 **별도 브랜치에서 진행 후 Pull Request(PR)** 를 통해 병합
- 병합 후 **기능 브랜치는 삭제**
- 다른 브랜치에서 작업 중이여도 남이 쓴 코드 건들기 X.
- ex) insertRoom이 마음에 안들면 insertRoom1 같은거 만들어서 작업하기
- 같은 파일에서 작업 중이면 구분되게 맨 밑에서 작업하기
---

## 🌱 브랜치 유형

### 1. 기능 브랜치 (Feature Branch)
- 이름 형식: `feature/<기능명>`
- 예시:
  - `feature/login-system`
  - `feature/user-management`
  - `feature/payment-integration`

### 2. 버그 수정 브랜치
- 이름 형식: `fix/`
- 예시:
  - `fix/login-error`
  - `fix/critical-security-patch`
  - `fix/navbar-responsive`

---

## 📌 Git 사용 규칙

### 1. `.gitignore` 설정
- `upload/`, `log/`, `.settings/`, `.classpath`, `.idea/` 등은 Git에 올리지 않음
- **이미지, 개인 환경 설정 파일 등은 무조건 제외**

### 2. `Pull First, Push Later` 원칙
- 작업 전 `pull` 먼저 → 충돌 방지
- 자주 `commit`하고 자주 `push`
- 작업 누적 방지 (한꺼번에 푸시 ❌)

### 3. 커밋 메시지 규칙
- `feature: 로그인 기능 추가`
- `fix: 비밀번호 검증 오류 수정`
- `refactor: 중복 코드 정리`

### 4. Pull Request(PR) 기반의 협업
- **PR 후 코드 리뷰** → 아침에 확인 권장
- 기능 단위 PR → 머지 후 브랜치 삭제

---

## ⚠️ 기능 브랜치 재사용의 위험

> 하나의 기능 브랜치를 계속 재활용하는 경우 발생하는 문제점:

### ❌ 잘못된 방식 예시
1. `feature/user-login` 브랜치 생성 → 작업 후 PR
2. **브랜치 삭제하지 않고**, 다음 작업도 같은 브랜치에서 진행
3. 반복적으로 PR → `main` 머지

### 🧨 문제점
- **이력 혼란**: 어떤 커밋이 어떤 기능인지 파악 어려움
- **충돌 증가**: 오래된 브랜치는 `main`과 점점 멀어져 충돌 빈도 증가
- **리뷰 어려움**: 과거 커밋까지 PR에 포함되어 리뷰 복잡
- **롤백 곤란**: 기능별로 롤백이 어렵거나 불가능

### ✅ 권장 방식
- 기능 하나 완료 후 머지 → **해당 브랜치 삭제**
- 다음 기능은 **새로운 브랜치 생성**해서 작업

---

## 📎 요약

- 모든 작업은 **기능 단위 브랜치**로 분리해서 관리
- **main 브랜치는 건들지 말 것!**
- 커밋 메시지, PR, Git 규칙을 철저히 지킬 것
- 브랜치는 **기능별 생성 후 병합하면 삭제**

---

