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
        NavigationStack {
            List {
                Section(header: Text("Featured Playlists")) {
                    ForEach(filteredPlaylists) { playlist in
                        NavigationLink {
                            PlaylistDetailView(playlist: playlist, viewModel: viewModel)
                        } label: {
                            HStack(spacing: 16) {
                                // Add gradient image
                                Image(systemName: "music.note.list")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors:
randomGradientColors(for: playlist.id)),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(8)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(playlist.name)
                                        .font(.headline)
                                    Text(playlist.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(5)
                                    Text("\(playlist.tracks.count) tracks")
                                        .font(.caption)
                                }
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .refreshable {
                viewModel.fetchPlaylists()
            }
        }
    }

    // Helper function to generate consistent random colors based on playlist ID
    private func randomGradientColors(for id: String) -> [Color] {
        let colors: [[Color]] = [
            [.blue, .purple],
            [.orange, .pink],
            [.green, .mint],
            [.indigo, .teal],
            [.yellow, .orange],
            [.purple, .indigo],
            [.teal, .blue]
        ]

        // Use playlist ID to get consistent colors for each playlist
        let hash = id.hashValue
        let index = abs(hash) % colors.count
        return colors[index]
    }
}

#Preview {
    FeaturedPlaylistListView()
        .modelContainer(for: Item.self, inMemory: true)
}
