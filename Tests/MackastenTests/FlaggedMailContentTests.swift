import AppKit
@testable import Mackasten
import XCTest

final class FlaggedMailContentTests: XCTestCase {
    func testUsesFlagIconAndAccessibilityDescription() {
        let content = FlaggedMailContent.make(from: [])
        XCTAssertEqual(content.symbolName, "flag")
        XCTAssertEqual(content.accessibilityDescription, "Mackasten — Flagged mail")
    }

    func testEmptyListShowsPlaceholderThenSeparatorThenQuit() {
        let items = FlaggedMailContent.make(from: []).menuItems
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items[0].title, "No flagged mail")
        XCTAssertFalse(items[0].isEnabled)
        XCTAssertTrue(items[1].isSeparatorItem)
        XCTAssertEqual(items[2].title, "Quit")
        XCTAssertEqual(items[2].action, #selector(NSApplication.terminate(_:)))
        XCTAssertEqual(items[2].keyEquivalent, "q")
    }

    func testPopulatedListShowsEachSubjectAsDisabledItem() {
        let mails = [
            FlaggedMail(subject: "Pay quarterly taxes"),
            FlaggedMail(subject: "Review PR #42"),
        ]
        let items = FlaggedMailContent.make(from: mails).menuItems
        XCTAssertEqual(items.count, 4)
        XCTAssertEqual(items[0].title, "Pay quarterly taxes")
        XCTAssertFalse(items[0].isEnabled)
        XCTAssertEqual(items[1].title, "Review PR #42")
        XCTAssertFalse(items[1].isEnabled)
        XCTAssertTrue(items[2].isSeparatorItem)
        XCTAssertEqual(items[3].title, "Quit")
    }
}
