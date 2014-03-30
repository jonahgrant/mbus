//
//  Constants.m
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "Constants.h"

NSInteger const ARRIVALS_REFRESH_INTERVAL                  = 60; // one minute

NSString * const GOOGLE_MAPS_API_KEY                       = @"AIzaSyCCBKyJMm7zWhVxukAy8k-_ejMlc5t8ugo";
NSString * const DISCLAIMER                                = @"The system behind MBus is under development.  Riders are encouraged to use it, but reliable and accurate information is not garunteed";
NSString * const RATE_APP_URL                              = @"itms-apps://itunes.apple.com/app/id777435172";
NSString * const ACKNOWLEDGEMENTS_PLIST_PATH               = @"Pods-MBus-acknowledgements";
NSString * const ACKNOWLEDGEMENTS_PLIST_TYPE               = @"plist";
double const CAMPUS_CENTER_LAT                             = 42.282707;
double const CAMPUS_CENTER_LNG                             = -83.740196;
NSString * const SUPPORT_EMAIL_ADDRESS                     = @"mbus@jonahgrant.com";
NSString * const DEVELOPER_EMAIL_ADDRESS                   = @"jonah@jonahgrant.com";
NSString * const SUPPORT_EMAIL_SUBJECT                     = @"MBus Support";
NSString * const DEVELOPER_EMAIL_SUBJECT                   = @"Hi Jonah";
NSString * const NEVER                                     = @"never";
NSString * const BLANK_STRING                              = @" ";
NSString * const FORMATTED_ADDRESS                         = @"%@ %@\n%@, %@ %@";
NSString * const LOADING_ADDRESS                           = @"Loading address...";
NSString * const DISMISS                                   = @"Dismiss";
NSString * const FORMATTED_LAST_UPDATED                    = @"Last updated %@";
NSString * const FORMATTED_AS_OF                           = @"As of %@";
NSString * const ROUTE_INFORMATION                         = @"Route information";
NSString * const UNIVERSITY_OF_MICHIGAN                    = @"University of Michigan";
NSString * const NO_ROUTES_IN_SERVICE                      = @"NO ROUTES IN SERVICE";
NSString * const CALL_SAFE_RIDES                           = @"Call Safe Rides";
NSString * const ROUTES_IN_SERVICE                         = @"Routes in service";
NSString * const SAFE_RIDES_TEL                            = @"tel://7346478000";
NSString * const STREET_VIEW                               = @"Street View";
NSString * const DIRECTIONS                                = @"Directions";
NSString * const FORMATTED_APPLE_MAPS_DIRECTIONS           = @"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale";
NSString * const FORMATTED_ANNOUNCEMENTS_COUNT             = @"%i announcement%@";
NSString * const NEARBY_STOPS                              = @"Nearby stops";
NSString * const NEARBY_STOPS_IN_SERVICE                   = @"Nearby stops in service";
NSString * const FORMATTED_MORE_STOPS_CELL_TEXT            = @"%u MORE STOPS";
NSString * const NONE                                      = @"NONE";
NSString * const UNKNOWN_LOCATION                          = @"Uknown location";
NSString * const UNKNOWN                                   = @"unknown";
NSString * const FORMATTED_APPLE_MAPS_PIN                  = @"http://maps.apple.com/?q=%f,%f";
NSInteger const ADDRESS_CELL_HEIGHT = 80.0f;
NSString * const ABOUT_MAGIC_BUS_URL = @"http://mbus.pts.umich.edu/about-us/";
NSString * const MBUS_GITHUB_URL = @"http://github.com/jonahgrant/mbus/";

#pragma mark - Analytics

NSString * const ANALYTICS_FETCH_STOPS                     = @"fetch_stops";
NSString * const ANALYTICS_FETCH_ARRIVALS                  = @"fetch_arrivals";
NSString * const ANALYTICS_FETCH_BUSES                     = @"fetch_buses";
NSString * const ANALYTICS_FETCH_ANNOUNCEMENTS             = @"fetch_announcements";
NSString * const ANALYTICS_APP_OPENED                      = @"app_opened";
NSString * const ANALYTICS_APP_RECEIVED_LOCAL_NOTIFICATION = @"app_received_local_notification";
NSString * const ANALYTICS_APP_RECEIVED_MEMORY_WARNING     = @"app_received_memory_warning";
NSString * const ANALYTICS_STOP_ARRIVAL_NOTIFY             = @"stop_arrival_notify";
NSString * const ANALYTICS_STOP_ARRIVAL_VIEW_ROUTE         = @"stop_arrival_view_route";
NSString * const ANALYTICS_STOP_ARRIVAL_DISMISS            = @"stop_arrival_dismiss";
NSString * const ANALYTICS_STOP_DIRECTIONS                 = @"stop_directions";
NSString * const ANALYTICS_STOP_STREET_VIEW                = @"stop_street_view";
NSString * const ANALYTICS_STOP_ADDRESS                    = @"stop_address";
NSString * const ANALYTICS_BEGAN_STOPS_SEARCH              = @"began_stop_search";
NSString * const ANALYTICS_ENDED_STOPS_SEARCH              = @"ended_stop_search";
NSString * const ANALYTICS_CALL_SAFE_RIDES                 = @"called_safe_rides";
NSString * const ANALYTICS_MISC_MAP                        = @"view_map";
NSString * const ANALYTICS_MISC_ANNOUNCEMENTS              = @"view_announcements";
NSString * const ANALYTICS_MISC_ACKNOWLEDGEMENTS           = @"view_acknowledgements";
NSString * const ANALYTICS_MISC_CONTACT_SUPPORT            = @"contact_support";
NSString * const ANALYTICS_MISC_CONTACT_DEVELOPER          = @"contact_developer";
NSString * const ANALYTICS_MISC_REVIEW                     = @"review_app";
NSString * const ANALYTICS_MISC_ABOUT                      = @"view_about_magic_bus";
NSString * const ANALYTICS_VIEW_ROUTE_MAP                  = @"view_route_map";
NSString * const ANALYTICS_SELECT_STOP_ANNOTATION          = @"selected_stop_annotation";
NSString * const ANALYTICS_DISPLAY_STOP_ANNOTATION_TRAY    = @"display_stop_annotation_tray";
NSString * const ANALYTICS_HIDE_STOP_ANNOTATION_TRAY       = @"hide_stop_annotation_tray";
NSString * const ANALYTICS_FETCH_STOP_ADDRESS              = @"fetch_stop_address";
NSString * const ANALYTICS_STOPS_ANNOUNCEMENTS             = @"tapped_attention_announcements";
NSString * const ANALYTICS_VIEW_ALL_STOPS                  = @"view_all_stops";

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
    } else if ([class isEqualToString:@"NotificationViewController"]) {
        return @"Notify me";
    }
    
    return @"ERROR: UNMAPPED VC";
}
