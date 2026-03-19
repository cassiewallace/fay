//
//  AppTabBar.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct AppTabBar: View {
    
    // MARK: - Properties

    let token: String
    
    // MARK: - Private Properties
    
    private enum Tab {
        case appointments, chat, journal, profile
    }

    @State private var selectedTab: Tab = .appointments

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

    var body: some View {
        TabView(selection: $selectedTab) {
            AppointmentsList(token: token)
                .tabItem {
                    Label(Copy.Tabs.appointments, image: selectedTab == .appointments ? "icon-calendar-filled" : "icon-calendar")
                }
                .tag(Tab.appointments)

            ChatScreen()
                .tabItem {
                    Label(Copy.Tabs.chat, image: "icon-chats")
                }
                .tag(Tab.chat)

            JournalScreen()
                .tabItem {
                    Label(Copy.Tabs.journal, image: "icon-notebook")
                }
                .tag(Tab.journal)

            ProfileScreen()
                .tabItem {
                    Label(Copy.Tabs.profile, image: "icon-user")
                }
                .tag(Tab.profile)
        }
        .tint(.accentFill.primary)
    }
}
