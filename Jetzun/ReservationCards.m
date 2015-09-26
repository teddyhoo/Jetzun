//
//  ReservationCards.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/16/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "ReservationCards.h"
#import "JT3DScrollView.h"
#import "GalleryView.h"


@interface ReservationCards () {
    
    NSMutableArray *pictureData;
    
}

@property (nonatomic,strong) JT3DScrollView *scrollView;

@end




@implementation ReservationCards

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _scrollView = [[JT3DScrollView alloc]initWithFrame:CGRectMake(40, 60, self.view.frame.size.width - 40, self.view.frame.size.height -80)];
    
    self.scrollView.effect = JT3DScrollViewEffectTranslation;
    self.scrollView.delegate = self;
    
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"teal-bg"]];
    background.alpha = 0.8;
    
    [self.view addSubview:background];
    [self.view addSubview:_scrollView];
    
    NSString *pListData = [[NSBundle mainBundle]
                           pathForResource:@"Driver-Profile"
                           ofType:@"plist"];
    
    pictureData = [[NSMutableArray alloc] initWithContentsOfFile:pListData];
    
    for (NSDictionary *driverInfo in pictureData) {
        CGFloat width = CGRectGetWidth(self.scrollView.frame);
        CGFloat height = CGRectGetHeight(self.scrollView.frame);
        CGFloat x = self.scrollView.subviews.count * width;
        
        
        NSString *imageName = [driverInfo objectForKey:@"ImageID"];
        NSString *captionString = [driverInfo objectForKey:@"DriverName"];
        
        GalleryView *cardTopic = [[GalleryView alloc]
                                  initWithFrame:CGRectMake(x, 0, 380, 900)
                                  andData:imageName
                                  andCaption:captionString];
        
        
        
        
        cardTopic.driverRating = [driverInfo objectForKey:@"DriverRating"];
        cardTopic.driverVehicleMake = [driverInfo objectForKey:@"VehicleMake"];
        cardTopic.driverVehicleModel = [driverInfo objectForKey:@"VehicleModel"];
        cardTopic.driverVehicleYear = [driverInfo objectForKey:@"VehicleYear"];
        cardTopic.driverProfileDescription = [driverInfo objectForKey:@"ProfileDescription"];
        NSLog(@"%@",[driverInfo objectForKey:@"ProfileDescription"]);
        
        [cardTopic.vehiclePhoto setImage:[UIImage imageNamed:[driverInfo objectForKey:@"VehiclePictureFileName"]]];
        
        [cardTopic addDetails];
        
        [self.scrollView addSubview:cardTopic];
        self.scrollView.contentSize = CGSizeMake(x+width,height);
        
        
    }
}





@end
