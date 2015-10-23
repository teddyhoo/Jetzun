//
//  CalendarViewController.h
//  Example
//
//  Created by Ted Hooban on 10/2/15.
//  Copyright © 2015 Jonathan Tribouharet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"
#import "JTCalendarDayView.h"

@interface CalendarViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (nonatomic,strong) UIView *visitDetails;

@property (nonatomic,strong) NSString *startDatePicked;
@property (nonatomic,strong) NSString *endDatePicked;
@property (nonatomic,strong) NSMutableArray *selectedDates;

@property (nonatomic,strong) UITableView *reservationsTable;
@property (nonatomic,strong) NSMutableArray *reservationData;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@end
