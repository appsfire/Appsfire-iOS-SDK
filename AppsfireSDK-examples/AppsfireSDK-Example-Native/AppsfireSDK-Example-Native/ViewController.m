//
//  ViewController.m
//  AppsfireSDK-Example-Native
//
//  Created by Vincent on 09/04/2015.
//  Copyright (c) 2015 appsfire. All rights reserved.
//

#import "ViewController.h"
// helpers
#import "AppsfireAdSDK.h"
// objects
#import "AFNativeAd.h"
// views
#import "ExampleCustomNativeAdView.h"

@interface ViewController () <AFNativeAdDelegate>

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) ExampleCustomNativeAdView *nativeAdView;

@property (nonatomic, strong) UIButton *refreshAdButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    // status label
    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.textColor = [UIColor blackColor];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.statusLabel];
    
    // native ad view
    self.nativeAdView = [[ExampleCustomNativeAdView alloc] init];
    self.nativeAdView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.view addSubview:self.nativeAdView];
    
    // refresh ad button
    self.refreshAdButton = [[UIButton alloc] init];
    [self.refreshAdButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.refreshAdButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.refreshAdButton setTitle:@"Ask New Ad" forState:UIControlStateNormal];
    [self.refreshAdButton addTarget:self action:@selector(refreshNativeAd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshAdButton];
    
    //
    [self refreshStatutes];
    
}

#pragma mark - Layout Subviews

- (void)viewWillLayoutSubviews {
    
    CGRect statusLabelFrame;
    CGRect nativeAdFrame;
    CGRect refreshAdButtonFrame;
    
    // status label
    statusLabelFrame = CGRectZero;
    statusLabelFrame.size = CGSizeMake(floor(CGRectGetWidth(self.view.frame) * 0.7), 100.0);
    statusLabelFrame.origin.x = floor(CGRectGetWidth(self.view.frame) / 2.0 - CGRectGetWidth(statusLabelFrame) / 2.0);
    statusLabelFrame.origin.y = CGRectGetHeight(self.view.frame) / 2.0 - CGRectGetHeight(statusLabelFrame) - 40.0;
    self.statusLabel.frame = statusLabelFrame;
    
    // native ad
    nativeAdFrame = CGRectZero;
    nativeAdFrame.size = CGSizeMake(CGRectGetWidth(self.view.frame) - 20.0, 90.0);
    nativeAdFrame.origin.x = floor(CGRectGetWidth(self.view.frame) / 2.0 - CGRectGetWidth(nativeAdFrame) / 2.0);
    nativeAdFrame.origin.y = floor(CGRectGetHeight(self.view.frame) / 2.0);
    self.nativeAdView.frame = nativeAdFrame;
    
    // refresh ad button
    refreshAdButtonFrame = CGRectZero;
    refreshAdButtonFrame.size = CGSizeMake(200.0, 44.0);
    refreshAdButtonFrame.origin.x = floor(CGRectGetWidth(self.view.frame) / 2.0 - CGRectGetWidth(refreshAdButtonFrame) / 2.0);
    refreshAdButtonFrame.origin.y = CGRectGetMaxY(nativeAdFrame) + 80.0;
    self.refreshAdButton.frame = refreshAdButtonFrame;
    
}

#pragma mark - Refresh Statutes

- (void)refreshStatutes {
    
    AFAdSDKAdAvailability adAvaibility;
    
    //
    adAvaibility = [AppsfireAdSDK isThereNativeAdAvailable];
    
    // status text
    if (adAvaibility == AFAdSDKAdAvailabilityPending)
        self.statusLabel.text = @"Status: pending";
    else if (adAvaibility == AFAdSDKAdAvailabilityYes)
        self.statusLabel.text = @"Status: ads available";
    else
        self.statusLabel.text = @"Status: no ads available";
    
    // refresh button
    self.refreshAdButton.enabled = (adAvaibility == AFAdSDKAdAvailabilityYes);
    
}

#pragma markr - Refresh Native Ad

- (void)refreshNativeAd {
    
    NSError *error;
    AFNativeAd *nativeAd;
    
    // verify that at least 1 ad is available
    if ([AppsfireAdSDK isThereNativeAdAvailable] != AFAdSDKAdAvailabilityYes) {
        [[[UIAlertView alloc] initWithTitle:@"Native Ad" message:@"Couldn't refresh native ad: no new ad to display" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        return;
    }
    
    // get native ad
    error = nil;
    nativeAd = [AppsfireAdSDK nativeAdWithError:&error];
    
    // set to view
    if ([nativeAd isKindOfClass:[AFNativeAd class]] && error == nil) {
        
        //
        nativeAd.delegate = self;
        
        // change the ad
        self.nativeAdView.nativeAd = nativeAd;
                
    }
    
}

#pragma mark - Native Ad Delegate

- (void)nativeAdDidRecordImpression:(AFNativeAd *)nativeAd {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

- (void)nativeAdDidRecordClick:(AFNativeAd *)nativeAd {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

- (void)nativeAdBeginOverlayPresentation:(AFNativeAd *)nativeAd {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
}

- (void)nativeAdEndOverlayPresentation:(AFNativeAd *)nativeAd {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

}

- (UIViewController *)viewControllerForNativeAd:(AFNativeAd *)nativeAd {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

    return self;
    
}

@end
