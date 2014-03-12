//
// BurstlyAdUtils.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import "BurstlyLoggerConstants.h"

@interface BurstlyAdUtils: NSObject

+ (NSString*)version;

+ (void)setLogLevel:(BurstlyLogLevel)level;
+ (BurstlyLogLevel)logLevel;


+ (void)setServerUrl:(NSURL*)url;
+ (void)setResourcesUrl:(NSURL*)url;

/**
* Initialize FlightPath.  Allows segmenting and analysis of users based on metrics collected after initialization.
* Access to FlightPath is by invite only. First signup at www.testflightapp.com to receive you unique identifier.
* Once you have your unique identifier, email support@burstly.com to get started using FlightPath.
*
* @param appToken - unique identifier provided by Burstly
*/
+ (void)startFlightPath:(NSString *)appToken;

/**
* Track user events by passing a checkpoint when the user has reached a noteworthy point within the application.
* This can only be done after FlightPath has been successfully initialized.
*
* @param checkpoint - The name of the checkpoint, this should be a static string
*/
+ (void)passCheckpoint:(NSString *)checkpoint;

@end