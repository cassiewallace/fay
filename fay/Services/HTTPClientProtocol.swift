//
//  HTTPClientProtocol.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation

protocol HTTPClientProtocol {
    func signIn(username: String, password: String) async throws -> String
    func fetchAppointments(token: String) async throws -> [Appointment]
}
