//
// BurstlyInstalledAppsTracker.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BurstlyInstalledAppsTrackerDelegate.h"

// Checks whether applications are installed on current device and reports this info to Burstly server.
@interface BurstlyInstalledAppsTracker : NSObject {
}

// Checks whether applications are installed on current device and reports this info to Burstly server.
// appURLS - array of application URL strings. for example:
// [NSArray arrayWithObjects:@"tel:", @"farmville-0:", @"http:", nil];
//
// returns dictionary where keys are URL strings from appURLs, 
// values are instances of NSNumber class containing bool value, 
// which is YES if application with a given URL is installed on current device; NO otherwise.
+ (NSDictionary *)checkInstalledApps:(NSArray *)appURLs;

// Loads list of apps to check and check them
// Receives publisher ID
+ (void)loadListAndCheckInstalledApps:(NSString *)publisherId;
+ (void)loadListAndCheckInstalledAppsWithPubId:(NSString *)publisherId andDelegate:(id<BurstlyInstalledAppsTrackerDelegate>) delegate;

@end
