//
//  AFAppDelegate.m
//  Appsfire SDK Demo
//
//  Created by Ali Karagoz on 16/09/13.
//  Copyright (c) 2013 Appsfire. All rights reserved.
//

#import "AppDelegate.h"

#import "SDKTableViewController.h"
#import "SDKOptionsTableViewController.h"

@implementation AppDelegate

#pragma mark - Monitoring App State Changes

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Calling this method here makes sure the SDK will be correctly integrated to the project.
    // However you need to check the Integrator class to configure it to your needs.
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    // Continue the implementation.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // TableView Controller
    self.tableViewController = [[SDKTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    // NavigationController
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.tableViewController];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [super applicationDidBecomeActive:application];
    
    // Continue the implementation.
    
}

#pragma mark - Handling Remote Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    // Continue the implementation.
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [super application:application didReceiveRemoteNotification:userInfo];
    
    // Continue the implementation.
    
}

@end
