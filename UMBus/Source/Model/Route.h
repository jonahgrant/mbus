//
//  Route.h
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "Mantle.h"

@interface Route : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSString *id, *name, *color, *topOfLoopStopID;
@property (nonatomic) BOOL isActive;
@property (strong, nonatomic) NSArray *stops;

@end
