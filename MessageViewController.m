//
//  MessageViewController.m
//  LeashTimeSitter
//
//  Created by Ted Hooban on 10/25/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import "MessageViewController.h"
#import <CoreLocation/CoreLocation.h> 
#import <Parse/Parse.h>
#import "VisitAnnotation.h"
#import "VisitAnnotationView.h"
#import "LocationTracker.h"
#import "LocationShareModel.h"
#import "UberKit.h"
#import <GPUberViewController.h>
#import "ReservationDetails.h"
#include <tgmath.h>


@interface MessageViewController () <UITextViewDelegate> {
    
    NSMutableData *_responseData;
}

@property BOOL isIphone4;
@property BOOL isIphone5;
@property BOOL isIphone6;
@property BOOL isIphone6P;
@property LocationShareModel *sharedLocation;

@end


int imageIndex = 0;


@implementation MessageViewController

-(id)init
{
    self = [super init];
    if(self){
        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    _sharedLocation = [LocationShareModel sharedModel];
    
    NSString *theDeviceType = [_sharedVisitsTracking tellDeviceType];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoStart) name:@"foundStartRoute" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoEnd) name:@"foundEndRoute" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setDateService) name:@"choseDateService" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeReservation) name:@"makeReservation" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setTripOptions) name:@"tripOptions" object:nil];
    

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
    
    _height = self.view.bounds.size.height;
    

    if (_isIphone6P) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    } else if (_isIphone6) {
        
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,60, self.view.frame.size.width, self.view.frame.size.height)];

        
    } else if (_isIphone5) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,60, self.view.frame.size.width, self.view.frame.size.height)];
        
        
    } else if (_isIphone4) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,60, self.view.frame.size.width, self.view.frame.size.height)];

        
    }

    _showingMap = YES;
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsBuildings = YES;
    //_mapView.showsTraffic = YES;
    [self.view addSubview:_mapView];

}



- (void)didMoveToParentViewController:(UIViewController *)parent {
        
    imageIndex = 0;
    [self addDrivers];
    //[self removeAnnotations];

    NSString *theDeviceType = [_sharedVisitsTracking tellDeviceType];
    
    
    if ([theDeviceType isEqualToString:@"iPhone6P"]) {
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 390)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 130, self.view.frame.size.width, 230)];
        _chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 130, self.view.frame.size.width, 200)];

        
    } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
        
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 300)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 130, self.view.frame.size.width, 230)];
        _chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 170)];

        
    } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
        
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 300)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 130, self.view.frame.size.width, 230)];
        _chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 170)];

    }  else if ([theDeviceType isEqualToString:@"iPhone4"]) {
        
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 300)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 130, self.view.frame.size.width, 230)];
        _chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 170)];
        
    }
    
    _calendarView.alpha = 0.9;
    [self.view addSubview:_chooseVisualView];
    [self.view addSubview:_routeOptionsView];
    [self.view addSubview:_calendarView];
    [self initialMapView];

}


-(void)setDateService {
    
    CGRect newFrame;
    
    if(_isIphone6P) {
        
        newFrame = CGRectMake(0, -40, self.view.frame.size.width,170);
        
    } else if (_isIphone6) {
        
        newFrame = CGRectMake(0, -40, self.view.frame.size.width, 140);

    } else if (_isIphone5) {
        
        newFrame = CGRectMake(0, -40, self.view.frame.size.width, 120);

    } else if (_isIphone4) {
        
        newFrame = CGRectMake(0, -40, self.view.frame.size.width, 110);

    }
    
    
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.3 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        
        _calendarView.frame = newFrame;
        _calendarView.backgroundColor = [UIColor redColor];
        _calendarView.alpha = 1.0;
        
        CGRect newFrame2 = CGRectMake(0,_chooseVisualView.frame.origin.y,self.view.frame.size.width, _chooseVisualView.frame.size.height);
        
        [UIView animateWithDuration:0.4 delay:0.2 usingSpringWithDamping:0.5 initialSpringVelocity:0.2 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            _chooseVisualView.frame = newFrame2;
        } completion:^(BOOL finished) {
            
            
        }];
        
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.2 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _calendarView.frame = newFrame;
        _calendarView.backgroundColor = [UIColor redColor];
        _calendarView.alpha = 1.0;
    } completion:^(BOOL finished) {

        CGRect newFrame2 = CGRectMake(0,_chooseVisualView.frame.origin.y,self.view.frame.size.width, _chooseVisualView.frame.size.height);
        [UIView animateWithDuration:0.5 animations:^{
            _chooseVisualView.frame = newFrame2;
        }];
    }];
}

