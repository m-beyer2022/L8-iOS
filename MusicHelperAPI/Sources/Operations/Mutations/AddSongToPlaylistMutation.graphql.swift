// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AddSongToPlaylistMutation: GraphQLMutation {
  public static let operationName: String = "addSongToPlaylist"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation addSongToPlaylist($input: AddItemsToPlaylistInput!) { addItemsToPlaylist(input: $input) { __typename code message playlist { __typename tracks { __typename durationMs explicit id name uri } } } }"#
    ))

  public var input: AddItemsToPlaylistInput

  public init(input: AddItemsToPlaylistInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: MusicHelperAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MusicHelperAPI.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("addItemsToPlaylist", AddItemsToPlaylist.self, arguments: ["input": .variable("input")]),
    ] }

    /// Add one or more items to a user's playlist.
    public var addItemsToPlaylist: AddItemsToPlaylist { __data["addItemsToPlaylist"] }

    /// AddItemsToPlaylist
    ///
    /// Parent Type: `AddItemsToPlaylistPayload`
    public struct AddItemsToPlaylist: MusicHelperAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MusicHelperAPI.Objects.AddItemsToPlaylistPayload }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("code", Int.self),
        .field("message", String.self),
        .field("playlist", Playlist?.self),
      ] }

      /// Similar to HTTP status code, represents the status of the mutation.
      public var code: Int { __data["code"] }
      /// Human-readable message for the UI.
      public var message: String { __data["message"] }
      /// The playlist that contains the newly added items.
      public var playlist: Playlist? { __data["playlist"] }

      /// AddItemsToPlaylist.Playlist
      ///
      /// Parent Type: `Playlist`
      public struct Playlist: MusicHelperAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { MusicHelperAPI.Objects.Playlist }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("tracks", [Track].self),
        ] }

        /// The tracks in the playlist.
        public var tracks: [Track] { __data["tracks"] }

        /// AddItemsToPlaylist.Playlist.Track
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
}
