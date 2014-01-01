//
//  AddressCell.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AddressCell.h"
#import "AddressCellModel.h"
#import "Constants.h"

@implementation AddressCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.textLabel.text = kBlankString;
        self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.numberOfLines = 0;
        
        [self beginLoading];
        
        [RACObserve(self, model) subscribeNext:^(AddressCellModel *model) {
            if (model && !self.model.placemark) {
                [self.model reverseGeocodeLocation:self.model.location];
            }
        }];
        
        [RACObserve(self, model.placemark) subscribeNext:^(CLPlacemark *placemark) {
            if (placemark) {
                [self endLoading];
                
                self.textLabel.text = [NSString stringWithFormat:kFormattedStringAddress, placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode];
            }
        }];
    }
    return self;
}

- (void)beginLoading {
    self.textLabel.text = kLoadingAddress;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)endLoading {
    self.textLabel.text = kBlankString;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
}

@end