- (void) makeReservation {

    _routeOptionsView.startLabel.text = _sharedLocation.pickupLocationText;
    _routeOptionsView.endLabel.text = _sharedLocation.dropoffLocationText;
    
    CGRect newFrame;
    CGRect newFrame2;
    
    if(_isIphone6P) {
        newFrame = CGRectMake(0, 130, self.view.frame.size.width, 260);
        newFrame2 = CGRectMake(0, -330, self.view.frame.size.width, 160);
    } else if (_isIphone6) {
        newFrame = CGRectMake(0, 130, self.view.frame.size.width, 260);
        newFrame2 = CGRectMake(0, -130, self.view.frame.size.width, 160);
        
    } else if (_isIphone5) {
        newFrame = CGRectMake(0, 130, self.view.frame.size.width, 260);
        newFrame2 = CGRectMake(0, -130, self.view.frame.size.width, 160);
        
    } else if (_isIphone4) {
        newFrame = CGRectMake(0, -130, self.view.frame.size.width, _calendarView.frame.size.height);
        newFrame2 = CGRectMake(0, -130, self.view.frame.size.width, 160);
    }

    [UIView animateWithDuration:0.5 animations:^{
        _chooseVisualView.frame = newFrame2;
        
    } completion:^(BOOL finished) {
        _routeOptionsView.frame = newFrame;
    }];
}


-(void)setTripOptions {
    
    _goToUber = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (_isIphone6P) {
        _goToUber.frame = CGRectMake(0,250,self.view.frame.size.width,100);

        
    } else if (_isIphone6) {
        _goToUber.frame = CGRectMake(0,250,self.view.frame.size.width,40);

        
    } else if (_isIphone5) {
        _goToUber.frame = CGRectMake(0,210,self.view.frame.size.width,40);

        
    } else if (_isIphone4) {
        _goToUber.frame = CGRectMake(0,250,self.view.frame.size.width,40);

        
    }
    [_goToUber setBackgroundImage:[UIImage imageNamed:@"light-blue-box"] forState:UIControlStateNormal];
    [_goToUber addTarget:self action:@selector(deepLinkUber) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *scheduleUber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _goToUber.frame.size.width, 50)];
    scheduleUber.textAlignment = NSTextAlignmentCenter;
    [scheduleUber setFont:[UIFont fontWithName:@"Lato-Bold" size:24]];
    [scheduleUber setText:@"REQUEST RIDE"];
    [scheduleUber setTextColor:[UIColor whiteColor]];
    [_goToUber addSubview:scheduleUber];
    [self.view addSubview:_goToUber];

}



- (void)deepLinkUber {
    
    [[UberKit sharedInstance] setClientID:@"cyOf4riuRPm6Mups-8tDY21AWCAQG9n6"];
    [[UberKit sharedInstance] setClientSecret:@"B1-7YvWc0nWJz5VdXHe8r6cmLL-eHNSkUTOfLHWB"];
    [[UberKit sharedInstance] setRedirectURL:@"https://localhost"];
    [[UberKit sharedInstance] setApplicationName:@"Rideshare Manager"];
    //UberKit *uberKit = [[UberKit alloc] initWithClientID:@"YOUR_CLIENTID" ClientSecret:@"YOUR_CLIENT_SECRET" RedirectURL:@"YOUR_REDIRECT_URI" ApplicationName:@"YOUR_APPLICATION_NAME"]; // Alternate initialization
    //UberKit *uberKit = [UberKit sharedInstance];
    //uberKit.delegate = self;
    [[UberKit sharedInstance] startLogin];
    
    LocationShareModel *sharedModel = [LocationShareModel sharedModel];
    
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"uber://"]]) {
     //   [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"uber://?action=setPickup&pickup=my_location"]];
        
    } else {
        
       NSLog(@"no uber");
    }
    
    ///NSString *serverToken = @"P_DXM1dCDDq_f17lvgk57FBPWmc8vCD6Bwid2ULp";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_calendarView.dateSelected];
    
    [self showMapAndGoToLocation];
    
    [_goToUber removeFromSuperview];
    [_calendarView removeFromSuperview];
    [_routeOptionsView removeFromSuperview];
    
    ReservationDetails *reservationDetails = [[ReservationDetails alloc]init];
    reservationDetails.reservationStatus = @"pending";
    reservationDetails.reservationDate = dateString;
    reservationDetails.pickupLocation = _sharedLocation.pickupLocationText;
    reservationDetails.dropOffLocation = _sharedLocation.dropoffLocationText;
    reservationDetails.pickupTime = _routeOptionsView.timeHour;
    reservationDetails.amOrpm = _routeOptionsView.amOrPm;
    
    NSLog(@"Reservation: %@, date: %@, pickup: %@, dropoff: %@, time: %@ %@",reservationDetails.reservationStatus,reservationDetails.reservationDate, reservationDetails.pickupLocation,reservationDetails.dropOffLocation, reservationDetails.pickupTime, reservationDetails.amOrpm);
    
    [reservationDetails addStartEndPointCoordinates:_sharedLocation.startRoute
                                           endPoint:_sharedLocation.endRoute];
    
    
    [reservationDetails saveReservationDetailsToParse];
    
    _reservationReview = [[ReservationReview alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 270)];
    [_reservationReview setupReservationDetailsView:_calendarView.dateSelected
                                       monthReserve:_calendarView.dateMon
                                         dayReserve:_calendarView.dayOfWeek
                                            dayName:_calendarView.dateNum
                                         pickupTime:_routeOptionsView.timeHour
                                        typeProduct:_routeOptionsView.typeOfProduct];
    
    [self.view addSubview:_reservationReview];

}


