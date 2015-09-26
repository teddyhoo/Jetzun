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
@property (nonatomic) CLLocation *validLocationLast;
@property (nonatomic) CLLocationCoordinate2D startRoute;
@property (nonatomic) CLLocationCoordinate2D endRoute;


@property (nonatomic) NSMutableDictionary *myLocationDictInPlist;
@property (nonatomic) NSMutableArray *myLocationArrayInPlist;
@property (nonatomic) NSMutableArray *myLocationArray;


@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSTimer * delay10Seconds;

@property (nonatomic) NSMutableArray *allCoordinates;
@property (nonatomic) NSString *lastSendTimeStamp;
@property (nonatomic) NSString *lastSendNumCoordinates;
@property (nonatomic) NSString *responseSend;

@property BOOL afterResume;
@property BOOL turnOffGPSTracking;

@property int totalNumberPointsForSession;
@property int totalDistanceForSession;

@property (nonatomic,strong) NSString *gpsStatus;
@property (nonatomic,strong) NSString *identifierRegionEntered;
@property (nonatomic,strong) NSString *identifierRegionExited;


+(id)sharedModel;


@end
