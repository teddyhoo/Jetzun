#import "AppDelegate.h"
#import "YALTabBarItem.h"
#import "YALFoldingTabBarController.h"
#import "YALAnimatingTabBarConstants.h"
#import "UberKit.h"
#import <Parse/Parse.h>
#import "VisitsAndTracking.h"
#import "LocationTracker.h"
#import "VisitsAndTracking.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [application setStatusBarHidden:YES];
    VisitsAndTracking *sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    
    _locationTracker = [[LocationTracker alloc]init];
    [_locationTracker startLocationTracking];

    if (IS_IPHONE_6P) {
        [sharedVisitsTracking setDeviceType:@"iPhone6P"];
        
    } else if (IS_IPHONE_6) {
        [sharedVisitsTracking setDeviceType:@"iPhone6"];
        
    } else if (IS_IPHONE_5) {
        [sharedVisitsTracking setDeviceType:@"iPhone5"];
        
    } else if (IS_IPHONE_4_OR_LESS) {
        
        [sharedVisitsTracking setDeviceType:@"iPhone4"];
        
    }
    
    NSLog(@"dev type: %@",sharedVisitsTracking.deviceType);
    
    [self setupYALTabBarController];
    
    return YES;
}

- (BOOL) preferStatusBarHidden {
    
    return YES;
}

- (void)setupYALTabBarController {
    YALFoldingTabBarController *tabBarController = (YALFoldingTabBarController *) self.window.rootViewController;
    
    self.window.rootViewController = tabBarController;
    YALTabBarItem *item1 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"profile_icon"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    
    YALTabBarItem *item2 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"calendar72"]
                                                      leftItemImage:[UIImage imageNamed:@"edit_icon"]
                                                     rightItemImage:[UIImage imageNamed:@"white-checkmark-noback"]];
    
    tabBarController.leftBarItems = @[item1, item2];
    
    YALTabBarItem *item3 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"midsize"]
                                                      leftItemImage:[UIImage imageNamed:@"search_icon"]
                                                     rightItemImage:[UIImage imageNamed:@"new_chat_icon"]];
    
    
    YALTabBarItem *item4 = [[YALTabBarItem alloc] initWithItemImage:[UIImage imageNamed:@"location-white"]
                                                      leftItemImage:nil
                                                     rightItemImage:nil];
    
    tabBarController.rightBarItems = @[item3, item4];
    tabBarController.centerButtonImage = [UIImage imageNamed:@"plus_icon"];
    tabBarController.selectedIndex = 3;
    
    //customize tabBarView
    tabBarController.tabBarView.extraTabBarItemHeight = YALExtraTabBarItemsDefaultHeight;
    tabBarController.tabBarView.offsetForExtraTabBarItems = YALForExtraTabBarItemsDefaultOffset;
    //tabBarController.tabBarView.backgroundColor = [UIColor colorWithRed:94.0/255.0 green:91.0/255.0 blue:149.0/255.0 alpha:1];
    tabBarController.tabBarView.tabBarColor = [UIColor colorWithRed:72.0/255.0 green:211.0/255.0 blue:178.0/255.0 alpha:1];
    tabBarController.tabBarViewHeight = YALTabBarViewDefaultHeight;
    tabBarController.tabBarView.tabBarViewEdgeInsets = YALTabBarViewHDefaultEdgeInsets;
    tabBarController.tabBarView.tabBarItemsEdgeInsets = YALTabBarViewItemsDefaultEdgeInsets;
}


@end


