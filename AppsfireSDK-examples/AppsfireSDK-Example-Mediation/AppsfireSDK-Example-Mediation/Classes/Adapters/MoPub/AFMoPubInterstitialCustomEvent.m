/*!
 *  AFMoPubInterstitialCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFMoPubInterstitialCustomEvent.h"

// MoPub
#import "MPInterstitialAdController.h"

@interface AFMoPubInterstitialCustomEvent () <MPInterstitialAdControllerDelegate>

@property (nonatomic, strong) MPInterstitialAdController *interstitial;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFMoPubInterstitialCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    [MPInterstitialAdController removeSharedInterstitialAdController:self.interstitial];
    self.interstitial.delegate = nil;
    self.interstitial = nil;
}

#pragma mark - AFMedInterstitialCustomEvent

- (void)requestInterstitialWithCustomParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;
    
    NSString *adUnitId = [self parseAdUnitIdFromParameters:parameters];
    NSError *error;
    
    // AdUnit Id
    if (![adUnitId isKindOfClass:NSString.class] || adUnitId.length == 0) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct ad unit id."}];
    }
    
    // If there is an error.
    if (error) {
        
        if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
            self.delegateAlreadyNotified = YES;
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        }
        
        return;
    }
    
    // Creating an interstitial with the specified adUnit.
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:adUnitId];
    self.interstitial.delegate = self;
    
    // Setting the location if provided.
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventInformation:)]) {
        
        AFMedInfo *information = [self.delegate interstitialCustomEventInformation:self];
        if (information.location) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:information.location.latitude longitude:information.location.longitude];
            self.interstitial.location = location;
        }
    }
    
    // Start loading ads.
    [self.interstitial loadAd];
}

- (void)presentInterstitialFromViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:UIViewController.class]) {
        [self.interstitial showFromViewController:viewController];
    }
}

#pragma mark - MPInterstitialAdControllerDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didLoadAd:interstitial];
    }
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
        [self.delegate interstitialCustomEventWillAppear:self];
    }
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
        [self.delegate interstitialCustomEventDidAppear:self];
    }
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}

- (void)interstitialDidExpire:(MPInterstitialAdController *)interstitial {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidExpire:)]) {
        [self.delegate interstitialCustomEventDidExpire:self];
    }
}

#pragma mark - Parameters

- (NSString *)parseAdUnitIdFromParameters:(NSDictionary *)parameters {
    
    if (![parameters isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    // Extracting ad unit id.
    NSString *adUnitId = parameters[@"adUnitId"];
    if ([adUnitId isKindOfClass:NSString.class] && adUnitId.length > 0) {
        return adUnitId;
    }
    
    return nil;
}

@end
