# Research: Architecture

**Milestone:** v2.1 Persistence & Sharing  
**Date:** 2026-05-24

## Proposed Integration Shape

- Add a dedicated `auth` feature with repository, use cases, and presentation state for sign-up, sign-in, sign-out, and session observation.
- Add a `saved_paths` feature that serializes the current canvas state into DTOs separate from the existing domain graph models.
- Add a `sharing` feature that resolves incoming deep links to shared snapshot records and hands them to the canvas loader.

## Firestore Shape

The following is an implementation inference from the milestone goals and Firebase rules guidance:

- `users/{uid}/saved_paths/{pathId}`
  - owner-scoped editable records
  - includes title, serialized graph payload, viewport metadata, created/updated timestamps
- `shared_paths/{shareId}`
  - read-only public snapshot records used by links
  - contains the serialized graph payload needed to open the shared experience
  - excludes account-only metadata that should stay private

This split keeps owner CRUD rules simple while allowing anonymous reads for shared paths.

## Integration Points In The Current App

- `main.dart` should initialize Firebase before dependency injection consumers resolve auth or Firestore services.
- `app/di.dart` should register Firebase-backed data sources, repositories, and feature BLoCs/use cases alongside existing MusicBrainz and Wikidata modules.
- `CanvasBloc` or an adjacent orchestration layer will need an input for loading a serialized path back into the current graph state.
- Deep-link handling should target a specific route or app-entry coordinator instead of pushing ad hoc navigation directly into the canvas.

## Suggested Build Order

1. Firebase bootstrap and auth/session wiring
2. Saved-path serialization and owner CRUD
3. Shared snapshot creation and incoming link handling

## Source Notes

- Firebase Auth session behavior on Flutter: https://firebase.google.com/docs/auth/flutter/start
- Firestore rules and auth-scoped data: https://firebase.google.com/docs/firestore/security/rules-query
- Flutter navigation guidance for deep links: https://docs.flutter.dev/ui/navigation
