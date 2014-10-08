//
//  AppDelegate.m
//  AppsfireSDK-Example-Mediation
//
//  Created by Ali Karagoz on 01/10/14.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AppDelegate.h"

// Appsfire SDK
#import "AppsfireSDK.h"
#import "AppsfireAdSDK.h"

#import "AppTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
     *  Appsfire Setup
     */
    
    // Enabling debug mode for testing purpose only.
    #if DEBUG
        #warning In Release mode, make sure to set the value below to NO.
        [AppsfireAdSDK setDebugModeEnabled:NO];
    #endif
    
    // sdk connect
    #error Add your Appsfire SDK Token and Secret key below.
    NSError *error = [AppsfireSDK connectWithSDKToken:@"" secretKey:@"" features:AFSDKFeatureMonetization parameters:nil];
    if (error) {
        NSLog(@"Unable to initialize Appsfire SDK (%@)", error);
    }
    
    /*
     * UI Implementation
     */
    
    AppTableViewController *tableViewController = [[AppTableViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:tableViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
