//
//  VisitAnnotationView.h
//  LeashTimeSitterV1
//
//  Created by Ted Hooban on 12/17/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Foundation/Foundation.h>
#import "VisitAnnotation.h"

@interface VisitAnnotationView : MKAnnotationView

@property (nonatomic,strong)UIImageView *imageView;

-(id)initWithFrame:(CGRect)frame

initWithAnnotation:(VisitAnnotation*)annotation
   reuseIdentifier:(NSString *)reuseIdentifier;
@end
