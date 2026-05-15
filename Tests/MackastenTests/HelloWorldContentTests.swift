import AppKit
@testable import Mackasten
import XCTest

final class HelloWorldContentTests: XCTestCase {
    func testContentHasChecklistIcon() {
        let content = HelloWorldContent.make()
        XCTAssertEqual(content.symbolName, "checklist")
        XCTAssertEqual(content.accessibilityDescription, "Mackasten")
    }

    func testContentHasTitleSeparatorAndQuit() {
        let items = HelloWorldContent.make().menuItems
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items[0].title, "Hello World")
        XCTAssertTrue(items[1].isSeparatorItem)
        XCTAssertEqual(items[2].title, "Quit")
        XCTAssertEqual(items[2].action, #selector(NSApplication.terminate(_:)))
        XCTAssertEqual(items[2].keyEquivalent, "q")
    }
}
