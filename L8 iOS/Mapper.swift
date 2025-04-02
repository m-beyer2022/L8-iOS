//
//  Mapper.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import MusicHelperAPI

func mapTrack(result: FeaturedPlaylistsQuery.Data.FeaturedPlaylist.Track) throws -> Track {
    return Track(
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
