/*!
 *  @header    AFMoPubInterstitialCustomEvent.m
 *  @abstract  Appsfire MoPub Interstitial Custom Event class.
 *  @version   1.2
 */

/*
 Copyright 2010-2014 Appsfire SAS. All rights reserved.
 
 Redistribution and use in source and binary forms, without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY APPSFIRE SAS ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL APPSFIRE SAS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AFMoPubInterstitialCustomEvent.h"

// Appsfire SDK
#import "AppsfireAdSDK.h"
#import "AppsfireAdTimerView.h"

@interface AFMoPubInterstitialCustomEvent () <AppsfireAdSDKDelegate>

@property (nonatomic, assign, readwrite) AFAdSDKModalType modalType;
@property (nonatomic, assign, readwrite) BOOL shouldShowTimer;

// Parses and assigns the modal type and timer values.
- (void)parseInfoPayload:(NSDictionary *)info;

// Shows Appsfire interstitials if those are available.
- (void)showAppsfireInterstitialsFromRootViewController:(UIViewController *)rootViewController;

@end

@implementation AFMoPubInterstitialCustomEvent

#pragma mark - Init & Dealloc

- (void)dealloc {
    [AppsfireAdSDK setDelegate:nil];
}

#pragma mark - Ad Request

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    
    // Default values
    _modalType = AFAdSDKModalTypeSushi;
    _shouldShowTimer = NO;
    
    // Getting custom values.
    [self parseInfoPayload:info];
    
    // Specify the delegate to handle various interactions with the Appsfire Ad SDK.
    [AppsfireAdSDK setDelegate:self];
    
    // Tells Ad SDK to prepare, this method is automatically called during a modal ad request.
    [AppsfireAdSDK prepare];
    
    // We need to know if we have available ads.
    AFAdSDKAdAvailability availability = [AppsfireAdSDK isThereAModalAdAvailableForType:_modalType];
    
    // Depending on the availability.
    switch (availability) {
        case AFAdSDKAdAvailabilityYes: {
            if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)]) {
                [self.delegate interstitialCustomEvent:self didLoadAd:nil];
            }
        } break;
            
        case AFAdSDKAdAvailabilityNo: {
            if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)]) {
                NSError *error = [NSError errorWithDomain:@"com.appsfire.sdk" code:AFSDKErrorCodeAdvertisingNoAd userInfo:@{NSLocalizedDescriptionKey : @"No Ads to display."}];
                [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
            }
        } break;
            
        default:
            break;
    }
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    [self showAppsfireInterstitialsFromRootViewController:rootViewController];
}

#pragma mark - AppsfireAdSDKDelegate

- (void)modalAdIsReadyForRequest {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)]) {
        [self.delegate interstitialCustomEvent:self didLoadAd:nil];
    }
}

- (void)modalAdRequestDidFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)]) {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)modalAdWillAppear {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
        [self.delegate interstitialCustomEventWillAppear:self];
    }
}

- (void)modalAdDidAppear {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
        [self.delegate interstitialCustomEventDidAppear:self];
    }
}

- (void)modalAdWillDisappear {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
}

- (void)modalAdDidDisappear {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}

- (void)modalAdDidReceiveTapForDownload {
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)]) {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    }
}

#pragma mark - Parsing the Info

- (void)parseInfoPayload:(NSDictionary *)info {
    
    // Fetching necessary information in order to decide which ad unit we are showing
    if ([info isKindOfClass:NSDictionary.class]) {
        
        // Getting the type of the ad unit.
        NSString *type = [info objectForKey:@"type"];
        if ([type isKindOfClass:NSString.class]) {
            
            if ([type isEqualToString:@"sushi"]) {
                _modalType = AFAdSDKModalTypeSushi;
            }
            else if ([type isEqualToString:@"uramaki"]) {
                _modalType = AFAdSDKModalTypeUraMaki;
            }
        }
        
        // Should we display the timer?
        NSNumber *timer = [info objectForKey:@"timer"];
        if ([timer isKindOfClass:NSNumber.class]) {
            _shouldShowTimer = [timer boolValue];
        }
    }
}

#pragma mark - Show Interstitials

- (void)showAppsfireInterstitialsFromRootViewController:(UIViewController *)rootViewController {
    
    if (![rootViewController isKindOfClass:UIViewController.class]) {
        return;
    }
    
    // If we don't have any available interstitial we skip the next lines.
    if ([AppsfireAdSDK isThereAModalAdAvailableForType:_modalType] != AFAdSDKAdAvailabilityYes) {
        return;
    }
    
    // Showing a timer before presenting the Ad.
    if (_shouldShowTimer) {
        
        [[[AppsfireAdTimerView alloc] initWithCountdownStart:3] presentWithCompletion:^(BOOL accepted) {
            if (accepted) {
                [AppsfireAdSDK requestModalAd:_modalType withController:rootViewController];
            }
        }];
    }
    
    // Simply showing the Ad.
    else {
        [AppsfireAdSDK requestModalAd:_modalType withController:rootViewController];
    }
}

@end
