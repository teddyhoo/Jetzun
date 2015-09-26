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
#import "VisitAnnotation.h"
#import "VisitAnnotationView.h"


@interface GalleryView() {
    
    
}

@property (nonatomic,strong) NSMutableArray *dataFields;
@property (nonatomic,copy) NSString *captionForCurrentImage;
@property (nonatomic,strong) UIImageView *currentImageFrame;
@property (nonatomic,strong) UIImageView *favoriteIcon;
@property (nonatomic,strong) UILabel *captionLabel;


@end


@implementation GalleryView


-(id)initWithFrame:(CGRect)frame andData:(NSString *)imageName andCaption:(NSString *)captionText {
    
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
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.height-300)];

        
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
-(id)initWithFrame:(CGRect)frame andData:(NSString *)imageName andCaption:(NSString *)captionText type:(NSString*)typeOfCards {
    
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

-(id)initWithFrame:(CGRect)frame andData:(NSString *)carType
         andPickup:(NSString*)pickup
        andDropoff:(NSString*)dropOff
           andHour:(NSString*)hour
            andMin:(NSString*)min
            onDate:(NSString*)date
        withCharge:(NSString *)charge
{
    
    self = [self initWithFrame:frame];
    self.userInteractionEnabled  = YES;
    
    _sharedLocation = [LocationShareModel sharedModel];
    
    VisitsAndTracking *sharedVisits = [VisitsAndTracking sharedInstance];
    if ([sharedVisits.deviceType isEqualToString:@"iPhone6P"]) {
        _backImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.height-300)];
        
        
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
    
    UIImageView *calendarIcon = [[UIImageView alloc]initWithFrame:CGRectMake(30, 30, 80, 80)];
    [calendarIcon setImage:[UIImage imageNamed:@"calendar-red-head-larger"]];
    [self addSubview:calendarIcon];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *dateMonth = [[NSDate alloc]init];
    dateMonth = [dateFormatter dateFromString:date];
    
    NSDateFormatter *monthFormat = [[NSDateFormatter alloc]init];
    [monthFormat setDateFormat:@"MMM"];
    NSDateFormatter *dayFormat = [[NSDateFormatter alloc]init];
    [dayFormat setDateFormat:@"dd"];


    NSString *monthStr = [monthFormat stringFromDate:dateMonth];
    NSString *dayStr = [dayFormat stringFromDate:dateMonth];
    NSString *upperMonth = [monthStr uppercaseString];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 35, 300, 20)];
    [dateLabel setText:upperMonth];
    [dateLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Bold" size:16]];
    [dateLabel setTextColor:[UIColor blackColor]];
    [self addSubview:dateLabel];
    
    UILabel *dateLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(45, 60, 300, 40)];
    [dateLabel2 setText:dayStr];
    [dateLabel2 setFont:[UIFont fontWithName:@"CompassRoseCPC-Light" size:32]];
    [dateLabel2 setTextColor:[UIColor blackColor]];
    [self addSubview:dateLabel2];
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(130, 30, 300, 22)];
    [title setText:@"RESERVATION"];
    [title setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [self addSubview:title];
    
    UIImageView *pickupTimeIcon = [[UIImageView alloc]initWithFrame:CGRectMake(130, 60, 20, 20)];
    [pickupTimeIcon setImage:[UIImage imageNamed:@"clock-icon-hands"]];
    [self addSubview:pickupTimeIcon];
    
    UILabel *pickupTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(pickupTimeIcon.frame.origin.x + 30, pickupTimeIcon.frame.origin.y, 200, 22)];
    NSString *timePickupString = [[NSString alloc]init];
    timePickupString = [timePickupString stringByAppendingString:hour];
    timePickupString = [timePickupString stringByAppendingString:min];
    [pickupTimeLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [pickupTimeLabel setTextColor:[UIColor redColor]];
    [pickupTimeLabel setText:timePickupString];
    [self addSubview:pickupTimeLabel];

    UIImageView *costIcon = [[UIImageView alloc]initWithFrame:CGRectMake(25, 120, 20, 20)];
    [costIcon setImage:[UIImage imageNamed:@"DollarSymbol"]];
    [self addSubview:costIcon];
    
    UILabel *chargeLabel = [[UILabel alloc]initWithFrame:CGRectMake(costIcon.frame.origin.x + 30, costIcon.frame.origin.y, 100, 20)];
    [chargeLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Bold" size:18]];
    [chargeLabel setTextColor:[UIColor colorWithRed:0.2 green:0.6 blue:0.2 alpha:1.0]];
    [chargeLabel setText:charge];
    [self addSubview:chargeLabel];
    
    UIImageView *pickupIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 160, 30, 30)];
    [pickupIcon setImage:[UIImage imageNamed:@"annotation-home-icon"]];
    [self addSubview:pickupIcon];
    
    UILabel *caption2 = [[UILabel alloc]initWithFrame:CGRectMake(pickupIcon.frame.origin.x + 30, pickupIcon.frame.origin.y, 300, 20)];
    [caption2 setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [caption2 setText:pickup];
    
    [caption2 setTextColor:[UIColor blackColor]];
    [self addSubview:caption2];
    caption2.textAlignment = NSTextAlignmentLeft;

    
    UIImageView *dropoffIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 200, 30, 30)];
    [dropoffIcon setImage:[UIImage imageNamed:@"destination-star-icon"]];
    [self addSubview:dropoffIcon];
    
    UILabel *caption3 = [[UILabel alloc]initWithFrame:CGRectMake(dropoffIcon.frame.origin.x + 30, dropoffIcon.frame.origin.y, 300, 40)];
    [caption3 setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [caption3 setText:dropOff];
    
    [caption3 setTextColor:[UIColor blackColor]];
    [self addSubview:caption3];
    caption3.textAlignment = NSTextAlignmentLeft;

    
    UILabel *caption1Title = [[UILabel alloc]initWithFrame:CGRectMake(140, 85, 300, 20)];
    [caption1Title setText:@"Product"];
    [caption1Title setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [caption1Title setTextColor:[UIColor blackColor]];
    [self addSubview:caption1Title];
    
    UILabel *caption1 = [[UILabel alloc]initWithFrame:CGRectMake(caption1Title.frame.origin.x + 80, caption1Title.frame.origin.y, 300, 20)];
    [caption1 setText:carType];
    [caption1 setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    [caption1 setTextColor:[UIColor blackColor]];
    [self addSubview:caption1];
    
    
    UIButton *acceptReservationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptReservationButton.frame = CGRectMake(40, 520, 260, 40);
    [acceptReservationButton setImage:[UIImage imageNamed:@"purple-button"] forState:UIControlStateNormal];
    [acceptReservationButton addTarget:self action:@selector(acceptReservation) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:acceptReservationButton];
    
    UILabel *buttonLabel = [[UILabel alloc]initWithFrame:CGRectMake(acceptReservationButton.frame.origin.x, acceptReservationButton.frame.origin.y, acceptReservationButton.frame.size.width, acceptReservationButton.frame.size.height)];
    buttonLabel.textAlignment = NSTextAlignmentCenter;
    [buttonLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Bold" size:18]];
    [buttonLabel setTextColor:[UIColor whiteColor]];
    [buttonLabel setText:@"ACCEPT"];
    [self addSubview:buttonLabel];
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(40, 240, 260, 240)];
    _mapView.delegate = self;
    [self addSubview:_mapView];
    [self showMapAndGoToLocation];
    [self findAndGeocodeCoordinates:pickup dropOffLocation:dropOff];
    [self gotoEnd];
    
    return self;
    
    
}

-(void)gotoEnd {
    
    LocationShareModel *locationShare = [LocationShareModel sharedModel];
    
    
    VisitAnnotation *startAnnotation = [[VisitAnnotation alloc]init];
    
    startAnnotation.coordinate = locationShare.startRoute;
    startAnnotation.title = @"Route Begin";
    startAnnotation.typeOfAnnotation = VisitStart;
    [self.mapView addAnnotation:startAnnotation];
    
    VisitAnnotation *endAnnotation = [[VisitAnnotation alloc]init];
    
    endAnnotation.coordinate = locationShare.endRoute;
    endAnnotation.title = @"End Route";
    endAnnotation.typeOfAnnotation = VisitEnd;
    [self.mapView addAnnotation:endAnnotation];
    
    MKPlacemark *placemarkSrc = [[MKPlacemark alloc]initWithCoordinate:locationShare.startRoute addressDictionary:nil];
    MKPlacemark *placemarkDest = [[MKPlacemark alloc]initWithCoordinate:locationShare.endRoute addressDictionary:nil];
    
    MKMapItem *mapItemSrc = [[MKMapItem alloc]initWithPlacemark:placemarkSrc];
    MKMapItem *mapItemDest = [[MKMapItem alloc]initWithPlacemark:placemarkDest];
    
    //[self findDirectionsFrom:mapItemSrc to:mapItemDest];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    NSLog(@"called map annotation view");
    
    VisitAnnotationView* annotationView;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
    } else {
        annotationView = [[VisitAnnotationView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        [annotationView initWithAnnotation:annotation reuseIdentifier:@"regularPin"];
        //annotationView = [[VisitAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"regularPin"];
        annotationView.canShowCallout = YES;
    }
    
    
    return annotationView;
}



-(void)showMapAndGoToLocation {
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    
    float spanX = 0.00725;
    float spanY = 0.00725;
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center.latitude = _sharedLocation.lastValidLocation.latitude;
    region.center.longitude = _sharedLocation.lastValidLocation.longitude;
    
    [self.mapView setRegion:region animated:YES];
    
}

-(void)findAndGeocodeCoordinates:(NSString *)pickUpLocation dropOffLocation:(NSString*)dropOffLocation {
    
    
    [self endEditing:YES];
    
    NSLog(@"%@, %@",pickUpLocation,dropOffLocation);
    
    if(_geocodeAddress == nil) {
        _geocodeAddress = [[CLGeocoder alloc]init];
    }
    
    if(_geocodeAddress2 == nil) {
        _geocodeAddress2 = [[CLGeocoder alloc]init];
    }
    _pickUpLocation = pickUpLocation;
    _dropOffLocation = dropOffLocation;

    
    [_geocodeAddress geocodeAddressString:_pickUpLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        NSLog(@"begin geocode");
        if(placemarks.count > 0)
        {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
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

                    break;
                case kCLErrorNetwork:
                    break;
                case kCLErrorGeocodeFoundNoResult:
                    break;
                default:
                    break;
            }
        }
        
    }];
    
    [_geocodeAddress2 geocodeAddressString:_dropOffLocation completionHandler:^(NSArray *placemarks2, NSError *error) {
        NSLog(@"end geocode");
        
        if(placemarks2.count > 0)
        {
            CLPlacemark *placemark2 = [placemarks2 objectAtIndex:0];

            LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
            sharedLocation.endRoute = CLLocationCoordinate2DMake(placemark2.location.coordinate.latitude, placemark2.location.coordinate.longitude);
            
        }
        else if (error.domain == kCLErrorDomain)
        {
            switch (error.code)
            {
                case kCLErrorDenied:

                    break;
                case kCLErrorNetwork:
                    break;
                case kCLErrorGeocodeFoundNoResult:
                    break;
                default:
                    break;
            }
        }
        
    }];
    
}

-(void) acceptReservation {
    
    NSLog(@"accept reservation");
}

-(id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {

    }
    
    return self;
}

-(void)baseInit {

    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInView:self];
    
}

