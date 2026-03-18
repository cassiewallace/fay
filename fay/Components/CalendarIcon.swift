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

    let month: String
    let day: Int
    let variant: Variant

    private let cornerRadius: CGFloat = Constants.s
    private let size: CGFloat = Constants.xxxl

    init(date: Date, variant: Variant = .upcoming, calendar: Calendar = .current, locale: Locale = .autoupdatingCurrent) {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = locale
        formatter.dateFormat = Constants.calendarMonthFormat
        self.month = formatter.string(from: date)
        self.day = calendar.component(.day, from: date)
        self.variant = variant
    }

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

    private var monthForeground: Color {
        switch variant {
        case .upcoming: Color.accentFill.primary
        case .past: Color.foreground.primary
        }
    }

    private var dayForeground: Color {
        switch variant {
        case .upcoming: Color.primary
        case .past: Color.foreground.primary
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(outerFill)

            VStack(spacing: 0) {
                Text(month.uppercased())
                    .font(.system(size: Constants.calendarMonthFontSize, weight: .semibold))
                    .foregroundStyle(monthForeground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Constants.xs)
                    .background(monthBackground)

                Text("\(day)")
                    .font(.system(size: Constants.calendarDayFontSize, weight: .medium))
                    .foregroundStyle(dayForeground)
                    .padding(.vertical, Constants.xs)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .frame(width: size, height: size)
    }
}

#Preview {
    HStack {
        CalendarIcon(date: Date.distantFuture, variant: .upcoming)
        CalendarIcon(date: Date.distantPast, variant: .past)
    }
}
