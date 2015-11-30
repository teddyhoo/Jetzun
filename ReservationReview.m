//
//  ReservationReview.m
//  Jetzun
//
//  Created by Ted Hooban on 10/12/15.
//  Copyright © 2015 Ted Hooban. All rights reserved.
//

#import "ReservationReview.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"
#import "VisitsAndTracking.h"
#import "VisitAnnotationView.h"
#import "VisitAnnotation.h"

@interface ReservationReview () <MKMapViewDelegate> {
    
}

@property (nonatomic,strong) VisitsAndTracking *sharedVisits;

@property (nonatomic,strong) MKMapView *startMap;
@property (nonatomic,strong) MKMapView *endMap;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *vehicleName;
@property (nonatomic,strong) NSString *driverName;

@property (nonatomic,strong) UIButton *finalizeReservationButton;
@property (nonatomic,strong) UIImageView *mapBackStart;
@property (nonatomic,strong) UIImageView *mapBackEnd;
@property (nonatomic,strong) UIImageView *driverImage;


@property BOOL isIphone4;
@property BOOL isIphone5;
@property BOOL isIphone6;
@property BOOL isIphone6P;

@end


@implementation ReservationReview



-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
         LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
        
        _sharedVisits = [VisitsAndTracking sharedInstance];
        
        NSString *theDeviceType = [_sharedVisits tellDeviceType];
        
        if ([theDeviceType isEqualToString:@"iPhone6P"]) {
            _isIphone6P = YES;
            _isIphone6 = NO;
            _isIphone5 = NO;
            _isIphone4 = NO;
            
            _mapBackStart = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-240, 5, 240,190)];
            [_mapBackStart setImage:[UIImage imageNamed:@"map-background"]];
            _startMap = [[MKMapView alloc]initWithFrame:CGRectMake(self.frame.size.width - 270, 5, 260, 175)];
            
        } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
            _isIphone6 = YES;
            _isIphone6P = NO;
            _isIphone5 = NO;
            _isIphone4 = NO;
            
            _mapBackStart = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-240, 5, 200,190)];
            [_mapBackStart setImage:[UIImage imageNamed:@"map-background"]];
            _startMap = [[MKMapView alloc]initWithFrame:CGRectMake(self.frame.size.width - 270, 20, 210, 175)];
            
        } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
            _isIphone5 = YES;
            _isIphone6P = NO;
            _isIphone6 = NO;
            _isIphone4 = NO;
            
            _mapBackStart = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-180, 5, 220,190)];
            [_mapBackStart setImage:[UIImage imageNamed:@"map-background"]];
            _startMap = [[MKMapView alloc]initWithFrame:CGRectMake(self.frame.size.width - 180, 20, 220, 175)];
        }
        
        
        
        _startMap.tag = 1;
        _startMap.delegate = self;
        _startMap.showsCompass = NO;
        _startMap.userInteractionEnabled = NO;
        [self gotoStartMap:_startMap andCoord:sharedLocation.startRoute];
        
        VisitAnnotation *annotation = [[VisitAnnotation alloc]init];
        annotation.coordinate = sharedLocation.startRoute;
        annotation.title = @"START";
        annotation.subtitle = @"ROUTE";
        [_startMap removeAnnotation:annotation];
        [_startMap addAnnotation:annotation];
        
        MKMapCamera *cameraView = [MKMapCamera cameraLookingAtCenterCoordinate:sharedLocation.endRoute fromEyeCoordinate:sharedLocation.startRoute eyeAltitude:150];
        [cameraView setPitch:0.9];
        
        [_startMap setCamera:cameraView];
                
        
    }
    return self;
}