-(void) addDetails {
    
    UILabel *driverRatingLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 160, 280,30)];
    [driverRatingLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    [driverRatingLabel setTextColor:[UIColor blackColor]];
    NSString *ratingLabelString = [NSString stringWithFormat:@"%@",_driverRating];
    [driverRatingLabel setText:ratingLabelString];
    //[self addSubview:driverRatingLabel];
    
    UILabel *vehicleMakeLabel = [[UILabel alloc]initWithFrame:CGRectMake(94, 50, 160,30)];
    [vehicleMakeLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    [vehicleMakeLabel setTextColor:[UIColor blackColor]];
    NSString *vehicleMakeString = [NSString stringWithFormat:@"%@",_driverVehicleMake];
    [vehicleMakeLabel setText:vehicleMakeString];
    [self addSubview:vehicleMakeLabel];
    
    UILabel *vehicleModelLabel = [[UILabel alloc]initWithFrame:CGRectMake(94, 70, 160,30)];
    [vehicleModelLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    [vehicleModelLabel setTextColor:[UIColor blackColor]];
    NSString *vehicleModelString = [NSString stringWithFormat:@"%@",_driverVehicleModel];
    [vehicleModelLabel setText:vehicleModelString];
    [self addSubview:vehicleModelLabel];
    
    UILabel *profileDescription;
    
    VisitsAndTracking *sharedVisits = [VisitsAndTracking sharedInstance];
    if ([sharedVisits.deviceType isEqualToString:@"iPhone6P"]) {
        profileDescription = [[UILabel alloc]initWithFrame:CGRectMake(20, 240, 270,280)];
        profileDescription.numberOfLines = 8;
        [profileDescription setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
        
        
    } else if ([sharedVisits.deviceType isEqualToString:@"iPhone6"]) {
        profileDescription = [[UILabel alloc]initWithFrame:CGRectMake(20, 240, 270,280)];
        profileDescription.numberOfLines = 8;
        [profileDescription setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
        
        
    } else if ([sharedVisits.deviceType isEqualToString:@"iPhone5"]) {
        profileDescription = [[UILabel alloc]initWithFrame:CGRectMake(20, 240, 230,280)];
        profileDescription.numberOfLines = 8;
        [profileDescription setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
        
        
    } else if ([sharedVisits.deviceType isEqualToString:@"iPhone4"]) {
        profileDescription = [[UILabel alloc]initWithFrame:CGRectMake(20, 240, 230,280)];
        profileDescription.numberOfLines = 8;
        [profileDescription setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
    }
    
    
    
    [profileDescription setTextColor:[UIColor blackColor]];
    NSString *profileString = [NSString stringWithFormat:@"%@",_driverProfileDescription];
    [profileDescription setText:profileString];
    [self addSubview:profileDescription];
    
}

@end
