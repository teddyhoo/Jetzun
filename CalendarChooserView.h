//
//  CalendarChooserView.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/14/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "JTCalendarDayView.h"

@interface CalendarChooserView : UIView <JTCalendarDataSource>

@property(nonatomic,strong) JTCalendarMenuView *calendarMenuView;
@property(nonatomic,strong) JTCalendarContentView *calendarContentView;
@property(nonatomic,strong) JTCalendarDayView *dayView;
@property(nonatomic,strong) JTCalendar *calendar;
@property(nonatomic,strong) NSDate *chosenDate;

@property (nonatomic,strong) NSMutableArray *reservationData;
@property (nonatomic, strong) NSLayoutConstraint *calendarContentViewHeight;
@end
