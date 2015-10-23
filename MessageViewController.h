//
//  MessageViewController.h
//  LeashTimeSitter
//
//  Created by Ted Hooban on 10/25/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CalendarChooserView.h"
#import "RouteOptionsView.h"
#import "ReservationReview.h"
#import "VisitsAndTracking.h"
#import "VisitDetails.h"
#import "UberKit.h"
#import "ChooseVisualRoute.h"


@interface MessageViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,NSURLConnectionDelegate,UberKitDelegate> {
    
    
    
}

@property (nonatomic,strong) VisitsAndTracking *sharedVisitsTracking;
@property (nonatomic,strong) UIButton *showMap;
@property (nonatomic,strong) UIButton *hideMap;
@property BOOL showingMap;
@property BOOL keyboardVisible;
@property CGRect keyboardRect;
@property CGFloat height;
@property CGFloat width;

@property (nonatomic,strong) UIImageView *mapFrame;
@property (nonatomic,strong) UILabel *showMapLabel;
@property (nonatomic,strong) UIImageView *backgroundView2;
@property (nonatomic,strong) CLGeocoder *geocodeAddress;
@property (nonatomic,strong) MKDirectionsResponse *response;

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) CalendarChooserView *calendarView;
@property (nonatomic,strong) RouteOptionsView *routeOptionsView;
@property (nonatomic,strong) ChooseVisualRoute *chooseVisualView;
@property (nonatomic,strong) ReservationReview *reservationReview;

@property (nonatomic,strong) UIButton *goToUber;

@property (nonatomic,strong) NSString *objectIDForReservation;
@end
