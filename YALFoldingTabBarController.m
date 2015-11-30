// For License please refer to LICENSE file in the root of YALAnimatingTabBarController project

#import "YALFoldingTabBarController.h"
#import "YALTabBarItem.h"
#import "YALTabBarInteracting.h"
#import "YALAnimatingTabBarConstants.h"

#import "MessageViewController.h"
#import "FrontViewController.h"
#import "TripMonitorViewController.h"
#import "ReservationCards.h"
#import "PhotoGallery.h"

@interface YALFoldingTabBarController () <YALTabBarViewDataSource, YALTabBarViewDelegate>

@property (nonatomic, assign) YALTabBarState state;

@end

@implementation YALFoldingTabBarController

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        NSLog(@"called init");
        
        [self setup];
    }
    return self;
}

-(BOOL)prefersStatusBarHidden {
    
    return YES;
}

- (void)setup {
    self.tabBarViewHeight = YALTabBarViewDefaultHeight;
    
    [self setupTabBarView];
}

#pragma mark - View & LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarView = [[YALFoldingTabBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, YALTabBarViewDefaultHeight)];
    
    self.tabBarView.dataSource = self;
    self.tabBarView.delegate = self;
    
    MessageViewController *firstVC = [[MessageViewController alloc]init];
    FrontViewController *secondVC = [[FrontViewController alloc]init];
    TripMonitorViewController *thirdVC = [[TripMonitorViewController alloc]init];
    PhotoGallery *fourthVC = [[PhotoGallery alloc]init];
    
    NSMutableArray *localVCArray = [[NSMutableArray alloc]init];
    [localVCArray addObject:secondVC];
    [localVCArray addObject:firstVC];
    [localVCArray addObject:thirdVC];
    [localVCArray addObject:fourthVC];
    
    self.viewControllers = localVCArray;
    
    [self.view addSubview:self.tabBarView];
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    [self.tabBar setShadowImage:[[UIImage alloc] init]];
    //self.tabBar.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = self.tabBarViewHeight;
    tabFrame.origin.y = self.view.frame.size.height - self.tabBarViewHeight;
    self.tabBar.frame = tabFrame;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self updateTabBarViewFrame];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];

    self.tabBarView.selectedTabBarItemIndex = selectedIndex;
    [self.tabBarView setNeedsLayout];
}

#pragma mark - Private

- (void)updateTabBarViewFrame {
    CGFloat tabBarViewOriginX = self.tabBar.frame.origin.x;
    CGFloat tabBarViewOriginY = self.tabBar.frame.origin.y;
    CGFloat tabBarViewSizeWidth = CGRectGetWidth(self.tabBar.frame);
    
    self.tabBarView.frame = CGRectMake(tabBarViewOriginX, tabBarViewOriginY, tabBarViewSizeWidth, self.tabBarViewHeight);
    [self.tabBarView setNeedsLayout];
}

- (void)setupTabBarView {
    //self.tabBarView = [[YALFoldingTabBar alloc] initWithFrame:CGRectZero state:self.state];
    
   
}

- (id<YALTabBarInteracting>)currentInteractingViewController {
    NSLog(@"current view controller: %@",self.selectedViewController.description);
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        return (id<YALTabBarInteracting>)[(UINavigationController *)self.selectedViewController topViewController];
    } else {
        
        NSLog(@"other tap: %@",self.selectedViewController);
        
        return (id<YALTabBarInteracting>)self.selectedViewController;
    }
}

#pragma mark - YALTabBarViewDataSource

- (NSArray *)leftTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView {
    return self.leftBarItems;
}

- (NSArray *)rightTabBarItemsInTabBarView:(YALFoldingTabBar *)tabBarView {
    return self.rightBarItems;
}

- (UIImage *)centerImageInTabBarView:(YALFoldingTabBar *)tabBarView {
    return self.centerButtonImage;
}

#pragma mark - YALTabBarViewDelegate

- (void)tabBarViewWillCollapse:(YALFoldingTabBar *)tabBarView {
    id<YALTabBarInteracting>viewController = [self currentInteractingViewController];
    if ([viewController respondsToSelector:@selector(tabBarViewWillCollapse)]) {
        [viewController tabBarViewWillCollapse];
    }
}

- (void)tabBarViewDidCollapse:(YALFoldingTabBar *)tabBarView {
    id<YALTabBarInteracting>viewController = [self currentInteractingViewController];
    if ([viewController respondsToSelector:@selector(tabBarViewDidCollapse)]) {
        [viewController tabBarViewDidCollapse];
    }
}

- (void)tabBarViewWillExpand:(YALFoldingTabBar *)tabBarView {
    id<YALTabBarInteracting>viewController = [self currentInteractingViewController];
    if ([viewController respondsToSelector:@selector(tabBarViewWillExpand)]) {
        [viewController tabBarViewWillExpand];
    }
}

- (void)tabBarViewDidExpand:(YALFoldingTabBar *)tabBarView {
    id<YALTabBarInteracting>viewController = [self currentInteractingViewController];
    if ([viewController respondsToSelector:@selector(tabBarViewDidExpand)]) {
        [viewController tabBarViewDidExpand];
    }
}

- (void)extraLeftItemDidPressInTabBarView:(YALFoldingTabBar *)tabBarView {
    id<YALTabBarInteracting>viewController = [self currentInteractingViewController];
    if ([viewController respondsToSelector:@selector(extraLeftItemDidPress)]) {
        [viewController extraLeftItemDidPress];
    }
}

- (void)extraRightItemDidPressInTabBarView:(YALFoldingTabBar *)tabBarView {
    NSLog(@"right item pressed");

    id<YALTabBarInteracting>viewController = [self currentInteractingViewController];
    if ([viewController respondsToSelector:@selector(extraRightItemDidPress)]) {
        [viewController extraRightItemDidPress];
    }
}

- (void)itemInTabBarViewPressed:(YALFoldingTabBar *)tabBarView atIndex:(NSUInteger)index {
    self.selectedViewController = [self.viewControllers objectAtIndex:index];
}


@end
