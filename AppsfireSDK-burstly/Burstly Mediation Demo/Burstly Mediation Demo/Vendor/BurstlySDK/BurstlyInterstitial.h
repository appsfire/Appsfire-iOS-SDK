//
// BurstlyInterstitial.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BurstlyAdRequest.h"
#import "BurstlyInterstitialDecorator.h"

#pragma mark Delegate

@class BurstlyInterstitial;

@protocol BurstlyInterstitialDelegate <NSObject>

@required

- (UIViewController *)viewControllerForModalPresentation:(BurstlyInterstitial *)interstitial;	/* Required, this must be your top most view controller */

@optional

// Sent when a modal view controller takes over the screen when showAd: is invoked. Use this callback
//  as an oppurtunity to implement state specific details such as pausing animation, timers, etc. The
// exact timing of this callback is not guaranteed as a few ad networks roll out the canvas
// prior to sending a callback whereas some others do the opposite. The following ad networks
// notify us prior to rolling out the canvas.
// Admob, Greystripe, Inmobi
// @param: ad - Specifies interstitial ad which is going to present full screen.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyInterstitial:(BurstlyInterstitial *)ad willTakeOverFullScreen:(NSDictionary *)info;

// Sent when the modal view controller is dismissed. This is a good time to cache an
// ad for the next attempt to display an interstitial. eg: between game levels.
// @param: ad - Specifies interstitial ad which dismissed full screen.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyInterstitial:(BurstlyInterstitial *)ad willDismissFullScreen:(NSDictionary *)info;

// Sent when an interstitial ad request succeeded. This callback will always be followed by
// burstlyInterstitial:willTakeOverFullScreen:.
// @param: ad - Specifies loaded interstitial ad.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyInterstitial:(BurstlyInterstitial *)ad didLoad:(NSDictionary *)info;

// Sent when an ad is successfully cached. The ad is now ready to be displayed.
// Follow up with a call to showAd. @param: adNetwork specifies the mediated network
// that was cached.
// Discussion: Following a request to cache an ad, the adServer responds with a
// list of networks to mediate from. The list is auto-enumerated and the SDK traverses
// the list until an ad network succeeds. Note that while it is highly recommended
// that you cache an ad prior to displaying it, you could invoke showAd: directly
// and the auto-enumeration process would repeat. The ad will be displayed albeit
// delayed. If you do not choose to cache the ad, you must notify your users of a
// pending ad after calling showAd. You could remove the spinner after you recieve
// burstlyInterstitial:willTakeOverFullScreen: or burstlyInterstitial:didFailWithError:
//callbacks.
// @param: ad - Specifies cached interstitial ad.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyInterstitial:(BurstlyInterstitial *)ad didCache:(NSDictionary *)info;

// Sent when interstitial ad was clicked
// @param: ad - Specifies interstitial ad which was clicked.
// @param: info - Dictionary containing network name for key BurstlyInfoNetwork. @see BurstlyInfoNetwork
- (void)burstlyInterstitial:(BurstlyInterstitial *)ad wasClicked:(NSDictionary *)info;

// Sent when the ad request has failed. Typically this would occur when either Burstly or
// one our 3rd party networks have no fill. Refer to NSError for more details.
// You could send a request to cache an ad for your next attempt.
// @param: ad - Specifies failed interstitial ad.
// @param: info - Dictionary error for key BurstlyInfoError. @see BurstlyInfoError
- (void)burstlyInterstitial:(BurstlyInterstitial *)ad didFail:(NSDictionary *)info;

// Returns whether full screen ad should autorotate to specified user interface orientation.
// This callback will only be called for Burstly network ads.
// @param: ad - Specifies interstitial ad which is about to rotate full screen UI.
// @param: orientation - User interface orientation.
// @param: info - Specifies additional info. currently not used.
// @returns YES if full screen ad should autorotate to specified user interface orientation; otherwise returns NO.
- (BOOL)burstlyInterstitial:(BurstlyInterstitial *)ad shouldAutorotateInterstitialAdToInterfaceOrientation: (UIInterfaceOrientation)orientation withInfo: (NSDictionary *)info;

// Returns application's current interface orientation.  This callback will only be called for Burstly network ads.
// @param: ad - Specifies interstitial ad which requests for current interface orientation.
// @param: info - Specifies additional info. currently not used.
// @returns Current interface orientation.
- (UIInterfaceOrientation)burstlyInterstitialRequiresCurrentInterfaceOrientation: (BurstlyInterstitial *)ad withInfo: (NSDictionary *)info;


@end

@class OAIAdManager;

