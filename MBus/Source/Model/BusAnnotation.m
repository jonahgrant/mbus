//
//  BusAnnotation.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "BusAnnotation.h"
#import "Bus.h"
#import "DataStore.h"
#import "Arrival.h"
#import "HexColor.h"
#import "Constants.h"

@interface BusAnnotation ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong, readwrite) Arrival *arrival;

@end

@implementation BusAnnotation

- (instancetype)initWithBus:(Bus *)bus {
    if (self = [super init]) {
        [self setBus:bus];
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

- (void)setBus:(Bus *)bus {
    _bus = bus;
    _id = bus.id;
    _coordinate = bus.coordinate;
    _heading = [bus.heading floatValue];
    _arrival = [[DataStore sharedManager] arrivalForID:_bus.routeID];
    _color = _arrival.routeColor;
}

- (NSString *)title {
    return @"Bus";
}

- (NSString *)subtitle {
    return [[DataStore sharedManager] arrivalForID:_bus.routeID].name;
}

@end
