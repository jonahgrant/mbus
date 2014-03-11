//
//  AddressCellMapView.h
//  MBus
//
//  Created by Jonah Grant on 3/11/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

@interface AddressCellMapView : UIView

@property (nonatomic, strong, readonly) MKMapView *mapView;

+ (instancetype)sharedInstance;

- (void)purge;

@end
