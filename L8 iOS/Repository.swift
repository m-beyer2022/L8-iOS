//
//  Repository.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import Apollo
import Foundation
import MusicHelperAPI

protocol RepositoryProtocol {
    func fetchFeaturedPlaylistList(completion: @escaping (Result<[Playlist], Error>) -> Void)
}

struct Repository: RepositoryProtocol {
    func fetchFeaturedPlaylistList(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        if ProcessInfo.processInfo.arguments.contains("-UITesting") {
            // Mock response
            let mockPlaylist = Playlist(
                id: "mock1",
                description: "Mock playlist for UI tests",
                name: "Test Playlist",
                tracks: [
                    Track(id: "track1", durationMs: 180000, explicit: false,
                          name: "Test Track 1", uri: "spotify:track:1"),
                    Track(id: "track2", durationMs: 210000, explicit: true,
                          name: "Test Track 2", uri: "spotify:track:2")
                ]
            )
            DispatchQueue.main.async {
                completion(.success([mockPlaylist]))
            }
            return
        }
        let query = MusicHelperAPI.FeaturedPlaylistsQuery()
        Network.shared.apollo.fetch(query: query) { result in
            switch result {
            case .success(let graphQLResult):
                do {
                    let playlists = try mapFeaturedPlaylistsList(result: graphQLResult.data!)
                    completion(.success(playlists))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
