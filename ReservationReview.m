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

@property (nonatomic,strong) MKMapView *startMap;
@property (nonatomic,strong) MKMapView *endMap;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSString *timeReservation;
@property (nonatomic,strong) NSString *amPM;
@property (nonatomic,strong) UIImageView *driverImage;
@property (nonatomic,strong) NSString *vehicleName;
@property (nonatomic,strong) NSString *driverName;
@property (nonatomic,strong) NSString *milesEst;
@property (nonatomic,strong) NSString *costEst;
@property (nonatomic,strong) NSString *savingEst;
@property (nonatomic,strong) UIButton *finalizeReservationButton;
@property (nonatomic,strong) VisitsAndTracking *sharedVisits;
@property (nonatomic,strong) UIImageView *mapBackStart;
@property (nonatomic,strong) UIImageView *mapBackEnd;

@property BOOL isIphone4;
@property BOOL isIphone5;
@property BOOL isIphone6;
@property BOOL isIphone6P;

@end


@implementation ReservationReview



-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        NSLog(@"init reservation view frame %f,%f,%f,%f",frame.size.width,frame.size.height,frame.origin.x,frame.origin.y);
        
         LocationShareModel *sharedLocation = [LocationShareModel sharedModel];
        
        _sharedVisits = [VisitsAndTracking sharedInstance];
        NSString *theDeviceType = [_sharedVisits tellDeviceType];
        
        if ([theDeviceType isEqualToString:@"iPhone6P"]) {
            _isIphone6P = YES;
            _isIphone6 = NO;
            _isIphone5 = NO;
            _isIphone4 = NO;
            
        } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
            _isIphone6 = YES;
            _isIphone6P = NO;
            _isIphone5 = NO;
            _isIphone4 = NO;
            
        } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
            _isIphone5 = YES;
            _isIphone6P = NO;
            _isIphone6 = NO;
            _isIphone4 = NO;
        }
        
        _mapBackStart = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-320, 0, 160,200)];
        [_mapBackStart setImage:[UIImage imageNamed:@"map-background"]];
        
        _mapBackEnd = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-160, 0, 160,200)];
        [_mapBackEnd setImage:[UIImage imageNamed:@"map-background"]];
        
        NSLog(@"map start: %f, %f map end: %f, %f",_mapBackStart.frame.origin.x, _mapBackStart.frame.origin.y, _mapBackEnd.frame.origin.x, _mapBackEnd.frame.origin.y);
        
        _startMap = [[MKMapView alloc]initWithFrame:CGRectMake(2, 25, 152, 176)];
        _endMap = [[MKMapView alloc]initWithFrame:CGRectMake(2, 25, 152, 176)];
        
        _startMap.tag = 1;
        _endMap.tag  = 2;
        
        _startMap.delegate = self;
        _endMap.delegate = self;
        
        _startMap.showsCompass = NO;
        _endMap.showsCompass = NO;
        
        _startMap.userInteractionEnabled = NO;
        _endMap.userInteractionEnabled = NO;
        
        [_mapBackStart addSubview:_startMap];
        [_mapBackEnd addSubview:_endMap];
        
        
        [self addSubview:_mapBackStart];
        [self addSubview:_mapBackEnd];
        
        float startRouteLat = sharedLocation.startRoute.latitude;
        float startRouteLon = sharedLocation.startRoute.longitude;
        float endRouteLat = sharedLocation.endRoute.latitude;
        float endRouteLon = sharedLocation.endRoute.longitude;
        
        //NSLog(@"%f, %f, end: %f, %f",startRouteLat,startRouteLon,endRouteLat,endRouteLon);
        
        [self gotoStartMap:_startMap andCoord:sharedLocation.startRoute];
        [self gotoStartMap:_endMap andCoord:sharedLocation.endRoute];
        
        VisitAnnotation *annotation = [[VisitAnnotation alloc]init];
        annotation.coordinate = sharedLocation.startRoute;
        annotation.title = @"START";
        annotation.subtitle = @"ROUTE";
        [_startMap addAnnotation:annotation];
        
        
        
        MKMapCamera *cameraView = [MKMapCamera cameraLookingAtCenterCoordinate:sharedLocation.endRoute fromEyeCoordinate:sharedLocation.startRoute eyeAltitude:150];
        [cameraView setPitch:0.9];
        
        [_startMap setCamera:cameraView];
        
        MKMapCamera *cameraView2 = [MKMapCamera cameraLookingAtCenterCoordinate:sharedLocation.startRoute fromEyeCoordinate:sharedLocation.endRoute eyeAltitude:150];
        
        [_endMap setCamera:cameraView2];
        
        
    }
    return self;
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



