//
//  StopArrivalCellView.h
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@class StopArrivalCellModel;

@interface StopArrivalCellView : UIView

@property (strong, nonatomic) StopArrivalCellModel *model;

- (instancetype)initWithFrame:(CGRect)frame arrivalModel:(StopArrivalCellModel *)model;

@end
