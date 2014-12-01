/*!
 *  AFFacebookInterstitialCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFFacebookInterstitialCustomEvent.h"

// Facebook
#import <FBAudienceNetwork/FBAudienceNetwork.h>

@interface AFFacebookInterstitialCustomEvent () <FBInterstitialAdDelegate>

@property (nonatomic, strong) FBInterstitialAd *interstitial;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFFacebookInterstitialCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    self.interstitial.delegate = nil;
    self.interstitial = nil;
}

#pragma mark - AFMedInterstitialCustomEvent

- (void)requestInterstitialWithCustomParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;
    
    NSString *placementId = [self parsePlacementIdFromParameters:parameters];
    NSError *error;
    
    // Placement Id
    if (![placementId isKindOfClass:NSString.class] || placementId.length == 0) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct placement id."}];
    }
    
    // If there is an error.
    if (error) {
        [self interstitialAd:nil didFailWithError:error];
        return;
    }
    
    self.interstitial = [[FBInterstitialAd alloc] initWithPlacementID:placementId];
    self.interstitial.delegate = self;
    [self.interstitial loadAd];
}

- (void)presentInterstitialFromViewController:(UIViewController *)viewController {
    
    if (!self.interstitial || !self.interstitial.isAdValid) {
        if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidExpire:)]) {
            [self.delegate interstitialCustomEventDidExpire:self];
        }
    }
    
    else {
        
        if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
            [self.delegate interstitialCustomEventWillAppear:self];
        }
        
        if ([viewController isKindOfClass:UIViewController.class]) {
            [self.interstitial showAdFromRootViewController:viewController];
        }
        
        if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
            [self.delegate interstitialCustomEventDidAppear:self];
        }
    }
}

#pragma mark - FBInterstitialAdDelegate

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didLoadAd:interstitialAd];
    }
}

- (void)interstitialAd:(FBInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)interstitialAdDidClick:(FBInterstitialAd *)interstitialAd {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)]) {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    }
}

- (void)interstitialAdWillClose:(FBInterstitialAd *)interstitialAd {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
}

- (void)interstitialAdDidClose:(FBInterstitialAd *)interstitialAd {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}

#pragma mark - Parameters

- (NSString *)parsePlacementIdFromParameters:(NSDictionary *)parameters {
    
    if (![parameters isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    // placementId.
    NSString *placementId = parameters[@"placementId"];
    if ([placementId isKindOfClass:NSString.class] && placementId.length > 0) {
        return placementId;
    }
    
    return nil;
}

@end
