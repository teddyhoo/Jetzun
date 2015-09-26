//
//  VisitTableCell.m
//  LeashTimeSitterV1
//
//  Created by Ted Hooban on 11/25/14.
//  Copyright (c) 2014 Ted Hooban. All rights reserved.
//

#import "VisitTableCell.h"
#import "UIImageView+Rotate.h"
#import "VisitsAndTracking.h"

@implementation VisitIndicatorView

-(void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents(_indicatorColor.CGColor));
    CGContextFillPath(ctx);
    
    if (_innerColor) {
        CGFloat innerSize = rect.size.width * 1.0;
        CGRect innerRect = CGRectMake(rect.origin.x + rect.size.width * 1.5 - innerSize * 1.5,
                                      rect.origin.y + rect.size.height * 1.5 - innerSize * 1.5,
                                      innerSize, innerSize);
        CGContextAddEllipseInRect(ctx, innerRect);
        CGContextSetFillColor(ctx, CGColorGetComponents(_innerColor.CGColor));
        CGContextFillPath(ctx);
    }
}

-(void) setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    [self setNeedsDisplay];
}

-(void) setInnerColor:(UIColor *)innerColor
{
    _innerColor = innerColor;
    [self setNeedsDisplay];
}

@end


@implementation VisitTableCell

VisitsAndTracking *sharedVisits;
BOOL isIphone6P;
BOOL isIphone6;
BOOL isIphone5;
BOOL isIphone4;

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        sharedVisits = [VisitsAndTracking sharedInstance];
        NSString *theDeviceType = [sharedVisits tellDeviceType];
        
        if ([theDeviceType isEqualToString:@"iPhone6P"]) {
            isIphone6P = YES;
       
        } else if ([theDeviceType isEqualToString:@"iPhone6"]) {
            isIphone6 = YES;
            
        } else if ([theDeviceType isEqualToString:@"iPhone5"]) {
            isIphone5 = YES;
            
        } else {
            isIphone4 = YES;
        }

        
        if ([[sharedVisits tellDeviceType]isEqualToString:@"iPhone6P"]) {

            
        } else if ([[sharedVisits tellDeviceType]isEqualToString:@"iPhone6"])  {
            

            
        } else if ([[sharedVisits tellDeviceType]isEqualToString:@"iPhone5"]) {

            
            
        } else if ([[sharedVisits tellDeviceType]isEqualToString:@"iPhone4"]) {


        }

    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];

    
}




@end
