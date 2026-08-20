# Cipher-X — Git Workflow & Branch Strategy Specification 🔀

> **Application Name**: Cipher-X  
> **Founding Team**: Team Decrypters (Hardik, Gauri, Avadhut)  
> **Document Version**: 1.0.0  

---

## 1. Branch Topology & Strategy

Cipher-X enforces a strict trunk-based git workflow using short-lived feature branches and a single protected production branch (`main`).

```text
       feature/hardik-auth-rbac
          ┌──────────────────────┐
          │                      │
───(main)─┴──────────────────────┴─(PR Review & Merge)───► [Production Stable]
          │                      │
          └──────────────────────┘
       feature/gauri-qr-scanner
```

### Branch Rules:
1. **`main`**: The canonical production branch.
   - **PROTECTED**: No developer (including Tech Lead) may push directly to `main`.
   - All code merges require an approved Pull Request (PR) with passing CI checks.
2. **Feature Branches**: Named according to developer ownership and feature description:
   - `feature/hardik-<feature_name>`
   - `feature/gauri-<feature_name>`
   - `feature/avadhut-<feature_name>`
   - `fix/<developer>-<bug_description>`
   - `docs/<description>`

---

## 2. Conventional Commit Specification

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) format to auto-generate changelogs and maintain readable git history.

```text
<type>(<scope>): <subject>
```

### Scope Examples:
- `auth`: Authentication & role routing
- `sites`: Site management & geofencing
- `shifts`: Roster scheduling
- `attendance`: Multi-factor verification engine
- `incidents`: Incident reporting & evidence storage
- `alerts`: Alert system & push notifications
- `audit`: Audit logging subsystem
- `rules`: Security rules configuration

### Example Commits:
```bash
git commit -m "feat(attendance): implement haversine distance calculation in verification engine"
git commit -m "fix(shifts): resolve overlap validation bug during shift assignment"
git commit -m "docs(schema): document auditLogs collection schema"
git commit -m "chore(deps): update flutter_riverpod to v2.5.1"
```

---

## 3. Pull Request (PR) Protocol

### Step 1: Pre-PR Self Audit
Before opening a PR to `main`, run local validation commands:

```bash
# 1. Format code
dart format .

# 2. Run static analysis
flutter analyze

# 3. Execute unit tests
flutter test

# 4. Verify build codegen
dart run build_runner build --delete-conflicting-outputs
```

### Step 2: Open Pull Request
Use the standard Cipher-X PR Template:

```markdown
## Description
Brief summary of changes introduced in this PR.

## Closes Issue
Closes #<issue_number>

## Type of Change
- [ ] Feature (`feat`)
- [ ] Bug Fix (`fix`)
- [ ] Refactor (`refactor`)
- [ ] Documentation (`docs`)

## Code Review Checklist
- [ ] Code formatted with `dart format .`
- [ ] Clean output from `flutter analyze`
- [ ] Verified on Firebase Emulator Suite (`firebase emulators:start`)
- [ ] No paid Firebase Blaze dependencies introduced
- [ ] Security rules validated for multi-tenant isolation

## Screenshots / Demo (UI PRs)
(Attach GIF or image here)
```

### Step 3: Peer Review & Merge
- At least **1 mandatory review approval** from another member of Team Decrypters.
- Merges must use **Squash and Merge** to maintain a clean linear commit log on `main`.
