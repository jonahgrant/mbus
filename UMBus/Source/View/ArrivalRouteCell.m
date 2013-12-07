//
//  ArrivalRouteCell.m
//  UMBus
//
//  Created by Jonah Grant on 12/7/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "ArrivalRouteCell.h"
#import "ArrivalCellModel.h"
#import "Arrival.h"
#import "ArrivalRouteCellView.h"

@interface ArrivalRouteCell ()

@property (strong, nonatomic) UILabel *routeNameLabel;

@end

@implementation ArrivalRouteCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        ArrivalRouteCellView *cellView = [[ArrivalRouteCellView alloc] initWithFrame:self.frame arrivalModel:self.model];
        [self addSubview:cellView];
        
        RAC(cellView, model) = RACObserve(self, model);
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

@end
