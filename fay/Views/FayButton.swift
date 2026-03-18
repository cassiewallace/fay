//
//  FayButton.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct FayButton: View {
    let icon: Image
    let copy: String
    
    var body: some View {
        // TODO: Combine a11y children?
        Button { /* no-op */ } label: {
            HStack(spacing: 8) {
                icon
                    .accessibilityHidden(true)
                Text(copy)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(16)
        }
        .foregroundStyle(.white)
        .background(Color.fill.accent)
        .clipShape(.rect(cornerRadius: 8))
        .accessibilityLabel(Copy.Appointments.joinButton)
    }
}
