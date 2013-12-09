//
//  MapViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/8/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapViewControllerModel : NSObject

@property (nonatomic) BOOL continuouslyUpdating;
@property (strong, nonatomic) NSArray *buses;
@property (strong, nonatomic) NSDictionary *busAnnotations;
@property (strong, nonatomic) NSError *fetchBusesError;

- (void)beginFetchingBuses;
- (void)endFetchingBuses;
- (void)refresh;

@end
