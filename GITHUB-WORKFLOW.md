# GitHub Workflow Guide
**تطبيق تعليم الأطفال العراقيين**

---

## Branch Strategy

```
main (protected, production-ready)
  └── develop (integration branch)
       ├── feature/backend-auth
       ├── feature/backend-lessons
       ├── feature/backend-progress
       ├── feature/frontend-home
       ├── feature/frontend-lesson-detail
       └── feature/frontend-progress
```

### Branch Rules:
- **`main`**: Production code only, protected (no direct push)
- **`develop`**: Integration branch, weekly merge to `main`
- **`feature/*`**: Feature branches, merge to `develop` after review

---

## Workflow Steps

### 1. Create Feature Branch

```bash
# Update develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/backend-auth
# or
git checkout -b feature/frontend-home
```

### 2. Work & Commit

```bash
# Make changes...

# Stage
git add .

# Commit with proper message
git commit -m "[backend] Add authentication endpoints"
# or
git commit -m "[frontend] Implement home screen UI"
```

### 3. Push to Remote

```bash
git push origin feature/backend-auth
```

### 4. Open Pull Request

1. Go to GitHub → Pull Requests → New
2. Base: `develop` ← Compare: `feature/backend-auth`
3. Fill PR template:
   - Description
   - Type of change
   - Checklist
   - Screenshots (للـ frontend)
4. Assign reviewer
5. Create PR

### 5. Code Review

**Reviewer:**
- Review code في GitHub
- Test locally:
  ```bash
  git fetch origin
  git checkout feature/backend-auth
  # Test...
  ```
- Comment أو Approve

**Developer:**
- Fix issues
- Push updates:
  ```bash
  git add .
  git commit -m "[backend] Fix reviewer comments"
  git push origin feature/backend-auth
  ```

### 6. Merge

بعد Approval:
```bash
# Merge via GitHub (Squash and merge)
# or locally:
git checkout develop
git pull origin develop
git merge feature/backend-auth
git push origin develop

# Delete feature branch
git branch -d feature/backend-auth
git push origin --delete feature/backend-auth
```

---

## Commit Message Format

### Template:
```
[scope] Short description (50 chars max)

Longer description if needed (wrap at 72 chars)
- Bullet points ok
- Explain what and why, not how

Fixes #123
```

### Scopes:
- `[backend]` — Backend code
- `[frontend]` — Frontend code
- `[database]` — Database changes
- `[docs]` — Documentation
- `[review]` — Code review fixes
- `[test]` — Tests
- `[config]` — Configuration

### Examples:
```
[backend] Add authentication endpoints

Implemented JWT-based auth with device_id.
- POST /auth/register
- POST /auth/login
- Token expiration: 7 days

Closes #5

---

[frontend] Implement home screen UI

Created home screen with 3 track cards.
- RTL support
- Cairo font
- Responsive layout

---

[database] Add indexes for performance

Added indexes on child_progress table:
- (child_id, status)
- (completed_at)

Expected query speedup: 3x

---

[review] Fix SQL injection vulnerability in lessons endpoint

Replaced string concatenation with SQLAlchemy ORM.

---

[docs] Update API documentation

Added examples for all endpoints in README.
```

---

## Pull Request Template

عند فتح PR، استخدم هذا Template:

```markdown
## Description
<!-- وصف مختصر للتغييرات -->
أضفت authentication endpoints للـ backend باستخدام JWT.

## Type of Change
- [x] Backend
- [ ] Frontend
- [ ] Database
- [ ] Documentation

## Changes Made
- أضفت `POST /auth/register`
- أضفت `POST /auth/login`
- أضفت JWT token generation
- أضفت unit tests

## Testing
- [x] Tests pass locally
- [x] Tested manually with Postman
- [x] Added unit tests (coverage: 85%)

## Checklist
- [x] Code follows style guidelines
- [x] Self-reviewed code
- [x] Commented complex code
- [x] Documentation updated
- [x] No new warnings

## Screenshots
<!-- للـ Frontend فقط -->
N/A

## Related Issues
Closes #5
```

---

## Code Review Checklist

### للـ Reviewer:

#### Backend:
- [ ] Code readable و clean
- [ ] Follows project structure
- [ ] No hardcoded values
- [ ] Error handling موجود
- [ ] Security checks (SQL injection, validation)
- [ ] Tests موجودة و تمر
- [ ] Documentation updated
- [ ] Performance ok (no N+1 queries)

