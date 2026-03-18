//
//  fayApp.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

@main
struct fayApp: App {

    // MARK: - Private

    @State private var token: String?

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            if let token {
                AppTabBar(token: token)
                    .environment(\.signOut, SignOutAction { self.token = nil })
            } else {
                LoginScreen { signedInToken in
                    token = signedInToken
                }
            }
        }
    }
}
