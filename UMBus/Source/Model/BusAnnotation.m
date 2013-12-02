//
//  BusAnnotation.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "BusAnnotation.h"
#import "Bus.h"

@interface BusAnnotation ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) Bus *bus;

@end

@implementation BusAnnotation

- (instancetype)initWithBus:(Bus *)bus {
    if (self = [super init]) {
        _bus = bus;
        _coordinate = CLLocationCoordinate2DMake([bus.latitude doubleValue], [bus.longitude doubleValue]);
        _heading = [bus.heading floatValue];
    }
    return self;
}
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate heading:(CGFloat)heading {
    if (self = [super init]) {
        _coordinate = coordinate;
        _heading = heading;
    }
    return self;
}

- (NSString *)title {
    return _bus.routeName;
}

- (NSString *)subtitle {
    return [NSString stringWithFormat:@"Route #%@", _bus.route];
}

@end
