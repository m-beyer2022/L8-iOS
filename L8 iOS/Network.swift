//
//  Network.swift
//  L8 iOS
//
//  Created by Moritz Beyer on 02.04.25.
//

import Foundation
import Apollo

class Network {
  static let shared = Network()

  private(set) lazy var apollo = ApolloClient(url: URL(string: "http://127.0.0.1:8000")!)
}
