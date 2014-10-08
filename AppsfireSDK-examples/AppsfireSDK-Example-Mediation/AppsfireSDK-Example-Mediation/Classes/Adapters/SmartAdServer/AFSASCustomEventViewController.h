/*!
 *  AFSASCustomEventViewController.h
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 *
 *  @version  1.0
 *  @abstract Compatible with the Appsfire SDK 2.5.0 and Smart AdServer SDK 4.5
 */

#import <UIKit/UIViewController.h>

@protocol AFSASCustomEventViewControllerBannerDelegate;
@protocol AFSASCustomEventViewControllerInterstitialDelegate;

@interface AFSASCustomEventViewController : UIViewController

@property (readwrite, nonatomic, weak) id <AFSASCustomEventViewControllerBannerDelegate> bannerDelegate;
@property (readwrite, nonatomic, weak) id <AFSASCustomEventViewControllerInterstitialDelegate> interstitialDelegate;

@end

@protocol AFSASCustomEventViewControllerBannerDelegate <NSObject>

- (void)customEventViewController:(AFSASCustomEventViewController *)customEventViewController didLoadAd:(id)ad;
- (void)customEventViewController:(AFSASCustomEventViewController *)customEventViewController didFailToLoadAdWithError:(NSError *)error;

- (UIViewController *)viewControllerForCustomEventViewController:(AFSASCustomEventViewController *)customEventViewController;
- (void)customEventViewControllerBeginOverlayPresentation:(AFSASCustomEventViewController *)customEventViewController;
- (void)customEventViewControllerEndOverlayPresentation:(AFSASCustomEventViewController *)customEventViewController;
- (void)customEventViewControllerWillLeaveApplication:(AFSASCustomEventViewController *)customEventViewController;

@end


@protocol AFSASCustomEventViewControllerInterstitialDelegate <NSObject>

- (void)customEventViewController:(AFSASCustomEventViewController *)customEventViewController didLoadAd:(id)ad;
- (void)customEventViewController:(AFSASCustomEventViewController *)customEventViewController didFailToLoadAdWithError:(NSError *)error;

- (UIViewController *)viewControllerForCustomEventViewController:(AFSASCustomEventViewController *)customEventViewController;
- (void)customEventViewControllerDidReceiveTapEvent:(AFSASCustomEventViewController *)customEventViewController;
- (void)customEventViewControllerAdViewDidDisapear:(AFSASCustomEventViewController *)customEventViewController;
- (void)customEventViewControllerWillLeaveApplication:(AFSASCustomEventViewController *)customEventViewController;

@end