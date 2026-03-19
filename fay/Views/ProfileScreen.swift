//
//  ProfileScreen.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct ProfileScreen: View {

    // MARK: - Body

    @Environment(\.signOut) private var signOut

    var body: some View {
        NavigationStack {
            ActionButton(copy: Copy.Profile.signOutButton) {
                signOut()
            }
            .padding()
            .navigationTitle(Copy.Tabs.profile)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Previews

#Preview {
    ProfileScreen()
        .environment(\.signOut, SignOutAction { })
}
