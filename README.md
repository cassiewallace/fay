# Fay

A healthcare appointment app for iOS (17.0+), built with SwiftUI.

## Demo

<!-- TODO: Add 1–3 minute video demo (Loom, YouTube unlisted, etc.) -->

## Implementation Notes
- Minimum deployment target is iOS 17.0. iOS 17 is a common deployment floor for new SwiftUI apps and unlocks `@Observable`, which eliminates boilerplate and improves performance over `ObservableObject`. In practice I would validate this against device analytics before committing, but iOS 17 adoption is high enough that it balances technical capability with broad user reach, consistent with Fay's mission of increasing access to affordable, inclusive nutrition counseling. Liquid Glass effects (iOS 26+) are layered on with `.ultraThinMaterial` fallbacks so the app is fully functional on any supported OS version.
- Authentication is in-memory (JWT token held in app state); no keychain persistence between sessions was required for this scope
- The "Join appointment" button is present on the first upcoming appointment as a placeholder; it performs no action
- Provider name ("Jane Williams, RD") is hardcoded since the API does not return provider metadata
- All user-facing strings run through `String(localized:)` backed by a `Copy` enum and String Catalog (`Localizable.xcstrings`) for future localization
- The API service (`node-api-for-candidates.onrender.com`) was suspended by its owner during development. The app currently uses `MockHTTPClient`, which returns a hardcoded token for `john`/`12345` and a realistic set of appointments. All live networking code (`HTTPClient`, `HTTPClientProtocol`) is intact — swapping back to the real API requires changing one line in `fayApp.swift`.

## Planning

See [`docs/PLAN.md`](docs/PLAN.md) for the full implementation plan, architecture
decisions, color system, accessibility notes, and file structure. The app was built in part with [Cursor](https://cursor.com) using Anthropic (Claude) models.

## Time Breakdown

| Area | Time |
|---|---|
| Login screen | ~0.25 hours |
| Appointments screen | ~0.75 hours |
| Nice-to-haves (Liquid Glass, accessibility, color system, localization) | TODO |
| Additional (project setup, README, planning) | 0.5 hours (initial build plan) |
| **Total** | **TODO** |
