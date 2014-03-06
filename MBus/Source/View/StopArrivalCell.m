//
//  StopArrivalCell.m
//  UMBus
//
//  Created by Jonah Grant on 12/15/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopArrivalCell.h"
#import "StopArrivalCellModel.h"
#import "StopArrivalCellView.h"

@interface StopArrivalCell ()

@property (strong, nonatomic) StopArrivalCellView *cellView;

@end

@implementation StopArrivalCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        if (!self.cellView) {
            self.cellView = [[StopArrivalCellView alloc] initWithFrame:self.frame arrivalModel:self.model];
            [self addSubview:self.cellView];
        }
        
        RAC(self.cellView, model) = RACObserve(self, model);
    }
    return self;
}


@end
