import XCTest
import SwiftGodotTestability
@testable import SwiftGodot

final class SnappingTests: GodotTestCase {
    override static func godotSetUp () {
        registerTypes ()
    }
    
    func testSnapDouble() {
        XCTAssertEqual(Double(1008).snapped(step: 1000), 1000)
        XCTAssertEqual(Double(4023).snapped(step: 1000), 4000)
        XCTAssertEqual(Double(128).snapped(step: 128), 128)
        XCTAssertEqual(Double(128).snapped(step: 200), 0)
    }
    
    func testSnapFloat() {
        XCTAssertEqual(Float(1008).snapped(step: 1000), 1000)
        XCTAssertEqual(Float(4023).snapped(step: 1000), 4000)
        XCTAssertEqual(Float(128).snapped(step: 128), 128)
        XCTAssertEqual(Float(128).snapped(step: 200), 0)
    }
    
    func testSnapInt() {
        XCTAssertEqual(Int(1008).snapped(step: 1000), 1000)
        XCTAssertEqual(Int(4023).snapped(step: 1000), 4000)
        XCTAssertEqual(Int(128).snapped(step: 128), 128)
        XCTAssertEqual(Int(128).snapped(step: 200), 0)
    }
    
    func testSnapVector4() {
        XCTAssertEqual(Vector4(x: 1008, y: 1008, z: 1008, w: 1008)
            .snapped(step: Vector4(x: 1000, y: 1000, z: 1000, w: 1000)),
                       Vector4(x: 1000, y: 1000, z: 1000, w: 1000))
        XCTAssertEqual(Vector4(x: 4023, y: 4023, z: 4023, w: 4023)
            .snapped(step: Vector4(x: 1000, y: 1000, z: 1000, w: 1000)),
                       Vector4(x: 4000, y: 4000, z: 4000, w: 4000))
        XCTAssertEqual(Vector4(x: 128, y: 128, z: 128, w: 128)
            .snapped(step: Vector4(x: 128, y: 128, z: 128, w: 128)),
                       Vector4(x: 128, y: 128, z: 128, w: 128))
        XCTAssertEqual(Vector4(x: 128, y: 128, z: 128, w: 128)
            .snapped(step: Vector4(x: 1000, y: 1000, z: 1000, w: 1000)),
                       Vector4(x: 0, y: 0, z: 0, w: 0))
    }
    
    func testSnapVector3() {
        XCTAssertEqual(Vector3(x: 1008, y: 1008, z: 1008)
            .snapped(step: Vector3(x: 1000, y: 1000, z: 1000)), Vector3(x: 1000, y: 1000, z: 1000))
        XCTAssertEqual(Vector3(x: 4023, y: 4023, z: 4023)
            .snapped(step: Vector3(x: 1000, y: 1000, z: 1000)), Vector3(x: 4000, y: 4000, z: 4000))
        XCTAssertEqual(Vector3(x: 128, y: 128, z: 128)
            .snapped(step: Vector3(x: 128, y: 128, z: 128)), Vector3(x: 128, y: 128, z: 128))
        XCTAssertEqual(Vector3(x: 128, y: 128, z: 128)
            .snapped(step: Vector3(x: 1000, y: 1000, z: 1000)), Vector3(x: 0, y: 0, z: 0))
    }
    
    func testSnapVector2() {
        XCTAssertEqual(Vector2(x: 1008, y: 1008)
            .snapped(step: Vector2(x: 1000, y: 1000)), Vector2(x: 1000, y: 1000))
        XCTAssertEqual(Vector2(x: 4023, y: 4023)
            .snapped(step: Vector2(x: 1000, y: 1000)), Vector2(x: 4000, y: 4000))
        XCTAssertEqual(Vector2(x: 128, y: 128)
            .snapped(step: Vector2(x: 128, y: 128)), Vector2(x: 128, y: 128))
        XCTAssertEqual(Vector2(x: 128, y: 128)
            .snapped(step: Vector2(x: 1000, y: 1000)), Vector2(x: 0, y: 0))
    }
}
