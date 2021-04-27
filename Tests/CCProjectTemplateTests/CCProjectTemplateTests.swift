import XCTest
@testable import CCProjectTemplate

final class CCProjectTemplateTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//        XCTAssertEqual(CCProjectTemplate().text, "Hello, World!")
        CCPrint.debug(Bundle.cc)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
    
    /**
     测试输出日志
     */
    func testCCPrintLog() {
        
        CCPrint.debug("123")
        CCPrint.debug(1)
        CCPrint.debug(false)
        CCPrint.debug(["aa", "bb"])
        CCPrint.debug(["key":"Value"])
    }
}
