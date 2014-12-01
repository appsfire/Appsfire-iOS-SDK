//
//  AFInterstitialViewController.m
//  AppsfireSDK-Example-Mediation
//
//  Created by Ali Karagoz on 01/10/14.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AFInterstitialViewController.h"

// Appsfire SDK
#import "AFMedInterstitial.h"

typedef NS_ENUM(NSUInteger, AFInterstitialStatus) {
    AFInterstitialStatusNone = 0,
    AFInterstitialStatusLoading,
    AFInterstitialStatusLoaded,
    AFInterstitialStatusFailed
};

@interface AFInterstitialViewController () <AFMedInterstitialDelegate>

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) AFMedInterstitial *interstitial;
@property (nonatomic, assign) AFInterstitialStatus status;

@end

@implementation AFInterstitialViewController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    self.title = @"Interstitial Demo";
    _status = AFInterstitialStatusNone;
    
    return self;
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    // View configuration
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    
    // Show Ad Button
    self.button = [[UIButton alloc] init];
    [self.button setTitle:@"Tap to load" forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.button setTitleColor:[UIColor colorWithWhite:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithWhite:0.5 alpha:1.0] forState:UIControlStateHighlighted];
    [self.button setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateDisabled];
    self.button.layer.cornerRadius = 5.0;
    
    [self.button sizeToFit];
    CGSize showAdButtonSize = CGSizeMake(200.0, 50.0);
    self.button.frame = CGRectMake(CGRectGetWidth(self.view.bounds) / 2.0 - showAdButtonSize.width / 2.0,
                                         CGRectGetHeight(self.view.bounds) / 2.0 - showAdButtonSize.height / 2.0,
                                         showAdButtonSize.width,
                                         showAdButtonSize.height);
    self.button.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin| UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin);
    [self.button addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    // Status Label
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0,
                                                                 CGRectGetHeight(self.view.bounds) - 60.0,
                                                                 CGRectGetWidth(self.view.bounds), 60.0)];
    self.statusLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin);
    self.statusLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.statusLabel.font = [UIFont fontWithName:@"Courier" size:14.0];
    self.statusLabel.minimumScaleFactor = 2;
    self.statusLabel.numberOfLines = 2;
    self.statusLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];
}

#pragma mark - Appsfire Mediation

- (void)loadInterstitial {
    
    // Instantiate the interstitial using the class convenience method.
    #error Add your Appsfire Interstitial Placement Id below.
    self.interstitial = [[AFMedInterstitial alloc] initWithAdPlacementId:@"<APPSFIRE_PLACEMENT_ID>"];
    self.interstitial.delegate = self;
    self.interstitial.logsEnabled = YES;
    
    // Loading the interstitial ad.
    [self.interstitial loadAd];
    
    // Status
    self.status = AFInterstitialStatusLoading;
    self.statusLabel.text = @"Loading interstitial...";
    self.button.enabled = NO;
}

- (void)didTapButton:(id)sender {
    
    switch (self.status) {
        case AFInterstitialStatusNone: {
            [self loadInterstitial];
        } break;
        
        case AFInterstitialStatusLoading: {
        } break;
            
        case AFInterstitialStatusLoaded: {
            
            if (self.interstitial.isReady) {
                [self.interstitial presentInterstitial];
            }
        
        } break;
        
        case AFInterstitialStatusFailed: {
            [self loadInterstitial];
        }
    }
    
}

#pragma mark - AFMedInterstitialDelegate

- (UIViewController *)viewControllerForInterstitial:(AFMedInterstitial *)interstitial {
    return self;
}

- (void)interstitialDidLoadAd:(AFMedInterstitial *)interstitial {
    self.status = AFInterstitialStatusLoaded;
    
    // Status
    [self.button setTitle:@"Tap to show" forState:UIControlStateNormal];
    self.statusLabel.text = @"Interstitial loaded";
    self.button.enabled = YES;
}

- (void)interstitialDidFailToLoadAd:(AFMedInterstitial *)interstitial withError:(NSError *)error {
    self.status = AFInterstitialStatusFailed;
    
    [self.button setTitle:@"Tap to re-load" forState:UIControlStateNormal];
    self.statusLabel.text = @"Failed to load interstitial";
    self.button.enabled = YES;
}

- (void)interstitialWillAppear:(AFMedInterstitial *)interstitial {

    self.statusLabel.text = @"Interstitial will appear";
}

- (void)interstitialDidAppear:(AFMedInterstitial *)interstitial {

    self.statusLabel.text = @"Interstitial did appear";
}

- (void)interstitialWillDisappear:(AFMedInterstitial *)interstitial {

    self.statusLabel.text = @"Interstitial will disappear";
}

- (void)interstitialDidDisappear:(AFMedInterstitial *)interstitial {

    self.status = AFInterstitialStatusNone;
    [self.button setTitle:@"Tap to re-load" forState:UIControlStateNormal];
    self.statusLabel.text = @"Interstitial did disappear";
}

- (void)interstitialDidExpire:(AFMedInterstitial *)interstitial {

    self.statusLabel.text = @"Interstitial did expire";
}

@end
