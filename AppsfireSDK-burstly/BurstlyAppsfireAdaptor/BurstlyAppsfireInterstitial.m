/*!
 *  @header    BurstlyAppsfireInterstitial.m
 *  @abstract  Appsfire Burstly Interstitial Custom Event class.
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

#import "BurstlyAppsfireInterstitial.h"

@interface BurstlyAppsfireInterstitial ()

@property (nonatomic, assign, readwrite) AFAdSDKModalType modalType;
@property (nonatomic, assign, readwrite) BOOL shouldShowTimer;

// Parses and assigns the modal type and timer values.
- (void)parseParameters:(NSDictionary *)params;

// Shows Appsfire interstitials if those are available.
- (void)showAppsfireInterstitialsFromRootViewController:(UIViewController *)rootViewController;

@end

@implementation BurstlyAppsfireInterstitial

@synthesize delegate = _delegate;

- (id)initWithParams:(NSDictionary *)params {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    // Default values
    _modalType = AFAdSDKModalTypeSushi;
    _shouldShowTimer = NO;
    
    // Getting custom values.
    [self parseParameters:params];
    
    // Specify the delegate to handle various interactions with the Appsfire Ad SDK.
    [AppsfireAdSDK setDelegate:self];
    
    return self;
}

- (void)dealloc {
    [self cancelInterstitialLoading];
}

#pragma mark - BurstlyAdInterstitialProtocol

- (void)loadInterstitialInBackground {
    // Tell Ad SDK to prepare, this method is automatically called during a modal ad request.
    [AppsfireAdSDK prepare];
    
    // We need to know if we have available ads.
    AFAdSDKAdAvailability availability = [AppsfireAdSDK isThereAModalAdAvailableForType:_modalType];
    
    // Depending on the availability.
    switch (availability) {
        case AFAdSDKAdAvailabilityYes: {
            if ([_delegate respondsToSelector:@selector(interstitialDidLoadAd:)]) {
                [_delegate interstitialDidLoadAd:self];
            }
        } break;
            
        case AFAdSDKAdAvailabilityNo: {
            if ([_delegate respondsToSelector:@selector(interstitial:didFailToLoadAdWithError:)]) {
                NSError *error = [NSError errorWithDomain:@"com.appsfire.sdk" code:AFSDKErrorCodeAdvertisingNoAd userInfo:@{NSLocalizedDescriptionKey : @"No Ads to display."}];
                [_delegate interstitial:self didFailToLoadAdWithError:error];
            }
        } break;
            
        default:
            break;
    }
}

- (void)cancelInterstitialLoading {
    [AppsfireAdSDK setDelegate:nil];
}

- (void)presentInterstitial {
    UIViewController *rootViewController = [_delegate viewControllerForModalPresentation];
    [self showAppsfireInterstitialsFromRootViewController:rootViewController];
}

#pragma mark - AppsfireAdSDKDelegate

- (void)modalAdIsReadyForRequest {
    if ([_delegate respondsToSelector:@selector(interstitialDidLoadAd:)]) {
        [_delegate interstitialDidLoadAd:self];
    }
}

- (void)modalAdRequestDidFailWithError:(NSError *)error {
    if ([_delegate respondsToSelector:@selector(interstitial:didFailToLoadAdWithError:)]) {
        [_delegate interstitial:self didFailToLoadAdWithError:error];
    }
}

- (void)modalAdWillAppear {
    if ([_delegate respondsToSelector:@selector(interstitialWillPresentFullScreen:)]) {
        [_delegate interstitialWillPresentFullScreen:self];
    }
}

- (void)modalAdDidAppear {
    if ([_delegate respondsToSelector:@selector(interstitialDidPresentFullScreen:)]) {
        [_delegate interstitialWillPresentFullScreen:self];
    }
}

- (void)modalAdWillDisappear {
    // Burstly does not support this event.
}

- (void)modalAdDidDisappear {
    if ([_delegate respondsToSelector:@selector(interstitialDidDismissFullScreen:)]) {
        [_delegate interstitialDidDismissFullScreen:self];
    }
}

- (void)modalAdDidReceiveTapForDownload {
    if ([_delegate respondsToSelector:@selector(interstitialWasClicked:)]) {
        [_delegate interstitialWasClicked:self];
    }
    
    if ([_delegate respondsToSelector:@selector(interstitialWillLeaveApplication:)]) {
        [_delegate interstitialWillLeaveApplication:self];
    }
}

#pragma mark - Parsing the Info

- (void)parseParameters:(NSDictionary *)params {
    
    // Fetching necessary information in order to decide which ad unit we are showing
    if ([params isKindOfClass:NSDictionary.class]) {
        
        // Getting the type of the ad unit.
        NSString *type = [params objectForKey:@"type"];
        if ([type isKindOfClass:NSString.class]) {
            
            if ([type isEqualToString:@"sushi"]) {
                _modalType = AFAdSDKModalTypeSushi;
            }
            else if ([type isEqualToString:@"uramaki"]) {
                _modalType = AFAdSDKModalTypeUraMaki;
            }
        }
        
        // Should we display the timer?
        NSNumber *timer = [params objectForKey:@"timer"];
        if ([timer isKindOfClass:NSNumber.class]) {
            _shouldShowTimer = [timer boolValue];
        }
    }
}

#pragma mark - Show Interstitials

- (void)showAppsfireInterstitialsFromRootViewController:(UIViewController *)rootViewController {
    
    BOOL isThereAModalAdAvailable = ([AppsfireAdSDK isThereAModalAdAvailableForType:_modalType] == AFAdSDKAdAvailabilityYes);
    BOOL canShowInterstitial = isThereAModalAdAvailable && ![AppsfireAdSDK isModalAdDisplayed] && [rootViewController isKindOfClass:UIViewController.class];
    
    if (canShowInterstitial) {
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
    
    else {
        NSString *errorDescription = [NSString stringWithFormat: @"Appsfire interstitial cannot be presented, isReady=%d, isAlreadyDisplayed=%d, rootViewController=%@", isThereAModalAdAvailable, [AppsfireAdSDK isModalAdDisplayed], rootViewController];
        
        NSError *error = [NSError errorWithDomain: @"com.appsfire.adunit" code:1 userInfo:@{NSLocalizedDescriptionKey: errorDescription}];
        [_delegate interstitial:self didFailToPresentFullScreenWithError:error];
    }

}

@end
