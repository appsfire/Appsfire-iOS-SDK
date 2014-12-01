/*!
 *  @header    AFMedBannerViewCustomEventDelegate.h
 *  @abstract  Appsfire Mediation banner view custom event delegate.
 *  @version   2.5.1
 */

#import <Foundation/NSObject.h>
#import <UIKit/UIViewController.h>
#import "AFMedInfo.h"

@protocol AFMedBannerViewCustomEvent;

/*!
 * Your custom event class which implements the AFMedBannerViewCustomEvent protocol has a 
 * AFMedBannerViewCustomEventDelegate delegate which needs to be used to forward your SDK delegate
 * events to the Appsfire SDK.
 *
 * When mediating a third party ad network it is important to call as many of these methods as 
 * accurately as possible. Not all ad networks support all these events, and some support different 
 * events. It is your responsibility to find an appropriate mapping between the ad network's events
 * and the callbacks defined on AFMedBannerViewCustomEventDelegate.
 */

@protocol AFMedBannerViewCustomEventDelegate <NSObject>

/*!
 * This method must be called after the third party network received an ad.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self` 
 * for the event to be associated with the correct instance of your custom event.
 *
 * @param ad A UIView which represents the banner view that has been loaded. This object must be a 
 * subclass of UIView in order to be able to be added in the view hierarchy. This ad object will be
 * accessible via the `hostedBannerView` property of the AFMedBannerView instance.
 *
 * @note This will allow the Appsfire SDK to automatically track an impression unless if manual
 * tracking is used.
 *
 * @since 2.5.0
 */
- (void)bannerViewCustomEvent:(id <AFMedBannerViewCustomEvent>)customEvent didLoadAd:(id)ad;

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
- (void)bannerViewCustomEvent:(id <AFMedBannerViewCustomEvent>)customEvent didFailToLoadAdWithError:(NSError *)error;

@optional

/*!
 * Calling this method will return the view controller that should be used to present the eventual 
 * modal views.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @return The UIViewController instance provided when implementing the 
 * `-viewControllerForBannerView:` method of the AFMedBannerViewDelegate delegate.
 *
 * @note It it usually not necessary to use this method but some third-party Ad Networks need to
 * have access to the view controller used to present eventual modals.
 *
 * @since 2.5.0
 */
- (UIViewController *)viewControllerForBannerViewCustomEvent:(id <AFMedBannerViewCustomEvent>)customEvent;

/*!
 * Optional method which should be called when a tap has been detected on the banner and which
 * triggered the presentation of an overlay like a modal view.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @note Calling this method will cause the Appsfire SDK to record a click on the banner unless if
 * manual tracking is used (via `-shouldManuallyTrackEvents:`).
 *
 * @warning If you call this method, make sure to also call
 * `-bannerViewCustomEventEndOverlayPresentation:` when dismissing the overlay.
 *
 * @since 2.5.0
 */
- (void)bannerViewCustomEventBeginOverlayPresentation:(id <AFMedBannerViewCustomEvent>)customEvent;

/*!
 * Optional method which should be called when the overlay presented has been removed.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @note Calling this method will cause the Appsfire SDK to record a click on the banner unless if
 * manual tracking is used (via `-shouldManuallyTrackEvents:`).
 *
 * @warning You should only call this method if you have previously called it's counterpart `-bannerViewCustomEventBeginOverlayPresentation:`
 *
 * @since 2.5.0
 */
- (void)bannerViewCustomEventEndOverlayPresentation:(id <AFMedBannerViewCustomEvent>)customEvent;

/**
 * This method must be called when the banner ad will cause the user to leave the application.
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
- (void)bannerViewCustomEventWillLeaveApplication:(id <AFMedBannerViewCustomEvent>)customEvent;

/*!
 * Call this method when an impression needs to be tracked.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @warning Calling this method requires that you implemented manual event tracking, see
 * '-shouldManuallyTrackEvents' of AFMedBannerViewCustomEvent. Without this events will not be 
 * manually tracked.
 *
 * @since 2.5.0
 */
- (void)bannerViewCustomEventTrackImpression:(id <AFMedBannerViewCustomEvent>)customEvent;

/*!
 * Call this method when a "click" needs to be tracked.
 *
 * @param customEvent The custom event which originated this event. You should usually pass `self`
 * for the event to be associated with the correct instance of your custom event.
 *
 * @warning Calling this method requires that you implemented manual event tracking, see
 * '-shouldManuallyTrackEvents' of AFMedBannerViewCustomEvent. Without this events will not be 
 * manually tracked.
 *
 * @since 2.5.0
 */
- (void)bannerViewCustomEventTrackClick:(id <AFMedBannerViewCustomEvent>)customEvent;

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
- (AFMedInfo *)bannerViewCustomEventInformation:(id <AFMedBannerViewCustomEvent>)customEvent;

@end
