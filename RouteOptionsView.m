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
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3;
        [self addSubview:backView];
        
 
        UIImageView *startAnnotation;
        UIImageView *endAnnotation;
        _makeReservation = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        if ([theDeviceType isEqualToString:@"iPhone6P"]) {
            
            _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
            _startLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 300, 20)];
            _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,25, 300, 20)];
            startAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, 20, 20)];
            endAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,25, 20, 20)];
            _makeReservation.frame = CGRectMake(0,self.frame.size.height - 60, self.frame.size.width, 60);

        } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
            
            _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
            _startLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 300, 20)];
            _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,25, 300, 20)];
            startAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, 20, 20)];
            endAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,25, 20, 20)];
            _makeReservation.frame = CGRectMake(0,self.frame.size.height - 50, self.frame.size.width, 50);
            
        } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
            
            _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
            _startLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 300, 20)];
            _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,25, 300, 20)];
            startAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, 20, 20)];
            endAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,25, 20, 20)];
            _makeReservation.frame = CGRectMake(0,self.frame.size.height - 50, self.frame.size.width, 50);
            
        } else if ([theDeviceType isEqualToString:@"iPhone4"]) {
            _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
            _startLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 300, 20)];
            _endLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,25, 300, 20)];
            startAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,0, 20, 20)];
            endAnnotation = [[UIImageView alloc]initWithFrame:CGRectMake(10,25, 20, 20)];
            _makeReservation.frame = CGRectMake(0,self.frame.size.height - 50, self.frame.size.width, 50);

        }
        
        [startAnnotation setImage:[UIImage imageNamed:@"startAnnotationShadow"]];
        [self addSubview:startAnnotation];
        
        [endAnnotation setImage:[UIImage imageNamed:@"destination-star-icon"]];
        [self addSubview:endAnnotation];
        
        [_startLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
        [_startLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_startLabel];
        
        [_endLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
        [_endLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_endLabel];
        
        
        self.typeOfCars =  @[@"UberX",
                             @"UberXL",
                             @"Uber Black",
                             @"Uber SUV",
                             @"Ultra Lux",];
        
        self.hourTime = @[@"12:00",@"12:15",@"12:30",@"12:45",@"1:00",@"1:15",@"1:30",@"1:45",@"2:00",@"2:15",@"2:30",
                          @"2:45",@"3:00",@"3:15",@"3:30",@"3:45",@"4:00",@"4:15",@"4:30",@"4:45",@"5:00",@"6:00",
                          @"6:15",@"6:30",@"6:45",@"7:00",@"7:15",@"7:30",@"7:45",@"8:00",@"8:15",@"8:30",@"8:45",
                          @"9:00",@"9:15",@"9:30",@"9:45",@"10:00",@"10:15",@"10:30",@"10:45",@"11:00",@"11:15",
                          @"11:30",@"11:45"];

        
        _typeOfProduct = _typeOfCars[0];
        _timeHour = _hourTime[0];
        
        _estimatedDistance = @"20";
        _costEstimate = @"20.00";
        _estimatedTime = @"10";
        
        [self setupPickerViews];
        
        
        [_makeReservation setBackgroundImage:[UIImage imageNamed:@"green-bg"] forState:UIControlStateNormal];
        [_makeReservation addTarget:self action:@selector(optionsButton) forControlEvents:UIControlEventTouchUpInside];
        _makeReservation.alpha = 0.8;
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
    [_typeOfCar removeFromSuperview];
    [_pickUpTimeHour removeFromSuperview];
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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"tripOptions" object:self];
    
}

-(void)setupPickerViews {
    
    VisitsAndTracking *sharedInstance = [VisitsAndTracking sharedInstance];
    NSString *theDeviceType = sharedInstance.deviceType;
    
    UILabel *amLabel;
    UILabel *pmLabel;
    _AMbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _PMbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([theDeviceType isEqualToString:@"iPhone6P"]) {
        _backDial = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 420, 60)];
        _backDial2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 110, 420, 60)];
        self.typeOfCar = [[AKPickerView alloc]initWithFrame:CGRectMake(30,50, 420, 60)];
        self.pickUpTimeHour = [[AKPickerView alloc]initWithFrame:CGRectMake(30, 100 ,360, 60)];
        
        
        amLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        pmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];

        _AMbutton.frame = CGRectMake(self.frame.size.width-30, _backDial2.frame.origin.y+30, 30, 30);
        _PMbutton.frame = CGRectMake(self.frame.size.width-30, _backDial2.frame.origin.y, 30, 30);

    } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
        _backDial = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 380, 60)];
        _backDial2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 120, 380, 60)];
        self.typeOfCar = [[AKPickerView alloc]initWithFrame:CGRectMake(30,50, 420, 60)];
        self.pickUpTimeHour = [[AKPickerView alloc]initWithFrame:CGRectMake(30, 100 ,360, 60)];
        amLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        pmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        _AMbutton.frame = CGRectMake(self.frame.size.width-30, _backDial2.frame.origin.y+30, 30, 30);
        _PMbutton.frame = CGRectMake(self.frame.size.width-30, _backDial2.frame.origin.y, 30, 30);

    } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
        _backDial = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 420, 60)];
        _backDial2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 110, 420, 60)];
        self.typeOfCar = [[AKPickerView alloc]initWithFrame:CGRectMake(30,50, 420, 60)];
        self.pickUpTimeHour = [[AKPickerView alloc]initWithFrame:CGRectMake(30, 100 ,360, 60)];
        amLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        pmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        
        _AMbutton.frame = CGRectMake(self.frame.size.width-30, _backDial2.frame.origin.y+30, 30, 30);
        _PMbutton.frame = CGRectMake(self.frame.size.width-30, _backDial2.frame.origin.y, 30, 30);

    }
    
    [amLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [amLabel setTextColor:[UIColor whiteColor]];
    [amLabel setText:@"AM"];
    
    [pmLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [pmLabel setTextColor:[UIColor whiteColor]];
    [pmLabel setText:@"PM"];
    
    [_AMbutton addSubview:amLabel];
    [_PMbutton addSubview:pmLabel];
    [_AMbutton setBackgroundImage:[UIImage imageNamed:@"green-bg"] forState:UIControlStateNormal];
    [_PMbutton setBackgroundImage:[UIImage imageNamed:@"green-bg"] forState:UIControlStateNormal];
    
    [_AMbutton addTarget:self action:@selector(changeAM) forControlEvents:UIControlEventTouchUpInside];
    [_PMbutton addTarget:self action:@selector(changePM) forControlEvents:UIControlEventTouchUpInside];
    
    [_backDial setImage:[UIImage imageNamed:@"light-blue-box"]];
    _AMbutton.alpha = 0.3;
    
    _amOrPm = @"PM";
    
    [self addSubview:_backDial];
    
    [_backDial2 setImage:[UIImage imageNamed:@"light-blue-box"]];
    [self addSubview:_backDial2];

    [self addSubview:_AMbutton];
    [self addSubview:_PMbutton];
    
    
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
    
}

-(void) changeAM {
    _PMbutton.alpha = 0.5;
    _AMbutton.alpha = 1.0;
    _amOrPm = @"AM";
}


-(void) changePM {
    _AMbutton.alpha = 0.5;
    _PMbutton.alpha = 1.0;
    _amOrPm = @"PM";
}

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
    
    if (pickerView.tag == 1) {
        return [self.typeOfCars count];
        
    } else if (pickerView.tag == 2) {
        return [self.hourTime count];
        
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
    }
}

@end
