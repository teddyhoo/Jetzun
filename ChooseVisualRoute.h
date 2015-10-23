//
//  ChooseVisualRoute.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/19/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import <CoreLocation/CoreLocation.h>

@interface ChooseVisualRoute : UIView <UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *backgroundChooseRoute;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic,strong) HMSegmentedControl *pickerStartControl;
@property (nonatomic,strong) HMSegmentedControl *pickerDestinationControl;
@property (nonatomic,strong) NSMutableArray *favoriteDestinations;

@property (nonatomic,strong) UITextView *pickupText;
@property (nonatomic,strong) UITextView *dropoffText;
@property (nonatomic,strong) CLGeocoder *geocodeAddress;
@property (nonatomic,strong) CLGeocoder *geocodeAddress2;

@property (nonatomic,copy) NSString *pickupLocation;
@property (nonatomic,copy) NSString *dropOffLocation;

@property (nonatomic,strong) UILabel *pickupLabel;
@property (nonatomic,strong) UILabel *dropOffLabel;
@property (nonatomic,strong) UILabel *beginRouteLabel;
@property (nonatomic,strong) UILabel *endRouteLabel;

@property BOOL keyboardVisible;
@property BOOL showPickupPicker;
@property BOOL showDropoffPicker;

@property NSInteger selectedIndexValue;

@property (nonatomic,strong) UIButton *showPickerBar;
@property (nonatomic,strong) UIButton *showPickerBar2;
@property (nonatomic,strong) UIButton *selectedStartEnd;

@property (nonatomic,strong) UIImageView *startImageIcon;
@property (nonatomic,strong) UIImageView *endImageIcon;

@end
