//
//  Stop.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "Mantle.h"

@interface Stop : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *id, *uniqueName, *humanName, *additionalName, *latitude, *longitude, *heading;

@end
