//
//  Constants.h
//  MBus
//
//  Created by Jonah Grant on 3/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

@import MapKit;

extern NSInteger const ARRIVALS_REFRESH_INTERVAL;
extern NSString * const GOOGLE_MAPS_API_KEY;
extern NSString * const DISCLAIMER;
extern NSString * const RATE_APP_URL;
extern NSString * const ACKNOWLEDGEMENTS_PLIST_PATH;
extern NSString * const ACKNOWLEDGEMENTS_PLIST_TYPE;
extern double const CAMPUS_CENTER_LAT;
extern double const CAMPUS_CENTER_LNG;
extern NSString * const SUPPORT_EMAIL_ADDRESS;
extern NSString * const DEVELOPER_EMAIL_ADDRESS;
extern NSString * const SUPPORT_EMAIL_SUBJECT;
extern NSString * const DEVELOPER_EMAIL_SUBJECT;
extern NSString * const NEVER;
extern NSString * const BLANK_STRING;
extern NSString * const FORMATTED_ADDRESS;
extern NSString * const LOADING_ADDRESS;
extern NSString * const DISMISS;
extern NSString * const FORMATTED_LAST_UPDATED;
extern NSString * const FORMATTED_AS_OF;
extern NSString * const ROUTE_INFORMATION;
extern NSString * const UNIVERSITY_OF_MICHIGAN;
extern NSString * const NO_ROUTES_IN_SERVICE;
extern NSString * const CALL_SAFE_RIDES;
extern NSString * const ROUTES_IN_SERVICE;
extern NSString * const SAFE_RIDES_TEL;
extern NSString * const STREET_VIEW;
extern NSString * const DIRECTIONS;
extern NSString * const FORMATTED_APPLE_MAPS_DIRECTIONS;
extern NSString * const FORMATTED_ANNOUNCEMENTS_COUNT;
extern NSString * const NEARBY_STOPS;
extern NSString * const NEARBY_STOPS_IN_SERVICE;
extern NSString * const FORMATTED_MORE_STOPS_CELL_TEXT;
extern NSString * const NONE;
extern NSString * const UNKNOWN_DISTANCE;
extern NSString * const UNKNOWN;
extern NSString * const FORMATTED_APPLE_MAPS_PIN;

extern NSInteger const ADDRESS_CELL_HEIGHT;

#pragma mark - Analytics

extern NSString * const ANALYTICS_FETCH_STOPS;
extern NSString * const ANALYTICS_FETCH_ARRIVALS;
extern NSString * const ANALYTICS_FETCH_BUSES;
extern NSString * const ANALYTICS_FETCH_ANNOUNCEMENTS;
extern NSString * const ANALYTICS_APP_OPENED;
extern NSString * const ANALYTICS_APP_RECEIVED_LOCAL_NOTIFICATION;
extern NSString * const ANALYTICS_APP_RECEIVED_MEMORY_WARNING;
extern NSString * const ANALYTICS_STOP_ARRIVAL_NOTIFY; // when user taps an arrival and chooses to be notified before it arrives
extern NSString * const ANALYTICS_STOP_ARRIVAL_VIEW_ROUTE; // when user taps an arrival and chooses to view it's route
extern NSString * const ANALYTICS_STOP_ARRIVAL_DISMISS; // when user taps an arrival and chooses to dismiss the picker
extern NSString * const ANALYTICS_STOP_DIRECTIONS; // when user chooses to get directions to a stop
extern NSString * const ANALYTICS_STOP_STREET_VIEW; // when user chooses to view a stop's street view
extern NSString * const ANALYTICS_STOP_ADDRESS; // when a user chooses to view a stop's location on a map
extern NSString * const ANALYTICS_BEGAN_STOPS_SEARCH; // when a user taps the search bar to find a stop
extern NSString * const ANALYTICS_ENDED_STOPS_SEARCH; // when the user dismisses the search bar
extern NSString * const ANALYTICS_CALL_SAFE_RIDES; // when no buses are in service and user calls safe rides (called_safe_rides)
extern NSString * const ANALYTICS_MISC_MAP;
extern NSString * const ANALYTICS_MISC_ANNOUNCEMENTS;
extern NSString * const ANALYTICS_MISC_ACKNOWLEDGEMENTS;
extern NSString * const ANALYTICS_MISC_CONTACT_SUPPORT;
extern NSString * const ANALYTICS_MISC_CONTACT_DEVELOPER;
extern NSString * const ANALYTICS_MISC_REVIEW;
extern NSString * const ANALYTICS_MISC_ABOUT;
extern NSString * const ANALYTICS_VIEW_ROUTE_MAP; // (view_route_map)
extern NSString * const ANALYTICS_SELECT_STOP_ANNOTATION; // selected_stop_annotation
extern NSString * const ANALYTICS_DISPLAY_STOP_ANNOTATION_TRAY;
extern NSString * const ANALYTICS_HIDE_STOP_ANNOTATION_TRAY;
extern NSString * const ANALYTICS_FETCH_STOP_ADDRESS;

extern NSString * NSStringForUIViewController(UIViewController *viewController);
