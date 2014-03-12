//
//  AFViewController.m
//  MoPub Mediation Demo
//
//  Created by Ali Karagoz on 17/10/2013.
//  Copyright (c) 2013 Appsfire. All rights reserved.
//

#import "AFViewController.h"
#import "AppsfireAdSDK.h"
#import "AppsfireSDK.h"
#import "MPInterstitialAdController.h"

@interface AFViewController () <MPInterstitialAdControllerDelegate>

@property (nonatomic) UIButton *button;
@property (nonatomic) MPInterstitialAdController *interstitial;

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
    
    // Load MoPub Interstitial
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

#pragma mark - MoPub

- (void)loadInterstitial {
#error Add your MoPub Ad Unit Id below.
    // Instantiate the interstitial using the class convenience method.
    self.interstitial = [MPInterstitialAdController interstitialAdControllerForAdUnitId:@"INSERT_AD_UNIT_ID_HERE"];
    
    // Fetch the interstitial ad.
    [self.interstitial loadAd];
    
    // Delegate
    self.interstitial.delegate = self;
}

- (void)showAd:(id)sender {
    [self.interstitial showFromViewController:self];
}

#pragma mark - MPInterstitialAdControllerDelegate

- (void)interstitialDidLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    // Enabling the button if the interstitial is ready
    if (self.interstitial.ready) {
        self.button.enabled = YES;
    }
}

- (void)interstitialDidFailToLoadAd:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialWillAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialDidAppear:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialWillDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)interstitialDidDisappear:(MPInterstitialAdController *)interstitial {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
