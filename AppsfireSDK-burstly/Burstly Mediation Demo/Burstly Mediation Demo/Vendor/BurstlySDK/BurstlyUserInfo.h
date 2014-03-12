//
// BurstlyUserInfo.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BurstlyUserInfo : NSObject {
    NSString *dateOfBitrh_;
    NSString *postalCode_;
    NSString *zipCode_;
    NSString *areaCode_;
    NSString *regionCode_;
    NSString *city_;
    NSString *gender_;
    NSString *keyWords_;
    NSString *blockKeywords_;
    NSString *income_;
    NSString *educationType_;
    NSString *ethnicityType_;
    NSString *email_;
    NSString *language_;
    NSString *country_;
    NSString *state_;
    NSString *interests_;
    NSString *searchString_;
    CLLocation *location_;
} 

- (NSDictionary*)userParams;
- (void)setDefaults;


/*
 @param: Required format mm/dd/yy
 @example: return @"02/03/12";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *dateOfBirth;

/*
 @param: String with postal code
 @example: return @"90401";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *postalCode;


/*
 @param: String with area code
 @example: return @"29";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *areaCode;

/*
 @param: String with zip code
 @example: return @"90401";
 @3rd party networks affected: Millennial
 */
@property (nonatomic, retain) NSString  *zipCode;

/*
 @param: String with region code
 @example: return @"29";
 @3rd party networks affected: none
 */
@property (nonatomic, retain) NSString  *regionCode;

/*
 @param: String with city name
 @example: return @"Santa Monica";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *city;

/*
 @param: unknown/male/female
 @example: return @"male";
 @3rd party networks affected: Admob, Inmobi, Millennial, Jumptap
 */
@property (nonatomic, retain) NSString  *gender;

/*
 @param: String with set of keywords divided by space
 @example: return @"offers sale shopping";
 @3rd party networks affected: Admob, Inmobi, Flurry
 */
@property (nonatomic, retain) NSString  *keyWords;


/*
 @param: String with set of keywords divided by space
 @example: return @"alcohol tobacco";
 @3rd party networks affected: none
 */
@property (nonatomic, retain) NSString  *blockKeywords;

/*
 @param: String with income (should be in USD)
 @example: return @"10000;
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *income;

/*
 @param: Education type (none/highSchool/college/bachelor/master/doctor/other)
 @example: return @"college";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *educationType;

/*
 @param: EthnicityType: none
                        mixed
                        asian
                        black
                        hispanic
                        nativeAmerican
                        white
                        other
 @example: return @"white";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *ethnicityType;

/*
 @param: String with email
 @example: return @"apple@apple.com;
 @3rd party networks affected: none
 */
@property (nonatomic, retain) NSString  *email;

/*
 @param: String with language
 @example: return @"EN-US";
 @3rd party networks affected: none
 */
@property (nonatomic, retain) NSString  *language;

/*
 @param: String with name of the country
 @example: return @"Austria";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *country;


/*
 @param: String with name of the state
 @example: return @"California";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *state;

/*
 @param: String with set of interests divided by space
 @example: return @"cars bikes racing";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *interests;


/*
 @param: Search string
 @example: return  @"Hotel Santa Monica CA";
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) NSString  *searchString;

/*
 @param: Location 
 @3rd party networks affected: Inmobi
 */
@property (nonatomic, retain) CLLocation  *location;

@end

#define BURSTLY_USERINFO_DATE_OF_BIRTH_KEY    @"dateOfBirth"
#define BURSTLY_USERINFO_POSTAL_CODE_KEY      @"postalCode"
#define BURSTLY_USERINFO_AREA_CODE_KEY        @"areaCode"
#define BURSTLY_USERINFO_ZIP_CODE_KEY         @"zip"
#define BURSTLY_USERINFO_REGION_CODE_KEY      @"regionCode"
#define BURSTLY_USERINFO_CITY_KEY             @"city"
#define BURSTLY_USERINFO_LATITUDE_KEY         @"latitude"
#define BURSTLY_USERINFO_LONGITUDE_KEY        @"longitude"
#define BURSTLY_USERINFO_GENDER_KEY           @"gender"
#define BURSTLY_USERINFO_KEY_WORDS_KEY        @"keywords"
#define BURSTLY_USERINFO_SEARCH_STRING_KEY    @"searchString"
#define BURSTLY_USERINFO_INTERESTS_KEY        @"interests"
#define BURSTLY_USERINFO_BLOCK_KEY_WORDS_KEY  @"blockKeywords"
#define BURSTLY_USERINFO_INCOME_KEY           @"income"
#define BURSTLY_USERINFO_EDUCATION_TYPE_KEY   @"educationType"
#define BURSTLY_USERINFO_ETHNITY_TYPE_KEY     @"ethnicityType"
#define BURSTLY_USERINFO_EMAIL_KEY            @"email"
#define BURSTLY_USERINFO_LANGUAGE_KEY         @"language"
#define BURSTLY_USERINFO_COUNTRY_KEY          @"country"
#define BURSTLY_USERINFO_LOGIN_ID_KEY         @"loginID"
#define BURSTLY_USERINFO_SESSION_ID_KEY       @"SessionID"
#define BURSTLY_USERINFO_LOCATION_KEY         @"location"
#define BURSTLY_USERINFO_STATE_KEY            @"state"
#define BURSTLY_USERINFO_AGE_KEY              @"age"

//Education types defines

#define BURSTLY_USERINFO_EDUCATION_NONE            @"none"
#define BURSTLY_USERINFO_EDUCATION_HIGH_SCHOOL     @"highSchool"
#define BURSTLY_USERINFO_EDUCATION_COLLEGE         @"college"
#define BURSTLY_USERINFO_EDUCATION_BACHELORS       @"bachelor"
#define BURSTLY_USERINFO_EDUCATION_MASTERS         @"master"
#define BURSTLY_USERINFO_EDUCATION_DOCTORS         @"doctor"
#define BURSTLY_USERINFO_EDUCATION_OTHER           @"other"

//Gender defines

#define BURSTLY_USERINFO_GENDER_MALE               @"male"
#define BURSTLY_USERINFO_GENDER_FEMALE             @"female"

//Ethinity defines

#define BURSTLY_USERINFO_ETHNITY_NONE              @"none"
#define BURSTLY_USERINFO_ETHNITY_MIXED             @"mixed"
#define BURSTLY_USERINFO_ETHNITY_ASIAN             @"asian"
#define BURSTLY_USERINFO_ETHNITY_BLACK             @"black"
#define BURSTLY_USERINFO_ETHNITY_HISPANIC          @"hispanic"
#define BURSTLY_USERINFO_ETHNITY_NATIVE_AMERICAN   @"nativeAmerican"
#define BURSTLY_USERINFO_ETHNITY_WHITE             @"white"
#define BURSTLY_USERINFO_ETHNITY_OTHER             @"other"
#define BURSTLY_USERINFO_ETHNITY_INDIAN            @"indian"
#define BURSTLY_USERINFO_ETHNITY_NATIVE_ALASKA     @"nativeAlaska"
#define BURSTLY_USERINFO_ETHNITY_NATIVE_HAWAIIAN   @"nativeHawaiian"
#define BURSTLY_USERINFO_ETHNITY_PACIFIC_ISLANDER  @"pacificIslander"

