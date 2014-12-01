/*!
 *  @header    AFMedBannerViewCustomEvent.h
 *  @abstract  Appsfire Mediation banner view custom event protocol.
 *  @version   2.5.1
 */

#import <Foundation/NSObject.h>
#import "AFMedBannerViewCustomEventDelegate.h"

/*!
 * The Appsfire iOS SDK mediates third party Ad Networks using custom events. The custom events are
 * responsible for instantiating and manipulating objects in the third party SDK and translating
 * and communicating events from those objects back to the Appsfire SDK by notifying a delegate.
 *
 * By implementing this protocol on your custom event class you can enable the Appsfire SDK to 
 * natively support a wide variety of third-party ad networks.
 *
 * At runtime, the Appsfire SDK will find and instantiate your custom event class that implements 
 * the AFMedBannerViewCustomEvent protocol will invoke the
 * `-requestBannerViewWithSize:customEventParameters:` method.
 */

@protocol AFMedBannerViewCustomEvent <NSObject>

/*!
 * The delegate to use in order to forward your corresponding SDK events.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, weak) id <AFMedBannerViewCustomEventDelegate> delegate;

/*!
 * Delegate method called when the Appsfire mediation banner requires a new banner view.
 *
 * @param size The size of the placement in the publishers app. Your implementation must make sure
 * that the size of your banner does not exceed the publishers provided size. If it does not fit
 * you should call the delegate's `-bannerViewCustomEvent:didFailToLoadAdWithError:` method with an
 * error.
 *
 * @param parameters This dictionary may contain additional information provided via the custom
 * payload entered by the publisher on the mediation dashboard. For instance it may be used to pass
 * information like ad placement ids, size of the banner or any other variable useful to you.
 *
 * @warning You will need to disable automatic ad refreshing on your banner if this one allows you
 * to do it.
 *
 * @since 2.5.0
 */
- (void)requestBannerViewWithSize:(CGSize)size customEventParameters:(NSDictionary *)parameters;

@optional

/*!
 * This method is called when the device changed of orientation and the banner should be rotated.
 *
 * @discussion When calling `-rotateToInterfaceOrientation:` on an instance of AFMedBannerView the
 * call will be forwarded to this method. You can implement this method for third-party ad networks 
 * that have special behavior when orientation changes happen (like iAd).
 *
 * @param interfaceOrientation The new interface orientation.
 *
 * @since 2.5.0
 */
- (void)rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

/*!
 * Delegate asking if manuel tracking should be used.
 *
 * @discussion For some reason you may want to enable manual tracking of events for impressions and 
 * clicks.
 *
 * @warning By activating this mode, automatic tracking which is enabled by default is disabled. In 
 * this case you should make sure to manually report impressions and clicks with 
 * `-bannerViewCustomEventTrackImpression:' and `-bannerViewCustomEventTrackClick:`.
 *
 * @return A boolean value indicating whether manual event tracking should be used.
 *
 * @since 2.5.0
 */
- (BOOL)shouldManuallyTrackEvents;

/*!
 * This delegate method is called when the current banner should be invalidated.
 *
 * @discussion This method is called when the mediation is about to try to pop a new network from
 * the waterfall after the refresh period. This should only be used for ad networks that do not
 * support having several instances of banners (like iAd).
 *
 * @warning This is only for complicated banner implementation and most of the time you don't need 
 * to use it.
 *
 * @since 2.5.0
 */
- (void)invalidate;

@end
