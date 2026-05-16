import AppKit
@testable import Mackasten
import XCTest

final class MenuBarTests: XCTestCase {
    func testInstallReflectsSingleContentOnStatusItem() {
        let probeItem = NSMenuItem(title: "probe", action: nil, keyEquivalent: "")
        let content = MenuBarContent(
            symbolName: "checklist",
            accessibilityDescription: "probe-desc",
            menuItems: [probeItem]
        )

        let items = MenuBar.install([content])

        XCTAssertEqual(items.count, 1)
        XCTAssertNotNil(items[0].button?.image)
        XCTAssertEqual(items[0].button?.image?.accessibilityDescription, "probe-desc")
        XCTAssertEqual(items[0].menu?.items.count, 1)
        XCTAssertEqual(items[0].menu?.items.first?.title, "probe")
    }

    func testInstallPlacesEachContentOnItsOwnStatusItem() {
        let mailItem = NSMenuItem(title: "mail-probe", action: nil, keyEquivalent: "")
        let mailContent = MenuBarContent(
            symbolName: "flag",
            accessibilityDescription: "mail-desc",
            menuItems: [mailItem]
        )
        let reminderItem = NSMenuItem(title: "reminder-probe", action: nil, keyEquivalent: "")
        let reminderContent = MenuBarContent(
            symbolName: "checklist",
            accessibilityDescription: "reminder-desc",
            menuItems: [reminderItem]
        )

        let items = MenuBar.install([mailContent, reminderContent])

        XCTAssertEqual(items.count, 2)
        XCTAssertEqual(items[0].button?.image?.accessibilityDescription, "mail-desc")
        XCTAssertEqual(items[0].menu?.items.first?.title, "mail-probe")
        XCTAssertEqual(items[1].button?.image?.accessibilityDescription, "reminder-desc")
        XCTAssertEqual(items[1].menu?.items.first?.title, "reminder-probe")
    }
}
