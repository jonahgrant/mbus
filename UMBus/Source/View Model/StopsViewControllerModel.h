//
//  StopsViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StopsViewControllerModel : NSObject

@property (strong, nonatomic) NSArray *sortedStops;

- (void)fetchStops;

@end
