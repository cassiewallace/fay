//
//  ProfileScreen.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct ProfileScreen: View {

    // MARK: - Private Properties

    @Environment(\.signOut) private var signOut

    // MARK: - Body

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
