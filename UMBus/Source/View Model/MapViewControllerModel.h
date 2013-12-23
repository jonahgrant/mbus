//
//  MapViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/20/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapViewControllerModel : NSObject

@property (strong, nonatomic) NSArray *buses;
@property (strong, nonatomic) NSDictionary *busAnnotations;
@property (nonatomic, getter = isFetchingBuses) BOOL fetchingContinuously;

- (void)refreshData;
- (void)beginContinuousFetching;
- (void)endContinuousFetching;

@end
