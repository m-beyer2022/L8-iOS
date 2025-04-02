//
//  Repository.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import Apollo
import MusicHelperAPI

func fetchFeaturedPlaylistList(completion: @escaping (Result<[Playlist], Error>) -> Void) {
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
