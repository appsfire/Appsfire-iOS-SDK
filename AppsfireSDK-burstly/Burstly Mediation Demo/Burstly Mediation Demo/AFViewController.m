//
//  AFViewController.m
//  AdMob Mediation Demo
//
//  Created by Ali Karagoz on 17/10/2013.
//  Copyright (c) 2013 Appsfire. All rights reserved.
//

#import "AFViewController.h"
#import "AppsfireAdSDK.h"
#import "AppsfireSDK.h"
#import "BurstlyInterstitial.h"

#define USE_INTERSTITIAL_PRE_CACHING 1

@interface AFViewController () <BurstlyInterstitialDelegate>

@property (nonatomic) UIButton *button;
@property (nonatomic) BurstlyInterstitial *interstitial;

- (void)loadInterstitial;
- (void)showAd:(id)sender;

@end

@implementation AFViewController

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    // Configuring the view
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Button
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:@"Show Ad" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(showAd:) forControlEvents:UIControlEventTouchUpInside];
    [self.button sizeToFit];
    
    self.button.center = self.view.center;
    self.button.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|
                                    UIViewAutoresizingFlexibleRightMargin|
                                    UIViewAutoresizingFlexibleTopMargin|
                                    UIViewAutoresizingFlexibleBottomMargin);
    [self.view addSubview:self.button];
    
    // We disable the button until we have an ad
    self.button.enabled = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Load AdMob Interstitial
    [self loadInterstitial];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - AdMob

- (void)loadInterstitial {

#error Add your Burstly App Id below
    // Burstly appId
    NSString *appId = @"BURSTLY_APP_ID";

#error Add your Burstly Zone Id below
    // Burstly Zone Id
    NSString *interstitialZoneId = @"BURSTLY_ZONE_ID";
    
    // Burstly interstitial
    self.interstitial = [[BurstlyInterstitial alloc] initAppId:appId zoneId:interstitialZoneId delegate:self];
	if (USE_INTERSTITIAL_PRE_CACHING) {
		// Enable automatic caching
		self.interstitial.useAutomaticCaching = YES;
	}
    
    // Delegate
    self.interstitial.delegate = self;
}

- (void)showAd:(id)sender {
    // If the interstitial is ready to be displayed, we do so
    if (self.interstitial.state == BurstlyInterstitialStateCached) {
        [self.interstitial showAd];
    }
    
    else {
        NSLog(@"Can't show the interstitial for now with state (%d)", self.interstitial.state);
    }
}

#pragma mark - BurstlyInterstitialDelegate

- (UIViewController *)viewControllerForModalPresentation:(BurstlyInterstitial *)interstitial {
    return self;
}

- (void)burstlyInterstitial:(BurstlyInterstitial *)ad willTakeOverFullScreen:(NSDictionary *)info {
    // N/A
}

- (void)burstlyInterstitial:(BurstlyInterstitial *)ad willDismissFullScreen:(NSDictionary *)info {
    //
}

- (void)burstlyInterstitial:(BurstlyInterstitial *)ad didHide:(NSDictionary *)info {
    //
}

- (void)burstlyInterstitial:(BurstlyInterstitial *)ad didShow:(NSDictionary *)info {
    //
}

- (void)burstlyInterstitial:(BurstlyInterstitial *)ad didCache:(NSDictionary *)info {
    NSLog(@"Interstitial Did Cache");
    self.button.enabled = YES;
}

- (void)burstlyInterstitial:(BurstlyInterstitial *)ad wasClicked:(NSDictionary *)info {
    //
}

- (void)burstlyInterstitial:(BurstlyInterstitial *)ad didFail:(NSDictionary *)info {
    self.button.enabled = NO;
    
    // An interstitial did fail to load.
	// Handle interstitial load error.
    NSError *error = info[BurstlyInfoError];
    NSLog(@"Failed to load interstitial: %@", error.description);
    switch (error.code) {
        case BurstlyErrorInvalidRequest:
            break;
        case BurstlyErrorNoFill:
            break;
        case BurstlyErrorNetworkFailure:
            break;
        case BurstlyErrorServerError:
            break;
        case BurstlyErrorInterstitialTimedOut:
            break;
        case BurstlyErrorRequestThrottled:
            break;
        case BurstlyErrorConfigurationError:
            break;
        default:
            break;
    }
}

@end
