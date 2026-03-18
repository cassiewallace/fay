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
        formatter.dateFormat = "MMM"
        self.month = formatter.string(from: date)
        self.day = calendar.component(.day, from: date)
        self.variant = variant
    }

    private var outerFill: Color {
        switch variant {
        case .upcoming: Color.border.subtle
        case .past: Color.fill.calendarPastBottom
        }
    }

    private var monthBackground: Color {
        switch variant {
        case .upcoming: Color.fill.accentSubtle
        case .past: Color.fill.calendarPastTop
        }
    }

    private var monthForeground: Color {
        switch variant {
        case .upcoming: Color.content.onAccentSubtle
        case .past: Color.content.calendarPast
        }
    }

    private var dayForeground: Color {
        switch variant {
        case .upcoming: Color.primary
        case .past: Color.content.calendarPast
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(outerFill)

            VStack(spacing: 0) {
                Text(month.uppercased())
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(monthForeground)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Constants.xxs)
                    .background(monthBackground)

                Text("\(day)")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(dayForeground)
                    .padding(.vertical, Constants.xxxs)
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
