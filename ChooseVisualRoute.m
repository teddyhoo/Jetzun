//
//  ChooseVisualRoute.m
//  UberScheduler
//
//  Created by Ted Hooban on 9/19/15.
//  Copyright (c) 2015 Ted Hooban. All rights reserved.
//

#import "ChooseVisualRoute.h"

@implementation ChooseVisualRoute


-(instancetype) initWithFrame:(CGRect)frame {
    
    if(self = [super initWithFrame:frame]) {
        
        _backgroundChooseRoute = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0 , frame.size.width, frame.size.height)];
        [_backgroundChooseRoute setImage:[UIImage imageNamed:@"teal-bg"]];
        [self addSubview:_backgroundChooseRoute];
        
        
        CGFloat viewWidth = CGRectGetWidth(self.frame);
        
        NSString *pListData = [[NSBundle mainBundle]
                               pathForResource:@"FavoriteDestinations"
                               ofType:@"plist"];
        
        _favoriteDestinations = [[NSMutableArray alloc]initWithContentsOfFile:pListData];
        
        NSMutableArray *selectItems = [[NSMutableArray alloc]init];
        
        for (NSDictionary *favoriteDetails in _favoriteDestinations) {
            NSLog(@"Image name: %@",[favoriteDetails objectForKey:@"Image"]);
                                     
            UIImage *favoriteImage = [UIImage imageNamed:[favoriteDetails objectForKey:@"Image"]];
            if (favoriteImage != nil) {
                [selectItems addObject:favoriteImage];
                
            }
        }
    
        NSArray *initImgArray = [NSArray arrayWithArray:selectItems];
        
        /*UILabel *destination = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, self.frame.size.height)];
        [destination setFont:[UIFont fontWithName:@"Lato-Bold" size:16]];
        [destination setTextColor:[UIColor blackColor]];
        [destination setText:@"Destination"];
        [self addSubview:destination];*/
        
        _pickerSegmentedControl = [[HMSegmentedControl alloc]initWithSectionImages:initImgArray sectionSelectedImages:initImgArray];
        _pickerSegmentedControl.frame = CGRectMake(0, 0, viewWidth, self.frame.size.height);
        _pickerSegmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _pickerSegmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _pickerSegmentedControl.backgroundColor = [UIColor colorWithRed:0.2 green:0.5 blue:0.2 alpha:1.0];
        
        _pickerSegmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;

        [_pickerSegmentedControl addTarget:self
                                    action:@selector(segmentedControlChangedValue:)
                          forControlEvents:UIControlEventValueChanged];
        
        [self addSubview:_pickerSegmentedControl];

        
        
        
    }
    
    return self;
    
}

- (void)setApperanceForLabel:(UILabel *)label {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    label.backgroundColor = color;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:21.0f];
    label.textAlignment = NSTextAlignmentCenter;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
    
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    
    NSDictionary *selectedItem = [_favoriteDestinations objectAtIndex:segmentedControl.selectedSegmentIndex];
    
    NSLog(@"%@",[selectedItem objectForKey:@"Name"]);
    
}





- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = scrollView.contentOffset.x / pageWidth;
    
    [_pickerSegmentedControl setSelectedSegmentIndex:page animated:YES];
}


@end
