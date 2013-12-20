//
//  AddressCellModel.h
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface AddressCellModel : NSObject

@property (strong, nonatomic) CLLocation *location;
@property (strong, nonatomic) CLPlacemark *placemark;

- (instancetype)initWithLocation:(CLLocation *)location;

- (void)reverseGeocodeLocation:(CLLocation *)location;

@end
