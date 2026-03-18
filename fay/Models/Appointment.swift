//
//  Appointment.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import Foundation

// MARK: - Appointment

struct Appointment: Codable, Identifiable {
    let id: String
    let patientID: String
    let providerID: String
    let status: String
    let appointmentType: String
    let start: Date
    let end: Date
    let durationInMinutes: Int
    let recurrenceType: String

    enum CodingKeys: String, CodingKey {
        case id = "appointment_id"
        case patientID = "patient_id"
        case providerID = "provider_id"
        case status
        case appointmentType = "appointment_type"
        case start
        case end
        case durationInMinutes = "duration_in_minutes"
        case recurrenceType = "recurrence_type"
    }
}

struct AppointmentResponse: Decodable {
    let appointments: [Appointment]
}

// MARK: - Preview Helpers

extension Appointment {
    static let previewUpcoming1 = Appointment(
        id: "1",
        patientID: "1",
        providerID: "100",
        status: "Scheduled",
        appointmentType: "Follow-up",
        start: Calendar.current.date(byAdding: .day, value: 7, to: .now)!,
        end: Calendar.current.date(byAdding: .day, value: 7, to: .now)!.addingTimeInterval(3600),
        durationInMinutes: 60,
        recurrenceType: "Weekly"
    )

    static let previewUpcoming2 = Appointment(
        id: "2",
        patientID: "1",
        providerID: "100",
        status: "Scheduled",
        appointmentType: "Follow-up",
        start: Calendar.current.date(byAdding: .day, value: 30, to: .now)!,
        end: Calendar.current.date(byAdding: .day, value: 30, to: .now)!.addingTimeInterval(3600),
        durationInMinutes: 60,
        recurrenceType: "Weekly"
    )

    static let previewUpcoming3 = Appointment(
        id: "3",
        patientID: "1",
        providerID: "100",
        status: "Scheduled",
        appointmentType: "Follow-up",
        start: Calendar.current.date(byAdding: .day, value: 60, to: .now)!,
        end: Calendar.current.date(byAdding: .day, value: 60, to: .now)!.addingTimeInterval(3600),
        durationInMinutes: 60,
        recurrenceType: "Weekly"
    )

    static let previewPast1 = Appointment(
        id: "4",
        patientID: "1",
        providerID: "100",
        status: "Completed",
        appointmentType: "Follow-up",
        start: Calendar.current.date(byAdding: .day, value: -14, to: .now)!,
        end: Calendar.current.date(byAdding: .day, value: -14, to: .now)!.addingTimeInterval(3600),
        durationInMinutes: 60,
        recurrenceType: "Weekly"
    )

    static let previewPast2 = Appointment(
        id: "5",
        patientID: "1",
        providerID: "100",
        status: "Completed",
        appointmentType: "Follow-up",
        start: Calendar.current.date(byAdding: .day, value: -30, to: .now)!,
        end: Calendar.current.date(byAdding: .day, value: -30, to: .now)!.addingTimeInterval(3600),
        durationInMinutes: 60,
        recurrenceType: "Weekly"
    )
}
