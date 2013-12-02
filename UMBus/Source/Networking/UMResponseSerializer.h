//
//  UMResponseSerializer.h
//  UMBus
//
//  Created by Jonah Grant on 12/1/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AFURLResponseSerialization.h"
#import "MTLModel.h"

extern NSString * const LTCResponseSerializerErrorDomain;

@interface UMResponseSerializer : AFJSONResponseSerializer

@end

@interface MTLModel (UMResponseSerializer)

+ (UMResponseSerializer *)um_responseSerializer;
+ (UMResponseSerializer *)um_arrayResponseSerializer;

@end
