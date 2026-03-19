//
//  AuthViewModelTests.swift
//  fayTests
//
//  Created by Cassie Wallace on 3/18/26.
//

import Testing
import Foundation
@testable import fay

@Suite("AuthViewModel")
@MainActor
struct AuthViewModelTests {

    // MARK: - signIn

    @Test("signIn returns token and resets state to idle on success")
    func signIn_success_returnsTokenAndResetsState() async {
        let mock = MockHTTPClient(signInResult: .success("test-token"))
        let vm = AuthViewModel(client: mock)

        let token = await vm.signIn(username: "john", password: "12345")

        #expect(token == "test-token")
        if case .idle = vm.state { } else {
            Issue.record("Expected idle state, got \(vm.state)")
        }
    }

    @Test("signIn sets error state on failure")
    func signIn_failure_setsErrorState() async {
        let mock = MockHTTPClient(signInResult: .failure(HTTPClientError.unauthorized))
        let vm = AuthViewModel(client: mock)

        let token = await vm.signIn(username: "wrong", password: "wrong")

        #expect(token == nil)
        if case .error = vm.state { } else {
            Issue.record("Expected error state, got \(vm.state)")
        }
    }
}
