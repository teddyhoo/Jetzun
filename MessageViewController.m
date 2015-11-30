//
//  MessageViewController.m
//  LeashTimeSitter
//
//  Created by Ted Hooban on 10/25/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import "MessageViewController.h"
#import <Parse/Parse.h>
#import <GPUberViewController.h>
#include <tgmath.h>
#import <pop/POP.h>


#import "VisitAnnotation.h"
#import "VisitAnnotationView.h"
#import "LocationTracker.h"
#import "LocationShareModel.h"
#import "ReservationDetails.h"
#import "PhotoGallery.h"

#define KM_TO_MILES 0.621371
#define SECONDS 60

@interface MessageViewController () <UITextViewDelegate,UPCardsCarouselDataSource, UPCardsCarouselDelegate, UIScrollViewDelegate> {
    
    NSMutableData *_responseData;
}

@property BOOL isIphone4;
@property BOOL isIphone5;
@property BOOL isIphone6;
@property BOOL isIphone6P;
@property int tripDistance;
@property float timeForTrip;
@property LocationShareModel *sharedLocation;

@end


int imageIndex = 0;


@implementation MessageViewController

-(id)init
{
    self = [super init];
    if(self){
        
        
        _sharedVisitsTracking = [VisitsAndTracking sharedInstance];
        _sharedLocation = [LocationShareModel sharedModel];
        
        _canConfirmReservation = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoStart) name:@"foundStartRoute" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(gotoEnd) name:@"foundEndRoute" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setDateService) name:@"choseDateService" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeReservation) name:@"makeReservation" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deepLinkUber) name:@"tripOptions" object:nil];
        
        NSString *theDeviceType = [_sharedVisitsTracking tellDeviceType];
        
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
        
        
        
        
    }
    
    return self;
}

-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}

- (void)tabBarViewWillCollapse {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}

- (void)tabBarViewWillExpand {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}

- (void)tabBarViewDidCollapse {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}

- (void)tabBarViewDidExpand {
        NSLog(@"Running %@ '%@'", self.class, NSStringFromSelector(_cmd));
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self startNewReservation];
    
}


-(void)startNewReservation {
    
    NSLog(@"NEW RESERVATION");
    NSString *theDeviceType = [_sharedVisitsTracking tellDeviceType];
    _isIphone6P = YES;
    theDeviceType = @"iPhone6P";
    
    if (_isIphone6P) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    } else if (_isIphone6) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    } else if (_isIphone5) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    } else if (_isIphone4) {
        _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsBuildings = YES;
    
    [self.view addSubview:_mapView];

    [self removeAnnotations];
    
    imageIndex = 0;

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
    
    
    
    if ([theDeviceType isEqualToString:@"iPhone6P"]) {
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 390)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, 320)];
        _chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 90, self.view.frame.size.width, 250)];
        
        
    } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
        
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 130, self.view.frame.size.width, 230)];
        _chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 170)];
        
        
    } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
        
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 130, self.view.frame.size.width, 230)];
        _chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 170)];
        
    }  else if ([theDeviceType isEqualToString:@"iPhone4"]) {
        
        _calendarView = [[CalendarChooserView alloc]initWithFrame:CGRectMake(0, -40, self.view.frame.size.width, 300)];
        _routeOptionsView = [[RouteOptionsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 130, self.view.frame.size.width, 230)];
        _chooseVisualView = [[ChooseVisualRoute alloc]initWithFrame:CGRectMake(self.view.frame.size.width, 160, self.view.frame.size.width, 170)];
        
    }
    
    _calendarView.alpha = 0.8;
    [self.view addSubview:_chooseVisualView];
    [self.view addSubview:_calendarView];
    [self.view addSubview:_routeOptionsView];
    [self showInitialMapAndGoToLcoation];
}


