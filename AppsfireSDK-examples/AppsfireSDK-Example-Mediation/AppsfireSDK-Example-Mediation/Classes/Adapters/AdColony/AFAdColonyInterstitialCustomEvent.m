/*!
 *  AFAdColonyInterstitialCustomEvent.h
 *  Copyright (c) 2014 Appsfire. All rights reserved.
 */

#import "AFAdColonyInterstitialCustomEvent.h"

// AdColony
#import <AdColony/AdColony.h>

#error Please provide your AdColony App Id below.
static NSString *const AFAdColonyAppId = @"<ADCOLONY_APP_ID>";

#error Please provide your Zone Ids below.
// Zone Ids should be separated by comas without any white space.
static NSString *const AFAdColonyAvailableZoneIds = @"<ZONE_ID_1>,<ZONE_ID_2>,<ZONE_ID_3>";

#pragma mark - AFadColonyDispatcher Interface
#pragma mark -

@protocol AFAdColonyDispatcherDelegate;
@interface AFAdColonyDispatcher : NSObject <AdColonyDelegate>

@property (nonatomic, strong) NSMutableDictionary *zones;

+ (instancetype)sharedDispatcher;
+ (void)addZone:(NSString *)zone forEvent:(AFAdColonyInterstitialCustomEvent *)event;
+ (void)removeZone:(NSString *)zone;
+ (BOOL)embedeedZonesContainZone:(NSString *)zone;

@end

@protocol AFAdColonyDispatcherDelegate <NSObject>

- (void)adColonyDispatcher:(AFAdColonyDispatcher *)dispatcher didLoadAd:(id)ad;
- (void)adColonyDispatcher:(AFAdColonyDispatcher *)dispatcher didFailToLoadAdWithError:(NSError *)error;
- (void)adColonyDispatcherDidExpire:(AFAdColonyDispatcher *)dispatcher;

@end

#pragma mark - AFAdColonyInterstitialCustomEvent Extension
#pragma mark -

@interface AFAdColonyInterstitialCustomEvent () <AdColonyAdDelegate, AFAdColonyDispatcherDelegate>

@property (nonatomic, copy) NSString *zoneId;
@property (nonatomic, assign, getter = isDelegateAlreadyNotified) BOOL delegateAlreadyNotified;

@end

#pragma mark - AFAdColonyInterstitialCustomEvent Implementation
#pragma mark -

@implementation AFAdColonyInterstitialCustomEvent

@synthesize delegate;

- (void)dealloc {
    [AFAdColonyDispatcher removeZone:self.zoneId];
    self.zoneId = nil;
}

#pragma mark - AFMedInterstitialCustomEvent

- (void)requestInterstitialWithCustomParameters:(NSDictionary *)parameters {
    
    self.delegateAlreadyNotified = NO;
    
    // Parameters parsing.
    self.zoneId = [self parseZoneId:parameters];
    NSError *error;
    
    // Are the parameters valid?
    if (![self.zoneId isKindOfClass:NSString.class]) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The server parameters did not return a correct payload."}];
    }
    
    // If the received zone is not in the list of the zones, then we fire an error.
    if (![AFAdColonyDispatcher embedeedZonesContainZone:self.zoneId]) {
        error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The received Zone is not part of the embedeed zones."}];
    }
    
    // If there is an error.
    if (error) {
        [self adColonyDispatcher:nil didFailToLoadAdWithError:error];
        return;
    }
    
    [AFAdColonyDispatcher addZone:self.zoneId forEvent:self];
    
    [self checkZoneAvailability];
}

- (void)checkZoneAvailability {

    NSError *error;
    ADCOLONY_ZONE_STATUS zoneStatus = [AdColony zoneStatusForZone:self.zoneId];
    switch (zoneStatus) {
            
        case ADCOLONY_ZONE_STATUS_NO_ZONE : {} break;
        case ADCOLONY_ZONE_STATUS_LOADING : {} break;
        case ADCOLONY_ZONE_STATUS_OFF : {
            
            error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The received Zone is not part of the embedeed zones."}];
            [self adColonyDispatcher:nil didFailToLoadAdWithError:error];
            
        } break;
            
        case ADCOLONY_ZONE_STATUS_ACTIVE : {
            [self adColonyDispatcher:nil didLoadAd:nil];
        } break;
            
        case ADCOLONY_ZONE_STATUS_UNKNOWN : {
            
            error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"The status for the given zone is unknown."}];
            [self adColonyDispatcher:nil didFailToLoadAdWithError:error];
            
        } break;
    }
}

- (void)presentInterstitialFromViewController:(UIViewController *)viewController {
    
    ADCOLONY_ZONE_STATUS zoneStatus = [AdColony zoneStatusForZone:self.zoneId];
    if (zoneStatus == ADCOLONY_ZONE_STATUS_ACTIVE) {
        
        if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
            [self.delegate interstitialCustomEventWillAppear:self];
        }
        
        [AdColony playVideoAdForZone:self.zoneId withDelegate:self];
    }
}

#pragma mark - Parameters

- (NSString *)parseZoneId:(NSDictionary *)parameters {
    
    if (![parameters isKindOfClass:NSDictionary.class]) {
        return nil;
    }
    
    NSString *zoneId = parameters[@"zoneId"];
    if ([zoneId isKindOfClass:NSString.class]) {
        return zoneId;
    }
    
    return nil;
}

