import AppKit
@testable import Mackasten
import XCTest

final class SourceAppContentTests: XCTestCase {
    func testEmptyListShowsPlaceholder() {
        let items = SourceAppContent.menuItems(
            from: [MailMessage](),
            rowSymbolName: "envelope",
            emptyPlaceholder: "No flagged mail"
        )
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].title, "No flagged mail")
        XCTAssertFalse(items[0].isEnabled)
    }

    func testMailRowCarriesSubjectIconAndStringId() {
        let items = SourceAppContent.menuItems(
            from: [MailMessage(id: 42, subject: "Pay quarterly taxes")],
            rowSymbolName: "envelope",
            emptyPlaceholder: "No flagged mail"
        )
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].title, "Pay quarterly taxes")
        XCTAssertNotNil(items[0].image)
        XCTAssertEqual(items[0].representedObject as? String, "42")
        XCTAssertFalse(items[0].isEnabled)
    }

    func testReminderRowCarriesTitleIconAndStringId() {
        let items = SourceAppContent.menuItems(
            from: [ReminderItem(id: "abc", title: "Review PR #42")],
            rowSymbolName: "circle",
            emptyPlaceholder: "No reminders requiring focus"
        )
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].title, "Review PR #42")
        XCTAssertNotNil(items[0].image)
        XCTAssertEqual(items[0].representedObject as? String, "abc")
        XCTAssertFalse(items[0].isEnabled)
    }

    func testRowsAreEnabledAndWiredWhenOnSelectIsProvided() {
        final class StubHandler: NSObject {
            @objc func openItem(_: Any?) {}
        }
        let handler = StubHandler()
        let onSelect = MenuItemAction(target: handler, selector: #selector(StubHandler.openItem(_:)))
        let items = SourceAppContent.menuItems(
            from: [MailMessage(id: 1, subject: "x")],
            rowSymbolName: "envelope",
            emptyPlaceholder: "—",
            onSelect: onSelect
        )

        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(items[0].isEnabled)
        XCTAssertEqual(items[0].action, #selector(StubHandler.openItem(_:)))
        XCTAssertTrue(items[0].target === handler)
    }
}
