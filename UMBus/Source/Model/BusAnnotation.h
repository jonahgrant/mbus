//
//  BusAnnotation.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@import MapKit;

@class Bus;

@interface BusAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) Bus *bus;
@property (nonatomic) CGFloat heading;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) UIColor *color;

- (instancetype)initWithBus:(Bus *)bus;

@end
