//
//  StopsViewControllerModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/18/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@interface StopsViewControllerModel : NSObject

@property (strong, nonatomic) NSArray *stops, *stopCellModels;

- (void)fetchData;

@end
