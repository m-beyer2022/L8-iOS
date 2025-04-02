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
}
