# Git Workflow

Bu repository uchun default branch `dev`. Kod faqat pull request orqali
protected branchlarga kiradi.

## Branchlar

- `dev`: kundalik development va feature PRlar uchun default branch.
- `prod`: release candidate va production deployga tayyor holat.
- `main`: production snapshot va barqaror tarix.
- `feature/*`, `fix/*`, `chore/*`: ishchi branchlar.

## Merge Yo'nalishi

- Feature branchlar faqat `dev`ga PR qilinadi.
- Release promotion faqat `dev`dan `prod`ga PR orqali qilinadi.
- Production snapshot faqat `prod`dan `main`ga PR orqali qilinadi.
- `dev`, `prod`, `main`ga direct push qilinmaydi.
- Agentlar ham shu qoidaga bo'ysunadi: protected branchda lokal commit
  qoldirmaydi, scoped branch ochadi va PR orqali ishlaydi.

## PR Talablari

Har bir PRdan oldin local muhitda quyidagi tekshiruvlar bajariladi:

- `flutter analyze`
- `dart format --set-exit-if-changed .`
- kerakli unit/widget/BLoC testlar

GitHub Actions PR yoki protected branch push paytida avtomatik ishlamaydi.
`.github/workflows/flutter-ci.yml` faqat qo'lda `workflow_dispatch` orqali
ishga tushiriladi. Tekshiruvlar repositoryga push qilishdan oldin lokal
muhitda bajariladi.

PR merge bo'lishidan oldin:

- kamida 1 approval bo'lishi kerak;
- stale approval yangi commitdan keyin bekor qilinadi;
- barcha review conversationlar resolve qilinadi;
- branch base bilan up to date bo'ladi.

## Agent Ish Tartibi

Agent Git bilan ishlashdan oldin `AGENTS.md` va ushbu faylni o'qiydi.

- Ishni `dev`dan boshlaydi: `git fetch origin`, keyin `origin/dev`dan scoped
  branch yaratadi.
- Branch nomi ish turini bildiradi: `feature/*`, `fix/*`, yoki `chore/*`.
- Stage qilishdan oldin `git status --short` va `git diff` bilan faqat kerakli
  fayllar tanlanganini tekshiradi.
- Commit xabari qisqa, aniq va imperative bo'ladi.
- Protected branchlarga direct push qilmaydi.
- PR base default holatda `dev`; release uchun faqat `dev -> prod`, production
  snapshot uchun faqat `prod -> main`.
- Branch protection, collaborator, default branch yoki merge settings o'zgarishi
  faqat user aniq so'raganda qilinadi.
- User so'ramasa, admin/protection sozlamalari o'zgartirilmaydi.

## Merge Huquqi

Protected branchlarga merge/push huquqi faqat `Nomonjon0124` accountiga
beriladi. Boshqa contributorlar branch ochishi va PR yuborishi mumkin, lekin
`dev`, `prod`, `main` branchlariga kodni birlashtira olmaydi.

## Repo Sozlamalari

- Squash merge yoqilgan.
- Merge commit o'chirilgan.
- Rebase merge o'chirilgan.
- Auto-merge o'chirilgan.
- PR merge qilingandan keyin source branch avtomatik o'chiriladi.
- Protected branch deletion va force push o'chirilgan.

## Release Tartibi

1. Feature/fix PR `dev`ga merge qilinadi.
2. Release tayyor bo'lganda `dev -> prod` PR ochiladi.
3. Productionga chiqadigan commit tasdiqlanganda `prod -> main` PR ochiladi.
4. `prod` va `main` branchlar faqat promotion PR orqali yangilanadi.
