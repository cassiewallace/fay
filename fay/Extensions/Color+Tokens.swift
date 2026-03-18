//
//  Color+Tokens.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

extension Color {
    static let brand = BrandTokens()
    static let surface = SurfaceTokens()
    static let fill = FillTokens()
    static let content = ContentTokens()
    static let border = BorderTokens()

    /// Primary brand color and tints derived from it.
    struct BrandTokens {
        let primary = Color("AccentColor")
        let onPrimary = Color.white
    }

    /// Page- and card-level background colors.
    struct SurfaceTokens {
        let primary = Color("BackgroundPrimary")
        let card = Color("BackgroundCard")
        let muted = Color("DateBadgePastBackground")
    }

    /// Solid fill colors for interactive elements (badges, buttons, chips).
    struct FillTokens {
        let accent = Color("AccentColor")
        /// Light tint of the accent color for de-emphasized elements on the same surface.
        let accentSubtle = Color("FillAccentSubtle")
        let muted = Color("DateBadgePastBackground")
    }

    /// Foreground/text colors intended for use on top of fills and surfaces.
    struct ContentTokens {
        let onAccent = Color.white
        let onAccentSubtle = Color("AccentColor")
        let onMuted = Color("DateBadgePastForeground")
    }

    /// Border and stroke colors.
    struct BorderTokens {
        let `default` = Color("BorderDefault")
        let subtle = Color("BorderSubtle")
    }
}
