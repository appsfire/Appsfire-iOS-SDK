//
// BurstlyCurrency.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BurstlyCurrencyUpdateInfo.h"

@class BurstlyCurrency;

extern NSString * BurstlyCurrencyBalancesUpdateNotification;



@protocol BurstlyCurrencyDelegate <NSObject>

@optional

- (void)currencyManager:(BurstlyCurrency *)manager didUpdateBalances:(NSDictionary *)balances;
- (void)currencyManager:(BurstlyCurrency *)manager didFailToUpdateBalanceWithError:(NSError *)error;

@end


@interface BurstlyCurrency : NSObject {
    id<BurstlyCurrencyDelegate> delegate_;
    NSString *appId_;
    NSString *userId_;
}

+ (BurstlyCurrency *) sharedCurrencyManager;

- (NSInteger) currentBalanceForCurrency:(NSString *)currency;
- (NSInteger) increaseBalance:(NSUInteger)amount forCurrency:(NSString *)currency;
- (NSInteger) decreaseBalance:(NSUInteger)amount forCurrency:(NSString *)currency;

- (void) checkForUpdate;


- (void)setAppId: (NSString*)appId;
- (void)setAppId: (NSString *)appId andUserId: (NSString*)userId;

@property (nonatomic, assign) id<BurstlyCurrencyDelegate> delegate;
@property (nonatomic, readonly) NSString *appId;
@property (nonatomic, readonly) NSString *userId;

@end
