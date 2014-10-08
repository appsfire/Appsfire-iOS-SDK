/*!
 *  AFChartboostInterstitialCustomEvent.m
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFChartboostInterstitialCustomEvent.h"

// Chartboost
#import <Chartboost/Chartboost.h>

#error Please provide your Chartboost information below.
static NSString *const AFChartboostAppId = @"<CHARTBOOST_APP_ID>";
static NSString *const AFChartboostAppSignature = @"<CHARTBOOST_APP_SIGNATURE>";

#pragma mark - AFChartboostDispatcher Interface
#pragma mark -

@protocol AFChartboostDispatcherDelegate;
@interface AFChartboostDispatcher : NSObject <ChartboostDelegate>

@property (nonatomic, strong) NSMutableDictionary *locations;

+ (instancetype)sharedDispatcher;
+ (void)addLocation:(NSString *)location forEvent:(AFChartboostInterstitialCustomEvent *)event;
+ (void)removeLocation:(NSString *)location;

@end

@protocol AFChartboostDispatcherDelegate <NSObject>

- (void)chartboostDispatcher:(AFChartboostDispatcher *)dispatcher didLoadAd:(id)ad;
- (void)chartboostDispatcher:(AFChartboostDispatcher *)dispatcher didFailToLoadAdWithError:(NSError *)error;
- (void)chartboostDispatcherWillAppear:(AFChartboostDispatcher *)dispatcher;
- (void)chartboostDispatcherDidAppear:(AFChartboostDispatcher *)dispatcher;
- (void)chartboostDispatcherWillDisappear:(AFChartboostDispatcher *)dispatcher;
- (void)chartboostDispatcherDidDisappear:(AFChartboostDispatcher *)dispatcher;
- (void)chartboostDispatcherDidReceiveTapEvent:(AFChartboostDispatcher *)dispatcher;

@end

#pragma mark - AFChartboostInterstitialCustomEvent Extension
#pragma mark -

@interface AFChartboostInterstitialCustomEvent () <AFChartboostDispatcherDelegate>

@property (nonatomic, copy) NSString *location;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

#pragma mark - AFChartboostInterstitialCustomEvent Implementation
#pragma mark -

@implementation AFChartboostInterstitialCustomEvent

@synthesize delegate;

- (void)dealloc {
    [AFChartboostDispatcher removeLocation:self.location];
    self.location = nil;
}

#pragma mark - AFMedInterstitialCustomEvent

- (void)requestInterstitialWithCustomParameters:(NSDictionary *)parameters {

    self.delegateAlreadyNotified = NO;
    
    // Parameters parsing.
    self.location = [self parseLocation:parameters];
    NSError *error;
    
    // Are the parameters valid?
    if (![self.location isKindOfClass:NSString.class]) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct payload."}];
    }
    
    // If there is an error.
    if (error) {
        [self chartboostDispatcher:nil didFailToLoadAdWithError:error];
        return;
    }
    
    [AFChartboostDispatcher addLocation:self.location forEvent:self];
    [Chartboost cacheInterstitial:self.location];
}

- (void)presentInterstitialFromViewController:(UIViewController *)viewController {
    
    // If it has an interstitial, present it.
    if ([Chartboost hasInterstitial:self.location]) {
        [Chartboost showInterstitial:self.location];
    }
}

#pragma mark - AFCharboostDispatcherDelegate

- (void)chartboostDispatcher:(AFChartboostDispatcher *)dispatcher didLoadAd:(id)ad {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didLoadAd:ad];
    }
}

- (void)chartboostDispatcher:(AFChartboostDispatcher *)dispatcher didFailToLoadAdWithError:(NSError *)error {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)chartboostDispatcherWillAppear:(AFChartboostDispatcher *)dispatcher {

    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
        [self.delegate interstitialCustomEventWillAppear:self];
    }
}

- (void)chartboostDispatcherDidAppear:(AFChartboostDispatcher *)dispatcher {

    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
        [self.delegate interstitialCustomEventDidAppear:self];
    }
}

- (void)chartboostDispatcherWillDisappear:(AFChartboostDispatcher *)dispatcher {

    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
}

- (void)chartboostDispatcherDidDisappear:(AFChartboostDispatcher *)dispatcher {

    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
}

- (void)chartboostDispatcherDidReceiveTapEvent:(AFChartboostDispatcher *)dispatcher {

    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)]) {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self];
    }
}

#pragma mark - Parameters

- (NSString *)parseLocation:(NSDictionary *)parameters {
    
    if (![parameters isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    NSString *location = parameters[@"location"];
    if ([location isKindOfClass:NSString.class]) {
        return location;
    }
    
    return nil;
}

@end

#pragma mark - ChartboostDispatcher Implementation
#pragma mark -

@implementation AFChartboostDispatcher

#pragma mark - Init

+ (instancetype)sharedDispatcher {

    static id sharedDispatcher = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDispatcher = [[self alloc] init];
    });
    
    return sharedDispatcher;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    // Initialization of the Chartboost SDK.
    [Chartboost startWithAppId:AFChartboostAppId appSignature:AFChartboostAppSignature delegate:self];
    [Chartboost setAutoCacheAds:NO];
    
    return self;
}

#pragma mark - Public Methods

+ (void)addLocation:(NSString *)location forEvent:(AFChartboostInterstitialCustomEvent *)event {
    [[self.class sharedDispatcher] addLocation:location forEvent:event];
}

+ (void)removeLocation:(NSString *)location {
    [[self.class sharedDispatcher] removeLocation:location];
}

#pragma mark - Adding / Removing Locations

- (void)addLocation:(NSString *)location forEvent:(AFChartboostInterstitialCustomEvent *)event {
    
    // Sanity checks.
    if (![location isKindOfClass:NSString.class] && location.length <= 0) {
        return;
    }
    
    if (![event isKindOfClass:AFChartboostInterstitialCustomEvent.class]) {
        return;
    }
    
    if ([self.locations objectForKey:location] != nil) {
    
        if ([event respondsToSelector:@selector(chartboostDispatcher:didFailToLoadAdWithError:)]) {
            NSError *error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"This location is already in use."}];
            [event chartboostDispatcher:self didFailToLoadAdWithError:error];
        }
        
        return;
    }
    
    @synchronized(self.locations) {
        [self.locations setObject:event forKey:location];
    };
}

- (void)removeLocation:(NSString *)location {
    
    // Sanity checks.
    if (![location isKindOfClass:NSString.class] && location.length <= 0) {
        return;
    }
    
    @synchronized(self.locations) {
        [self.locations removeObjectForKey:location];
    };
}

- (AFChartboostInterstitialCustomEvent *)eventForLocation:(NSString *)location {
    
    // Sanity checks.
    if (![location isKindOfClass:NSString.class] && location.length <= 0) {
        return nil;
    }
    
    @synchronized(self.locations) {
        return [self.locations objectForKey:location];
    }
}

#pragma mark - Accessors

- (NSMutableDictionary *)locations {
    if (!_locations) {
        _locations = [NSMutableDictionary dictionary];
    }
    return _locations;
}

#pragma mark - ChartboostDelegate

- (void)didCacheInterstitial:(CBLocation)location {
    
    id <AFChartboostDispatcherDelegate> event = [self eventForLocation:location];
    
    // Did load.
    if ([event respondsToSelector:@selector(chartboostDispatcher:didLoadAd:)]) {
        [event chartboostDispatcher:self didLoadAd:nil];
    }
}

- (void)didFailToLoadInterstitial:(CBLocation)location withError:(CBLoadError)error {
   
    id <AFChartboostDispatcherDelegate> event = [self eventForLocation:location];
    
    // Did fail to load.
    if ([event respondsToSelector:@selector(chartboostDispatcher:didFailToLoadAdWithError:)]) {
        
        NSError *e = [NSError errorWithDomain:@"com.appsfire.sdk" code:error userInfo:@{NSLocalizedDescriptionKey : @"Chartboost failed to load ad."}];
        [event chartboostDispatcher:self didFailToLoadAdWithError:e];
    }
    
    [AFChartboostDispatcher removeLocation:location];
}

- (void)didDisplayInterstitial:(CBLocation)location {
    
    id <AFChartboostDispatcherDelegate> event = [self eventForLocation:location];
    
    // Will appear.
    if ([event respondsToSelector:@selector(chartboostDispatcherWillAppear:)]) {
        [event chartboostDispatcherWillAppear:self];
    }
    
    // Did appear.
    if ([event respondsToSelector:@selector(chartboostDispatcherDidAppear:)]) {
        [event chartboostDispatcherDidAppear:self];
    }
}

- (void)didDismissInterstitial:(CBLocation)location {
    
    id <AFChartboostDispatcherDelegate> event = [self eventForLocation:location];
    
    // Will disappear.
    if ([event respondsToSelector:@selector(chartboostDispatcherWillDisappear:)]) {
        [event chartboostDispatcherWillDisappear:self];
    }
    
    // Did disappear.
    if ([event respondsToSelector:@selector(chartboostDispatcherDidDisappear:)]) {
        [event chartboostDispatcherDidDisappear:self];
    }
    
    [AFChartboostDispatcher removeLocation:location];
}

- (void)didClickInterstitial:(CBLocation)location {
    
    id <AFChartboostDispatcherDelegate> event = [self eventForLocation:location];
    
    // Did tap.
    if ([event respondsToSelector:@selector(chartboostDispatcherDidReceiveTapEvent:)]) {
        [event chartboostDispatcherDidReceiveTapEvent:self];
    }
}

@end