/*!
 *  AFDFPBannerViewCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFDFPBannerViewCustomEvent.h"

// DoubleClick
#import "DFPBannerView.h"

@interface AFDFPBannerViewCustomEvent () <GADBannerViewDelegate>

@property (nonatomic, strong) DFPBannerView *bannerView;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFDFPBannerViewCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    self.bannerView.delegate = nil;
    self.bannerView = nil;
    self.delegate = nil;
}

#pragma mark - AFMedBannerViewCustomEvent

- (void)requestBannerViewWithSize:(CGSize)size customEventParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;
    
    NSString *adUnitId = [self parseAdUnitIdFromParameters:parameters];
    NSError *error;
    
    // AdUnit Id
    if (![adUnitId isKindOfClass:NSString.class] || adUnitId.length == 0) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct ad unit id."}];
    }
    
    // If there is an error.
    if (error) {
        
        if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
            self.delegateAlreadyNotified = YES;
            [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:error];
        }
        
        return;
    }
    
    self.bannerView = [[DFPBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(size)];
    self.bannerView.delegate = self;
    self.bannerView.adUnitID = adUnitId;
    self.bannerView.rootViewController = [self rootViewController];
    
    GADRequest *request = [GADRequest request];
    
    // Setting information if provided.
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventInformation:)]) {
        
        AFMedInfo *information = [self.delegate bannerViewCustomEventInformation:self];
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
    
    // Adding the simulator as a test device.
    request.testDevices = @[GAD_SIMULATOR_ID];
    [self.bannerView loadRequest:request];
}

- (UIViewController *)rootViewController {
    
    if ([self.delegate respondsToSelector:@selector(viewControllerForBannerViewCustomEvent:)]) {
        return [self.delegate viewControllerForBannerViewCustomEvent:self];
    }
    
    return nil;
}

#pragma mark - GADBannerViewDelegate

- (void)adViewDidReceiveAd:(GADBannerView *)view {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didLoadAd:view];
    }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventBeginOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventBeginOverlayPresentation:self];
    }
}

- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventEndOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventEndOverlayPresentation:self];
    }
}

- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventWillLeaveApplication:)]) {
        [self.delegate bannerViewCustomEventWillLeaveApplication:self];
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
