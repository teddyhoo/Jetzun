//
//  ChooseVisualRoute.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/19/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface ChooseVisualRoute : UIView <UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *backgroundChooseRoute;
@property (nonatomic,strong) HMSegmentedControl *pickerSegmentedControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *favoriteDestinations;

@end
