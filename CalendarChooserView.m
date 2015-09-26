//
//  CalendarChooserView.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/14/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "CalendarChooserView.h"

@implementation CalendarChooserView


-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        NSString *pListData = [[NSBundle mainBundle]
                               pathForResource:@"EventAppointments"
                               ofType:@"plist"];
        
        _reservationData = [[NSMutableArray alloc]initWithContentsOfFile:pListData];

        self.calendar = [JTCalendar new];
        
        {
            self.calendar.calendarAppearance.calendar.firstWeekday = 1; // Sunday == 1, Saturday == 7
            self.calendar.calendarAppearance.dayCircleRatio = 8. / 10.;
            self.calendar.calendarAppearance.ratioContentMenu = 0.5;
            self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
            self.calendar.calendarAppearance.isWeekMode = NO;
            self.calendar.calendarAppearance.dayBackgroundColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.8 alpha:1.0];
        }
        
        self.calendarMenuView = [[JTCalendarMenuView alloc]initWithFrame:CGRectMake(0,0,self.frame.size.width, 30)];
        self.calendarContentView = [[JTCalendarContentView alloc]initWithFrame:CGRectMake(0, 30, self.frame.size.width,300)];
        [self.calendar setMenuMonthsView:self.calendarMenuView];
        [self.calendar setContentView:self.calendarContentView];
        
        [self addSubview:self.calendarMenuView];
        [self addSubview:self.calendarContentView];
        
        [self.calendar setDataSource:self];
        [self.calendar reloadData];
        
        
    }
    
    return self;
}
- (void)transitionExample
{
    CGFloat newHeight = 100;
    if(self.calendar.calendarAppearance.isWeekMode){
        newHeight = 75.;
    }
    
    [UIView animateWithDuration:0.5 delay:0.5 options:nil animations:^{
        self.calendarContentViewHeight.constant = newHeight;
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.25
                         animations:^{
                             self.calendarContentView.layer.opacity = 0;
                         }
                         completion:^(BOOL finished) {
                             [self.calendar reloadAppearance];
                             
                             [UIView animateWithDuration:.25
                                              animations:^{
                                                  self.calendarContentView.layer.opacity = 1;
                                              }];
                         }];
        
    }];
    
    
    [UIView animateWithDuration:.5
                     animations:^{
                         //self.calendarContentViewHeight.constant = newHeight;
                         //[self layoutIfNeeded];
                     }];
    
    [UIView animateWithDuration:.25
                     animations:^{
                         //self.calendarContentView.layer.opacity = 0;
                     }
                     completion:^(BOOL finished) {
                         //[self.calendar reloadAppearance];
                         
                         //[UIView animateWithDuration:.25
                                          //animations:^{
                                              //self.calendarContentView.layer.opacity = 1;
                                          //}];
                     }];
    
    /*CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, 40);
    CGRect newFrame2 = CGRectMake(0,40, self.frame.size.width, 60);
    CGRect newBounds = self.bounds;
    newBounds.size.width =self.bounds.size.width;
    newBounds.size.height = self.bounds.size.height/4;
    self.bounds = newBounds;
    
    
    [self layoutIfNeeded];
    [self.calendarContentView layoutIfNeeded];*/
    CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, 40);
    CGRect newFrame2 = CGRectMake(0,40, self.frame.size.width, 60);

    
    [UIView animateWithDuration:0.1 delay:1.1 options:UIViewAnimationOptionCurveLinear animations:^{
        self.calendarContentView.frame = newFrame2;
        [self.calendarContentView layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.calendarMenuView layoutIfNeeded];
        [UIView animateWithDuration:1.5 animations:^{
            self.calendarMenuView.frame = newFrame;
            [self.calendarMenuView layoutIfNeeded];
            
            CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, 40);
            CGRect newFrame2 = CGRectMake(0,40, self.frame.size.width, 60);
            CGRect newBounds = self.bounds;
            newBounds.size.width =self.bounds.size.width;
            newBounds.size.height = self.bounds.size.height/4;
            self.bounds = newBounds;
        }];

        [self layoutIfNeeded];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"choseDateService" object:self];
    }];
    
}


- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    for (NSDictionary *reservationsDic in _reservationData) {
        
        if (reservationsDic[key] && [reservationsDic[key]count] > 0) {
            return YES;
            
        }
    }
    
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    
    
    NSString *matchDateString = [[self dateFormatter]stringFromDate:date];
    NSString *dateStringEvent;
    
    NSLog(@"date picked: %@",matchDateString);
    for (NSDictionary *reservationsDic in _reservationData) {
        dateStringEvent = [reservationsDic objectForKey:@"ReservationFullDate"];
        
        if ([matchDateString isEqualToString:dateStringEvent]) {
            
            NSLog(@"event: %@",[reservationsDic objectForKey:@"ReservationID"]);
            
        }
    }
    
    _chosenDate = date;
    self.calendar.calendarAppearance.isWeekMode = !self.calendar.calendarAppearance.isWeekMode;
    [self transitionExample];
    
    
}

- (void)calendarDidLoadPreviousPage
{
    NSLog(@"Previous page loaded");
}

- (void)calendarDidLoadNextPage
{
    NSLog(@"Next page loaded");
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
