//
//  StopAnnotation.m
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopAnnotation.h"
#import "Stop.h"

@interface StopAnnotation ()

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end

@implementation StopAnnotation

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        _coordinate = CLLocationCoordinate2DMake([stop.latitude doubleValue], [stop.longitude doubleValue]);
        _stop = stop;
    }
    return self;
}

- (NSString *)title {
    return _stop.humanName;
}

@end
