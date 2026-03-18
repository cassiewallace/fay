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

    var isLoading = false
    var errorMessage: String?

    func signIn(username: String, password: String) async -> String? {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let token = try await client.signIn(username: username, password: password)
            return token
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    // MARK: - Private

    private let client: any HTTPClientProtocol
}
