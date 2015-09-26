//
//  LocationTracker.h
//  Location

//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"

@interface LocationTracker : NSObject <CLLocationManagerDelegate>

@property (strong,nonatomic) LocationShareModel *shareModel;


@property (nonatomic) CLLocationCoordinate2D myLastLocation;
@property (nonatomic) CLLocationAccuracy myLastLocationAccuracy;
@property (nonatomic) CLLocationDistance distanceFilterSetting;
@property (nonatomic) CLLocationCoordinate2D myLocation;
@property (nonatomic) CLLocationAccuracy myLocationAccuracy;

@property int totalDistance;
@property float regionRadius;
@property float updateFrequencySeconds;
@property float minAccuracy;
@property float minNumCoordinatesBeforeSend;

@property BOOL regionMonitoringSetupForDay;

@property (nonatomic,strong)NSMutableArray *regionsToMonitor;
@property (atomic,strong)NSMutableData *responseData;
@property (atomic,strong)NSString *onWhichVisit;
@property (nonatomic) NSTimer* locationUpdateTimer;


@property (nonatomic,strong) NSMutableDictionary* logServerGPS;

+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)sendCoordinatesToServer;
- (void)goingToBackgroundMode;

@end
