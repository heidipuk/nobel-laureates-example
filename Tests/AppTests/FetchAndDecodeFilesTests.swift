@testable import App
import Vapor
import XCTest

final class FetchAndDecodeFilesTests: XCTestCase {
    func testCorrectFileName() throws {
        let fileName = "femaleNobelLaureates.json"
        XCTAssertNotNil(try Data.fromFile(fileName)) // Success
    }

    func testWrongFileName() throws {
        let fileName = "femaleNobelLaureate.json"
        XCTAssertThrowsError(try Data.fromFile(fileName)) // Success, thrown error: "The file “femaleNobelLaureate.json” couldn’t be opened because there is no such file."
    }

    func testDecodeLaureatesCount() throws {
        let testData = try NobelLaureates.decodeFromData()
        XCTAssertEqual(testData.data.count, 20) // Success, 20 women have received the Nobels price in Physics, Chemistry or Medicine or Physiology
    }

    func testDecodeLaureatesAtIndex() throws {
        let testData = try NobelLaureates.decodeFromData()
        XCTAssertEqual(testData.data[6].fullName, "Rosalyn Sussman Yalow") // Success, the laureate at index 6 in the decoded array is Rosalyn Sussman Yalow
        XCTAssertEqual(testData.data[6].year, 1977) // Success, Rosalyn Sussman Yalow received the price in 1977
    }

    static let allTests = [
        ("testWrongFileName", testWrongFileName),
        ("testCorrectFileName", testCorrectFileName),
        ("testDecodeLaureatesCount", testDecodeLaureatesCount),
        ("testDecodeLaureatesAtIndex", testDecodeLaureatesAtIndex)
    ]
}
