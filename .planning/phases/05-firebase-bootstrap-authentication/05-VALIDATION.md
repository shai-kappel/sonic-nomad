---
phase: 05
slug: firebase-bootstrap-authentication
status: approved
nyquist_compliant: true
wave_0_complete: true
created: 2026-05-24
---

# Phase 05 - Validation Strategy

> Reconstructed from execution artifacts and updated after retroactive Nyquist gap-filling.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Flutter `flutter_test` |
| **Config file** | `pubspec.yaml` |
| **Quick run command** | `flutter test --no-pub test/widget_test.dart test/features/auth/presentation/bloc/auth_bloc_test.dart test/features/auth/presentation/widgets/auth_entry_sheet_test.dart test/nyquist/phase_05_test.dart` |
| **Full suite command** | `flutter test --no-pub` |
| **Estimated runtime** | ~5 seconds |

---

## Sampling Rate

- **After every task commit:** Run `flutter test --no-pub test/widget_test.dart test/features/auth/presentation/bloc/auth_bloc_test.dart test/features/auth/presentation/widgets/auth_entry_sheet_test.dart test/nyquist/phase_05_test.dart`
- **After every plan wave:** Run `flutter test --no-pub`
- **Before `$gsd-verify-work`:** Full suite must be green
- **Max feedback latency:** 10 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 05-01-01 | 01 | 1 | AUTH-01, AUTH-03 | — | Firebase bootstraps before UI and provider policy is encoded in source | nyquist | `flutter test --no-pub test/nyquist/phase_05_test.dart` | ✅ | ✅ green |
| 05-01-02 | 01 | 1 | AUTH-01 | — | Guest launch remains available after Firebase wiring | widget | `flutter test --no-pub test/widget_test.dart` | ✅ | ✅ green |
| 05-02-01 | 02 | 2 | AUTH-02, AUTH-03 | — | Auth flows stay behind repository/use-case boundaries | nyquist | `flutter test --no-pub test/nyquist/phase_05_test.dart` | ✅ | ✅ green |
| 05-02-02 | 02 | 2 | AUTH-01, AUTH-04 | — | Auth state stream can restore a signed-in session and return to guest | bloc | `flutter test --no-pub test/features/auth/presentation/bloc/auth_bloc_test.dart` | ✅ | ✅ green |
| 05-02-03 | 02 | 2 | AUTH-02, AUTH-03, AUTH-04 | — | Email, social, and sign-out actions dispatch through AuthBloc | bloc | `flutter test --no-pub test/features/auth/presentation/bloc/auth_bloc_test.dart` | ✅ | ✅ green |
| 05-03-01 | 03 | 3 | AUTH-01, AUTH-03 | — | Auth entry UI stays non-blocking on canvas and hides unsupported providers | widget | `flutter test --no-pub test/features/auth/presentation/widgets/auth_entry_sheet_test.dart` | ✅ | ✅ green |
| 05-03-02 | 03 | 3 | AUTH-02, AUTH-03, AUTH-04 | — | Email sign-up, social sign-in, authenticated sheet, and sign-out affordances are exposed in UI | widget | `flutter test --no-pub test/features/auth/presentation/widgets/auth_entry_sheet_test.dart` | ✅ | ✅ green |
| 05-03-03 | 03 | 3 | AUTH-05 | — | Guest exploration remains ephemeral with no local persistence introduced | nyquist | `flutter test --no-pub test/nyquist/phase_05_test.dart` | ✅ | ✅ green |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements.

---

## Manual-Only Verifications

All phase behaviors have automated verification.

---

## Validation Audit 2026-05-24

| Metric | Count |
|--------|-------|
| Gaps found | 3 |
| Resolved | 3 |
| Escalated | 0 |

Resolved gaps:
- Added `AuthBloc` tests for sign-up dispatch, social sign-in dispatch, and authenticated-to-guest auth stream transitions.
- Added `AuthEntrySheet` tests for sign-up submission, Google dispatch, and platform-specific Apple visibility on Android/iOS.
- Reclassified `AUTH-02`, `AUTH-03`, and `AUTH-04` from partial to covered after the new tests passed.

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references
- [x] No watch-mode flags
- [x] Feedback latency < 10s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** approved 2026-05-24
