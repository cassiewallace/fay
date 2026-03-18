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

    // Service is suspended — swap MockHTTPClient for HTTPClient.shared when restored.
    private let client: any HTTPClientProtocol = MockHTTPClient()

    @State private var token: String?

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            if let token {
                AppTabBar(token: token, client: client)
                    .environment(\.signOut, SignOutAction { self.token = nil })
            } else {
                LoginScreen(client: client) { signedInToken in
                    token = signedInToken
                }
            }
        }
    }
}
