/*!
 *  @header    AFAdSDKSashimiView.h
 *  @abstract  Appsfire Advertising SDK Sashimi Header
 *  @version   2.6.0
 */

#import <UIKit/UIView.h>
#import "AFAdSDKAdBadgeView.h"

/*! 
 *  Information about the type of the screenshot provided by the `screenshotType` property.
 *
 *  @since 2.2.0
 */
typedef NS_ENUM(NSUInteger, AFAdSDKAppScreenshotType) {
    
    /** The screenshot type is unknown. */
    AFAdSDKAppScreenshotTypeUnknown = 0,

    /** iPhone screenshot type. */
    AFAdSDKAppScreenshotTypeiPhone,
    
    /** iPad screenshot type. */
    AFAdSDKAppScreenshotTypeiPad
    
};

/*!
 *  Information about the orientation of the screenshot provided by the `screenshotOrientation` property.
 *
 *  @since 2.2.0
 */
typedef NS_ENUM(NSUInteger, AFAdSDKAppScreenshotOrientation) {
    
    /** The orientation of the screenshot is unknown. */
    AFAdSDKAppScreenshotOrientationUnknown = 0,
    
    /** The screenshot is in Portrait orientation. */
    AFAdSDKAppScreenshotOrientationPortrait,
    
    /** The screenshot is in Landscape orientation. */
    AFAdSDKAppScreenshotOrientationLandscape
    
};

/*!
 *  Information about the kind of asset.
 *
 *  @since 2.4.0
 */
typedef NS_ENUM(NSUInteger, AFAdSDKAppAssetType) {
    
    /** The icon. */
    AFAdSDKAppAssetTypeIcon = 0,
    
    /** The screenshot. */
    AFAdSDKAppAssetTypeScreenshot
    
};

@protocol AFAdSDKSashimiViewDelegate;

/*!
 *  `AFAdSDKSashimiView` is a generic adertisement view containing all the information needed to create your own sashimi ads.
 */
@interface AFAdSDKSashimiView : UIView

/*!
 * The object that acts as the delegate of the receiving sashimi view.
 *
 * @since 2.4.0
 */
@property (nonatomic, weak) id <AFAdSDKSashimiViewDelegate> delegate;

/*! 
 *  Title of the application.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) NSString *title;

/*!
 *  Tagline of the application.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) NSString *tagline;

/*!
 *  Localized Category of the application.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) NSString *category;

/*!
 *  Localized title of the call to action view.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) NSString *callToActionTitle;

/*!
 *  Icon URL of the application.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) NSString *iconURL;

/*!
 *  Screenshot URL of the application.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) NSString *screenshotURL;

/*!
 *  Screenshot Type of the application.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) AFAdSDKAppScreenshotType screenshotType;

/*!
 *  Screenshot Orientation of the application.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) AFAdSDKAppScreenshotOrientation screenshotOrientation;

/*!
 *  Is App Free.
 *  
 *  @since 2.2.0
 */
@property (nonatomic, readonly) BOOL isFree;

/*!
 *  Localized price of the application.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) NSString *localizedPrice;

/*!
 *  The view of the appsfire badge you need to add.
 *
 *  @since 2.2.0
 */
@property (nonatomic, readonly) AFAdSDKAdBadgeView *viewAppsfireBadge;

/*!
 *  @brief Called after the view is initialized.
 *
 *  @note You should implement any initialization or user interface thing here.
 *  @note The method will be called before any draw or layout method. At this point, all properties are set and accessible.
 *
 *  @since 2.2.0
 */
- (void)sashimiIsReadyForInitialization;

/*!
 *  @brief Called when one or more properties were updated while the view was already created since some time.
 *
 *  @note For example, it is possible since sdk 2.4 that the call to action changes over time.
 *
 *  @since 2.4.0
 */
- (void)sashimiDidUpdateProperties;

/*!
 *  @brief Download an asset asynchronously.
 *
 *  @since 2.4.0
 *
 *  @param asset The asset you would like to download. The ENUM `AFAdSDKAppAssetTypeIcon` refers to the property `iconURL`, and `AFAdSDKAppAssetTypeScreenshot` to `screenshotURL`.
 *  @param completion The completion block for the callback once the asset is downloaded. If a problem occured, the `image` variable will be `nil`. Note: the block is called on the main thread.
 */
- (void)downloadAsset:(AFAdSDKAppAssetType)asset completion:(void (^)(UIImage *image))completion;

@end

/*!
 * `AFAdSDKSashimiViewDelegate` provides additional information on actions performed on the sashimi
 * view.
 *
 * @since 2.4.0
 */
@protocol AFAdSDKSashimiViewDelegate <NSObject>

@optional

/*!
 * This delegate event informs you that an overlay will be added on top of the current view 
 * controller. You will not be able to interact with your interface until the end of the 
 * presentation and you may want to pause certain actions at this moment.
 *
 * @param sashimiView the sashimi at the origin of this delegate event.
 *
 * @since 2.4.0
 */
- (void)sashimiViewBeginOverlayPresentation:(AFAdSDKSashimiView *)sashimiView;

/*!
 * This delegate event informs you that the overlay that was presented has been removed and you will
 * be able to re-interact with your interface. You may want to resume any action you paused during
 * the process.
 *
 * @param sashimiView the sashimi at the origin of this delegate event.
 *
 * @since 2.4.0
 */
- (void)sashimiViewEndOverlayPresentation:(AFAdSDKSashimiView *)sashimiView;

/*!
 * This delegate event informs you that the Appsfire SDK has recorded a click on the sashimi view.
 *
 * @param sashimiView the sashimi at the origin of this delegate event.
 *
 * @since 2.4.0
 */
- (void)sashimiViewDidRecordClick:(AFAdSDKSashimiView *)sashimiView;

/*!
 * This method should return the UIViewController used to host the StoreKit view controller. If not
 * implemented, the StoreKit is not used and the user will be redirected to the App Store to
 * download the app.
 *
 * @param sashimiView The AFAdSDKSashimiView instance requesting for the host UIViewController to contain the StoreKit.
 *
 * @return a UIViewController that will host the StoreKit.
 *
 * @since 2.6.0
 */
- (UIViewController *)viewControllerForSashimiView:(AFAdSDKSashimiView *)sashimiView;

@end
