//
//  Copy.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation

enum Copy {

    // MARK: - Login

    enum Login {
        static let usernameTitle = String(localized: "login.username.title", defaultValue: "Username")
        static let passwordTitle = String(localized: "login.password.title", defaultValue: "Password")
        static let usernamePlaceholder = String(localized: "login.username.placeholder", defaultValue: "Enter username")
        static let passwordPlaceholder = String(localized: "login.password.placeholder", defaultValue: "Enter password")
        static let signInButton = String(localized: "login.sign_in.button", defaultValue: "Log in")
        static let errorTitle = String(localized: "login.error.title", defaultValue: "Sign in failed")
        static let screenTitle = String(localized: "login.screen.title", defaultValue: "Welcome back")
        static let screenSubtitle = String(localized: "login.screen.subtitle", defaultValue: "Sign in to your account")
    }

    // MARK: - Appointments

    enum Appointments {
        static let screenTitle = String(localized: "appointments.screen.title", defaultValue: "Appointments")
        static let newButton = String(localized: "appointments.new.button", defaultValue: "New")
        static let newButtonAccessibility = String(localized: "appointments.new.button.accessibility", defaultValue: "New appointment")
        static let upcoming = String(localized: "appointments.tab.upcoming", defaultValue: "Upcoming")
        static let past = String(localized: "appointments.tab.past", defaultValue: "Past")
        static let joinButton = String(localized: "appointments.join.button", defaultValue: "Join appointment")
        static let emptyUpcoming = String(localized: "appointments.empty.upcoming", defaultValue: "No upcoming appointments")
        static let emptyPast = String(localized: "appointments.empty.past", defaultValue: "No past appointments")
        static let retryButton = String(localized: "appointments.retry.button", defaultValue: "Try Again")
        static let loading = String(localized: "appointments.loading", defaultValue: "Loading appointments")
        static let providerName = String(localized: "appointments.provider.name", defaultValue: "Jane Williams, RD")
        static let newAppointmentSheetTitle = String(localized: "appointments.new.sheet.title", defaultValue: "New appointment")
        static let newAppointmentSheetPlaceholder = String(localized: "appointments.new.sheet.placeholder", defaultValue: "Nothing here yet!")
    }

    // MARK: - Profile

    enum Profile {
        static let signOutButton = String(localized: "profile.sign_out.button", defaultValue: "Sign Out")
    }

    // MARK: - Tabs

    enum Tabs {
        static let appointments = String(localized: "tab.appointments", defaultValue: "Appointments")
        static let chat = String(localized: "tab.chat", defaultValue: "Chat")
        static let journal = String(localized: "tab.journal", defaultValue: "Journal")
        static let profile = String(localized: "tab.profile", defaultValue: "Profile")
    }

    // MARK: - Chat

    enum Chat {
        static let empty = String(localized: "chat.empty", defaultValue: "No messages yet")
    }

    // MARK: - Journal

    enum Journal {
        static let empty = String(localized: "journal.empty", defaultValue: "No journal entries yet")
    }

    // MARK: - Errors

    enum Errors {
        static let generic = String(localized: "error.generic", defaultValue: "Something went wrong. Please try again.")
        static let unauthorized = String(localized: "error.unauthorized", defaultValue: "Invalid username or password.")
        static let invalidResponse = String(localized: "error.invalid_response", defaultValue: "An unexpected error occurred. Please try again.")
        static func serverError(code: Int) -> String { "Server error (\(code)). Please try again." }
    }
}
