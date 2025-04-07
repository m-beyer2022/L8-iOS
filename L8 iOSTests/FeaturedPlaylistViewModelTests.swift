//
//  FeaturedPlaylistViewModelTests.swift
//  L8 iOSTests
//
//  Created by Moritz Beyer on 07.04.25.
//

import Testing
import Foundation
@testable import L8_iOS

struct FeaturedPlaylistViewModelTests {

    // MARK: - Test Data
    private let mockPlaylists = [
        Playlist(
            id: "1",
            description: "Test Playlist 1",
            name: "Playlist 1",
            tracks: [
                Track(id: "1", durationMs: 180000, explicit:
                        false, name: "Track 1", uri: "spotify:track:1"),
                Track(id: "2", durationMs: 240000, explicit:
                        true, name: "Track 2", uri: "spotify:track:2")
            ]
        ),
        Playlist(
            id: "2",
            description: "Test Playlist 2",
            name: "Playlist 2",
            tracks: [
                Track(id: "3", durationMs: 210000, explicit:
                        false, name: "Track 3", uri: "spotify:track:3")
            ]
        )
    ]

    private let mockError = NSError(domain: "TestError",
                                    code: 123, userInfo: nil)

    //    private let urlError = URLError(.badServerResponse)

    // MARK: - Mock Repository
    class MockRepository: RepositoryProtocol {
        var shouldSucceed: Bool
        var mockPlaylists: [Playlist]
        var mockError: Error

        init(shouldSucceed: Bool, mockPlaylists: [Playlist],
             mockError: Error) {
            self.shouldSucceed = shouldSucceed
            self.mockPlaylists = mockPlaylists
            self.mockError = mockError
        }

        func fetchFeaturedPlaylistList(completion: @escaping
                                       (Result<[Playlist], Error>) -> Void) {
            if shouldSucceed {
                completion(.success(mockPlaylists))
            } else {
                completion(.failure(mockError))
            }
        }
    }

    // MARK: - Tests

    @Test func testInitialState() async throws {
        let mockRepository = MockRepository(
            shouldSucceed: true,
            mockPlaylists: [],
            mockError: mockError
        )
        let viewModel = FeaturedPlaylistViewModel(repository:
                                                    mockRepository)

        #expect(viewModel.playlists.isEmpty)
        #expect(viewModel.error == nil)
    }

    @Test func testSuccessfulFetch() async throws {
        let mockRepository = MockRepository(
            shouldSucceed: true,
            mockPlaylists: mockPlaylists,
            mockError: mockError
        )
        let viewModel = FeaturedPlaylistViewModel(repository:
                                                    mockRepository)

        // Wait for async operation
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.playlists.count ==
                mockPlaylists.count)
        #expect(viewModel.error == nil)
        #expect(viewModel.playlists.first?.name == "Playlist 1")
    }
    @Test func testFailedFetch() async throws {
        let mockRepository = MockRepository(
            shouldSucceed: false,
            mockPlaylists: mockPlaylists,
            mockError: mockError
        )
        let viewModel = FeaturedPlaylistViewModel(repository:
                                                    mockRepository)

        // Wait for async operation
        try await Task.sleep(nanoseconds: 100_000_000)

        #expect(viewModel.playlists.isEmpty)
        #expect(viewModel.error != nil)
        #expect((viewModel.error! as NSError).code == 123)
    }

    @Test func testAllTracksComputedProperty() async throws {
        let mockRepository = MockRepository(
            shouldSucceed: true,
            mockPlaylists: mockPlaylists,
            mockError: mockError
        )
        let viewModel = FeaturedPlaylistViewModel(repository:
                                                    mockRepository)

        // Wait for async operation
        try await Task.sleep(nanoseconds: 100_000_000)

        let expectedTrackCount = mockPlaylists.reduce(0) { $0
            + $1.tracks.count }
        #expect(viewModel.allTracks.count ==
                expectedTrackCount)
        #expect(viewModel.allTracks.first?.name == "Track 1")
        #expect(viewModel.allTracks.last?.name == "Track 3")
    }

    @Test func testErrorIsNilAfterSuccessfulRetry() async
    throws {
        let failingRepository = MockRepository(
            shouldSucceed: false,
            mockPlaylists: mockPlaylists,
            mockError: mockError
        )
        let viewModel = FeaturedPlaylistViewModel(repository:
                                                    failingRepository)

        // Wait for first (failed) fetch
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(viewModel.error != nil)

        // Change to success case
        let successRepository = MockRepository(
            shouldSucceed: true,
            mockPlaylists: mockPlaylists,
            mockError: mockError
        )
        viewModel.repository = successRepository
        viewModel.fetchPlaylists()

        // Wait for second (successful) fetch
        try await Task.sleep(nanoseconds: 100_000_000)
        #expect(viewModel.error == nil)
        #expect(viewModel.playlists.count ==
                mockPlaylists.count)
    }
}
