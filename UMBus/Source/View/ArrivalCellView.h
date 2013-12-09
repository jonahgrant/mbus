//
//  ArrivalCellView.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArrivalCellModel;

@interface ArrivalCellView : UIView

@property (strong, nonatomic) ArrivalCellModel *model;

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(ArrivalCellModel *)model;

@end
