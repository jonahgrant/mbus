//
//  RoutesViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoutesViewControllerModel : NSObject

@property (strong, nonatomic) NSArray *arrivals;

- (void)fetchArrivals;

@end
