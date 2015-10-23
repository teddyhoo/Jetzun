//
//  ChooseVisualRoute.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/19/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "ChooseVisualRoute.h"
#import "LocationShareModel.h"
#import "YALTabBarItem.h"
#import "YALFoldingTabBarController.h"
#import "YALAnimatingTabBarConstants.h"

@interface ChooseVisualRoute() {
    
    
}

@end

@implementation ChooseVisualRoute

-(instancetype) initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        self.userInteractionEnabled = YES;
        
        _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
        [_backgroundChooseRoute setImage:[UIImage imageNamed:@"teal-bg"]];
        _backgroundChooseRoute.alpha = 0.4;
        [self addSubview:_backgroundChooseRoute];
        self.backgroundColor = [UIColor clearColor];
        
        
        _showDropoffPicker = YES;
        _showPickupPicker = YES;
    
        CGFloat viewWidth = CGRectGetWidth(self.frame);
        
        NSString *pListData = [[NSBundle mainBundle]
                               pathForResource:@"FavoriteDestinations"
                               ofType:@"plist"];
        
        _favoriteDestinations = [[NSMutableArray alloc]initWithContentsOfFile:pListData];
        
        NSMutableArray *selectItems = [[NSMutableArray alloc]init];
        
        for (NSDictionary *favoriteDetails in _favoriteDestinations) {                                     
            UIImage *favoriteImage = [UIImage imageNamed:[favoriteDetails objectForKey:@"Image"]];
            if (favoriteImage != nil) {
                [selectItems addObject:favoriteImage];
                
            }
        }
    
        NSArray *initImgArray = [NSArray arrayWithArray:selectItems];
        
        _pickerStartControl = [[HMSegmentedControl alloc]initWithSectionImages:initImgArray sectionSelectedImages:initImgArray];
        _pickerDestinationControl = [[HMSegmentedControl alloc]initWithSectionImages:initImgArray sectionSelectedImages:initImgArray];
        
        _pickupText = [[UITextView alloc]initWithFrame:CGRectMake(20, 10, viewWidth - 40, 50)];
        _dropoffText = [[UITextView alloc]initWithFrame:CGRectMake(viewWidth, 40, viewWidth - 20, 50)];
        _pickerStartControl.frame = CGRectMake(20, 60, viewWidth-50, 40);
        _pickerDestinationControl.frame = CGRectMake(viewWidth, 100, viewWidth - 50, 40);
        
        [_pickupText setFont:[UIFont fontWithName:@"Lato-Regular" size:18]];
        [_pickupText setText:@"Current Location"];
        [_pickupText setTextColor:[UIColor blackColor]];
        [_pickupText setBackgroundColor:[UIColor whiteColor]];
        _pickupText.alpha = 0.7;
        _pickupText.tag = 0;
        _pickupText.returnKeyType = UIReturnKeyDone;
        _pickupText.delegate = self;
        [self addSubview:_pickupText];
        
        
        [_dropoffText setFont:[UIFont fontWithName:@"Lato-Regular" size:18]];
        [_dropoffText setText:@"Dropoff Location"];
        [_dropoffText setTextColor:[UIColor blackColor]];
        [_dropoffText setBackgroundColor:[UIColor whiteColor]];
        _dropoffText.alpha = 0.7;
        _dropoffText.tag = 1;
        _dropoffText.returnKeyType = UIReturnKeyDone;
        _dropoffText.delegate = self;
        [self addSubview:_dropoffText];
        
        
        _pickerStartControl.segmentEdgeInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _pickerStartControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        _pickerStartControl.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.7];
        _pickerStartControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _pickerStartControl.tag = 1;
        [_pickerStartControl addTarget:self
                                    action:@selector(startControlValueChanged:)
                          forControlEvents:UIControlEventValueChanged];
        
        

        [self addSubview:_pickerStartControl];

        _pickerDestinationControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _pickerDestinationControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
        _pickerDestinationControl.backgroundColor = [UIColor colorWithRed:0.0 green:0.5 blue:1.0 alpha:0.7];
        _pickerDestinationControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        _pickerDestinationControl.tag = 2;
        
        [_pickerDestinationControl addTarget:self
                                    action:@selector(destinationControlValueChanged:)
                          forControlEvents:UIControlEventValueChanged];
        [self addSubview:_pickerDestinationControl];
        
        
        _selectedStartEnd = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedStartEnd.frame = CGRectMake(0, self.frame.size.height -40, self.frame.size.width, 40);
        [_selectedStartEnd addTarget:self action:@selector(findAndGeocodeCoordinates) forControlEvents:UIControlEventTouchUpInside];
        [_selectedStartEnd setBackgroundImage:[UIImage imageNamed:@"light-blue-box"] forState:UIControlStateNormal];
        [self addSubview:_selectedStartEnd];
        
        UILabel *setLocationsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _selectedStartEnd.frame.size.width, _selectedStartEnd.frame.size.height)];
        [setLocationsLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:20]];
        [setLocationsLabel setTextColor:[UIColor whiteColor]];
        [setLocationsLabel setText:@"CONTINUE"];
        setLocationsLabel.textAlignment = NSTextAlignmentCenter;
        [_selectedStartEnd addSubview:setLocationsLabel];
        
        LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
        
        [_geocodeAddress geocodeAddressString:_pickupLocation completionHandler:^(NSArray *placemarks, NSError *error) {

            if(placemarks.count > 0)
            {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                
                sharedLocation.startRoute = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
                
                NSString *startLocation = [NSString stringWithFormat:@"%f, %f",sharedLocation.startRoute.longitude,sharedLocation.startRoute.latitude];
                
                [_dropoffText setText:startLocation];

                
                
            }
            else if (error.domain == kCLErrorDomain)
            {
                
            }
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"foundStartRoute" object:self];
            
        }];
        
        
    }
    
    return self;
    
}
/*
-(void)touchTabControl:(NSNotification*)notification {

    NSDictionary *userInfo = notification.userInfo;
    NSString *tagID = [userInfo valueForKey:@"tagID"];
    NSLog(@"Index initial touch: %li", (long)_selectedIndexValue);
    NSInteger indexValue = _selectedIndexValue;
    
    if ([tagID isEqualToString:@"1"]) {
        CGRect newFrame = CGRectMake(10, _pickupText.frame.origin.y, self.frame.size.width - 60, _pickerStartControl.frame.size.height-10);
        
        CGRect newFrame2 = CGRectMake(self.frame.size.width, _pickerStartControl.frame.origin.y, _pickerStartControl.frame.size.width, _pickerStartControl.frame.size.height);
        
        CGRect newFrameDest = CGRectMake(20, _pickerDestinationControl.frame.origin.y, _pickerDestinationControl.frame.size.width, _pickerDestinationControl.frame.size.height);
        
        CGRect newTextDest = CGRectMake(20, _dropoffText.frame.origin.y, _dropoffText.frame.size.width, _dropoffText.frame.size.height);
        
        [UIView animateWithDuration:0.4 animations:^{
            [_startImageIcon removeFromSuperview];
            _startImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];

            _pickerStartControl.frame = newFrame2;
            [_pickerStartControl setSelectedSegmentIndex:indexValue];

            UIImage *selectedImageFromStartControl = [_pickerStartControl.sectionImages objectAtIndex:indexValue];
            [_startImageIcon setImage:selectedImageFromStartControl];
            [_pickupText addSubview:_startImageIcon];
            
            _pickupText.frame = newFrame;

        } completion:^(BOOL finished) {
            
            _pickerDestinationControl.frame = newFrameDest;
            _dropoffText.frame = newTextDest;
            

        }];
    } else if ([tagID isEqualToString:@"2"]){
        CGRect newFrame = CGRectMake(30, _pickerDestinationControl.frame.origin.y, self.frame.size.width - 60, _pickerDestinationControl.frame.size.height);

        [UIView animateWithDuration:0.2 animations:^{
            _pickerDestinationControl.frame = newFrame;
            [_pickerDestinationControl setSelectedSegmentIndex:indexValue];
            _dropoffText.frame = newFrame;
        } completion:^(BOOL finished) {
            
            NSLog(@"Index completion picker anim2: %li", (long)_selectedIndexValue);
            [_pickerDestinationControl setSelectedSegmentIndex:indexValue animated:YES];
            
        }];
    }
}
*/

