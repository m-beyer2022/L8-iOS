// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct AddItemsToPlaylistInput: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    playlistId: ID,
    uris: [String]
  ) {
    __data = InputDict([
      "playlistId": playlistId,
      "uris": uris
    ])
  }

  /// The ID of the playlist.
  public var playlistId: ID {
    get { __data["playlistId"] }
    set { __data["playlistId"] = newValue }
  }

  /// A list of Spotify URIs to add.
  public var uris: [String] {
    get { __data["uris"] }
    set { __data["uris"] = newValue }
  }
}
