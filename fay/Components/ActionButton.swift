//
//  ActionButton.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

/// Primary action button with optional leading icon and loading state.
struct ActionButton: View {
    
    // MARK: - Properties

    /// Optional icon shown before the label.
    let icon: Image?
    /// Button label text.
    let copy: String
    /// When true, shows a spinner instead of the label.
    let isLoading: Bool
    /// When true, shows a disabled state and prevents tap.
    let isDisabled: Bool
    /// Action to perform on tap.
    let action: (() -> Void)?
    
    // MARK: - Private Properties
    
    private var background: Color {
        isDisabled ? Color.accentFill.primary.opacity(0.5) : Color.accentFill.primary
    }

    // MARK: - Lifecycle

    init(icon: Image? = nil, copy: String, isLoading: Bool = false, isDisabled: Bool = false, action: (() -> Void)? = nil) {
        self.icon = icon
        self.copy = copy
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }

    // MARK: - Body

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
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
        }
        .disabled(isLoading)
        .foregroundStyle(.white)
        .background(background)
        .clipShape(.rect(cornerRadius: Constants.s))
        .accessibilityLabel(copy)
    }
}