- (void)addDrivers {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DriversAvailableNow" ofType:@"plist"];
    NSArray *drivers = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *driver in drivers) {
        VisitAnnotation *annotation = [[VisitAnnotation alloc]init];
        CGPoint point = CGPointFromString(driver[@"location"]);
        annotation.coordinate = CLLocationCoordinate2DMake(point.x, point.y);
        annotation.title = driver[@"name"];
        annotation.typeOfAnnotation = [driver[@"type"] integerValue];
        annotation.subtitle = driver[@"subtitle"];
        [self.mapView addAnnotation:annotation];
    }
}

-(void)gotoStart {
    
    
    float spanX = 0.00225;
    float spanY = 0.00225;
    LocationShareModel *locationShare = [LocationShareModel sharedModel];
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center.latitude = locationShare.startRoute.latitude;
    region.center.longitude = locationShare.startRoute.longitude;
    
    [self.mapView setRegion:region animated:YES];
    
}

-(void)gotoEnd {
    
    LocationShareModel *locationShare = [LocationShareModel sharedModel];

    
    VisitAnnotation *startAnnotation = [[VisitAnnotation alloc]init];

    startAnnotation.coordinate = locationShare.startRoute;
    startAnnotation.title = @"Route Begin";
    startAnnotation.typeOfAnnotation = VisitStart;
    startAnnotation.subtitle = _routeOptionsView.timeHour;
    [self.mapView addAnnotation:startAnnotation];
    
    VisitAnnotation *endAnnotation = [[VisitAnnotation alloc]init];
    
    endAnnotation.coordinate = locationShare.endRoute;
    endAnnotation.title = @"End Route";
    endAnnotation.typeOfAnnotation = VisitEnd;
    endAnnotation.subtitle = @"10 minutes";
    [self.mapView addAnnotation:endAnnotation];

    MKPlacemark *placemarkSrc = [[MKPlacemark alloc]initWithCoordinate:locationShare.startRoute addressDictionary:nil];
    MKPlacemark *placemarkDest = [[MKPlacemark alloc]initWithCoordinate:locationShare.endRoute addressDictionary:nil];

    MKMapItem *mapItemSrc = [[MKMapItem alloc]initWithPlacemark:placemarkSrc];
    MKMapItem *mapItemDest = [[MKMapItem alloc]initWithPlacemark:placemarkDest];
    [self findDirectionsFrom:mapItemSrc to:mapItemDest];
    
}


- (void)findDirectionsFrom:(MKMapItem *)source
                        to:(MKMapItem *)destination
{
    //provide loading animation here
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.transportType = MKDirectionsTransportTypeAutomobile;
    request.destination = destination;
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:
     ^(MKDirectionsResponse *response, NSError *error) {
         
         
         if (error) {
             
             NSLog(@"Error is %@",error);
             
         } else {
             //do something about the response, like draw it on map
             MKRoute *route = [response.routes firstObject];
             [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
             
         }
     }];
}

-(void)showRoute:(MKDirectionsResponse*)route {
    
    _response = route;
    
    for (MKRoute *route in _response.routes) {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveLabels];
        
    }

}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.lineWidth = 3.0f;
    polylineRender.strokeColor = [UIColor redColor];
    return polylineRender;
}



-(void)showMapAndGoToLocation {
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    
    float spanX = 0.12025;
    float spanY = 0.12025;
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center.latitude = _sharedLocation.startRoute.latitude;
    region.center.longitude = _sharedLocation.startRoute.longitude;
    
    [self.mapView setRegion:region animated:YES];
    
    LocationShareModel *locationShare = [LocationShareModel sharedModel];
    
    
    //MKMapCamera *newCamera = [MKMapCamera cameraLookingAtCenterCoordinate:locationShare.endRoute fromDistance:4000 pitch:90 heading:90];

    MKMapCamera *newCamera = [MKMapCamera cameraLookingAtCenterCoordinate:_sharedLocation.startRoute
                                                        fromEyeCoordinate:_sharedLocation.endRoute
                                                              eyeAltitude:1000];
    [newCamera setHeading:90];
    [newCamera setPitch:60];
    [_mapView setCamera:newCamera];
    
}


-(void)initialMapView {
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    
    float spanX = 0.00025;
    float spanY = 0.00025;
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center.latitude = _sharedLocation.lastValidLocation.latitude;
    region.center.longitude = _sharedLocation.lastValidLocation.longitude;
    
    [self.mapView setRegion:region animated:YES];
    
}


-(void)removeAnnotations {


}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
    

}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
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

-(MKPolyline *) polyLine:(NSArray *)routePoints {
    
    CLLocationCoordinate2D coords[[routePoints count]];
    
    for (int i = 0; i < [routePoints count]; i++) {
        CLLocation *thePoint = [routePoints objectAtIndex:i];
        coords[i] = thePoint.coordinate;
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:[routePoints count]];
    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
