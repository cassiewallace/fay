//
//  JournalScreen.swift
//  fay
//
//  Created by Cassie Wallace on 3/18/26.
//

import SwiftUI

struct JournalScreen: View {
    var body: some View {
        NavigationStack {
            Color.surface.primary
                .ignoresSafeArea()
                .navigationTitle(Copy.Tabs.journal)
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    JournalScreen()
}
