// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class AddSongToPlaylistMutation: GraphQLMutation {
  public static let operationName: String = "addSongToPlaylist"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation addSongToPlaylist($input: AddItemsToPlaylistInput!) { addItemsToPlaylist(input: $input) { __typename code message success } }"#
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
        .field("success", Bool.self),
      ] }

      /// Similar to HTTP status code, represents the status of the mutation.
      public var code: Int { __data["code"] }
      /// Human-readable message for the UI.
      public var message: String { __data["message"] }
      /// Indicates whether the mutation was successful.
      public var success: Bool { __data["success"] }
    }
  }
}
