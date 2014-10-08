/*!
 *  AFXaxisBannerViewCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFXaxisBannerViewCustomEvent.h"

// Xaxis
#import "XAdView.h"
#import "XAdSlotConfiguration.h"

static NSString *const AFXaxisCustomInformation = @"AFXaxisCustomInformation";

@interface AFXaxisBannerViewCustomEvent () <XAdViewDelegate>

@property (nonatomic, strong) XAdView *bannerView;
@property (nonatomic, copy) NSString *domainName;
@property (nonatomic, copy) NSString *pageName;
@property (nonatomic, copy) NSString *adPosition;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFXaxisBannerViewCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    self.bannerView = nil;
    self.bannerView.delegate = nil;
    self.delegate = nil;
    self.domainName = nil;
    self.pageName = nil;
    self.adPosition = nil;
}

#pragma mark - AFMedBannerViewCustomEvent

- (void)requestBannerViewWithSize:(CGSize)size customEventParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;

    // Extracting parameters from the info payload.
    BOOL areParametersValid = [self parseParameters:parameters];
    NSError *error;
    
    // Are the parameters valid?
    if (!areParametersValid) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct payload."}];
    }
    
    // If there is an error.
    if (error) {
        [self xAdView:nil didFailWithError:error];
        return;
    }
    
    XAdSlotConfiguration *configuration = [[XAdSlotConfiguration alloc] init];
    configuration.bannerRefreshInterval = 0;
    configuration.scalingAllowed = YES;
    configuration.maintainAspectRatio = YES;
    configuration.shouldOpenClickThroughURLInAppBrowser = YES;
    configuration.RTBRequired = NO;
    configuration.COPPAPermissions = YES;
    
    NSString *queryString = nil;
    NSString *keywords = nil;
    
    // Getting information if provided.
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventInformation:)]) {
        
        AFMedInfo *information = [self.delegate bannerViewCustomEventInformation:self];
        if (information) {
            
            NSDictionary *customDictionary = information.customDictionary;
            if ([customDictionary isKindOfClass:NSDictionary.class]) {
                
                // Extracting the Xaxis specific payload.
                id customInformation = [customDictionary objectForKey:AFXaxisCustomInformation];
                if ([customInformation isKindOfClass:NSDictionary.class]) {
                    
                    // Getting the keywords.
                    id component = [customInformation objectForKey:@"keywords"];
                    if ([component isKindOfClass:NSString.class] && [(NSString *)component length] > 0) {
                        keywords = component;
                    }
                    
                    // Getting a queryString.
                    component = [customInformation objectForKey:@"queryString"];
                    if ([component isKindOfClass:NSString.class] && [(NSString *)component length] > 0) {
                        queryString = component;
                    }
                    
                }
            }
        }
    }
    
    self.bannerView = [[XAdView alloc] initWithFrame:CGRectMake(0.0, 0.0, size.width, size.height)];
    self.bannerView.delegate = self;
    self.bannerView.slotConfiguration = configuration;
    [self.bannerView loadWithDomainName:self.domainName pageName:self.pageName adPosition:self.adPosition keywords:keywords queryString:queryString];
}

#pragma mark XAdViewDelegate

- (void)xAdViewDidLoad:(XAdView *)adView {

    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didLoadAd:adView];
    }
}

- (void)xAdView:(XAdView *)xAdView didFailWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)xAdViewDidReceiveNoAd:(XAdView *)adView {
    
    NSError *error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"Blank Ad received."}];
    [self xAdView:adView didFailWithError:error];
}

- (void)xAdViewWillOpenInInAppBrowser:(XAdView *)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventBeginOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventBeginOverlayPresentation:self];
    }
}

- (void)xAdViewWillCloseInAppBrowser:(XAdView *)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventEndOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventEndOverlayPresentation:self];
    }
}

- (void)xAdViewWillLeaveApplication:(XAdView *)adView {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventWillLeaveApplication:)]) {
        [self.delegate bannerViewCustomEventWillLeaveApplication:self];
    }
}

- (void)xAdViewDidDismissOnMemoryWarning:(XAdView *)adView {

    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:nil];
    }
}

#pragma mark - Parameters

- (BOOL)parseParameters:(NSDictionary *)parameters {
    
    if (![parameters isKindOfClass:NSDictionary.class]) {
        return NO;
    }
    
    id component;
    
    // domainName
    component = parameters[@"domainName"];
    if ([component isKindOfClass:NSString.class] && [(NSString *)component length] > 0) {
        self.domainName = component;
    } else {
        return NO;
    }
    
    // pageName
    component = parameters[@"pageName"];
    if ([component isKindOfClass:NSString.class] && [(NSString *)component length] > 0) {
        self.pageName = component;
    } else {
        return NO;
    }
    
    // adPosition
    component = parameters[@"adPosition"];
    if ([component isKindOfClass:NSString.class] && [(NSString *)component length] > 0) {
        self.adPosition = component;
    } else {
        return NO;
    }
    
    return YES;
}

@end
