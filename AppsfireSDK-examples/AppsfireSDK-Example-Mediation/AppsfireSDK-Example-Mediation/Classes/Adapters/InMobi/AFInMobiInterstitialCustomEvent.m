/*!
 *  AFInMobiInterstitialCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFInMobiInterstitialCustomEvent.h"

// InMobi
#import "IMInterstitial.h"

@interface AFInMobiInterstitialCustomEvent () <IMInterstitialDelegate>

@property (nonatomic, strong) IMInterstitial *interstitial;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFInMobiInterstitialCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    self.interstitial.delegate = nil;
    self.interstitial = nil;
}

#pragma mark - AFMedInterstitialCustomEvent

- (void)requestInterstitialWithCustomParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;
    
    NSString *appId = [self parseAppIdFromParameters:parameters];
    NSError *error;
    
    // AdUnit Id
    if (![appId isKindOfClass:NSString.class] || appId.length == 0) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct app id."}];
    }
    
    // If there is an error.
    if (error) {
        
        if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
            self.delegateAlreadyNotified = YES;
            [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
        }
        
        return;
    }
    
    self.interstitial = [[IMInterstitial alloc] initWithAppId:appId];
    self.interstitial.delegate = self;
    
    // Setting information if provided.
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventInformation:)]) {
        
        AFMedInfo *information = [self.delegate interstitialCustomEventInformation:self];
        if (information) {
            
            // Location
            if (information.location) {
                [InMobi setLocationWithLatitude:information.location.latitude longitude:information.location.longitude accuracy:0];
            }
            
            // Gender
            [InMobi setGender:[self inMobiGenderMappingFromAppsfireGender:information.gender]];
            
            // Birthdate
            if (information.birthDate) {
                [InMobi setDateOfBirth:information.birthDate];
            }
        }
    }
    
    [self.interstitial loadInterstitial];
}

- (void)presentInterstitialFromViewController:(UIViewController *)viewController {
    [self.interstitial presentInterstitialAnimated:YES];
}

#pragma mark - IMAdInterstitialDelegate


- (void)interstitialDidReceiveAd:(IMInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didLoadAd:ad];
    }
}

- (void)interstitial:(IMInterstitial *)ad didFailToReceiveAdWithError:(IMError *)error {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

- (void)interstitialWillPresentScreen:(IMInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
        [self.delegate interstitialCustomEventWillAppear:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
        [self.delegate interstitialCustomEventDidAppear:self];
    }
}

- (void)interstitial:(IMInterstitial *)ad didFailToPresentScreenWithError:(IMError *)error {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

- (void)interstitialWillDismissScreen:(IMInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
}

- (void)interstitialDidDismissScreen:(IMInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}

- (void)interstitialWillLeaveApplication:(IMInterstitial *)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillLeaveApplication:)]) {
        [self.delegate interstitialCustomEventWillLeaveApplication:self];
    }
}

- (void) interstitialDidInteract:(IMInterstitial *)ad withParams:(NSDictionary *)dictionary {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)]) {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    }
}

#pragma mark - Parameters

- (NSString *)parseAppIdFromParameters:(NSDictionary *)parameters {
    
    if (![parameters isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    // Extracting app id.
    NSString *appId = parameters[@"appId"];
    if ([appId isKindOfClass:NSString.class] && appId.length > 0) {
        return appId;
    }
    
    return nil;
}

#pragma mark - Misc

- (IMGender)inMobiGenderMappingFromAppsfireGender:(AFMedInfoGender)gender {
    
    switch (gender) {
        case AFMedInfoGenderNone: {
            return kIMGenderUnknown;
        } break;
            
        case AFMedInfoGenderMale: {
            return kIMGenderMale;
        } break;
            
        case AFMedInfoGenderFemale: {
            return kIMGenderFemale;
        } break;
    }
}

@end
