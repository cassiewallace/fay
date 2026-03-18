//
//  AppTabBar.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct AppTabBar: View {
    let token: String
    var client: any HTTPClientProtocol

    init(token: String, client: any HTTPClientProtocol = HTTPClient.shared) {
        self.token = token
        self.client = client
    }

    var body: some View {
        TabView {
            AppointmentsList(token: token, client: client)
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
    AppTabBar(token: "preview", client: MockHTTPClient())
}
