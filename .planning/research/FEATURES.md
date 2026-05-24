# Research: Features

**Milestone:** v2.1 Persistence & Sharing  
**Date:** 2026-05-24

## Authentication

**Table stakes**
- Guest users can access the canvas without an account
- Email/password sign-up and sign-in
- Session persistence for signed-in users
- Password reset and sign-out flows

**Differentiators**
- Social sign-in providers to reduce signup friction on mobile

**Notes**
- Guest exploration should stay intentionally ephemeral for this milestone.
- Social login is in scope, but each provider adds platform configuration and testing overhead.

## Saved Paths

**Table stakes**
- Save current graph state as a named record
- View list of saved paths
- Reopen a saved path into the canvas
- Rename and delete saved paths

**Differentiators**
- Duplicate a saved path as a new editable copy

**Notes**
- Restored paths need both graph content and enough viewport/canvas metadata to feel continuous.

## Sharing

**Table stakes**
- Generate a shareable link for a saved path
- Open a shared path directly in the app from a mobile link
- Explore a shared path without signing in

**Differentiators**
- Save a personal editable copy of a shared path after authentication

**Anti-features for this milestone**
- Collaborative real-time editing
- Commenting or social reactions
- Image export or static-card sharing

## Source Notes

- Flutter deep linking overview: https://docs.flutter.dev/ui/navigation/deep-linking
- Flutter Android app links setup: https://docs.flutter.dev/cookbook/navigation/set-up-app-links
- Android App Links overview: https://developer.android.com/training/app-links/about
- Apple universal links: https://developer.apple.com/documentation/xcode/allowing-apps-and-websites-to-link-to-your-content