- (void)startControlValueChanged:(HMSegmentedControl *)segmentedControl {
    
    NSDictionary *selectedItem = [_favoriteDestinations objectAtIndex:segmentedControl.selectedSegmentIndex];
    _selectedIndexValue = segmentedControl.selectedSegmentIndex;
    NSLog(@"Start Control %@, Index: %li",[selectedItem objectForKey:@"Name"], (long)_selectedIndexValue);

    CGPoint point = CGPointFromString([selectedItem objectForKey:@"Coordinates"]);
    CLLocationCoordinate2D coordStart = CLLocationCoordinate2DMake(point.x,point.y);
    
    _pickupLocation = [selectedItem objectForKey:@"Address"];
    [_pickupText setText:_pickupLocation];

    LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
    
    sharedLocation.startRoute = coordStart;
    
    CGRect newFrame = CGRectMake(40, _pickupText.frame.origin.y, self.frame.size.width - 60, 20);
    
    CGRect newFrame2 = CGRectMake(self.frame.size.width, _pickerStartControl.frame.origin.y, _pickerStartControl.frame.size.width, _pickerStartControl.frame.size.height);
    
    CGRect newFrameDest = CGRectMake(40, _pickerDestinationControl.frame.origin.y, _pickerDestinationControl.frame.size.width, _pickerDestinationControl.frame.size.height);
    
    CGRect newTextDest = CGRectMake(40, _dropoffText.frame.origin.y, _dropoffText.frame.size.width, _dropoffText.frame.size.height);
    
    [UIView animateWithDuration:0.4 animations:^{
        [_startImageIcon removeFromSuperview];
        
        _startImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(newFrame.origin.x - 40, _pickupText.frame.origin.y, 32, 32)];
        _pickerStartControl.frame = newFrame2;
        [_pickerStartControl setSelectedSegmentIndex:_selectedIndexValue];
        
        UIImage *selectedImageFromStartControl = [_pickerStartControl.sectionImages
                                                  objectAtIndex:_selectedIndexValue];
        
        [_startImageIcon setImage:selectedImageFromStartControl];
        
        [self addSubview:_startImageIcon];
        [_pickupText setBackgroundColor:[UIColor clearColor]];
        
        _pickupText.frame = newFrame;
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            _pickerDestinationControl.frame = newFrameDest;
            _dropoffText.frame = newTextDest;


        } completion:^(BOOL finished) {
            
            
        }];
        
    }];

    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"foundStartRoute" object:self];
}


