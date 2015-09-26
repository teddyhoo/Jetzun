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


@interface VisitsAndTracking : NSObject <CLLocationManagerDelegate, NSURLSessionDelegate> {
    
    NSMutableData *_responseData;
    NSMutableDictionary *coordinatesForVisits;
    NSMutableArray *arrayCoordForVisits;
    
}

+(VisitsAndTracking *)sharedInstance;

extern NSString *const pollingCompleteWithChanges;
extern NSString *const pollingFailed;

@property(nonatomic)NSTimer *timerRequest;              // Initial login, because UI loaded before data received
@property(nonatomic)NSTimer *rollingSecondRequest;      // Background request to get latest visit data and sync with local copy
@property(nonatomic)NSTimer *makeAnotherRequest;        // If request fails, redo

@property(nonatomic,strong)NSNumber* totalCoordinatesForSession;
@property(nonatomic)NSTimer *locationUpdateTimer;

@property(nonatomic,strong)NSMutableArray *clientData;
@property(nonatomic,strong)NSMutableArray *visitData;
@property(nonatomic,strong)NSMutableArray *reservationsData;

@property BOOL isReachable;
@property BOOL isUnreachable;
@property BOOL isReachableViaWWAN;
@property BOOL isReachableViaWiFi;
@property BOOL diagnosticsON;
@property (nonatomic,copy) NSString *deviceType;

// OPTION SETTINGS

-(void)setDeviceType:(NSString*)typeDev;
-(NSString*)tellDeviceType;
-(NSMutableArray *)getTodayVisits;
-(NSMutableArray *)getClientData;
-(NSMutableArray *)getVisitData;
-(void)addReservationDetails:(NSString*)reservationID;
-(void)changePollingFrequency:(NSNumber*)changePollingFrequencyTo;
-(void)turnOffGPSTracking;

-(void)newReservationWithDetails:(NSString *)reservationDate
                          status:(NSString*)status
                  pickupLocation:(NSString*)pickup
                 dropoffLocation:(NSString*)dropoff
                    pickupMinute:(NSString*)minutePick
                      pickupHour:(NSString*)hourPick
                     productType:(NSString*)product
                 estimatedCharge:(NSString*)charge
               estimatedDistance:(NSString*)distance
                   estimatedTime:(NSString*)time;


@end
