//
//  JTCalendarSettings.m
//  JTCalendar
//
//  Created by Jonathan Tribouharet
//

#import "JTCalendarSettings.h"

@implementation JTCalendarSettings

- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    [self commonInit];
    
    return self;
}

- (void)commonInit
{
    _pageViewHideWhenPossible = YES;
    _pageViewNumberOfWeeks = 5;
    _pageViewHaveWeekDaysView = YES;
    _weekDayFormat = JTCalendarWeekDayFormatShort;
    _weekModeEnabled = NO;
    _pageViewWeekModeNumberOfWeeks = 1;
}

@end
