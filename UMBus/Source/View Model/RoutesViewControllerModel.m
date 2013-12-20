//
//  RoutesViewControllerModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "RoutesViewControllerModel.h"
#import "DataStore.h"

@implementation RoutesViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        self.routes = [DataStore sharedManager].arrivals;
        
        if (!self.routes) {
            [self fetchData];
        }
        
        [RACObserve([DataStore sharedManager], arrivals) subscribeNext:^(NSArray *arrivals) {
            self.routes = arrivals;
        }];
    }
    return self;
}

- (void)fetchData {
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:^(NSError *error) {
        self.routes = self.routes;
    }];
}

@end
