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
                    Label(Copy.Tabs.appointments, systemImage: "calendar")
                }

            ChatScreen()
                .tabItem {
                    Label(Copy.Tabs.chat, systemImage: "bubble.left.and.bubble.right")
                }

            JournalScreen()
                .tabItem {
                    Label(Copy.Tabs.journal, systemImage: "note.text")
                }

            ProfileScreen()
                .tabItem {
                    Label(Copy.Tabs.profile, systemImage: "person.circle")
                }
        }
        .tint(.brand.primary)
    }
}

// MARK: - Previews

#Preview("Default") {
    AppTabBar(token: "preview", client: MockHTTPClient())
}
