//
//  AddressCellMapView.m
//  MBus
//
//  Created by Jonah Grant on 3/11/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

@import MapKit;

#import "AddressCellMapView.h"
#import "Constants.h"

@interface AddressCellMapView () <MKMapViewDelegate>

@property (nonatomic, strong, readwrite) MKMapView *mapView;

@end

@implementation AddressCellMapView

#pragma mark Singleton

+ (instancetype)sharedInstance {
    static AddressCellMapView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIApplication sharedApplication].keyWindow.frame), ADDRESS_CELL_HEIGHT)]) {
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, -40, 500, 200)];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.delegate = self;
        _mapView.showsBuildings = YES;
        [self addSubview:_mapView];
    }
    return self;
}

- (void)purge {
    [_mapView removeAnnotations:_mapView.annotations];
    
    //[AddressCellMapView sharedInstance].mapView.mapType = MKMapTypeSatellite;
    //[[AddressCellMapView sharedInstance].mapView removeFromSuperview];
    //[AddressCellMapView sharedInstance].mapView = nil;
}

#pragma mark - MKMapView

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier: @"annotation_ID"];
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"annotation_ID"];
    } else {
        pin.annotation = annotation;
    }
    
    pin.pinColor = MKPinAnnotationColorRed;
    pin.animatesDrop = YES;
    
    return pin;
}


@end
