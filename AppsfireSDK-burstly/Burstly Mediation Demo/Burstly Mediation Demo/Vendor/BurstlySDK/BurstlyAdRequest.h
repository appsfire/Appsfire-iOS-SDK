//
// BurstlyAdRequest.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BurstlyUserInfo.h"

FOUNDATION_EXPORT NSString *const BurstlyInfoNetwork;
FOUNDATION_EXPORT NSString *const BurstlyInfoError;
FOUNDATION_EXPORT NSString *const BurstlyInfoFailedNetworks;
FOUNDATION_EXPORT NSString *const BurstlyInfoMinimumTimeToNextRequest;
FOUNDATION_EXPORT NSString *const BurstlyInfoIsRequestThrottled;
FOUNDATION_EXPORT NSString *const BurstlyInfoIsCachedRequestFailed;

// Use BurstlyTestAdNetwork to force requests to point to 
// a specific ad network that would otherwise be mediated.
// Should be used in testing mode only. Works only on 
// the simulator. 
typedef enum {
    kBurstlyTestAdmob,
    kBurstlyTestGreystripe,
    kBurstlyTestInmobi,
    kBurstlyTestIad,
    kBurstlyTestJumptap,
    kBurstlyTestMillennial,
    kBurstlyTestRewards
} BurstlyTestAdNetwork;

extern NSString * const BurstlyErrorDomain;

// NSError codes for Burstly error domain.
typedef enum {
    // The ad request is invalid. This is most likely due to
    // an invalid appId/zoneId or an invalid reference
    // to your top-most view controller. Refer to the
    // NSLocalizedDescriptionKey in the userInfo dictionary
    // for more details.
    BurstlyErrorInvalidRequest,
    
    // The server returned no ads for this zone. Contact
    // your Burstly admin with the errant zoneid for more details.
    BurstlyErrorNoFill,
    
    // There was an error loading data due to network delays
    BurstlyErrorNetworkFailure,
    
    // The AdServer experienced an error eg.server timeout
    BurstlyErrorServerError,
    
    // The timeout you specified via the requestTimeout property
    // has fired.
    BurstlyErrorInterstitialTimedOut,
    
    // The request was throttled. This happens when you send
    // back to back requests within an extremely short time
    // interval.
    BurstlyErrorRequestThrottled,
    
    // The Banner/Interstitial was misconfigured.
    BurstlyErrorConfigurationError
} BurstlyError;


@interface BurstlyAdRequest : NSObject
{
    BurstlyTestAdNetwork _integrationModeAdNetwork;
    BOOL _integrationMode;
}

@property (nonatomic,retain) BurstlyUserInfo *userInfo;

// Used to transmit custom publisher targeting data key-value pairs
// back to the ad server. This string should represent a set
// of comma-delimited key-value pairs that can consist of integer,
// float, or string (must be single-quote delimited) values.
// - (NSString *)pubTargeting {
//    return @"gender='m',age=21";
// }
@property (nonatomic, retain) NSString *targetingParameters;

// Used to transmit custom creative-specific data key-value pairs
// to customize landing page URLs back to the ad server. This string 
// should represent a set of comma-delimited key-value pairs
//  that can consist of integer, float, or string
//  (must be single-quote delimited) values.
@property (nonatomic, retain) NSString *adParameters;

@property (nonatomic, readwrite) CGSize bannerSize;

@property (nonatomic, readwrite) CGSize bannerSizeRange;

// Returns an auto-released BurstlyAdRequest
+ (BurstlyAdRequest *)request;

- (NSString *)integrationModeAppId;
- (void)setIntegrationModeWithTestNetwork:(BurstlyTestAdNetwork)aTestNetwork filterAdvertisingIdentifiers:(NSArray *)advertisingIdentifiers;

// Mediated ad-networks may have additional parameters they accept. To pass these
// parameters to them, create a dictionary object with the appropriate key-value
// as detailed here. All networks will have access to the basic settings
// you've set in the BurstlyUserInfo class.
// (gender, age, zip-code, etc.).
// Note: This feature is reserved for future use and supports only the
// MediaBrix network at this time.
- (void)setCustomParamsForNetwork:(NSString*)network withDictionary:(NSDictionary*)params;

@end
