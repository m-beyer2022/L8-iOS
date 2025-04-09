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
        List(tracks) { track in
            HStack {
                Text(track.name)
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
        .navigationTitle("All Tracks")
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
