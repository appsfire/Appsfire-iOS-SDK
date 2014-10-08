/*!
 *  @header    AFMedInterstitialCustomEvent.h
 *  @abstract  Appsfire Mediation interstitial custom event protocol.
 *  @version   2.5.0
 */

#import <Foundation/NSObject.h>
#import <UIKit/UIViewController.h>
#import "AFMedInterstitialCustomEventDelegate.h"

/*!
 * The Appsfire iOS SDK mediates third party Ad Networks using custom events. The custom events are
 * responsible for instantiating and manipulating objects in the third party SDK and translating
 * and communicating events from those objects back to the Appsfire SDK by notifying a delegate.
 *
 * By implementing this protocol on your custom event class you can enable the Appsfire SDK to
 * natively support a wide variety of third-party ad networks.
 *
 * At runtime, the Appsfire SDK will find and instantiate your custom event class that implements
 * the AFMedInterstitialCustomEvent protocol and will invoke the
 * `-requestInterstitialWithCustomParameters:` method.
 */

@protocol AFMedInterstitialCustomEvent <NSObject>

/*!
 * The delegate to use in order to forward your corresponding SDK events.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, weak) id <AFMedInterstitialCustomEventDelegate> delegate;

/*!
 * This method is called when the Appsfire mediation interstitial requires a new interstitial.
 *
 * @param parameters This dictionary may contain additional information provided via the custom
 * payload entered by the publisher on the mediation dashboard. For instance it may be used to pass
 * information like ad placement ids.
 *
 * @since 2.5.0
 */
- (void)requestInterstitialWithCustomParameters:(NSDictionary *)parameters;

/*!
 * This method is called when an interstitial need to be presented to the user.
 *
 * @param viewController The UIViewController instance which should be used to present your SDK's
 * interstitial.
 *
 * @since 2.5.0
 */
- (void)presentInterstitialFromViewController:(UIViewController *)viewController;

@optional

/*!
 * Delegate asking if manuel tracking should be used.
 *
 * @discussion For some reason you may want to enable manual tracking of events for impressions and
 * clicks.
 *
 * @warning By activating this mode, automatic tracking which is enabled by default is disabled. In
 * this case you should make sure to manually report impressions and clicks with
 * `-interstitialCustomEventTrackImpression:' and `-interstitialCustomEventTrackClick:`.
 *
 * @return A boolean value indicating whether manual event tracking should be used.
 *
 * @since 2.5.0
 */
- (BOOL)shouldManuallyTrackEvents;

@end
