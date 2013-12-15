//
//  StopViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopViewControllerModel.h"
#import "DataStore.h"
#import "Stop.h"

@implementation StopViewControllerModel

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
        
        [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
            if (arrivals) {
                self.arrivals = [[DataStore sharedManager] arrivalsContainingStopName:self.stop.uniqueName];
            }
        }];
    }
    return self;
}

- (void)loadData {
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:^(NSError *error) {
        
    }];
}

@end
