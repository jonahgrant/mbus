//
//  StopViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopViewControllerModel.h"
#import "Stop.h"
#import "DataStore.h"

@implementation StopViewControllerModel

- (instancetype)initWithStop:(Stop *)stop {
    if (self = [super init]) {
        self.stop = stop;
        
        [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
            if (arrivals) {
                NSLog(@"%@", arrivals);
                self.arrivalsServicingStop = [[DataStore sharedManager] arrivalsContainingStopName:self.stop.uniqueName];
            }
        }];
    }
    return self;
}

- (void)fetchData {
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:^(NSError *error) {
        self.arrivalsServicingStop = self.arrivalsServicingStop;
    }];
}

@end
