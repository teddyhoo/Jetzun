//
//  ReservationDetails.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/11/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "ReservationDetails.h"
#import <Parse/Parse.h>

@implementation ReservationDetails

-(BOOL)saveReservationDetailsToParse {
    
    
    PFObject *reservationObj = [PFObject objectWithClassName:@"Reservation"];
    reservationObj[@"ChosenDate"] = self.reservationDate;
    reservationObj[@"Status"] = @"PENDING";
    reservationObj[@"PickupLocation"] = self.pickupLocation;
    reservationObj[@"DropoffLocation"] = self.dropOffLocation;
    reservationObj[@"PickupTime"] = self.pickupTime;
    reservationObj[@"AMorPM"] = self.amOrpm;
    
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
