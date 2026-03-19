//
//  AppointmentTests.swift
//  fayTests
//
//  Created by Cassie Wallace on 3/18/26.
//

import Testing
import Foundation
@testable import fay

@Suite("Appointment")
struct AppointmentTests {

    private func makeAppointment(start: Date, end: Date) -> Appointment {
        Appointment(
            id: "test",
            patientID: "1",
            providerID: "100",
            status: "Scheduled",
            appointmentType: "Follow-up",
            start: start,
            end: end,
            durationInMinutes: 60,
            recurrenceType: "Weekly"
        )
    }

    // MARK: - isWithinJoinWindow

    @Test("returns true when appointment is in progress")
    func isWithinJoinWindow_inProgress_returnsTrue() {
        let now = Date.now
        let appointment = makeAppointment(
            start: now.addingTimeInterval(-1800),
            end: now.addingTimeInterval(1800)
        )
        #expect(appointment.isWithinJoinWindow(now: now))
    }

    @Test("returns true when appointment starts within the join window")
    func isWithinJoinWindow_startsWithinWindow_returnsTrue() {
        let now = Date.now
        let appointment = makeAppointment(
            start: now.addingTimeInterval(5 * 60),
            end: now.addingTimeInterval(65 * 60)
        )
        #expect(appointment.isWithinJoinWindow(now: now))
    }

    @Test("returns false when appointment starts after the join window")
    func isWithinJoinWindow_startsFarFuture_returnsFalse() {
        let now = Date.now
        let appointment = makeAppointment(
            start: now.addingTimeInterval(60 * 60),
            end: now.addingTimeInterval(120 * 60)
        )
        #expect(!appointment.isWithinJoinWindow(now: now))
    }

    @Test("returns false when appointment is in the past")
    func isWithinJoinWindow_past_returnsFalse() {
        let now = Date.now
        let appointment = makeAppointment(
            start: now.addingTimeInterval(-120 * 60),
            end: now.addingTimeInterval(-60 * 60)
        )
        #expect(!appointment.isWithinJoinWindow(now: now))
    }

    @Test("returns true when appointment ends exactly at now")
    func isWithinJoinWindow_endsAtNow_returnsTrue() {
        let now = Date.now
        let appointment = makeAppointment(
            start: now.addingTimeInterval(-60 * 60),
            end: now
        )
        #expect(appointment.isWithinJoinWindow(now: now))
    }

    @Test("returns true when appointment starts exactly at window boundary")
    func isWithinJoinWindow_startsAtWindowBoundary_returnsTrue() {
        let now = Date.now
        let appointment = makeAppointment(
            start: now.addingTimeInterval(10 * 60),
            end: now.addingTimeInterval(70 * 60)
        )
        #expect(appointment.isWithinJoinWindow(now: now))
    }
}
