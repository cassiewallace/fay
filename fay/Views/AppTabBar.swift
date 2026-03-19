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
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor.systemBackground
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }

    // MARK: - Body

    let token: String
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            AppointmentsList(token: token)
                .tabItem {
                    Label(Copy.Tabs.appointments, image: selectedTab == 0 ? "icon-calendar-filled" : "icon-calendar")
                }
                .tag(0)

            ChatScreen()
                .tabItem {
                    Label(Copy.Tabs.chat, image: "icon-chats")
                }
                .tag(1)

            JournalScreen()
                .tabItem {
                    Label(Copy.Tabs.journal, image: "icon-notebook")
                }
                .tag(2)

            ProfileScreen()
                .tabItem {
                    Label(Copy.Tabs.profile, image: "icon-user")
                }
                .tag(3)
        }
        .tint(.accentFill.primary)
    }
}
