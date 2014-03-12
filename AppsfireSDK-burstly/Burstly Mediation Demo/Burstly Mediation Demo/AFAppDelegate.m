//
//  AFAppDelegate.m
//  Burstly Mediation Demo
//
//  Created by Ali Karagoz on 29/10/2013.
//  Copyright (c) 2013 Appsfire. All rights reserved.
//

#import "AFAppDelegate.h"
#import "AFViewController.h"
#import "AppsfireSDK.h"
#import "AppsfireAdSDK.h"

@implementation AFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // View Controller
    AFViewController *viewController = [[AFViewController alloc] init];
    self.window.rootViewController = viewController;
    
    //-------------------
    // Appsfire SDK Setup
    //-------------------
#error Add your Appsfire API key below
    NSString *apiKey = @"";
    
    // The only mandatory code to use the Appsfire SDK if the connection to the API with your API Key.
    if ([AppsfireSDK connectWithAPIKey:apiKey afterDelay:1.0]) {
        NSLog(@"Appsfire Demo App launched with %@",[AppsfireSDK getAFSDKVersionInfo]);
    } else {
        NSLog(@"Unable to launch Appsfire Demo App. Probably incompatible iOS.");
    }
    
    // In the context of the ad mediation we will only use the monetization features.
    // If you plan to use both Monetization and Engage features of the SDK you should omit the following line.
    [AppsfireSDK setFeatures:AFSDKFeatureMonetization];
    
    //-----------------------
    // Appsfire Ad SDK Setup
    //-----------------------
    
#if DEBUG
#warning Replace by `NO` if you don't want to see test Ads in DEBUG mode.
    [AppsfireAdSDK setDebugModeEnabled:YES];
#endif
    
    // (Optional) Use In App Download.
    [AppsfireAdSDK setUseInAppDownloadWhenPossible:YES];
    
    // (Optional) Tell Ad SDK to prepare, this method is automatically called during a modal ad request.
    [AppsfireAdSDK prepare];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
