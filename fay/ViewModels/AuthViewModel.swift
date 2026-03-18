//
//  AuthViewModel.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class AuthViewModel {

    // MARK: - Lifecycle

    init(client: any HTTPClientProtocol = HTTPClient.shared) {
        self.client = client
    }

    // MARK: - Public

    var state: ViewState<Void> = .idle

    func signIn(username: String, password: String) async -> String? {
        state = .loading
        do {
            let token = try await client.signIn(username: username, password: password)
            state = .idle
            return token
        } catch {
            state = .error(error.localizedDescription)
            return nil
        }
    }

    // MARK: - Private

    private let client: any HTTPClientProtocol
}
