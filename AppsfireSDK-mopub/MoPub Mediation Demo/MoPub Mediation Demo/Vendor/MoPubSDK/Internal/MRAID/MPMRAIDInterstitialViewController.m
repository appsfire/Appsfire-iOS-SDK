//
//  MPMRAIDInterstitialViewController.m
//  MoPub
//
//  Copyright (c) 2012 MoPub, Inc. All rights reserved.
//

#import "MPMRAIDInterstitialViewController.h"

#import "MPAdConfiguration.h"

@interface MPMRAIDInterstitialViewController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation MPMRAIDInterstitialViewController

@synthesize delegate = _delegate;

- (id)initWithAdConfiguration:(MPAdConfiguration *)configuration
{
    self = [super init];
    if (self) {
        CGFloat width = MAX(configuration.preferredSize.width, 1);
        CGFloat height = MAX(configuration.preferredSize.height, 1);
        CGRect frame = CGRectMake(0, 0, width, height);
        _interstitialView = [[MRAdView alloc] initWithFrame:frame
                                            allowsExpansion:NO
                                           closeButtonStyle:MRAdViewCloseButtonStyleAdControlled
                                              placementType:MRAdViewPlacementTypeInterstitial];
        _interstitialView.delegate = self;
        _interstitialView.adType = configuration.precacheRequired ? MRAdViewAdTypePreCached : MRAdViewAdTypeDefault;
        _configuration = [configuration retain];
        self.orientationType = [_configuration orientationType];
        _advertisementHasCustomCloseButton = NO;
    }
    return self;
}

- (void)dealloc
{
    _interstitialView.delegate = nil;
    [_interstitialView release];
    [_configuration release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _interstitialView.frame = self.view.bounds;
    _interstitialView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_interstitialView];
}

#pragma mark - Public

- (void)startLoading
{
    [_interstitialView loadCreativeWithHTMLString:[_configuration adResponseHTMLString]
                                          baseURL:nil];
}

- (BOOL)shouldDisplayCloseButton
{
    return !_advertisementHasCustomCloseButton;
}

- (void)willPresentInterstitial
{
    if ([self.delegate respondsToSelector:@selector(interstitialWillAppear:)]) {
        [self.delegate interstitialWillAppear:self];
    }
}

- (void)didPresentInterstitial
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidAppear:)]) {
        [self.delegate interstitialDidAppear:self];
    }
}

- (void)willDismissInterstitial
{
    if ([self.delegate respondsToSelector:@selector(interstitialWillDisappear:)]) {
        [self.delegate interstitialWillDisappear:self];
    }
}

- (void)didDismissInterstitial
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidDisappear:)]) {
        [self.delegate interstitialDidDisappear:self];
    }
}

#pragma mark - MRAdViewDelegate

- (CLLocation *)location
{
    return [self.delegate location];
}

- (NSString *)adUnitId
{
    return [self.delegate adUnitId];
}

- (MPAdConfiguration *)adConfiguration
{
    return _configuration;
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}

- (void)adDidLoad:(MRAdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidLoadAd:)]) {
        [self.delegate interstitialDidLoadAd:self];
    }
}

- (void)adDidFailToLoad:(MRAdView *)adView
{
    if ([self.delegate respondsToSelector:@selector(interstitialDidFailToLoadAd:)]) {
        [self.delegate interstitialDidFailToLoadAd:self];
    }
}

- (void)adWillClose:(MRAdView *)adView
{
    [self dismissInterstitialAnimated:YES];
}

- (void)adDidClose:(MRAdView *)adView
{
    // TODO:
}

- (void)ad:(MRAdView *)adView didRequestCustomCloseEnabled:(BOOL)enabled
{
    _advertisementHasCustomCloseButton = enabled;
    [self layoutCloseButton];
}

- (void)appShouldSuspendForAd:(MRAdView *)adView
{

}

- (void)appShouldResumeFromAd:(MRAdView *)adView
{

}

@end
