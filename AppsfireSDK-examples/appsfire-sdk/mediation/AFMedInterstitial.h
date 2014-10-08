/*!
 *  @header    AFMedInterstitial.h
 *  @abstract  Appsfire Mediation interstitial controller.
 *  @version   2.5.0
 */

#import <UIKit/UIViewController.h>
#import "AFMedInfo.h"

@protocol AFMedInterstitialDelegate;

@interface AFMedInterstitial : NSObject

/*!
 * The Appsfire ad placement id for this interstitial ad.
 *
 * Required value created on the Appsfire Dashboard. Create a new ad placement id for every unique
 * placement of an ad in your application.
 * 
 * @since 2.5.0
 */
@property (readonly, nonatomic, copy) NSString *adPlacementId;

/*!
 * Indicator when there is an ad and it's ready to be displayed.
 *
 * @since 2.5.0
 */
@property (readonly, nonatomic, assign, getter = isReady) BOOL ready;

/*!
 * Interval in second to discard a network when this one is taking too much time to respond. When
 * the timeout is fired, the next network in the list is tested.
 *
 * @note Default value is 30 seconds.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, assign) NSTimeInterval timeout;

/*!
 * Delegate object to be set to receive events on presentation and expiration of interstitials.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, weak) id <AFMedInterstitialDelegate> delegate;

/*!
 * Allows you to activate logs in order to see which network is selected and why.
 *
 * @note Default value is `NO`.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, assign) BOOL logsEnabled;

/*!
 * Allows you to pass information on your end users to the custom event adapters.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, strong) AFMedInfo *information;

/*!
 * Initialization method which return an AFMedInterstitial object with the corresponding ad 
 * placement id.
 *
 * @param adPlacementId The string corresponding the to ad placement id given by Appsfire.
 *
 * @return An initialized AFMedInterstitial object.
 *
 * @since 2.5.0
 */
- (instancetype)initWithAdPlacementId:(NSString *)adPlacementId;

/*!
 * Start loading an interstitial ad.
 *
 * @note Make sure to implement the delegate to be notified of ad loading or errors during the
 * retrieval.
 *
 * @since 2.5.0
 */
- (void)loadAd;

/*!
 * Presents the interstitial and uses the view controller returnded by the delegate in 
 * `-viewControllerForInterstitial:`.
 *
 * @note Before trying to present an interstitial you should check if the ad is loaded via the 
 * isLoaded property.
 *
 * @since 2.5.0
 */
- (void)presentInterstitial;

@end

@protocol AFMedInterstitialDelegate <NSObject>

/*!
 * This method should return the UIViewController used to present the interstitial and other modal
 * view controllers triggered by the interstitial (like a StoreKit or an in-app browser view
 * controllers).
 *
 * @param interstitial The AFMedInterstitial instance requesting for the UIViewController.
 *
 * @return a UIViewController used to present modal content.
 *
 * @since 2.5.0
 */
- (UIViewController *)viewControllerForInterstitial:(AFMedInterstitial *)interstitial;

@optional

/*!
 * This delegate event informs you that an ad is ready to be displayed. You may want to show it with
 * the `-presentInterstitialFromViewController:` method.
 *
 * @param interstitial The interstitial object originating the call.
 *
 * @since 2.5.0
 */
- (void)interstitialDidLoadAd:(AFMedInterstitial *)interstitial;

/*!
 * This delegate event informs you that the interstitial instance failed to load an ad. You may want
 * to check the content of the error to know exactely why.
 *
 * @param interstitial The interstitial object originating the call.
 * @param error An error indicating why the ad loading failed.
 *
 * @since 2.5.0
 */
- (void)interstitialDidFailToLoadAd:(AFMedInterstitial *)interstitial withError:(NSError *)error;

/*!
 * This delegate event infroms you when the interstitial is about to be presented.
 *
 * @param interstitial The interstitial object originating the call.
 *
 * @since 2.5.0
 */
- (void)interstitialWillAppear:(AFMedInterstitial *)interstitial;

/*!
 * This delegate event infroms you when the interstitial is presented.
 *
 * @param interstitial The interstitial object originating the call.
 *
 * @since 2.5.0
 */
- (void)interstitialDidAppear:(AFMedInterstitial *)interstitial;

/*!
 * This delegate event infroms you when the interstitial is about to be dismissed.
 *
 * @param interstitial The interstitial object originating the call.
 *
 * @since 2.5.0
 */
- (void)interstitialWillDisappear:(AFMedInterstitial *)interstitial;

/*!
 * This delegate event infroms you when the interstitial is dismissed.
 *
 * @param interstitial The interstitial object originating the call.
 *
 * @since 2.5.0
 */
- (void)interstitialDidDisappear:(AFMedInterstitial *)interstitial;

/*!
 * This delegate event infroms you when the interstitial is about to expire and.
 *
 * @note Upong reception of this event you should instantiate a new interstitial object and load a
 * new ad.
 *
 * @param interstitial The interstitial object originating the call.
 *
 * @since 2.5.0
 */
- (void)interstitialDidExpire:(AFMedInterstitial *)interstitial;

@end
