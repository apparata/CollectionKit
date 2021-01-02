import XCTest
@testable import CollectionKit

final class CollectionKitTests: XCTestCase {

    func testAllAreTrue() {
        
        struct Object {
            let property: Bool
        }
        
        let allTrue = [
            Object(property: true),
            Object(property: true),
            Object(property: true)
        ]
        
        let oneTrue = [
            Object(property: false),
            Object(property: true),
            Object(property: false)
        ]
        
        let noneTrue = [
            Object(property: false),
            Object(property: false),
            Object(property: false)
        ]
        
        XCTAssertEqual(allTrue.allAreTrue(\.property), true)
        XCTAssertEqual(oneTrue.allAreTrue(\.property), false)
        XCTAssertEqual(noneTrue.allAreTrue(\.property), false)
    }

    func testAnyIsTrue() {
        
        struct Object {
            let property: Bool
        }
        
        let allTrue = [
            Object(property: true),
            Object(property: true),
            Object(property: true)
        ]
        
        let oneTrue = [
            Object(property: false),
            Object(property: true),
            Object(property: false)
        ]
        
        let noneTrue = [
            Object(property: false),
            Object(property: false),
            Object(property: false)
        ]
        
        XCTAssertEqual(allTrue.anyIsTrue(\.property), true)
        XCTAssertEqual(oneTrue.anyIsTrue(\.property), true)
        XCTAssertEqual(noneTrue.anyIsTrue(\.property), false)
    }
    
    func testNoneAreTrue() {
        
        struct Object {
            let property: Bool
        }
        
        let allTrue = [
            Object(property: true),
            Object(property: true),
            Object(property: true)
        ]
        
        let oneTrue = [
            Object(property: false),
            Object(property: true),
            Object(property: false)
        ]
        
        let noneTrue = [
            Object(property: false),
            Object(property: false),
            Object(property: false)
        ]
        
        XCTAssertEqual(allTrue.noneAreTrue(\.property), false)
        XCTAssertEqual(oneTrue.noneAreTrue(\.property), false)
        XCTAssertEqual(noneTrue.noneAreTrue(\.property), true)
    }

    static var allTests = [
        ("testAllAreTrue", testAllAreTrue),
        ("testAnyIsTrue", testAnyIsTrue),
        ("testNoneAreTrue", testNoneAreTrue)
    ]
}
