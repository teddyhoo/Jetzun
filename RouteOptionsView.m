//
//  RouteOptionsView.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/16/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "RouteOptionsView.h"
#import "LocationShareModel.h"
#import "VisitsAndTracking.h"

@interface RouteOptionsView() <AKPickerViewDataSource,AKPickerViewDelegate> {
    
}

@end

@implementation RouteOptionsView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        VisitsAndTracking *sharedInstance = [VisitsAndTracking sharedInstance];
        NSString *theDeviceType = sharedInstance.deviceType;
        
        
        
        
        if ([theDeviceType isEqualToString:@"iPhone6P"]) {
            
            _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
            _startLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 300, 20)];
            _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,25, 300, 20)];

        } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
            
            _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
            _startLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 300, 20)];
            _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,25, 300, 20)];

            
        } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
            
            _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
            _startLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 300, 20)];
            _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,25, 300, 20)];

        }
        
        [_backgroundChooseRoute setImage:[UIImage imageNamed:@"teal-bg"]];
        [self addSubview:_backgroundChooseRoute];
        
        UIImageView *startAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, 20, 20)];
        [startAnnotation setImage:[UIImage imageNamed:@"annotation-home-icon"]];
        [self addSubview:startAnnotation];
        
        UIImageView *endAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,25, 20, 20)];
        [endAnnotation setImage:[UIImage imageNamed:@"destination-star-icon"]];
        [self addSubview:endAnnotation];
        
        [_startLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
        [_startLabel setTextColor:[UIColor blackColor]];
        
        [self addSubview:_startLabel];
        
        [_endLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
        [_endLabel setTextColor:[UIColor blackColor]];

        [self addSubview:_endLabel];
        
        
        self.typeOfCars =  @[@"UberX",
                             @"UberXL",
                             @"Uber Black",
                             @"Uber SUV",
                             @"Ultra Lux",];
        
        self.hourTime = @[@"11",@"12",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
        self.minutesTime = @[@":00a",@":05a",@":10a",@":15a",@":20a",@":25a",@":30a",@":35a",@":40a",@":45a",@":50a",@":55a",@":00p",@":05p",@":10p",@":15p",@":20p",@":25p",@":30p",@":35p",@":40p",@":45p",@":50p",@":55p"];
        
        
        _typeOfProduct = _typeOfCars[0];
        _timeHour = _hourTime[0];
        _timeMinute = _minutesTime[0];
        
        _estimatedDistance = @"20";
        _costEstimate = @"20.00";
        _estimatedTime = @"10";
        
        [self setupPickerViews];
        
        _makeReservation = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeReservation.frame = CGRectMake(0,self.frame.size.height - 40, self.frame.size.width, 40);
        [_makeReservation setBackgroundImage:[UIImage imageNamed:@"purple-button"] forState:UIControlStateNormal];
        [_makeReservation addTarget:self action:@selector(optionsButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_makeReservation];
        
        UILabel *makeReservationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _makeReservation.frame.size.width, 40)];
        [makeReservationLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:20]];
        [makeReservationLabel setTextColor:[UIColor whiteColor]];
        [makeReservationLabel setText:@"RESERVE"];
        makeReservationLabel.textAlignment = NSTextAlignmentCenter;
        [_makeReservation addSubview:makeReservationLabel];
        
    }
    return self;
}

- (void) optionsButton {
    
    [_backDial removeFromSuperview];
    [_backDial2 removeFromSuperview];
    [_backDial3 removeFromSuperview];
    [_typeOfCar removeFromSuperview];
    [_pickUpTimeHour removeFromSuperview];
    [_pickUpTimeMinute removeFromSuperview];
    [_makeReservation removeFromSuperview];
    
    CGRect newFrame = CGRectMake(30,200, self.frame.size.width, 30);
    CGRect newFrame3 = CGRectMake(30,230, self.frame.size.width, 30);
    
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        _startLabel.frame = newFrame;
        _endLabel.frame = newFrame3;
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGRect newFrame2 = CGRectMake(0,0, self.frame.size.width, 60);
        CGRect newBounds = self.bounds;
        newBounds.size.width =self.bounds.size.width;
        newBounds.size.height = self.bounds.size.height/4;
        self.bounds = newBounds;
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
            self.frame = newFrame2;
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
        
    }];
    
    UIImageView *backTime = [[UIImageView alloc]initWithFrame:CGRectMake(0, 160, 60, 40)];
    [backTime setImage:[UIImage imageNamed:@"trip-summary-miles"]];
    [self addSubview:backTime];
    
    
    UIImageView *backCost = [[UIImageView alloc]initWithFrame:CGRectMake(60, 160, 60, 40)];
    [backCost setImage:[UIImage imageNamed:@"trip-summary-cost"]];
    [self addSubview:backCost];
    
    UIImageView *backPickup = [[UIImageView alloc]initWithFrame:CGRectMake(120, 160, 60, 40)];
    [backPickup setImage:[UIImage imageNamed:@"trip-summary-time"]];
    [self addSubview:backPickup];
    
    
    
    
    
    _totalDistance = [[UILabel alloc]initWithFrame:CGRectMake(10,160, 100,30)];
    _estimatedCost = [[UILabel alloc]initWithFrame:CGRectMake(70,160, self.frame.size.width,30)];
    _totalTime = [[UILabel alloc]initWithFrame:CGRectMake(130,160, 100,30)];

    [_totalDistance setFont:[UIFont fontWithName:@"CompassRoseCPC-Light" size:12]];
    [_totalDistance setText:@"10"];
    [self addSubview:_totalDistance];
    
    NSString *timeHour = [NSString  stringWithFormat:@"%@%@",_timeHour,_timeMinute];
    [_totalTime setFont:[UIFont fontWithName:@"CompassRoseCPC-Light" size:12]];
    [_totalTime setTextColor:[UIColor redColor]];
    [_totalTime setText:timeHour];
    [self addSubview:_totalTime];
    
    [_estimatedCost setFont:[UIFont fontWithName:@"CompassRoseCPC-Light" size:12]];
    [_estimatedCost setText:@"$23.47"];
    [self addSubview:_estimatedCost];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tripOptions" object:self];
    
}

