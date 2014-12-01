/*!
 *  AFiAdBannerViewCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFiAdBannerViewCustomEvent.h"

// iAd
#import <iAd/iAd.h>

@protocol AFiAdBannerViewManagerObserver <NSObject>

- (void)bannerDidLoad;
- (void)bannerDidFailWithError:(NSError *)error;
- (void)bannerActionWillBeginAndWillLeaveApplication:(BOOL)willLeave;
- (void)bannerActionDidFinish;

@end

@interface AFiAdBannerViewManager : NSObject <ADBannerViewDelegate>

@property (nonatomic, strong) ADBannerView *bannerView;
@property (nonatomic, strong) NSMutableSet *observers;
@property (nonatomic, assign, getter = hasTrackedImpression) BOOL trackImpression;
@property (nonatomic, assign, getter = hasTrackedClick) BOOL trackClick;

+ (instancetype)sharedManager;
+ (void)addObserver:(id <AFiAdBannerViewManagerObserver>)observer;
+ (void)removeObserver:(id <AFiAdBannerViewManagerObserver>)observer;

@end

@interface AFiAdBannerViewCustomEvent () <AFiAdBannerViewManagerObserver>

@property (nonatomic, strong) ADBannerView *bannerView;

@end

@implementation AFiAdBannerViewCustomEvent

@synthesize delegate;

#pragma mark - Dealloc

- (void)dealloc {
    self.bannerView = nil;
}

#pragma mark - AFMedBannerViewCustomEvent

- (void)requestBannerViewWithSize:(CGSize)size customEventParameters:(NSDictionary *)parameters {
    
    [AFiAdBannerViewManager addObserver:self];
    
    if (self.bannerView.isBannerLoaded) {
        [self bannerDidLoad];
    }
}

- (BOOL)shouldManuallyTrackEvents {
    return YES;
}

- (void)invalidate {
    [AFiAdBannerViewManager removeObserver:self];
}

- (void)rotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    if ([self.bannerView respondsToSelector:@selector(setCurrentContentSizeIdentifier:)]) {
        self.bannerView.currentContentSizeIdentifier = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? ADBannerContentSizeIdentifierPortrait : ADBannerContentSizeIdentifierLandscape;
    }
}

- (void)trackImpressionIfNeeded {
    
    BOOL hasTrackedImpression = [AFiAdBannerViewManager sharedManager].hasTrackedImpression;
    if (!hasTrackedImpression) {
        
        [AFiAdBannerViewManager sharedManager].trackImpression = YES;
        if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventTrackImpression:)]) {
            [self.delegate bannerViewCustomEventTrackImpression:self];
        }
    }
}

- (void)trackClickIfNecessary {
    
    BOOL hasTrackedClick = [AFiAdBannerViewManager sharedManager].hasTrackedClick;
    if (!hasTrackedClick) {
        
        [AFiAdBannerViewManager sharedManager].trackClick = YES;
        if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventTrackClick:)]) {
            [self.delegate bannerViewCustomEventTrackClick:self];
        }
    }
}

#pragma mark - AFiAdBannerViewManagerObserver

- (void)bannerDidLoad {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didLoadAd:)]) {
        [self.delegate bannerViewCustomEvent:self didLoadAd:self.bannerView];
    }
    
    [self trackImpressionIfNeeded];
}

- (void)bannerDidFailWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEvent:didFailToLoadAdWithError:)]) {
        [self.delegate bannerViewCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)bannerActionWillBeginAndWillLeaveApplication:(BOOL)willLeave {
    
    if (willLeave) {
        
        if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventWillLeaveApplication:)]) {
            [self.delegate bannerViewCustomEventWillLeaveApplication:self];
        }
        
    } else {
        
        if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventBeginOverlayPresentation:)]) {
            [self.delegate bannerViewCustomEventBeginOverlayPresentation:self];
        }
    }
    
    [self trackClickIfNecessary];
}

- (void)bannerActionDidFinish {
    
    if ([self.delegate respondsToSelector:@selector(bannerViewCustomEventEndOverlayPresentation:)]) {
        [self.delegate bannerViewCustomEventEndOverlayPresentation:self];
    }
}

#pragma mark - Accessors

- (ADBannerView *)bannerView {
    return [AFiAdBannerViewManager sharedManager].bannerView;
}

@end

@implementation AFiAdBannerViewManager

#pragma mark - Static

+ (void)addObserver:(id <AFiAdBannerViewManagerObserver>)observer {
    [[AFiAdBannerViewManager sharedManager] addObserver:observer];
}

+ (void)removeObserver:(id <AFiAdBannerViewManagerObserver>)observer {
    [[AFiAdBannerViewManager sharedManager] removeObserver:observer];
}

#pragma mark - Init & Dealloc

+ (instancetype)sharedManager {
    static id sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _bannerView = [[ADBannerView alloc] init];
    _observers = [NSMutableSet set];
    _bannerView.delegate = self;
    
    return self;
}

- (void)dealloc {
    self.bannerView.delegate = nil;
    self.bannerView = nil;
}

#pragma mark - Adding / Removing observers

- (void)addObserver:(id <AFiAdBannerViewManagerObserver>)observer {
    
    @synchronized(self.observers) {
        [self.observers addObject:observer];
    }
}

- (void)removeObserver:(id <AFiAdBannerViewManagerObserver>)observer {
    
    @synchronized(self.observers) {
        [self.observers removeObject:observer];
    }
}

#pragma mark - ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    self.trackClick = NO;
    self.trackImpression = NO;
    
    @synchronized(self.observers) {
        for (id <AFiAdBannerViewManagerObserver> observer in self.observers) {
            if ([observer respondsToSelector:@selector(bannerDidLoad)]) {
                [observer bannerDidLoad];
            }
        }
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    
    @synchronized(self.observers) {
        for (id <AFiAdBannerViewManagerObserver> observer in self.observers) {
            if ([observer respondsToSelector:@selector(bannerDidFailWithError:)]) {
                [observer bannerDidFailWithError:error];
            }
        }
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    
    @synchronized(self.observers) {
        for (id <AFiAdBannerViewManagerObserver> observer in self.observers) {
            if ([observer respondsToSelector:@selector(bannerActionWillBeginAndWillLeaveApplication:)]) {
                [observer bannerActionWillBeginAndWillLeaveApplication:willLeave];
            }
        }
    }
    
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    
    @synchronized(self.observers) {
        for (id <AFiAdBannerViewManagerObserver> observer in self.observers) {
            if ([observer respondsToSelector:@selector(bannerActionDidFinish)]) {
                [observer bannerActionDidFinish];
            }
        }
    }
}

@end
