//
//  ContentViewModel.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import Foundation

final class ContentViewModel: ObservableObject {
    @Published var playlists: [Playlist] = []
    @Published var error: Error?
    
    init() {
        fetchFeaturedPlaylistList { result in
            switch result {
            case .success(let playlists):
                print(playlists)
            case .failure(let error):
                print(error)
            }
        }
    }
}
