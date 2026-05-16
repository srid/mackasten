import AppKit
@testable import Mackasten
import XCTest

final class FlaggedMailContentTests: XCTestCase {
    func testEmptyListShowsPlaceholder() {
        let items = FlaggedMailContent.menuItems(from: [])
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items[0].title, FlaggedMailContent.emptyPlaceholder)
        XCTAssertFalse(items[0].isEnabled)
    }

    func testPopulatedListShowsEachSubjectAsDisabledRowWithIcon() {
        let mails = [
            MailMessage(id: 1, subject: "Pay quarterly taxes"),
            MailMessage(id: 2, subject: "Review PR #42"),
        ]
        let items = FlaggedMailContent.menuItems(from: mails)
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
            @objc func openMessage(_: Any?) {}
        }
        let handler = StubHandler()
        let onSelect = MenuItemAction(target: handler, selector: #selector(StubHandler.openMessage(_:)))
        let items = FlaggedMailContent.menuItems(
            from: [MailMessage(id: 42, subject: "subject")],
            onSelect: onSelect
        )

        XCTAssertEqual(items.count, 1)
        XCTAssertTrue(items[0].isEnabled)
        XCTAssertEqual(items[0].action, #selector(StubHandler.openMessage(_:)))
        XCTAssertTrue(items[0].target === handler)
        XCTAssertEqual(items[0].representedObject as? Int, 42)
        XCTAssertNotNil(items[0].image)
    }
}
