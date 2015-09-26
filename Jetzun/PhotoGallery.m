//
//  PhotoGallery.m
//  RevealControllerProject
//
//  Created by Ted Hooban on 3/6/15.
//
//

#import "PhotoGallery.h"
#import "JT3DScrollView.h"
#import "GalleryView.h"
#import "VisitsAndTracking.h"
#import <Parse/Parse.h>

@interface PhotoGallery () {
    
    NSMutableArray *pictureData;
    
}

@property (nonatomic,strong) JT3DScrollView *scrollView;

@end



@implementation PhotoGallery

- (void)viewDidLoad {
    [super viewDidLoad];

    _sharedVisits = [VisitsAndTracking sharedInstance];
    
    self.view.userInteractionEnabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getReservationObjects];
    
    _scrollView = [[JT3DScrollView alloc]initWithFrame:CGRectMake(40, 60, self.view.frame.size.width - 40, self.view.frame.size.height -80)];
    
    self.scrollView.effect = JT3DScrollViewEffectTranslation;
    self.scrollView.delegate = self;
    

    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height)];
    [background setImage:[UIImage imageNamed:@"teal-bg"]];
    background.alpha = 0.8;
    
    [self.view addSubview:background];
    [self.view addSubview:_scrollView];
    
    /*NSString *pListData = [[NSBundle mainBundle]
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
        
        [cardTopic.vehiclePhoto setImage:[UIImage imageNamed:[driverInfo objectForKey:@"VehiclePictureFileName"]]];
        
        [cardTopic addDetails];
        
        [self.scrollView addSubview:cardTopic];
        self.scrollView.contentSize = CGSizeMake(x+width,height);
        
    }*/
}


-(void)getReservationObjects {
    
    NSLog(@"getting reservation objects");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Reservation"];
    [query whereKey:@"Status" equalTo:@"NEW"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            
            for (PFObject *reservation in objects) {
                
                CGFloat width = CGRectGetWidth(self.scrollView.frame);
                CGFloat height = CGRectGetHeight(self.scrollView.frame);
                CGFloat x = self.scrollView.subviews.count * width;
                
                GalleryView *cardTopic = [[GalleryView alloc]initWithFrame:CGRectMake(x, 0, 380, 900)
                                                                   andData:[reservation objectForKey:@"TypeOfProduct"]
                                                                 andPickup:[reservation objectForKey:@"PickupLocation"]
                                                                andDropoff:[reservation objectForKey:@"DropoffLocation"]
                                                                   andHour:[reservation objectForKey:@"PickupHour"]
                                                                    andMin:[reservation objectForKey:@"PickupMinute"]
                                                                    onDate:[reservation objectForKey:@"ChosenDate"]
                                                                withCharge:[reservation objectForKey:@"EstimatedCharge"]];
                
                
                [self.scrollView addSubview:cardTopic];
                self.scrollView.contentSize = CGSizeMake(x+width,height);
                
            }
        }
        
    }];
}


- (NSUInteger)numberOfCardsInCarousel:(UPCardsCarousel *)carousel
{
    NSUInteger thecount = [_photoArray count];
    return thecount;
}

- (UIView*)carousel:(UPCardsCarousel *)carousel viewForCardAtIndex:(NSUInteger)index
{

    return [self createCardViewWithImage:[_photoArray objectAtIndex:index]];
    
    //return [_photoArray objectAtIndex:index];
}

- (NSString*)carousel:(UPCardsCarousel *)carousel labelForCardAtIndex:(NSUInteger)index
{
    return [NSString stringWithFormat:@"Crash is not happy about being crammed in the back seat", (int)index];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)carousel:(UPCardsCarousel *)carousel didTouchCardAtIndex:(NSUInteger)index
{
    NSString *message = [NSString stringWithFormat:@"Card %i touched", (int)index];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (UIView*)createCardViewWithLabel:(NSString*)label
{
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 440, 440)];
    [cardView setBackgroundColor:[UIColor colorWithRed:180./255. green:180./255. blue:180./255. alpha:1.]];
    [cardView.layer setShadowColor:[UIColor blackColor].CGColor];
    [cardView.layer setShadowOpacity:.5];
    [cardView.layer setShadowOffset:CGSizeMake(0, 0)];
    [cardView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cardView.layer setBorderWidth:10.];
    [cardView.layer setCornerRadius:4.];

    
    return cardView;
}

- (UIView*)createCardViewWithImage:(UIImageView*)image
{
    UIView *cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 290)];
    [cardView setBackgroundColor:[UIColor colorWithRed:180./255. green:180./255. blue:180./255. alpha:1.]];
    [cardView.layer setShadowColor:[UIColor blackColor].CGColor];
    [cardView.layer setShadowOpacity:.5];
    [cardView.layer setShadowOffset:CGSizeMake(0, 0)];
    [cardView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [cardView.layer setBorderWidth:10.];
    [cardView.layer setCornerRadius:4.];

    [cardView addSubview:image];
    
    return cardView;
}




- (void)loadNextPage:(id)sender
{
    
    
}


- (void)loadPageIndex:(NSUInteger)index animated:(BOOL)animated
{
    
}

@end
