//
// BurstlyBanner.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "BurstlyAdRequest.h"
#import "BurstlyAnchor.h"

#pragma mark Delegate

@class BurstlyBanner;
@class OAIAdManager;

@protocol BurstlyBannerDelegate <NSObject>

@optional

// Sent when the ad view takes over the screen when the banner is clicked. Use this callback as an
// oppurtunity to implement state specific details such as pausing animation, timers, etc. The
// exact timing of this callback is not guaranteed as a few ad networks roll out the canvas
// prior to sending a callback whereas some others do the opposite. The following ad networks
// notify us prior to rolling out the canvas.
// Admob, Greystripe, Inmobi
// @param: view - Specifies banner view which is going to present full screen.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyBanner:(BurstlyBanner *)view willTakeOverFullScreen:(NSDictionary *)info;

// Sent when the ad view is dismissed from screen.
// @param: view - Specifies banner view which dismissed full screen.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyBanner:(BurstlyBanner *)view willDismissFullScreen:(NSDictionary *)info;

// Sent with banner view hides itself.
// @param: view - Specifies banner view which did hide itself.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyBanner:(BurstlyBanner *)view didHide:(NSDictionary *)info;

// Sent when an ad request succeeded and a valid view is available to be displayed.
// @param: view - Specifies banner view which was loaded.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyBanner:(BurstlyBanner *)view didShow:(NSDictionary *)info;

// Typically caching a banner is not required as it does not introduce delays that affect user
// experience. But in select cases, the game may run in to resource intensive modes and would require
// the ad to be loaded during off-peak intervals such as in-between levels. This is when you may want
// to cache a banner and animate the view whenever applicable.
// @param: view - Specifies banner view which was cached.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyBanner:(BurstlyBanner *)view didCache:(NSDictionary *)info;

// Sent when the banner ad view is clicked.
// @param: view - Specifies banner view which was clicked.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyBanner:(BurstlyBanner *)view wasClicked:(NSDictionary *)info;

// Sent when the ad request has failed. Typically this would occur when either Burstly or
// one our 3rd party networks have no fill. Refer to NSError for more details.
// @param: view - Specifies failed banner view.
// @param: info - Dictionary error for key BurstlyInfoError. @see BurstlyInfoError
- (void)burstlyBanner:(BurstlyBanner *)view didFail:(NSDictionary *)info;

// Returns whether full screen ad should autorotate to specified user interface orientation.
// @param: view - Specifies banner view which is about to rotate full screen UI.
// @param: orientation - User interface orientation.
// @param: info - Specifies additional info. currently not used.
// @returns YES if full screen ad should autorotate to specified user interface orientation; otherwise returns NO.
- (BOOL)burstlyBanner:(BurstlyBanner *)view shouldAutorotateInterstitialAdToInterfaceOrientation: (UIInterfaceOrientation)orientation withInfo: (NSDictionary *)info;

// Returns application's current interface orientation.  
// @param: view - Specifies banner view which requests for current interface orientation.
// @param: info - Specifies additional info. currently not used.
// @returns Current interface orientation.
- (UIInterfaceOrientation)burstlyBannerRequiresCurrentInterfaceOrientation: (BurstlyBanner *)view withInfo: (NSDictionary *)info;


@end

@interface BurstlyBanner : UIView
{
    NSString *_appId;
    NSString *_zoneId;
    BurstlyAdRequest *_adRequest;
    UIViewController *_rootViewController;
    BOOL _adPaused;
    id<BurstlyBannerDelegate> _delegate;
    BurstlyAnchor _anchor;
    CGFloat _defaultRefreshInterval;
}

#pragma mark - Properties

// The width and height of the banner ad that was last loaded.
@property CGSize adSize;

// Set to YES to stop banner refresh.
// Set to NO to resume banner refresh.
@property (nonatomic, assign) BOOL adPaused;

