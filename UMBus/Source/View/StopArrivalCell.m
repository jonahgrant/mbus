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

@implementation StopArrivalCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        StopArrivalCellView *cellView = [[StopArrivalCellView alloc] initWithFrame:self.frame arrivalModel:self.model];
        [self addSubview:cellView];
        
        RAC(cellView, model) = RACObserve(self, model);
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


@end
