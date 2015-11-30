//
//  CalendarChooserView.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/14/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "CalendarChooserView.h"
#import "CustomCalendarDayView.h"

@interface CalendarChooserView() {
    
    NSMutableDictionary *_eventsByDate;    
    NSDate *_todayDate;
    NSDate *_minDate;
    NSDate *_maxDate;
}

@end


@implementation CalendarChooserView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _sharedVisitsTracking = [VisitsAndTracking sharedInstance];
        NSString *theDeviceType = [_sharedVisitsTracking tellDeviceType];

        if ([theDeviceType isEqualToString:@"iPhone6P"]) {
            _isIphone6P = YES;
            _isIphone6 = NO;
            _isIphone5 = NO;
            _isIphone4 = NO;
            
        } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
            _isIphone6 = YES;
            _isIphone6P = NO;
            _isIphone5 = NO;
            _isIphone4 = NO;
            
            
            
        } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
            _isIphone5 = YES;
            _isIphone6P = NO;
            _isIphone6 = NO;
            _isIphone4 = NO;
        }
        
        
        _dateAlreadySelected = NO;
        
        self.backgroundColor = [UIColor clearColor];
        NSString *pListData = [[NSBundle mainBundle]
                               pathForResource:@"EventAppointments"
                               ofType:@"plist"];
        
        _reservationData = [[NSMutableArray alloc]initWithContentsOfFile:pListData];
        
        _calendarContentView = [[JTHorizontalCalendarView alloc]initWithFrame:CGRectMake(0, 60, self.frame.size.width, 280)];
        _calendarContentView.backgroundColor = [UIColor blackColor];
        _calendarContentView.alpha = 0.7;
        
        [self addSubview:_calendarContentView];
        
        _calendarMenuView = [[JTCalendarMenuView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 60)];
        _calendarMenuView.backgroundColor = [UIColor colorWithRed:0.8 green:0.3 blue:0.2 alpha:0.8];
        _calendarMenuView.scrollView.backgroundColor = [UIColor colorWithRed:1.0 green:0.2 blue:0.2 alpha:0.6];
        _calendarMenuView.scrollView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_calendarMenuView];
        
        _calendarManager = [JTCalendarManager new];
        _calendarManager.delegate = self;
        _calendarManager.settings.weekDayFormat = JTCalendarWeekDayFormatShort;
    
        //[self createRandomEvents];
        [self createMinAndMaxDate];

        [_calendarManager setMenuView:_calendarMenuView];
        [_calendarManager setContentView:_calendarContentView];
        [_calendarManager setDate:[NSDate date]];
        
    }
    
    return self;
}
- (UIView<JTCalendarWeekDay> *)calendarBuildWeekDayView:(JTCalendarManager *)calendar
{
    JTCalendarWeekDayView *view = [JTCalendarWeekDayView new];
    
    for(UILabel *label in view.dayViews){
        label.textColor = [UIColor yellowColor];
        label.font = [UIFont fontWithName:@"CompassRoseCPC-Bold" size:14];
    }
    
    return view;
}

-(void)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

- (void)didChangeModeTouch:(NSDate*)withDate
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 75.;
    }
    NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
    [formatDate setDateFormat:@"MM-dd-YYYY"];
    NSString *dateString = [formatDate stringFromDate:withDate];
    NSLog(@"DATE: %@",dateString);
    
    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    if (_isIphone6P) {
        [_calendarContentView setFrame:CGRectMake(100, self.frame.size.height, self.frame.size.width-100, 95)];
        _dateButton.frame = CGRectMake(0,self.frame.size.height,100,95);
        
    } else if (_isIphone6) {
        [_calendarContentView setFrame:CGRectMake(100, self.frame.size.height-75, self.frame.size.width-100, 95)];
        _dateButton.frame = CGRectMake(0,self.frame.size.height-75,100,95);


    } else if (_isIphone5) {
        [_calendarContentView setFrame:CGRectMake(100, self.frame.size.height-100, self.frame.size.width-100, 75)];
        _dateButton.frame = CGRectMake(0,self.frame.size.height-100,100,75);


    } else if (_isIphone4) {
        [_calendarContentView setFrame:CGRectMake(100, self.frame.size.height-75, self.frame.size.width-100, 75)];
        _dateButton.frame = CGRectMake(0,self.frame.size.height-75,100,95);


    }
    
    [_dateButton setBackgroundImage:[UIImage imageNamed:@"green-bg"] forState:UIControlStateNormal];
    _dateButton.alpha = 0.0;
    
    [_calendarManager setDate:withDate];
    [self addLabelToDateButton:withDate];
    
    NSString *calMgrDate = [formatDate stringFromDate:_calendarManager.date];
    //self.calendarManager.constant = newHeight;
    [self layoutIfNeeded];
}

