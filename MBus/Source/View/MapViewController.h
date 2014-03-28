//
//  MapViewController.h
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "UMViewController.h"

@class Stop;

@interface MapViewController : UMViewController

@property (nonatomic, strong, readwrite) Stop *startingStop;

/**
 If we're going to only show the buses that are servicing a specific stop, pass along the IDs of the routes to show
 */
@property (nonatomic, strong, readwrite) NSArray *arrivalIDsServicingStop;

@end
