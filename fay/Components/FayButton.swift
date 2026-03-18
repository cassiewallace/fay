//
//  FayButton.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct FayButton: View {
    let icon: Image?
    let copy: String
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
            .padding(Constants.xs)
        }
        .foregroundStyle(.white)
        .background(Color.fill.accent)
        .clipShape(.rect(cornerRadius: Constants.s))
        .accessibilityLabel(copy)
    }
}
