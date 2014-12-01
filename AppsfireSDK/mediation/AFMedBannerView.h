/*!
 *  @header    AFMedBannerView.h
 *  @abstract  Appsfire Mediation banner view.
 *  @version   2.5.1
 */

#import <UIKit/UIView.h>
#import <UIKit/UIApplication.h>
#import "AFMedInfo.h"

@protocol AFMedBannerViewDelegate;

@interface AFMedBannerView : UIView

/*!
 * The Appsfire ad placement id for this banner ad.
 *
 * Required value created on the Appsfire Dashboard. Create a new ad placement id for every unique
 * placement of an ad in your application.
 *
 * @since 2.5.0
 */
@property (readonly, nonatomic, copy) NSString *adPlacementId;

/*!
 * The view returned by the third party network.
 *
 * @since 2.5.0
 */
@property (readonly, nonatomic, strong) UIView *hostedBannerView;

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
 * Delegate object to be set to receive events related to the banner view.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, weak) id <AFMedBannerViewDelegate> delegate;

/*!
 * Allows you to activate logs in order to see which network is selected and why.
 *
 * @note Default value is `NO`.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, assign) BOOL logsEnabled;

/*!
 * Boolean specifying if automatic refresh should be used.
 *
 * @discussion You should set this property to NO when hidding the banner view and set it back to
 * YES when showing is again.
 *
 * @note the default value is YES.
 *
 * @see refreshInterval
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, assign, getter = isRefreshingAutomatically) BOOL refreshAutomatically;

/*!
 * Boolean informing whether an ad is currenly loaded in the banner.
 *
 * @since 2.5.0
 */
@property (readonly, nonatomic, assign, getter = isLoaded) BOOL loaded;

/*!
 * Allows you to pass information on your end users to the custom event adapters.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, strong) AFMedInfo *information;

/*!
 * Initialization method which return an AFMedBannerView view with the corresponding ad placement id.
 *
 * @param adPlacementId The string corresponding the to ad placement id given by Appsfire.
 *
 * @param size The size of the banner view.
 *
 * @return An initialized AFMedBannerView object.
 *
 * @since 2.5.0
 */
- (instancetype)initWithAdPlacementId:(NSString *)adPlacementId size:(CGSize)size;

/*!
 * Tells to the mediation banner view to start loading ads.
 *
 * @note Make sure to implement the delegate to be notified of ad loading or errors during the
 * retrieval.
 *
 * @since 2.5.0
 */
- (void)loadAd;

/*!
 * Call this method if you want to inform the hosted banner view that an interface orientation
 * occured.
 *
 * @note Some network banners (like iAd) have orientation specific layout and sizes and this
 * method allows you to pass the information to the custom adaptor.
 *
 * @param interfaceOrientation The new orientation of the interface.
 *
 * @since 2.5.0
 */
- (void)rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

@protocol AFMedBannerViewDelegate <NSObject>

/*!
 * This method should return the UIViewController used to present eventual modal view controllers
 * like a StoreKit or in-app browser view controllers.
 *
 * @param bannerView The AFMedBannerView instance requesting for the UIViewController.
 *
 * @return a UIViewController used to present modal content.
 *
 * @since 2.5.0
 */
- (UIViewController *)viewControllerForBannerView:(AFMedBannerView *)bannerView;

@optional

/*!
 * This delegate event informs you that the banner view loaded an ad. You may want to show the
 * banner view at this moment if it was previously hidden.
 *
 * @param bannerView the mediation banner view at the origin of this delegate event.
 *
 * @since 2.5.0
 */
- (void)bannerViewDidLoadAd:(AFMedBannerView *)bannerView;

/*!
 * This delegate event informs you that the banner view failed to load an ad. You may want to hide
 * the banner view at this moment if it was previously visible.
 *
 * @param bannerView the mediation banner view at the origin of this delegate event.
 * @param error An error indicating why the ad loading failed.
 *
 * @since 2.5.0
 */
- (void)bannerViewDidFailToLoadAd:(AFMedBannerView *)bannerView withError:(NSError *)error;

/*!
 * This delegate event informs you that an overlay will be added on top of the current view
 * controller. You will not be able to interact with your interface until the end of the
 * presentation and you may want to pause certain actions at this moment.
 *
 * @param bannerView the mediation banner view at the origin of this delegate event.
 *
 * @since 2.5.0
 */
- (void)bannerViewBeginOverlayPresentation:(AFMedBannerView *)bannerView;

/*!
 * This delegate event informs you that the overlay that was presented has been removed and you will
 * be able to re-interact with your interface. You may want to resume any action you paused during
 * the process.
 *
 * @param bannerView the mediation banner view at the origin of this delegate event.
 *
 * @since 2.5.0
 */
- (void)bannerViewEndOverlayPresentation:(AFMedBannerView *)bannerView;

/*!
 * This delegate event informs you that the Appsfire SDK has recorded a "click" on the banner view.
 *
 * @param bannerView the mediation banner view at the origin of this delegate event.
 *
 * @since 2.5.0
 */
- (void)bannerViewDidRecordClick:(AFMedBannerView *)bannerView;

@end
