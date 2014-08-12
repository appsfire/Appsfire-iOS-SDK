//
//  AppTableViewController.m
//  Appsfire SDK Demo
//
//  Created by Vincent on 19/06/14.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AppTableViewController.h"
//
#import "AppDelegate.h"
#import "AppsfireAdSDK.h"
#import "AppsfireAdTimerView.h"

typedef NS_ENUM(NSUInteger, AFAdSDKRowInterstitial) {
    AFAdSDKRowInterstitialSushi = 0,
    AFAdSDKRowInterstitialUramakiWithoutTimer,
    AFAdSDKRowInterstitialUramakiWithTimer
};

@interface AppTableViewController () <AFAdSDKModalDelegate>

@end

@implementation AppTableViewController

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style {
    
    if ((self = [super initWithStyle:style]) != nil) {

        self.title = @"Appsfire SDK - Intertitials";
        
    }
    return self;
    
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
    return @"Interstial Formats";

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    static NSString *CellIdentifier = @"basic";
    
    // try to get a reusable cell
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // if none, create it
    if (!cell) {
        
        // create cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // customize cell
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    
    //
    switch (indexPath.row) {
            
        case AFAdSDKRowInterstitialSushi: {
            cell.textLabel.text = @"Sushi";
            break;
        }
            
        case AFAdSDKRowInterstitialUramakiWithoutTimer: {
            cell.textLabel.text = @"Uramaki";
            break;
        }
            
        case AFAdSDKRowInterstitialUramakiWithTimer: {
            cell.textLabel.text = @"Uramaki (with timer)";
            break;
        }
            
        default: {
            break;
        }
            
    }
    
    //
    return cell;
    
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *typeString;
    BOOL shouldUseTimer;
    AFAdSDKModalType modalType;
    
    //
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //
    switch (indexPath.row) {
                    
        case AFAdSDKRowInterstitialSushi: {
            modalType = AFAdSDKModalTypeSushi;
            typeString = @"Sushi";
            shouldUseTimer = NO;
            break;
        }

        case AFAdSDKRowInterstitialUramakiWithoutTimer: {
            modalType = AFAdSDKModalTypeUraMaki;
            typeString = @"Uramaki";
            shouldUseTimer = NO;
            break;
        }

        case AFAdSDKRowInterstitialUramakiWithTimer: {
            modalType = AFAdSDKModalTypeUraMaki;
            typeString = @"Uramaki";
            shouldUseTimer = YES;
            break;
        }

        default: {
            modalType = AFAdSDKModalTypeSushi;
            shouldUseTimer = NO;
            break;
        }
        
    }
    
    // check if an ad is available
    if ([AppsfireAdSDK isThereAModalAdAvailableForType:modalType] == AFAdSDKAdAvailabilityYes) {
        
        // if timer was asked
        if (shouldUseTimer) {
            
            [[[AppsfireAdTimerView alloc] initWithCountdownStart:3] presentWithCompletion:^(BOOL accepted) {
                if (accepted)
                    [AppsfireAdSDK requestModalAd:modalType withController:self withDelegate:self];
            }];
            
        }
        
        // else, simply display ad
        else {
            
            [AppsfireAdSDK requestModalAd:modalType withController:self withDelegate:self];
            
        }
        
    }
    
    // else display an error
    // (for debug purpose, don't do this in your app :))
    else {
    
        [[[UIAlertView alloc] initWithTitle:typeString message:@"This Ad format is not yet ready, try again in a few seconds." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
    }
    
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return YES;
    
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
    
}

#pragma mark - Appsfire Ad Modal Delegate

- (void)sashimiAdsWereReceived {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

- (BOOL)shouldDisplayModalAd {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    // return `NO` if you want to cancel the presentation of the ad (at the very last minute)
    return YES;
    
}

- (void)modalAdRequestDidFailWithError:(NSError *)error {
    
    NSLog(@"Modal Ad Request Error : %@", error.localizedDescription);
    
}

- (void)modalAdWillAppear {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

- (void)modalAdDidAppear {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

- (void)modalAdWillDisappear {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

- (void)modalAdDidDisappear {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

@end
