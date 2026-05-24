# Research: Stack

**Milestone:** v2.1 Persistence & Sharing  
**Date:** 2026-05-24

## Recommended Additions

- `firebase_core` for app initialization and generated platform options
- `firebase_auth` for email/password and federated auth flows
- `cloud_firestore` for saved-path documents and shared snapshot documents
- `google_sign_in` if Google sign-in is enabled on mobile
- `sign_in_with_apple` if Apple sign-in is enabled

## Why This Fits The Existing App

- The current app already runs fully client-side and has no backend tier.
- Firebase Auth plus Firestore preserves the existing $0-backend direction.
- FlutterFire supports the existing Flutter stack and can be initialized early in `main.dart`.
- The current `GetIt` + use case architecture can absorb auth and persistence modules cleanly.

## Constraints And Watchouts

- Firebase Dynamic Links are deprecated for new projects and shut down on **August 25, 2025**. Sharing should use standard deep links instead of Dynamic Links.
- Firestore auto-generated IDs are not ordered; saved paths should store a creation timestamp if list ordering matters.
- Firestore security rules should rely on `request.auth.uid` for owner-scoped documents.
- Apple sign-in has extra platform setup requirements and should be treated as first-class configuration work, not an afterthought.

## Suggested Testing Stack

- Firebase Emulator Suite for auth and Firestore flows during local development and tests
- Existing widget/BLoC testing patterns extended with repository fakes for auth, saved paths, and deep-link entry

## Source Notes

- Firebase Flutter setup: https://firebase.google.com/docs/flutter/setup
- Firebase Auth on Flutter: https://firebase.google.com/docs/auth/flutter/start
- Firestore add/write patterns: https://firebase.google.com/docs/firestore/manage-data/add-data
- Firestore security rules: https://firebase.google.com/docs/firestore/security/get-started
- Firebase Dynamic Links deprecation FAQ: https://firebase.google.com/docs/dynamic-links/use-cases/user-to-user
