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
#import "AddressCellMapView.h"

static const CGFloat PARALLAX_LEEWAY_VALUE = 20.0f;
static const CGFloat CAMERA_ALTITUDE = 1000.0f;
static const CGFloat CAMERA_PITCH = 0.0f;
static const CGFloat CAMERA_HEADING = 0.0f;

static CGFloat const TINT_ALPHA = 0.69; // lol

@interface AddressCell ()

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UIView *tintView;
@property (nonatomic) BOOL loaded;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

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
        self.textLabel.alpha = 0;
        
        _tintView = [[UIView alloc] initWithFrame:self.frame];
        _tintView.backgroundColor = [UIColor blackColor];
        _tintView.alpha = 1;
        [self insertSubview:_tintView atIndex:0];
        
        [self insertSubview:[AddressCellMapView sharedInstance] atIndex:0];
       
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityIndicator.center = CGPointMake(CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) / 2);
        _activityIndicator.hidesWhenStopped = YES;
        [self addSubview:_activityIndicator];
        [_activityIndicator startAnimating];
        
         
        for (UIInterpolatingMotionEffect *motionEffect in [AddressCellMapView sharedInstance].mapView.motionEffects) {
            [[AddressCellMapView sharedInstance].mapView removeMotionEffect:motionEffect];
        }
         
        UIInterpolatingMotionEffect *mapHorizontalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        mapHorizontalEffect.minimumRelativeValue = @(-PARALLAX_LEEWAY_VALUE);
        mapHorizontalEffect.maximumRelativeValue = @(PARALLAX_LEEWAY_VALUE);
        [[AddressCellMapView sharedInstance].mapView addMotionEffect:mapHorizontalEffect];
        
        UIInterpolatingMotionEffect *mapVerticalEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        mapVerticalEffect.minimumRelativeValue = @(-PARALLAX_LEEWAY_VALUE);
        mapVerticalEffect.maximumRelativeValue = @(PARALLAX_LEEWAY_VALUE);
        [[AddressCellMapView sharedInstance].mapView addMotionEffect:mapVerticalEffect];
        
        [self beginLoading];
        
        [[RACObserve(self, model) filter:^BOOL(AddressCellModel *model) {
            return (model != nil && !self.model.placemark && !self.loaded);
        }] subscribeNext:^(AddressCellModel *model) {
            [self.model reverseGeocodeLocation:self.model.location];
        }];
        
        [RACObserve(self, model.placemark) subscribeNext:^(CLPlacemark *placemark) {
            if (placemark) {
                [self endLoading];
                
                [_activityIndicator stopAnimating];
                
                [UIView animateWithDuration:0.5
                                 animations:^ {
                                     _tintView.alpha = TINT_ALPHA;
                                     self.textLabel.alpha = 1;
                                 }];
                
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
            } else {
                [self endLoading];
                
                [_activityIndicator stopAnimating];
                
                [UIView animateWithDuration:0.5
                                 animations:^ {
                                     _tintView.alpha = TINT_ALPHA;
                                     self.textLabel.alpha = 1;
                                 }];

                self.textLabel.text = @"Couldn't find address.";
                self.textLabel.textAlignment = NSTextAlignmentCenter;
            }
        }];
    }
    return self;
}

- (void)purgeMapMemory {
    [[AddressCellMapView sharedInstance] purge];
}

- (void)zoomToCoordinate:(CLLocationCoordinate2D)coordinate {
    MKMapCamera *camera = [MKMapCamera new];
    camera.centerCoordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude - 0.0005);
    camera.heading = CAMERA_HEADING;
    camera.pitch = CAMERA_PITCH;
    camera.altitude = CAMERA_ALTITUDE;
    [[AddressCellMapView sharedInstance].mapView setCamera:camera animated:NO];
}

- (void)dropPinWithCoordinate:(CLLocationCoordinate2D)coordinate {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    [[AddressCellMapView sharedInstance].mapView addAnnotation:annotation];
}

- (void)beginLoading {
    self.textLabel.text = LOADING_ADDRESS;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)endLoading {
    self.textLabel.text = BLANK_STRING;
    self.textLabel.textAlignment = NSTextAlignmentLeft;
}

@end
