//
//  CalendarIcon.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct CalendarIcon: View {

    enum Variant {
        case upcoming
        case past
    }

    // MARK: - Lifecycle

    let month: String
    let day: Int
    let variant: Variant

    init(date: Date, variant: Variant = .upcoming, calendar: Calendar = .current, locale: Locale = .autoupdatingCurrent) {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        formatter.dateFormat = "MMM"
        self.month = formatter.string(from: date)
        self.day = calendar.component(.day, from: date)
        self.variant = variant
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(outerFill)

            VStack(spacing: 0) {
                Text(month.uppercased())
                    .font(.system(size: Constants.m, weight: .semibold))
                    .foregroundStyle(textForeground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Constants.xs)
                    .background(monthBackground)

                Text("\(day)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(textForeground)
                    .padding(.vertical, Constants.xs)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .frame(width: size, height: size)
    }

    // MARK: - Private

    private let cornerRadius: CGFloat = Constants.s
    private let size: CGFloat = Constants.xxxl

    private var outerFill: Color {
        switch variant {
        case .upcoming: Color.border.subtle
        case .past: Color.background.subtle
        }
    }

    private var monthBackground: Color {
        switch variant {
        case .upcoming: Color.accentFill.subtle
        case .past: Color.background.muted
        }
    }

    private var textForeground: Color {
        switch variant {
        case .upcoming: Color.primary
        case .past: Color.foreground.primary
        }
    }
}

// MARK: - Previews

#Preview {
    HStack {
        CalendarIcon(date: Date.distantFuture, variant: .upcoming)
        CalendarIcon(date: Date.distantPast, variant: .past)
    }
}
