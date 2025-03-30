// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PlaylistDescriptionQuery: GraphQLQuery {
  public static let operationName: String = "PlaylistDescription"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PlaylistDescription { featuredPlaylists { __typename description } }"#
    ))

  public init() {}

  public struct Data: MusicHelperAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { MusicHelperAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("featuredPlaylists", [FeaturedPlaylist].self),
    ] }

    /// Playlists hand-picked to be featured to all users.
    public var featuredPlaylists: [FeaturedPlaylist] { __data["featuredPlaylists"] }

    /// FeaturedPlaylist
    ///
    /// Parent Type: `Playlist`
    public struct FeaturedPlaylist: MusicHelperAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { MusicHelperAPI.Objects.Playlist }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("description", String?.self),
      ] }

      /// Describes the playlist, what to expect and entices the user to listen.
      public var description: String? { __data["description"] }
    }
  }
}