-(void)setDateService {
    
    CGRect newFrame;
    
    if(_isIphone6P) {
        
        newFrame = CGRectMake(0, -80, self.view.frame.size.width,170);
        
    } else if (_isIphone6) {
        
        newFrame = CGRectMake(0, -40, self.view.frame.size.width, 140);

    } else if (_isIphone5) {
        
        newFrame = CGRectMake(0, -40, self.view.frame.size.width, 120);

    } else if (_isIphone4) {
        
        newFrame = CGRectMake(0, -40, self.view.frame.size.width, 110);

    }
    
    _backgroundCalButton = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 90)];
    [_backgroundCalButton setImage:[UIImage imageNamed:@"green-bg"]];
    [self.view addSubview:_backgroundCalButton];
    
    _calButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _calButton.frame = _backgroundCalButton.frame;
    
    
    UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 60, 20)];
    [dayLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [dayLabel setTextColor:[UIColor whiteColor]];
    [dayLabel setText:_calendarView.dayOfWeek];
    [_backgroundCalButton addSubview:dayLabel];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 60, 20)];
    [dateLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [dateLabel setTextColor:[UIColor whiteColor]];
    [dateLabel setText:_calendarView.dateNum];
    [_backgroundCalButton addSubview:dateLabel];
    
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 45, 60, 20)];
    [monthLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
    [monthLabel setTextColor:[UIColor whiteColor]];
    [monthLabel setText:_calendarView.dateMon];
    
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.textAlignment = NSTextAlignmentCenter;
    
    [_backgroundCalButton addSubview:monthLabel];
    
    
    
    [UIView animateWithDuration:0.3
                          delay:0.1
         usingSpringWithDamping:0.9
          initialSpringVelocity:0.7
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        
        _calendarView.frame = newFrame;
        _calendarView.alpha = 0.9;
        
        CGRect newFrame2 = CGRectMake(0,_chooseVisualView.frame.origin.y,self.view.frame.size.width, _chooseVisualView.frame.size.height);
        
        [UIView animateWithDuration:0.4
                              delay:0.2
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.2
                            options:UIViewAnimationOptionTransitionFlipFromRight
                         animations:^{
                             
            _chooseVisualView.frame = newFrame2;
            _chooseVisualView.alpha = 1.0;
                             
        } completion:^(BOOL finished) {
            
            
            
            
        }];
        
    } completion:^(BOOL finished) {
        
    }];
    
    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.velocity = @(1000.);
    //[_calendarView pop_addAnimation:anim forKey:@"slide"];
    
    
    
    
    [UIView animateWithDuration:0.2 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        _calendarView.frame = newFrame;
        _calendarView.backgroundColor = [UIColor redColor];
        _calendarView.alpha = 0.7;
        
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
        newFrame = CGRectMake(0, 0, self.view.frame.size.width, 260);
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
    [_goToUber setBackgroundImage:[UIImage imageNamed:@"light-blue-box"]
                         forState:UIControlStateNormal];
    [_goToUber addTarget:self action:@selector(deepLinkUber)
        forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *scheduleUber = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _goToUber.frame.size.width, 50)];
    scheduleUber.textAlignment = NSTextAlignmentCenter;
    [scheduleUber setFont:[UIFont fontWithName:@"Lato-Bold" size:24]];
    [scheduleUber setText:@"REQUEST RIDE"];
    [scheduleUber setTextColor:[UIColor whiteColor]];
    [_goToUber addSubview:scheduleUber];
    [self.view addSubview:_goToUber];

}



- (void)deepLinkUber {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:_calendarView.dateSelected];
    
    [self showMapAndGoToLocation];
    
    [_goToUber removeFromSuperview];
    [_calendarView removeFromSuperview];
    [_routeOptionsView removeFromSuperview];
    
    float chargeMileFactor = 1.24;
    float chargeTimeFactor = 0.24;
    float baseCharge = 2.00;
    
    float totalCharge = (chargeMileFactor * _tripDistance) + (chargeTimeFactor * _timeForTrip) + baseCharge;
    
    _reservationDetails = [[ReservationDetails alloc]init];
    _reservationDetails.reservationDate = dateString;
    _reservationDetails.reservationStatus = @"PENDING";
    _reservationDetails.pickupLocation = _sharedLocation.pickupLocationText;
    _reservationDetails.dropOffLocation = _sharedLocation.dropoffLocationText;
    _reservationDetails.pickupTime = _routeOptionsView.timeHour;
    _reservationDetails.amOrpm = _routeOptionsView.amOrPm;
    _reservationDetails.productType = _routeOptionsView.typeOfProduct;
    _reservationDetails.estimatedDistance = [NSString stringWithFormat:@"%i",_tripDistance];
    _reservationDetails.estimatedTravelTime = [NSString stringWithFormat:@"%.2f",_timeForTrip];
    _reservationDetails.estimatedTripCharge = [NSString stringWithFormat:@"%.2f",totalCharge];

    [_reservationDetails addStartEndPointCoordinates:_sharedLocation.startRoute
                                           endPoint:_sharedLocation.endRoute];
    [_reservationDetails saveReservationDetailsToParse];
    
    _reservationReview = [[ReservationReview alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 270)];
    [_reservationReview setupReservationDetailsView:_calendarView.dateSelected
                                       monthReserve:_calendarView.dateMon
                                         dayReserve:_calendarView.dayOfWeek
                                            dayName:_calendarView.dateNum
                                        typeProduct:_routeOptionsView.typeOfProduct
                                  reservationObject:_reservationDetails];
    
    [self.view addSubview:_reservationReview];
    [_calButton removeFromSuperview];
    [_backgroundCalButton removeFromSuperview];
    _canConfirmReservation = YES;
    [_sharedVisitsTracking getAllReservations];
    

}

