//
//  AddressCellModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AddressCellModel.h"

@interface AddressCellModel ()

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation AddressCellModel

- (instancetype)initWithLocation:(CLLocation *)location {
    if (self = [super init]) {
        self.geocoder = [[CLGeocoder alloc] init];
        self.location = location;
    }
    return self;
}

- (void)reverseGeocodeLocation:(CLLocation *)location {
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
        if (placemarks.count > 0) {
            self.placemark = (CLPlacemark *)placemarks[0];
        }
    }];
}

@end
