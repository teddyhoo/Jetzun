//
//  ReservationCards.h
//  UberScheduler
//
//  Created by Ted Hooban on 9/16/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPCardsCarousel.h"

@interface ReservationCards : UIViewController <UPCardsCarouselDataSource, UPCardsCarouselDelegate, UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,strong) UIImageView *favoriteIcon;


@end
