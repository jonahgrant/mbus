//
//  StopCellView.h
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StopCellModel;

@interface StopCellView : UIView

@property (strong, nonatomic) StopCellModel *model;

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(StopCellModel *)model;

@end
