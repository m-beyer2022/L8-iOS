//
//  AllTracksView.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import SwiftUI


struct AllTracksView: View {
    @State private var showPlaylistPicker = false
    @State private var selectedTrack: Track?
    @State private var selectedPlaylistId: String?
    @Environment(\.dismiss) private var dismiss
    var viewModel: FeaturedPlaylistViewModel
    let tracks: [Track]

    var body: some View {
        List {
            ForEach(tracks) { track in
                HStack(spacing: 12) {
                    // Explicit indicator
                    if track.explicit {
                        Image(systemName: "e.square.fill")
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(track.name)
                            .font(.headline)

                        // Format duration as minutes:seconds
                        Text(formatDuration(track.durationMs))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    // Add button
                    Button(action: {
                        selectedTrack = track
                        showPlaylistPicker = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 8)
            }
        }
        .listStyle(.plain)
        .sheet(isPresented: $showPlaylistPicker) {
            NavigationStack {
                VStack(spacing: 20) {
                    if let track = selectedTrack {
                        Text("Add '\(track.name)' to:")
                            .font(.headline)
                            .padding(.top)

                        Picker("Select Playlist", selection: $selectedPlaylistId) {
                            ForEach(viewModel.playlists) { playlist in
                                Text(playlist.name).tag(playlist.id as String?)
                            }
                        }
                        .pickerStyle(.inline)

                        HStack(spacing: 20) {
                            Button("Cancel") {
                                showPlaylistPicker = false
                            }
                            .foregroundColor(.red)

                            Button("Add to Playlist") {
                                if let playlistId = selectedPlaylistId,
                                   let playlist = viewModel.playlists.first(where: { $0.id == playlistId }) {
                                    viewModel.addTrack(track, to: playlist)
                                    dismiss()
                                }
                            }
                            .disabled(selectedPlaylistId == nil)
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    }
                }
                .navigationTitle("Select Playlist")
                .navigationBarTitleDisplayMode(.inline)
            }
            .presentationDetents([.medium])
        }
        .navigationTitle("All Tracks")
    }

    private func formatDuration(_ ms: Int) -> String {
        let seconds = ms / 1000
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}

let viewModel = FeaturedPlaylistViewModel(repository: PreviewRepository())

#Preview {
    AllTracksView(
        viewModel: viewModel,
        tracks: [.init(
            id: "",
            durationMs: 1,
            explicit: false,
            name: "Hello",
            uri: "h"
        )]
    )
}
