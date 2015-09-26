//
//  VisitTableCell.h
//  LeashTimeSitterV1
//
//  Created by Ted Hooban on 11/25/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"



@interface VisitIndicatorView : UIView

@property (nonatomic,strong)UIColor *indicatorColor;
@property (nonatomic,strong)UIColor *innerColor;

@end


@interface VisitTableCell : MGSwipeTableCell

@property (nonatomic,strong) VisitIndicatorView *indicatorView;
@property (nonatomic,strong) UIImageView *backgroundIV;
@property (nonatomic,strong) UIImageView *cancelationBack;
@property (nonatomic,strong) UIImageView *lateVisitBack;
@property (nonatomic,strong) UIImageView *arrivedImg;
@property (nonatomic,strong) UIImageView *completedImg;
@property (nonatomic,strong) UIImageView *photoFrame;
@property (nonatomic,strong) UIImageView *petPhoto;

@property (nonatomic, strong) UILabel * driverName;
@property (nonatomic, strong) UILabel * destinationName;
@property (nonatomic, strong) UILabel * timeBegin;
@property (nonatomic, strong) UILabel * timeEnd;
@property (nonatomic, strong) UILabel * visitNote;
@property (nonatomic, strong) UILabel * keyIDLabel;
@property (nonatomic, strong) UILabel * photoLabel;

@property (nonatomic,strong) UIImageView *lateVisitImg;
@property (nonatomic,strong) UIImageView *alarmBellImg;
@property (nonatomic,strong) UIImageView *highPriorityImg;
@property (nonatomic,strong) UIImageView *hasKeyIcon;
@property (nonatomic,strong) UIImageView *noteIcon;

@property (nonatomic,strong) UIImageView *managerVisitNote;
@property (nonatomic,strong) UIImageView *clientVisitNote;
@property (nonatomic,strong) UIImageView *sitterVisitNote;

@property (nonatomic,strong) UIImageView *backgroundBorder;

@property BOOL arrived;
@property BOOL completed;
@property BOOL pendingCancelation;
@property BOOL highPriority;
@property BOOL late;

@property BOOL showPetPic;
@property BOOL showPawPrint;
@property BOOL showKeyIcon;
@property BOOL showFlags;

@end
