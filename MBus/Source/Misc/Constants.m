//
//  Constants.m
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "Constants.h"

NSInteger const ARRIVALS_REFRESH_INTERVAL = 60; // one minute

NSString * const GOOGLE_MAPS_API_KEY = @"AIzaSyCCBKyJMm7zWhVxukAy8k-_ejMlc5t8ugo";
NSString * const DISCLAIMER = @"The system behind MBus is under development.  Riders are encouraged to use it, but reliable and accurate information is not garunteed";
NSString * const RATE_APP_URL = @"itms-apps://itunes.apple.com/app/id777435172";
NSString * const ACKNOWLEDGEMENTS_PLIST_PATH = @"Pods-MBus-acknowledgements";
NSString * const ACKNOWLEDGEMENTS_PLIST_TYPE = @"plist";
double const CAMPUS_CENTER_LAT = 42.282707;
double const CAMPUS_CENTER_LNG = -83.740196;
NSString * const SUPPORT_EMAIL_ADDRESS = @"mbus@jonahgrant.com";
NSString * const DEVELOPER_EMAIL_ADDRESS = @"jonah@jonahgrant.com";
NSString * const SUPPORT_EMAIL_SUBJECT = @"MBus Support";
NSString * const DEVELOPER_EMAIL_SUBJECT = @"Hi Jonah";
NSString * const NEVER = @"never";
NSString * const BLANK_STRING = @" ";
NSString * const FORMATTED_ADDRESS = @"%@ %@\n%@, %@ %@";
NSString * const LOADING_ADDRESS = @"Loading address...";
NSString * const DISMISS = @"Dismiss";
NSString * const FORMATTED_LAST_UPDATED = @"Last updated %@";
NSString * const FORMATTED_AS_OF = @"As of %@";
NSString * const ROUTE_INFORMATION = @"Route information";
NSString * const UNIVERSITY_OF_MICHIGAN = @"University of Michigan";
NSString * const NO_ROUTES_IN_SERVICE = @"NO ROUTES IN SERVICE";
NSString * const CALL_SAFE_RIDES = @"Call Safe Rides";
NSString * const ROUTES_IN_SERVICE = @"Routes in service";
NSString * const SAFE_RIDES_TEL = @"tel://7346478000";
NSString * const STREET_VIEW = @"Street View";
NSString * const DIRECTIONS = @"Directions";
NSString * const FORMATTED_APPLE_MAPS_DIRECTIONS = @"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale";
NSString * const FORMATTED_ANNOUNCEMENTS_COUNT = @"%i announcements";
NSString * const NEARBY_STOPS = @"Nearby stops";
NSString * const NEARBY_STOPS_IN_SERVICE = @"Nearby stops in service";
NSString * const FORMATTED_MORE_STOPS_CELL_TEXT = @"%u MORE STOPS";

extern NSString * NSStringForUIViewController(UIViewController *viewController) {
    NSString *class = NSStringFromClass([viewController class]);
    
    if ([class isEqualToString:@"StopsViewController"]) {
        return @"Stops";
    } else if ([class isEqualToString:@"StopViewController"]) {
        return @"Stop";
    } else if ([class isEqualToString:@"AllStopsViewController"]) {
        return nil; // has no title
    } else if ([class isEqualToString:@"MiscViewController"]) {
        return @"More";
    } else if ([class isEqualToString:@"MapViewController"]) {
        return @"Map";
    } else if ([class isEqualToString:@"WebViewController"]) {
        return nil; // handle it's own title
    } else if ([class isEqualToString:@"RoutesViewController"]) {
        return @"Routes";
    } else if ([class isEqualToString:@"RouteViewController"]) {
        return nil; // handles it's own title
    } else if ([class isEqualToString:@"RouteMapViewController"]) {
        return nil; // handles it's own title
    } else if ([class isEqualToString:@"AnnouncementsViewController"]) {
        return @"Announcements";
    } else if ([class isEqualToString:@"StreetViewController"]) {
        return nil; // handles it's own title
    }
    
    return @"ERROR: UNMAPPED VC";
}
