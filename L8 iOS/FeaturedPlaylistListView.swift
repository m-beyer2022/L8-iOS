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

struct FeaturedPlaylistListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject private var viewModel = FeaturedPlaylistViewModel(repository: Repository())
    @State private var searchText: String = ""

    // Computed property for filtered playlists
    var filteredPlaylists: [Playlist] {
        if searchText.isEmpty {
            return viewModel.playlists
        } else {
            return viewModel.playlists.filter { playlist in
                playlist.name.localizedCaseInsensitiveContains(searchText) ||
                playlist.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            List {
                Section(header: Text("Featured Playlists")) {
                    ForEach(filteredPlaylists) { playlist in
                        NavigationLink {
                            PlaylistDetailView(playlist: playlist, viewModel: viewModel)
                        } label: {
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
                Section("Tracks") {
                    NavigationLink("Show All Tracks") {
                        AllTracksView(viewModel: viewModel, tracks: viewModel.allTracks)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search playlists")
            .navigationTitle("Music App")
            .refreshable {
                viewModel.fetchPlaylists()
            }
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    FeaturedPlaylistListView()
        .modelContainer(for: Item.self, inMemory: true)
}