-(void)setupReservationDetailsView:(NSDate*)dateReserve
                      monthReserve:(NSString*)month
                        dayReserve:(NSString*)dayNum
                           dayName:(NSString*)dayOfWeek
                        pickupTime:(NSString*)pickup
                       typeProduct:(NSString*)product {
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(0,0,140,90);

    UIView *buttonBack2 = [[UIView alloc]initWithFrame:dateButton.frame];
    [buttonBack2 setBackgroundColor:[UIColor blackColor]];
    buttonBack2.alpha = 0.9;
    
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 32, 20)];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [monthLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [monthLabel setTextColor:[UIColor whiteColor]];
    [monthLabel setText:month];

    UILabel *dateDayNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 60, 20)];
    dateDayNumLabel.textAlignment = NSTextAlignmentCenter;
    [dateDayNumLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [dateDayNumLabel setText:dayOfWeek];
    [dateDayNumLabel setTextColor:[UIColor whiteColor]];
    
    UILabel *dayOfWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, 60, 24)];
    dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
    [dayOfWeekLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:20]];
    [dayOfWeekLabel setTextColor:[UIColor whiteColor]];
    [dayOfWeekLabel setText:dayNum];

    UIButton *timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    timeButton.frame = CGRectMake(0, 100, 100, 50);
    
    UIView *buttonBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    [buttonBack setBackgroundColor:[UIColor blackColor]];
    buttonBack.alpha = 0.9;

    UILabel *pickupLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 24)];
    pickupLabel.textAlignment = NSTextAlignmentCenter;
    [pickupLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:20]];
    [pickupLabel setTextColor:[UIColor yellowColor]];
    [pickupLabel setText:pickup];
    
    [dateButton addSubview:buttonBack2];
    //[dateButton addSubview:dateDayNumLabel];
    [dateButton addSubview:monthLabel];
    //[dateButton addSubview:dayOfWeekLabel];
    
    NSMutableArray *dateNum = [self dateNumIcons:dayOfWeek];
    for (UIImageView *numImg in dateNum) {
        [dateButton addSubview:numImg];
    }
    [self addSubview:dateButton];

    [timeButton addSubview:buttonBack];
    
    
    NSMutableArray *numImgs = [self displayNumIcons:pickup];
    for (UIImageView *numImg in numImgs) {
        [dateButton addSubview:numImg];
    }
    //[timeButton addSubview:pickupLabel];

    
    
    
    //[self addSubview:timeButton];
    //[self addDriverAttributes:@"Hector" withProductType:product];
    
    //UIButton *finalizeReserve = [UIButton buttonWithType:UIButtonTypeCustom];
    int xPos = 0;
    int yPos = 66;
    for (int i = 0; i <= 6; i++) {
        
        UIImageView *dayWeekImg = [[UIImageView alloc]initWithFrame:CGRectMake(xPos, yPos, 20, 24)];
        UILabel *dateChar = [[UILabel alloc]initWithFrame:CGRectMake(4,0, 20, 24)];
        [dateChar setFont:[UIFont fontWithName:@"Lato-Bold" size:11]];
        [dateChar setTextColor:[UIColor whiteColor]];
        [dayWeekImg setImage:[UIImage imageNamed:@"green-bg"]];
        [dayWeekImg setAlpha:0.0];
        
        CGRect frame = CGRectMake(dayWeekImg.frame.origin.x, dayWeekImg.frame.origin.y+10, dayWeekImg.frame.size.width, dayWeekImg.frame.size.height);
        
        if (i==0) {
            [dateChar setText:@"SU"];
            if ([dayNum isEqualToString:@"SUN"]) {
                dayWeekImg.alpha = 1.0;
            } else {
                dayWeekImg.alpha = 0.5;
            }
            //[self changeAlphaDayNum:dayWeekImg withDay:@"SUN"];
            
        } else if (i==1) {
            [dateChar setText:@"M"];
            if ([dayNum isEqualToString:@"MON"]) {
                dayWeekImg.alpha = 1.0;
                [UIView animateWithDuration:0.4 delay:0.3 usingSpringWithDamping:0.8 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                    
                    dayWeekImg.frame = frame;
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            } else {
                dayWeekImg.alpha = 0.5;
            }
            //[self changeAlphaDayNum:dayWeekImg withDay:@"MON"];

        } else if (i==2) {
            [dateChar setText:@"T"];
            if ([dayNum isEqualToString:@"TUE"]) {
                dayWeekImg.alpha = 1.0;
            } else {
                dayWeekImg.alpha = 0.5;
            }
            //[self changeAlphaDayNum:dayWeekImg withDay:@"TUE"];

        } else if (i==3) {
            [dateChar setText:@"W"];
            if ([dayNum isEqualToString:@"WED"]) {
                dayWeekImg.alpha = 1.0;
            } else {
                dayWeekImg.alpha = 0.5;
            }
            //[self changeAlphaDayNum:dayWeekImg withDay:@"WED"];

        } else if (i==4) {
            [dateChar setText:@"TH"];
            if ([dayNum isEqualToString:@"THU"]) {
                dayWeekImg.alpha = 1.0;
            } else {
                dayWeekImg.alpha = 0.5;
            }
            //[self changeAlphaDayNum:dayWeekImg withDay:@"THU"];

        } else if (i==5) {
            
            [dateChar setText:@"F"];
            if ([dayNum isEqualToString:@"FRI"]) {
                dayWeekImg.alpha = 1.0;
            } else {
                dayWeekImg.alpha = 0.5;
            }
            //[self changeAlphaDayNum:dayWeekImg withDay:@"FRI"];

        } else if (i==6) {
            [dateChar setText:@"SA"];
            if ([dayNum isEqualToString:@"SAT"]) {
                dayWeekImg.alpha = 1.0;
            } else {
                dayWeekImg.alpha = 0.5;
            }
            //[self changeAlphaDayNum:dayWeekImg withDay:@"SAT"];

        }
        
        NSLog(@"day num: %@",dayNum);
        
        xPos +=20;
        [self addSubview:dayWeekImg];
        [dayWeekImg addSubview:dateChar];
         
    }
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
    
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UILabel *dateDayNumLabel;
    UILabel *monthLabel;
    UIView *buttonBack2;
    UILabel *dayOfWeekLabel;
    UIButton *timeButton;
    UIView *buttonBack;
    UILabel *pickupLabel;
    UIImageView *tripDetails;
    UILabel *milesLabel;
    UILabel *costLabel;
    UILabel *savingsLabel;
    
    dateButton.frame = CGRectMake(0,0,100,100);
    dateDayNumLabel= [[UILabel alloc]initWithFrame:CGRectMake(0, dateButton.frame.size.height/2-20, 30, 32)];
    monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 80, 20)];
    dayOfWeekLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 60, 20)];
    timeButton.frame = CGRectMake(0, 100, 100, 40);
    buttonBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    buttonBack2 = [[UIView alloc]initWithFrame:dateButton.frame];
    pickupLabel = [[UILabel alloc]initWithFrame:CGRectMake(timeButton.frame.size.width/2, 20, 100, 20)];
    tripDetails = [[UIImageView alloc]initWithFrame:CGRectMake(0,300,self.frame.size.width,60)];
    milesLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 100, 30)];
    costLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 5, 100, 30)];
    savingsLabel = [[UILabel alloc]initWithFrame:CGRectMake(300, 5, 100, 30)];
    
    [buttonBack2 setBackgroundColor:[UIColor blackColor]];
    buttonBack2.alpha = 0.8;
    
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [monthLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [monthLabel setTextColor:[UIColor whiteColor]];
    [monthLabel setText:reservationDetails.monthDate];
    
    dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
    [dayOfWeekLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [dayOfWeekLabel setText:reservationDetails.dayDate];
    [dayOfWeekLabel setTextColor:[UIColor whiteColor]];
    
    [dateDayNumLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:24]];
    [dateDayNumLabel setTextColor:[UIColor whiteColor]];
    [dateDayNumLabel setText:reservationDetails.dateNum];
    [dateButton addSubview:dateDayNumLabel];
    
    timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [buttonBack setBackgroundColor:[UIColor blackColor]];
    buttonBack.alpha = 0.6;
    
    pickupLabel.textAlignment = NSTextAlignmentCenter;
    [pickupLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [pickupLabel setTextColor:[UIColor whiteColor]];
    [pickupLabel setText:reservationDetails.pickupTime];
    
    tripDetails.alpha = 0.8;
    [tripDetails setImage:[UIImage imageNamed:@"light-blue-box"]];
    
    [milesLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [milesLabel setTextColor:[UIColor whiteColor]];
    [milesLabel setText:@"Miles"];
    
    [costLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [costLabel setTextColor:[UIColor whiteColor]];
    [costLabel setText:@"Cost"];
    
    [savingsLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
    [savingsLabel setTextColor:[UIColor whiteColor]];
    [savingsLabel setText:@"Savings"];
    
    
    [dateButton addSubview:buttonBack2];
    [dateButton addSubview:dateDayNumLabel];
    [dateButton addSubview:monthLabel];
    [dateButton addSubview:dayOfWeekLabel];
    [self addSubview:dateButton];
    
    [timeButton addSubview:buttonBack];
    [timeButton addSubview:pickupLabel];
    [self addSubview:timeButton];
    
    //[tripDetails addSubview:milesLabel];
    //[tripDetails addSubview:costLabel];
    //[tripDetails addSubview:savingsLabel];
    
    //[self addSubview:tripDetails];
    // [self addDriverAttributes:@"Hector" withProductType:reservationDetails.productType];
}



@end
