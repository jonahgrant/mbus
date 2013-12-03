//
//  StopTray.m
//  UMBus
//
//  Created by Jonah Grant on 12/2/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "StopTray.h"
#import "StopTrayModel.h"
#import "MapViewController.h"

@interface StopTray ()

@property (strong, nonatomic) UIButton *streetViewButton, *directionsButton, *dummyButton;

@end

@implementation StopTray

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 100)]) {
        _model = [[StopTrayModel alloc] init];
        [_model fetchETA];
        
        [RACObserve(self, model.stopAnnotation) subscribeNext:^(StopAnnotation *stopAnnotation) {
            if (stopAnnotation) {
                [_model fetchETA];
            }
        }];
        
        [RACObserve(self, model.eta) subscribeNext:^(NSString *eta) {
            if (eta) {
                NSLog(@"ETA: %@", eta);
            }
        }];
        
        _streetViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_streetViewButton setTitle:@"Street View" forState:UIControlStateNormal];
        _streetViewButton.frame = CGRectMake(10, 60, 90, 30);
        [_streetViewButton addTarget:self action:@selector(displayStreetView) forControlEvents:UIControlEventTouchUpInside];
        _streetViewButton.layer.cornerRadius = 2;
        _streetViewButton.layer.borderWidth = 1;
        _streetViewButton.layer.borderColor = _streetViewButton.titleLabel.textColor.CGColor;
        [self addSubview:_streetViewButton];
        
        _directionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_directionsButton setTitle:@"Directions" forState:UIControlStateNormal];
        _directionsButton.frame = CGRectMake(110, 60, 90, 30);
        [_directionsButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        _directionsButton.layer.cornerRadius = 2;
        _directionsButton.layer.borderWidth = 1;
        _directionsButton.layer.borderColor = _directionsButton.titleLabel.textColor.CGColor;
        [self addSubview:_directionsButton];
        
        _dummyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_dummyButton setTitle:@"Share" forState:UIControlStateNormal];
        _dummyButton.frame = CGRectMake(210, 60, 90, 30);
        [_dummyButton addTarget:self action:nil forControlEvents:UIControlEventTouchUpInside];
        _dummyButton.layer.cornerRadius = 2;
        _dummyButton.layer.borderWidth = 1;
        _dummyButton.layer.borderColor = _dummyButton.titleLabel.textColor.CGColor;
        [self addSubview:_dummyButton];

    }
    return self;
}

- (void)displayStreetView {
    [(MapViewController *)_target displayStreetViewForAnnotation:(NSObject<MKAnnotation> *)_model.stopAnnotation];
}

@end
