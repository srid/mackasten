@testable import Mackasten
import XCTest

final class MenuBarTests: XCTestCase {
    func testTitleIsHelloWorld() {
        XCTAssertEqual(MenuBar.title, "Hello World")
    }

    func testIconUsesChecklistSymbol() {
        XCTAssertEqual(MenuBar.symbolName, "checklist")
    }
}
