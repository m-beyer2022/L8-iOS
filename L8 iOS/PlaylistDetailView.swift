//
//  PlaylistDetailView.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import SwiftUI

struct PlaylistDetailView: View {
    let playlist: Playlist
    @State private var showPlaylistPicker = false
    @State private var selectedTrack: Track?
    @State private var selectedPlaylistId: String?
    @Environment(\.dismiss) private var dismiss
    var viewModel: FeaturedPlaylistViewModel
    
    var body: some View {
        List {
            // Playlist header section
            Section {
                Image(systemName: "music.note.list")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(8)
                    .shadow(radius: 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(playlist.description)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("\(playlist.tracks.count) tracks • \(playlist.formattedDuration)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            
            // Tracks section
            Section(header: Text("Tracks")) {
                ForEach(playlist.tracks) { track in
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(track.name)
                                .font(.body)
                                .lineLimit(1)
                        }
                        if track.explicit {
                            Image(systemName: "e.square.fill")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }

                        Spacer()
                        Button(action: {
                            selectedTrack = track
                            showPlaylistPicker = true
                        }) {
                            Label("Add to Playlist", systemImage: "plus")
                                .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.borderless)
                    }
                    .padding(.vertical, 4)
                }
            }
            .sheet(isPresented: $showPlaylistPicker) {
                HStack {
                    if let track = selectedTrack {
                        Picker("Select Playlist", selection: $selectedPlaylistId) {
                            ForEach(viewModel.playlists) { playlist in
                                Text(playlist.name).tag(playlist.id as String?)
                            }
                            
                        }
                        .pickerStyle(.inline)


                        Button("Add to Playlist") {
                            if let playlistId = selectedPlaylistId,
                               let playlist = viewModel.playlists.first(where: { $0.id == playlistId }) {
                                viewModel.addTrack(track, to: playlist)
                                dismiss()
                            }
                        }
                        .disabled(selectedPlaylistId == nil)
                        
                    } else {
                        Color.red
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(playlist.name)
    }
}

#Preview {
    let mockTracks = [
        Track(id: "1", durationMs: 237000, explicit: true, name: "Blinding Lights", uri: "spotify:track:1"),
        Track(id: "2", durationMs: 194000, explicit: false, name: "Dance Monkey", uri: "spotify:track:2"),
        Track(id: "3", durationMs: 215000, explicit: true, name: "Shape of You", uri: "spotify:track:3"),
        Track(id: "4", durationMs: 182000, explicit: false, name: "Someone You Loved", uri: "spotify:track:4"),
        Track(id: "5", durationMs: 263000, explicit: true, name: "Sunflower - Spider-Man: Into the Spider-Verse", uri:
"spotify:track:5")
    ]

    let mockPlaylist = Playlist(
        id: "123",
        description: "The hottest tracks right now",
        name: "Today's Top Hits",
        tracks: mockTracks
    )

    NavigationStack {
        PlaylistDetailView(playlist: mockPlaylist, viewModel: FeaturedPlaylistViewModel(repository: PreviewRepository()))
    }
}
