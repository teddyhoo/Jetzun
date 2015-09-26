//
//  GalleryView.h
//  LeashTimeClientPet
//
//  Created by Ted Hooban on 6/16/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"

@interface GalleryView : UIView <MKMapViewDelegate,CLLocationManagerDelegate> {
    
    
}

@property (nonatomic,strong) NSString *driverName;
@property (nonatomic,strong) NSString *driverRating;
@property (nonatomic,strong) NSString *driverVehicleMake;
@property (nonatomic,strong) NSString *driverVehicleModel;
@property (nonatomic,strong) NSString *driverVehicleYear;
@property (nonatomic,strong) NSString *driverNumYearsDriving;
@property (nonatomic,strong) NSString *driverBaseLocation;
@property (nonatomic,strong) NSString *driverProfileDescription;
@property (nonatomic,strong) UIImageView *backImage;
@property (nonatomic,strong) UIImageView *vehiclePhoto;
@property (nonatomic,strong) NSString *numberSeats;
@property (nonatomic,strong) MKMapView *mapView;
@property (nonatomic,strong) CLGeocoder *geocodeAddress;
@property (nonatomic,strong) CLGeocoder *geocodeAddress2;
@property (nonatomic,strong) NSString *pickUpLocation;
@property (nonatomic,strong) NSString *dropOffLocation;
@property (nonatomic,strong) LocationShareModel *sharedLocation;

-(id)initWithFrame:(CGRect)frame andData:(NSString*)imageName andCaption:(NSString*)captionText;

-(id)initWithFrame:(CGRect)frame andData:(NSString *)imageName
        andCaption:(NSString *)captionText
              type:(NSString*)typeOfCards;

-(id)initWithFrame:(CGRect)frame andData:(NSString *)carType
         andPickup:(NSString*)pickup
        andDropoff:(NSString*)dropOff
           andHour:(NSString*)hour
            andMin:(NSString*)min
            onDate:(NSString*)date
        withCharge:(NSString*)charge;

-(void)addDetails;
@end
