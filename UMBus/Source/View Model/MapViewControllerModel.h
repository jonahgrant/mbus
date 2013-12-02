//
//  MapViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapViewControllerModel : NSObject

@property (nonatomic) BOOL continuouslyUpdate;
@property (strong, nonatomic) NSArray *buses;
@property (strong, nonatomic) NSDictionary *annotations, *updatedAnnotations;

- (void)fetchBuses;

@end
