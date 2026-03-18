//
//  MockHTTPClient.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//
//  Stands in for the live API while node-api-for-candidates.onrender.com is suspended.
//  Remove this file and revert fayApp.swift to HTTPClient.shared when the service is restored.
//

import Foundation

struct MockHTTPClient: HTTPClientProtocol {

    // MARK: - Public

    func signIn(username: String, password: String) async throws -> String {
        try await simulatedDelay()
        guard username == APIConstants.demoUsername,
              password == APIConstants.demoPassword else {
            throw HTTPClientError.unauthorized
        }
        return "mock-jwt-token"
    }

    func fetchAppointments(token: String) async throws -> [Appointment] {
        try await simulatedDelay()
        return Self.mockAppointments
    }

    // MARK: - Private

    private func simulatedDelay() async throws {
        try await Task.sleep(for: .milliseconds(600))
    }

    private static let mockAppointments: [Appointment] = [
        Appointment(
            id: "509teq10vh",
            patientID: "1",
            providerID: "100",
            status: "Scheduled",
            appointmentType: "Follow-up",
            start: date(byAdding: 7, hour: 10, minute: 0),
            end: date(byAdding: 7, hour: 10, minute: 45),
            durationInMinutes: 45,
            recurrenceType: "Weekly"
        ),
        Appointment(
            id: "a1b2c3d4e5",
            patientID: "1",
            providerID: "100",
            status: "Scheduled",
            appointmentType: "Initial Consultation",
            start: date(byAdding: 14, hour: 14, minute: 30),
            end: date(byAdding: 14, hour: 15, minute: 30),
            durationInMinutes: 60,
            recurrenceType: "None"
        ),
        Appointment(
            id: "f6g7h8i9j0",
            patientID: "1",
            providerID: "100",
            status: "Scheduled",
            appointmentType: "Check-in",
            start: date(byAdding: 28, hour: 9, minute: 0),
            end: date(byAdding: 28, hour: 9, minute: 30),
            durationInMinutes: 30,
            recurrenceType: "Bi-weekly"
        ),
        Appointment(
            id: "k1l2m3n4o5",
            patientID: "1",
            providerID: "100",
            status: "Completed",
            appointmentType: "Follow-up",
            start: date(byAdding: -7, hour: 11, minute: 0),
            end: date(byAdding: -7, hour: 11, minute: 45),
            durationInMinutes: 45,
            recurrenceType: "Weekly"
        ),
        Appointment(
            id: "p6q7r8s9t0",
            patientID: "1",
            providerID: "100",
            status: "Completed",
            appointmentType: "Initial Consultation",
            start: date(byAdding: -30, hour: 15, minute: 0),
            end: date(byAdding: -30, hour: 16, minute: 0),
            durationInMinutes: 60,
            recurrenceType: "None"
        ),
    ]

    private static func date(byAdding days: Int, hour: Int, minute: Int) -> Date {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        components.hour = hour
        components.minute = minute
        let base = Calendar.current.date(from: components)!
        return Calendar.current.date(byAdding: .day, value: days, to: base)!
    }
}
