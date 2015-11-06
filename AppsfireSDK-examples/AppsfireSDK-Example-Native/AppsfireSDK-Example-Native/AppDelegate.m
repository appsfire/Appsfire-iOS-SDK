//
//  AppDelegate.m
//  AppsfireSDK-Example-Native
//
//  Created by Vincent on 09/04/2015.
//  Copyright (c) 2015 appsfire. All rights reserved.
//

#import "AppDelegate.h"
// helpers
#import "AppsfireSDK.h"
#import "AppsfireAdSDK.h"
// controllers
#import "ViewController.h"

@interface AppDelegate() <AppsfireAdSDKDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSError *error;
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    /*
     *  Appsfire
     */
    
    // set ad delegate
    [AppsfireAdSDK setDelegate:self];
    
    // enable debug mode for testing
    #if DEBUG
        #warning In Release mode, make sure to set the value below to NO.
        [AppsfireAdSDK setDebugModeEnabled:YES];
    #endif
    
    // sdk connect
    // Use your own Appsfire App ID below
    error = [AppsfireSDK connectWithAppId:@"3180317" parameters:nil];
    if (error != nil)
        NSLog(@"Unable to initialize Appsfire SDK (%@)", error);
    
    /*
     * UI Implementation
     */
    
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // main controller
    self.mainViewController = [[ViewController alloc] init];
    
    //
    self.window.rootViewController = self.mainViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

#pragma Appsfire Ad SDK Delegate

- (void)nativeAdsRefreshedAndAvailable {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    // refresh statutes
    [self.mainViewController refreshStatutes];

    // refresh native ad
    [self.mainViewController refreshNativeAd];
    
}

- (void)nativeAdsRefreshedAndNotAvailable {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    // refresh statutes
    [self.mainViewController refreshStatutes];
    
}

@end
