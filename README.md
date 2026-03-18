# Fay

An appointment app for iOS built with SwiftUI.

## Demo

<!-- TODO: Add 1–3 minute video demo (Loom, YouTube unlisted, etc.) -->

## Implementation Notes
- **Architecture:** MVVM with a custom `HTTPClient` for networking.
- **Deployment target:** iOS 17.0, which unlocks `@Observable` and has broad adoption. iOS 26 Liquid Glass is layered on with `.ultraThinMaterial` fallbacks for full backward compatibility.
- **Authentication:** Token stored in root `@State`; no Keychain persistence for this scope. A production app would persist to Keychain, proactively refresh before expiry, and redirect to login on 401.
- **Appointment cards:** The prominent card (glass/shadow + join button) appears when an appointment is in progress or starts within 10 minutes, controlled by `Appointment.isWithinJoinWindow()`. Provider name is always shown as a deliberate UX choice: it gives context at a glance without tapping in. "Join" is no-op.
- **New Appointment sheet:** Toolbar button present on all OS versions; sheet is intentionally empty (demonstrative only).
- **Dark mode:** Custom colors live in `Assets.xcassets` as named color sets with explicit light/dark values, surfaced as type-safe properties via `Color+Tokens.swift`. System colors are used where possible.
- **Typography & localization:** System fonts throughout. Strings use `String(localized:)` via a `Copy` enum and `Localizable.xcstrings`. Date components use `Calendar.current` and locale-aware formatters.
- **Accessibility:** Semantic labels, Reduce Motion support, 44pt touch targets, and system colors for contrast. Dynamic Type is partially supported; `CalendarIcon` and the tab picker use fixed sizes that would need flexible layouts in production.
- **Testing:** `HTTPClient` is covered with Swift Testing + `MockURLProtocol`, testing success, 401, and malformed JSON for both endpoints.
- **Attribution:** Login photo by [Airam Dato-on](https://unsplash.com/@airamdphoto?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/photos/woman-in-gray-button-up-shirt-holding-white-ceramic-mug-T90gWliuCQQ?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).
- **Use of AI:**  The app was built in part with Cursor using Anthropic (Claude) models.

## Time Breakdown

| Area | Time |
|---|---|
| Project setup & planning | 0.5 hours |
| Login screen | ~0.5 hours |
| Appointments screen | ~2.5 hours |
| Nice-to-haves | ~1 hours |
| **Total** | ~4.5 hours |
