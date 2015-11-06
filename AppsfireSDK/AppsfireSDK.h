/*!
 *  @header    AppsfireSDK.h
 *  @abstract  Appsfire iOS SDK Header
 *  @version   2.8.0
 */

#import <UIKit/UIViewController.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSError.h>
#import "AppsfireSDKConstants.h"

/*!
 *  Appsfire SDK top-level class.
 */
@interface AppsfireSDK : NSObject

/** @name Library Life
 *  Methods about the general life of the library.
 */

/*!
 *  @brief Set up the Appsfire SDK.
 *
 *  @param token Your app ID as supplied by Appsfire
 *  @param parameters (optional) A dictionary describing the optional parameters to initialize the SDK.
 *
 *  @return Returns an error if something bad happened. Or just `nil` if all went well!
 */
+ (NSError *)connectWithAppId:(NSString *)appId parameters:(NSDictionary *)parameters;

/*!
 *  @brief Tells you if the SDK is initialized.
 *
 *  @note The SDK initialization is not synchronous. Thus, don't except this method to return `YES` just after you called `connectWithAppId:parameters:`. If you need to be alerted once the SDK is initialized, please refer to the notification `kAFSDKIsInitialized`.
 *
 *  @return `YES` if the sdk is initialized, `NO` if not.
 */
+ (BOOL)isInitialized;

/*!
 *  @brief Get SDK version and build number (for debug purposes only).
 *
 *  @return Return a string with SDK version and build number.
 */
+ (NSString *)versionDescription;

@end
