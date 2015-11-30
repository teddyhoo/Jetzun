//
//  AppDelegate.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/9/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "LocationShareModel.h"
#import "LocationTracker.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) LocationTracker *locationTracker;

@property LocationShareModel *shareModel;
@end

