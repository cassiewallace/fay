//
//  ProfileScreen.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct ProfileScreen: View {

    // MARK: - Private

    @Environment(\.signOut) private var signOut

    var body: some View {
        NavigationStack {
            List {
                Button(Copy.Profile.signOutButton, role: .destructive) {
                    signOut()
                }
            }
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