// Required value created via the Burstly web interface. Create
// a new appId for every application produced by your organization.
// Unless your application is universal, you should create a new
// app id for iPhone/iPad SKUs.
// Sample app id: 5fWofmS3902gWbwSZhXa1w
@property (nonatomic, retain) NSString *appId;

// Required value created via the Burstly web interface for every
// unique placement of an ad in your application.
@property (nonatomic, retain) NSString *zoneId;

// The anchor tag specifies the region on the frame from where the banner ad fills out.
// Specifying the anchor ensures that the ads of varying sizes (in pixels) are held in place
// with respect to their superview.
@property (nonatomic, assign) BurstlyAnchor anchor;

// Specifies the view controller to modally present the ad when a user clicks on the banners.
// Set the rootViewController to the most valid topmost view controller. You will recieve a
// callback (burstlyBanner:willTakeOverFullScreen:) via the BurstlyBannerDelegate when the
// banner is clicked and prior to rolling out the modal view controller.
@property (nonatomic, assign) IBOutlet UIViewController *rootViewController;

// Delegate object that receives state change notifications when conforming to the
// BurstyBannerViewDelegate protocol. Remember to explicitly set the delegate to nil
// when you release the delegate object.
@property (nonatomic, assign) IBOutlet id<BurstlyBannerDelegate> delegate;

// Specifies the interval between banner ad refreshes. Burstly handles
// the ad refreshes after the first call to showAd. This value can be
// overridden via the web interface.
@property (nonatomic, assign) CGFloat defaultRefreshInterval;

@property (nonatomic, retain) BurstlyAdRequest *adRequest;

/**
* Returns whether cached ad is expired to be presented.
* Returns NO if there is no cached ad.
*/
@property (nonatomic, readonly) BOOL isCachedAdExpired;

#pragma mark - Sizes

// iPhone and iPod Touch ad size.
#define BBANNER_SIZE_320x50     CGSizeMake(320, 50)

// Medium Rectangle size for the iPhone/iPad
#define BBANNER_SIZE_300x250    CGSizeMake(300, 250)

#define BBANNER_SIZE_468x60    CGSizeMake(468, 60)

#define BBANNER_SIZE_480x32    CGSizeMake(480, 32)

// Leaderboard size for the iPad.
#define BBANNER_SIZE_728x90     CGSizeMake(728, 90)

#define BBANNER_SIZE_768x66    CGSizeMake(768, 66)

// Skyscraper size for the iPad.
#define BBANNER_SIZE_120x600    CGSizeMake(120, 600)

#define BBANNER_SIZE_1024x66    CGSizeMake(1024, 66)

#pragma mark - Initialization

// Initialize a new object for any zone id provided to you.
- (id)initWithAppId:(NSString *)anAppId zoneId:(NSString *)aZoneId frame:(CGRect)aFrame anchor:(BurstlyAnchor)anAnchor rootViewController:(UIViewController *)aRootViewController delegate:(id<BurstlyBannerDelegate>)aDelegate;

// NOT FOR PRODUCTION USE. Init with integration mode and a specific test network.
- (id)initWithIntegrationModeTestNetwork:(BurstlyTestAdNetwork)aTestNetwork filterAdvertisingIdentifiers:(NSArray *)advertisingIdentifiers frame:(CGRect)aFrame anchor:(BurstlyAnchor)anAnchor rootViewController:(UIViewController *)aRootViewController delegate:(id<BurstlyBannerDelegate>)aDelegate;

#pragma mark - Showing

// Loads an ad and accepts an optional request parameter that can be set to nil.
- (void)showAd;

// Cache an ad. Should be mapped to every request that loads the banner.
// This method is typically invoked several seconds ahead of showAd.
- (void)cacheAd;

/**
*
* Initializes specified ad network.  This step is only required by certain ad networks.
*
* @param networkName Name of ad network to be initialized.
* @param params Ad network parameters.
*/
- (void)performAdNetworkInitialization: (NSString *)networkName withParams: (NSDictionary *)params;

@end
