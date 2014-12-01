/*!
 *  AFXaxisInterstitialCustomEvent.h
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */
 
#import "AFXaxisInterstitialCustomEvent.h"

// Xaxis
#import "XAdInterstitialViewController.h"
#import "XAdSlotConfiguration.h"

static NSString *const AFXaxisCustomInformation = @"AFXaxisCustomInformation";

@interface AFXaxisInterstitialCustomEvent () <XAdInterstitialViewControllerDelegate>

@property (nonatomic, strong) XAdInterstitialViewController *interstitial;
@property (nonatomic, copy) NSString *domainName;
@property (nonatomic, copy) NSString *pageName;
@property (nonatomic, copy) NSString *adPosition;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFXaxisInterstitialCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    self.interstitial.delegate = nil;
    self.interstitial = nil;
    self.domainName = nil;
    self.pageName = nil;
    self.adPosition = nil;
}

#pragma mark - AFMedInterstitialCustomEvent

- (void)requestInterstitialWithCustomParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;
    NSError *error;
    
    // Extracting parameters from the info payload.
    BOOL areParametersValid = [self parseParameters:parameters];
    
    // Are the parameters valid?
    if (!areParametersValid) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct payload."}];
    }
    
    // If there is an error.
    if (error) {
        [self xAdInterstitial:nil didFailWithError:error];
        return;
    }
    
    [self xAdInterstitialDidLoad:nil];
}

- (void)presentInterstitialFromViewController:(UIViewController *)viewController {
    
    // Creating an interstitial with the specified adUnit.
    self.interstitial = [[XAdInterstitialViewController alloc] init];
    self.interstitial.delegate = self;
    
    if ([viewController isKindOfClass:UIViewController.class]) {
        
        if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
            [self.delegate interstitialCustomEventWillAppear:self];
        }
        
        [viewController presentViewController:self.interstitial animated:YES completion:^{
            
            if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
                [self.delegate interstitialCustomEventDidAppear:self];
            }
        }];
        
        NSString *queryString = nil;
        NSString *keywords = nil;
        
        // Getting information if provided.
        if ([self.delegate respondsToSelector:@selector(interstitialCustomEventInformation:)]) {
            
            AFMedInfo *information = [self.delegate interstitialCustomEventInformation:self];
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
        
        XAdSlotConfiguration *configuration = [[XAdSlotConfiguration alloc] init];
        configuration.bannerRefreshInterval = 0;
        configuration.RTBRequired = NO;
        configuration.COPPAPermissions = YES;
        configuration.shouldOpenClickThroughURLInAppBrowser = YES;
        self.interstitial.slotConfiguration = configuration;
        
        // Pre-loading the interstitial.
        [self.interstitial loadWithDomainName:self.domainName pageName:self.pageName adPosition:self.adPosition keywords:keywords queryString:queryString];
    }
}

#pragma mark - XAdInterstitialViewControllerDelegate

- (void)xAdInterstitialDidLoad:(XAdInterstitialViewController *)interstitialAdViewController {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didLoadAd:interstitialAdViewController];
    }
}

- (void)xAdInterstitial:(XAdInterstitialViewController *)interstitialAdViewController didFailWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)xAdInterstitialDidReceiveNoAd:(XAdInterstitialViewController *)interstitialAdViewController {

    NSError *error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"Blank Ad received."}];
    [self xAdInterstitial:nil didFailWithError:error];
}

- (void)xAdInterstitialDidClick:(XAdInterstitialViewController *)interstitialAdViewController {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)]) {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    }
}

- (void)xAdInterstitialDidDismissOnMemoryWarning:(XAdInterstitialViewController *)interstitialAdViewController {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}

- (void)xAdInterstitialDismissed:(XAdInterstitialViewController *)interstitialAdViewController {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}

- (void)xAdInterstitialWillLeaveApplication:(XAdInterstitialViewController*)interstitialAdViewController {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillLeaveApplication:)]) {
        [self.delegate interstitialCustomEventWillLeaveApplication:self];
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
