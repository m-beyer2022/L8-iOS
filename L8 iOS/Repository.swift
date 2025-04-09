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

#if DEBUG
struct PreviewRepository: RepositoryProtocol {
    // Mock playlists data
    private let mockPlaylists = [
        Playlist(
            id: "preview1",
            description: "Preview playlist 1",
            name: "Chill Vibes",
            tracks: [
                Track(id: "pv1", durationMs: 180000, explicit: false,
                      name: "Relaxing Song", uri: "spotify:track:pv1"),
                Track(id: "pv2", durationMs: 210000, explicit: false,
                      name: "Calm Melody", uri: "spotify:track:pv2")
            ]
        ),
        Playlist(
            id: "preview2",
            description: "Preview playlist 2",
            name: "Workout Mix",
            tracks: [
                Track(id: "pv3", durationMs: 240000, explicit: true,
                      name: "Energy Boost", uri: "spotify:track:pv3"),
                Track(id: "pv4", durationMs: 195000, explicit: false,
                      name: "Power Run", uri: "spotify:track:pv4")
            ]
        )
    ]

    func fetchFeaturedPlaylistList(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(mockPlaylists))
        }
    }

    func addTrackToPlaylist(playlistId: String, trackUri: String,
                           completion: @escaping (Result<AddSongToPlaylistResponse, Error>) -> Void) {
        // Always return success for previews
        let response = AddSongToPlaylistResponse(
            code: 200,
            message: "Track added successfully",
            success: true
        )
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(response))
        }
    }
}
#endif 
