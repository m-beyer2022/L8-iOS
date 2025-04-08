//
//  Track.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

struct Track: Identifiable {
    var id: String
    var durationMs: Int
    var explicit: Bool
    var name: String
    var uri: String
}
