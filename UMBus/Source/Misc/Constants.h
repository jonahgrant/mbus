//
//  Constants.h
//  UMBus
//
//  Created by Jonah Grant on 1/1/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#pragma Keys
// prefix must be kKey

static NSString * kKeyGoogleMapsAPI = @"AIzaSyCCBKyJMm7zWhVxukAy8k-_ejMlc5t8ugo";

#pragma Button title
// suffix must be kButtonTitle

static NSString * kButtonTitleDirections = @"Directions";
static NSString * kButtonTitleStreetView = @"Street View";

#pragma Formatted strings
// prefix must be kFormattedString

static NSString * kFormattedStringAppleMapsDirections = @"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=Posizione attuale";
static NSString * kFormattedStringAddress = @"%@ %@\n%@, %@ %@";
static NSString * kFormattedStringLastUpdated = @"Last updated %@";
static NSString * kFormattedStringXAnnouncements = @"%i announcements";

#pragma Errors
// prefix must be kError

static NSString * kErrorUnknownDistance = @"Unknown distance";
static NSString * kErrorNoStopsInService = @"NO STOPS BEING SERVICED";
static NSString * kErrorNoRoutesInService = @"NO ROUTES IN SERVICE";

#pragma UITableView section headers
// prefix must be kTableHeader

static NSString * kTableHeaderRoutesServicingStop = @"Routes servicing this stop";
static NSString * kTableHeaderRoutesInService = @"Routes in service";
static NSString * kTableHeaderRouteInformation = @"Route information";

#pragma UITableView section footers
// prefix must be kTableFooter

static NSString * kTableFooterUnderDevelopment = @"The system behind MBus is under development.  Riders are encouraged to use it, but reliable and accurate information is not garunteed.";

#pragma Misc
// no prefix; go nuts with this one

static NSString * kBusAnnotationTitle = @"Bus";
static NSString * kUniversityOfMichigan = @"University of Michigan";
static NSString * kDismiss = @"Dismiss";
static NSString * kMap = @"Map";
static NSString * kAnnouncements = @"Announcements";
static NSString * kCallSafeRides = @"Call Safe Rides";
static NSString * kSafeRidesTel = @"tel://7346478000";
static NSString * kLoadingAddress = @"Loading address...";
static NSString * kBlankString = @" ";
static NSString * kNever = @"never";