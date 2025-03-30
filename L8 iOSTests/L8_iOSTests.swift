//
//  L8_iOSTests.swift
//  L8 iOSTests
//
//  Created by Moritz Beyer on 26.03.25.
//

import Foundation
import Testing
import Apollo
@testable import MusicHelperAPI


struct L8_iOSTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        class Network {
          static let shared = Network()

          private(set) lazy var apollo = ApolloClient(url: URL(string: "http://127.0.0.1:8000")!)
        }

        Network.shared.apollo.fetch(query: PlaylistDescriptionQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                print("Success! Result: \(graphQLResult)")
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
    }
}
