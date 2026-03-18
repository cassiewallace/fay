//
//  Constants.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import CoreFoundation

/// Core constants for spacing and layout.
enum Constants {
    /// 4pt
    static let xs: CGFloat = 4
    /// 8pt
    static let s: CGFloat = 8
    /// 12pt
    static let m: CGFloat = 12
    /// 16pt
    static let l: CGFloat = 16
    /// 24pt
    static let xl: CGFloat = 24
    /// 32pt
    static let xxl: CGFloat = 32
    /// 48pt
    static let xxxl: CGFloat = 48

    /// 12pt — calendar month label
    static let calendarMonthFontSize: CGFloat = 12
    /// 18pt — calendar day label
    static let calendarDayFontSize: CGFloat = 18
    /// DateFormat for abbreviated month (e.g. "Jan")
    static let calendarMonthFormat = "MMM"
}
