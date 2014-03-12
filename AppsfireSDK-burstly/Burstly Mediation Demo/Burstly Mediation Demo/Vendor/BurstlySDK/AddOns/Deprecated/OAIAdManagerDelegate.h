//
// OAIAdManagerDelegate.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BurstlyAnchor.h"
#import "BurstlyAdPlacement.h"
#import <CoreLocation/CoreLocation.h>

@class OAIAdManager;

__attribute__((deprecated("please use BurstlyBannerDelegate and BurstlyInterstitialDelegate instead")))
@protocol OAIAdManagerDelegate <NSObject>

@required

/**
* Gets burstly ad publisher identifier.
*
* @returns burstly ad publisher identifier.
*/
- (NSString *)publisherId;

/**
* Gets burstly ad zone.
*
* @returns burstly ad zone.
*/
- (NSString *)getZone;

/**
* Returns view controller will be used to present modal user interface.
*
* @returns view controller will be used to present modal user interface.
*/
- (UIViewController *)viewControllerForModalPresentation;

/**
* Returns view will be used to present modal user interface.
*
* @returns view will be used to present modal user interface.
*/
- (UIView *)viewForModalPresentation;

@optional

/**
* Returns whether full screen ad should autorotate to specified user interface orientation.
*
* @param orientation User interface orientation.
*
* @returns YES if full screen ad should autorotate to specified user interface orientation; otherwise returns NO.
*/
- (BOOL)shouldAutorotateInterstitialAdToInterfaceOrientation: (UIInterfaceOrientation)orientation;

/**
* Returns current orientation of the application user interface.
*
* @returns Current orientation of the application user interface.
*/
- (UIInterfaceOrientation)currentOrientation;

/**
* Style the modal presentation for burstly ads. UIModalTransitionStyleVertical by default, partial curl not allowed.
*/
- (UIModalTransitionStyle)burstlyModalTransitionStyle;

- (void)adManager: (OAIAdManager *)manager attemptingToLoad: (NSString *)networkName;

- (void)adManager: (OAIAdManager *)manager didLoad: (NSString *)networkName isInterstitial: (BOOL)isInterstitial;

- (void)adManager: (OAIAdManager *)manager didPrecacheAd: (NSString *)networkName isInterstitial: (BOOL)isInterstitial;

- (void)adManager: (OAIAdManager *)manager failedToLoad: (NSString *)networkName;

- (void)adManagerFailedToLoadAll: (OAIAdManager *)manager withTimeout: (BOOL)isTimedOut;

- (void)adManager: (OAIAdManager *)manager adNetworkWasClicked: (NSString *)networkName;

- (void)adManager: (OAIAdManager *)manager willLeaveApplication: (NSString *)networkName;

- (void)adManager: (OAIAdManager *)manager adNetworkControllerPresentFullScreen: (NSString *)networkName;

- (void)adManager: (OAIAdManager *)manager adNetworkControllerDismissFullScreen: (NSString *)networkName;

- (void)adManager: (OAIAdManager *)manager viewDidChangeSize: (CGSize)newSize fromOldSize: (CGSize)oldSize;

- (void)adManager: (OAIAdManager *)manager didHideView: (NSString *)networkName;

- (void)adManager: (OAIAdManager *)manager didShowAdBannerViewOfNetwork: (NSString *)networkName;

- (void)adManagerRequestThrottled: (OAIAdManager *)manager;

- (void)adManagerRequestTimedOut: (OAIAdManager *)manager;

- (BurstlyAdPlacementType)adManagerAdPlacementType: (OAIAdManager *)manager;

- (CGSize)adManagerBannerSize: (OAIAdManager *)manager;



- (BurstlyAnchor)burstlyAnchor;

- (CGPoint)burstlyAnchorPoint;

- (NSTimeInterval)requestTimeout;

- (NSTimeInterval)defaultSessionLife;

// Optional params
- (NSString *)pubTargeting;
- (NSString *)crParms;
- (NSString *)placement;
- (CGSize)maxAdSize;
- (NSString *)debugFlags;
- (NSString *)noTrack;
- (UIColor *)adBackgroundColor;
- (UIColor *)adTextColor;
- (CLLocation *)burstlyLocationInfo;
- (NSString *)ipAddress;

@end