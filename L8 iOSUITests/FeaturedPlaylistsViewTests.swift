//
//  FeaturedPlaylistsViewTests.swift
//  L8 iOSUITests
//
//  Created by Moritz Beyer on 07.04.25.
//

import XCTest
import Foundation

final class FeaturedPlaylistsViewTests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITesting")
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        app.terminate()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    func testMockPlaylistAppears() {
        XCTAssert(app.staticTexts["Test Playlist"].waitForExistence(timeout: 1))
    }

    func testExample() throws {

        // Verify navigation title exists
        XCTAssert(app.navigationBars["Music App"].exists)

        // Verify "Featured Playlists" section exists
        XCTAssert(app.staticTexts["Featured Playlists"].exists)

        // Verify "Tracks" section exists
        XCTAssert(app.staticTexts["Tracks"].exists)
    }

    func testNavigationToAllTracks() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        // Tap the "Show All Tracks" link
        app.staticTexts["Show All Tracks"].tap()

        // Verify we navigated to All Tracks view
        XCTAssert(app.navigationBars["All Tracks"].exists)

        // Go back
        app.navigationBars.buttons["Music App"].tap()
    }

    func testPlaylistNavigation() {
        // Assuming there's at least one playlist
        let firstPlaylist =
        app.staticTexts.matching(identifier: "playlist.name").firstMatch
        if firstPlaylist.exists {
            firstPlaylist.tap()

            // Verify we're on playlist detail view
            XCTAssert(app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'tracks •'")).firstMatch.exists)

            // Go back
            app.navigationBars.buttons["Music App"].tap()
        }
    }

    func testPullToRefresh() {
        // Pull to refresh
        let firstCell = app.cells.firstMatch
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        start.press(forDuration: 0.1, thenDragTo: finish)
    }
}
