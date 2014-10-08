//
//  AppDelegate.m
//  AppsfireSDK-Example-IAP
//
//  Created by Ali Karagoz on 07/08/14.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AppDelegate.h"

// Appsfire SDK
#import "AppsfireSDK.h"
#import "AppsfireAdSDK.h"
#import "AFAdSDKIAP.h"

#import "AppTableViewController.h"

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /*
     *  Appsfire Setup
     */
    
    // Enabling debug mode for testing purpose only.
    #if DEBUG
        #warning In Release mode, make sure to set the value below to NO.
        [AppsfireAdSDK setDebugModeEnabled:YES];
    #endif
    
    // sdk connect
    #error Add your Appsfire SDK Token and Secret key below.
    NSError *error = [AppsfireSDK connectWithSDKToken:@"" secretKey:@"" features:AFSDKFeatureMonetization parameters:nil];
    if (error) {
        NSLog(@"Unable to initialize Appsfire SDK (%@)", error);
    }
    
    // In-App Purchase Ad Removal Prompt.
    
    // Creating a property.
    AFAdSDKIAPProperty *property = [AFAdSDKIAPProperty propertyWithBlock:^(AFAdSDKIAPProperty *property) {
        property.title = @"Remove Advertisement";
        property.message = @"Do you want to purchase the premium version of the app and remove ads?";
        property.cancelButtonTitle = @"Skip";
        property.buyButtonTitle = @"Buy ($0.99)";
        property.buyBlock = ^{
            
            // Dummy alert view to simulate a purchase.
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Premium"
                                                                message:@"Bravo! You just bought the full version of this app, Enjoy!"
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"Cool", nil];
            [alertView show];
            
        };
    }];
    
    // Setting the property.
    [AFAdSDKIAP setProperty:property andError:&error];
    
    if (error) {
        NSLog(@"In-app purchase property not valid : %@", error);
    }
    
    #if DEBUG
        #warning In Release mode, make sure to set the value below to NO.
        [AFAdSDKIAP setDebugModeEnabled:YES];
    #endif
    
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

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    // Disabling IAP Ad Removal Prompt.
    [AFAdSDKIAP setProperty:nil andError:nil];
}

@end
