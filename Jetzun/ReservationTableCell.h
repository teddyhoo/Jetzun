//
//  ReservationTableCell.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/13/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "MGSwipeTableCell.h"
#import "VisitsAndTracking.h"

@interface ReservationTableCell : MGSwipeTableCell


@property (nonatomic,strong) UIImageView *background;
@property (nonatomic,strong) UILabel *driverName;
@property (nonatomic,strong) UILabel *dateOfRide;
@property (nonatomic,strong) UILabel *lengthOfRide;
@property (nonatomic,strong) UILabel *distanceOfRide;
@property (nonatomic,strong) UILabel *costOfRide;
@property (nonatomic,strong) UILabel *startLocation;
@property (nonatomic,strong) UILabel *endLocation;
@property (nonatomic,strong) UILabel *dateDay;
@property (nonatomic,strong) UILabel *dateNumber;
@property (nonatomic,strong) UILabel *monthName;
@property (nonatomic,strong) UILabel *timeOfDay;
@property (nonatomic,strong) UILabel *tripCost;
@property (nonatomic,strong) UILabel *tripDistance;
@property (nonatomic,strong) UILabel *eventName;


@property (nonatomic,strong) UIImageView *driverImage;
@property (nonatomic,strong) UIImageView *vehicleImage;
@property (nonatomic,strong) UIImageView *backgroundBorder;
@property (nonatomic,strong) UIImageView *telphoneIcon;
@property (nonatomic,strong) UIImageView *chargeIcon;
@property (nonatomic,strong) UIImageView *noteIcon;
@property (nonatomic,strong) UIImageView *startMapIcon;
@property (nonatomic,strong) UIImageView *endMapIcon;
@property (nonatomic,strong) UIImageView *calendarView;
@property (nonatomic,strong) UIImageView *clockView;

@property BOOL isIphone6P;
@property BOOL isIphone6;
@property BOOL isIphone5;
@property BOOL isIphone4;
@property (nonatomic,strong) VisitsAndTracking *sharedVisits;

@end
