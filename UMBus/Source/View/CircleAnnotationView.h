//
//  CircleAnnotationView.h
//  UMBus
//
//  Created by Jonah Grant on 12/8/13.
//  Copyright (c) 2013 Jonah Grant. All rights reserved.
//

@import MapKit;

@interface CircleAnnotationView : MKAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation
                   reuseIdentifier:(NSString *)reuseIdentifier
                             color:(UIColor *)color
                      outlineColor:(UIColor *)outlineColor;

@end
