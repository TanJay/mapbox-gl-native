#import "MGLStyleValue_Private.h"

const MGLStyleFunctionOption MGLStyleFunctionOptionInterpolationBase = @"MGLStyleFunctionOptionInterpolationBase";
const MGLStyleFunctionOption MGLStyleFunctionOptionDefaultValue = @"MGLStyleFunctionOptionDefaultValue";

@implementation MGLStyleValue

+ (instancetype)valueWithRawValue:(id)rawValue {
    return [MGLStyleConstantValue valueWithRawValue:rawValue];
}

+ (instancetype)valueWithInterpolationBase:(CGFloat)interpolationBase stops:(NSDictionary *)stops {
    return [MGLCameraStyleFunction functionWithStopType:MGLStyleFunctionStopTypeExponential stops:stops options:@{MGLStyleFunctionOptionInterpolationBase: @(interpolationBase)}];
}

+ (instancetype)valueWithStops:(NSDictionary *)stops {
    return [MGLCameraStyleFunction functionWithStopType:MGLStyleFunctionStopTypeExponential stops:stops options:nil];
}

+ (instancetype)cameraFunctionValueWithStopType:(MGLStyleFunctionStopType)stopType stops:(NSDictionary *)stops options:(NSDictionary *)options {
    return [MGLCameraStyleFunction functionWithStopType:stopType stops:stops options:options];
}

+ (instancetype)sourceFunctionValueWithStopType:(MGLStyleFunctionStopType)stopType stops:(NSDictionary *)stops attributeName:(NSString *)attributeName options:(NSDictionary *)options {
    return [MGLSourceStyleFunction functionWithStopType:stopType stops:stops attributeName:attributeName options:options];
}

+ (instancetype)compositeFunctionValueWithStopType:(MGLStyleFunctionStopType)stopType stops:(NSDictionary *)stops attributeName:(NSString *)attributeName options:(nullable NS_DICTIONARY_OF(MGLStyleFunctionOption, id) *)options {
    return [MGLCompositeStyleFunction functionWithStopType:stopType stops:stops attributeName:attributeName options:options];
}

@end

@implementation MGLStyleConstantValue

+ (instancetype)valueWithRawValue:(id)rawValue {
    return [[self alloc] initWithRawValue:rawValue];
}

- (instancetype)initWithRawValue:(id)rawValue {
    if (self = [super init]) {
        _rawValue = rawValue;
    }
    return self;
}

- (NSString *)description {
    return [self.rawValue description];
}

- (NSString *)debugDescription {
    return [self.rawValue debugDescription];
}

- (BOOL)isEqual:(MGLStyleConstantValue *)other {
    return [other isKindOfClass:[self class]] && [other.rawValue isEqual:self.rawValue];
}

- (NSUInteger)hash {
    return [self.rawValue hash];
}

@end

@implementation MGLCameraStyleFunction

@synthesize stopType = _stopType;

+ (instancetype)functionWithStopType:(MGLStyleFunctionStopType)stopType stops:(NSDictionary *)stops options:(NSDictionary *)options {
    return [[self alloc] initWithStopType:stopType stops:stops options:options];
}

- (instancetype)init {
    return [self initWithStopType:MGLStyleFunctionStopTypeExponential stops:@{} options:nil];
}

