//
//  ViewControllerModelBase.h
//  MBus
//
//  Created by Jonah Grant on 2/18/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

typedef void (^DataUpdatedBlock)(void);

@interface ViewControllerModelBase : NSObject

@property (nonatomic, copy) DataUpdatedBlock dataUpdatedBlock;

- (void)fetchData;

@end