-(void)extraRightItemDidPress {
    
    if (_canConfirmReservation) {
        [_reservationReview removeFromSuperview];
        [_calendarView removeFromSuperview];
        [_routeOptionsView removeFromSuperview];
        [_chooseVisualView removeFromSuperview];
        
        _reservationReview = nil;
        _calendarView = nil;
        _routeOptionsView = nil;
        _chooseVisualView = nil;
        
        
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
        CGFloat height = CGRectGetHeight(self.scrollView.frame);
        CGFloat x = self.scrollView.subviews.count * width;
        
        _scrollView = [[JT3DScrollView alloc]initWithFrame:CGRectMake(10, 60, self.view.frame.size.width - 40, self.view.frame.size.height -80)];
        self.scrollView.delegate = self;
        [self.view addSubview:_scrollView];
        
        NSLog(@"adding scrollview");
        
        GalleryView *cardTopic = [[GalleryView alloc]initWithFrame:CGRectMake(x, self.view.frame.size.height -400, 450, 700)
                                                           andData:_reservationDetails.productType
                                                         andPickup:_reservationDetails.pickupLocation
                                                        andDropoff:_reservationDetails.dropOffLocation
                                                           andHour:_reservationDetails.pickupTime
                                                            andMin:@""
                                                            onDate:_reservationDetails.reservationDate
                                                        withCharge:_reservationDetails.estimatedTripCharge];
        
        
        [self.scrollView addSubview:cardTopic];
        self.scrollView.contentSize = CGSizeMake(x+width,height);
        self.scrollView.effect = JT3DScrollViewEffectTranslation;

        
        _canConfirmReservation  = NO;
        
    } else {
        _reservationDetails = nil;
        [_mapView removeFromSuperview];
        _mapView = nil;
        
        [self startNewReservation];
    }
    

    
}

-(void)gotoStart {
    
    
    float spanX = 0.30225;
    float spanY = 0.30225;
    LocationShareModel *locationShare = [LocationShareModel sharedModel];
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center.latitude = locationShare.lastValidLocation.latitude;
    region.center.longitude = locationShare.lastValidLocation.longitude;
    
    [self.mapView setRegion:region animated:YES];
    
}

-(void)gotoEnd {
    
    LocationShareModel *locationShare = [LocationShareModel sharedModel];

    [self removeAnnotations];
    
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

    NSLog(@"Placemark start: %@, end: %@",placemarkSrc,placemarkDest);
    
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
             float distanceForReservation = route.distance;
             NSTimeInterval timeForRoute = route.expectedTravelTime;
             float routeTime = timeForRoute;
             int routeMin = routeTime/60;
             distanceForReservation = distanceForReservation/1000;
             float distanceInMiles = distanceForReservation * KM_TO_MILES;             
             
             _tripDistance = distanceInMiles;
             _timeForTrip = routeMin;
             [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
             _sharedLocation.distance = distanceInMiles;
             _sharedLocation.tripTimeMin = routeMin;
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

-(void)showInitialMapAndGoToLcoation {
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    
    float spanX = 0.001000;
    float spanY = 0.001000;
    
    NSLog(@"lat: %f, lon: %f",_sharedLocation.lastValidLocation.latitude, _sharedLocation.lastValidLocation.longitude);
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    region.center.latitude = _sharedLocation.lastValidLocation.latitude;
    region.center.longitude = _sharedLocation.lastValidLocation.longitude;
    [self.mapView setRegion:region animated:YES];
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
    
    MKMapCamera *newCamera = [MKMapCamera cameraLookingAtCenterCoordinate:_sharedLocation.startRoute
                                                        fromEyeCoordinate:_sharedLocation.endRoute
                                                              eyeAltitude:1000];
    [newCamera setHeading:90];
    [newCamera setPitch:60];
    [_mapView setCamera:newCamera];
    
}


-(void)removeAnnotations {

    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        
        
        if (![annotation isKindOfClass:[MKUserLocation class]] && ![annotation isKindOfClass:[VisitAnnotation class]]) {
            [self.mapView removeAnnotation:annotation];
        }
    }
    
    for (id<MKOverlay> overlay in self.mapView.overlays) {
        [self.mapView removeOverlay:overlay];
    }
    [self.mapView removeOverlays:self.mapView.overlays];

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
