//
//  RoutesViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RoutesViewControllerModel.h"
#import "DataStore.h"

@implementation RoutesViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
            if (arrivals) {
                self.arrivals = arrivals;
            }
        }];
    }
    return self;
}

- (void)fetchArrivals {
    [[DataStore sharedManager] fetchArrivals];
}

@end
