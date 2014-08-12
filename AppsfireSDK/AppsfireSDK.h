/*!
 *  @header    AppsfireSDK.h
 *  @abstract  Appsfire iOS SDK Header
 *  @version   2.4.0
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
 *  @param token Your SDK token can be found on http://dashboard.appsfire.com/app/manage
 *  @param features Features defined by a bitmask. You can enable one or more features. If you are only using the Monetization SDK, then you should only specify `AFSDKFeatureMonetization`. In case of doubt, don't hesitate to contact us!
 *  @param parameters (optional) A dictionary describing the optional parameters to initialize the SDK.
 *
 *  @return Returns an error of something bad happened. Or just `nil` if all went well!
 */
+ (NSError *)connectWithSDKToken:(NSString *)token features:(AFSDKFeature)features parameters:(NSDictionary *)parameters;

/*!
 *  @brief Tells you if the SDK is initialized.
 *
 *  @note Once the SDK is initialized, you can present the notifications or the feedback.
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


/** @name Deprecated Methods
 *  Methods which are about to be removed from the SDK.
 */

+ (BOOL)connectWithAPIKey:(NSString *)key __deprecated_msg("We updated our initialization method! We strongly advise you to stop using this method. Please check `+connectWithSDKToken:features:parameters:` instead.");

+ (BOOL)connectWithAPIKey:(NSString *)key afterDelay:(NSTimeInterval)delay __deprecated_msg("We updated our initialization method! We strongly advise you to stop using this method. Please check `+connectWithSDKToken:features:parameters:` instead.");

+ (void)resetCache __deprecated_msg("We plan to remove this method in a future release. If you still find an interest in using it, please contact us!");

+ (NSString *)getAFSDKVersionInfo __deprecated_msg("We renamed the method. Please use `+versionDescription` instead.");

@end
