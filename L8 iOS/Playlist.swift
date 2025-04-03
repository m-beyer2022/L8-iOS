//
//  Playlist.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

struct Playlist: Identifiable {
    var id: String
    var description: String
    var name: String
    var tracks: [Track]

    // Computed property to get total duration of all tracks in milliseconds
    var totalDurationMs: Int {
        tracks.reduce(0) { $0 + $1.durationMs }
    }

    // Optional: Helper property to format duration in minutes:seconds
    var formattedDuration: String {
        let totalSeconds = totalDurationMs / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
