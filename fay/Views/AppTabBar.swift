//
//  AppTabBar.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct AppTabBar: View {

    // MARK: - Lifecycle

    init(token: String) {
        self.token = token
    }

    // MARK: - Body

    let token: String

    var body: some View {
        TabView {
            AppointmentsList(token: token)
                .tabItem {
                    Label(Copy.Tabs.appointments, image: "icon-calendar")
                }

            ChatScreen()
                .tabItem {
                    Label(Copy.Tabs.chat, image: "icon-chats")
                }

            JournalScreen()
                .tabItem {
                    Label(Copy.Tabs.journal, image: "icon-notebook")
                }

            ProfileScreen()
                .tabItem {
                    Label(Copy.Tabs.profile, image: "icon-user")
                }
        }
        .tint(.accentFill.primary)
    }
}

// MARK: - Previews

#Preview("Default") {
    AppTabBar(token: "preview")
}
