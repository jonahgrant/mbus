//
//  AppAnnouncement.h
//  MBus
//
//  Created by Jonah Grant on 3/28/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "Mantle.h"

@interface AppAnnouncement : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *text;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, strong, readonly) UIColor *color;
@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, copy, readonly) NSString *action; // email, phone, sms, url, native_url, none
@property (nonatomic, copy, readonly) NSString *actionDestination;
@property (nonatomic, copy, readonly) NSString *actionBody;
@property (nonatomic, copy, readonly) NSString *minimumVersion;
@property (nonatomic, copy, readonly) NSString *maximumVersion;
@property (nonatomic, copy, readonly) NSString *tag;

- (BOOL)supported;

@end
