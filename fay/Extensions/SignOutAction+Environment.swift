//
//  SignOutAction+Environment.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct SignOutAction {

    // MARK: - Public

    let perform: () -> Void

    func callAsFunction() {
        perform()
    }
}

// MARK: - Environment

private struct SignOutActionKey: EnvironmentKey {
    static let defaultValue = SignOutAction { }
}

extension EnvironmentValues {
    var signOut: SignOutAction {
        get { self[SignOutActionKey.self] }
        set { self[SignOutActionKey.self] = newValue }
    }
}
