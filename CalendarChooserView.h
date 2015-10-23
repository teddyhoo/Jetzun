//
//  CalendarChooserView.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/14/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "VisitsAndTracking.h"

@interface CalendarChooserView : UIView <JTCalendarDelegate>

@property (strong, nonatomic) JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTHorizontalCalendarView *calendarContentView;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (strong,nonatomic) NSDate *dateSelected;


@property (nonatomic,strong) NSDate *chosenDate;
@property (nonatomic,strong) NSMutableArray *reservationData;
@property (nonatomic,strong) NSMutableArray *currentReservations;
@property (nonatomic, strong) NSLayoutConstraint *calendarContentViewHeight;
@property (nonatomic,strong) UIButton *dateButton;
@property (nonatomic,strong) VisitsAndTracking *sharedVisitsTracking;

@property (nonatomic,copy) NSString *dayOfWeek;
@property (nonatomic,copy) NSString *dateNum;
@property (nonatomic,copy) NSString *dateMon;

@property BOOL dateAlreadySelected;
@property BOOL haveReservationOnDay;
@property BOOL isIphone4;
@property BOOL isIphone5;
@property BOOL isIphone6;
@property BOOL isIphone6P;


@end
