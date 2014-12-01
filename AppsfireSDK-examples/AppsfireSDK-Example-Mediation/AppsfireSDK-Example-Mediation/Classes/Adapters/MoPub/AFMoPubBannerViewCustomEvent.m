/*!
 *  AFMoPubBannerViewCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFMoPubBannerViewCustomEvent.h"

// MoPub
#import "MPAdView.h"

CG_INLINE BOOL
CGSizeFitInSize(CGSize size1, CGSize size2) {
    return (size1.width <= size2.width && size1.height <= size2.height);
}

@interface AFMoPubBannerViewCustomEvent () <MPAdViewDelegate>

@property (nonatomic, strong) MPAdView *bannerView;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFMoPubBannerViewCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    self.bannerView = nil;
    self.bannerView.delegate = nil;
    self.delegate = nil;
}

#pragma mark - AFMedBannerViewCustomEvent

- (void)requestBannerViewWithSize:(CGSize)size customEventParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;
    
    NSString *adUnitId = [self parseAdUnitIdFromParameters:parameters];
    CGSize adSize = [self adSizeWithSize:size];
    NSError *error;
    
    // AdUnit Id
    if (![adUnitId isKindOfClass:NSString.class] || adUnitId.length == 0) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct ad unit id."}];
    }
    
    // If there is an error.
    if (error) {
        [self adViewDidFailToLoadAd:nil];
        return;
    }
    
    self.bannerView = [[MPAdView alloc] initWithAdUnitId:adUnitId size:adSize];
    self.bannerView.delegate = self;
    
    // Setting the location if provided.
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventInformation:)]) {
        
        AFMedInfo *information = [self.delegate bannerViewCustomEventInformation:self];
        if (information.location) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:information.location.latitude longitude:information.location.longitude];
            self.bannerView.location = location;
        }
    }
    
    [self.bannerView stopAutomaticallyRefreshingContents];
    [self.bannerView loadAd];
}

#pragma mark - MPAdViewDelegate

- (void)adViewDidLoadAd:(MPAdView *)view {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didLoadAd:view];
    }
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

- (void)willPresentModalViewForAd:(MPAdView *)view {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventBeginOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventBeginOverlayPresentation:self];
    }
}

- (void)didDismissModalViewForAd:(MPAdView *)view {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventEndOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventEndOverlayPresentation:self];
    }
}

- (UIViewController *)viewControllerForPresentingModalView {
    
    if ([self.delegate respondsToSelector:@selector(viewControllerForBannerViewCustomEvent:)]) {
        return [self.delegate viewControllerForBannerViewCustomEvent:self];
    }
    
    return nil;
}

- (void)willLeaveApplicationFromAd:(MPAdView *)view {
    
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

#pragma mark - Size

- (CGSize)adSizeWithSize:(CGSize)size {

    if (CGSizeFitInSize(MOPUB_BANNER_SIZE, size)) {
        return MOPUB_BANNER_SIZE;
    } else if (CGSizeFitInSize(MOPUB_MEDIUM_RECT_SIZE, size)) {
        return MOPUB_MEDIUM_RECT_SIZE;
    } else if (CGSizeFitInSize(MOPUB_LEADERBOARD_SIZE, size)) {
        return MOPUB_LEADERBOARD_SIZE;
    } else if (CGSizeFitInSize(MOPUB_WIDE_SKYSCRAPER_SIZE, size)) {
        return MOPUB_WIDE_SKYSCRAPER_SIZE;
    }
    
    return size;
}

@end
