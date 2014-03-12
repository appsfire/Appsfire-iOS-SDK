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
#import "GADInterstitial.h"

@interface AFViewController () <GADInterstitialDelegate>

@property (nonatomic) UIButton *button;
@property (nonatomic) GADInterstitial *interstitial;

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
    // Instantiate the interstitial using the class convenience method.
    self.interstitial = [[GADInterstitial alloc] init];
    
#error Add your AdMob interstitial Unit Id
    self.interstitial.adUnitID = @"MY_INTERSTITIAL_UNIT_ID";
    
    // Loads an interstitial ad.
    [self.interstitial loadRequest:[GADRequest request]];
    
    // Delegate
    self.interstitial.delegate = self;
}

- (void)showAd:(id)sender {
    [self.interstitial presentFromRootViewController:self];
}

#pragma mark - GADInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Enabling the button if the interstitial is ready
    if (self.interstitial.isReady) {
        self.button.enabled = YES;
    }
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
