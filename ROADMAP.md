# Roadmap: SonicNomad

- **[Milestone 1: Foundation & Canvas](milestones/v1-ROADMAP.md)** - Completed 2026-03-30. 100-node 60fps canvas + CI/CD.
- **[Milestone 2: Data Exploration](milestones/v2.0-ROADMAP.md)** - Completed 2026-04-04. Live MB/Wikidata discovery.

## Milestone 3: Persistence & Sharing (Phase 5-7)
**Goal:** Preserve zero-friction anonymous exploration while adding account-backed saved-path CRUD and link sharing.

### Phase 5: Firebase Bootstrap & Authentication
**Goal:** Connect the app to Firebase and introduce guest-safe authentication flows without breaking anonymous canvas access.

**Requirements:** AUTH-01, AUTH-02, AUTH-03, AUTH-04, AUTH-05

**Success criteria:**
1. App initializes Firebase correctly in the existing Flutter startup path.
2. Guest users can still reach and use the canvas without creating an account.
3. Email/password auth and the milestone's chosen social providers work end-to-end on mobile.
4. Signed-in sessions persist across app restarts and sign-out returns the app to guest mode.
5. Tests or emulator-backed verification cover auth-state transitions and app startup wiring.

### Phase 6: Saved Path Persistence
**Goal:** Let authenticated users save, restore, and manage discovery paths as owner-scoped Firestore records.

**Requirements:** PATH-01, PATH-02, PATH-03, PATH-04, PATH-05, PATH-06, PATH-07

**Success criteria:**
1. Current graph state can be serialized into a stable saved-path payload with viewport metadata.
2. Signed-in users can save a path, see it in a dashboard/list, and reopen it into the canvas.
3. Rename, duplicate, and delete operations work only on the owner's saved paths.
4. Firestore document shape and repository boundaries stay cleanly separated from presentation state.
5. Tests verify repository behavior and at least one end-to-end restore flow.

### Phase 7: Sharing & Deep Links
**Goal:** Make saved paths shareable through standard mobile deep links and support anonymous open plus authenticated copy-save.

**Requirements:** SHARE-01, SHARE-02, SHARE-03, SHARE-04, SHARE-05

**Success criteria:**
1. User can generate a shareable link for a saved discovery path without using Firebase Dynamic Links.
2. Opening a valid link on iOS or Android loads the shared path into the app.
3. Recipients can explore a shared path without signing in.
4. Authenticated recipients can save an editable personal copy of a shared path.
5. Firestore rules enforce owner-only mutation while allowing the intended shared read path.

## Milestone 4: Polish & Deployment (Phase 8)
**Goal:** High-fidelity visuals and App Store readiness.

### Phase 8: Final Polish
- [ ] Implement multi-layered shadows and glow effects.
- [ ] Add subtle noise texture to background.
- [ ] Performance audit for low-end devices.
- [ ] Prepare deployment metadata.

---
*Last updated: 2026-05-24 after creating Milestone v2.1 roadmap*
