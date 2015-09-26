//
//  ChooseRouteView.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/13/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "ChooseRouteView.h"
#import "PSPDFTextView.h"
#import "LocationShareModel.h"
#import "VisitsAndTracking.h"

@interface ChooseRouteView() <UITextViewDelegate,AKPickerViewDataSource,AKPickerViewDelegate> {
    
    
}

@end
@implementation ChooseRouteView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
        [_backgroundChooseRoute setImage:[UIImage imageNamed:@"teal-bg"]];
        [self addSubview:_backgroundChooseRoute];
        
        VisitsAndTracking *sharedVisits = [VisitsAndTracking sharedInstance];
        if ([sharedVisits.deviceType isEqualToString:@"iPhone6P"]) {
            _beginRouteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
            _endRouteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
            _startRoute = [[UITextField alloc]initWithFrame:CGRectMake(_beginRouteLabel.frame.origin.x + 80, _beginRouteLabel.frame.origin.y,300,50)];
            _endRoute = [[UITextField alloc]initWithFrame:CGRectMake(_endRouteLabel.frame.origin.x + 80, _endRouteLabel.frame.origin.y, 300, 50)];
            _findRoute = [UIButton buttonWithType:UIButtonTypeCustom];
            _findRoute.frame = CGRectMake(0,150,420,80);

        } else if ([sharedVisits.deviceType isEqualToString:@"iPhone6"]) {
            _beginRouteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
            _endRouteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 80, 100, 30)];
            _startRoute = [[UITextField alloc]initWithFrame:CGRectMake(_beginRouteLabel.frame.origin.x + 80, _beginRouteLabel.frame.origin.y,300,50)];

            _endRoute = [[UITextField alloc]initWithFrame:CGRectMake(_endRouteLabel.frame.origin.x + 80, _endRouteLabel.frame.origin.y, 300, 50)];
            
            _findRoute = [UIButton buttonWithType:UIButtonTypeCustom];
            _findRoute.frame = CGRectMake(0,150,420,80);
        } else if ([sharedVisits.deviceType isEqualToString:@"iPhone5"]) {
            _beginRouteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
            _endRouteLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, 100, 30)];
            _startRoute = [[UITextField alloc]initWithFrame:CGRectMake(_beginRouteLabel.frame.origin.x + 80, _beginRouteLabel.frame.origin.y,220,30)];
            _endRoute = [[UITextField alloc]initWithFrame:CGRectMake(_endRouteLabel.frame.origin.x + 80, _endRouteLabel.frame.origin.y, 220, 30)];
            _findRoute = [UIButton buttonWithType:UIButtonTypeCustom];
            _findRoute.frame = CGRectMake(0,120,self.frame.size.width,60);

        }
        

        [_beginRouteLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
        [_beginRouteLabel setTextColor:[UIColor blackColor]];
        [_beginRouteLabel setText:@"Pickup"];
        [_backgroundChooseRoute addSubview:_beginRouteLabel];
        
        [_endRouteLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
        [_endRouteLabel setTextColor:[UIColor blackColor]];
        [_endRouteLabel setText:@"Destination"];
        [_backgroundChooseRoute addSubview:_endRouteLabel];
        
        [_startRoute setClearsOnBeginEditing:YES];
        [_startRoute setBorderStyle:UITextBorderStyleLine];
        [_startRoute setTextColor:[UIColor blackColor]];
        [_startRoute setFont:[UIFont fontWithName:@"Lato-Regular" size:12]];
         
        [_endRoute setClearsOnBeginEditing:YES];
        [_endRoute setBorderStyle:UITextBorderStyleLine];
        [_endRoute setTextColor:[UIColor blackColor]];
        [_endRoute setFont:[UIFont fontWithName:@"Lato-Regular" size:12]];
        
        
        [_findRoute setBackgroundImage:[UIImage imageNamed:@"purple-button"] forState:UIControlStateNormal];
        [_findRoute addTarget:self action:@selector(findAndGeocodeCoordinates) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_findRoute];
        
        _labelGeocode = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _findRoute.frame.size.width, 40)];

        [_labelGeocode setTextAlignment:NSTextAlignmentCenter];
        [_labelGeocode setFont:[UIFont fontWithName:@"Lato-Bold" size:24]];
        [_labelGeocode setText:@"SET OPTIONS"];
        [_labelGeocode setTextColor:[UIColor whiteColor]];
        [_findRoute addSubview:_labelGeocode];
        
        
        [self addSubview:_startRoute];
        [self addSubview:_endRoute];

        
    }
    return self;
    
}


