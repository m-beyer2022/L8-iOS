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
        app.buttons["Sign in with Apple"].tap()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        app.terminate()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    func testExample() throws {
        // Wait for main view to load
        XCTAssert(app.navigationBars["Music App"].waitForExistence(timeout: 5))

        // Verify navigation title exists
        XCTAssert(app.navigationBars["Music App"].exists)

        // Verify "Featured Playlists" section exists
        XCTAssert(app.staticTexts["FEATURED PLAYLISTS"].exists)

        // Verify "Tracks" section exists
        XCTAssert(app.staticTexts["TRACKS"].exists)
    }

    func testNavigationToAllTracks() {
        // Wait for main view to load
        XCTAssert(app.navigationBars["Music App"].waitForExistence(timeout: 5))

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
        // Wait for main view to load
        XCTAssert(app.navigationBars["Music App"].waitForExistence(timeout: 5))

        // Pull to refresh
        let firstCell = app.cells.firstMatch
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.1))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.9))
        start.press(forDuration: 0.1, thenDragTo: finish)
    }
    
    func testSearchFunctionality() {
        // Wait for main view to load
        XCTAssert(app.navigationBars["Music App"].waitForExistence(timeout: 5))

        // Verify initial state
        XCTAssert(app.staticTexts["Test Playlist"].exists)
        XCTAssert(app.staticTexts["Mock playlist for UI tests"].exists)
                                                                                                                                                                                                                        
        // Tap the search field
        let searchField = app.searchFields["Search playlists"]
        XCTAssert(searchField.exists)
        searchField.tap()
                                                                                                                                                                                                                        
        // Search for "Test" (should match the mock playlist)
        searchField.typeText("Test")
                                                                                                                                                                                                                        
        // Verify only matching playlist is shown
        XCTAssert(app.staticTexts["Test Playlist"].exists)
        XCTAssertFalse(app.staticTexts["Another Playlist"].exists) // Negative test
                                                                                                                                                                                                                        
        // Clear search
        app.buttons["Clear text"].tap()
                                                                                                                                                                                                                        
        // Search for "Mock" in description
        searchField.typeText("Mock")
                                                                                                                                                                                                                        
        // Verify playlist with matching description is shown
        XCTAssert(app.staticTexts["Test Playlist"].exists)
        XCTAssert(app.staticTexts["Mock playlist for UI tests"].exists)
                                                                                                                                                                                                                        
        // Test case insensitivity
        app.buttons["Clear text"].tap()
        searchField.typeText("test")
        XCTAssert(app.staticTexts["Test Playlist"].exists)
                                                                                                                                                                                                                        
        // Clear search to return to initial state
        app.buttons["Clear text"].tap()
        XCTAssert(app.staticTexts["Chill Vibes"].exists)
    }

    func testPlaylistDetailView() {
        // Wait for main view to load
        XCTAssert(app.navigationBars["Music App"].waitForExistence(timeout: 5))

        // Verify mock playlist exists
        XCTAssert(app.staticTexts["Test Playlist"].waitForExistence(timeout: 5))

        // Tap on the mock playlist
        app.staticTexts["Test Playlist"].tap()

        // Verify we're on detail view
        XCTAssert(app.staticTexts["Test Playlist"].exists) // Navigation title
        XCTAssert(app.staticTexts["Mock playlist for UI tests"].exists) // Description

        // Verify track count and duration
        let infoText = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'tracks •'")).firstMatch
        XCTAssert(infoText.exists)
        XCTAssert(infoText.label.contains("2 tracks")) // From mock data

        // Verify track list
        XCTAssert(app.staticTexts["Test Track 1"].exists)
        XCTAssert(app.staticTexts["Test Track 2"].exists)

        // Verify explicit indicator
        let explicitTracks = app.images.matching(identifier: "e.square.fill")
        XCTAssertEqual(explicitTracks.count, 1) // Only 1 explicit track in mock data

        // Test back navigation
        app.navigationBars.buttons["Music App"].tap()
        XCTAssert(app.navigationBars["Music App"].exists) // Verify we're back
    }

    func testAddTrackToPlaylistFlow() {
        // Wait for main view to load
        XCTAssert(app.navigationBars["Music App"].waitForExistence(timeout: 5))

        // Navigate to playlist detail (using the new mock data)
        app.staticTexts["Popular Now"].tap()

        // Verify we're on detail view
        XCTAssert(app.staticTexts["Popular Now"].exists)
        XCTAssert(app.staticTexts["Top Hits 2023"].exists)

        // Tap add button on first track
        let firstAddButton = app.buttons.matching(identifier: "Open add to Playlist").firstMatch
        XCTAssert(firstAddButton.waitForExistence(timeout: 1))
        firstAddButton.tap()
//        firstAddButton.tap()
//
//        // Select a playlist from the picker
//        app.pickerWheels.firstMatch.adjust(toPickerWheelValue: "Workout Mix")
//
//        // Tap the Add button
//        app.buttons["Add to Playlist"].tap()
//
//        // Verify we returned to detail view
//        XCTAssert(app.staticTexts["Popular Now"].exists)
    }

        // Note: In a real test, you'd want to verify the track was added
        // This would require either:
        // 1. Mocking the addTrack response in Repository
        // 2. Checking for a success alert
}
