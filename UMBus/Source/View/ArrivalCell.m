//
//  ArrivalCell.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalCell.h"
#import "ArrivalCellModel.h"
#import "Arrival.h"
#import "ArrivalCellView.h"

@interface ArrivalCell ()

@property (strong, nonatomic) UILabel *routeNameLabel;

@end

@implementation ArrivalCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        ArrivalCellView *cellView = [[ArrivalCellView alloc] initWithFrame:self.frame arrivalModel:self.model];
        //[self addSubview:cellView];

        RAC(cellView, model) = RACObserve(self, model);

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
