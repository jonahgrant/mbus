//
//  ArrivalRouteCellView.h
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ArrivalRouteCellModel;

@interface ArrivalRouteCellView : UIView

@property (strong, nonatomic) ArrivalRouteCellModel *model;

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(ArrivalRouteCellModel *)model;

@end
