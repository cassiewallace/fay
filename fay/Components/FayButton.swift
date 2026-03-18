//
//  FayButton.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

/// Primary action button with optional leading icon and loading state.
struct FayButton: View {

    // MARK: - Lifecycle

    init(icon: Image? = nil, copy: String, action: (() -> Void)? = nil, isLoading: Bool = false) {
        self.icon = icon
        self.copy = copy
        self.action = action
        self.isLoading = isLoading
    }

    // MARK: - Body

    /// Optional icon shown before the label.
    let icon: Image?
    /// Button label text.
    let copy: String
    /// Action to perform on tap.
    let action: (() -> Void)?
    /// When true, shows a spinner instead of the label.
    let isLoading: Bool

    var body: some View {
        Button {
            if !isLoading, let action {
                action()
            }
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    HStack(spacing: Constants.s) {
                        if let icon {
                            icon
                                .accessibilityHidden(true)
                        }
                        Text(copy)
                            .font(.subheadline.weight(.semibold))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .padding(Constants.s)
        }
        .disabled(isLoading)
        .foregroundStyle(.white)
        .background(Color.accentFill.primary)
        .clipShape(.rect(cornerRadius: Constants.s))
        .accessibilityLabel(copy)
    }
}
