//
//  MapViewControllerModel.h
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "ViewControllerModelBase.h"

@interface MapViewControllerModel : ViewControllerModelBase

@property (nonatomic, strong, readonly) NSDictionary *busAnnotations;
@property (nonatomic, readonly, getter=isFetchingBuses) BOOL fetchingContinuously;

- (void)beginContinuousFetching;
- (void)endContinuousFetching;

@end
