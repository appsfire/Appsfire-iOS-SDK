/*!
 *  @header    AFMedInterstitialCustomEventDelegate.h
 *  @abstract  Appsfire Mediation interstitial custom event delegate.
 *  @version   2.5.1
 */

#import <Foundation/NSObject.h>
#import "AFMedInfo.h"

@protocol AFMedInterstitialCustomEvent;

/*!
 * Your custom event class which implements the AFMedInterstitialCustomEvent protocol has a
 * AFMedInterstitialCustomEventDelegate delegate which needs to be used to forward your SDK delegate
 * events to the Appsfire SDK.
 *
 * When mediating a third party ad network it is important to call as many of these methods as
 * accurately as possible. Not all ad networks support all these events, and some support different
 * events. It is your responsibility to find an appropriate mapping between the ad network's events
 * and the callbacks defined on AFMedInterstitialCustomEventDelegate.
 */

@protocol AFMedInterstitialCustomEventDelegate <NSObject>

/*!
 * This method must be called after the third party network received an ad.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @param ad An optional object which represents the interstitial which has been loaded.
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEvent:(id <AFMedInterstitialCustomEvent>)customEvent didLoadAd:(id)ad;

/*!
 * This method must be called after the third party network failed to load an ad.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @param error An NSError describing why the ad failed to load.
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEvent:(id <AFMedInterstitialCustomEvent>)customEvent didFailToLoadAdWithError:(NSError *)error;

/*!
 * This method must be called when an interstitial is about to be presented.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @warning Your custom event subclass must call this method when it is about to present the
 * interstitial. Failure to do so will disrupt the mediation waterfall and cause future ad requests 
 * to stall. Also calling this will method will allow the Appsfire SDK to automatically track an
 * impression unless if manual tracking is used (via `-shouldManuallyTrackEvents:`).
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEventWillAppear:(id <AFMedInterstitialCustomEvent>)customEvent;

/*!
 * This method must be called when an interstitial was presented.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @warning Your custom event subclass must call this method when the interstitial was presented. 
 * Failure to do so will disrupt the mediation waterfall and cause future ad requests to stall. Also
 * calling this will method will allow the Appsfire SDK to automatically track an impression unless
 * if manual tracking is used (via `-shouldManuallyTrackEvents:`).
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEventDidAppear:(id <AFMedInterstitialCustomEvent>)customEvent;

/*!
 * This method must be called when an interstitial is about to be dismissed.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @warning Your custom event subclass must call this method when it is about to dismiss the
 * interstitial. Failure to do so will disrupt the mediation waterfall and cause future ad requests
 * to stall. Also calling this will method will allow the Appsfire SDK to automatically track an
 * impression unless if manual tracking is used (via `-shouldManuallyTrackEvents:`).
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEventWillDisappear:(id <AFMedInterstitialCustomEvent>)customEvent;

/*!
 * This method must be called when an interstitial was dismissed.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @warning Your custom event subclass must call this method when the interstitial was dismissed. 
 * Failure to do so will disrupt the mediation waterfall and cause future ad requests to stall. Also 
 * calling this will method will allow the Appsfire SDK to automatically track an impression, unless
 * if manual tracking is used (via `-shouldManuallyTrackEvents:`).
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEventDidDisappear:(id <AFMedInterstitialCustomEvent>)customEvent;

@optional

/*!
 * Calling this method will return the view controller that should be used to present the eventual
 * modal views.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @return The UIViewController instance provided when implementing the
 * `-viewControllerForInterstitial:` method of the AFMedInterstitialDelegate delegate.
 *
 * @note It it usually not necessary to use this method but some third-party Ad Networks need to
 * have access to the view controller used to present eventual modals.
 *
 * @since 2.5.0
 */
- (UIViewController *)viewControllerForinterstitialCustomEvent:(id <AFMedInterstitialCustomEvent>)customEvent;

/*!
 * This method must be called if a previously loaded interstitial should be considered as expired.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @note Some third-party ad networks will mark interstitials as expired (indicating they should not
 * be presented) after they have loaded. You may use this method to inform the Appsfire SDK that a
 * previously loaded interstitial has expired and that a new interstitial should be fetched.
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEventDidExpire:(id <AFMedInterstitialCustomEvent>)customEvent;

/*!
 * This method must be called when a tap on the interstitial has been detected.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @note This will allow the Appsfire SDK to automatically track a "click" unless if manual 
 * tracking is used.
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEventDidReceiveTapEvent:(id <AFMedInterstitialCustomEvent>)customEvent;

/**
 * This method must be called when the interstitial ad will cause the user to leave the application.
 * For instance if the user may have tapped on a link to visit the App Store or Safari.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @note This will allow the Appsfire SDK to automatically track a "click" unless if manual tracking 
 * is used.
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEventWillLeaveApplication:(id <AFMedInterstitialCustomEvent>)customEvent;

/*!
 * Call this method when a impression needs to be tracked.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @warning Calling this method requires that you implemented manual event tracking, see
 * '-shouldManuallyTrackEvents' of AFMedInterstitialCustomEvent. Without this events will not be
 * manually tracked.
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEventTrackImpression:(id <AFMedInterstitialCustomEvent>)customEvent;

/*!
 * Call this method when a "click" needs to be tracked.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @warning Calling this method requires that you implemented manual event tracking, see
 * '-shouldManuallyTrackEvents' of AFMedInterstitialCustomEvent. Without this events will not be
 * manually tracked.
 *
 * @since 2.5.0
 */
- (void)interstitialCustomEventTrackClick:(id <AFMedInterstitialCustomEvent>)customEvent;

/*!
 * Information object.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @return An instance of AFMedInfo if one has been provided otherwise `nil`.
 *
 * @since 2.5.0
 */
- (AFMedInfo *)interstitialCustomEventInformation:(id <AFMedInterstitialCustomEvent>)customEvent;

@end
