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

    func testConstants() {
        let shapeSource = MGLShapeSource(identifier: "test", shape: nil, options: nil)
        let circleStyleLayer = MGLCircleStyleLayer(identifier: "circleLayer", source: shapeSource)

        var circleTranslationOne = CGVector(dx: 100, dy: 0)
        let circleTranslationValueOne = NSValue(bytes: &circleTranslationOne, objCType: "{CGVector=dd}")

        // non-data-driven constant
        let expectedValue = MGLStyleValue<NSValue>(rawValue: circleTranslationValueOne)
        circleStyleLayer.circleTranslation = expectedValue
        XCTAssertEqual(circleStyleLayer.circleTranslation, expectedValue)
    }

    func testDeprecatedFunctions() {
        let shapeSource = MGLShapeSource(identifier: "test", shape: nil, options: nil)
        let symbolStyleLayer = MGLSymbolStyleLayer(identifier: "symbolLayer", source: shapeSource)

        // deprecated function, stops with float values
        let iconHaloBlurStyleValue = MGLStyleValue<NSNumber>(interpolationBase: 1.0, stops: [1: MGLStyleValue(rawValue: 0),
                                                                                             2: MGLStyleValue(rawValue: 1),
                                                                                             3: MGLStyleValue(rawValue: 2),
                                                                                             4: MGLStyleValue(rawValue: 3)])
        symbolStyleLayer.iconHaloBlur = iconHaloBlurStyleValue
        XCTAssertEqual(symbolStyleLayer.iconHaloBlur!, iconHaloBlurStyleValue)

        // deprecated function, stops with boolean values
        let stops: [NSNumber: MGLStyleValue<NSNumber>] = [
            1: MGLStyleValue(rawValue: true),
            2: MGLStyleValue(rawValue: false),
            3: MGLStyleValue(rawValue: true),
            4: MGLStyleValue(rawValue: false),
            ]
        let iconAllowsOverlapStyleValue = MGLStyleValue<NSNumber>(interpolationBase: 1, stops: stops)
        symbolStyleLayer.iconAllowsOverlap = iconAllowsOverlapStyleValue
        // iconAllowsOverlap is boolean so mgl and mbgl conversions will coerce the developers stops into interval stops
        let expectedIconAllowsOverlapStyleValue = MGLStyleValue.cameraFunctionValue(with: .interval, stops: stops, options: nil)
        XCTAssertEqual(symbolStyleLayer.iconAllowsOverlap, expectedIconAllowsOverlapStyleValue)
    }

    func testFunctions() {
        let shapeSource = MGLShapeSource(identifier: "test", shape: nil, options: nil)
        let circleStyleLayer = MGLCircleStyleLayer(identifier: "circleLayer", source: shapeSource)

        var circleTranslationOne = CGVector(dx: 100, dy: 0)
        let circleTranslationValueOne = NSValue(bytes: &circleTranslationOne, objCType: "{CGVector=dd}")
        var circleTranslationTwo = CGVector(dx: 0, dy: 0)
        let circleTranslationValueTwo = NSValue(bytes: &circleTranslationTwo, objCType: "{CGVector=dd}")

        let circleTranslationStops = [
            0: MGLStyleValue(rawValue: circleTranslationValueOne),
            10: MGLStyleValue(rawValue: circleTranslationValueTwo)
        ]
        let expectedCircleTranslationValue = MGLStyleValue<NSValue>.cameraFunctionValue(with: .interval, stops: circleTranslationStops, options: nil)
        circleStyleLayer.circleTranslation = expectedCircleTranslationValue
        XCTAssertEqual(circleStyleLayer.circleTranslation, expectedCircleTranslationValue)
    }
}
