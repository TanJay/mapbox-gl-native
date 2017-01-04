import XCTest
import Mapbox


extension MGLStyleValueTests {
    
    func testConstantValues() {
        let shapeSource = MGLShapeSource(identifier: "test", shape: nil, options: nil)
        let symbolStyleLayer = MGLSymbolStyleLayer(identifier: "test", source: shapeSource)
        
        // Boolean
        symbolStyleLayer.iconAllowsOverlap = MGLStyleConstantValue(rawValue: true)
        XCTAssertEqual((symbolStyleLayer.iconAllowsOverlap as! MGLStyleConstantValue<NSNumber>).rawValue, true)
        
        // Number
        symbolStyleLayer.iconHaloWidth = MGLStyleConstantValue(rawValue: 3)
        XCTAssertEqual((symbolStyleLayer.iconHaloWidth as! MGLStyleConstantValue<NSNumber>).rawValue, 3)
        
        // String
        symbolStyleLayer.text = MGLStyleConstantValue(rawValue: "{name}")
        XCTAssertEqual((symbolStyleLayer.text as! MGLStyleConstantValue<NSString>).rawValue, "{name}")
    }
    
    func testFunctions() {
        let shapeSource = MGLShapeSource(identifier: "test", shape: nil, options: nil)
        let symbolStyleLayer = MGLSymbolStyleLayer(identifier: "test", source: shapeSource)

        let value = MGLStyleValue<NSNumber>(interpolationBase: 1.0, stops: [1: MGLStyleValue(rawValue: 0),
                                                                            2: MGLStyleValue(rawValue: 1),
                                                                            3: MGLStyleValue(rawValue: 2),
                                                                            4: MGLStyleValue(rawValue: 3)])
        symbolStyleLayer.iconHaloBlur = value
        XCTAssertEqual(symbolStyleLayer.iconHaloBlur!, value)
    }
}
