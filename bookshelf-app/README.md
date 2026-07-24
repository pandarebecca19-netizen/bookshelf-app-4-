# 나의 책장

Next.js + Supabase로 만든 실제 웹 서비스예요. 이메일로 회원가입해서
로그인하면 "OO님의 책장"이 뜨고, 책장(책등 보기) / 표지 모아보기
두 탭에서 자신의 책 기록을 볼 수 있어요.

## 1. Supabase 프로젝트 준비

1. https://supabase.com 에서 무료 프로젝트를 하나 만들어요.
2. 좌측 메뉴 **SQL Editor**에서 `supabase/schema.sql` 파일 내용을
   그대로 붙여넣고 실행해요. (`books` 테이블 + 권한 정책이 만들어져요)
3. 좌측 메뉴 **Storage** → **New bucket** →
   - 이름: `covers`
   - **Public bucket**: 켜기
   로 버킷을 하나 만들어요. (표지 이미지 저장용)
4. **Authentication → Providers**에서 Email이 켜져 있는지 확인해요.
   테스트를 빠르게 하고 싶다면 **Authentication → Settings**에서
   "Confirm email"을 잠시 꺼둬도 괜찮아요 (실제 서비스에서는 켜두는 걸 추천해요).
5. **Project Settings → API**에서 아래 두 값을 복사해요.
   - Project URL
   - anon public key

## 2. 로컬에서 실행하기

```bash
npm install
cp .env.local.example .env.local
# .env.local 파일을 열어서 위에서 복사한 값 두 개를 붙여넣기
npm run dev
```

http://localhost:3000 접속 → 회원가입 → 로그인 → 책장 시작!

## 3. 실제 배포하기 (Vercel 추천)

1. 이 폴더를 GitHub 저장소로 올려요.
2. https://vercel.com 에서 "New Project" → 방금 만든 저장소 선택.
3. **Environment Variables**에 `.env.local`에 넣었던 두 값을 똑같이
   추가해요 (`NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`).
4. Deploy 누르면 몇 분 안에 실제 주소(`https://xxx.vercel.app`)로
   서비스가 열려요. 이후로는 깃허브에 푸시할 때마다 자동으로 재배포돼요.

## 폴더 구조

```
app/
  page.js            로그인 여부에 따라 /login 또는 /shelf 로 이동
  login/page.js       로그인 / 회원가입 (이름 입력 포함)
  shelf/page.js        메인 화면: 헤더, 탭, 책장/표지 모아보기, 책 등록·수정
lib/
  supabaseClient.js    Supabase 클라이언트 설정
  constants.js         색깔 팔레트, 상태 라벨, 날짜/색상 계산 로직
supabase/
  schema.sql           DB 테이블 + 파일 업로드 권한 정책
```

## 이미 앱을 쓰고 계셨다면 (마이그레이션)

이전 버전에서 이미 Supabase 프로젝트를 만들어 쓰고 계셨다면, `supabase/migration_genre.sql`
파일 내용을 SQL Editor에 붙여넣고 실행해주세요. 장르 기능에 필요한 컬럼이 추가되고,
더 이상 쓰지 않는 띠(리본) 컬럼은 정리돼요.

## 참고

- 표지 이미지는 파일로 업로드하면 Supabase Storage의 `covers` 버킷에
  저장되고, 공개 URL이 책 정보에 함께 저장돼요.
- 책 색깔은 파스텔 9색 중에서 고를 수 있어요.
- 장르는 직접 입력하고 색을 고르면, 같은 장르를 다시 쓸 때 자동으로 같은 색이 적용돼요.
- 연도 필터(책장 탭)와 연도별 탭은 "다 읽었어요" 상태이면서 완독일이 있는 책만 집계해요.
- 표지 모아보기 탭은 완독한 책만, 완독일이 최근인 순서로 보여줘요.
