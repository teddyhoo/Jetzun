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

@property (nonatomic,strong) NSString *reservationID;
@property (nonatomic,strong) NSString *reservationStatus;

@property (nonatomic,strong) NSDate *dateReservationWasMade;

// future, canceled, in-proces, completed, late, no-show-driver, no-show-client

@property (nonatomic,strong) NSString *reservationDate;
@property (nonatomic,strong) NSDate *reservationDateNS;
@property (nonatomic,strong) CLLocation *pickupLocation;
@property (nonatomic,strong) CLLocation *dropOffLocation;
@property (nonatomic,strong) NSString *estimatedTravelTime;
@property (nonatomic,strong) NSString *estimatedTripCharge;
@property (nonatomic,strong) NSString *actualTravelTime;
@property (nonatomic,strong) NSString *actualTripCharge;
@property (nonatomic,strong) NSString *gratuityTrip;


@property (nonatomic,strong) NSString *clientFirstName;
@property (nonatomic,strong) NSString *clientLastName;
@property (nonatomic,strong) NSString *clientPhone1;
@property (nonatomic,strong) NSString *clientPhone2;
@property (nonatomic,strong) NSString *clientEmail1;
@property (nonatomic,strong) NSString *clientEmail2;

@property (nonatomic,strong) NSString *pickupInstructions;
@property (nonatomic,strong) NSString *dropOffInstructions;

@end
