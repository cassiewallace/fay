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
            HStack(spacing: Constants.s) {
                icon
                    .accessibilityHidden(true)
                Text(copy)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Constants.s)
            .padding(.horizontal, Constants.l)
        }
        .foregroundStyle(.white)
        .background(Color.fill.accent)
        .clipShape(.rect(cornerRadius: Constants.s))
        .accessibilityLabel(Copy.Appointments.joinButton)
    }
}
