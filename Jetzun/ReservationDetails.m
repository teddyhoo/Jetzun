//
//  ReservationDetails.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/11/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "ReservationDetails.h"
#import "VisitsAndTracking.h"
#import <Parse/Parse.h>

@implementation ReservationDetails

-(BOOL)saveReservationDetailsToParse {
    
    VisitsAndTracking *sharedVisits = [VisitsAndTracking sharedInstance];

    PFObject *reservationObj = [PFObject objectWithClassName:@"Reservation"];
    reservationObj[@"UserID"] = sharedVisits.currentUser;
    reservationObj[@"ChosenDate"] = self.reservationDate;
    reservationObj[@"Status"] = self.reservationStatus;
    reservationObj[@"PickupLocation"] = self.pickupLocation;
    reservationObj[@"DropoffLocation"] = self.dropOffLocation;
    reservationObj[@"PickupTime"] = self.pickupTime;
    reservationObj[@"TypeOfProduct"] = self.productType;
    reservationObj[@"AMorPM"] = self.amOrpm;
    reservationObj[@"EstimatedCharge"] = self.estimatedTripCharge;
    reservationObj[@"EstimatedDistance"] = self.estimatedDistance;
    reservationObj[@"EstimatedTime"] = self.estimatedTravelTime;

    [reservationObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error userInfo][@"error"]
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Ok", nil];
            [alertView show];
            return;
        }
        if (succeeded) {
            
            NSLog(@"%@", reservationObj);
            
            self.reservationID = reservationObj.objectId;
            
            self.userID = sharedVisits.currentUser;
            
        } else {
            NSLog(@"Failed to save.");
        }
    }];
    
    
    return YES;
}

-(void)changeReservationStatus:(NSString*)toStatus {
    
    

}


-(void)addStartEndPointCoordinates:(CLLocationCoordinate2D)startPoint
                          endPoint:(CLLocationCoordinate2D)endPoint {
    
    
    _pickupLocationCoordLat = [NSString stringWithFormat:@"%f",startPoint.latitude];
    _pickupLocationCoordLon = [NSString stringWithFormat:@"%f",startPoint.longitude];
    _dropoffLocationCoordLat = [NSString stringWithFormat:@"%f",endPoint.latitude];
    _dropoffLocationCoordLon = [NSString stringWithFormat:@"%f",endPoint.longitude];
    
    
    
}


-(void)contactUberAPIForPricingInformation {
    
    
}

@end
