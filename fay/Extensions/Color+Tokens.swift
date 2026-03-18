//
//  Color+Tokens.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

extension Color {
    static let brand = BrandTokens()
    static let background = BackgroundTokens()

    struct BrandTokens {
        let primary = Color("AccentColor")
    }

    struct BackgroundTokens {
        let card = Color("BackgroundCard")
        let primary = Color("BackgroundPrimary")
    }
}
