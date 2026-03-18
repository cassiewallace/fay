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
            Color.surface.primary
                .ignoresSafeArea()
                .navigationTitle(Copy.Tabs.chat)
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    ChatScreen()
}
