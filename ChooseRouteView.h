//
//  ChooseRouteView.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/13/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AKPickerView.h"

@interface ChooseRouteView : UIView {
    
}

@property (nonatomic,strong) UITextField *startRoute;
@property (nonatomic,strong) UITextField *endRoute;
@property (nonatomic,strong) UIImageView *backgroundChooseRoute;
@property (nonatomic,strong) UIButton *findRoute;
@property (nonatomic,strong) CLGeocoder *geocodeAddress;
@property (nonatomic,strong) CLGeocoder *geocodeAddress2;
@property (nonatomic,strong) UILabel *labelGeocode;
@property (nonatomic,strong) UILabel *beginRouteLabel;
@property (nonatomic,strong) UILabel *endRouteLabel;


@property (nonatomic,strong) NSArray *typeOfCars;
@property (nonatomic,strong) NSArray *hourTime;
@property (nonatomic,strong) NSArray *minutesTime;

@property (nonatomic,copy) NSString *pickupLocation;
@property (nonatomic,copy) NSString *dropOffLocation;
@property (nonatomic,copy) NSString *timeHour;
@property (nonatomic,copy) NSString *timeMinute;
@property (nonatomic,copy) NSString *typeOfProduct;


@property CGSize winSize;
@property BOOL keyboardVisible;

-(instancetype)initWithFrame:(CGRect)frame;
-(void)chosenStartEnd;

@end