-(void)destinationControlValueChanged:(HMSegmentedControl *)segmentedControl {
    
    NSDictionary *selectedItem = [_favoriteDestinations objectAtIndex:segmentedControl.selectedSegmentIndex];
    NSLog(@"Destination Control %@",[selectedItem objectForKey:@"Name"]);
    _selectedIndexValue = segmentedControl.selectedSegmentIndex;
    CGPoint point = CGPointFromString([selectedItem objectForKey:@"Coordinates"]);
    
    CLLocationCoordinate2D coordDrop = CLLocationCoordinate2DMake(point.x,point.y);
    _dropOffLocation = [selectedItem objectForKey:@"Address"];
    [_dropoffText setText:_dropOffLocation];
    LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
    sharedLocation.startRoute = coordDrop;
    
    CGRect newFrame = CGRectMake(40, _dropoffText.frame.origin.y+20, self.frame.size.width - 60, 20);
    
    CGRect newFrame2 = CGRectMake(self.frame.size.width, _pickerDestinationControl.frame.origin.y+20, _pickerDestinationControl.frame.size.width, _pickerDestinationControl.frame.size.height);
    
    CGRect newFrameDest = CGRectMake(40, _pickerDestinationControl.frame.origin.y, _pickerDestinationControl.frame.size.width, _pickerDestinationControl.frame.size.height);
    
    CGRect newTextDest = CGRectMake(40, _dropoffText.frame.origin.y, _dropoffText.frame.size.width, _dropoffText.frame.size.height);

    [UIView animateWithDuration:0.4 animations:^{
        [_endImageIcon removeFromSuperview];
        
        _endImageIcon = [[UIImageView alloc]initWithFrame:CGRectMake(newFrame.origin.x - 40, _dropoffText.frame.origin.y, 32, 32)];
        _pickerDestinationControl.frame = newFrame2;
        [_pickerDestinationControl setSelectedSegmentIndex:_selectedIndexValue];
        
        UIImage *selectedImageFromStartControl = [_pickerDestinationControl.sectionImages
                                                  objectAtIndex:_selectedIndexValue];
        
        [_endImageIcon setImage:selectedImageFromStartControl];
        
        [self addSubview:_endImageIcon];
        [_dropoffText setBackgroundColor:[UIColor clearColor]];
        
        _dropoffText.frame = newFrame;
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"foundEndRoute" object:self];
}

-(void)textViewDidChange:(UITextView *)textView {
    
    NSLog(@"text view changed");
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSLog(@"begin editing");
    
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
    NSLog(@"text: %@",textView.text);
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)aTextView {
    
    if (aTextView.tag == 0) {
        
        CGRect newFrame = CGRectMake(self.frame.size.width, _pickerStartControl.frame.origin.y, _pickerStartControl.frame.size.width, _pickerStartControl.frame.size.height);
        
        CGRect newFrameText = CGRectMake(_pickupText.frame.origin.x-5, _pickupText.frame.origin.y-5, self.frame.size.width - 80, _pickupText.frame.size.height+10);
        
        
        
        [UIView animateWithDuration:0.3 animations:^{
            _pickerStartControl.frame = newFrame;
            _pickupText.alpha = 1.0;
        } completion:^(BOOL finished) {
            _pickupText.frame = newFrameText;
            [_pickupText setText:@""];
            [_pickupText setNeedsLayout];
            
            _showPickerBar = [UIButton buttonWithType:UIButtonTypeCustom];
            _showPickerBar.frame = CGRectMake(self.frame.size.width-40 , _pickerStartControl.frame.origin.y,32,32);
            [_showPickerBar setBackgroundImage:[UIImage imageNamed:@"left-arrow-white"] forState:UIControlStateNormal];
            [_showPickerBar addTarget:self action:@selector(zoomPickerBarStart) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_showPickerBar];
            
        }];
        
    } else if (aTextView.tag == 1) {
        
        NSLog(@"tag view tag: %li",(long)aTextView.tag);
        
        CGRect newFrame = CGRectMake(self.frame.size.width, _pickerDestinationControl.frame.origin.y, _pickerDestinationControl.frame.size.width, _pickerDestinationControl.frame.size.height);
        
        CGRect newFrameText = CGRectMake(_dropoffText.frame.origin.x-5, _dropoffText.frame.origin.y-5, self.frame.size.width - 80, _dropoffText.frame.size.height+10);
        
        [UIView animateWithDuration:0.3 animations:^{
            _pickerDestinationControl.frame = newFrame;
            _dropoffText.alpha = 1.0;
        } completion:^(BOOL finished) {
            _dropoffText.frame = newFrameText;
            [_dropoffText setText:@""];
            [_dropoffText setNeedsLayout];
            
            _showPickerBar2 = [UIButton buttonWithType:UIButtonTypeCustom];
            _showPickerBar2.frame = CGRectMake(self.frame.size.width - 40, _pickerDestinationControl.frame.origin.y+10,32,32);
            [_showPickerBar2 setBackgroundImage:[UIImage imageNamed:@"left-arrow-white"] forState:UIControlStateNormal];
            [_showPickerBar2 addTarget:self action:@selector(zoomPickerBarEnd) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_showPickerBar2];            
        }];
        
    }

    return YES;
}

- (void) zoomPickerBarStart {
    
    CGRect newFrame = CGRectMake(30, _pickerStartControl.frame.origin.y, self.frame.size.width - 60, _pickerStartControl.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        _pickerStartControl.frame = newFrame;
        _pickupText.frame = newFrame;
    } completion:^(BOOL finished) {
        
        NSLog(@"Index: %li", (long)_selectedIndexValue);
        
        
    }];
}

