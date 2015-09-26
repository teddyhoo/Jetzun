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
#import "UberKit.h"
#import "VisitAnnotation.h"
#import "VisitAnnotationView.h"
#import "LocationTracker.h"
#import "LocationShareModel.h"
#import "ChooseRouteView.h"
#import "ChooseVisualRoute.h"
#import <GPUberViewController.h>


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
    
    _isIphone6P = YES;
    _height = self.view.bounds.size.height;
    

    if (_isIphone6P) {
        _backgroundView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [_backgroundView2 setImage:[UIImage imageNamed:@"6p-messageview-back"]];
        [self.view addSubview:_backgroundView2];
        
        _showingMap = YES;
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,60, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:_mapView];

    } else if (_isIphone6) {
        
        
        
    } else if (_isIphone5) {
        _backgroundView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
        [_backgroundView2 setImage:[UIImage imageNamed:@"6p-messageview-back"]];
        [self.view addSubview:_backgroundView2];
        
        _showingMap = YES;
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,60, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:_mapView];
        
        
    } else if (_isIphone4) {
        
        
    }
    

}



- (void)didMoveToParentViewController:(UIViewController *)parent {
    
    NSLog(@"did move to parent view controller");
    
    imageIndex = 0;
    [self addDrivers];

    NSString *theDeviceType = [_sharedVisitsTracking tellDeviceType];
    
    
    if ([theDeviceType isEqualToString:@"iPhone6P"]) {
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        _chooseRouteView = [[ChooseRouteView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 230)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 2, 160, self.view.frame.size.width, 250)];
    
        //_chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 60)];
        
    } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
        
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        _chooseRouteView = [[ChooseRouteView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 230)];
        //_routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 2, 160, self.view.frame.size.width * 2, 250)];
        
        _chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 60)];
        
        
    } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
        
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        _chooseRouteView = [[ChooseRouteView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 180)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 2, 160, self.view.frame.size.width * 2, 180)];
        
        //_chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 60)];
        
    }
    
    [self.view addSubview:_chooseRouteView];
    //[self.view addSubview:_chooseVisualView];
    [self.view addSubview:_routeOptionsView];
    [self.view addSubview:_calendarView];
    
    [self showMapAndGoToLocation];

}


-(void)setDateService {
    
    CGRect newFrame = CGRectMake(0, 60, self.view.frame.size.width, 100);
    [UIView animateWithDuration:0.2 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        _calendarView.frame = newFrame;
    } completion:^(BOOL finished) {

        CGRect newFrame2 = CGRectMake(0,160,self.view.frame.size.width, _chooseRouteView.frame.size.height);
        [UIView animateWithDuration:0.5 animations:^{
            _chooseRouteView.frame = newFrame2;
            
            //_chooseVisualView.frame = newFrame2;
        }];
    }];
}

- (void) makeReservation {
    [_chooseRouteView chosenStartEnd];
    _routeOptionsView.startLabel.text = _chooseRouteView.pickupLocation;
    _routeOptionsView.endLabel.text = _chooseRouteView.dropOffLocation;
    
    CGRect newFrame = CGRectMake(0, 160, self.view.frame.size.width, 260);
    CGRect newFrame2 = CGRectMake(0, -160, self.view.frame.size.width, 160);
    [UIView animateWithDuration:0.5 animations:^{
        _routeOptionsView.frame = newFrame;
        _chooseRouteView.frame = newFrame2;
        
    } completion:^(BOOL finished) {
        
    }];
}


-(void)setTripOptions {
    
    UIButton *goToUber = [UIButton buttonWithType:UIButtonTypeCustom];
    goToUber.frame = CGRectMake(0,250,self.view.frame.size.width,50);
    [goToUber setBackgroundImage:[UIImage imageNamed:@"purple-button"] forState:UIControlStateNormal];
    [goToUber addTarget:self action:@selector(deepLinkUber) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *scheduleUber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, goToUber.frame.size.width, 50)];
    scheduleUber.textAlignment = NSTextAlignmentCenter;
    [scheduleUber setFont:[UIFont fontWithName:@"Lato-Bold" size:24]];
    [scheduleUber setText:@"SCHEDULE WITH UBER"];
    [scheduleUber setTextColor:[UIColor whiteColor]];
    [goToUber addSubview:scheduleUber];
    [self.view addSubview:goToUber];

}



