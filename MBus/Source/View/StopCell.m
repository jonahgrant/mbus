//
//  StopCell.m
//  UMBus
//
//  Created by Jonah Grant on 12/14/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "StopCell.h"
#import "StopCellModel.h"
#import "StopCellView.h"

@implementation StopCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        StopCellView *cellView = [[StopCellView alloc] initWithFrame:self.frame arrivalModel:self.model];
        [self addSubview:cellView];
        
        RAC(cellView, model) = RACObserve(self, model);
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


@end
