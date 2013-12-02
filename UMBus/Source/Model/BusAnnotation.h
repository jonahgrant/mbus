//
//  BusAnnotation.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface BusAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CGFloat heading;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate heading:(CGFloat)heading;

@end
