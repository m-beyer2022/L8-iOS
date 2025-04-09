//
//  ContentViewModel.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import Foundation

final class FeaturedPlaylistViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    @Published var error: Error?
    @Published var addTrackResult: AddSongToPlaylistResponse?
    var repository: RepositoryProtocol

    // Computed property that flattens all tracks
        var allTracks: [Track] {
            playlists.flatMap { $0.tracks }
        }

    init(repository: RepositoryProtocol) {
        self.repository = repository
        fetchPlaylists()
    }

    func fetchPlaylists() {
        repository.fetchFeaturedPlaylistList { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.error = nil
                case .failure(let error):
                    self?.playlists = []
                    self?.error = error
                    print("Error fetching playlists: \(error.localizedDescription)")
                }
            }
        }
    }

    func addTrack(_ track: Track, to playlist: Playlist) {
        repository.addTrackToPlaylist(playlistId: playlist.id, trackUri: track.uri) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.addTrackResult = response
                    if response.success {
                        // Optionally refresh the playlist data
                        self?.fetchPlaylists()
                    }
                case .failure(let error):
                    self?.error = error
                }
            }
        }
    }
}
