//
//  Announcement.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "Mantle.h"

@interface Announcement : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *title, *text, *type;

@end
