//
// BurstlyInstalledAppsTrackerDelegate.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BurstlyInstalledAppsTrackerDelegate <NSObject>

@optional
- (void) installedAppsTrackerDidLoadAppList:(NSArray*) appList;
- (void) installedAppsTrackerDidFailToLoadAppList:(NSError*) error; 
@end