-(void)setupPickerViews {
    
    VisitsAndTracking *sharedInstance = [VisitsAndTracking sharedInstance];
    NSString *theDeviceType = sharedInstance.deviceType;
    
    if ([theDeviceType isEqualToString:@"iPhone6P"]) {
        _backDial = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 420, 50)];
        _backDial2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 420, 50)];
        _backDial3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150, 420, 50)];
        self.typeOfCar = [[AKPickerView alloc]initWithFrame:CGRectMake(30,50, 420, 30)];
        self.pickUpTimeHour = [[AKPickerView alloc]initWithFrame:CGRectMake(30, 100 ,360, 30)];
        self.pickUpTimeMinute = [[AKPickerView alloc]initWithFrame:CGRectMake(30, 150 ,360, 30)];


    } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
        _backDial = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 420, 50)];
        _backDial2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 420, 50)];
        _backDial3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150, 420, 50)];
        self.typeOfCar = [[AKPickerView alloc]initWithFrame:CGRectMake(30,50, 420, 30)];
        self.pickUpTimeHour = [[AKPickerView alloc]initWithFrame:CGRectMake(30, 100 ,360, 30)];
        self.pickUpTimeMinute = [[AKPickerView alloc]initWithFrame:CGRectMake(30, 150 ,360, 30)];


    } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
        _backDial = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 320, 30)];
        _backDial2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 320, 30)];
        _backDial3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 110, 320, 30)];
        self.typeOfCar = [[AKPickerView alloc]initWithFrame:CGRectMake(30,50, 270, 30)];
        self.pickUpTimeHour = [[AKPickerView alloc]initWithFrame:CGRectMake(30, 80 ,270, 30)];
        self.pickUpTimeMinute = [[AKPickerView alloc]initWithFrame:CGRectMake(30, 110 ,270, 30)];

    }
    
    
    
    [_backDial setImage:[UIImage imageNamed:@"light-blue-box"]];
    [self addSubview:_backDial];
    
    [_backDial2 setImage:[UIImage imageNamed:@"light-blue-box"]];
    [self addSubview:_backDial2];
    
    [_backDial3 setImage:[UIImage imageNamed:@"light-blue-box"]];
    [self addSubview:_backDial3];
    
    self.typeOfCar.delegate = self;
    self.typeOfCar.dataSource = self;
    self.typeOfCar.tag = 1;
    //self.typeOfCar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.typeOfCar.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.typeOfCar.highlightedFont = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.typeOfCar.interitemSpacing = 20.0;
    self.typeOfCar.fisheyeFactor = 0.001;
    self.typeOfCar.pickerViewStyle = AKPickerViewStyle3D;
    [self addSubview:self.typeOfCar];
    
    self.pickUpTimeHour.delegate = self;
    self.pickUpTimeHour.dataSource = self;
    self.pickUpTimeHour.tag  = 2;
    //self.pickUpTimeHour.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pickUpTimeHour.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.pickUpTimeHour.highlightedFont = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.pickUpTimeHour.interitemSpacing = 20.0;
    self.pickUpTimeHour.fisheyeFactor = 0.0001;
    self.pickUpTimeHour.pickerViewStyle = AKPickerViewStyle3D;
    [self addSubview:self.pickUpTimeHour];
    
    self.pickUpTimeMinute.delegate = self;
    self.pickUpTimeMinute.dataSource = self;
    self.pickUpTimeMinute.tag  = 3;
    //self.pickUpTimeMinute.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.pickUpTimeMinute.font = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.pickUpTimeMinute.highlightedFont = [UIFont fontWithName:@"Lato-Regular" size:20];
    self.pickUpTimeMinute.interitemSpacing = 20.0;
    self.pickUpTimeMinute.fisheyeFactor = 0.0001;
    self.pickUpTimeMinute.pickerViewStyle = AKPickerViewStyle3D;
    [self addSubview:self.pickUpTimeMinute];
    
}


- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    
    if (pickerView.tag == 1) {
        return [self.typeOfCars count];
        
    } else if (pickerView.tag == 2) {
        return [self.hourTime count];
        
    } else if (pickerView.tag == 3) {
        return [self.minutesTime count];
        
    } else {
        return 0;
    }
    
}


- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
    
    if (pickerView.tag == 1) {
        return self.typeOfCars[item];
    } else if (pickerView.tag == 2) {
        return self.hourTime[item];
    } else if (pickerView.tag == 3) {
        return self.minutesTime[item];
    } else {
        return 0;
    }
    
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
    if (pickerView.tag == 1) {
        _typeOfProduct = _typeOfCars[item];
    } else if (pickerView.tag == 2) {
        _timeHour = _hourTime[item];
    } else if (pickerView.tag == 3) {
        _timeMinute = _minutesTime[item];
    }
}

@end
