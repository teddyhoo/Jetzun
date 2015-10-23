//
//  LocationShareModel.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BackgroundTaskManager.h"
#import <CoreLocation/CoreLocation.h>
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface LocationShareModel : NSObject
@property (nonatomic) BackgroundTaskManager * bgTask;

@property (nonatomic) CLLocationManager *anotherLocationManager;
@property (nonatomic) CLLocationCoordinate2D lastValidLocation;
@property (nonatomic) CLLocationCoordinate2D startRoute;
@property (nonatomic) CLLocationCoordinate2D endRoute;
@property (nonatomic,copy) NSString *pickupLocationText;
@property (nonatomic,copy) NSString *dropoffLocationText;

@property (nonatomic) CLLocation *validLocationLast;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer * delay10Seconds;

@property BOOL afterResume;
@property BOOL turnOffGPSTracking;



+(id)sharedModel;


@end
