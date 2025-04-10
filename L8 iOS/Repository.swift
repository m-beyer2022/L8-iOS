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
            DispatchQueue.main.async {
                completion(.success(mockPlaylists))
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

let mockPlaylists = [
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
    ),

    Playlist(
        id: "mock1",
        description: "Mock playlist for UI tests",
        name: "Test Playlist",
        tracks: [
            Track(id: "track1", durationMs: 180000, explicit: false,
                  name: "Test Track 1", uri: "spotify:track:1"),
            Track(id: "track2", durationMs: 210000, explicit: true,
                  name: "Test Track 2", uri: "spotify:track:2")
        ]
    ),

    // New mock data - 3 playlists with 5 tracks each
    Playlist(
        id: "mock5",
        description: "Top Hits 2023",
        name: "Popular Now",
        tracks: [
            Track(id: "t1", durationMs: 237000, explicit: true, name: "Blinding Lights", uri: "spotify:track:1"),
            Track(id: "t2", durationMs: 194000, explicit: false, name: "Dance Monkey", uri: "spotify:track:2"),
            Track(id: "t3", durationMs: 215000, explicit: true, name: "Shape of You", uri: "spotify:track:3"),
            Track(id: "t4", durationMs: 182000, explicit: false, name: "Someone You Loved", uri: "spotify:track:4"),
            Track(id: "t5", durationMs: 263000, explicit: true, name: "Sunflower", uri: "spotify:track:5")
        ]
    ),
    Playlist(
        id: "mock2",
        description: "Relaxing acoustic covers",
        name: "Acoustic Morning",
        tracks: [
            Track(id: "a1", durationMs: 210000, explicit: false, name: "Cover Song 1", uri: "spotify:track:a1"),
            Track(id: "a2", durationMs: 225000, explicit: false, name: "Cover Song 2", uri: "spotify:track:a2"),
            Track(id: "a3", durationMs: 198000, explicit: false, name: "Cover Song 3", uri: "spotify:track:a3"),
            Track(id: "a4", durationMs: 231000, explicit: false, name: "Cover Song 4", uri: "spotify:track:a4"),
            Track(id: "a5", durationMs: 217000, explicit: false, name: "Cover Song 5", uri: "spotify:track:a5")
        ]
    ),
    Playlist(
        id: "mock3",
        description: "Best workout tracks",
        name: "Gym Power",
        tracks: [
            Track(id: "g1", durationMs: 190000, explicit: true, name: "Pump It Up", uri: "spotify:track:g1"),
            Track(id: "g2", durationMs: 205000, explicit: true, name: "No Pain", uri: "spotify:track:g2"),
            Track(id: "g3", durationMs: 220000, explicit: false, name: "Stronger", uri: "spotify:track:g3"),
            Track(id: "g4", durationMs: 195000, explicit: true, name: "Go Hard", uri: "spotify:track:g4"),
            Track(id: "g5", durationMs: 210000, explicit: false, name: "Last Rep", uri: "spotify:track:g5")
        ]
    )
]

#if DEBUG
struct PreviewRepository: RepositoryProtocol {
    // Mock playlists data
    // Existing mock data (keep this)
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
            ),

            Playlist(
                id: "mock1",
                description: "Mock playlist for UI tests",
                name: "Test Playlist",
                tracks: [
                    Track(id: "track1", durationMs: 180000, explicit: false,
                          name: "Test Track 1", uri: "spotify:track:1"),
                    Track(id: "track2", durationMs: 210000, explicit: true,
                          name: "Test Track 2", uri: "spotify:track:2")
                ]
            ),

            // New mock data - 3 playlists with 5 tracks each
            Playlist(
                id: "mock1",
                description: "Top Hits 2023",
                name: "Popular Now",
                tracks: [
                    Track(id: "t1", durationMs: 237000, explicit: true, name: "Blinding Lights", uri: "spotify:track:1"),
                    Track(id: "t2", durationMs: 194000, explicit: false, name: "Dance Monkey", uri: "spotify:track:2"),
                    Track(id: "t3", durationMs: 215000, explicit: true, name: "Shape of You", uri: "spotify:track:3"),
                    Track(id: "t4", durationMs: 182000, explicit: false, name: "Someone You Loved", uri: "spotify:track:4"),
                    Track(id: "t5", durationMs: 263000, explicit: true, name: "Sunflower", uri: "spotify:track:5")
                ]
            ),
            Playlist(
                id: "mock2",
                description: "Relaxing acoustic covers",
                name: "Acoustic Morning",
                tracks: [
                    Track(id: "a1", durationMs: 210000, explicit: false, name: "Cover Song 1", uri: "spotify:track:a1"),
                    Track(id: "a2", durationMs: 225000, explicit: false, name: "Cover Song 2", uri: "spotify:track:a2"),
                    Track(id: "a3", durationMs: 198000, explicit: false, name: "Cover Song 3", uri: "spotify:track:a3"),
                    Track(id: "a4", durationMs: 231000, explicit: false, name: "Cover Song 4", uri: "spotify:track:a4"),
                    Track(id: "a5", durationMs: 217000, explicit: false, name: "Cover Song 5", uri: "spotify:track:a5")
                ]
            ),
            Playlist(
                id: "mock3",
                description: "Best workout tracks",
                name: "Gym Power",
                tracks: [
                    Track(id: "g1", durationMs: 190000, explicit: true, name: "Pump It Up", uri: "spotify:track:g1"),
                    Track(id: "g2", durationMs: 205000, explicit: true, name: "No Pain", uri: "spotify:track:g2"),
                    Track(id: "g3", durationMs: 220000, explicit: false, name: "Stronger", uri: "spotify:track:g3"),
                    Track(id: "g4", durationMs: 195000, explicit: true, name: "Go Hard", uri: "spotify:track:g4"),
                    Track(id: "g5", durationMs: 210000, explicit: false, name: "Last Rep", uri: "spotify:track:g5")
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
