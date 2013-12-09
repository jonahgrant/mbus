//
//  StopTrayModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <Foundation/Foundation.h>

@class StopAnnotation, Bus;

@interface StopTrayModel : NSObject

@property (strong, nonatomic) StopAnnotation *stopAnnotation;

@end
