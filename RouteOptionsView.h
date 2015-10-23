//
//  RouteOptionsView.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/16/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AKPickerView.h"

@interface RouteOptionsView : UIView

@property (nonatomic,strong) AKPickerView *typeOfCar;
@property (nonatomic,strong) AKPickerView *pickUpTimeHour;
@property (nonatomic,strong) AKPickerView *pickUpTimeMinute;

@property (nonatomic,strong) UIImageView *backDial;
@property (nonatomic,strong) UIImageView *backDial2;
@property (nonatomic,strong) UIImageView *backDial3;

@property (nonatomic,strong) NSArray *typeOfCars;
@property (nonatomic,strong) NSArray *hourTime;
@property (nonatomic,strong) NSArray *minutesTime;

@property (nonatomic,strong) UIImageView *backgroundChooseRoute;
@property (nonatomic,strong) UIButton *makeReservation;

@property (nonatomic,strong) UILabel *startLabel;
@property (nonatomic,strong) UILabel *endLabel;
@property (nonatomic,strong) UILabel *totalDistance;
@property (nonatomic,strong) UILabel *totalTime;
@property (nonatomic,strong) UILabel *estimatedCost;


@property (nonatomic,strong) UIButton *AMbutton;
@property (nonatomic,strong) UIButton *PMbutton;

@property (nonatomic,copy) NSString *pickupLocation;
@property (nonatomic,copy) NSString *dropOffLocation;
@property (nonatomic,copy) NSString *timeHour;
@property (nonatomic,copy) NSString *typeOfProduct;
@property (nonatomic,copy) NSString *amOrPm;

@property (nonatomic,copy) NSString *estimatedDistance;
@property (nonatomic,copy) NSString *estimatedTime;
@property (nonatomic,copy) NSString *costEstimate;


@end
