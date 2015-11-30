//
//  ReservationReview.h
//  Jetzun
//
//  Created by Ted Hooban on 10/12/15.
//  Copyright © 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReservationDetails.h"
@interface ReservationReview : UIView

-(void)setupReservationDetailsView:(NSDate*)dateReserve
                      monthReserve:(NSString*)month
                        dayReserve:(NSString*)dayNum
                           dayName:(NSString*)dayOfWeek
                       typeProduct:(NSString*)product
                 reservationObject:(ReservationDetails*)reservationDetails;


-(void)setupReservationDetailsView:(ReservationDetails*)reservationDetails;

@end
