//
//  GalleryView.m
//  LeashTimeClientPet
//
//  Created by Ted Hooban on 6/16/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GalleryView.h"
#import "VisitsAndTracking.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"


@interface GalleryView() {
    
}
@property (nonatomic,strong) UIImageView *currentImageFrame;
@property (nonatomic,strong) UILabel *captionLabel;
@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) NSDateFormatter *monthFormat;
@property (nonatomic,strong) NSDateFormatter *dayFormat;
@end


@implementation GalleryView



-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        self.userInteractionEnabled  = YES;
        
        VisitsAndTracking *sharedVisits = [VisitsAndTracking sharedInstance];
        
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"YYYY-MM-dd"];
        _monthFormat = [[NSDateFormatter alloc]init];
        [_monthFormat setDateFormat:@"MMM"];
        _dayFormat = [[NSDateFormatter alloc]init];
        [_dayFormat setDateFormat:@"dd"];
        
        if ([sharedVisits.deviceType isEqualToString:@"iPhone6P"]) {
            _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.height-300)];
            
            
        } else if ([sharedVisits.deviceType isEqualToString:@"iPhone6"]) {
            _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.height-300)];
            
            
        } else if ([sharedVisits.deviceType isEqualToString:@"iPhone5"]) {
            _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 120, self.frame.size.height-400)];
            
            
        } else if ([sharedVisits.deviceType isEqualToString:@"iPhone4"]) {
            
        }
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
           andData:(NSString *)carType
         andPickup:(NSString*)pickup
        andDropoff:(NSString*)dropOff
           andHour:(NSString*)hour
            andMin:(NSString*)min
            onDate:(NSString*)date
        withCharge:(NSString *)charge
{
    
    self = [self initWithFrame:frame];
    self.userInteractionEnabled  = YES;
    
    VisitsAndTracking *sharedVisits = [VisitsAndTracking sharedInstance];
    
    NSLog(@"pickup: %@",pickup);
    UILabel *title;

    UIImageView *calendarIcon;
    UILabel *dateLabel;
    UILabel *dateLabel2;
    UIImageView *pickupTimeIcon;
    UILabel *pickupTimeLabel;
    UIImageView *costIcon;
    UILabel *chargeLabel;
    
    UIImageView *pickupIcon;
    UIImageView *dropoffIcon;
    UILabel *caption1;
    UILabel *caption2;
    UILabel *caption3;
    UILabel *caption1Title;
    UIButton *acceptReservationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    NSDate *dateMonth = [[NSDate alloc]init];
    dateMonth = [_dateFormatter dateFromString:date];
    NSString *monthStr = [_monthFormat stringFromDate:dateMonth];
    NSString *dayStr = [_dayFormat stringFromDate:dateMonth];
    NSString *upperMonth = [monthStr uppercaseString];
    
    if ([sharedVisits.deviceType isEqualToString:@"iPhone6P"]) {
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.height)];
        
        calendarIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 50, 80, 80)];
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 60, 44, 20)];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(40, 80, 44, 30)];
        dateLabel2.textAlignment = NSTextAlignmentCenter;
        
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(130, 50, 300, 22)];
        pickupTimeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 140, 20, 20)];
        pickupTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,140,120,20)];
        
        costIcon = [[UIImageView alloc]initWithFrame:CGRectMake(130, 110, 20, 20)];
        chargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(costIcon.frame.origin.x + 30, costIcon.frame.origin.y, 100, 20)];
        pickupIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 150, 30, 30)];
        caption2 = [[UILabel alloc]initWithFrame:CGRectMake(pickupIcon.frame.origin.x + 30, pickupIcon.frame.origin.y, 300, 20)];
        dropoffIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 200, 30, 30)];
        caption3 = [[UILabel alloc]initWithFrame:CGRectMake(dropoffIcon.frame.origin.x + 30, dropoffIcon.frame.origin.y, 300, 40)];
        caption1Title = [[UILabel alloc]initWithFrame:CGRectMake(130, 95, 300, 20)];
        caption1 = [[UILabel alloc]initWithFrame:CGRectMake(caption1Title.frame.origin.x + 80, caption1Title.frame.origin.y, 300, 20)];
        acceptReservationButton.frame = CGRectMake(40, self.frame.size.height - 50, 260, 40);
        
    } else if ([sharedVisits.deviceType isEqualToString:@"iPhone6"]) {

        
        
        
        
        
        
        
    } else if ([sharedVisits.deviceType isEqualToString:@"iPhone5"]) {
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 120, self.frame.size.height-400)];
        
        calendarIcon = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 80, 80)];
        dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 35, 300, 20)];
        dateLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(45, 60, 300, 40)];
        title = [[UILabel alloc]initWithFrame:CGRectMake(130, 30, 300, 22)];
        pickupTimeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(130, 60, 20, 20)];
        pickupTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(pickupTimeIcon.frame.origin.x + 30, pickupTimeIcon.frame.origin.y, 200, 30)];
        costIcon = [[UIImageView alloc]initWithFrame:CGRectMake(25, 120, 20, 20)];
        chargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(costIcon.frame.origin.x + 30, costIcon.frame.origin.y, 100, 20)];
        pickupIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 190, 30, 30)];
        caption2 = [[UILabel alloc]initWithFrame:CGRectMake(pickupIcon.frame.origin.x + 30, pickupIcon.frame.origin.y, 300, 20)];
        dropoffIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 240, 30, 30)];
        caption3 = [[UILabel alloc]initWithFrame:CGRectMake(dropoffIcon.frame.origin.x + 30, dropoffIcon.frame.origin.y, 300, 40)];
        caption1Title = [[UILabel alloc]initWithFrame:CGRectMake(140, 55, 300, 20)];
        caption1 = [[UILabel alloc]initWithFrame:CGRectMake(caption1Title.frame.origin.x + 80, caption1Title.frame.origin.y, 300, 20)];
        acceptReservationButton.frame = CGRectMake(40, 520, 260, 40);
        
    } else if ([sharedVisits.deviceType isEqualToString:@"iPhone4"]) {
        
    }
    
    [_backImage setImage:[UIImage imageNamed:@"background-darkblue-lightblue"]];
    [calendarIcon setImage:[UIImage imageNamed:@"side_button"]];
    [pickupTimeIcon setImage:[UIImage imageNamed:@"clock-icon-hands"]];
    [costIcon setImage:[UIImage imageNamed:@"DollarSymbol"]];
    [pickupIcon setImage:[UIImage imageNamed:@"annotation-home-icon"]];
    [dropoffIcon setImage:[UIImage imageNamed:@"destination-star-icon"]];

    [dateLabel setText:upperMonth];
    [dateLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Bold" size:16]];
    [dateLabel setTextColor:[UIColor blackColor]];
    [dateLabel2 setText:dayStr];
    [dateLabel2 setFont:[UIFont fontWithName:@"CompassRoseCPC-Light" size:32]];
    [dateLabel2 setTextColor:[UIColor blackColor]];
    
    
    [chargeLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Bold" size:18]];
    [chargeLabel setTextColor:[UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0]];
    [chargeLabel setText:charge];
    
    [title setText:@"RESERVATION: PENDING"];
    [title setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [title setTextColor:[UIColor whiteColor]];
    
    [pickupTimeLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:20]];
    [pickupTimeLabel setTextColor:[UIColor redColor]];
    [pickupTimeLabel setText:hour];
    
    [caption2 setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [caption2 setText:pickup];
    
    [caption2 setTextColor:[UIColor blackColor]];
    [self addSubview:caption2];
    caption2.textAlignment = NSTextAlignmentLeft;
    
    [caption3 setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [caption3 setText:dropOff];
    
    [caption3 setTextColor:[UIColor blackColor]];
    [self addSubview:caption3];
    caption3.textAlignment = NSTextAlignmentLeft;
    
    
    [caption1Title setText:@"Product"];
    [caption1Title setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [caption1Title setTextColor:[UIColor blackColor]];

    [caption1 setText:carType];
    [caption1 setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [caption1 setTextColor:[UIColor blackColor]];

    [_backImage addSubview:_currentImageFrame];
    [_backImage addSubview:_captionLabel];

    [self addSubview:_backImage];
    [self addSubview:calendarIcon];
    [self addSubview:dateLabel];
    [self addSubview:dateLabel2];
    [self addSubview:title];
    [self addSubview:pickupTimeIcon];
    [self addSubview:pickupTimeLabel];
    [self addSubview:costIcon];
    [self addSubview:chargeLabel];
    [self addSubview:pickupIcon];
    [self addSubview:dropoffIcon];
    [self addSubview:caption1Title];
    [self addSubview:caption1];

    [acceptReservationButton setImage:[UIImage imageNamed:@"purple-button"] forState:UIControlStateNormal];
    [acceptReservationButton addTarget:self action:@selector(acceptReservation) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acceptReservationButton];
    
    UILabel *buttonLabel = [[UILabel alloc]initWithFrame:CGRectMake(acceptReservationButton.frame.origin.x, acceptReservationButton.frame.origin.y, acceptReservationButton.frame.size.width, self.frame.size.height-50)];
    buttonLabel.textAlignment = NSTextAlignmentCenter;
    [buttonLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Bold" size:18]];
    [buttonLabel setTextColor:[UIColor whiteColor]];
    [buttonLabel setText:@"CANCEL"];
    [self addSubview:buttonLabel];
    
    return self;
    
    
}

-(id)initWithFrame:(CGRect)frame
           andData:(NSString *)imageName
        andCaption:(NSString *)captionText {
    
    self = [self initWithFrame:frame];
    self.userInteractionEnabled  = YES;
    
    _currentImageFrame  = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 64, 64)];
    [_currentImageFrame setImage:[UIImage imageNamed:imageName]];
    
    _captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(94, 20, 300, 40)];
    [_captionLabel setText:captionText];
    [_captionLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:18]];
    [_captionLabel setTextColor:[UIColor blackColor]];
    
    
    VisitsAndTracking *sharedVisits = [VisitsAndTracking sharedInstance];
    if ([sharedVisits.deviceType isEqualToString:@"iPhone6P"]) {
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.height)];
        
        
    } else if ([sharedVisits.deviceType isEqualToString:@"iPhone6"]) {
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.height-300)];
        
        
    } else if ([sharedVisits.deviceType isEqualToString:@"iPhone5"]) {
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 120, self.frame.size.height-400)];
        
        
    } else if ([sharedVisits.deviceType isEqualToString:@"iPhone4"]) {
        
    }
    
    
    [_backImage setImage:[UIImage imageNamed:@"cream-1200x1900"]];
    [_backImage addSubview:_currentImageFrame];
    [_backImage addSubview:_captionLabel];
    [self addSubview:_backImage];
    
    _vehiclePhoto = [[UIImageView alloc]initWithFrame:CGRectMake(10,115,_backImage.frame.size.width-20, 160)];
    [self addSubview:_vehiclePhoto];
    
    return self;
    
}

