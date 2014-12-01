/*!
 *  AFSASCustomEventViewController.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFSASCustomEventViewController.h"

// Smart Ad Server
#import "SASBannerView.h"
#import "SASInterstitialView.h"

@implementation AFSASCustomEventViewController

#pragma mark - Dealloc

- (void)dealloc {
    self.bannerDelegate = nil;
    self.interstitialDelegate = nil;
}

#pragma mark - SASAdViewDelegate

- (void)adViewDidLoad:(SASAdView *)adView {
    
    // SASBannerView
    if ([adView isMemberOfClass:SASBannerView.class]) {
        
        if ([self.bannerDelegate respondsToSelector:@selector(customEventViewController:didLoadAd:)]) {
            [self.bannerDelegate customEventViewController:self didLoadAd:adView];
        }
    }
    
    // SASInterstitialView
    else if([adView isMemberOfClass:SASInterstitialView.class]) {
        
        if ([self.interstitialDelegate respondsToSelector:@selector(customEventViewController:didLoadAd:)]) {
            [self.interstitialDelegate customEventViewController:self didLoadAd:adView];
        }
    }
}

- (void)adViewDidFailToLoad:(SASAdView *)adView error:(NSError *)error {
    
    // SASBannerView
    if ([adView isMemberOfClass:SASBannerView.class]) {
        
        if ([self.bannerDelegate respondsToSelector:@selector(customEventViewController:didFailToLoadAdWithError:)]) {
            [self.bannerDelegate customEventViewController:self didFailToLoadAdWithError:error];
        }
    }
    
    // SASInterstitialView
    else if([adView isMemberOfClass:SASInterstitialView.class]) {
        
        if ([self.interstitialDelegate respondsToSelector:@selector(customEventViewController:didFailToLoadAdWithError:)]) {
            [self.interstitialDelegate customEventViewController:self didFailToLoadAdWithError:error];
        }
    }
}

- (void)adViewWillPresentModalView:(SASAdView *)adView {
    
    // SASBannerView
    if ([adView isMemberOfClass:SASBannerView.class]) {
        
        if ([self.bannerDelegate respondsToSelector:@selector(customEventViewControllerBeginOverlayPresentation:)]) {
            [self.bannerDelegate customEventViewControllerBeginOverlayPresentation:self];
        }
        
    }
    
    // SASInterstitialView
    else if([adView isMemberOfClass:SASInterstitialView.class]) {
        
        if ([self.interstitialDelegate respondsToSelector:@selector(customEventViewControllerDidReceiveTapEvent:)]) {
            [self.interstitialDelegate customEventViewControllerDidReceiveTapEvent:self];
        }
        
    }
}

- (void)adViewWillDismissModalView:(SASAdView *)adView {
    
    // SASBannerView
    if ([adView isMemberOfClass:SASBannerView.class]) {
        
        if ([self.bannerDelegate respondsToSelector:@selector(customEventViewControllerEndOverlayPresentation:)]) {
            [self.bannerDelegate customEventViewControllerEndOverlayPresentation:self];
        }
    }
    
    // SASInterstitialView
    else if([adView isMemberOfClass:SASInterstitialView.class]) {
        
        if ([self.interstitialDelegate respondsToSelector:@selector(customEventViewControllerDidReceiveTapEvent:)]) {
            [self.interstitialDelegate customEventViewControllerDidReceiveTapEvent:self];
        }
    }
}

- (void)adView:(SASAdView *)adView willPerformActionWithExit:(BOOL)willExit {
    
    // SASBannerView
    if ([adView isMemberOfClass:SASBannerView.class] && willExit) {
        
        if ([self.bannerDelegate respondsToSelector:@selector(customEventViewControllerWillLeaveApplication:)]) {
            [self.bannerDelegate customEventViewControllerWillLeaveApplication:self];
        }
    }
    
    // SASInterstitialView
    else if([adView isMemberOfClass:SASInterstitialView.class] && willExit) {
        
        if ([self.interstitialDelegate respondsToSelector:@selector(customEventViewControllerWillLeaveApplication:)]) {
            [self.interstitialDelegate customEventViewControllerWillLeaveApplication:self];
        }
    }
}

- (void)adViewDidDisappear:(SASAdView *)adView {
    
    // SASInterstitialView
    if ([adView isMemberOfClass:SASInterstitialView.class]) {
        
        if ([self.interstitialDelegate respondsToSelector:@selector(customEventViewControllerAdViewDidDisapear:)]) {
            [self.interstitialDelegate customEventViewControllerAdViewDidDisapear:self];
        }
    }
}

- (UIViewController *)viewControllerForAdView:(SASAdView *)adView {
    
    // SASBannerView
    if ([adView isMemberOfClass:SASBannerView.class]) {
        
        if ([self.bannerDelegate respondsToSelector:@selector(viewControllerForCustomEventViewController:)]) {
            return [self.bannerDelegate viewControllerForCustomEventViewController:self];
        }
    }
    
    // SASInterstitialView
    else if([adView isMemberOfClass:SASInterstitialView.class]) {
        
        if ([self.interstitialDelegate respondsToSelector:@selector(viewControllerForCustomEventViewController:)]) {
            return [self.interstitialDelegate viewControllerForCustomEventViewController:self];
        }
    }
    
    return nil;
}

#pragma mark - Animation

- (UIViewAnimationOptions)animationOptionsForDismissingAdView:(SASAdView *)adView {
	return UIViewAnimationOptionCurveEaseOut;
}

- (NSTimeInterval)animationDurationForDismissingAdView:(SASAdView *)adView {
	return 0.3;
}

@end
