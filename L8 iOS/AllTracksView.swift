//
//  AllTracksView.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import SwiftUI

struct AllTracksView: View {
    let tracks: [Track]

    var body: some View {
        List(tracks) { track in
            Text(track.name)
        }
        .navigationTitle("All Tracks")
    }
}

#Preview {
    AllTracksView(tracks: [])
}
