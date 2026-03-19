//
//  AppointmentsViewModelTests.swift
//  fayTests
//
//  Created by Cassie Wallace on 3/18/26.
//

import Testing
import Foundation
@testable import fay

@Suite("AppointmentsViewModel")
@MainActor
struct AppointmentsViewModelTests {

    private let futureAppointment = Appointment(
        id: "future",
        patientID: "1",
        providerID: "100",
        status: "Scheduled",
        appointmentType: "Follow-up",
        start: Date.now.addingTimeInterval(86400),
        end: Date.now.addingTimeInterval(90000),
        durationInMinutes: 60,
        recurrenceType: "Weekly"
    )

    private let pastAppointment = Appointment(
        id: "past",
        patientID: "1",
        providerID: "100",
        status: "Completed",
        appointmentType: "Follow-up",
        start: Date.now.addingTimeInterval(-90000),
        end: Date.now.addingTimeInterval(-86400),
        durationInMinutes: 60,
        recurrenceType: "Weekly"
    )

    // MARK: - loadAppointments

    @Test("loadAppointments sets loaded state on success")
    func loadAppointments_success_setsLoadedState() async {
        let mock = MockHTTPClient(fetchAppointmentsResult: .success([futureAppointment]))
        let vm = AppointmentsViewModel(client: mock)

        await vm.loadAppointments(token: "valid-token")

        if case .loaded(let appointments) = vm.state {
            #expect(appointments.count == 1)
            #expect(appointments[0].id == "future")
        } else {
            Issue.record("Expected loaded state, got \(vm.state)")
        }
    }

    @Test("loadAppointments sets error state on failure")
    func loadAppointments_failure_setsErrorState() async {
        let mock = MockHTTPClient(fetchAppointmentsResult: .failure(HTTPClientError.unauthorized))
        let vm = AppointmentsViewModel(client: mock)

        await vm.loadAppointments(token: "expired-token")

        if case .error = vm.state { } else {
            Issue.record("Expected error state, got \(vm.state)")
        }
    }

    // MARK: - upcomingAppointments / pastAppointments

    @Test("upcomingAppointments returns only future appointments")
    func upcomingAppointments_returnsOnlyFuture() async {
        let mock = MockHTTPClient(fetchAppointmentsResult: .success([futureAppointment, pastAppointment]))
        let vm = AppointmentsViewModel(client: mock)
        await vm.loadAppointments(token: "token")

        #expect(vm.upcomingAppointments.map(\.id) == ["future"])
    }

    @Test("pastAppointments returns only past appointments")
    func pastAppointments_returnsOnlyPast() async {
        let mock = MockHTTPClient(fetchAppointmentsResult: .success([futureAppointment, pastAppointment]))
        let vm = AppointmentsViewModel(client: mock)
        await vm.loadAppointments(token: "token")

        #expect(vm.pastAppointments.map(\.id) == ["past"])
    }
}
