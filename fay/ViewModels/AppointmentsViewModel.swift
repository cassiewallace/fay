//
//  AppointmentsViewModel.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class AppointmentsViewModel {

    // MARK: - Lifecycle

    init(client: any HTTPClientProtocol = HTTPClient.shared) {
        self.client = client
    }

    // MARK: - Public

    var appointments: [Appointment] = []
    var isLoading = false
    var errorMessage: String?

    var upcomingAppointments: [Appointment] {
        appointments
            .filter { $0.start >= .now }
            .sorted { $0.start < $1.start }
    }

    var pastAppointments: [Appointment] {
        appointments
            .filter { $0.start < .now }
            .sorted { $0.start > $1.start }
    }

    func loadAppointments(token: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            appointments = try await client.fetchAppointments(token: token)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Private

    private let client: any HTTPClientProtocol
}