-(id)initWithFrame:(CGRect)frame
           andData:(NSString *)imageName
        andCaption:(NSString *)captionText
              type:(NSString*)typeOfCards {
    
    self = [self initWithFrame:frame];
    self.userInteractionEnabled  = YES;
    
    _currentImageFrame  = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 64, 64)];
    [_currentImageFrame setImage:[UIImage imageNamed:imageName]];
    
    
    _captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(94, 20, 300, 40)];
    [_captionLabel setText:captionText];
    [_captionLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:18]];
    [_captionLabel setTextColor:[UIColor blackColor]];
    
    _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.height-300)];
    if ([typeOfCards isEqualToString:@"Urgent"]) {
        [_backImage setImage:[UIImage imageNamed:@"category-card-red"]];
    } else {
        [_backImage setImage:[UIImage imageNamed:@"cream-1200x1900"]];
    }
    [_backImage setImage:[UIImage imageNamed:@"cream-1200x1900"]];
    [_backImage addSubview:_currentImageFrame];
    [_backImage addSubview:_captionLabel];
    [self addSubview:_backImage];
    
    return self;
}


-(id)initWithFrame:(CGRect)frame andData:(ReservationDetails*)reservationInfo {
    
    
    
    
    return self;
}

-(void) acceptReservation {
    
    NSLog(@"accept reservation");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInView:self];
    
}


@end