#pragma mark - AdColonyAdDelegate

- (void)onAdColonyAdStartedInZone:(NSString *)zoneID {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
        [self.delegate interstitialCustomEventDidAppear:self];
    }
}

- (void)onAdColonyAdAttemptFinished:(BOOL)shown inZone:(NSString *)zoneID {

    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self];
    }
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self];
    }
    
    [AFAdColonyDispatcher removeZone:self.zoneId];
}

#pragma mark - AFAdColonyDispatcherDelegate

- (void)adColonyDispatcher:(AFAdColonyDispatcher *)dispatcher didLoadAd:(id)ad {

    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didLoadAd:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didLoadAd:ad];
    }
}

- (void)adColonyDispatcher:(AFAdColonyDispatcher *)dispatcher didFailToLoadAdWithError:(NSError *)error {

    if ([self.delegate respondsToSelector:@selector(interstitialCustomEvent:didFailToLoadAdWithError:)] && !self.isDelegateAlreadyNotified) {
        self.delegateAlreadyNotified = YES;
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}

- (void)adColonyDispatcherDidExpire:(AFAdColonyDispatcher *)dispatcher {
    
    if ([self.delegate respondsToSelector:@selector(interstitialCustomEventDidExpire:)]) {
        [self.delegate interstitialCustomEventDidExpire:self];
    }
}

@end

#pragma mark - adColonyDispatcher Implementation
#pragma mark -

@implementation AFAdColonyDispatcher

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
    
    // Initialization of the AdColony SDK.
    [AdColony configureWithAppID:AFAdColonyAppId zoneIDs:[self availableZoneIds] delegate:self logging:NO];
    
    return self;
}

#pragma mark - Public Methods

+ (void)addZone:(NSString *)zone forEvent:(AFAdColonyInterstitialCustomEvent *)event {
    [[self.class sharedDispatcher] addZone:zone forEvent:event];
}

+ (void)removeZone:(NSString *)zone {
    [[self.class sharedDispatcher] removeZone:zone];
}

+ (BOOL)embedeedZonesContainZone:(NSString *)zone {
    
    // Sanity checks.
    if (![zone isKindOfClass:NSString.class] && zone.length <= 0) {
        return NO;
    }
    
    NSArray *availableZoneIds = [AFAdColonyAvailableZoneIds componentsSeparatedByString:@","];
    if (![availableZoneIds isKindOfClass:NSArray.class]) {
        return NO;
    }
    
    for (NSString *z in availableZoneIds) {
        if ([z respondsToSelector:@selector(isEqualToString:)] && [z isEqualToString:zone]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Adding / Removing Locations

- (void)addZone:(NSString *)zone forEvent:(AFAdColonyInterstitialCustomEvent *)event {
    
    // Sanity checks.
    if (![zone isKindOfClass:NSString.class] && zone.length <= 0) {
        return;
    }
    
    if (![event isKindOfClass:AFAdColonyInterstitialCustomEvent.class]) {
        return;
    }
    
    if ([self.zones objectForKey:zone] != nil) {
        
        if ([event respondsToSelector:@selector(adColonyDispatcher:didFailToLoadAdWithError:)]) {
            NSError *error = [NSError errorWithDomain:@"com.appsfire.sdk" code:0 userInfo:@{NSLocalizedDescriptionKey : @"This location is already in use."}];
            [event adColonyDispatcher:self didFailToLoadAdWithError:error];
        }
        
        return;
    }
    
    @synchronized(self.zones) {
        [self.zones setObject:event forKey:zone];
    };
}

- (void)removeZone:(NSString *)zone {
    
    // Sanity checks.
    if (![zone isKindOfClass:NSString.class] && zone.length <= 0) {
        return;
    }
    
    @synchronized(self.zones) {
        [self.zones removeObjectForKey:zone];
    };
}

- (AFAdColonyInterstitialCustomEvent *)eventForZone:(NSString *)zone {
    
    // Sanity checks.
    if (![zone isKindOfClass:NSString.class] && zone.length <= 0) {
        return nil;
    }
    
    @synchronized(self.zones) {
        return [self.zones objectForKey:zone];
    }
}

#pragma mark - 

- (void)onAdColonyAdAvailabilityChange:(BOOL)available inZone:(NSString *)zoneID {
    
    AFAdColonyInterstitialCustomEvent *event = [self eventForZone:zoneID];
    
    if(available) {
        
        if ([event respondsToSelector:@selector(adColonyDispatcher:didLoadAd:)]) {
            [event adColonyDispatcher:self didLoadAd:nil];
        }
    }
    
    else {
        
        if ([event respondsToSelector:@selector(adColonyDispatcherDidExpire:)]) {
            [event adColonyDispatcherDidExpire:self];
        }
    }
}

#pragma mark - Accessors

- (NSArray *)availableZoneIds {
    NSArray *availableZoneIds = [AFAdColonyAvailableZoneIds componentsSeparatedByString:@","];
    if ([availableZoneIds isKindOfClass:NSArray.class]) {
        return availableZoneIds;
    }
    
    return nil;
}

- (NSMutableDictionary *)zones {
    if (!_zones) {
        _zones = [NSMutableDictionary dictionary];
    }
    return _zones;
}

@end