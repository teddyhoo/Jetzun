//
//  VisitsAndTracking.h
//  LeashTimeSitter
//
//  Created by Ted Hooban on 8/13/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VisitDetails.h"
#import <Parse/Parse.h>
#import "ReservationDetails.h"


@interface VisitsAndTracking : NSObject <CLLocationManagerDelegate, NSURLSessionDelegate> {
    
    NSMutableData *_responseData;
}

+(VisitsAndTracking *)sharedInstance;

@property(nonatomic,strong)NSMutableArray *reservationsData;
@property PFUser *currentUser;
@property PFSession *currentSession;
@property BOOL isReachable;
@property BOOL isUnreachable;
@property BOOL isReachableViaWWAN;
@property BOOL isReachableViaWiFi;
@property BOOL diagnosticsON;
@property (nonatomic,copy) NSString *deviceType;

-(void)setDeviceType:(NSString*)typeDev;

-(NSString*)tellDeviceType;

-(void)turnOffGPSTracking;

-(NSString*)uberCredServer;

-(void)getAllReservations;

-(void)addReservation:(ReservationDetails*)reservation;

@end
