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
#import "ChooseVisualRoute.h"
#import "RouteOptionsView.h"
#import "ReservationReview.h"
#import "VisitsAndTracking.h"
#import "VisitDetails.h"
#import "UberKit.h"
#import "YALTabBarInteracting.h"
#import "GalleryView.h"
#import "JT3DScrollView.h"
#import "ReservationDetails.h"

@interface MessageViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,NSURLConnectionDelegate,UberKitDelegate, YALTabBarInteracting> {
    
    
    
}

@property (nonatomic,strong) VisitsAndTracking *sharedVisitsTracking;

@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) CalendarChooserView *calendarView;
@property (nonatomic,strong) RouteOptionsView *routeOptionsView;
@property (nonatomic,strong) ChooseVisualRoute *chooseVisualView;
@property (nonatomic,strong) ReservationReview *reservationReview;
@property (nonatomic,strong) GalleryView *reservationCard;
@property (nonatomic,strong) JT3DScrollView *scrollView;
@property (nonatomic,strong) ReservationDetails *reservationDetails;
@property (nonatomic,strong) UIImageView *mapFrame;
@property (nonatomic,strong) CLGeocoder *geocodeAddress;
@property (nonatomic,strong) MKDirectionsResponse *response;
@property (nonatomic,strong) NSString *objectIDForReservation;

@property (nonatomic,strong) UIImageView *backgroundCalButton;
@property (nonatomic,strong) UIButton *goToUber;
@property (nonatomic,strong) UIButton *calButton;


@property BOOL canConfirmReservation;

@end
