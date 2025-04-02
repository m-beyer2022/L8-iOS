// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PlaylistQuery: GraphQLQuery {
  public static let operationName: String = "Playlist"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Playlist($playlistId: ID!) { playlist(id: $playlistId) { __typename id description name tracks { __typename durationMs explicit id name uri } } }"#
    ))

  public var playlistId: ID

  public init(playlistId: ID) {
    self.playlistId = playlistId
  }

  public var __variables: Variables? { ["playlistId": playlistId] }

  public struct Data: MusicHelperAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MusicHelperAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("playlist", Playlist?.self, arguments: ["id": .variable("playlistId")]),
    ] }

    /// Retrieves a specific playlist.
    public var playlist: Playlist? { __data["playlist"] }

    /// Playlist
    ///
    /// Parent Type: `Playlist`
    public struct Playlist: MusicHelperAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MusicHelperAPI.Objects.Playlist }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", MusicHelperAPI.ID.self),
        .field("description", String?.self),
        .field("name", String.self),
        .field("tracks", [Track].self),
      ] }

      /// The ID for the playlist.
      public var id: MusicHelperAPI.ID { __data["id"] }
      /// Describes the playlist, what to expect and entices the user to listen.
      public var description: String? { __data["description"] }
      /// The name of the playlist.
      public var name: String { __data["name"] }
      /// The tracks in the playlist.
      public var tracks: [Track] { __data["tracks"] }

      /// Playlist.Track
      ///
      /// Parent Type: `Track`
      public struct Track: MusicHelperAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MusicHelperAPI.Objects.Track }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("durationMs", Int.self),
          .field("explicit", Bool.self),
          .field("id", MusicHelperAPI.ID.self),
          .field("name", String.self),
          .field("uri", String.self),
        ] }

        /// The track length in milliseconds.
        public var durationMs: Int { __data["durationMs"] }
        /// Whether or not the track has explicit lyrics (true = yes it does; false = no it does not OR unknown)
        public var explicit: Bool { __data["explicit"] }
        /// The ID for the track.
        public var id: MusicHelperAPI.ID { __data["id"] }
        /// The name of the track.
        public var name: String { __data["name"] }
        /// The URI for the track, usually a Spotify link.
        public var uri: String { __data["uri"] }
      }
    }
  }
}
