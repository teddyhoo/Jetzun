//
//  TripMonitorViewController.m
//  Jetzun
//
//  Created by Ted Hooban on 10/15/15.
//  Copyright © 2015 Ted Hooban. All rights reserved.
//

#import "TripMonitorViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@import AVFoundation;
#import "LocationShareModel.h"
#import <CoreLocation/CoreLocation.h>
#import "VisitAnnotation.h"
#import "VisitAnnotationView.h"

@interface TripMonitorViewController () <MKMapViewDelegate,AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (assign) BOOL backgroundMusicPlaying;
@property (assign) BOOL backgroundMusicInterrupted;
@property (assign) SystemSoundID pewPewSound;
@property (nonatomic,strong) LocationShareModel *sharedLocationModel;
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) UIButton *emergencyButton;
@property (nonatomic,strong) AVAudioPlayer *soundPlayer;
@property (nonatomic, retain) CLLocation *lastLocation;
@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolyline* currentRouteLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@end

@implementation TripMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureAudioSession];
    [self configureAudioPlayer];
    [self configureSystemSound];
    _tripHasBegun = NO;
    
    _sharedLocationModel = [LocationShareModel sharedModel];

    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"teal-bg"]];
    [self.view addSubview:background];
    
    UILabel *authenticateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 50, 200, 50)];
    [authenticateLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [authenticateLabel setTextColor:[UIColor whiteColor]];
    [authenticateLabel setText:@"BEGIN TRIP"];

    
     _beginTripButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_beginTripButton setBackgroundImage:[UIImage imageNamed:@"teal-bg"] forState:UIControlStateNormal];
    _beginTripButton.frame = CGRectMake(0,0,self.view.frame.size.width,40);
    [_beginTripButton addTarget:self action:@selector(clickBeginTrip) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:_beginTripButton];
    [self.view addSubview:authenticateLabel];
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, 500)];
    _mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = YES;
    
    [self.view addSubview:_mapView];
    [self zoomToCurrentLocation];
    
    _emergencyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _emergencyButton.frame = CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100);
    [_emergencyButton setBackgroundImage:[UIImage imageNamed:@"purple-button"] forState:UIControlStateNormal];
    [_emergencyButton addTarget:self action:@selector(playAudioAlert) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelEmergency = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, self.view.frame.size.width, 40)];
    [labelEmergency setFont:[UIFont fontWithName:@"Lato-Bold" size:18]];
    [labelEmergency setTextColor:[UIColor redColor]];
    [labelEmergency setText:@"CONTACT JETZUN"];
    [_emergencyButton addSubview:labelEmergency];
    
    [self.view addSubview:_emergencyButton];
    
    
    LAContext *context = [[LAContext alloc]init];
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil]) {
        NSLog(@"fingerprint authentication available");
    }
    
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"Authenticate" reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            
            NSLog(@"Fingerprint validated.");

            
        } else {

        }
    }];
    

}

