//
//  ContentView.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 26.03.25.
//

import SwiftUI
import SwiftData
import MusicHelperAPI
import Apollo



struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationSplitView {
            List {
                // Playlists Section
                Section(header: Text("Featured Playlists")) {
                    ForEach(viewModel.playlists, id: \.name) { playlist in
                        VStack(alignment: .leading) {
                            Text(playlist.name)
                                .font(.headline)
                            Text(playlist.description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("\(playlist.tracks.count) tracks")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Music App")
            .refreshable {
                viewModel.fetchPlaylists()
            }
        } detail: {
            Text("Select an item")
        }
    }
    // ... rest of the ContentView code ...
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