- (void)deepLinkUber {
    
    //[[UberKit sharedInstance] setClientID:@"CrI6A2YCLiM3v-n4dYN04ERH4ZXg56vV"];
    //[[UberKit sharedInstance] setClientSecret:@"gOuGroOd6TJdmR2-yEu3Y8hsx0yCgPoBQEUlWjeL"];
    //[[UberKit sharedInstance] setRedirectURL:@"https://localhost"];
    //[[UberKit sharedInstance] setApplicationName:@"Rideshare Manager"];
    //UberKit *uberKit = [[UberKit alloc] initWithClientID:@"YOUR_CLIENTID" ClientSecret:@"YOUR_CLIENT_SECRET" RedirectURL:@"YOUR_REDIRECT_URI" ApplicationName:@"YOUR_APPLICATION_NAME"]; // Alternate initialization
    //UberKit *uberKit = [UberKit sharedInstance];
    //uberKit.delegate = self;
    //[uberKit startLogin];
    
    //if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"uber://"]]) {
    //    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"uber://?action=setPickup&pickup=my_location"]];
        
    //} else {
        
    //    NSLog(@"no uber");
   // }
    
    ///NSString *serverToken = @"P_DXM1dCDDq_f17lvgk57FBPWmc8vCD6Bwid2ULp";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_calendarView.chosenDate];
    
    NSLog(@"calling shared visits");
    
    [_sharedVisitsTracking newReservationWithDetails:dateString
                                              status:@"NEW"
                                      pickupLocation:_chooseRouteView.pickupLocation
                                     dropoffLocation:_chooseRouteView.dropOffLocation
                                        pickupMinute:_routeOptionsView.timeMinute
                                          pickupHour:_routeOptionsView.timeHour
                                         productType:_routeOptionsView.typeOfProduct
                                     estimatedCharge:_routeOptionsView.costEstimate
                                   estimatedDistance:_routeOptionsView.estimatedDistance
                                       estimatedTime:_routeOptionsView.estimatedTime];

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
         
         //stop loading animation here
         
         if (error) {
             NSLog(@"Error is %@",error);
         } else {
             //do something about the response, like draw it on map
             MKRoute *route = [response.routes firstObject];
             [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
         }
     }];
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
    
    //[self findDirectionsFrom:mapItemSrc to:mapItemDest];
    
}

-(void)showRoute:(MKDirectionsResponse*)route {
    
    _response = route;
    
    for (MKRoute *route in _response.routes) {
        [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveLabels];
        
    }
    
    _mapView.delegate = self;

}

-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    MKPolylineRenderer *polylineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    polylineRender.lineWidth = 3.0f;
    polylineRender.strokeColor = [UIColor redColor];
    return polylineRender;
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

-(void)showMapAndGoToLocation {
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    
    float spanX = 0.00125;
    float spanY = 0.00125;
    
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

-(MKPolyline *) polyLine:(NSArray *)routePoints {
    
    CLLocationCoordinate2D coords[[routePoints count]];
    
    for (int i = 0; i < [routePoints count]; i++) {
        CLLocation *thePoint = [routePoints objectAtIndex:i];
        coords[i] = thePoint.coordinate;
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:[routePoints count]];
    
}


-(void)sendNote:(NSString*)note
          moods:(NSString*)moodButtons
       latitude:(NSString*)currentLatitude
      longitude:(NSString*)currentLongitude
     markArrive:(NSString*)arriveTime
   markComplete:(NSString*)completionTime {
    
    
    NSDate *rightNow = [NSDate date];
    NSDateFormatter *dateFormat = [NSDateFormatter new];
    [dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateTimeString = [dateFormat stringFromDate:rightNow];

    NSUserDefaults *loginSetting = [NSUserDefaults standardUserDefaults];
    NSString *username = [loginSetting objectForKey:@"username"];
    NSString *pass = [loginSetting objectForKey:@"password"];
    NSString *appointmentID = @"appointment ID";
        
    NSString *parameterData = [NSString stringWithFormat:@"loginid=%@&password=%@&datetime=%@&appointmentptr=%@&note=%@&%@&appointmentid=%@",username,pass,dateTimeString,appointmentID,note,moodButtons,appointmentID];
       
    NSLog(@"[VISIT REPORT]: %@",parameterData);
       
    NSData *requestBodyData = [parameterData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[requestBodyData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
                                    
    [request setURL:[NSURL URLWithString:@"https://leashtime.com/native-visit-update.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0];
    [request setHTTPBody:requestBodyData];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                delegate:self];

}

-(void)scaledownMailIcon {
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _responseData = [[NSMutableData alloc]init];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_responseData appendData:data];
    [self scaledownMailIcon];
    NSString *receivedDataString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];

    if(![receivedDataString isEqualToString:@"OK"]) {
        
        
        
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSDate *rightNow = [NSDate date];
    NSDateFormatter *dateFormat2 = [NSDateFormatter new];
    [dateFormat2 setDateFormat:@"HH:mm a"];
    NSString *dateTimeString2 = [dateFormat2 stringFromDate:rightNow];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"received error: %@",error);
    NSUserDefaults *networkLogging = [NSUserDefaults standardUserDefaults];
    NSDate *rightNow2 = [NSDate date];
    NSDateFormatter *dateFormat2 = [[NSDateFormatter alloc]init];
    [dateFormat2 setDateFormat:@"HH:mm:ss MMM dd yyyy"];
    NSString *dateString2 = [dateFormat2 stringFromDate:rightNow2];
    
    NSString *failURLString = [NSString stringWithFormat:@"%@",error];
    NSString *errorDetails = error.localizedDescription;
    NSMutableDictionary *logServerError = [[NSMutableDictionary alloc]init];
    [logServerError setObject:dateString2 forKey:@"date"];
    [logServerError setObject:failURLString forKey:@"error1"];
    [logServerError setObject:errorDetails forKey:@"errorDetails"];
    [logServerError setObject:@"SEND NOTES" forKey:@"location"];
    [logServerError setObject:@"network" forKey:@"type"];
    [networkLogging setObject:logServerError forKey:dateString2];
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
