//
//  StopAnnotation.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <MapKit/MapKit.h>

@class Stop;

@interface StopAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) Stop *stop;
@property (strong, nonatomic) NSString *id;

- (instancetype)initWithStop:(Stop *)stop;

@end
