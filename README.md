# Fay

An appointment app for iOS (17.0+), built with SwiftUI.

## Demo

<!-- TODO: Add 1–3 minute video demo (Loom, YouTube unlisted, etc.) -->

## Implementation Notes
- **Typography:** System fonts are used to prioritize accessibility in the context of this exercise without customizing type.
- **Architecture:** MVVM architecture with an HTTPClient for networking.
- **Minimum deployment target:** is iOS 17.0. iOS 17 is a common deployment floor for new SwiftUI apps and unlocks `@Observable`, which eliminates boilerplate and improves performance over `ObservableObject`. In practice I would validate this against device analytics before committing, but iOS 17 adoption is high enough that it balances technical capability with broad user reach, consistent with Fay's mission of increasing access to affordable, inclusive nutrition counseling. Liquid Glass effects (iOS 26+) are layered on with `.ultraThinMaterial` fallbacks so the app is fully functional on any supported OS version.
- **Authentication:** Token is held in app state (`@State` in the root view); no keychain persistence for this scope. Login error handling (e.g. retry, field-level validation) was left out of scope. If the token expires, the next API call returns 401 and the user sees the error state with a retry button. A production app would: (1) persist the token in Keychain for session restore, (2) decode the JWT `exp` claim to proactively refresh or prompt re-login before expiry, (3) on 401, clear the token and present the login screen instead of a generic error, and (4) consider refresh tokens if the API supports them.
- **Appointment card styling:** The prominent card (glass/shadow, join button) is shown when an appointment is in progress or starts within 10 minutes — not by list position. `Appointment.isWithinJoinWindow()` encapsulates this; the 10‑minute window is configurable. "Join appointment" button is no-op and provider name is hard-coded, since the current API does not return provider
- **Localization:** All user-facing strings run through `String(localized:)` backed by a `Copy` enum and String Catalog (`Localizable.xcstrings`) for future localization. Date components (month abbreviation, day number) use `Calendar.current` and locale-aware `DateFormatter`/`Date.FormatStyle` instances so they adapt correctly to the user's region and calendar system.
- **New Appointment:** Lives in the toolbar, enabling consistent placement and styling across deployment targets and leveraging the latest standards for iOS 26 with Liquid Glass. The sheet is demonstrative and intentionally empty — no booking flow was implemented.
- **Dark mode:** All custom colors are defined as named color sets in `Assets.xcassets` with explicit light and dark values, then surfaced as type-safe static properties on `Color` via `Color+Tokens.swift`. System colors (`.primary`, `.secondary`) are used where possible to adapt automatically.
- **Accessibility:** Core practices are applied throughout: semantic accessibility labels (including VoiceOver-friendly card descriptions), Reduce Motion support, minimum 44pt touch targets, and system colors for contrast. Dynamic Type support could be further refined — notably, `CalendarIcon` uses fixed font sizes and a fixed frame that would clip at the largest accessibility sizes, and the tab picker has a fixed height. A production app would address these with scalable text styles and flexible layouts.
- **Testing:** Unit tests cover `HTTPClient` using Swift Testing (`@Test`, `#expect`) with a `MockURLProtocol` to intercept network requests without hitting the live API. Tests cover success paths, 401 unauthorized errors, and malformed JSON decoding for both `signIn` and `fetchAppointments`.
- **Attribution:** Login screen photo by [Airam Dato-on](https://unsplash.com/@airamdphoto?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/photos/woman-in-gray-button-up-shirt-holding-white-ceramic-mug-T90gWliuCQQ?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).
- **Use of AI:**  The app was built in part with Cursor using Anthropic (Claude) models.

## Time Breakdown

| Area | Time |
|---|---|
| Project setup & planning | 0.5 hours |
| Login screen | ~0.5 hours |
| Appointments screen | ~2 hours |
| Nice-to-haves | ~1 hours |
| **Total** | ~4 hours |
