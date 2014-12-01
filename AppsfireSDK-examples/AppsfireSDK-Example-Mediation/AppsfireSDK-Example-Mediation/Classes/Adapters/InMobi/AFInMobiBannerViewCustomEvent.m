/*!
 *  AFInMobiBannerViewCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFInMobiBannerViewCustomEvent.h"

// InMobi
#import "IMBanner.h"

static CGSize const AFInMobiBannerViewCustomEvent320x250 = {320.0, 250.0};
static CGSize const AFInMobiBannerViewCustomEvent728x90  = {728.0, 90.0};
static CGSize const AFInMobiBannerViewCustomEvent468x60  = {468.0, 60.0};
static CGSize const AFInMobiBannerViewCustomEvent120x600 = {120.0, 600.0};
static CGSize const AFInMobiBannerViewCustomEvent320x50  = {320.0, 50.0};

@interface AFInMobiBannerViewCustomEvent () <IMBannerDelegate>

@property (nonatomic, strong) IMBanner *bannerView;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFInMobiBannerViewCustomEvent

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
    
    NSString *appId = [self parseAppIdFromParameters:parameters];
    int adSize = [self adSizeWithSize:size];
    NSError *error;
    
    // App Id
    if (![appId isKindOfClass:NSString.class] || appId.length == 0) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct app id."}];
    }
    
    // Ad Size
    else if (adSize == -1) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"Banner size mismatch."}];
    }
    
    // If there is an error.
    if (error) {
        
        if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
            self.delegateAlreadyNotified = YES;
            [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:error];
        }
        
        return;
    }
    
    self.bannerView = [[IMBanner alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height) appId:appId adSize:adSize];
    self.bannerView.refreshInterval = REFRESH_INTERVAL_OFF;
    self.bannerView.delegate = self;
    
    // Setting information if provided.
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventInformation:)]) {
        
        AFMedInfo *information = [self.delegate bannerViewCustomEventInformation:self];
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
    
    [self.bannerView loadBanner];
}

#pragma mark - IMBannerDelegate

- (void)bannerDidReceiveAd:(IMBanner *)banner {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didLoadAd:banner];
    }
}

- (void)banner:(IMBanner *)banner didFailToReceiveAdWithError:(IMError *)error {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)bannerWillPresentScreen:(IMBanner *)banner {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventBeginOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventBeginOverlayPresentation:self];
    }
}

- (void)bannerWillDismissScreen:(IMBanner *)banner {}

- (void)bannerDidDismissScreen:(IMBanner *)banner {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventEndOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventEndOverlayPresentation:self];
    }
}

- (void)bannerWillLeaveApplication:(IMBanner *)banner {
   
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventWillLeaveApplication:)]) {
        [self.delegate bannerViewCustomEventWillLeaveApplication:self];
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

- (int)adSizeWithSize:(CGSize)size {
    
    if (CGSizeEqualToSize(size, AFInMobiBannerViewCustomEvent320x250)) {
        return IM_UNIT_300x250;
    } else if (CGSizeEqualToSize(size, AFInMobiBannerViewCustomEvent728x90)) {
        return IM_UNIT_728x90;
    } else if (CGSizeEqualToSize(size, AFInMobiBannerViewCustomEvent468x60)) {
        return IM_UNIT_468x60;
    } else if (CGSizeEqualToSize(size, AFInMobiBannerViewCustomEvent120x600)) {
        return IM_UNIT_120x600;
    } else if (CGSizeEqualToSize(size, AFInMobiBannerViewCustomEvent320x50)) {
        return IM_UNIT_320x50;
    }
    
    return -1;
}

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
