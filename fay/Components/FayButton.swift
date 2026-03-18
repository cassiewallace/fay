//
//  FayButton.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

/// Primary action button with optional leading icon.
struct FayButton: View {
    /// Optional icon shown before the label.
    let icon: Image?
    /// Button label text.
    let copy: String
    /// Action to perform on tap.
    let action: (() -> ())?
    
    init(icon: Image? = nil, copy: String, action: (() -> Void)? = nil) {
        self.icon = icon
        self.copy = copy
        self.action = action
    }
    
    var body: some View {
        Button {
            if let action {
                action()
            }
        } label: {
            HStack(spacing: Constants.s) {
                if let icon {
                    icon
                        .accessibilityHidden(true)
                }
                Text(copy)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(Constants.s)
        }
        .foregroundStyle(.white)
        .background(Color.accentFill.primary)
        .clipShape(.rect(cornerRadius: Constants.s))
        .accessibilityLabel(copy)
    }
}
