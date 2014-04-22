/*!
 *  @header    AFAdSDKBrichterSanControl.h
 *  @abstract  Brichter-San Control Header file.
 *  @version   2.3.0
 */

#import <UIKit/UIKit.h>

// Views
#import "AFAdSDKSashimiMinimalView.h"

/*!
 * Enum defining the different possible states of the control.
 *
 * @since 2.3.0
 */
typedef NS_ENUM(NSUInteger, AFAdSDKBSControlState) {
    /*!
     * Undefined state of the Brichter-San control.
     *
     * @since 2.3.0
     */
    AFAdSDKBSControlStateNone = 0,
    
    /*!
     * The Brichter-San control is currently refreshing and the process is not over.
     *
     * @since 2.3.0
     */
    AFAdSDKBSControlStateRefreshing,
    
    /*!
     * The Brichter-San control finished refreshing and is showing and advertisement.
     *
     * @since 2.3.0
     */
    AFAdSDKBSControlStateRefreshed
};

/*!
 * Enum defining the different possible coloring styles of the control.
 *
 * @since 2.3.0
 */
typedef NS_ENUM(NSUInteger, AFAdSDKBSControlStyle) {
    /*!
     * Light style of the Brichter-San control.
     *
     * @since 2.3.0
     */
    
    AFAdSDKBSControlStyleLight = 0,
    /*!
     * Dark style of the Brichter-San control.
     *
     * @since 2.3.0
     */
    AFAdSDKBSControlStyleDark
};

@protocol AFAdSDKBrichterSanControlDelegate;

/*!
 * `AFAdSDKBrichterSanControl` is an API compatible replacement of `UIRefreshControl` for iOS 5.0+
 * which uses the Appsfire Sashimi format to display advertisement in the refresh control view on
 * top of a `UIScrollView` (can be a `UITableView` for instance).
 */
@interface AFAdSDKBrichterSanControl : UIControl


/*!
 * The object that acts as the delegate of the receiving Brichter-San control.
 *
 * @since 2.3.0
 */
@property (nonatomic, weak, readwrite) id <AFAdSDKBrichterSanControlDelegate> delegate;

/*!
 * The UIScroll view subclass used to trigger the Brichter-San control.
 *
 * @since 2.3.0
 */
@property (nonatomic, assign, readwrite) UIScrollView *scrollView;

/*!
 * The tint color for the refresh control.
 *
 * @discussion The default value of this property is nil.
 * @since 2.3.0
 */
@property (nonatomic, strong, readwrite) UIColor *color;

/*!
 * An Enum value reflecting the internal state of the Brichter-San control.
 *
 * @see `AFAdSDKBSControlState`
 * @since 2.3.0
 */
@property (nonatomic, assign, readonly) AFAdSDKBSControlState controlState;

/*!
 * An Enum value to set the coloring style of the control.
 *
 * @see `AFAdSDKBSControlStyle`
 * @since 2.3.0
 */
@property (nonatomic, assign, readwrite) AFAdSDKBSControlStyle style;

/*!
 * Default top content inset.
 *
 * @note    If the you set a top `contentInset` of your `UIScrollView` you might want to set the 
 *          same value to `defaultTopContentInset`.
 *
 * @since 2.3.0
 */
@property (nonatomic, assign, readwrite) CGFloat defaultTopContentInset;

/*!
 * Default top content offset.
 *
 * @note    Useful on iOS 7.0+ when the `UIScrollView` is embedded in a view controller when the extended
 *          edges value `edgesForExtendedLayout` is equal to `UIRectEdgeTop` or `UIRectEdgeAll`. In
 *          this case the top `contentOffset` is equal to topLayoutGuide.length (64pt in portrait).
 *          The following code sample allows you to adjust the top content offset with rotation support:
 *          
 *          // In your view controller subclass.
 *          - (void)viewDidLayoutSubviews {
 *              [super viewDidLayoutSubviews];
 *
 *              // Brichter-San adjustment.
 *              if ([self respondsToSelector:@selector(topLayoutGuide)]) {
 *                  CGFloat topOffset = self.topLayoutGuide.length;
 *                  _brichterSanControl.defaultTopContentOffset = topOffset;
 *              }
 *          }
 *
 * @since 2.3.0
 */
@property (nonatomic, assign, readwrite) CGFloat defaultTopContentOffset;

/*!
 * A Boolean value indicating whether the Brichter-San control should show ads.
 *
 * @since 2.3.0
 */
@property (nonatomic, assign, readwrite, getter = isShowingAds) BOOL showAds;

/*!
 * Initializes and returns a standard Brichter-San control.
 *
 * @param scrollView The `UIScrollView` used to trigger the Brichter-San control.
 * @since 2.3.0
 */
- (id)initWithScrollView:(UIScrollView *)scrollView;

/*!
 * Tells the control that a refresh operation was started programmatically.
 *
 * @note    Call this method when an external event source triggers a programmatic refresh of your
 *          table. For example, if you use an NSTimer object to refresh the contents of the table
 *          view periodically, you would call this method as part of your timer handler. This method
 *          updates the state of the Brichter-San control to reflect the in-progress refresh
 *          operation. When the refresh operation ends, be sure to call the endRefreshing method to
 *          return the control to its default state.
 *
 *
 * @since 2.3.0
 */
- (void)beginRefreshing;

/*!
 * Tells the control that a refresh operation has ended.
 *
 * @note    Call this method at the end of any refresh operation (whether it was initiated
 *          programmatically or by the user) to return the Brichter-San control to its default state.
 *          If the Brichter-San control is at least partially visible, calling this method also hides
 *          it. If animations are also enabled, the control is hidden using an animation.
 *
 * @since 2.3.0
 */
- (void)endRefreshing;

/*!
 * Tells the control to programmatically dismiss when it's showing an ad.
 *
 * @note This method is only applied when the control's state is `AFAdSDKBSControlStateRefreshed`.
 *
 * @since 2.3.0
 */
- (void)dismissAd;

@end

/*!
 *  Brichter-San protocol.
 */
@protocol AFAdSDKBrichterSanControlDelegate <NSObject>

@optional

/**
 *  Allows the customization of the `AFAdSDKSashimiMinimalView` instance displayed in the Brichter-San 
 *  control when available.
 *
 *  @param brichterSanControl   The `AFAdSDKBrichterSanControl` instance requesting for customization
 *                              of the `AFAdSDKSashimiMinimalView` instance displayed in the 
 *                              Brichter-San control.
 *
 *  @param sashimiView          The the `AFAdSDKSashimiMinimalView` instance being customized.
 *  @since 2.3.0
 */
- (void)brichterSanControl:(AFAdSDKBrichterSanControl *)brichterSanControl customizeSashimiView:(AFAdSDKSashimiMinimalView *)sashimiView;

@end

