//
//  ReservationDetails.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/11/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ReservationDetails : NSObject {
    
    
    
}

@property (nonatomic,copy) NSString *reservationID;
@property (nonatomic,copy) NSString *reservationStatus;
@property (nonatomic,strong) NSDate *dateReservationWasMade;

// future, canceled, in-proces, completed, late, no-show-driver, no-show-client

@property (nonatomic,copy) NSString *reservationDate;
@property (nonatomic,strong) NSDate *reservationDateNS;
@property (nonatomic,copy) NSString *dayDate;
@property (nonatomic,copy) NSString *monthDate;
@property (nonatomic,copy) NSString *dateNum;

@property (nonatomic,copy) NSString *pickupLocation;
@property (nonatomic,copy) NSString *dropOffLocation;

@property (nonatomic,copy) NSString *pickupLocationCoordLat;
@property (nonatomic,copy) NSString *pickupLocationCoordLon;
@property (nonatomic,copy) NSString *dropoffLocationCoordLat;
@property (nonatomic,copy) NSString *dropoffLocationCoordLon;

@property (nonatomic,copy) NSString *pickupTime;
@property (nonatomic,copy) NSString *amOrpm;
@property (nonatomic,copy) NSString *productType;

@property (nonatomic,copy) NSString *estimatedTravelTime;
@property (nonatomic,copy) NSString *estimatedTripCharge;
@property (nonatomic,copy) NSString *actualTravelTime;
@property (nonatomic,copy) NSString *actualTripCharge;
@property (nonatomic,copy) NSString *gratuityTrip;


@property (nonatomic,strong) NSString *clientFirstName;
@property (nonatomic,strong) NSString *clientLastName;
@property (nonatomic,strong) NSString *clientPhone1;
@property (nonatomic,strong) NSString *clientPhone2;
@property (nonatomic,strong) NSString *clientEmail1;
@property (nonatomic,strong) NSString *clientEmail2;

@property (nonatomic,strong) NSString *pickupInstructions;
@property (nonatomic,strong) NSString *dropOffInstructions;


-(BOOL)saveReservationDetailsToParse;
-(void)changeReservationStatus:(NSString*)toStatus;
-(void)addStartEndPointCoordinates:(CLLocationCoordinate2D)startPoint endPoint:(CLLocationCoordinate2D)endPoint;


@end
