//
//  AFAppDelegate.m
//  Appsfire SDK Demo
//
//  Created by Vincent on 19/06/14.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AppDelegate.h"
// helpers
#import "AppsfireSDK.h"
#import "AppsfireAdSDK.h"
// controllers
#import "AppNavigationController.h"
#import "AppTableViewController.h"

@interface AppDelegate() <AppsfireAdSDKDelegate>

@end

@implementation AppDelegate

#pragma mark - Monitoring App State Changes

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSError *error;
    
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
    #error Add your Appsfire SDK Token below.
    error = [AppsfireSDK connectWithSDKToken:@"" features:AFSDKFeatureMonetization parameters:nil];
    if (error != nil)
        NSLog(@"Unable to initialize Appsfire SDK (%@)", error);
    
    /*
     * UI Implementation
     */
    
    // window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // main table view controller
    self.tableViewController = [[AppTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    // navigation controller
    self.navigationController = [[AppNavigationController alloc] initWithRootViewController:self.tableViewController];
    
    //
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

#pragma mark - Appsfire Ad SDK Delegate

- (void)modalAdsRefreshedAndAvailable {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    // if you want to show ads as soon as they are ready, uncomment the following lines.
    /*
    if ([AppsfireAdSDK isThereAModalAdAvailableForType:AFAdSDKModalTypeUraMaki] == AFAdSDKAdAvailabilityYes && ![AppsfireAdSDK isModalAdDisplayed])
         [AppsfireAdSDK requestModalAd:AFAdSDKModalTypeSushi withController:[UIApplication sharedApplication].keyWindow.rootViewController withDelegate:nil];
    */
    
}

- (void)modalAdsRefreshedAndNotAvailable {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

}

@end
