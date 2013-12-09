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

- (void)fetchArrivals {
    [[DataStore sharedManager] fetchArrivalsWithErrorBlock:^(NSError *error) {
        self.fetchError = error;
    }];
}

@end
