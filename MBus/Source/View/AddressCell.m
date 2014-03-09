//
//  AddressCell.m
//  UMBus
//
//  Created by Jonah Grant on 12/19/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@import MapKit;

#import "AddressCell.h"
#import "AddressCellModel.h"
#import "Constants.h"
#import "UMAdditions+UIFont.h"

static const CGFloat PARALLAX_LEEWAY_VALUE = 20.0f;
static const CGFloat CAMERA_ALTITUDE = 1000.0f;
static const CGFloat CAMERA_PITCH = 0.0f;
static const CGFloat CAMERA_HEADING = 0.0f;

@interface AddressCell () <MKMapViewDelegate>

@property (strong, nonatomic, readwrite) MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) BOOL loaded;

@end

@implementation AddressCell

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        self.textLabel.text = BLANK_STRING;
        self.textLabel.font = [UIFont helveticaNeueWithWeight:TypeWeightNormal size:17.0f];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        self.textLabel.layer.shadowOffset = CGSizeMake(0.0, 1.0);
        self.textLabel.layer.shadowOpacity = 1;
        self.textLabel.layer.shadowRadius = 0.1;
        
        UIView *tintView = [[UIView alloc] initWithFrame:self.frame];
        tintView.backgroundColor = [UIColor blackColor];
        tintView.alpha = 0.6;
        [self insertSubview:tintView atIndex:0];
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, -40, CGRectGetWidth(self.frame) + 180, CGRectGetHeight(self.frame) + 120)];
        _mapView.mapType = MKMapTypeStandard;
        _mapView.delegate = self;
        _mapView.showsBuildings = YES;
        [self insertSubview:_mapView atIndex:0];
        
        UIInterpolatingMotionEffect *mapHorizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        mapHorizontalEffect.minimumRelativeValue = @(-PARALLAX_LEEWAY_VALUE);
        mapHorizontalEffect.maximumRelativeValue = @(PARALLAX_LEEWAY_VALUE);
        [_mapView addMotionEffect:mapHorizontalEffect];
        
        UIInterpolatingMotionEffect *mapVerticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        mapVerticalEffect.minimumRelativeValue = @(-PARALLAX_LEEWAY_VALUE);
        mapVerticalEffect.maximumRelativeValue = @(PARALLAX_LEEWAY_VALUE);
        [_mapView addMotionEffect:mapVerticalEffect];
        
        [self beginLoading];
        
        [[RACObserve(self, model) filter:^BOOL(AddressCellModel *model) {
            return (model != nil && !self.model.placemark && !self.loaded);
        }] subscribeNext:^(AddressCellModel *model) {
            [self.model reverseGeocodeLocation:self.model.location];
        }];
        
        [[RACObserve(self, model.placemark) filter:^BOOL(CLPlacemark *placemark) {
            return (placemark != nil);
        }] subscribeNext:^(CLPlacemark *placemark) {
            [self endLoading];
            
            self.loaded = YES;
            
            _coordinate = placemark.location.coordinate;
            
            [self zoomToCoordinate:_coordinate];
            [self dropPinWithCoordinate:_coordinate];
            
            self.textLabel.text = [NSString stringWithFormat:FORMATTED_ADDRESS,
                                   placemark.subThoroughfare,
                                   placemark.thoroughfare,
                                   placemark.locality,
                                   placemark.administrativeArea,
                                   placemark.postalCode];
        }];
    }
    return self;
}

- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate {
    MKMapCamera *camera = [MKMapCamera new];
    camera.centerCoordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude - 0.0005);
    camera.heading = CAMERA_HEADING;
    camera.pitch = CAMERA_PITCH;
    camera.altitude = CAMERA_ALTITUDE;
    [_mapView setCamera:camera animated:NO];
}

- (void)dropPinWithCoordinate:(CLLocationCoordinate2D)coordinate {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [_mapView addAnnotation:annotation];
}

- (void)beginLoading {
    self.textLabel.text = LOADING_ADDRESS;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)endLoading {
    self.textLabel.text = BLANK_STRING;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
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
