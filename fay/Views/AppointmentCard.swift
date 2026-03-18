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
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                dateBadge
                appointmentInfo
            }

            if showJoinButton {
                joinButton
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardBackground)
    }

    private var dateBadge: some View {
        VStack(spacing: 2) {
            Text(monthText)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .accessibilityHidden(true)
            Text(dayText)
                .font(.title2.bold())
                .foregroundStyle(.white)
                .accessibilityHidden(true)
        }
        .frame(width: 52, height: 60)
        .background(Color.brand.primary)
        .clipShape(.rect(cornerRadius: 10))
    }

    private var appointmentInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(timeRangeText)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
            Text("\(appointment.appointmentType) with \(Copy.Appointments.providerName)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var joinButton: some View {
        Button { /* no-op */ } label: {
            HStack(spacing: 8) {
                Image(systemName: "video.fill")
                    .accessibilityHidden(true)
                Text(Copy.Appointments.joinButton)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
        }
        .joinButtonStyle()
        .accessibilityLabel(Copy.Appointments.joinButton)
    }

    @ViewBuilder
    private var cardBackground: some View {
        if #available(iOS 26, *) {
            Color.clear
                .glassEffect(.regular, in: .rect(cornerRadius: 16))
        } else {
            Color.background.card
                .clipShape(.rect(cornerRadius: 16))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
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

    private var timeRangeText: String {
        let style = Date.FormatStyle()
            .hour()
            .minute()
            .locale(.autoupdatingCurrent)
        let start = appointment.start.formatted(style)
        let end = appointment.end.formatted(style)
        // specificName gives DST-aware abbreviation (e.g. PDT vs PST), shown once at the end
        let tz = appointment.start.formatted(
            .dateTime.timeZone(.specificName(.short)).locale(.autoupdatingCurrent)
        )
        return "\(start) - \(end) (\(tz))"
    }

    private var accessibilityLabel: String {
        let date = appointment.start.formatted(
            .dateTime.month(.wide).day().year().locale(.autoupdatingCurrent)
        )
        let timeStyle = Date.FormatStyle().hour().minute().locale(.autoupdatingCurrent)
        let startTime = appointment.start.formatted(timeStyle)
        let endTime = appointment.end.formatted(timeStyle)
        // Use DST-aware specific name for the appointment's date, not today's offset
        let tz = appointment.start.formatted(
            .dateTime.timeZone(.specificName(.long)).locale(.autoupdatingCurrent)
        )
        return "\(date), \(startTime) to \(endTime), \(tz), "
            + "\(appointment.appointmentType) with \(Copy.Appointments.providerName)"
    }
}

// MARK: - Join Button Style

private extension View {
    @ViewBuilder
    func joinButtonStyle() -> some View {
        if #available(iOS 26, *) {
            self
                .foregroundStyle(.white)
                .glassEffect(.regular.tint(Color.brand.primary).interactive(), in: .rect(cornerRadius: 12))
        } else {
            self
                .foregroundStyle(.white)
                .background(Color.brand.primary)
                .clipShape(.rect(cornerRadius: 12))
        }
    }
}

// MARK: - Previews

#Preview("With Join Button") {
    AppointmentCard(appointment: .previewUpcoming1, showJoinButton: true)
        .padding()
}

#Preview("Without Join Button") {
    AppointmentCard(appointment: .previewUpcoming2, showJoinButton: false)
        .padding()
}

#Preview("Past") {
    AppointmentCard(appointment: .previewPast1, showJoinButton: false)
        .padding()
}
