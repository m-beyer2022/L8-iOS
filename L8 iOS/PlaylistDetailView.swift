//
//  PlaylistDetailView.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import SwiftUI

struct PlaylistDetailView: View {
    let playlist: Playlist
    
    var body: some View {
        List {
            // Playlist header section
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text(playlist.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(playlist.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(playlist.tracks.count) tracks • \(playlist.formattedDuration)")
                        .font(.caption)
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
                            
                            HStack(spacing: 8) {
                                if track.explicit {
                                    Image(systemName: "e.square.fill")
                                        .foregroundColor(.secondary)
                                        .font(.caption)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(playlist.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PlaylistDetailView(playlist: .init(id: "1", description: "1", name: "2", tracks: [.init(id: "1", durationMs: 1, explicit: false, name: "1", uri: "1")]))
}
