//
//  StreetViewController.h
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "UMViewController.h"

@import MapKit;

@class Stop;

@interface StreetViewController : UMViewController

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           heading:(NSUInteger)heading
                             title:(NSString *)title;

@end
