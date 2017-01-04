// This file is generated.
// Edit platform/darwin/scripts/generate-style-code.js, then run `make darwin-style-code`.

#import "MGLStyleLayerTests.h"

#import "MGLStyleLayer_Private.h"

#include <mbgl/style/layers/background_layer.hpp>

@interface MGLBackgroundLayerTests : MGLStyleLayerTests
@end

@implementation MGLBackgroundLayerTests

+ (NSString *)layerType {
    return @"background";
}

- (void)testProperties {
    MGLBackgroundStyleLayer *layer = [[MGLBackgroundStyleLayer alloc] initWithIdentifier:@"layerID"];
    XCTAssertNotEqual(layer.rawLayer, nullptr);
    XCTAssertTrue(layer.rawLayer->is<mbgl::style::BackgroundLayer>());
    auto rawLayer = layer.rawLayer->as<mbgl::style::BackgroundLayer>();

    // background-color
    {
        XCTAssertTrue(rawLayer->getBackgroundColor().isUndefined(),
                      @"background-color should be unset initially.");
        MGLStyleValue<MGLColor *> *defaultStyleValue = layer.backgroundColor;

        MGLStyleValue<MGLColor *> *styleValue = [MGLStyleValue<MGLColor *> valueWithRawValue:[MGLColor redColor]];
        layer.backgroundColor = styleValue;
        mbgl::style::PropertyValue<mbgl::Color> propertyValue = { { 1, 0, 0, 1 } };
        XCTAssertEqual(rawLayer->getBackgroundColor(), propertyValue,
                       @"Setting backgroundColor to a constant value should update background-color.");
        XCTAssertEqualObjects(layer.backgroundColor, styleValue,
                              @"backgroundColor should round-trip constant values.");

        styleValue = [MGLStyleValue<MGLColor *> cameraFunctionValueWithStopType:MGLStyleFunctionStopTypeInterval
                                                                                             stops:@{@18: styleValue}
                                                                                           options:nil];        
        layer.backgroundColor = styleValue;

        mbgl::style::IntervalStops<mbgl::Color> intervalStops = { {{18, { 1, 0, 0, 1 }}} };
        propertyValue = mbgl::style::CameraFunction<mbgl::Color> { intervalStops };
        
        XCTAssertEqual(rawLayer->getBackgroundColor(), propertyValue,
                       @"Setting backgroundColor to a function should update background-color.");
        XCTAssertEqualObjects(layer.backgroundColor, styleValue,
                              @"backgroundColor should round-trip functions.");

        layer.backgroundColor = nil;
        XCTAssertTrue(rawLayer->getBackgroundColor().isUndefined(),
                      @"Unsetting backgroundColor should return background-color to the default value.");
        XCTAssertEqualObjects(layer.backgroundColor, defaultStyleValue,
                              @"backgroundColor should return the default value after being unset.");
    }

    // background-opacity
    {
        XCTAssertTrue(rawLayer->getBackgroundOpacity().isUndefined(),
                      @"background-opacity should be unset initially.");
        MGLStyleValue<NSNumber *> *defaultStyleValue = layer.backgroundOpacity;

        MGLStyleValue<NSNumber *> *styleValue = [MGLStyleValue<NSNumber *> valueWithRawValue:@0xff];
        layer.backgroundOpacity = styleValue;
        mbgl::style::PropertyValue<float> propertyValue = { 0xff };
        XCTAssertEqual(rawLayer->getBackgroundOpacity(), propertyValue,
                       @"Setting backgroundOpacity to a constant value should update background-opacity.");
        XCTAssertEqualObjects(layer.backgroundOpacity, styleValue,
                              @"backgroundOpacity should round-trip constant values.");

        styleValue = [MGLStyleValue<NSNumber *> cameraFunctionValueWithStopType:MGLStyleFunctionStopTypeInterval
                                                                                             stops:@{@18: styleValue}
                                                                                           options:nil];        
        layer.backgroundOpacity = styleValue;

        mbgl::style::IntervalStops<float> intervalStops = { {{18, 0xff}} };
        propertyValue = mbgl::style::CameraFunction<float> { intervalStops };
        
        XCTAssertEqual(rawLayer->getBackgroundOpacity(), propertyValue,
                       @"Setting backgroundOpacity to a function should update background-opacity.");
        XCTAssertEqualObjects(layer.backgroundOpacity, styleValue,
                              @"backgroundOpacity should round-trip functions.");

        layer.backgroundOpacity = nil;
        XCTAssertTrue(rawLayer->getBackgroundOpacity().isUndefined(),
                      @"Unsetting backgroundOpacity should return background-opacity to the default value.");
        XCTAssertEqualObjects(layer.backgroundOpacity, defaultStyleValue,
                              @"backgroundOpacity should return the default value after being unset.");
    }

    // background-pattern
    {
        XCTAssertTrue(rawLayer->getBackgroundPattern().isUndefined(),
                      @"background-pattern should be unset initially.");
        MGLStyleValue<NSString *> *defaultStyleValue = layer.backgroundPattern;

        MGLStyleValue<NSString *> *styleValue = [MGLStyleValue<NSString *> valueWithRawValue:@"Background Pattern"];
        layer.backgroundPattern = styleValue;
        mbgl::style::PropertyValue<std::string> propertyValue = { "Background Pattern" };
        XCTAssertEqual(rawLayer->getBackgroundPattern(), propertyValue,
                       @"Setting backgroundPattern to a constant value should update background-pattern.");
        XCTAssertEqualObjects(layer.backgroundPattern, styleValue,
                              @"backgroundPattern should round-trip constant values.");

        styleValue = [MGLStyleValue<NSString *> cameraFunctionValueWithStopType:MGLStyleFunctionStopTypeInterval
                                                                                             stops:@{@18: styleValue}
                                                                                           options:nil];        
        layer.backgroundPattern = styleValue;

        mbgl::style::IntervalStops<std::string> intervalStops = { {{18, "Background Pattern"}} };
        propertyValue = mbgl::style::CameraFunction<std::string> { intervalStops };
        
        XCTAssertEqual(rawLayer->getBackgroundPattern(), propertyValue,
                       @"Setting backgroundPattern to a function should update background-pattern.");
        XCTAssertEqualObjects(layer.backgroundPattern, styleValue,
                              @"backgroundPattern should round-trip functions.");

        layer.backgroundPattern = nil;
        XCTAssertTrue(rawLayer->getBackgroundPattern().isUndefined(),
                      @"Unsetting backgroundPattern should return background-pattern to the default value.");
        XCTAssertEqualObjects(layer.backgroundPattern, defaultStyleValue,
                              @"backgroundPattern should return the default value after being unset.");
    }
}

- (void)testPropertyNames {
    [self testPropertyName:@"background-color" isBoolean:NO];
    [self testPropertyName:@"background-opacity" isBoolean:NO];
    [self testPropertyName:@"background-pattern" isBoolean:NO];
}

@end
