//
//  AddressCellModel.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import "AddressCellModel.h"
#import "DataStore.h"

@interface AddressCellModel ()

@property (strong, nonatomic) CLGeocoder *geocoder;

@end

@implementation AddressCellModel

- (instancetype)initWithLocation:(CLLocation *)location stopID:(NSString *)stopID {
    if (self = [super init]) {
        self.geocoder = [[CLGeocoder alloc] init];
        self.location = location;
        self.stopID = stopID;
    }
    return self;
}

- (void)reverseGeocodeLocation:(CLLocation *)location {
    if ([[DataStore sharedManager] hasPlacemarkForStopID:self.stopID]) {
        self.placemark = [[DataStore sharedManager] placemarkForStopID:self.stopID];
    } else {
        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error){
            if (placemarks.count > 0) {
                self.placemark = (CLPlacemark *)placemarks[0];
                [[DataStore sharedManager] persistPlacemark:(CLPlacemark *)placemarks[0] forStopID:self.stopID];
            }
        }];
    }
}

@end
