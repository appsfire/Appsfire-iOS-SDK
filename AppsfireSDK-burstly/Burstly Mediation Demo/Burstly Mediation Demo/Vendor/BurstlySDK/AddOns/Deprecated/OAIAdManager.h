//
// OAIAdManager.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAIAdManagerDelegate.h"
#import "BurstlyUserInfo.h"

typedef enum {
    AdManagerState_Idle,
    AdManagerState_Caching,
    AdManagerState_Cached,
    AdManagerState_Retrieving,      //Trying to request an ad
    AdManagerState_Showing
} AdManagerState;

typedef enum {
    AdManagerLastError_OK,
    AdManagerLastError_Throttle,
    AdManagerLastError_NoFill
} AdManagerLastError;

@protocol BurstlyAdImpressionProtocol;

__attribute__((deprecated("please use BurstlyBanner and BurstlyInterstitial instead")))
@interface OAIAdManager : NSObject {
    id<OAIAdManagerDelegate> _delegate;

    id<BurstlyAdImpressionProtocol> _visibleImpression;
    id<BurstlyAdImpressionProtocol> _cachedImpression;
    id<BurstlyAdImpressionProtocol> _requestedImpression;

    UIView *_adView;
    CGSize _currentBannerViewSize;

    BurstlyUserInfo         *_userInfo;
    NSMutableDictionary     *_customParamsForNetworks;
    NSArray                 *_selectedCreatives;

    NSTimeInterval _watchdogTimeout;
    NSTimeInterval _lastRequestTime;
    NSTimer         *_autoRefreshTimer;
    BOOL            _isAutoRefreshPaused;
    NSTimer         *_requestTimeoutTimer;
}

/**
* Gets or sets ad manager delegate.
*/
@property (nonatomic, assign) id <OAIAdManagerDelegate> delegate;

/**
* Gets ad manager's ad view. This view should be added to application user interface hierarchy to display banner ads.
*/
@property (nonatomic, readonly) UIView *adView;

/**
* Gets or sets user info parameters.
*/
@property (nonatomic, retain) BurstlyUserInfo *userInfo;

/**
* Gets ad manager current state.
*/
@property (nonatomic, readonly) AdManagerState state;

/**
* Gets ad manager last error.
*/
@property (nonatomic, readonly) AdManagerLastError lastError;

/**
* Gets or sets whether auto refresh paused.
*/
@property (nonatomic, readwrite) BOOL isAutoRefreshPaused;

/**
 * Gets or sets prefered ad's id, Debug only.
 */
@property (nonatomic, retain) NSArray *selectedCreatives;

/**
* Returns whether cached ad is expired to be presented.
* Returns NO if there is no cached ad.
*/
@property (nonatomic, readonly) BOOL isCachedAdExpired;

/**
* Returns list of failed networks names.
*/
@property (nonatomic, readonly) NSArray *failedNetworks;

/**
* Returns minimum allowed time to next request.
*/
@property (nonatomic, readonly) NSTimeInterval timeToNextAllowedRequest;

/**
* Returns YES if ad manager is currently caching ad. Returns NO in all other cases.
*/
@property (nonatomic, readonly) BOOL isLastRequestCaching;

/**
* Initializes ad manager instance with delegate.
*
* @param delegate Ad manager delegate.
* @returns Initialized instance of ad manager.
*/
- (id)initWithDelegate: (id<OAIAdManagerDelegate>)delegate;

/**
* Asynchronously requests server for new ad and shows it. If an ad was previously cached (@see cacheAd), it will be displayed immediately.
*/
- (void)requestRefreshAd;

/**
* Asynchronously requests server for new ad.
*/
- (void)cacheAd;

/**
* Recalculates banner ad view position and relocates it.
*/
- (void)updateBannerViewPosition;

/**
* Initializes specified ad network.
*
* @param networkName Name of ad network to be initialized.
* @param params Ad network parameters.
*/
- (void)performAdNetworkInitialization: (NSString *)networkName withParams: (NSDictionary *)params;

/**
* Sets parameters for specific network.
*
* @param networkName Name of ad network.
* @param params Ad network parameters.
*/
- (void)setCustomParamsForNetwork: (NSString *)networkName withDictionary: (NSDictionary *)params;

/**
 * Sets id's values for requered ad's, debug only.
 *
 * @param creatives Array of id.
 */
- (void)setSelectThisCreative: (NSArray *)creatives;

/**
* Disables watchdog timer for every ad network request.
*/
- (void)disableWatchdog;

/**
* Enables watchdog timer for every ad network request.
*
* @param timeout Watchdog timeout interval.
*/
- (void)enableWatchdogWithTimeout: (NSTimeInterval)timeout;

@end