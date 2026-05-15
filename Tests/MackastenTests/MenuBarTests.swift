import AppKit
@testable import Mackasten
import XCTest

final class MenuBarTests: XCTestCase {
    func testInstallReflectsContentOnStatusItem() {
        let probeItem = NSMenuItem(title: "probe", action: nil, keyEquivalent: "")
        let content = MenuBarContent(
            symbolName: "checklist",
            accessibilityDescription: "probe-desc",
            menuItems: [probeItem]
        )

        let item = MenuBar.install(content)

        XCTAssertNotNil(item.button?.image)
        XCTAssertEqual(item.button?.image?.accessibilityDescription, "probe-desc")
        XCTAssertEqual(item.menu?.items.count, 1)
        XCTAssertEqual(item.menu?.items.first?.title, "probe")
    }
}
