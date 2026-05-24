# Research: Pitfalls

**Milestone:** v2.1 Persistence & Sharing  
**Date:** 2026-05-24

## High-Risk Mistakes

### 1. Building on Firebase Dynamic Links

- This is a dead path for a new milestone.
- The service is deprecated and shut down on **2025-08-25**.
- Use Android App Links and Apple Universal Links instead.

### 2. Mixing Owner Data And Public Share Data

- If saved paths and shared snapshots are the same document shape with the same rules, it becomes easy to leak owner-only metadata or over-grant write access.
- Prefer separate owner-scoped saved documents and public read-only shared documents.

### 3. Serializing UI State Too Loosely

- Saving only nodes and edges may not be enough to produce a coherent restore experience.
- The payload likely needs viewport/camera metadata and stable entity identifiers.

### 4. Letting Rules And Queries Drift Apart

- Firestore queries must satisfy the same constraints enforced by security rules.
- Owner dashboards should query only owner-scoped collections keyed by `request.auth.uid`.

### 5. Underestimating Provider Setup

- Apple sign-in needs platform capabilities and external console setup.
- Social providers expand the test matrix across iOS and Android.

## Prevention

- Treat deep-link infrastructure as a distinct phase with explicit validation.
- Define DTOs for saved/shared path payloads rather than serializing presentation objects directly.
- Keep security rules in milestone scope, not as post-hoc hardening.
- Add emulator-backed test coverage for auth state and Firestore access patterns.

## Source Notes

- Firebase Dynamic Links deprecation FAQ: https://firebase.google.com/docs/dynamic-links/use-cases/user-to-user
- Firestore rules conditions: https://firebase.google.com/docs/firestore/security/rules-conditions
- Flutter deep-link validator: https://docs.flutter.dev/tools/devtools/deep-links
