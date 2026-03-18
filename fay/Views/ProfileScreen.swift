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

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Color.background.primary
                .ignoresSafeArea()
                .navigationTitle(Copy.Tabs.profile)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(Copy.Profile.signOutButton, role: .destructive) {
                            signOut()
                        }
                    }
                }
        }
    }
}

// MARK: - Previews

#Preview {
    ProfileScreen()
        .environment(\.signOut, SignOutAction { })
}
