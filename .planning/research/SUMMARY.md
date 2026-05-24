# Research Summary

**Milestone:** v2.1 Persistence & Sharing  
**Date:** 2026-05-24

## Stack Additions

- Add `firebase_core`, `firebase_auth`, and `cloud_firestore`.
- Add provider packages only for the social logins that remain committed for this milestone.
- Use the Firebase Emulator Suite for development and verification.

## Feature Table Stakes

- Guest exploration remains account-free and ephemeral.
- Signed-in users get saved-path CRUD.
- Shared links must open a serialized path on mobile and allow recipients to save their own copy.

## Architecture Direction

- Keep clean boundaries by introducing dedicated auth, saved-path, and sharing modules.
- Store owner-editable paths separately from public shared snapshots.
- Load deep links through a deliberate app-entry path, not by coupling link parsing into widget code.

## Watch Out For

- Do not use Firebase Dynamic Links; standard platform deep links are the viable path.
- Security rules and query shape need to be designed together.
- Social provider setup, especially Apple, is real milestone work.
