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
        List(playlist.tracks) { track in
            Text(track.name)
        }
        Text("\(playlist.tracks.count) tracks • \(playlist.formattedDuration)")
            .font(.caption)
    }
}
