# Contributing Guidelines for Cipher-X 🛡️

Thank you for contributing to **Cipher-X**, developed by **Team Decrypters**. To maintain high engineering standards, zero-cost compatibility, and rapid 10-day delivery, all contributors must strictly adhere to these guidelines.

---

## 👥 Team Ownership & Responsibilities

| Contributor | Area of Ownership | Branch Prefix | Key Responsibilities |
| :--- | :--- | :--- | :--- |
| **Hardik** | Core Architecture, Firebase, Auth, Rules, Verification | `feature/core-*`, `feature/auth-*` | Data models, security rules, attendance verification engine, CI/CD, integration |
| **Gauri** | Guard Mobile App & Guard Workflows | `feature/guard-*` | Today's shift UI, Check-In/Out screen, QR scanner, incident creation, profile UI |
| **Avadhut** | Admin Dashboard & Operations UI | `feature/admin-*` | Guard management, site management, shift scheduler, live coverage dashboard, alerts UI |

---

## 🌿 Git Branching & Workflow Strategy

We enforce a modified GitHub Flow with trunk-based integration principles:

1. **`main` Branch**:
   - The production-ready, stable code branch.
   - Protected: Direct pushes are **strictly forbidden**.
   - Requires pull request approval before merging.

2. **Feature Branches**:
   - All work must occur on dedicated feature branches named with the following convention:
     ```text
     feature/<team-member>-<short-description>
     fix/<team-member>-<short-description>
     docs/<short-description>
     ```
   - Examples:
     - `feature/hardik-auth-rbac`
     - `feature/gauri-qr-scanner`
     - `feature/avadhut-site-management`

---

## 📝 Commit Message Standard

We use [Conventional Commits](https://www.conventionalcommits.org/). Commit messages must follow this pattern:

```text
<type>(<scope>): <short description>
```

### Allowed Types:
- `feat`: A new feature implementation
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Formatting, missing semi-colons, no code change
- `refactor`: Refactoring production code without changing functionality
- `test`: Adding or updating tests
- `chore`: Updating build tasks, dependencies, gitignore

### Examples:
```bash
git commit -m "feat(auth): integrate firebase authentication and role routing"
git commit -m "fix(attendance): resolve geofence distance precision bug"
git commit -m "docs(schema): update firestore index specifications"
```

---

## 🔁 Pull Request & Code Review Checklist

Before creating a Pull Request (PR) to `main`, ensure the following criteria are met:

### PR Template Checklist:
1. [ ] **Branch updated**: Rebased on latest `main`.
2. [ ] **Flutter Analyzed**: Clean output from `flutter analyze` without errors or warnings.
3. [ ] **Code Formatting**: Formatted using `dart format .`.
4. [ ] **Free Tier Verified**: No paid Firebase features (e.g. mandatory Cloud Functions) introduced.
5. [ ] **Security Checked**: No exposed API keys, secret tokens, or vulnerable Security Rules.
6. [ ] **Tested Locally**: Ran using Firebase Emulators suite (`firebase emulators:start`).
7. [ ] **Reviewers Assigned**: At least one other member of Team Decrypters has reviewed and approved the PR.

---

## 🎨 Code Style & Engineering Guidelines

### 1. Feature-First Architecture
Keep code organized under `lib/features/<feature_name>/` containing `data/`, `domain/`, and `presentation/` layers where appropriate.

### 2. State Management Rules
- Use **Riverpod** exclusively for state management.
- Do NOT mix Provider, Bloc, or GetX into the codebase.
- Prefer `AsyncNotifierProvider` for asynchronous state loading.

### 3. Data Immutability
- Use `@freezed` for all domain data models and DTOs.
- Always run `dart run build_runner build` after altering model files.

### 4. Zero Hardcoded Strings or Static Pixels
- Store app constants in `lib/core/constants/`.
- Use dynamic theme extensions for colors and layout boundaries.

---

## 🧪 Local Testing Workflow

1. Start Firebase Emulators:
   ```bash
   firebase emulators:start --only auth,firestore,storage
   ```
2. Run unit and widget tests:
   ```bash
   flutter test
   ```
3. Format code:
   ```bash
   dart format .
   ```

Thank you for building **Cipher-X** with excellence!
