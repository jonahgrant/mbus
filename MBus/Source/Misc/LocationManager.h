//
//  LocationManager.h
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@import MapKit;

@interface LocationManager : NSObject

@property (strong, nonatomic) CLLocation *currentLocation;

+ (instancetype)sharedManager;

- (void)fetchLocation;

@end