-(void) zoomPickerBarEnd {
    
    CGRect newFrame = CGRectMake(30, _pickerDestinationControl.frame.origin.y, self.frame.size.width - 60, _pickerDestinationControl.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        _pickerDestinationControl.frame = newFrame;
        _dropoffText.frame = newFrame;
    } completion:^(BOOL finished) {
        NSLog(@"Index: %li", (long)_selectedIndexValue);
    }];
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

- (void)dismissKeyboard {
    
    
    
}

-(void)findAndGeocodeCoordinates {
    
    
    [self endEditing:YES];
    
    LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
    
    if(_geocodeAddress == nil) {
        _geocodeAddress = [[CLGeocoder alloc]init];
    }
    
    if(_geocodeAddress2 == nil) {
        _geocodeAddress2 = [[CLGeocoder alloc]init];
    }
    _pickupLocation = _pickupText.text;
    _dropOffLocation = _dropoffText.text;
    

    if (![_dropOffLocation isEqual:[NSNull null]] && ([_dropOffLocation length] > 0)) {
        
    } else  {
        _dropOffLocation = @"116 South Addison St, Richmond, VA";
        
    }
    
    if (![_pickupLocation isEqual:[NSNull null]] && ([_pickupLocation length] > 0)) {
        
    } else if ([_pickupLocation isEqualToString:@"Current Location"]) {
        
        
    } else  {
        _pickupLocation = @"116 South Addison St, Richmond, VA";
        
    }

    
    sharedLocation.pickupLocationText = _pickupLocation;
    sharedLocation.dropoffLocationText = _dropOffLocation;

    if ([_pickupLocation isEqualToString:@"Current Location"]) {
        sharedLocation.startRoute = sharedLocation.lastValidLocation;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"foundStartRoute" object:self];
    } else {
        
        [_geocodeAddress geocodeAddressString:_pickupLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if(placemarks.count > 0)
            {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                sharedLocation.startRoute = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
            }
            else if (error.domain == kCLErrorDomain)
            {
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:@"foundStartRoute" object:self];
        }];
    }
    
    
    [_geocodeAddress2 geocodeAddressString:_dropOffLocation completionHandler:^(NSArray *placemarks2, NSError *error) {
        if(placemarks2.count > 0)
        {
            CLPlacemark *placemark2 = [placemarks2 objectAtIndex:0];
            sharedLocation.endRoute = CLLocationCoordinate2DMake(placemark2.location.coordinate.latitude, placemark2.location.coordinate.longitude);
        }
        else if (error.domain == kCLErrorDomain)
        {

        }
        [[NSNotificationCenter defaultCenter]postNotificationName:@"foundEndRoute" object:self];
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
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"makeReservation" object:self];
    
}

- (void)setApperanceForLabel:(UILabel *)label {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    label.backgroundColor = color;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:21.0f];
    label.textAlignment = NSTextAlignmentCenter;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [_pickerStartControl setSelectedSegmentIndex:page animated:YES];
}




@end
