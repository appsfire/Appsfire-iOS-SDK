//
// BurstlyCurrencyUpdateInfo.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BurstlyCurrencyUpdateInfo : NSObject

@property (nonatomic, readonly) NSString * currency;
@property (nonatomic, readonly) NSInteger oldTotal;
@property (nonatomic, readonly) NSInteger newTotal;
@property (nonatomic, readonly) NSInteger change;

@end
