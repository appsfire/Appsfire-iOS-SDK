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
#import "MainViewController.h"
#import "ExampleMinimalSashimiTableViewController.h"
#import "ExampleExtendedSashimiTableViewController.h"
#import "ExampleCustomSashimiTableViewController.h"

@interface AppDelegate() <AppsfireAdSDKDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

    //
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // main controller
    self.tableViewController = [[MainViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // navigation controller
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.tableViewController];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    
    /*
     *  Appsfire
     */
    
    // sdk connect
    #error Add your Appsfire API key below.
    [AppsfireSDK connectWithAPIKey:@""];
    
    // set delegate
    [AppsfireAdSDK setDelegate:self];
    
    //
    #if DEBUG
        #warning In Release mode, make sure to set the value below to NO.
        [AppsfireAdSDK setDebugModeEnabled:YES];
    #endif
    
    // tell ad sdk to load ads right now
    [AppsfireAdSDK prepare];
    
    //
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma Appsfire Ad SDK Delegate

- (void)sashimiAdsWereReceived {
    
    if ([self.navigationController.visibleViewController isKindOfClass:[ExampleMinimalSashimiTableViewController class]])
        [(ExampleMinimalSashimiTableViewController *)self.navigationController.visibleViewController tryIncludingSashimiAds];
    else if ([self.navigationController.visibleViewController isKindOfClass:[ExampleExtendedSashimiTableViewController class]])
        [(ExampleExtendedSashimiTableViewController *)self.navigationController.visibleViewController tryIncludingSashimiAds];
    else if ([self.navigationController.visibleViewController isKindOfClass:[ExampleCustomSashimiTableViewController class]])
        [(ExampleCustomSashimiTableViewController *)self.navigationController.visibleViewController tryIncludingSashimiAds];
    
}

@end
