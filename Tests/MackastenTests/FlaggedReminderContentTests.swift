import AppKit
@testable import Mackasten
import XCTest

final class FlaggedReminderContentTests: XCTestCase {
    func testUsesChecklistIconAndAccessibilityDescription() {
        let content = FlaggedReminderContent.make(from: [])
        XCTAssertEqual(content.symbolName, FlaggedReminderContent.symbolName)
        XCTAssertEqual(content.accessibilityDescription, FlaggedReminderContent.accessibilityDescription)
    }

    func testEmptyListShowsPlaceholder() {
        let items = FlaggedReminderContent.make(from: []).menuItems
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].title, FlaggedReminderContent.emptyPlaceholder)
        XCTAssertFalse(items[0].isEnabled)
    }

    func testPopulatedListShowsEachTitleAsDisabledItem() {
        let reminders = [
            ReminderItem(id: "r1", title: "Pay quarterly taxes"),
            ReminderItem(id: "r2", title: "Review PR #42"),
        ]
        let items = FlaggedReminderContent.make(from: reminders).menuItems
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].title, "Pay quarterly taxes")
        XCTAssertFalse(items[0].isEnabled)
        XCTAssertEqual(items[1].title, "Review PR #42")
        XCTAssertFalse(items[1].isEnabled)
    }

    func testItemsAreEnabledAndWiredWhenOnSelectIsProvided() {
        final class StubHandler: NSObject {
            @objc func openReminder(_: Any?) {}
        }
        let handler = StubHandler()
        let onSelect = MenuItemAction(target: handler, selector: #selector(StubHandler.openReminder(_:)))
        let items = FlaggedReminderContent.make(
            from: [ReminderItem(id: "abc", title: "title")],
            onSelect: onSelect
        ).menuItems

        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(items[0].isEnabled)
        XCTAssertEqual(items[0].action, #selector(StubHandler.openReminder(_:)))
        XCTAssertTrue(items[0].target === handler)
        XCTAssertEqual(items[0].representedObject as? String, "abc")
    }

    func testFooterIsAppendedAfterReminderItems() {
        let footer = [NSMenuItem.separator(), NSMenuItem(title: "Quit", action: nil, keyEquivalent: "q")]
        let items = FlaggedReminderContent.make(
            from: [ReminderItem(id: "r", title: "x")],
            footer: footer
        ).menuItems
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items[0].title, "x")
        XCTAssertTrue(items[1].isSeparatorItem)
        XCTAssertEqual(items[2].title, "Quit")
    }
}
