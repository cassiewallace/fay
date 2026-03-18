//
//  AppointmentCard.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct AppointmentCard: View {
    let appointment: Appointment
    let showJoinButton: Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        cardContent
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel)
    }

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 16) {
                dateBadge
                appointmentInfo
            }

            if showJoinButton {
                FayButton(icon: Image("icon-video-camera"),
                          copy: Copy.Appointments.joinButton)
            }
        }
        .padding(showJoinButton ? 20 : 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
        .clipShape(.rect(cornerRadius: 16))
    }

    private var isPast: Bool {
        appointment.start < .now
    }

    private var dateBadge: some View {
        let monthForeground: Color
        let badgeBackground: Color

        if isPast {
            monthForeground = Color.content.onMuted
            badgeBackground = Color.fill.muted
        } else {
            monthForeground = Color.content.onAccentSubtle
            badgeBackground = Color.fill.accentSubtle
        }

        return VStack(spacing: 0) {
            Text(monthText)
                .font(.caption.weight(.semibold))
                .foregroundStyle(monthForeground)
                .accessibilityHidden(true)
            Text(dayText)
                .font(.title2.bold())
                .foregroundStyle(.primary)
                .accessibilityHidden(true)
        }
        .frame(width: 56, height: 64)
        .background(badgeBackground)
        .clipShape(.rect(cornerRadius: 10))
    }

    private var appointmentInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(timeText)
                .font(.body.weight(.semibold))
                .foregroundStyle(.primary)
            Text("\(appointment.appointmentType) with \(Copy.Appointments.providerName)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var cardBackground: some View {
        if showJoinButton {
            if #available(iOS 26, *) {
                Color.clear
                    .glassEffect(.regular, in: .rect(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.surface.card)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.border.subtle, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 4)
            }
        } else {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.surface.card)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.border.default, lineWidth: 1)
                )
        }
    }

    private var monthText: String {
        appointment.start
            .formatted(.dateTime.month(.abbreviated).locale(.autoupdatingCurrent))
            .uppercased()
    }

    private var dayText: String {
        appointment.start.formatted(.dateTime.day().locale(.autoupdatingCurrent))
    }

    private var timeText: String {
        if showJoinButton {
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

        if showJoinButton {
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
    List {
        AppointmentCard(appointment: .previewUpcoming1, showJoinButton: true)
            .listRowSeparator(.hidden)
        AppointmentCard(appointment: .previewUpcoming2, showJoinButton: false)
            .listRowSeparator(.hidden)
        AppointmentCard(appointment: .previewPast1, showJoinButton: false)
            .listRowSeparator(.hidden)
    }
    .listStyle(.plain)
}
