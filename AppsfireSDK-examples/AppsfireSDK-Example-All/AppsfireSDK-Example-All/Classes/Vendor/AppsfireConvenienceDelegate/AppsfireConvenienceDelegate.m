/*!
 *  @header    AppsfireConvenienceDelegate.m
 *  @abstract  Appsfire SDK easy integration class
 *  @version   2.2
 */

/*
 Copyright 2010-2013 Appsfire SAS. All rights reserved.
 
 Redistribution and use in source and binary forms, without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY APPSFIRE SAS ``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL APPSFIRE SAS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "AppsfireConvenienceDelegate.h"

// Appsfire SDK imports
#import "AppsfireAdSDK.h"
#import "AppsfireSDK.h"

//------------------------------
// Appsfire SDK Configuration
//------------------------------

#error Add your Appsfire API key below.
#define AFSDK_API_KEY           @""

// How the SDK should handle the badge count.  (default is `AFSDKBadgeHandlingLocal`)
#define AFSDK_BADGE_HANDLING    AFSDKBadgeHandlingLocal

// If the SDK window should be opened when we receive a push while the app is running in foreground. (default is `NO`)
#define AFSDK_OPEN_PUSH         NO

// Debug mode, essentially to show log messages, just uncomment to see logs.
//#define AFSDK_DEBUG             1

//------------------------------
// Appsfire Ad SDK Configuration
//------------------------------

// Use of the Appsfire Ad SDK. (default is `YES`)
#define AFSDK_ENABLE_ADS            YES

// Use of automatic advertisement display when an ad is available. The format used is Sushi. (default is `YES`)
#define AFSDK_AUTOMATIC_AD_DISPLAY  YES

// Debug mode, allows you to see, allows you to see example of ads examples.  (default is `YES`)
#define AFSDK_AD_DEBUG              YES

/*!
 *  @brief Enum for deciding badge handling mode
 */
typedef NS_ENUM(NSUInteger, AFSDKBadgeHandling) {
    AFSDKBadgeHandlingNone = 0,         // The SDK will not handle the springboard badge count.
    AFSDKBadgeHandlingLocal,            // The SDK will handle the springboard badge count locally.
    AFSDKBadgeHandlingLocalAndRemote    // The SDK will handle the springboard badge count locally AND remotely.
};


#ifdef AFSDK_DEBUG
#define AFSDKLog(fmt, ...) NSLog((@"[AppsfireSDK] %s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define AFSDKLog(fmt, ...)
#endif

@interface AppsfireConvenienceDelegate () <AppsfireSDKDelegate, AppsfireAdSDKDelegate>
@end

@implementation AppsfireConvenienceDelegate

#pragma mark - Monitoring App State Changes

#warning In order to use the Appsfire SDK Integrator you mandatorily need to call this method from your appDelegate subclass. Remove these lines when you finished reading it.
#warning Example : [super application:application didFinishLaunchingWithOptions:launchOptions]

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //------------------------------
    // Appsfire SDK Setup
    //------------------------------
    
    // Enable both Engage and Monetization features
    // please refer to the online documentation to understand what you need to enable in your case!
    [AppsfireSDK setFeatures:AFSDKFeatureEngage|AFSDKFeatureMonetization];
    
    // The only mandatory code in order to use the Appsfire SDK if the connection to the API with the API Key.
    if ([AppsfireSDK connectWithAPIKey:AFSDK_API_KEY]) {
        AFSDKLog(@"Appsfire Demo App launched with %@",[AppsfireSDK getAFSDKVersionInfo]);
    }
    
    else {
        AFSDKLog(@"Unable to launch Appsfire Demo App. Probably incompatible iOS");
    }
    
    // Setting the delegate of the Base SDK.
    [AppsfireSDK setDelegate:self];
    
    //------------------------------
    // Appsfire Ad SDK Setup
    //------------------------------
    
    // Use of the Appsfire Ad SDK.
    if (AFSDK_ENABLE_ADS) {
        
        // Setting the delegate of the Base SDK.
        [AppsfireAdSDK setDelegate:self];
        
#ifdef DEBUG
        [AppsfireAdSDK setDebugModeEnabled:AFSDK_AD_DEBUG];
#else
        // This is a supplementary check to make sure the developer does not ship any debug code in production.
        [AppsfireAdSDK setDebugModeEnabled:NO];
#endif
        // Tell Ad SDK to prepare, this method is automatically called during a modal ad request.
        [AppsfireAdSDK prepare];
    }
    
    //------------------------------
    // Push Configuration
    //------------------------------
    
    switch (AFSDK_BADGE_HANDLING) {
        case AFSDKBadgeHandlingLocal: {
            
            // Ask SDK to handle your springboard badge count locally.
            [AppsfireSDK handleBadgeCountLocally:YES];
            
        } break;
            
        case AFSDKBadgeHandlingLocalAndRemote: {
            
            // Ask SDK to handle your springboard badge count locally AND remotely.
            // In this case, the count will be updated even if the app is in background. You must
            // supply your production push certificate in your Manage Apps space (http://appsfire.com/sdk).
            [AppsfireSDK handleBadgeCountLocallyAndRemotely:YES];
            
            // NOTE : If you choose the second option, you must register your user's push token and send the
            // token to the SDK. To start, you will have to register the token using this code :
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
            
            // You will also need to implement this if you are using push notifications.
            NSDictionary *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            
            if ([notification respondsToSelector:@selector(objectForKey:)]) {
                NSNumber *notificationId = [notification objectForKey:@"ab_notid"];
                if (notificationId != nil && [notificationId respondsToSelector:@selector(intValue)]) {
                    AFSDKLog(@"App Launched via Push notification");
                    [AppsfireSDK openSDKNotificationID:[notificationId intValue]];
                }
            }
            
        } break;
            
        default: {
        } break;
    }
    
    return YES;
}