#### Frontend:
- [ ] Code readable و clean
- [ ] Follows project structure
- [ ] UI matches design (إذا موجود)
- [ ] RTL works
- [ ] Responsive (different screen sizes)
- [ ] No hardcoded strings (استخدم i18n لاحقاً)
- [ ] State management correct
- [ ] No performance issues (jank, memory leaks)
- [ ] Tests موجودة و تمر

---

## Git Tips

### Useful Commands

```bash
# View status
git status

# View diff
git diff

# View commit history
git log --oneline

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Stash changes (temporary save)
git stash
git stash pop

# Update from develop while on feature branch
git checkout feature/my-feature
git fetch origin
git rebase origin/develop

# Resolve conflicts
# Edit files...
git add .
git rebase --continue
```

### Keep Commits Clean

```bash
# Squash multiple commits into one (interactive rebase)
git rebase -i HEAD~3

# In editor, change 'pick' to 'squash' for commits to merge
```

---

## Release Process (Future)

### Versioning: Semantic Versioning (semver)
- `v1.0.0` — Major.Minor.Patch
- `v1.1.0` — New features (backwards compatible)
- `v1.0.1` — Bug fixes

### Steps:
1. Merge `develop` → `main`
2. Tag release:
   ```bash
   git tag -a v1.0.0 -m "Release 1.0.0"
   git push origin v1.0.0
   ```
3. Create GitHub Release (with changelog)
4. Build & deploy

---

## GitHub Actions (Future)

### CI/CD Pipeline (نضيفها لاحقًا):

`.github/workflows/backend-ci.yml`:
```yaml
name: Backend CI

on:
  pull_request:
    paths:
      - 'backend/**'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - run: pip install -r backend/requirements.txt
      - run: pytest backend/tests/
```

`.github/workflows/frontend-ci.yml`:
```yaml
name: Flutter CI

on:
  pull_request:
    paths:
      - 'mobile/**'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.0'
      - run: flutter pub get
        working-directory: mobile
      - run: flutter test
        working-directory: mobile
```

---

## Best Practices

### 1. Commit Often
- Small, focused commits
- One logical change per commit
- لا تنتظر نهاية اليوم

### 2. Write Good Commit Messages
- Present tense: "Add feature" not "Added feature"
- Explain **why**, not **what** (الكود يشرح what)

### 3. Pull Before Push
```bash
git pull origin develop
# Resolve conflicts if any
git push origin feature/my-feature
```

### 4. Review Your Own Code First
قبل ما تفتح PR، راجع الكود بنفسك:
```bash
git diff develop...feature/my-feature
```

### 5. Keep PRs Small
- هدف: 200-400 سطر تغيير
- لو أكبر، قسّمها لـ PRs متعددة

### 6. Respond Quickly to Reviews
- رد خلال 24 ساعة
- لو مشغول، خلّي الفريق يعرف

---

## Common Issues

### Problem: Merge Conflicts

```bash
# Update from develop
git checkout feature/my-feature
git fetch origin
git merge origin/develop

# Conflicts appear...
# Edit conflicted files, resolve <<<<< ===== >>>>>
git add .
git commit -m "Resolve merge conflicts"
git push origin feature/my-feature
```

### Problem: Wrong Branch

```bash
# Committed to wrong branch
git log  # copy commit hash
git checkout correct-branch
git cherry-pick <commit-hash>
git checkout wrong-branch
git reset --hard HEAD~1
```

### Problem: Pushed Sensitive Data

1. **Don't panic** — لا تحذف Repo
2. Remove from history:
   ```bash
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch path/to/file" \
     --prune-empty --tag-name-filter cat -- --all
   git push origin --force --all
   ```
3. Rotate secrets (API keys, passwords)
4. Add to `.gitignore`

---

## Team Communication

### Daily Standups (WhatsApp):
**صباحاً (9 AM):**
```
👋 صباح الخير!
📅 اليوم راح أشتغل على:
- [ ] Task 1
- [ ] Task 2
```

**مساءً (6 PM):**
```
✅ اليوم خلصت:
- [x] Task 1
- [x] Task 2

🚧 قيد التنفيذ:
- [ ] Task 3 (50%)

❓ عوائق:
- لا توجد
```

### PR Notifications:
- Tag reviewer في PR
- Respond to comments خلال 24 ساعة

### Questions:
- WhatsApp للأسئلة السريعة
- GitHub Issues للمشاكل التقنية

---

## Resources

- **Git Docs:** https://git-scm.com/doc
- **GitHub Guides:** https://guides.github.com/
- **Git Cheat Sheet:** https://education.github.com/git-cheat-sheet-education.pdf

---

**Last Updated:** 19 March 2026  
**Team Size:** 4 (Architect, Backend, Frontend, Reviewer)  
**Sprint:** Week 1 of 6
