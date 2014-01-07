//
//  ArrivalCell.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalCell.h"
#import "ArrivalCellModel.h"
#import "ArrivalCellView.h"

@interface ArrivalCell ()

@property (strong, nonatomic) ArrivalCellView *cellView;

@end

@implementation ArrivalCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _cellView = [[ArrivalCellView alloc] initWithFrame:self.frame arrivalModel:self.model];
        [self addSubview:_cellView];

        RAC(_cellView, model) = RACObserve(self, model);

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
