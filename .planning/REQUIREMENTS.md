# Requirements: SonicNomad

**Defined:** 2026-05-24
**Milestone:** v2.1 Persistence & Sharing
**Core Value:** Users can visually explore how artists and genres connect and evolve on an interactive infinite canvas — spatial discovery, not list-based browsing.

## v2.1 Requirements

### Authentication

- [x] **AUTH-01**: User can launch and explore the canvas without creating an account.
- [x] **AUTH-02**: User can create an account with email and password.
- [x] **AUTH-03**: User can sign in with the milestone's configured social providers.
- [x] **AUTH-04**: Signed-in user session persists across app restarts on mobile until the user signs out.
- [ ] **AUTH-05**: Guest exploration is not persisted after the user leaves the app.

### Saved Paths

- [ ] **PATH-01**: Signed-in user can save the current discovery path as a named record.
- [ ] **PATH-02**: Saved path serialization includes enough graph and viewport state to restore the path faithfully.
- [ ] **PATH-03**: Signed-in user can view a list of their saved discovery paths.
- [ ] **PATH-04**: Signed-in user can reopen a saved discovery path into the canvas.
- [ ] **PATH-05**: Signed-in user can rename one of their saved discovery paths.
- [ ] **PATH-06**: Signed-in user can duplicate one of their saved discovery paths as a new editable record.
- [ ] **PATH-07**: Signed-in user can delete one of their saved discovery paths.

### Sharing

- [ ] **SHARE-01**: Signed-in user can generate a shareable link for one of their saved discovery paths.
- [ ] **SHARE-02**: Opening a valid shared link on iOS or Android loads the linked discovery path in the app.
- [ ] **SHARE-03**: Recipient can explore a shared discovery path without signing in.
- [ ] **SHARE-04**: Recipient can save a personal editable copy of a shared discovery path after authentication.
- [ ] **SHARE-05**: Firestore access rules restrict saved-path mutation to the owning user while still allowing the intended shared-path read flow.

## Future Requirements

### Persistence

- **PATH-08**: Guest user can recover an in-progress discovery path after leaving the app.
- **PATH-09**: User can organize saved paths into folders or collections.

### Sharing

- **SHARE-06**: Shared links support post-install deferred deep-link continuation.
- **SHARE-07**: Shared paths support collaborative editing or comments.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Local/offline drafts for guests | User explicitly wants guest sessions to disappear on exit in this milestone |
| Firebase Dynamic Links | Deprecated for new projects and shut down in 2025 |
| Cloud Functions link generation backend | Conflicts with the $0 backend constraint |
| Static image export sharing | Milestone is about serialized path sharing, not media export |
| Real-time collaborative graph editing | Higher complexity than single-owner CRUD plus link sharing |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| AUTH-01 | Phase 5 | Complete |
| AUTH-02 | Phase 5 | Complete |
| AUTH-03 | Phase 5 | Complete |
| AUTH-04 | Phase 5 | Complete |
| AUTH-05 | Phase 5 | Pending |
| PATH-01 | Phase 6 | Pending |
| PATH-02 | Phase 6 | Pending |
| PATH-03 | Phase 6 | Pending |
| PATH-04 | Phase 6 | Pending |
| PATH-05 | Phase 6 | Pending |
| PATH-06 | Phase 6 | Pending |
| PATH-07 | Phase 6 | Pending |
| SHARE-01 | Phase 7 | Pending |
| SHARE-02 | Phase 7 | Pending |
| SHARE-03 | Phase 7 | Pending |
| SHARE-04 | Phase 7 | Pending |
| SHARE-05 | Phase 7 | Pending |

**Coverage:**
- v2.1 requirements: 17 total
- Mapped to phases: 17
- Unmapped: 0

---
*Requirements defined: 2026-05-24*
*Last updated: 2026-05-24 after roadmap creation*
