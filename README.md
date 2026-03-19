# Fay

An appointment app for iOS built with SwiftUI.

## Demo

<!-- TODO: Add 1–3 minute video demo (Loom, YouTube unlisted, etc.) -->

## Implementation Notes
- **Architecture:** MVVM with a custom `HTTPClient` for networking.
- **Deployment target:** iOS 17.0, which unlocks `@Observable` and has broad adoption. iOS 26 Liquid Glass is layered on with fallbacks for graceful backward compatibility.
- **Authentication:** Token stored in root `@State`. "Join" is no-op.
- **Appointment cards:** The prominent card (glass/shadow + join button) appears when an appointment is in progress or starts within 10 minutes, controlled by `Appointment.isWithinJoinWindow()`. Provider name is always shown as a deliberate UX choice: it gives context at a glance without tapping in.
- **New Appointment sheet:** Toolbar button present on all OS versions; sheet is intentionally empty (demonstrative only).
- **Tab bar icons:** The selected/unselected icon swap (`icon-calendar-filled` vs `icon-calendar`) is only implemented for the Appointments tab, as that was the only filled variant provided.
- **Dark mode:** Custom colors live in `Assets.xcassets` as named color sets with explicit light/dark values, surfaced as type-safe properties via `Color+Tokens.swift`. System colors are used where possible.
- **Typography & localization:** System fonts throughout. Strings use `String(localized:)` via a `Copy` enum and `Localizable.xcstrings`. Date components use `Calendar.current` and locale-aware formatters.
- **Accessibility:** Semantic labels, Reduce Motion support, 44pt touch targets, and system colors for contrast. Dynamic Type is implemented via `@ScaledMetric` throughout.
- **Testing:** `HTTPClient` is covered with Swift Testing + `MockURLProtocol`, testing success, 401, and malformed JSON for both endpoints. `HTTPClient` conforms to `HTTPClientProtocol`, which both ViewModels depend on; a `MockHTTPClient` conforming to the same protocol enables ViewModel-level unit testing without any URLSession machinery. `Appointment.isWithinJoinWindow()` is covered with boundary-condition tests. `AppointmentsViewModel` is initialized via `_viewModel = State(initialValue:)` in the `AppointmentsList` init — the idiomatic SwiftUI pattern for injecting an `@Observable` view model that needs to be owned as `@State` while still supporting preview injection.
- **Attribution:** Login photo by [Airam Dato-on](https://unsplash.com/@airamdphoto?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText) on [Unsplash](https://unsplash.com/photos/woman-in-gray-button-up-shirt-holding-white-ceramic-mug-T90gWliuCQQ?utm_source=unsplash&utm_medium=referral&utm_content=creditCopyText).
- **Use of AI:**  The app was built with Xcode and Cursor using Anthropic (Claude) models. Architecture decisions, tradeoffs, and all final judgment calls were mine. This reflects how I'd work on your team.

## What I'd Improve With More Time
- **AppointmentsList is doing a lot:** Tab state, sheet state, error rendering, paging. I would break this up into smaller views and files. 
- **Token persistence:** Move the auth token from root `@State` to Keychain, add proactive refresh before expiry, and redirect to login on 401.
- **Dynamic Type polish:** `CalendarIcon` and the tab picker use fixed sizes that would need flexible layouts to fully support extreme text size categories.
- **Error recovery:** Add retry logic for failed network requests rather than relying on manual retry.
- **New appointment sheet:** Add the ability to create fake appointments to make testing easier, even with no upcoming appointments.

## Time Breakdown

| Area | Time |
|---|---|
| Project setup, planning, and core architecture | 1 hour |
| Login screen | 1 hours |
| Appointments screen | 3 hours |
| Nice-to-haves | 2 hours |
| **Total** | ~7 hours |
