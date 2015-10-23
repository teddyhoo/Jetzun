//
//  VisitsAndTracking.m
//  LeashTimeSitter
//
//  Created by Ted Hooban on 8/13/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import "VisitsAndTracking.h"
#import "DateTools.h"
#import "VisitDetails.h"
#import "ReservationDetails.h"

#import <Parse/Parse.h>

@implementation VisitsAndTracking {
    

    
}

+(VisitsAndTracking *)sharedInstance {
    
    static VisitsAndTracking *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance =[[VisitsAndTracking alloc]init];
    });
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        coordinatesForVisits = [[NSMutableDictionary alloc]init];
        arrayCoordForVisits = [[NSMutableArray alloc]init];
        _clientData = [[NSMutableArray alloc]init];
        _visitData = [[NSMutableArray alloc]init];

        _reservationsData = [[NSMutableArray alloc]init];
        
        self.isReachable = NO;
        self.isUnreachable = NO;
        self.isReachableViaWiFi = NO;
        self.isReachableViaWWAN = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:@"ReservationPosted"
                                                selector:@selector(addReservationDetails)
                                                    name:@"ReservationPosted"
                                                  object:nil];
        

        [self setupDefaults];
        
    }
    return self;
}

-(void)addReservationDetails {
    
    
}


-(void)setupDefaults {
    
}


-(NSMutableArray *)getClientData {
    return _clientData;
}


-(NSMutableArray *)getVisitData {
    return _visitData;
}

-(NSMutableArray *)visitDataFromServer {
    return _visitData;
}


#pragma mark - Notifications

-(void)setupLocalNotifications {
    UILocalNotification* local = [[UILocalNotification alloc]init];
    if (local)
    {
        local.fireDate = [NSDate dateWithTimeIntervalSinceNow:10];
        local.alertBody = @"Turn on GPS tracking";
        local.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:local];
    }

    
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder" message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)turnOffGPSTracking {
}


-(void)changePollingFrequency:(NSNumber*)changePollingFrequencyTo {


}

-(void)changeDistanceFilter:(NSNumber*)changeDistanceFilterTo {
    

}

-(void)setUserDefault:(NSString*)preferenceSetting {
    
    
}

-(NSMutableArray *)getTodayVisits {
        return _visitData;
}


-(void)setUpReachability {
    
}



-(void) setDeviceType:(NSString*)typeDev {
    
    _deviceType = typeDev;
    
}

-(NSString *) tellDeviceType {
    
    return _deviceType;
    
}
-(NSString *)getCurrentSystemVersion {
    
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *systemVersion = [currentDevice systemVersion];
    return systemVersion;
    
}


-(NSString *)stringForYesterday:(int)numDays {
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMdd"];
    NSDate *now = [NSDate date];
    NSDate *yesterday = [now dateByAddingDays:numDays];
    NSString *dateString = [format stringFromDate:yesterday];
    return dateString;
}


-(NSString *)stringForCurrentDateAndTime {
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *now = [NSDate date];
    NSString *dateString = [format stringFromDate:now];
    return dateString;
    
}

-(NSString *)stringForCurrentDay {
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyyMMdd"];
    NSDate *now = [NSDate date];
    NSString *dateString = [format stringFromDate:now];
    return dateString;
}


@end
