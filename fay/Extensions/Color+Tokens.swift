//
//  Color+Tokens.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

extension Color {
    static let background = BackgroundTokens()
    static let foreground = ForegroundTokens()
    static let border = BorderTokens()
    static let accentFill = AccentTokens()

    struct BackgroundTokens {
        let primary = Color("BackgroundPrimary")
        let card = Color("BackgroundCard")
        let muted = Color("BackgroundMuted")
        let subtle = Color("BackgroundSubtle")
        let white = Color.white
    }

    struct ForegroundTokens {
        let primary = Color("ForegroundPrimary")
        let secondary = Color("ForegroundSecondary")
        let onAccent = Color.white
    }

    struct BorderTokens {
        let `default` = Color("BorderDefault")
        let subtle = Color("BorderSubtle")
    }

    struct AccentTokens {
        let primary = Color("AccentPrimary")
        let subtle = Color("AccentSubtle")
    }
}
