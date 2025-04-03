//
//  Mapper.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import MusicHelperAPI

func mapAddSongToPlaylistMutation(result: AddSongToPlaylistMutation.Data.AddItemsToPlaylist) throws -> {
    
}


func mapTrack(result: FeaturedPlaylistsQuery.Data.FeaturedPlaylist.Track) throws -> Track {
    return Track(
        id: result.id,
        durationMs: result.durationMs,
        explicit: result.explicit,
        name: result.name,
        uri: result.uri
    )
}

func mapFeaturedPlaylist(result: FeaturedPlaylistsQuery.Data.FeaturedPlaylist) throws ->
Playlist {
    let tracks = try result.tracks.map { track in
        return try mapTrack(result: track)
    }

    return Playlist(
        id: result.id,
        description: result.description ?? "",
        name: result.name,
        tracks: tracks
    )
}

func mapFeaturedPlaylistsList(result: FeaturedPlaylistsQuery.Data) throws -> [Playlist] {
    return try result.featuredPlaylists.map { playlist in
        return try mapFeaturedPlaylist(result: playlist)
    }
}
