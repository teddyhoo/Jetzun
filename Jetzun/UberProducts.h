//
//  UberProducts.h
//  Jetzun
//
//  Created by Ted Hooban on 11/8/15.
//  Copyright © 2015 Ted Hooban. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UberProducts : NSObject


@property (nonatomic,copy) NSString *productID;
@property (nonatomic,copy) NSString *productDescription;
@property (nonatomic,copy) NSString *capacity;
@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSString *basePrice;
@property (nonatomic,copy) NSString *cancelFee;
@property (nonatomic,copy) NSString *costPerDistance;
@property (nonatomic,copy) NSString *costPerMinute;
@property (nonatomic,copy) NSString *currencyCode;
@property (nonatomic,copy) NSString *distanceUnit;
@property (nonatomic,copy) NSString *minimumCharge;


@end
