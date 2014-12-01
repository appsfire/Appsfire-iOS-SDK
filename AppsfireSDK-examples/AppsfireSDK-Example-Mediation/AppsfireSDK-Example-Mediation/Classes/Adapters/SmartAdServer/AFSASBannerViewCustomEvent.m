/*!
 *  AFSASBannerViewCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFSASBannerViewCustomEvent.h"

// Smart Ad Server
#import "SASBannerView.h"
#import "AFSASCustomEventViewController.h"

@interface AFSASBannerViewCustomEvent () <AFSASCustomEventViewControllerBannerDelegate>

@property (nonatomic, copy) NSNumber *formatId;
@property (nonatomic, copy) NSString *pageId;
@property (nonatomic, strong) SASBannerView *bannerView;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

@implementation AFSASBannerViewCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    self.bannerView.delegate = nil;
    self.delegate = nil;
    self.bannerView = nil;
    self.formatId = nil;
    self.pageId = nil;
}

#pragma mark - AFMedBannerViewCustomEvent

- (void)requestBannerViewWithSize:(CGSize)size customEventParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;
    
    // Extracting parameters from the info payload.
    BOOL areParametersValid = [self parseParameters:parameters];
    UIViewController <SASAdViewDelegate> *viewController = [self viewControllerDelegate];
    NSError *error;
    
    // Are the parameters valid?
    if (!areParametersValid) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct payload."}];
    }
    
    // Is the returned view controller valid?
    else if (![viewController isKindOfClass:UIViewController.class]) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The view controller returned by the delegate is not of UIViewController type."}];
    }
    
    // If there is an error.
    if (error) {
        [self customEventViewController:nil didFailToLoadAdWithError:error];
        return;
    }
    
    self.bannerView = [[SASBannerView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    // Setting the location if provided.
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventInformation:)]) {
        
        AFMedInfo *information = [self.delegate bannerViewCustomEventInformation:self];
        if (information.location) {
            CLLocation *location = [[CLLocation alloc] initWithLatitude:information.location.latitude longitude:information.location.longitude];
            [SASAdView setLocation:location];
        }
    }
    
    self.bannerView.delegate = viewController;
    [self setBannerDelegate:self];
    
    // Start loading.
	[self.bannerView loadFormatId:[self.formatId integerValue] pageId:self.pageId master:YES target:nil];
}

#pragma mark - AFSASCustomEventViewControllerBannerDelegate

- (void)customEventViewController:(AFSASCustomEventViewController *)customEventViewController didLoadAd:(id)ad {
	
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didLoadAd:ad];
    }
}

- (void)customEventViewController:(AFSASCustomEventViewController *)customEventViewController didFailToLoadAdWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (UIViewController *)viewControllerForCustomEventViewController:(AFSASCustomEventViewController *)customEventViewController {
    return self.bannerView.delegate;
}

- (void)customEventViewControllerBeginOverlayPresentation:(AFSASCustomEventViewController *)customEventViewController {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventBeginOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventBeginOverlayPresentation:self];
    }
}

- (void)customEventViewControllerEndOverlayPresentation:(AFSASCustomEventViewController *)customEventViewController {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventEndOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventEndOverlayPresentation:self];
    }
}

- (void)customEventViewControllerWillLeaveApplication:(AFSASCustomEventViewController *)customEventViewController {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventWillLeaveApplication:)]) {
        [self.delegate bannerViewCustomEventWillLeaveApplication:self];
    }
}

#pragma mark - Misc

- (UIViewController <SASAdViewDelegate> *)viewControllerDelegate {
    return (id)[self.delegate viewControllerForBannerViewCustomEvent:self];
}

- (void)setBannerDelegate:(id <AFSASCustomEventViewControllerBannerDelegate>)bannerDelegate {
    if ([self.bannerView.delegate isKindOfClass:AFSASCustomEventViewController.class]) {
        ((AFSASCustomEventViewController *)self.bannerView.delegate).bannerDelegate = bannerDelegate;
    }
}

#pragma mark - Parameters

- (BOOL)parseParameters:(NSDictionary *)parameters {
    
    if (![parameters isKindOfClass:NSDictionary.class]) {
        return NO;
    }
    
    id component;
    
    // formatId
    component = parameters[@"formatId"];
    if ([component isKindOfClass:NSNumber.class]) {
        self.formatId = component;
    } else {
        return NO;
    }
    
    // pageId
    component = parameters[@"pageId"];
    if ([component isKindOfClass:NSString.class] && [(NSString *)component length] > 0) {
        self.pageId = component;
    } else {
        return NO;
    }
    
    return YES;
}

@end
