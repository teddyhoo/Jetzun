//
//  VisitAnnotationView.m
//  LeashTimeSitterV1
//
//  Created by Ted Hooban on 12/17/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import "VisitAnnotationView.h"
#import "VisitAnnotation.h"

@implementation VisitAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self) {
        VisitAnnotation *visitAnnotation = self.annotation;
        
        switch (visitAnnotation.typeOfAnnotation) {

            case VisitStart:
                [self setImage:[UIImage imageNamed:@"annotation-home-icon"]];
                break;
            case VisitEnd:
                [self setImage:[UIImage imageNamed:@"destination-star-icon"]];
                break;
            case UberBlack:
                [self setImage:[UIImage imageNamed:@"map-vehicle-icon-black"]];
                break;
            case UberSUV:
                [self setImage:[UIImage imageNamed:@"map-vehicle-icon-suv"]];
                break;
            case UberXL:
                [self setImage:[UIImage imageNamed:@"map-vehicle-icon-xl"]];
                break;
            case UberX:
                [self setImage:[UIImage imageNamed:@"map-verhicle-icon-uberX"]];
                break;
            default:
                [self setImage:[UIImage imageNamed:@"destination-star-icon"]];
                break;
        }
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        CGRect  viewRect = CGRectMake(-20, -20, 40, 40);
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:viewRect];

        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _imageView = imageView;
        
        [self addSubview:imageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{

    _imageView.image = image;
}

@end