-(void)findAndGeocodeCoordinates {
    
    
    [self endEditing:YES];
    
    if(_geocodeAddress == nil) {
        _geocodeAddress = [[CLGeocoder alloc]init];
    }
    
    if(_geocodeAddress2 == nil) {
        _geocodeAddress2 = [[CLGeocoder alloc]init];
    }
    _pickupLocation = _startRoute.text;
    _dropOffLocation = _endRoute.text;
    
    if (![_startRoute.text length] == 0) {
        
        _pickupLocation = _startRoute.text;
        
    } else {
        
        _pickupLocation = @"4006 Grove Ave, Richmond, VA";
    }

    if(![_endRoute.text length] == 0) {
        
        _dropOffLocation = _endRoute.text;

    } else {
        
        _dropOffLocation = @"116 South Addison St, Richmond, VA";

    }
    
    
    
    NSLog(@"pickup: %@, dropoff: %@",_pickupLocation,_dropOffLocation);
    
    [_geocodeAddress geocodeAddressString:_pickupLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSLog(@"begin geocode");
        if(placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            self.startRoute.text = placemark.location.description;
            
            LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
            sharedLocation.startRoute = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            NSLog(@"start coordinate: %f,%f",sharedLocation.startRoute.latitude,sharedLocation.startRoute.longitude);

            [[NSNotificationCenter defaultCenter]postNotificationName:@"foundStartRoute" object:self];
        }
        else if (error.domain == kCLErrorDomain)
        {
            switch (error.code)
            {
                case kCLErrorDenied:
                    self.startRoute.text
                    = @"Location Services Denied by User";
                    break;
                case kCLErrorNetwork:
                    self.startRoute.text = @"No Network";
                    break;
                case kCLErrorGeocodeFoundNoResult:
                    self.startRoute.text = @"No Result Found";
                    break;
                default:
                    self.startRoute.text = error.localizedDescription;
                    break;
            }
        }

            }];
    
    [_geocodeAddress2 geocodeAddressString:_dropOffLocation completionHandler:^(NSArray *placemarks2, NSError *error) {
        NSLog(@"end geocode");

        if(placemarks2.count > 0)
        {
            CLPlacemark *placemark2 = [placemarks2 objectAtIndex:0];
            self.endRoute.text = placemark2.location.description;
            NSLog(@"%@",self.endRoute.text);
            LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
            sharedLocation.endRoute = CLLocationCoordinate2DMake(placemark2.location.coordinate.latitude, placemark2.location.coordinate.longitude);
            NSLog(@"end latitude: %f, end route: %f",sharedLocation.endRoute.latitude, sharedLocation.endRoute.longitude);
            [[NSNotificationCenter defaultCenter]postNotificationName:@"foundEndRoute" object:self];
        }
        else if (error.domain == kCLErrorDomain)
        {
            switch (error.code)
            {
                case kCLErrorDenied:
                    self.startRoute.text
                    = @"Location Services Denied by User";
                    break;
                case kCLErrorNetwork:
                    self.startRoute.text = @"No Network";
                    break;
                case kCLErrorGeocodeFoundNoResult:
                    self.startRoute.text = @"No Result Found";
                    break;
                default:
                    self.startRoute.text = error.localizedDescription;
                    break;
            }
        }
        
    }];
    
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
    
    [_findRoute removeFromSuperview];
    [self chosenStartEnd];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"makeReservation" object:self];
    
    
    
}

-(void)chosenStartEnd {
    
    [_beginRouteLabel setText:_pickupLocation];
    [_endRouteLabel setText:_dropOffLocation];

    CGRect newFrame = CGRectMake(30,self.frame.size.height - 30, self.frame.size.width, 30);
    CGRect newFrame2 = CGRectMake(30, self.frame.size.height - 50, self.frame.size.width, 30);
    [UIView animateWithDuration:0.1 animations:^{
        _beginRouteLabel.frame = newFrame;
        _endRouteLabel.frame = newFrame2 ;
    }];
    
    [self layoutIfNeeded];

}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {

    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)aTextView {
    NSLog(@"Called %@", NSStringFromSelector(_cmd));
    return YES;
}

- (void)keyboardWillShowNotification:(NSNotification *)notification {
    if (!_keyboardVisible) {
        _keyboardVisible = YES;

    }
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
    if (_keyboardVisible) {
        _keyboardVisible = NO;

    }
}

- (void)updateTextViewContentInset {

}

- (void)keyboardDidShow:(NSNotification *)note {


}

- (void)textViewDidChangeSelection:(UITextView *)textView {

    
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    //NSLog(@"text: %@",textView.text);

}

- (void)dismissKeyboard {
    

    
}


@end
