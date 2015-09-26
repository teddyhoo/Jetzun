//
//  ReservationTableCell.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/13/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "ReservationTableCell.h"

@implementation ReservationTableCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _sharedVisits = [VisitsAndTracking sharedInstance];
        NSString *theDeviceType = [_sharedVisits tellDeviceType];
        
        if ([theDeviceType isEqualToString:@"iPhone6P"]) {
            
            NSLog(@"adding cell fields");
          
            _isIphone6P = YES;
            
            _backgroundBorder = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 411, 118)];
            [_backgroundBorder setImage:[UIImage imageNamed:@"border-cell-light-blue"]];
            
            
            _background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 412, 120)];
            _eventName = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 320, 30)];
            _startLocation = [[UILabel alloc]initWithFrame:CGRectMake(110, 40, 240, 18)];
            _endLocation = [[UILabel alloc]initWithFrame:CGRectMake(110, 65, 240, 18)];
            
            _driverImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 10, 10, 60, 60)];
            _driverName = [[UILabel alloc]initWithFrame:CGRectMake(_driverImage.frame.origin.x, _driverImage.frame.origin.y - 10, 200, 20)];
            _telphoneIcon = [[UIImageView alloc]initWithFrame:CGRectMake(_driverName.frame.origin.x -25, _driverName.frame.origin.y, 20, 20)];

            _startMapIcon = [[UIImageView alloc]initWithFrame:CGRectMake(_startLocation.frame.origin.x-20, _startLocation.frame.origin.y, 20, 20)];
            _endMapIcon = [[UIImageView alloc]initWithFrame:CGRectMake(_endLocation.frame.origin.x - 20, _endLocation.frame.origin.y, 20, 20)];
            
            _clockView = [[UIImageView alloc]initWithFrame:CGRectMake(_endLocation.frame.origin.x-20, 95, 20, 20)];
            _timeOfDay = [[UILabel alloc]initWithFrame:CGRectMake(_clockView.frame.origin.x + 40, 90, 200, 30)];
            
            _calendarView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 80, 80)];
            _dateDay = [[UILabel alloc]initWithFrame:CGRectMake(_calendarView.frame.origin.x + 5, _calendarView.frame.origin.y +5, 160, 24)];
            _dateNumber = [[UILabel alloc]initWithFrame:CGRectMake(_dateDay.frame.origin.x+10, _dateDay.frame.origin.y + 30, 160, 30)];

            _chargeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(_calendarView.frame.origin.x, _calendarView.frame.origin.y+85, 15, 15)];
            _tripCost = [[UILabel alloc]initWithFrame:CGRectMake(_chargeIcon.frame.origin.x + 20, _chargeIcon.frame.origin.y, 100, 20)];
            _distanceOfRide = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 180, 20)];
            
        }  else if ([theDeviceType isEqualToString:@"iPhone6"]) {
            _isIphone6 = YES;
            
        } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
            _isIphone5 = YES;
            
            _backgroundBorder = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 411, 118)];
            [_backgroundBorder setImage:[UIImage imageNamed:@"border-cell-light-blue"]];
            
            
            _background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 120)];
            _eventName = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 320, 30)];
            _startLocation = [[UILabel alloc]initWithFrame:CGRectMake(110, 40, 240, 18)];
            _endLocation = [[UILabel alloc]initWithFrame:CGRectMake(110, 65, 240, 18)];
            
            _driverImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
            _driverName = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 200, 20)];
            _telphoneIcon = [[UIImageView alloc]initWithFrame:CGRectMake(_driverName.frame.origin.x + 5, _driverName.frame.origin.y + 20, 20, 20)];
            
            _startMapIcon = [[UIImageView alloc]initWithFrame:CGRectMake(_startLocation.frame.origin.x-20, _startLocation.frame.origin.y, 20, 20)];
            _endMapIcon = [[UIImageView alloc]initWithFrame:CGRectMake(_endLocation.frame.origin.x - 20, _endLocation.frame.origin.y, 20, 20)];
            
            _clockView = [[UIImageView alloc]initWithFrame:CGRectMake(_endLocation.frame.origin.x-20, 95, 20, 20)];
            _timeOfDay = [[UILabel alloc]initWithFrame:CGRectMake(_clockView.frame.origin.x + 40, 90, 200, 30)];
            
            _calendarView = [[UIImageView alloc]initWithFrame:CGRectMake(330, 5, 80, 80)];
            _dateDay = [[UILabel alloc]initWithFrame:CGRectMake(350, 7, 160, 24)];
            _dateNumber = [[UILabel alloc]initWithFrame:CGRectMake(_dateDay.frame.origin.x+10, _dateDay.frame.origin.y + 30, 160, 30)];
            
            _chargeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(_calendarView.frame.origin.x, _calendarView.frame.origin.y+85, 15, 15)];
            _tripCost = [[UILabel alloc]initWithFrame:CGRectMake(_chargeIcon.frame.origin.x + 20, _chargeIcon.frame.origin.y, 100, 20)];
            _distanceOfRide = [[UILabel alloc]initWithFrame:CGRectMake(10, 70, 180, 20)];
            
            
        } else {
            _isIphone4 = YES;
        }
        
        [_background setImage:[UIImage imageNamed:@"tealbg1250x200"]];
        [_background setAlpha:0.4];
        
        [_clockView setImage:[UIImage imageNamed:@"clock-icon"]];
        [_telphoneIcon setImage:[UIImage imageNamed:@"mobile-phone-icon-orange-back"]];
        [_chargeIcon setImage:[UIImage imageNamed:@"DollarSymbol"]];
        [_calendarView setImage:[UIImage imageNamed:@"cal-icon-nohooks"]];
        
        [_startMapIcon setImage:[UIImage imageNamed:@"annotation-home-icon"]];
        [_endMapIcon setImage:[UIImage imageNamed:@"destination-star-icon"]];
        [_driverName setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
        [_startLocation setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
        [_endLocation setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
        [_eventName setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
        [_tripCost setFont:[UIFont fontWithName:@"Lato-Regular" size:18]];
 
        [_dateDay setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
        [_dateNumber setFont:[UIFont fontWithName:@"Lato-Bold" size:32]];
        [_timeOfDay setTextColor:[UIColor redColor]];
        [_timeOfDay setFont:[UIFont fontWithName:@"Lato-Regular" size:20]];
        
        [self.contentView addSubview:_background];
        [self.contentView addSubview:_backgroundBorder];
        [self.contentView addSubview:_calendarView];
        [self.contentView addSubview:_clockView];
        [self.contentView addSubview:_driverName];
        [self.contentView addSubview:_eventName];
        [self.contentView addSubview:_startLocation];
        [self.contentView addSubview:_endLocation];
        [self.contentView addSubview:_startMapIcon];
        [self.contentView addSubview:_endMapIcon];
        [self.contentView addSubview:_dateDay];
        [self.contentView addSubview:_dateNumber];
        [self.contentView addSubview:_timeOfDay];
        [self.contentView addSubview:_tripCost];
        [self.contentView addSubview:_chargeIcon];
        [self.contentView addSubview:_tripCost];
        [self.contentView addSubview:_telphoneIcon];
        
    }
    
    return self;
}


@end
