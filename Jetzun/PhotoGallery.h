//
//  PhotoGallery.h
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/6/15.
//
//

#import <UIKit/UIKit.h>
#import "UPCardsCarousel.h"
#import "VisitsAndTracking.h"
#import "ReservationDetails.h"  

@interface PhotoGallery : UIViewController <UPCardsCarouselDataSource, UPCardsCarouselDelegate, UIScrollViewDelegate>

-(instancetype)initWithReservation:(ReservationDetails*)reservationDetails;

    
@property (nonatomic,strong) ReservationDetails *reservationDetails;
@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,strong) UIImageView *favoriteIcon;
@property (nonatomic,strong) VisitsAndTracking *sharedVisits;

@end
