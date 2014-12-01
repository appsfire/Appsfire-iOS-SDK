/*!
 *  @header    AFMedInfo.h
 *  @abstract  Appsfire Mediation Information Object.
 *  @version   2.5.1
 */

#import <Foundation/NSObject.h>
#import <UIKit/UIView.h>

@class AFMedInfoLocation;

/*!
 * Gender enumeration.
 *
 * @since 2.5.0
 */
typedef NS_ENUM(NSUInteger, AFMedInfoGender) {
    
    /* No gender provided. */
    AFMedInfoGenderNone = 0,
    
    /* Male gender. */
    AFMedInfoGenderMale,
    
    /* Female gender. */
    AFMedInfoGenderFemale
};

/*!
 * Information object that is passed to instances of AFMedInterstitial and AFMedBannerView in order 
 * to communicate information on you end users. This information is then used by the custom event 
 * adapters in order to pass this information to third party networks.
 */
@interface AFMedInfo : NSObject

/*!
 * Location of the end user.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, strong) AFMedInfoLocation *location;

/*!
 * Birth date of the end user.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, strong) NSDate *birthDate;

/*!
 * Gender of the end user.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, assign) AFMedInfoGender gender;

/*!
 * Dictionary containing custom information to be passed to custom event adapters.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, strong) NSDictionary *customDictionary;

/*!
 * Handy setter of the location.
 *
 * @param latitude The latitude of the coordinate.
 * @param longitude The longitude of the coordinate.
 *
 * @since 2.5.0
 */
- (void)setLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end

@interface AFMedInfoLocation : NSObject

/*!
 * Latitude component.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, assign) CGFloat latitude;

/*!
 * Longitude component.
 *
 * @since 2.5.0
 */
@property (readwrite, nonatomic, assign) CGFloat longitude;

/*!
 * Handy initialiser which taked the latitude and the longitude of the coordinate.
 *
 * @param latitude The latitude of the coordinate.
 * @param longitude The longitude of the coordinate.
 *
 * @return And instance of AFMedInfoLocation with the provided latitude and longitude.
 *
 * @since 2.5.0
 */
- (instancetype)initWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

@end
