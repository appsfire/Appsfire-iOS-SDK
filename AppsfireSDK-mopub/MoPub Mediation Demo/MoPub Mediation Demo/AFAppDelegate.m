//
//  AFAppDelegate.m
//  MoPub Mediation Demo
//
//  Created by Ali Karagoz on 17/10/2013.
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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