-(void)setupReservationDetailsView:(NSDate*)dateReserve
                      monthReserve:(NSString*)month
                        dayReserve:(NSString*)dayNum
                           dayName:(NSString*)dayOfWeek
                       typeProduct:(NSString*)product
                 reservationObject:(ReservationDetails*)reservationDetails {

    
    NSString *timeString = [NSString stringWithFormat:@"%@ mins",reservationDetails.estimatedTravelTime];
    NSString *distString = [NSString stringWithFormat:@"%@ miles",reservationDetails.estimatedDistance];
    NSString *tripChargeString = [NSString stringWithFormat:@"$%@",reservationDetails.estimatedTripCharge];
    
    NSLog(@"trip charge, %@",tripChargeString);
    
    UIView *buttonBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];

    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(0,0,self.frame.size.width,200);
    UIView *buttonBack2 = [[UIView alloc]initWithFrame:dateButton.frame];

    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UILabel *pickupLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 95, 100, 30)];
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 60, 25)];
    UILabel *dateDayNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 65, 60, 30)];
    UILabel *dayOfWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 95, 80, 30)];
    UILabel *timeTravelLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 130, 60, 20)];
    UILabel *distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 150, 60, 20)];
    UILabel *totalCostLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 170, 60, 20)];
    UILabel *amPMLabel = [[UILabel alloc]initWithFrame:CGRectMake(pickupLabel.frame.origin.x +20, pickupLabel.frame.origin.y + 30, 100, 24)];
    UILabel *prodLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, 100, 20)];
    
    monthLabel.textAlignment = NSTextAlignmentCenter;
    dateDayNumLabel.textAlignment = NSTextAlignmentCenter;
    dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
    timeTravelLabel.textAlignment = NSTextAlignmentLeft;
    distanceLabel.textAlignment = NSTextAlignmentLeft;
    totalCostLabel.textAlignment = NSTextAlignmentLeft;
    monthLabel.textAlignment = NSTextAlignmentCenter;
    dateDayNumLabel.textAlignment = NSTextAlignmentCenter;
    dayOfWeekLabel.textAlignment = NSTextAlignmentLeft;
    pickupLabel.textAlignment = NSTextAlignmentRight;
    amPMLabel.textAlignment = NSTextAlignmentCenter;
    prodLabel.textAlignment  = NSTextAlignmentCenter;
    
    [buttonBack2 setBackgroundColor:[UIColor blackColor]];
    buttonBack2.alpha = 0.8;

    [timeTravelLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:12]];
    [timeTravelLabel setTextColor:[UIColor whiteColor]];
    [timeTravelLabel setText:timeString];
    
    [distanceLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:12]];
    [distanceLabel setTextColor:[UIColor whiteColor]];
    [distanceLabel setText:distString];
    
    [totalCostLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:12]];
    [totalCostLabel setTextColor:[UIColor whiteColor]];
    [totalCostLabel setText:tripChargeString];
    
    [monthLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    [monthLabel setTextColor:[UIColor whiteColor]];
    [monthLabel setText:month];

    [dateDayNumLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:18]];
    [dateDayNumLabel setText:dayOfWeek];
    [dateDayNumLabel setTextColor:[UIColor whiteColor]];
    
    [dayOfWeekLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Light" size:24]];
    [dayOfWeekLabel setTextColor:[UIColor yellowColor]];
    [dayOfWeekLabel setText:dayNum];

    [pickupLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:28]];
    [pickupLabel setTextColor:[UIColor yellowColor]];
    [pickupLabel setText:reservationDetails.pickupTime];
    
    [amPMLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Light" size:24]];
    [amPMLabel setTextColor:[UIColor yellowColor]];
    [amPMLabel setText:reservationDetails.amOrpm];
    
    [prodLabel setFont:[UIFont fontWithName:@"CompassRoseCPC-Light" size:12]];
    [prodLabel setTextColor:[UIColor whiteColor]];
    [prodLabel setText:reservationDetails.productType];
    
    timeButton.frame = CGRectMake(0, 0, 200, 50);
    [buttonBack setBackgroundColor:[UIColor whiteColor]];
    
    [timeButton addSubview:pickupLabel];
    [timeButton addSubview:amPMLabel];
    [timeButton addSubview:prodLabel];
    
    [self addSubview:buttonBack2];
    [buttonBack2 addSubview:monthLabel];
    [buttonBack2 addSubview:dateDayNumLabel];
    [buttonBack2 addSubview:dayOfWeekLabel];
    [buttonBack2 addSubview:timeButton];
    [buttonBack2 addSubview:_startMap];
    [buttonBack2 addSubview:timeTravelLabel];
    [buttonBack2 addSubview:distanceLabel];
    [buttonBack2 addSubview:totalCostLabel];
    
    int xPos = 0;
    int yPos =0;
    
    if (_isIphone5) {
        yPos = 120;
    } else if (_isIphone6P) {
        yPos = 0;
    }
    for (int i = 0; i <= 6; i++) {
        
        UIImageView *dayWeekImg = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 20, 20)];
        UILabel *dateChar = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 20, 20)];
        [dateChar setFont:[UIFont fontWithName:@"Lato-Regular" size:10]];
        [dateChar setTextColor:[UIColor whiteColor]];
        dateChar.textAlignment = NSTextAlignmentCenter;
        [dayWeekImg setImage:[UIImage imageNamed:@"orange-box"]];
        [dayWeekImg setAlpha:0.0];
        
        CGRect frame = CGRectMake(dayWeekImg.frame.origin.x, dayWeekImg.frame.origin.y+4, dayWeekImg.frame.size.width, dayWeekImg.frame.size.height);
        
        if (i==0) {
            [dateChar setText:@"SU"];
            if ([dayNum isEqualToString:@"SUN"]) {
                dayWeekImg.alpha = 1.0;
                [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    dayWeekImg.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                }];

            } else {
                dayWeekImg.alpha = 0.2;
            }
            
        } else if (i==1) {
            [dateChar setText:@"M"];
            if ([dayNum isEqualToString:@"MON"]) {
                dayWeekImg.alpha = 1.0;
                [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    dayWeekImg.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            } else {
                dayWeekImg.alpha = 0.2;
            }

        } else if (i==2) {
            [dateChar setText:@"T"];
            if ([dayNum isEqualToString:@"TUE"]) {
                dayWeekImg.alpha = 1.0;
                dayWeekImg.alpha = 1.0;
                [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    dayWeekImg.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                dayWeekImg.alpha = 0.2;
            }

        } else if (i==3) {
            [dateChar setText:@"W"];
            if ([dayNum isEqualToString:@"WED"]) {
                dayWeekImg.alpha = 1.0;
                dayWeekImg.alpha = 1.0;
                [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    dayWeekImg.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                dayWeekImg.alpha = 0.2;
            }

        } else if (i==4) {
            [dateChar setText:@"TH"];
            if ([dayNum isEqualToString:@"THU"]) {
                dayWeekImg.alpha = 1.0;
                dayWeekImg.alpha = 1.0;
                [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    dayWeekImg.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                dayWeekImg.alpha = 0.2;
            }

        } else if (i==5) {
            
            [dateChar setText:@"F"];
            if ([dayNum isEqualToString:@"FRI"]) {
                dayWeekImg.alpha = 1.0;
                dayWeekImg.alpha = 1.0;
                [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    dayWeekImg.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                dayWeekImg.alpha = 0.2;
            }

        } else if (i==6) {
            [dateChar setText:@"SA"];
            if ([dayNum isEqualToString:@"SAT"]) {
                dayWeekImg.alpha = 1.0;
                dayWeekImg.alpha = 1.0;
                [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    dayWeekImg.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                dayWeekImg.alpha = 0.2;
            }

        }
        xPos +=20;
        [self addSubview:dayWeekImg];
        [dayWeekImg addSubview:dateChar];
         
    }
}


-(void)gotoStartMap:(MKMapView*)mapView andCoord:(CLLocationCoordinate2D)coordinates {
 
    float spanX = 0.00125;
    float spanY = 0.00125;
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center.latitude = coordinates.latitude;
    region.center.longitude = coordinates.longitude;
    
    [mapView setRegion:region animated:YES];
    
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    VisitAnnotationView* annotationView;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        
    } else {
        annotationView = [[VisitAnnotationView alloc] initWithFrame:CGRectMake(0, 0, 60, 20)];
        //[annotationView initWithAnnotation:annotation reuseIdentifier:@"regularPin"];
        annotationView.canShowCallout = YES;
    }
    
    
    return annotationView;
}

-(MKPolyline *) polyLine:(NSArray *)routePoints {
    
    CLLocationCoordinate2D coords[[routePoints count]];
    
    for (int i = 0; i < [routePoints count]; i++) {
        CLLocation *thePoint = [routePoints objectAtIndex:i];
        coords[i] = thePoint.coordinate;
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:[routePoints count]];
    
}


-(void)setupReservationDetailsView:(ReservationDetails*)reservationDetails {
    
}


-(NSMutableArray*)displayNumIcons:(NSString*)tileChar {
    
    NSMutableArray *characters = [[NSMutableArray alloc]init];
    NSMutableArray *imageForNumArr = [[NSMutableArray alloc]init];
    
    for (int iChar = 0; iChar < [tileChar length]; iChar++) {
        NSString *charForStr = [NSString stringWithFormat:@"%c",[tileChar characterAtIndex:iChar]];
        NSLog(@"char for str: %@",charForStr);
        [characters addObject:charForStr];
    }
    
    int xPos = 40;
    for (NSString *num in characters) {
        NSLog(@"char: %@",num);
        UIImageView *numImage;
        if([num isEqualToString:@"0"]) {
            
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-0-score"]];
            xPos += 18;
            
        } else if ([num isEqualToString:@"1"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-1-score"]];
            xPos += 18;
            
            
        } else if ([num isEqualToString:@"2"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-2-score"]];
            xPos += 18;
            
            
        } else if ([num isEqualToString:@"3"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-3-block"]];
            xPos += 22;
            
        } else if ([num isEqualToString:@"4"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-4-block"]];
            xPos += 22;
            
            
        } else if ([num isEqualToString:@"5"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-5-block"]];
            xPos += 22;
            
        } else if ([num isEqualToString:@"6"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-6-block"]];
            xPos += 22;
            
        } else if ([num isEqualToString:@"7"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-7-block"]];
            xPos += 22;
            
        } else if ([num isEqualToString:@"8"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-8-block"]];
            xPos += 22;
            
        } else if ([num isEqualToString:@"9"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 20, 24)];
            [numImage setImage:[UIImage imageNamed:@"num-9-block"]];
            xPos += 22;
            
        } else if ([num isEqualToString:@":"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, 20, 16, 24)];
            [numImage setImage:[UIImage imageNamed:@"colon"]];
            xPos += 18;
        }
        
        [imageForNumArr addObject:numImage];
        
    }
    
    return imageForNumArr;
    
}


-(NSMutableArray*)dateNumIcons:(NSString*)tileChar {
    
    NSMutableArray *characters = [[NSMutableArray alloc]init];
    NSMutableArray *imageForNumArr = [[NSMutableArray alloc]init];
    
    for (int iChar = 0; iChar < [tileChar length]; iChar++) {
        NSString *charForStr = [NSString stringWithFormat:@"%c",[tileChar characterAtIndex:iChar]];
        NSLog(@"char for str: %@",charForStr);
        [characters addObject:charForStr];
    }
    
    int xPos = 0;
    int yPos = 40;
    for (NSString *num in characters) {
        NSLog(@"char: %@",num);
        UIImageView *numImage;
        if([num isEqualToString:@"0"]) {
            
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-0-block"]];
            xPos += 16;
            
        } else if ([num isEqualToString:@"1"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-1-block"]];
            xPos += 16;
            
            
        } else if ([num isEqualToString:@"2"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-2-block"]];
            xPos += 16;
            
            
        } else if ([num isEqualToString:@"3"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos,yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-3-block"]];
            xPos += 16;
            
        } else if ([num isEqualToString:@"4"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-4-block"]];
            xPos += 16;
            
            
        } else if ([num isEqualToString:@"5"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-5-block"]];
            xPos += 16;
            
        } else if ([num isEqualToString:@"6"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-6-block"]];
            xPos += 16;
            
        } else if ([num isEqualToString:@"7"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-7-block"]];
            xPos += 16;
            
        } else if ([num isEqualToString:@"8"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-8-block"]];
            xPos += 16;
            
        } else if ([num isEqualToString:@"9"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"num-9-block"]];
            xPos += 16;
            
        } else if ([num isEqualToString:@":"]) {
            numImage = [[UIImageView alloc]initWithFrame:CGRectMake(xPos,yPos, 16, 16)];
            [numImage setImage:[UIImage imageNamed:@"colon"]];
            xPos += 18;
        }
        
        [imageForNumArr addObject:numImage];
        
    }
    
    return imageForNumArr;
    
}






-(void)addDriverAttributes:(NSString*)driverName withProductType:(NSString*)product {
    
    UIImageView *productDriver;
    UIImageView *driverPic;
    UILabel *driverNameLabel;
    UIImageView *driverFingerprint;
    UIImageView *driverCertification;
    UILabel *productType;
    UIImageView *carImage;
    UIImageView *driverTitleBar;
    UILabel *milesLabel;
    UILabel *costLabel;
    UILabel *savingsLabel;
    UIImageView *productTitleBar;
    
    milesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 50, 20)];
    costLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 5, 50, 20)];
    savingsLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 5, 50, 20)];
    
    productDriver = [[UIImageView alloc]initWithFrame:CGRectMake(0,90,140,120)];
    carImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140,70)];
    
    driverTitleBar = [[UIImageView alloc]initWithFrame:CGRectMake(productDriver.frame.origin.x, productDriver.frame.origin.y+70, 100, 30)];
    driverTitleBar.alpha = 0.6;
    
    productTitleBar = [[UIImageView alloc]initWithFrame:CGRectMake(0,70, carImage.frame.size.width, 30)];
    productTitleBar.alpha = 0.6;
    
    driverNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, 120, 20)];
    driverPic = [[UIImageView alloc]initWithFrame:CGRectMake(0,70, 80, 80)];
    driverFingerprint = [[UIImageView alloc]initWithFrame:CGRectMake(driverNameLabel.frame.origin.x + 95, driverNameLabel.frame.origin.y + 25, 16, 16)];
    
    driverCertification = [[UIImageView alloc]initWithFrame:CGRectMake(driverNameLabel.frame.origin.x+85, driverPic.frame.origin.y + 25, 20, 20)];
    
    productType = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 140, 24)];
    
    for (int i = 0; i < 7; i++) {
        i++;
        UIImageView *starImage = [[UIImageView alloc]initWithFrame:CGRectMake(driverNameLabel.frame.origin.x + (i * 5), driverPic.frame.origin.y + 30, 10, 10)];
        [starImage setImage:[UIImage imageNamed:@"star-icon-cartoon"]];
        [driverTitleBar addSubview:starImage];
    }
    
    [productDriver setImage:[UIImage imageNamed:@"light-blue-box"]];
    [driverTitleBar setImage:[UIImage imageNamed:@"seethru-label196x58"]];
    [productTitleBar setImage:[UIImage imageNamed:@"seethru-label196x58"]];
    
    [driverPic setImage:[UIImage imageNamed:@"friend-pic-5"]];
    productDriver.alpha = 0.8;
    
    [driverNameLabel setFont:[UIFont fontWithName:@"Lato-Light" size:10]];
    [driverNameLabel setTextColor:[UIColor blackColor]];
    [driverNameLabel setText:driverName];
    
    driverFingerprint.alpha = 0.7;
    [driverFingerprint setImage:[UIImage imageNamed:@"fingerprint-lo-detail"]];
    [driverCertification setImage:[UIImage imageNamed:@"driver-cert"]];
    [carImage setImage:[UIImage imageNamed:@"BMW"]];
    
    [productType setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [productType setTextColor:[UIColor blackColor]];
    [productType setText:product];
    
    [milesLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [milesLabel setTextColor:[UIColor whiteColor]];
    [milesLabel setText:@"Miles"];
    
    [costLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [costLabel setTextColor:[UIColor whiteColor]];
    [costLabel setText:@"Cost"];
    
    [savingsLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [savingsLabel setTextColor:[UIColor whiteColor]];
    [savingsLabel setText:@"Savings"];
    
    
    [driverTitleBar addSubview:driverNameLabel];
    [productTitleBar addSubview:productType];
    [carImage addSubview:productTitleBar];
    
    [productDriver addSubview:productType];
    [productDriver addSubview:driverCertification];
    [productDriver addSubview:driverFingerprint];
    [productDriver addSubview:carImage];
    [productDriver addSubview:driverPic];
    
    [self addSubview:productDriver];
    [self addSubview:driverTitleBar];
    
    
}





@end
