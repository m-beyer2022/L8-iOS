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
    @State private var showLogin = true

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
                if showLogin {
                    LoginView(onLoginComplete: { showLogin = false })
                } else {
                    FeaturedPlaylistListView()
                        .transition(.opacity)
                }
            }
            .modelContainer(sharedModelContainer)
        }
    }
