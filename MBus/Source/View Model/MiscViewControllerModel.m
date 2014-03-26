//
//  MiscViewControllerModel.m
//  MBus
//
//  Created by Jonah Grant on 2/27/14.
//  Copyright (c) 2014 Jonah Grant. All rights reserved.
//

#import "MiscViewControllerModel.h"
#import "DataStore.h"

NSString * NSStringFromSection(Section section) {
    switch (section) {
        case SectionMore:
            return @"More";
        case SectionContact:
            return @"Contact";
        case SectionLegal:
            return @"Legal";
        case SectionMisc:
            return @"Misc";
        default:
            break;
    }
}

NSString * NSStringFromCell(Cell cell) {
    switch (cell) {
        case CellAcknowledgements:
            return @"Acknowledgements";
        case CellSupport:
            return @"Contact support";
        case CellContact:
            return @"Email the developer";
        case CellReview:
            return @"Leave a review";
        case CellAbout:
            return @"About Magic Bus";
        case CellMap:
            return @"Map";
        case CellAnnouncements:
        {
            NSUInteger announcementsCount = [DataStore sharedManager].announcements.count;
            return [[NSString stringWithFormat:@"%lu", (unsigned long)announcementsCount] stringByAppendingString:(announcementsCount > 1) ? @" announcements" : @" announcement"];
        }
        case CellSource:
            return @"Open sourced on Github";
        default:
            return nil;
    }
}

extern NSInteger NSIntegerForCell(Cell cell) {
    // this is relative to it's order in it's own section
    // there really isn't any computation involved here, you just need to
    // know where each cell sits in it's respective section
    // if the returned value is incorrect, it is possible the entire
    // functionality of a cell's section will fail
    
    switch (cell) {
            // More
        case CellMap:
            return 0;
        case CellAnnouncements:
            return 1;
            // Legal
        case CellAcknowledgements:
            return 0;
            // Contact
        case CellSupport:
            return 0;
        case CellContact:
            return 1;
            // Misc
        case CellReview:
            return 0;
        case CellAbout:
            return 1;
        case CellSource:
            return 2;
        default:
            return 0;
    }
}

extern NSInteger NSIntegerForSection(Section section) {
    switch (section) {
        case SectionMore:
            return 0;
        case SectionContact:
            return 1;
        case SectionMisc:
            return 2;
        case SectionLegal:
            return 3;
        default:
            return 0;
    }
}

@interface MiscViewControllerModel ()

@property (nonatomic, strong, readwrite) NSArray *sections;
@property (nonatomic, strong, readwrite) NSDictionary *cells;

@end

@implementation MiscViewControllerModel

- (instancetype)init {
    if (self = [super init]) {
        self.sections = @[NSStringFromSection(SectionMore),
                          NSStringFromSection(SectionContact),
                          NSStringFromSection(SectionMisc),
                          NSStringFromSection(SectionLegal)];
        
        self.cells = @{self.sections[0]: @[NSStringFromCell(CellMap),
                                           NSStringFromCell(CellAnnouncements)],
                       self.sections[1]: @[NSStringFromCell(CellSupport),
                                           NSStringFromCell(CellContact)],
                       self.sections[2]: @[NSStringFromCell(CellReview),
                                           NSStringFromCell(CellAbout),
                                           NSStringFromCell(CellSource)],
                       self.sections[3]: @[NSStringFromCell(CellAcknowledgements)]};
    }
    return self;
}

@end
