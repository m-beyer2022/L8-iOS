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

    init() {
        fetchPlaylists()
    }

    func fetchPlaylists() {
        fetchFeaturedPlaylistList { [weak self] result in
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
}  
