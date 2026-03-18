//
//  ChatScreen.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct ChatScreen: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(Copy.Chat.empty, image: "icon-chats")
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.background.primary.ignoresSafeArea())
                .navigationTitle(Copy.Tabs.chat)
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ChatScreen()
}
