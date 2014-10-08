/*!
 *  AFFacebookBannerViewCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFFacebookBannerViewCustomEvent.h"

// Facebook
#import <FBAudienceNetwork/FBAudienceNetwork.h>

static FBAdSize const AFFacebookBannerViewCustomEventInvalidAdSize;

@interface AFFacebookBannerViewCustomEvent () <FBAdViewDelegate>

@property (nonatomic, strong) FBAdView *bannerView;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFFacebookBannerViewCustomEvent

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
    
    NSString *placementId = [self parsePlacementIdFromParameters:parameters];
    FBAdSize adSize = [self adSizeWithSize:size];
    NSError *error;
    
    // Placement Id
    if (![placementId isKindOfClass:NSString.class] || placementId.length == 0) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct ad unit id."}];
    }
    
    // Ad Size
    else if (CGSizeEqualToSize(adSize.size, AFFacebookBannerViewCustomEventInvalidAdSize.size)) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"Banner size mismatch."}];
    }
    
    // If there is an error.
    if (error) {
        [self adView:nil didFailWithError:error];
        return;
    }
    
    self.bannerView = [[FBAdView alloc] initWithPlacementID:placementId adSize:adSize rootViewController:[self rootViewController]];
    self.bannerView.delegate = self;
    [self.bannerView loadAd];
}

- (UIViewController *)rootViewController {
    
    if ([self.delegate respondsToSelector:@selector(viewControllerForBannerViewCustomEvent:)]) {
        return [self.delegate viewControllerForBannerViewCustomEvent:self];
    }
    
    return nil;
}

#pragma mark - MPAdViewDelegate

- (void)adViewDidLoad:(FBAdView *)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didLoadAd:adView];
    }
}

- (void)adView:(FBAdView *)adView didFailWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)adViewDidClick:(FBAdView *)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventBeginOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventBeginOverlayPresentation:self];
    }
}

- (void)adViewDidFinishHandlingClick:(FBAdView *)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventEndOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventEndOverlayPresentation:self];
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

#pragma mark - Size

- (FBAdSize)adSizeWithSize:(CGSize)size {
    
    if (CGSizeEqualToSize(size, kFBAdSize320x50.size)) {
        return kFBAdSize320x50;
    }
    
    else if (kFBAdSizeHeight50Banner.size.height >= size.height) {
        return kFBAdSizeHeight50Banner;
    }
    
    else if (kFBAdSizeHeight90Banner.size.height >= size.height) {
        return kFBAdSizeHeight90Banner;
    }
    
    return AFFacebookBannerViewCustomEventInvalidAdSize;
}

@end
