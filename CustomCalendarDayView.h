//
//  CustomCalendarDayView.h
//  LeashTimeClientPet
//
//  Created by Ted Hooban on 9/22/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCalendarDayView.h"

@interface CustomCalendarDayView : UIView<JTCalendarDay>

@property (nonatomic, weak) JTCalendarManager *manager;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic) BOOL isFromAnotherMonth;

@property (nonatomic) NSDate *date;

@property (nonatomic, readonly) UIView *circleView;
@property (nonatomic, readonly) UIView *dotView;
@property (nonatomic) CGFloat circleRatio;
@property (nonatomic) CGFloat dotRatio;

- (void)commonInit;



@end
