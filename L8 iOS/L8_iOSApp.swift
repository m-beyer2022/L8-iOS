//
//  L8_iOSApp.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 26.03.25.
//

import SwiftUI
import SwiftData

@main
struct L8_iOSApp: App {
    @StateObject private var viewModel = FeaturedPlaylistViewModel()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FeaturedPlaylistListView()
                .environmentObject(viewModel)
        }
        .modelContainer(sharedModelContainer)
    }
}
