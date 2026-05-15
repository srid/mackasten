import AppKit
@testable import Mackasten
import XCTest

final class FlaggedMailContentTests: XCTestCase {
    func testUsesFlagIconAndAccessibilityDescription() {
        let content = FlaggedMailContent.make(from: [])
        XCTAssertEqual(content.symbolName, FlaggedMailContent.symbolName)
        XCTAssertEqual(content.accessibilityDescription, FlaggedMailContent.accessibilityDescription)
    }

    func testEmptyListShowsPlaceholder() {
        let items = FlaggedMailContent.make(from: []).menuItems
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].title, FlaggedMailContent.emptyPlaceholder)
        XCTAssertFalse(items[0].isEnabled)
    }

    func testPopulatedListShowsEachSubjectAsDisabledItem() {
        let mails = [
            MailMessage(subject: "Pay quarterly taxes"),
            MailMessage(subject: "Review PR #42"),
        ]
        let items = FlaggedMailContent.make(from: mails).menuItems
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].title, "Pay quarterly taxes")
        XCTAssertFalse(items[0].isEnabled)
        XCTAssertEqual(items[1].title, "Review PR #42")
        XCTAssertFalse(items[1].isEnabled)
    }

    func testFooterIsAppendedAfterMailItems() {
        let footer = [NSMenuItem.separator(), NSMenuItem(title: "Quit", action: nil, keyEquivalent: "q")]
        let items = FlaggedMailContent.make(from: [MailMessage(subject: "x")], footer: footer).menuItems
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items[0].title, "x")
        XCTAssertTrue(items[1].isSeparatorItem)
        XCTAssertEqual(items[2].title, "Quit")
    }
}