// Use BurstlyInterstitialState to poll the current state of burstly interstitals.
typedef enum {
    
    /** The default state for interstitials. Returns to
     * this state if an ad fails to load or when the modal
     * takeover ends.
     **/
    BurstlyInterstitialStateStandBy,
    /**
     *  Indicates that a cache request is pending.
     **/
    BurstlyInterstitialStateCaching,
    /**
     *  Cache request succeeded. The interstitial is now
     *  ready to be displayed
     **/
    BurstlyInterstitialStateCached,
    /**
     *  The interstitial is loading state.
     *  This would be a good time to handle UI elements such
     *  as a spinner view to notify users that an ad is about
     *  to load
     **/
    BurstlyInterstitialStateLoading,
    /**
     *  The ad is visible on screen. You should
     *  remove any UI elements introduced while
     *  loading the ad. Any game activity should be paused
     *  during this state.
     **/
    BurstlyInterstitialStateVisible
} BurstlyInterstitialState;

@interface BurstlyInterstitial : NSObject
{
    OAIAdManager *_adManager;
    BurstlyInterstitialState _state;
    BOOL _useAutomaticCaching;
    NSString *_appId;
    NSString *_zoneId;
    BurstlyAdRequest *_adRequest;
    id<BurstlyInterstitialDelegate> _delegate;
    NSTimeInterval _requestTimeout;
}

#pragma mark - Properties

/** Required value created via the Burstly web interface. Create
 *   a new appId for every application produced by your organization.
 *   Unless your application is universal, you should create a new
 *   app id for iPhone/iPad SKUs.
 *   Sample app id: 5fWofmS3902gWbwSZhXa1w
 **/
@property (nonatomic, retain) NSString *appId;

/** Required value created via the Burstly web interface for every
 *   unique placement of an ad in your application.
 **/
@property (nonatomic, retain) NSString *zoneId;

/** Delegate object that receives state change notifications when
 *  conforming to the BurstlyInterstitialDelegate protocol.
 *  Remember to explicitly set the delegate to nil when you
 *  release the delegate object.
 **/
@property (nonatomic, assign) id<BurstlyInterstitialDelegate> delegate;

/** This property can be used to poll the current state
 *  of the interstitial ad. Refer to the BurstlyInterstitialState
 *  enum constants for more info.
 **/
@property (nonatomic, readonly) BurstlyInterstitialState state;

/** Specifies the maximum timeout interval that the
 *  application is willing to wait before it has to continue
 *  with in-game activity. When the timeout fires, the Burstly
 *  SDK cancels pending requests in the queue. However, the current
 *  request in the queue may not be cancelled - Ideally you would
 *  specify a value lower that your application's internal timer
 *  to remove UI elements such as a spinner view prior to displaying
 *  an interstitial.
 **/
@property (nonatomic, assign) NSTimeInterval requestTimeout;


@property (nonatomic, retain) BurstlyAdRequest *adRequest;

/** Set to YES to enable automatic caching.
 * If enabled, this interstitial will automatically begin
 * caching before showAdWithRootViewController is called.
 * This is meant to reduce the delay in displaying an interstitial.
 **/
@property (nonatomic, assign) BOOL useAutomaticCaching;

/**
* Returns whether cached ad is expired to be presented.
* Returns NO if there is no cached ad.
*/
@property (nonatomic, readonly) BOOL isCachedAdExpired;


#pragma mark - Initialization

- (id)initAppId:(NSString *)anAppId zoneId:(NSString *)aZoneId delegate:(id<BurstlyInterstitialDelegate>)aDelegate;
- (id)initAppId:(NSString *)anAppId zoneId:(NSString *)aZoneId delegate:(id<BurstlyInterstitialDelegate>)aDelegate useAutomaticCaching:(BOOL)automaticCaching;

// NOT FOR PRODUCTION USE. Init with integration mode and a specific test network.
- (id)initWithIntegrationModeTestNetwork:(BurstlyTestAdNetwork)aTestNetwork filterAdvertisingIdentifiers:(NSArray *)advertisingIdentifiers delegate:(id<BurstlyInterstitialDelegate>)aDelegate;

#pragma mark - Showing

/** Call to display an interstitial. Should be used in conjunction
 *  with cacheAd. 
 **/
- (void)showAd;

/** Call to cache an interstitial. Must be mapped to a corresponding
 *  request to display an ad. Ideally, this call should be made several
 *  seconds before invoking showAdWithRootViewController. You could also
 *  cache a subsequent ad from the burstlyInterstitial:willDismissFullScreen:
 *  callback.
 **/
- (void)cacheAd;

/**
* Initializes specified ad network.
*
* @param networkName Name of ad network to be initialized.
* @param params Ad network parameters.
*/
- (void)performAdNetworkInitialization: (NSString *)networkName withParams: (NSDictionary *)params;

/**
* Registers decorator for specific interstitial type.
*
* @param decorator Interstitial decorator. @see BurstlyInterstitialDecorator.
*/
+ (void)registerDecorator: (id <BurstlyInterstitialDecorator>)decorator;

/**
* Removes previously registered interstitial decorator.
*/
+ (void)removeInterstitialDecorator;

@end
