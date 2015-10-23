//
//  AppDelegate.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/9/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "UberKit.h"
#import <Parse/Parse.h>

#import "VisitsAndTracking.h"
#import "LocationTracker.h"
#import "FrontViewController.h"
#import "RearViewController.h"
#import "CustomAnimationController.h"
#import "PhotoGallery.h"


@interface AppDelegate()<SWRevealViewControllerDelegate>
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

@synthesize window = _window;
@synthesize viewController = _viewController;

//- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions {

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application setStatusBarHidden:YES];
    VisitsAndTracking *sharedVisitsTracking = [VisitsAndTracking sharedInstance];
    
    _locationTracker = [[LocationTracker alloc]init];
    [_locationTracker startLocationTracking];
    
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"ZKMMb0AGM6XqxBvoUeRx627R7OV5QuXpEv3YHAlA"
                  clientKey:@"DbBSkhJiT0qqxPtSrDGKXDfEJ8Dq8IH6mRSkS8LY"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    
    if (IS_IPHONE_6P) {
        [sharedVisitsTracking setDeviceType:@"iPhone6P"];
        
    } else if (IS_IPHONE_6) {
        [sharedVisitsTracking setDeviceType:@"iPhone6"];
        
    } else if (IS_IPHONE_5) {
        [sharedVisitsTracking setDeviceType:@"iPhone5"];
        
    } else if (IS_IPHONE_4_OR_LESS) {
        
        [sharedVisitsTracking setDeviceType:@"iPhone4"];
        
    }
    
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window = window;
    
    FrontViewController *frontViewController = [[FrontViewController alloc] init];
    RearViewController *rearViewController = [[RearViewController alloc] init];
    
    //UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:frontViewController];
    
    //frontNavigationController.toolbarHidden = YES;
    
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc]
                                                initWithRearViewController:rearViewController
                                                frontViewController:frontViewController];
   // revealController.automaticallyAdjustsScrollViewInsets = FALSE;
    revealController.delegate = self;
    revealController.rightViewController = nil;
    
   // frontViewController.automaticallyAdjustsScrollViewInsets = FALSE;

    
    self.viewController = revealController;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if([[UberKit sharedInstance] handleLoginRedirectFromUrl:url sourceApplication:sourceApplication])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    NSLog(@"application did enter background");
    
    [_locationTracker goingToBackgroundMode];
    
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
