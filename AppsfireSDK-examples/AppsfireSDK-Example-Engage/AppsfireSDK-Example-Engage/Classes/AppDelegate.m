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
#import "AppsfireEngageSDK.h"
// controllers
#import "AppTableViewController.h"
#import "AppNavigationController.h"

// How the SDK should handle the badge count (default is `AFSDKBadgeHandlingLocal`).
#define AFSDK_BADGE_HANDLING    AFSDKBadgeHandlingLocal

// If the SDK window should be opened when we receive a push while the app is running in foreground (default is `NO`).
#define AFSDK_OPEN_PUSH         NO

/*!
 *  @brief Enum for deciding badge handling mode
 */
typedef NS_ENUM(NSUInteger, AFSDKBadgeHandling) {
    AFSDKBadgeHandlingNone = 0,         // the sdk will not handle the springboard badge count.
    AFSDKBadgeHandlingLocal,            // the sdk will handle the springboard badge count locally.
    AFSDKBadgeHandlingLocalAndRemote    // the sdk will handle the springboard badge count locally AND remotely.
};

@interface AppDelegate() <AppsfireEngageSDKDelegate>

@end

@implementation AppDelegate

#pragma mark - Monitoring App State Changes

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSError *error;
    NSDictionary *notification;
    
    /*
     *  Appsfire SDK Connect
     */
    
    // sdk connect
    #error Add your Appsfire SDK Token and Secret key below.
    error = [AppsfireSDK connectWithSDKToken:@"" secretKey:@"" features:AFSDKFeatureEngage parameters:nil];
    if (error != nil)
        NSLog(@"Unable to initialize Appsfire SDK (%@)", error);
    
    /*
     *  Appsfire Engage SDK Setup
     */
    
    // set up the delegate of the Engage SDK.
    [AppsfireEngageSDK setDelegate:self];
    
    // push configuration
    switch (AFSDK_BADGE_HANDLING) {
            
        // local
        case AFSDKBadgeHandlingLocal:
        {
            // ask SDK to handle your springboard badge count locally
            [AppsfireEngageSDK handleBadgeCountLocally:YES];
            
            break;
        }
         
        // local and remote
        case AFSDKBadgeHandlingLocalAndRemote:
        {
            // ask SDK to handle your springboard badge count locally AND remotely.
            // in this case, the count will be updated even if the app is in background.
            // you must supply your production push certificate in your Manage Apps space (http://dashboard.appsfire.com/app/manage).
            [AppsfireEngageSDK handleBadgeCountLocallyAndRemotely:YES];
            
            // NOTE : If you choose the second option, you must register your user's push token and send the
            // token to the SDK. To start, you will have to register the token using this code :
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            
            // you will also need to implement this if you are using push notifications.
            notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            if ([notification isKindOfClass:[NSDictionary class]]) {
                NSNumber *notificationId = notification[@"ab_notid"];
                if (notificationId != nil && [notificationId respondsToSelector:@selector(intValue)]) {
                    [AppsfireEngageSDK openSDKNotificationID:[notificationId intValue]];
                }
            }
            
            break;
        }
            
        default: {
            break;
        }
            
    }
    
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

#pragma mark - Handling Remote Notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // send the token to the sdk
    if (AFSDK_BADGE_HANDLING == AFSDKBadgeHandlingLocalAndRemote)
        [AppsfireEngageSDK registerPushToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    NSNumber *notificationId;
    
    // handle notification for the sdk
    if (AFSDK_OPEN_PUSH) {
        notificationId = [userInfo objectForKey:@"ab_notid"];
        if ([notificationId respondsToSelector:@selector(intValue)]) {
            [AppsfireEngageSDK openSDKNotificationID:[notificationId intValue]];
        }
    }
    
}

#pragma mark - Appsfire Engage SDK Delegate

- (void)SDKopenNotificationResult:(NSString *)response {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

- (void)panelViewControllerNeedsToBeDismissed:(UIViewController *)controller {
    
    BOOL isInNavigationController;
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    // check if parent controller is a navigation controller
    isInNavigationController = [controller.parentViewController isKindOfClass:UINavigationController.class];
    
    // if yes, then pop
    if (isInNavigationController) {
        [(UINavigationController *)controller.parentViewController popViewControllerAnimated:YES];
    }
    
    // else, just dismiss
    else {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
