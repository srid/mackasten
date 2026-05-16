import AppKit
@testable import Mackasten
import XCTest

final class FlaggedReminderContentTests: XCTestCase {
    func testEmptyListShowsPlaceholder() {
        let items = FlaggedReminderContent.menuItems(from: [])
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].title, FlaggedReminderContent.emptyPlaceholder)
        XCTAssertFalse(items[0].isEnabled)
    }

    func testPopulatedListShowsEachTitleAsDisabledRowWithIcon() {
        let reminders = [
            ReminderItem(id: "r1", title: "Pay quarterly taxes"),
            ReminderItem(id: "r2", title: "Review PR #42"),
        ]
        let items = FlaggedReminderContent.menuItems(from: reminders)
        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].title, "Pay quarterly taxes")
        XCTAssertFalse(items[0].isEnabled)
        XCTAssertNotNil(items[0].image)
        XCTAssertEqual(items[1].title, "Review PR #42")
        XCTAssertFalse(items[1].isEnabled)
        XCTAssertNotNil(items[1].image)
    }

    func testItemsAreEnabledAndWiredWhenOnSelectIsProvided() {
        final class StubHandler: NSObject {
            @objc func openReminder(_: Any?) {}
        }
        let handler = StubHandler()
        let onSelect = MenuItemAction(target: handler, selector: #selector(StubHandler.openReminder(_:)))
        let items = FlaggedReminderContent.menuItems(
            from: [ReminderItem(id: "abc", title: "title")],
            onSelect: onSelect
        )

        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(items[0].isEnabled)
        XCTAssertEqual(items[0].action, #selector(StubHandler.openReminder(_:)))
        XCTAssertTrue(items[0].target === handler)
        XCTAssertEqual(items[0].representedObject as? String, "abc")
        XCTAssertNotNil(items[0].image)
    }
}
