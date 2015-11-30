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

#define UBER_CLIENT_ID @"cyOf4riuRPm6Mups-8tDY21AWCAQG9n6"
#define UBER_SERVER_TOKEN @"lJvq5gtGUEPkIN0Hszud-qwqTOHamhobdDwAmYtq"
#define PARSE_APP_ID @"ZKMMb0AGM6XqxBvoUeRx627R7OV5QuXpEv3YHAlA"
#define PARSE_CLIENT_KEY @"DbBSkhJiT0qqxPtSrDGKXDfEJ8Dq8IH6mRSkS8LY"

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

-(NSString*)uberCredServer {
    
    return UBER_SERVER_TOKEN;
}
- (id)init
{
    self = [super init];
    if (self) {
        _reservationsData = [[NSMutableArray alloc]init];
        
        self.isReachable = NO;
        self.isUnreachable = NO;
        self.isReachableViaWiFi = NO;
        self.isReachableViaWWAN = NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:@"ReservationPosted"
                                                selector:@selector(addReservationDetails)
                                                    name:@"ReservationPosted"
                                                  object:nil];
        
        [Parse enableLocalDatastore];
        [Parse setApplicationId:@"ZKMMb0AGM6XqxBvoUeRx627R7OV5QuXpEv3YHAlA"
                      clientKey:@"DbBSkhJiT0qqxPtSrDGKXDfEJ8Dq8IH6mRSkS8LY"];
        

        [self setupDefaults];
        
    }
    return self;
}

-(void)addReservation:(ReservationDetails*)reservation {
    
    
}


-(void)getAllReservations {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Reservation"];
    [query whereKey:@"Status" equalTo:@"PENDING"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *reservation in objects) {
            }
        }
        
    }];


}
-(void)addReservationDetails {
    
    
}


-(void)setupDefaults {
    
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
