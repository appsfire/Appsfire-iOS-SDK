/*!
 *  AFAdMobInterstitialCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFAdMobInterstitialCustomEvent.h"

// AdMob
#import "GADInterstitial.h"

@interface AFAdMobInterstitialCustomEvent () <GADInterstitialDelegate>

@property (nonatomic, strong) GADInterstitial *interstitial;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFAdMobInterstitialCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
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
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
        }
        
        return;
    }
    
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.adUnitID = adUnitId;
    self.interstitial.delegate = self;
    
    GADRequest *request = [GADRequest request];
    
    // Setting information if provided.
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventInformation:)]) {
        
        AFMedInfo *information = [self.delegate interstitialCustomEventInformation:self];
        if (information) {
            
            // Location
            if (information.location) {
                [request setLocationWithLatitude:information.location.latitude longitude:information.location.longitude accuracy:0];
            }
            
            // Gender
            request.gender = [self adMobGenderMappingFromAppsfireGender:information.gender];
            
            // Birthday
            if (information.birthDate) {
                request.birthday = information.birthDate;
            }
            
        }
    }
    
    request.testDevices = @[GAD_SIMULATOR_ID];
    [self.interstitial loadRequest:request];
}

- (void)presentInterstitialFromViewController:(UIViewController *)viewController {
    
    if ([viewController isKindOfClass:UIViewController.class]) {
        [self.interstitial presentFromRootViewController:viewController];
    }
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didLoadAd:ad];
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
        [self.delegate interstitialCustomEventWillAppear:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
        [self.delegate interstitialCustomEventDidAppear:self];
    }
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillLeaveApplication:)]) {
        [self.delegate interstitialCustomEventWillLeaveApplication:self];
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

#pragma mark - Misc

- (GADGender)adMobGenderMappingFromAppsfireGender:(AFMedInfoGender)gender {
    
    switch (gender) {
        case AFMedInfoGenderNone: {
            return kGADGenderUnknown;
        } break;
            
        case AFMedInfoGenderMale: {
            return kGADGenderMale;
        } break;
            
        case AFMedInfoGenderFemale: {
            return kGADGenderFemale;
        } break;
    }
}

@end