-(void)clickBeginTrip {
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playAudioAlert {
    // If background music or other music is already playing, nothing more to do here
    if (self.backgroundMusicPlaying || [self.audioSession isOtherAudioPlaying]) {
        return;
    }
    
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    self.backgroundMusicPlaying = YES;
}



- (void)playSystemSound {
    AudioServicesPlaySystemSound(self.pewPewSound);
}



- (void) configureAudioSession {
    self.audioSession = [AVAudioSession sharedInstance];
    NSError *setCategoryError = nil;
    if ([self.audioSession isOtherAudioPlaying]) { // mix sound effects with music already playing
        [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
        self.backgroundMusicPlaying = NO;
    } else {
        [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    }
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
}

- (void)configureAudioPlayer {
   // NSString *backgroundMusicPath = [[NSBundle mainBundle] pathForResource:@"background-music-aac" ofType:@"caf"];
    
    NSString *backgroundMusicPath = [[NSBundle mainBundle]pathForResource:@"ruler_bottle" ofType:@"caf"];
    NSURL *backgroundMusicURL = [NSURL fileURLWithPath:backgroundMusicPath];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
    self.backgroundMusicPlayer.delegate = self;  // We need this so we can restart after interruptions
    self.backgroundMusicPlayer.numberOfLoops = -1;	// Negative number means loop forever
}

- (void)configureSystemSound {
    // This is the simplest way to play a sound.
    // But note with System Sound services you can only use:
    // File Formats (a.k.a. audio containers or extensions): CAF, AIF, WAV
    // Data Formats (a.k.a. audio encoding): linear PCM (such as LEI16) or IMA4
    // Sounds must be 30 sec or less
    // And only one sound plays at a time!
    NSString *pewPewPath = [[NSBundle mainBundle] pathForResource:@"ruler_bottle" ofType:@"caf"];
    NSURL *pewPewURL = [NSURL fileURLWithPath:pewPewPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)pewPewURL, &_pewPewSound);
}

-(void)zoomToCurrentLocation {

    float spanX = 0.00125;
    float spanY = 0.00125;
    MKCoordinateRegion region;
    region.center.latitude = _sharedLocationModel.lastValidLocation.latitude;
    region.center.longitude = _sharedLocationModel.lastValidLocation.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    CLLocation *currentLocation = _sharedLocationModel.validLocationLast;
    CLLocationDistance distance = [currentLocation distanceFromLocation:_lastLocation];
    
    
    // check the zero point
    if  (userLocation.coordinate.latitude == 0.0f || userLocation.coordinate.longitude == 0.0f) {
        distance = 0;
        _lastLocation = currentLocation;
        return;
        
    } else {
        NSLog(@"READING");
        
       // totalDistanceForSession = totalDistanceForSession + distance;
        
        CLLocationCoordinate2D coords[2];
        coords[0] = _lastLocation.coordinate;
        coords[1] = currentLocation.coordinate;
        
        _lastLocation = currentLocation;
        
        [self.mapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
        [self createAndAddAnnotationForCoordinate:currentLocation];
    }
}

-(void) createAndAddAnnotationForCoordinate : (CLLocation*) coordinate {
    
    
    VisitAnnotationView *track = [[VisitAnnotationView alloc]init];

    [self.mapView addAnnotation:track];
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    for (MKAnnotationView* aView in views) {
        if ([aView.reuseIdentifier isEqualToString:@"PawPrint"]) {
            aView.transform = CGAffineTransformMakeScale(0, 0);
            aView.alpha = 0;
            [UIView animateWithDuration:0.8 animations:^{
                aView.alpha = 1;
                aView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) return nil;
    
    MKAnnotationView* theAnnotationView = nil;
    
    
    if ([annotation isKindOfClass:[VisitAnnotation class]]) {
        VisitAnnotation *myVisit = (VisitAnnotation *)annotation;
        UIImage *imageForAnnotation;
        
        static NSString* ident = @"VisitAnnotation";
        imageForAnnotation = [UIImage imageNamed:@"right-arrow-circle"];
        //imageForAnnotation = [UIImage imageNamed:@"check-mark-circle"];
        //imageForAnnotation =[UIImage imageNamed:@"arrival-yellow-flag128x128"];
        //imageForAnnotation =[UIImage imageNamed:@"completion-green-flag128x128"];
        //imageForAnnotation = [UIImage imageNamed:@"dog-annotation-2"];
        
        
        
        theAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:ident];
        [theAnnotationView setImage:nil];
        [theAnnotationView setImage:imageForAnnotation];
        
        if (theAnnotationView == nil) {
            //theAnnotationView = [[VisitAnnotationView alloc]initWithFrame:CGRectMake(-20, -20, 20, 20)];
            theAnnotationView = [[VisitAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ident];
            [theAnnotationView setImage:imageForAnnotation];
            theAnnotationView.canShowCallout = YES;
        }
        
        theAnnotationView.annotation = myVisit;
        
        
    }
    return theAnnotationView;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor redColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
        
    } else if ([overlay isKindOfClass:[MKCircle class]]) {
        
        MKCircle *circle = (MKCircle *)overlay;
        MKCircleRenderer *circleRender = [[MKCircleRenderer alloc] initWithCircle:circle];
        circleRender.strokeColor = [UIColor lightGrayColor];
        circleRender.fillColor = [[UIColor blueColor]colorWithAlphaComponent:0.1];
        circleRender.lineWidth = 2;
        return circleRender;
        
    }
    
    return nil;
}


-(MKPolyline *) polyLine:(NSArray *)routePoints {
    
    CLLocationCoordinate2D coords[[routePoints count]];
    
    for (int i = 0; i < [routePoints count]; i++) {
        CLLocation *thePoint = [routePoints objectAtIndex:i];
        coords[i] = thePoint.coordinate;
    }
    
    return [MKPolyline polylineWithCoordinates:coords count:[routePoints count]];
    
}




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.mapView = nil;
    self.routeLine = nil;
    self.routeLineView = nil;
}



@end
