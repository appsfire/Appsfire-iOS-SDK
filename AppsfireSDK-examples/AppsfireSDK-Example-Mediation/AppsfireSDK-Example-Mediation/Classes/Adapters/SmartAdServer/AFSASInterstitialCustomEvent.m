/*!
 *  AFSASInterstitialCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFSASInterstitialCustomEvent.h"

// Smart Ad Server
#import "SASInterstitialView.h"

#import "AFSASCustomEventViewController.h"

@interface AFSASInterstitialCustomEvent () <AFSASCustomEventViewControllerInterstitialDelegate>

@property (nonatomic, copy) NSNumber *formatId;
@property (nonatomic, copy) NSString *pageId;
@property (nonatomic, strong) SASInterstitialView *interstitialView;
@property (nonatomic, strong) UIViewController <SASAdViewDelegate> *viewController;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFSASInterstitialCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    self.interstitialView.delegate = nil;
    self.interstitialView = nil;
    self.viewController = nil;
    self.delegate = nil;
    self.formatId = nil;
    self.pageId = nil;
}

#pragma mark - AFMedInterstitialCustomEvent

- (void)requestInterstitialWithCustomParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;
    
    // Extracting parameters from the info payload.
    BOOL areParametersValid = [self parseParameters:parameters];
    self.viewController = [self viewControllerDelegate];
    NSError *error;
    
    // Are the parameters valid?
    if (!areParametersValid) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct payload."}];
    }
    
    // Is the returned view controller valid?
    else if (![self.viewController isKindOfClass:UIViewController.class]) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The view controller returned by the delegate is not of UIViewController type."}];
    }
    
    // If there is an error.
    if (error) {
        [self customEventViewController:nil didFailToLoadAdWithError:error];
        return;
    }
    
    // Creating the interstitial view.
    self.interstitialView = [[SASInterstitialView alloc] initWithFrame:self.viewController.view.bounds loader:SASLoaderActivityIndicatorStyleTransparent];
    self.interstitialView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
    // Setting the location if provided.
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventInformation:)]) {
        
        AFMedInfo *information = [self.delegate interstitialCustomEventInformation:self];
        if (information.location) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:information.location.latitude longitude:information.location.longitude];
            [SASAdView setLocation:location];
        }
    }
    
    // Setting the delegate to the special view controller because Smart Ad Server's delegate needs
    // to be the one containing the ad view (it will crash if we don't do this).
    self.interstitialView.delegate = self.viewController;
    [self setInterstitialDelegate:self];
    
    // Moving the ad out.
    self.interstitialView.frame = CGRectMake(CGRectGetMinX(self.interstitialView.frame), CGRectGetMaxY(self.interstitialView.frame), CGRectGetWidth(self.interstitialView.frame), CGRectGetHeight(self.interstitialView.frame));
    
    // Adding a dismiss animation.
    self.interstitialView.dismissalAnimations = ^(SASAdView *adView) {
		adView.frame = CGRectMake(CGRectGetMinX(adView.frame), CGRectGetMaxY(adView.frame), CGRectGetWidth(adView.frame), CGRectGetHeight(adView.frame));
	};
    
    // Loading the ad.
	[self.interstitialView loadFormatId:[self.formatId integerValue] pageId:self.pageId master:YES target:nil];
}

- (void)presentInterstitialFromViewController:(UIViewController *)viewController {
    
    if (![viewController isKindOfClass:UIViewController.class]) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
        [self.delegate interstitialCustomEventWillAppear:self];
    }
    
    UIViewController *hostViewController;
    // Inserting the ad view in the view hierachy of the view inside the view controller.
    // If the viewController is encapsulated in the UINavigationController we use it to display the
    // ad.
    if ([viewController.navigationController isKindOfClass:UINavigationController.class]) {
        hostViewController = viewController.navigationController;
    }
    
    // If it's not
    else {
        hostViewController = viewController;
    }
    
    [hostViewController.view addSubview:self.interstitialView];
    
    // Placing the ad on the screen.
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.interstitialView.frame = hostViewController.view.bounds;
    } completion:^(BOOL finished) {
        
        if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
            [self.delegate interstitialCustomEventDidAppear:self];
        }
    }];
}

#pragma mark - AFSASInterstitialViewControllerDelegate

- (void)customEventViewController:(AFSASCustomEventViewController *)customEventViewController didLoadAd:(id)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didLoadAd:ad];
    }
}

- (void)customEventViewController:(AFSASCustomEventViewController *)customEventViewController didFailToLoadAdWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (UIViewController *)viewControllerForCustomEventViewController:(AFSASCustomEventViewController *)customEventViewController {
    return self.interstitialView.delegate;
}

- (void)customEventViewControllerAdViewDidDisapear:(AFSASCustomEventViewController *)customEventViewController {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
    
    [self.interstitialView removeFromSuperview];
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}

- (void)customEventViewControllerDidReceiveTapEvent:(AFSASCustomEventViewController *)customEventViewController {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)]) {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    }
}

- (void)customEventViewControllerWillLeaveApplication:(AFSASCustomEventViewController *)customEventViewController {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillLeaveApplication:)]) {
        [self.delegate interstitialCustomEventWillLeaveApplication:self];
    }
}

#pragma mark - Misc

- (UIViewController <SASAdViewDelegate> *)viewControllerDelegate {
    return (id)[self.delegate viewControllerForinterstitialCustomEvent:self];
}

- (void)setInterstitialDelegate:(id <AFSASCustomEventViewControllerInterstitialDelegate>)interstitialDelegate {
    if ([self.interstitialView.delegate isKindOfClass:AFSASCustomEventViewController.class]) {
        ((AFSASCustomEventViewController *)self.interstitialView.delegate).interstitialDelegate = interstitialDelegate;
    }
}

#pragma mark - Parameters

- (BOOL)parseParameters:(NSDictionary *)parameters {
    
    if (![parameters isKindOfClass:NSDictionary.class]) {
        return NO;
    }
    
    id component;
    
    // formatId
    component = parameters[@"formatId"];
    if ([component isKindOfClass:NSNumber.class]) {
        self.formatId = component;
    } else {
        return NO;
    }
    
    // pageId
    component = parameters[@"pageId"];
    if ([component isKindOfClass:NSString.class] && [(NSString *)component length] > 0) {
        self.pageId = component;
    } else {
        return NO;
    }
    
    return YES;
}

@end
