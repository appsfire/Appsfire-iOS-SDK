/*!
 *  @header    BurstlyAppsfireAdaptor.m
 *  @abstract  Appsfire Burstly Adaptor.
 *  @version   1.2
 */

/*
 Copyright 2010-2014 Appsfire SAS. All rights reserved.
 
 Redistribution and use in source and binary forms, without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY APPSFIRE SAS ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL APPSFIRE SAS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "BurstlyAppsfireAdaptor.h"
#import "BurstlyAppsfireInterstitial.h"
#import "AppsfireSDK.h"

@implementation BurstlyAppsfireAdaptor

#pragma mark - BurstlyAdNetworkAdaptorProtocol

- (id)initAdNetworkWithParams: (NSDictionary *)params {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (NSString *)adaptorVersion {
    return @"1.2";
}

- (NSString *)sdkVersion {
    return [AppsfireSDK getAFSDKVersionInfo];
}

- (BOOL)isIdiomSupported:(UIUserInterfaceIdiom)idiom {
    return YES;
}

- (BurstlyAdPlacementType)adPlacementTypeFor:(NSDictionary *)params {
    return BurstlyAdPlacementTypeInterstitial;
}

- (id<BurstlyAdBannerProtocol>)newBannerAdWithParams:(NSDictionary *)params andError:(NSError **)error {
    // Appsfire does not currently provide banner ads.
    return nil;
}

- (id<BurstlyAdInterstitialProtocol>)newInterstitialAdWithParams:(NSDictionary *)params andError:(NSError **)error {
    BurstlyAppsfireInterstitial *interstitial = [[BurstlyAppsfireInterstitial alloc] initWithParams:params];
    return interstitial;
}

@end
