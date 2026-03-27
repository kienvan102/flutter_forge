# Commit Convention

This repo uses a structured commit format so the git history reads as a clear learning log.

## Format

```
<type>(<scope>): <short description>
```

## Types

| Type | When to use |
|------|-------------|
| `tour` | Completed one or more dart_tour exercises |
| `feat` | Implemented something new in SecureVault |
| `fix` | Fixed a bug in SecureVault |
| `refactor` | Rewrote something already implemented — cleaner/more idiomatic approach |
| `test` | Added or fixed tests |
| `study` | Added personal notes or annotations to docs |
| `chore` | Dependencies, config, build tooling (pubspec, build_runner, CI) |
| `experiment` | Trying something out that may or may not stay |
| `revert` | Rolling back a failed experiment |
| `milestone` | Full module complete, project in clean runnable state |

## Scopes

For `tour`: the exercise folder name — `01_basics`, `05_streams`, etc.

For `feat` / `fix` / `refactor` / `test`: the feature area — `vault/auth`, `vault/crypto`,
`vault/navigation`, `vault/db`, `vault/ui`, etc.

For `chore`: `deps`, `build`, `ci`, `config`.

For `milestone`: `module-01` through `module-08`.

## Examples

```bash
# Dart tour
git commit -m "tour(01_basics): complete all 4 exercises"
git commit -m "tour(05_streams): complete broadcast stream exercise"
git commit -m "tour(06_oop): complete — used switch expression for sealed classes"

# SecureVault features
git commit -m "feat(vault/shell): app shell with adaptive navigation"
git commit -m "feat(vault/state): wire VaultNotifier and filteredVaultItems with Riverpod"
git commit -m "feat(vault/navigation): GoRouter with auth redirect guard"
git commit -m "feat(vault/db): replace in-memory repo with Drift SQLite"
git commit -m "feat(vault/crypto): AES-256-GCM encryption with PBKDF2 key derivation"
git commit -m "feat(vault/auth): biometric + PIN unlock, auto-lock on background"
git commit -m "feat(vault/generator): cryptographically random password generator"
git commit -m "feat(vault/cross-platform): master-detail layout and desktop keyboard shortcuts"

# Fixes
git commit -m "fix(vault/form): password field not clearing after save"
git commit -m "fix(vault/list): search not resetting when query is cleared"

# Refactors (after learning a better way)
git commit -m "refactor(vault/list): replace setState with Riverpod filteredItemsProvider"
git commit -m "refactor(vault/item): replace hand-written model with Freezed"

# Tests
git commit -m "test(vault_crypto): encrypt/decrypt roundtrip and wrong key assertion"
git commit -m "test(vault_item_card): widget tests for display, tap, and favorite"

# Personal study notes
git commit -m "study(02_state_management): notes comparing Riverpod to Spring DI"
git commit -m "study(05_security): OWASP M10 notes and how AES-GCM fixes it"

# Deps and tooling
git commit -m "chore(deps): add drift, freezed, riverpod, go_router"
git commit -m "chore(build): regenerate build_runner after adding Freezed model"
git commit -m "chore(ci): add GitHub Actions workflow for all platforms"

# Experiments
git commit -m "experiment(animations): hero transition between list and detail screen"
git commit -m "revert(animations): hero transition breaks on web, removing for now"

# Module milestones — project is clean and runnable
git commit -m "milestone(module-01): app shell and all screens rendering correctly"
git commit -m "milestone(module-04): full CRUD persisted to SQLite, Freezed models"
git commit -m "milestone(module-05): vault fully encrypted, biometric auth, auto-lock"
git commit -m "milestone(module-08): CI/CD building all 6 platforms on every push"
```

## Tips

- Commit after **each exercise**, not all at once — the history shows your actual pace
- Commit at each `milestone` with the project in a **runnable state** — so you can always check out any milestone and have something that works
- Use `experiment` freely — it signals "I'm exploring" and makes `revert` commits make sense
- Keep descriptions short (under 72 chars) — details go in the commit body if needed
