//
//  GalleryView.h
//  LeashTimeClientPet
//
//  Created by Ted Hooban on 6/16/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReservationDetails.h"

@interface GalleryView : UIView  {
    
    
}

@property (nonatomic,strong) UIImageView *backImage;
@property (nonatomic,strong) UIImageView *vehiclePhoto;
@property (nonatomic,strong) NSString *numberSeats;
@property (nonatomic,strong) NSString *pickUpLocation;
@property (nonatomic,strong) NSString *dropOffLocation;
@property (nonatomic,strong) ReservationDetails *reservationItem;


-(id)initWithFrame:(CGRect)frame andData:(NSString*)imageName andCaption:(NSString*)captionText;

-(id)initWithFrame:(CGRect)frame andData:(NSString *)imageName
        andCaption:(NSString *)captionText
              type:(NSString*)typeOfCards;

-(id)initWithFrame:(CGRect)frame
           andData:(NSString *)carType
         andPickup:(NSString*)pickup
        andDropoff:(NSString*)dropOff
           andHour:(NSString*)hour
            andMin:(NSString*)min
            onDate:(NSString*)date
        withCharge:(NSString*)charge;

-(id)initWithFrame:(CGRect)frame andData:(ReservationDetails*)reservationInfo;

-(void)addDetails;
@end
