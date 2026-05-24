# SonicNomad

## What This Is

SonicNomad is a mobile-first, open-source application that visually maps the macro-evolution of music genres and interconnected relationships between artists. Users explore a 2D node-based infinite canvas, actively building and expanding a "connect-the-dots" view of music history instead of scrolling through vertical lists. The next milestone adds account-backed persistence and sharing without compromising anonymous exploration.

## Core Value

Users can visually explore how artists and genres connect and evolve on an interactive infinite canvas — spatial discovery, not list-based browsing.

## Current State

**Shipped:** 
- [Milestone 1: Foundation & Canvas](.planning/milestones/v1-ROADMAP.md) (v1.0)
- [Milestone 2: Data Exploration](.planning/milestones/v2.0-ROADMAP.md) (v2.0)
  - Live MusicBrainz & Wikidata SPARQL integration
  - Dynamic artist/genre relationship expansion
  - Map-based high-performance graph state
  - Clean architecture with domain-driven entities

## Current Milestone: v2.1 Persistence & Sharing

**Goal:** Keep exploration frictionless for guests while adding account-backed saved-path CRUD and sharing.

**Target features:**
- Anonymous users can explore the app without creating an account, and their session is discarded when they leave.
- Signed-in users can create, view, reopen, rename, duplicate, and delete saved discovery paths.
- Saved discovery paths are serialized to Firestore and can be shared by link.
- Recipients can open a shared path without signing in and save their own editable copy after authentication.
- Firebase Authentication remains in scope, including email/password and social login.

## Requirements

## Validated
- [x] Interactive infinite canvas (pan, zoom) with artist nodes and bezier curve edges (v1.0)
- [x] 60fps performance with 100+ nodes (v1.0)
- [x] Glassmorphic Nebula Ethereal aesthetic (v1.0)
- [x] Dynamic search for a seed artist with immediate network expansion (v2.0)
- [x] Genre evolution mapping showing macro-level genre relationships (v2.0)
- [x] Direct client-side API calls to MusicBrainz and Wikidata (v2.0)
- [x] Strict Clean Architecture boundaries between data and domain (v2.0)

### Active
- [ ] Guest exploration remains available with no account and no cross-session persistence
- [ ] Firebase Authentication unlocks saved-path persistence and sharing
- [ ] Signed-in users can CRUD serialized discovery paths in Firestore
- [ ] Shared links open a path anonymously and support saving a personal copy after auth
- [ ] $0 operating cost architecture (Firebase Spark tier, no Cloud Functions)

<details>
<summary>Archived Milestone Requirements</summary>

- [Milestone 1 Requirements](.planning/milestones/v1-REQUIREMENTS.md)
- [Milestone 2 Requirements](.planning/milestones/v2.0-REQUIREMENTS.md)
</details>

## Out of Scope
- Offline/local caching (Hive, Isar) — Keep MVP lightweight, online-only
- Cloud Functions proxy — Explicit $0 backend cost constraint
- Web platform — Mobile-first (iOS/Android only) for MVP, web deferred to v2
- Audio integration (Spotify/Apple Music SDKs) — v2 feature
- Collaborative real-time graphs — v2 feature
- Static image sharing — Sharing is serialized graph state only
- Monetization features — Pure open-source community model
- Heavy third-party graph libraries — Using native InteractiveViewer + CustomPaint
- Firebase Dynamic Links — Deprecated for new projects; use platform deep links instead

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| InteractiveViewer + CustomPaint | Keep native, full control over UX, high performance | Validated (v1.0) |
| RepaintBoundary Isolation | Maintain 60fps by caching static background/edge layers | Validated (v1.0) |
| Map-based Painter Lookups | O(1) performance for edge drawing | Validated (v1.0) |
| Gitleaks & Trivy in CI | Early detection of secrets and vulnerabilities | Validated (v1.0) |
| Map-based Graph State | Efficient node deduplication and graph traversal | Validated (v2.0) |
| SPARQL direct query | Flexible hierarchical data extraction without backend | Validated (v2.0) |
| Domain Entities Mapping | Strict boundary between API models and business logic | Validated (v2.0) |
| Online-only MVP | Lightweight initial build, defer complexity | Pending |
| Direct client API calls | Enforces $0 backend cost for open-source sustainability | Pending |
| Guest mode stays account-free | Preserve zero-friction exploration before auth walls | Pending |
| Standard app links over Firebase Dynamic Links | Dynamic Links are deprecated and shut down for new use | Pending |
| git-cliff | Automated changelog generation based on conventional commits | Validated (quick) |

## Tooling

- **git-cliff:** Used for automated changelog generation. Configuration in `cliff.toml`. Helper script at `scripts/generate-changelog.sh`.
- **Gitleaks:** Secrets detection.
- **Trivy:** Vulnerability scanning.

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `$gsd-transition`):
1. Requirements invalidated? -> Move to Out of Scope with reason
2. Requirements validated? -> Move to Validated with phase reference
3. New requirements emerged? -> Add to Active
4. Decisions to log? -> Add to Key Decisions
5. "What This Is" still accurate? -> Update if drifted

**After each milestone** (via `$gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check -> still the right priority?
3. Audit Out of Scope -> reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-05-24 after starting Milestone v2.1*
