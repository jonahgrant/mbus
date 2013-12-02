//
//  BusAnnotation.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "BusAnnotation.h"

@interface BusAnnotation ()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation BusAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate heading:(CGFloat)heading {
    if (self = [super init]) {
        _coordinate = coordinate;
        _heading = heading;
    }
    return self;
}

@end