-(void)addLabelToDateButton:(NSDate*)chosenDate {
    
    NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
    [formatDate setDateFormat:@"MMM"];
    NSString *dateMonth= [formatDate stringFromDate:chosenDate];
    [formatDate setDateFormat:@"dd"];
    NSString *dateDayNum = [formatDate stringFromDate:chosenDate];
    
    UILabel *dateDayNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dateButton.frame.size.width/2-15, _dateButton.frame.size.height/2-10, 30, 32)];
    [dateDayNumLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [dateDayNumLabel setText:dateDayNum];
    _dateNum = dateDayNum;
    [_dateButton addSubview:dateDayNumLabel];
    
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dateButton.frame.size.width/2-25, _dateButton.frame.size.height-24, 40, 20)];
    
    [monthLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [monthLabel setText:[dateMonth uppercaseString]];
    
    
    _dateMon = [dateMonth uppercaseString];
    
    [_dateButton addSubview:monthLabel];
    
    NSString *dayOfWeekString;
    NSCalendar *gregorianCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorianCal components:(NSCalendarUnitYear |
                                                                 NSCalendarUnitMonth |
                                                                 NSCalendarUnitWeekOfYear |
                                                                 NSCalendarUnitWeekday)
                                                       fromDate:chosenDate];
    
    NSUInteger dayOfWeek = dateComponents.weekday;
    if (dayOfWeek == 1) {
        dayOfWeekString = @"SUN";
    } else if (dayOfWeek == 2) {
        dayOfWeekString = @"MON";
    } else if (dayOfWeek == 3) {
        dayOfWeekString = @"TUE";
    } else if (dayOfWeek == 4) {
        dayOfWeekString = @"WED";
    } else if (dayOfWeek == 5) {
        dayOfWeekString = @"THU";
    } else if (dayOfWeek == 6) {
        dayOfWeekString = @"FRI";
    } else if (dayOfWeek == 7) {
        dayOfWeekString = @"SAT";
    }
    
    _dayOfWeek = dayOfWeekString;
    
    UILabel *dayOfWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(_dateButton.frame.size.width/2-25, dateDayNumLabel.frame.size.height - 20, 60, 20)];
    [dayOfWeekLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [dayOfWeekLabel setText:dayOfWeekString];
    [_dateButton addSubview:dayOfWeekLabel];
}

- (UIView *)calendarBuildMenuItemView:(JTCalendarManager *)calendar
{
    
    
    UIView *menuItemView = [[UIView alloc]initWithFrame:CGRectMake(40,80, 180, 20)];
    _jetzunLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, 90,30)];
    [_jetzunLogo setImage:[UIImage imageNamed:@"logo-jetzun800"]];
    [menuItemView addSubview:_jetzunLogo];
    
    NSLog(@"Build menu item");
    //UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(_calendarMenuView.frame.origin.x+20, _calendarMenuView.frame.origin.y+80, 180, 20)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 80, 180, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Lato-Bold" size:22];
    
    [menuItemView addSubview:_jetzunLogo];
    [menuItemView addSubview:label];
    
    //return menuItemView;
    
    return label;
}



/*- (void)calendar:(JTCalendarManager *)calendar prepareMenuItemView:(UILabel *)menuItemView date:(NSDate *)date
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"MMMM yyyy";
        //dateFormatter.locale = _calendarManager.dateHelper.calendar.locale;
        //dateFormatter.timeZone = _calendarManager.dateHelper.calendar.timeZone;
    }
    
    menuItemView.text = [dateFormatter stringFromDate:date];
    NSLog(@"Prepare Menu Item View");

}*/



- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor orangeColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
        
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
        //dayView.textLabel.alpha = 0.0;
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}



- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}


- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:-3 toDate:_dateSelected options:nil];
    
    NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
    [formatDate setDateFormat:@"MM-dd-YYYY"];
    NSString *dateString = [formatDate stringFromDate:dayView.date];
    NSLog(@"DATE: %@",dateString);
    
    
    NSDateFormatter *formatDate2 = [[NSDateFormatter alloc]init];
    [formatDate2 setDateFormat:@"MMM"];
    NSString *dateMonth= [formatDate2 stringFromDate:_dateSelected];
    
    NSDateFormatter *formatDate3 = [[NSDateFormatter alloc]init];
    [formatDate3 setDateFormat:@"dd"];
    NSString *dateDayNum = [formatDate3 stringFromDate:_dateSelected];
    
    _dateNum = dateDayNum;
    _dateMon = [dateMonth uppercaseString];
    
    NSString *dayOfWeekString;
    NSCalendar *gregorianCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [gregorianCal components:(NSCalendarUnitYear |
                                                                 NSCalendarUnitMonth |
                                                                 NSCalendarUnitWeekOfYear |
                                                                 NSCalendarUnitWeekday)
                                                       fromDate:newDate];
    
    NSUInteger dayOfWeek = dateComponents.weekday;
    if (dayOfWeek == 1) {
        dayOfWeekString = @"SUN";
    } else if (dayOfWeek == 2) {
        dayOfWeekString = @"MON";
    } else if (dayOfWeek == 3) {
        dayOfWeekString = @"TUE";
    } else if (dayOfWeek == 4) {
        dayOfWeekString = @"WED";
    } else if (dayOfWeek == 5) {
        dayOfWeekString = @"THU";
    } else if (dayOfWeek == 6) {
        dayOfWeekString = @"FRI";
    } else if (dayOfWeek == 7) {
        dayOfWeekString = @"SAT";
    }
    
    _dayOfWeek = dayOfWeekString;
    
    if (_haveReservationOnDay) {
        
    
    } else {
    
        if (_dateAlreadySelected) {

        
        } else {
            _dateAlreadySelected = YES;
            _calendarContentView.alpha = 0.9;
            
            [_calendarMenuView setPreviousDate:newDate currentDate:_dateSelected nextDate:nil];
            
            CGRect newFrame;
            
            if(_isIphone6P) {
                newFrame = CGRectMake(60, 70, self.frame.size.width, 100);

            } else if (_isIphone5) {
                
                newFrame = CGRectMake(0, 70, self.frame.size.width, 100);
            }
            
            
            [UIView animateWithDuration:0.5 animations:^{
                
                //
                self.alpha = 0.5;
                dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
                
                [UIView transitionWithView:dayView
                                  duration:.3
                                   options:0
                                animations:^{
                                    dayView.circleView.transform = CGAffineTransformIdentity;
                                    _calendarMenuView.alpha = 0.8;
                                    [_calendarManager reload];
                                } completion:^(BOOL finished) {
                                    [self didChangeModeTouch:dayView.date];
                                }];
                
            } completion:^(BOOL finished) {
                
                _calendarContentView.frame = newFrame;
                
                
                if (_isIphone6P) {
                    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    _dateButton.frame = CGRectMake(0,80,60,90);
                    
                } else if (_isIphone6) {
                    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    _dateButton.frame = CGRectMake(0,80,100,95);
                    
                    
                } else if (_isIphone5) {
                    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];

                    _dateButton.frame = CGRectMake(0,80,100,90);
                    
                    
                } else if (_isIphone4) {
                    _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    _dateButton.frame = CGRectMake(0,self.frame.size.height-75,100,95);
                    
                }
                
                [_dateButton setBackgroundImage:[UIImage imageNamed:@"green-bg"] forState:UIControlStateNormal];
                _dateButton.alpha = 1.0;
                [self addLabelToDateButton:_dateSelected];
                //[self addSubview:_dateButton];
                
                [_calendarMenuView removeFromSuperview];
                
            }];
            
        }
       

        
        
        
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"choseDateService" object:self];
    }
    
    
}

- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}



@end
