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

    init() {
        self.client = HTTPClient.shared
    }

    // MARK: - Public

    var state: ViewState<[Appointment]> = .loading

    var upcomingAppointments: [Appointment] {
        guard case .loaded(let appointments) = state else { return [] }
        return appointments
            .filter { $0.start >= .now }
            .sorted { $0.start < $1.start }
    }

    var pastAppointments: [Appointment] {
        guard case .loaded(let appointments) = state else { return [] }
        return appointments
            .filter { $0.start < .now }
            .sorted { $0.start > $1.start }
    }

    func loadAppointments(token: String) async {
        state = .loading

        do {
            let appointments = try await client.fetchAppointments(token: token)
            state = .loaded(appointments)
        } catch {
            state = .error(error.localizedDescription)
        }
    }

    // MARK: - Private

    private let client: HTTPClient
}
