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
#import "RouteMapViewController.h"
#import "TTTAttributedLabel.h"
#import "StopAnnotation.h"
#import "Stop.h"
#import "Bus.h"
#import "Constants.h"

@interface StopTray ()

@property (nonatomic, copy) NSString *timeUntilNextBus;
@property (strong, nonatomic) UIButton *streetViewButton, *directionsButton, *shareButton;
@property (strong, nonatomic) TTTAttributedLabel *titleLabel, *subtitleLabel;

@end

@implementation StopTray

- (instancetype)initWithTintColor:(UIColor *)color {
    if (self = [super initWithFrame:CGRectMake(0, 0, 320, 50)]) {
        _model = [[StopTrayModel alloc] init];
        
        _titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 10, 310, 16)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor darkGrayColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(10, 30, 310, 16)];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        _subtitleLabel.textColor = [UIColor darkGrayColor];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_subtitleLabel];
        
        _streetViewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_streetViewButton setTitle:kButtonTitleStreetView forState:UIControlStateNormal];
        _streetViewButton.tintColor = color;
        _streetViewButton.frame = CGRectMake(10, 10, 140, 30);
        _streetViewButton.layer.cornerRadius = 3;
        _streetViewButton.layer.borderWidth = 1;
        _streetViewButton.layer.borderColor = color.CGColor;
        [_streetViewButton addTarget:self action:@selector(displayStreetView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_streetViewButton];
        
        _directionsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_directionsButton setTitle:kButtonTitleDirections forState:UIControlStateNormal];
        _directionsButton.tintColor = color;
        _directionsButton.frame = CGRectMake(170, 10, 140, 30);
        _directionsButton.layer.cornerRadius = 3;
        _directionsButton.layer.borderWidth = 1;
        _directionsButton.layer.borderColor = color.CGColor;
        [_directionsButton addTarget:self action:@selector(directions) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_directionsButton];
    }
    return self;
}

- (void)displayStreetView {
    [(RouteMapViewController *)_target displayStreetViewForAnnotation:(NSObject<MKAnnotation> *)_model.stopAnnotation];
}

- (void)directions {
    NSString *address = [NSString stringWithFormat:kFormattedStringAppleMapsDirections, _model.stopAnnotation.coordinate.latitude, _model.stopAnnotation.coordinate.longitude];
    NSURL *url = [[NSURL alloc] initWithString:[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

@end