#warning In order to use the Appsfire SDK Integrator you mandatorily need to call this method from your appDelegate subclass. Remove these lines when you finished reading it.
#warning Example : [super applicationDidBecomeActive:application]

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // If advertisement is active.
    if (AFSDK_ENABLE_ADS) {
        
        // If automatic advertisement display is enabled.
        if (AFSDK_AUTOMATIC_AD_DISPLAY) {
            
            if ([AppsfireAdSDK isThereAModalAdAvailableForType:AFAdSDKModalTypeSushi] == AFAdSDKAdAvailabilityYes && ![AppsfireAdSDK isModalAdDisplayed]) {
                
                // Try to show an interstitial after a slight delay
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [AppsfireAdSDK requestModalAd:AFAdSDKModalTypeSushi withController:[UIApplication sharedApplication].keyWindow.rootViewController];
                });
            }
        }
    }
}

#pragma mark - Handling Remote Notifications

#warning In order to use the Appsfire SDK Integrator you mandatorily need to call this method from your appDelegate subclass. Remove these lines when you finished reading it.
#warning Example : [super application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken]

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Registering the push token with the SDK
    if (AFSDK_BADGE_HANDLING == AFSDKBadgeHandlingLocalAndRemote) {
        AFSDKLog(@"Registering the push token with the SDK");
        [AppsfireSDK registerPushToken:deviceToken];
    }
}


#warning In order to use the Appsfire SDK Integrator you mandatorily need to call this method from your appDelegate subclass. Remove these lines when you finished reading it.
#warning Example : [super application:application didReceiveRemoteNotification:userInfo]

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // If the SDK window should be opened when we receive a push and the app is running in foreground.
    if (AFSDK_OPEN_PUSH) {
        NSNumber *notificationId = [userInfo objectForKey:@"ab_notid"];
        if ([notificationId respondsToSelector:@selector(intValue)]) {
            [AppsfireSDK openSDKNotificationID:[notificationId intValue]];
        }
    }
}

#pragma mark - AppsfireSDKDelegate

- (void)SDKopenNotificationResult:(NSString *)response {
    AFSDKLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
}

- (void)panelViewControllerNeedsToBeDismissed:(UIViewController *)controller {
    AFSDKLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    if (![controller isKindOfClass:UIViewController.class]) {
        AFSDKLog(@"Passed controller is not a valide UIViewController, can't dismiss it");
        return;
    }
    
    BOOL isInNavigationController = [controller.parentViewController isKindOfClass:UINavigationController.class];
    
    if (isInNavigationController) {
        [(UINavigationController *)controller.parentViewController popViewControllerAnimated:YES];
    }
    
    else {
        [controller dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - AppsfireAdSDKDelegate

- (void)adUnitDidInitialize {
    AFSDKLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
}

- (void)modalAdIsReadyForRequest {
    AFSDKLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

    // If you want to show ads as soon as they are ready, uncomment the following lines.
    
    /*
    // Advertisement must be active.
    if (AFSDK_ENABLE_ADS) {
        
        // If automatic advertisement display is enabled.
        if (AFSDK_AUTOMATIC_AD_DISPLAY) {
            
            if ([AppsfireAdSDK isThereAModalAdAvailableForType:AFAdSDKModalTypeSushi] == AFAdSDKAdAvailabilityYes && ![AppsfireAdSDK isModalAdDisplayed]) {
                [AppsfireAdSDK requestModalAd:AFAdSDKModalTypeSushi withController:[UIApplication sharedApplication].keyWindow.rootViewController];
            }
        }
    }
     */
}

- (void)sashimiAdsWereReceived {
    AFSDKLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
}

- (BOOL)shouldDisplayModalAd {
    AFSDKLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    return YES;
}

- (void)modalAdRequestDidFailWithError:(NSError *)error {
    AFSDKLog(@"Modal Ad Request Error : %@", error.localizedDescription);
    
    // Shows what what failed.
    switch (error.code) {
        case AFSDKErrorCodeUnknown: {
            AFSDKLog(@"Unknown Error.");
        } break;
            
        AFSDKErrorCodeLibraryNotInitialized: {
            AFSDKLog(@"Library isn't initialized yet.");
        } break;
            
        AFSDKErrorCodeInternetNotReachable: {
            AFSDKLog(@"Internet isn't reachable (and is required).");
        } break;
            
        AFSDKErrorCodeNeedsApplicationDelegate: {
            AFSDKLog(@"You need to set the application delegate to proceed.");
        } break;
            
        AFSDKErrorCodeAdvertisingNoAd: {
            AFSDKLog(@"No ad available.");
        } break;
            
        AFSDKErrorCodeAdvertisingBadCall: {
            AFSDKLog(@"The request call isn't appropriate.");
        } break;
            
        AFSDKErrorCodeAdvertisingAlreadyDisplayed: {
            AFSDKLog(@"An ad is currently displayed for this format.");
        } break;
            
        AFSDKErrorCodeAdvertisingCanceledByDevelopper: {
            AFSDKLog(@"The request was canceled by the developer.");
        } break;
            
        AFSDKErrorCodePanelAlreadyDisplayed: {
            AFSDKLog(@"The panel is already displayed.");
        } break;
            
        default:
            break;
    }
}

- (void)modalAdWillAppear {
    AFSDKLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
}

- (void)modalAdWillDisappear {
    AFSDKLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
}

@end
