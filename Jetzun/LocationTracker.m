//
//  LocationTracker.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "LocationTracker.h"
#import "VisitDetails.h"
#import "VisitsAndTracking.h"
#import "BackgroundTaskManager.h"


#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

VisitsAndTracking *visitData;

@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
    
    static CLLocationManager *_locationManager;

	@synchronized(self) {
		if (_locationManager == nil) {
			_locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            _locationManager.allowsBackgroundLocationUpdates = YES;
            
		}
	}
	return _locationManager;
}

- (id)init {
	if (self==[super init]) {
        
        self.shareModel = [LocationShareModel sharedModel];

        _regionMonitoringSetupForDay = NO;
        
        visitData = [VisitsAndTracking sharedInstance];
        _regionRadius = 50.0;
        _distanceFilterSetting = 100.0;
         _minAccuracy = 20.0;
        _updateFrequencySeconds = 1500;
        _minNumCoordinatesBeforeSend = 100;

        /*[[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(goingToBackgroundMode)
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];*/
        
    }
	return self;
}


-(void)setupGeofences {
    

    
    _regionMonitoringSetupForDay = YES;

}

-(void)goingToBackgroundMode{
    
    NSLog(@"notification: app background");
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = 20;
    locationManager.allowsBackgroundLocationUpdates = YES;
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
}

- (void) restartLocationUpdates
{
    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = _distanceFilterSetting;
    locationManager.allowsBackgroundLocationUpdates = YES;
    
    if(IS_OS_8_OR_LATER) {
        [locationManager requestAlwaysAuthorization];
    }

    [locationManager startUpdatingLocation];
}

- (void)startLocationTracking {
    
 

	if ([CLLocationManager locationServicesEnabled] == NO) {
        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                                                        message:@"You currently have all location services for this device disabled"
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
		[servicesDisabledAlert show];
        
	} else {
        
        
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        NSLog(@"Authorization status: %d",authorizationStatus);
        
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            
            
        } else {
            
            CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
            locationManager.distanceFilter = 50.0;
            
            if(IS_OS_8_OR_LATER) {
              [locationManager requestAlwaysAuthorization];
            }
            
            [locationManager startUpdatingLocation];
        }
	}
}

- (void)stopLocationTracking {

    
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    
	CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
	[locationManager stopUpdatingLocation];


}

#pragma mark - CLLocationManagerDelegate Methods

-(void)stopLocationDelayBy10Seconds{
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    [locationManager stopUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state
              forRegion:(CLRegion *)region
{
    
}


- (void)locationManager:(CLLocationManager *)manager
         didEnterRegion:(CLRegion *)region
{


}

- (void)locationManager:(CLLocationManager *)manager
          didExitRegion:(CLRegion *)region
{
    

    
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error
{
 
    
    switch([error code])
    {
        case kCLErrorNetwork: // general, network-related error
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Please check your network connection." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self logCoreLocationStatus:@"LOCATION FAILED: NETWORK"];

        }
            break;
        case kCLErrorDenied:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enable Location Service" message:@"You have to enable the Location Service to use this App. To enable, please go to Settings->Privacy->Location Services" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            [self logCoreLocationStatus:@"LOCATION DENIED: DISABLED USERS"];

        }
        
            break;
            
        default:
        {
            
        }
        break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    
        
    for(int i=0;i<locations.count;i++){
        NSLog(@"received location update");

        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        
        if (locationAge > 15.0)
        {
            continue;
        }
        
        if(newLocation!=nil && theAccuracy>0 && theAccuracy<_minAccuracy && (!(theLocation.latitude==0.0 && theLocation.longitude==0.0))) {
            
            self.myLastLocation = theLocation;
            self.myLocationAccuracy= theAccuracy;
            NSLog(@"added valid location update");

            _shareModel.validLocationLast = newLocation;
            _shareModel.lastValidLocation = theLocation;
        
        }
    }
    
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:32 target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }
    
    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:22 target:self
                                                                    selector:@selector(stopLocationDelayBy10Seconds)
                                                                    userInfo:nil
                                                                     repeats:NO];
    
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    _responseData = [[NSMutableData alloc]init];
    NSString *receivedDataString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];


}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [_responseData appendData:data];
    
    NSString *receivedDataString = [[NSString alloc] initWithData:_responseData encoding:NSUTF8StringEncoding];
    [_logServerGPS setObject:receivedDataString forKey:@"response"];
    
    NSUserDefaults *locationDefaultSystem = [NSUserDefaults standardUserDefaults];
    [locationDefaultSystem setObject:_logServerGPS forKey:[_logServerGPS objectForKey:@"date"]];
    
    [_logServerGPS removeAllObjects];
    _logServerGPS = nil;
    
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
   // NSLog(@"did finish loading");
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    
}

- (void) parseResponse:(NSData *) data {
    
    NSString *myData = [[NSString alloc] initWithData:data
                                             encoding:NSUTF8StringEncoding];

    NSError *error = nil;
    
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:NSJSONReadingAllowFragments
                     error:&error];
    
    
    
}

- (void)logCoreLocationStatus:(NSString*)withTransitionState {
    
    NSUserDefaults *locationDefaultSystem = [NSUserDefaults standardUserDefaults];
    
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    NSDate *rightNow = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm:ss MMM dd yyyy"];
    NSString *dateString = [dateFormat stringFromDate:rightNow];
    NSMutableDictionary *logServer = [[NSMutableDictionary alloc]init];
    
    [logServer setObject:rightNow forKey:@"date"];
    [logServer setObject:@"location" forKey:@"type"];
    [logServer setObject:withTransitionState forKey:@"Location State"];
    
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
        //[logServer setObject:@"AUTHORIZED STATUS: << AUTHORIZED >>" forKey:@"LOCATION TRACK STATUS"];
    } else if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
        //[logServer setObject:@"AUTHORIZED STATUS: << ALWAYS >>" forKey:@"LOCATION TRACK STATUS"];
    } else if (authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //[logServer setObject:@"AUTHORIZED STATUS: << WHEN IN USE >>" forKey:@"LOCATION TRACK STATUS"];
    } else if (authorizationStatus == kCLAuthorizationStatusDenied) {
        [logServer setObject:@"AUTHORIZED: << STATUS DENIED >>" forKey:@"LOCATION TRACK STATUS"];
    } else if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        [logServer setObject:@"AUTHORIZED STATUS: << NOT DETERMINED >>" forKey:@"LOCATION TRACK STATUS"];
    } else if (authorizationStatus == kCLAuthorizationStatusRestricted) {
        [logServer setObject:@"AUTHORIZED STATUS: << RESTRICTED >>" forKey:@"LOCATION TRACK STATUS"];
    }
    [locationDefaultSystem setObject:logServer forKey:dateString];
}





@end
