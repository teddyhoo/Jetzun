//
//  LocalEventKitCal.h
//  Jetzun
//
//  Created by Ted Hooban on 11/20/15.
//  Copyright © 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface LocalEventKitCal : NSObject

@property (nonatomic,strong) EKEventStore *eventStore;
@property (nonatomic) BOOL isAccessToEventStoreGranted;
@property (nonatomic,strong) NSMutableArray *reservationItems;

@end
