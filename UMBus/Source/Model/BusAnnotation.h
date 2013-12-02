//
//  BusAnnotation.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>

@class Bus;

@interface BusAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CGFloat heading;

- (instancetype)initWithBus:(Bus *)bus;

@end
