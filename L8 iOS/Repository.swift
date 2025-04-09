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
    func addTrackToPlaylist(playlistId: String, trackUri: String, completion: @escaping
    (Result<AddSongToPlaylistResponse, Error>) -> Void)
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

    func addTrackToPlaylist(playlistId: String, trackUri: String, completion: @escaping
(Result<AddSongToPlaylistResponse, Error>) -> Void) {
        let input = AddItemsToPlaylistInput(playlistId: playlistId, uris: [trackUri])
        let mutation = AddSongToPlaylistMutation(input: input)

        Network.shared.apollo.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let data = graphQLResult.data {
                    let response = mapAddSongToPlaylistResponse(result: data.addItemsToPlaylist)
                    completion(.success(response))
                } else if let errors = graphQLResult.errors {
                    completion(.failure(NSError(domain: "GraphQL", code: -1, userInfo: [NSLocalizedDescriptionKey:
errors.description])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
