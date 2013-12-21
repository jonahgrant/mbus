//
//  RouteViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RouteViewControllerModel.h"

@implementation RouteViewControllerModel

- (instancetype)initWithArrival:(Arrival *)arrival {
    if (self = [super init]) {
        self.arrival = arrival;
    }
    return self;
}

@end
