//
//  AppointmentCard.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

/// Card displaying a single appointment with date, type, and optional join button.
struct AppointmentCard: View {

    // MARK: - Lifecycle

    /// The appointment to display.
    let appointment: Appointment
    /// When true, appointment is in progress or starts within 10 minutes; shows glass/shadow styling and join button.
    let isWithinJoinWindow: Bool

    // MARK: - Body

    var body: some View {
        if isWithinJoinWindow, #available(iOS 26, *) {
            cardContent
                .glassEffect(.regular, in: .rect(cornerRadius: Constants.l))
        } else if isWithinJoinWindow {
            cardContent
                .shadow(radius: 12, x: 0, y: 4)
        } else {
            cardContent
                .overlay(
                    RoundedRectangle(cornerRadius: Constants.l)
                        .strokeBorder(Color.border.default, lineWidth: 1)
                )
        }
    }

    // MARK: - Private

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: Constants.m) {
            HStack(alignment: .center, spacing: Constants.m) {
                CalendarIcon(date: appointment.start, variant: isPast ? .past : .upcoming)
                appointmentInfo
            }

            if isWithinJoinWindow {
                ActionButton(icon: Image("icon-video-camera"),
                          copy: Copy.Appointments.joinButton)
            }
        }
        .padding(isWithinJoinWindow ? Constants.l + Constants.xs : Constants.l)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.background.card)
        .clipShape(.rect(cornerRadius: Constants.l))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }

    private var isPast: Bool {
        appointment.end < .now
    }

    private var appointmentInfo: some View {
        VStack(alignment: .leading, spacing: Constants.xs) {
            Text(timeText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.primary)
            Text("\(appointment.appointmentType) with \(Copy.Appointments.providerName)")
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var timeText: String {
        if isWithinJoinWindow {
            // Expanded format for the current appointment: "11:00 AM - 12:00 PM (PDT)"
            let style = Date.FormatStyle().hour().minute().locale(.autoupdatingCurrent)
            let start = appointment.start.formatted(style)
            let end = appointment.end.formatted(style)
            // specificName gives DST-aware abbreviation (e.g. PDT vs PST), shown once at the end
            let tz = appointment.start.formatted(
                .dateTime.timeZone(.specificName(.short)).locale(.autoupdatingCurrent)
            )
            return "\(start) - \(end) (\(tz))"
        } else {
            // Short format for all other cards: "11 AM"
            return appointment.start.formatted(
                .dateTime.hour(.defaultDigits(amPM: .abbreviated)).locale(.autoupdatingCurrent)
            )
        }
    }

    private var accessibilityLabel: String {
        let date = appointment.start.formatted(
            .dateTime.month(.wide).day().year().locale(.autoupdatingCurrent)
        )
        let timeStyle = Date.FormatStyle().hour().minute().locale(.autoupdatingCurrent)
        let startTime = appointment.start.formatted(timeStyle)
        let type = "\(appointment.appointmentType) with \(Copy.Appointments.providerName)"

        if isWithinJoinWindow {
            let endTime = appointment.end.formatted(timeStyle)
            let tz = appointment.start.formatted(
                .dateTime.timeZone(.specificName(.long)).locale(.autoupdatingCurrent)
            )
            return "\(date), \(startTime) to \(endTime), \(tz), \(type)"
        } else {
            return "\(date), \(startTime), \(type)"
        }
    }
}

// MARK: - Previews

#Preview {
    VStack {
        AppointmentCard(appointment: .previewUpcoming1, isWithinJoinWindow: true)
        AppointmentCard(appointment: .previewUpcoming2, isWithinJoinWindow: false)
        AppointmentCard(appointment: .previewPast1, isWithinJoinWindow: false)
    }
    .padding()
}
