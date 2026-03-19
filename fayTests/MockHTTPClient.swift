//
//  MockHTTPClient.swift
//  fayTests
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation
@testable import fay

struct MockHTTPClient: HTTPClientProtocol {
    var signInResult: Result<String, Error> = .success("mock-token")
    var fetchAppointmentsResult: Result<[Appointment], Error> = .success([])

    func signIn(username: String, password: String) async throws -> String {
        try signInResult.get()
    }

    func fetchAppointments(token: String) async throws -> [Appointment] {
        try fetchAppointmentsResult.get()
    }
}