- (instancetype)initWithStopType:(MGLStyleFunctionStopType)stopType stops:(NSDictionary *)stops options:(NSDictionary *)options {
    if (![stops count]) {
        [NSException raise:NSInvalidArgumentException
                    format:@"Camera functions must have at least one stop."];
        return {};
    }

    if (self == [super init]) {
        _stopType = stopType;
        _stops = stops;
        _interpolationBase = 1.0;

        if ([options.allKeys containsObject:MGLStyleFunctionOptionInterpolationBase]) {
            if ([options[MGLStyleFunctionOptionInterpolationBase] isKindOfClass:[NSNumber class]]) {
                NSNumber *value = (NSNumber *)options[MGLStyleFunctionOptionInterpolationBase];
                _interpolationBase = [value floatValue];
            } else {
                [NSException raise:NSInvalidArgumentException format:@"Interpolation base must be an NSNumber that represents a CGFloat."];
            }
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, \
            stopType = %lu, \
            stops = %@, \
            interpolationBase = %f>",
            NSStringFromClass([self class]), (void *)self,
            (unsigned long)self.stopType,
            self.stops,
            self.interpolationBase];
}

- (BOOL)isEqual:(MGLCameraStyleFunction *)other {
    return ([other isKindOfClass:[self class]]
            && other.stopType == self.stopType
            && [other.stops isEqualToDictionary:self.stops]
            && other.interpolationBase == self.interpolationBase);
}

- (NSUInteger)hash {
    return  self.stopType + self.stops.hash + self.interpolationBase;
}

@end

@implementation MGLSourceStyleFunction

@synthesize stopType = _stopType;

+ (instancetype)functionWithStopType:(MGLStyleFunctionStopType)stopType stops:(NSDictionary *)stops attributeName:(NSString *)attributeName options:(NSDictionary *)options {
    return [[self alloc] initWithStopType:stopType stops:stops attributeName:attributeName options:options];
}

- (instancetype)init {
    return [self initWithStopType:MGLStyleFunctionStopTypeExponential stops:nil attributeName:@"" options:nil];
}

- (instancetype)initWithStopType:(MGLStyleFunctionStopType)stopType stops:(NSDictionary *)stops attributeName:(NSString *)attributeName options:(NSDictionary *)options {
    if (self == [super init]) {
        _stopType = stopType;
        _stops = stops;
        _attributeName = attributeName;
        _interpolationBase = 1.0;

        if ([options.allKeys containsObject:MGLStyleFunctionOptionDefaultValue]) {
            if ([options[MGLStyleFunctionOptionDefaultValue] isKindOfClass:[MGLStyleValue class]]) {
                MGLStyleValue *value = (MGLStyleValue *)options[MGLStyleFunctionOptionDefaultValue];
                _defaultValue = value;
            } else {
                [NSException raise:NSInvalidArgumentException format:@"Default value must be an MGLStyleValue"];
            }
        }

        if ([options.allKeys containsObject:MGLStyleFunctionOptionInterpolationBase]) {
            if ([options[MGLStyleFunctionOptionInterpolationBase] isKindOfClass:[NSNumber class]]) {
                NSNumber *value = (NSNumber *)options[MGLStyleFunctionOptionInterpolationBase];
                _interpolationBase = [value floatValue];
            } else {
                [NSException raise:NSInvalidArgumentException format:@"Interpolation base must be an NSNumber that represents a CGFloat."];
            }
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, \
            stopType = %lu, \
            stops = %@, \
            attributeName = %@, \
            defaultValue = %@, \
            interpolationBase = %f>",
            NSStringFromClass([self class]),
            (void *)self,
            (unsigned long)self.stopType,
            self.stops,
            self.attributeName,
            self.defaultValue,
            self.interpolationBase];
}

- (BOOL)isEqual:(MGLSourceStyleFunction *)other {
    return ([other isKindOfClass:[self class]]
            && other.stopType == self.stopType
            && [other.stops isEqualToDictionary:self.stops]
            && [other.attributeName isEqual:self.attributeName]
            && [other.defaultValue isEqual:self.defaultValue]
            && other.interpolationBase == self.interpolationBase);
}

- (NSUInteger)hash {
    return self.stopType + self.stops.hash + self.attributeName.hash + self.defaultValue.hash + self.interpolationBase;
}

@end

@implementation MGLCompositeStyleFunction

@synthesize stopType = _stopType;

+ (instancetype)functionWithStopType:(MGLStyleFunctionStopType)stopType stops:(NSDictionary *)stops attributeName:(NSString *)attributeName options:(NSDictionary *)options {
    return [[self alloc] initWithStopType:stopType stops:stops attributeName:attributeName options:options];
}

- (instancetype)init {
    return [self initWithStopType:MGLStyleFunctionStopTypeExponential stops:@{} attributeName:@"" options:nil];
}

- (instancetype)initWithStopType:(MGLStyleFunctionStopType)stopType stops:(NSDictionary *)stops attributeName:(NSString *)attributeName options:(NSDictionary *)options {
    if (self == [super init]) {
        _stopType = stopType;
        _stops = stops;
        _attributeName = attributeName;
        _interpolationBase = 1.0;

        if ([options.allKeys containsObject:MGLStyleFunctionOptionDefaultValue]) {
            if ([options[MGLStyleFunctionOptionDefaultValue] isKindOfClass:[MGLStyleValue class]]) {
                MGLStyleValue *value = (MGLStyleValue *)options[MGLStyleFunctionOptionDefaultValue];
                _defaultValue = value;
            } else {
                [NSException raise:NSInvalidArgumentException format:@"Default value must be an MGLStyleValue"];
            }
        }

        if ([options.allKeys containsObject:MGLStyleFunctionOptionInterpolationBase]) {
            if ([options[MGLStyleFunctionOptionInterpolationBase] isKindOfClass:[NSNumber class]]) {
                NSNumber *value = (NSNumber *)options[MGLStyleFunctionOptionInterpolationBase];
                _interpolationBase = [value floatValue];
            } else {
                [NSException raise:NSInvalidArgumentException format:@"Interpolation base must be an NSNumber that represents a CGFloat."];
            }
        }
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, \
            stopType = %lu, \
            stops = %@, \
            attributeName = %@, \
            defaultValue = %@, \
            interpolationBase = %f>",
            NSStringFromClass([self class]), (void *)self,
            (unsigned long)self.stopType,
            self.stops,
            self.attributeName,
            self.defaultValue,
            self.interpolationBase];
}

- (BOOL)isEqual:(MGLCompositeStyleFunction *)other {
    return ([other isKindOfClass:[self class]]
            && other.stopType == self.stopType
            && [other.stops isEqualToDictionary:self.stops]
            && [other.attributeName isEqual:self.attributeName]
            && other.interpolationBase == self.interpolationBase);
}

- (NSUInteger)hash {
    return  self.stopType + self.stops.hash + self.attributeName.hash + self.interpolationBase;
}

@end
