//
//  AppDelegate.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 04/02/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AppDelegate.h"
// helpers
#import "AppsfireSDK.h"
#import "AppsfireAdSDK.h"
// controllers
#import "AppNavigationController.h"
#import "AppTableViewController.h"
#import "ExampleMinimalSashimiTableViewController.h"
#import "ExampleExtendedSashimiTableViewController.h"
#import "ExampleCustomSashimiTableViewController.h"

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
    error = [AppsfireSDK connectWithAppId:@"3180317" parameters:nil];
    if (error != nil)
        NSLog(@"Unable to initialize Appsfire SDK (%@)", error);

    /*
     * UI Implementation
     */
    
    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // main controller
    self.tableViewController = [[AppTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    // navigation controller
    self.navigationController = [[AppNavigationController alloc] initWithRootViewController:self.tableViewController];
    
    //
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
    
}

#pragma Appsfire Ad SDK Delegate

- (void)sashimiAdsRefreshedAndAvailable {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

    if ([self.navigationController.visibleViewController respondsToSelector:@selector(tryToIncludeAds)])
        [self.navigationController.visibleViewController performSelector:@selector(tryToIncludeAds)];
    
}

- (void)sashimiAdsRefreshedAndNotAvailable {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

@end
