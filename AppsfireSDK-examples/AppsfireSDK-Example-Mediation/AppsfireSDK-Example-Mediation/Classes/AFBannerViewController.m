//
//  AFBannerViewController.m
//  AppsfireSDK-Example-Mediation
//
//  Created by Ali Karagoz on 02/10/14.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AFBannerViewController.h"

// Appsfire SDK
#import "AppsfireSDKConstants.h"
#import "AFMedBannerView.h"

typedef NS_ENUM(NSUInteger, AFInterstitialStatus) {
    AFInterstitialStatusNone = 0,
    AFInterstitialStatusLoading,
    AFInterstitialStatusLoaded,
    AFInterstitialStatusFailed
};

@interface AFBannerViewController () <AFMedBannerViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) AFMedBannerView *bannerView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) AFInterstitialStatus status;
@property (nonatomic, assign, getter = isBannerVisible) BOOL bannerVisible;

@end

@implementation AFBannerViewController

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.title = @"Banner Demo";
    _status = AFInterstitialStatusNone;
    _bannerVisible = NO;
    _dataSource = @[
                    @"Locavore chia Carles, street art literally. 3 wolf moon kitsch.",
                    @"Lo-fi Schlitz tofu, vegan salvia, photo booth.",
                    @"Helvetica mustache chambray four loko, tilde craft beer.",
                    @"Whatever gastropub mustache, photo booth,church-key tilde.",
                    @"Etsy quinoa disrupt keytar organic ugh fanny pack.",
                    @"VHS cray 3 wolf moon kitsch church-key tilde craft beer.",
                    @"Skateboard roof party leggings, mixtape asymmetrical.",
                    @"Slow-carb roof party American Apparel, keytar organic ugh.",
                    @"Kickstarter VHS. Readymade pour-over literally.",
                    @"Locavore chia Carles, street art literally, American Apparel.",
                    @"Lo-fi Schlitz tofu, vegan salvia, Slow-carb roof party.",
                    @"Helvetica mustache chambray four loko, organic ugh fanny pack.",
                    @"Whatever gastropub mustache, photo booth, organic ugh fanny pack.",
                    @"Etsy quinoa disrupt keytar organic ugh fanny pack.",
                    @"VHS cray 3 wolf moon kitsch church-key tilde craft beer.",
                    @"Skateboard roof party leggings, mixtape asymmetrical.",
                    @"Slow-carb roof party American Apparel, church-key tilde craft.",
                    @"Kickstarter VHS. Readymade pour-over literally."
                    ];
    
    return self;
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    // View configuration
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    
    // TableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    self.tableView.rowHeight = 80.0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    // Status Label
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 60.0)];
    self.statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.statusLabel.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.statusLabel.font = [UIFont fontWithName:@"Courier" size:14.0];
    self.statusLabel.minimumScaleFactor = 2;
    self.statusLabel.numberOfLines = 2;
    self.statusLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.userInteractionEnabled = YES;
    self.tableView.tableHeaderView = self.statusLabel;
    
    // Banner View
    CGSize bannerSize = CGSizeMake(CGRectGetWidth(self.view.bounds), kAFAdSDKBannerHeight50);
    #error Add your Appsfire Banner Placement Id below.
    self.bannerView = [[AFMedBannerView alloc] initWithAdPlacementId:@"<APPSFIRE_PLACEMENT_ID>" size:bannerSize];
    self.bannerView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin);
    self.bannerView.delegate = self;
    
    self.bannerView.frame = CGRectMake(0.0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), kAFAdSDKBannerHeight50);
    self.bannerView.logsEnabled = YES;
    self.bannerView.alpha = 0;
    [self.view addSubview:self.bannerView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Status
    [self.bannerView loadAd];
    _status = AFInterstitialStatusLoading;
    self.statusLabel.text = @"Loading banner...";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    
    if (indexPath.row < self.dataSource.count) {
        cell.textLabel.text = self.dataSource[indexPath.row];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AFMedBannerViewDelegate

- (UIViewController *)viewControllerForBannerView:(AFMedBannerView *)bannerView {
    return self;
}

- (void)bannerViewDidLoadAd:(AFMedBannerView *)bannerView {
    _status = AFInterstitialStatusLoaded;
    
    [self showBanner];
    self.statusLabel.text = @"Banner loaded";
}

- (void)bannerViewDidFailToLoadAd:(AFMedBannerView *)bannerView withError:(NSError *)error {
    _status = AFInterstitialStatusFailed;
    
    [self hideBanner];
    self.statusLabel.text = @"Banner failed to load";
}

- (void)bannerViewBeginOverlayPresentation:(AFMedBannerView *)bannerView {

    self.statusLabel.text = @"Begin overlay presentation";
}

- (void)bannerViewEndOverlayPresentation:(AFMedBannerView *)bannerView {
    self.statusLabel.text = @"Banner end overlay presentation";
    
}

- (void)bannerViewDidRecordClick:(AFMedBannerView *)bannerView {
    self.statusLabel.text = @"Banner did record click";
    
}

#pragma mark - Show / Hide Banner

- (void)showBanner {
    
    if (self.isBannerVisible) {
        return;
    }
    
    // Getting the size of the hosted banner in order to resize.
    CGSize hostedViewSize = self.bannerView.hostedBannerView.bounds.size;
    
    // Banner placement
    __block CGRect bannerFrame = CGRectMake(CGRectGetWidth(self.view.bounds) / 2.0 - hostedViewSize.width / 2.0,
                                    CGRectGetHeight(self.view.bounds),
                                    hostedViewSize.width,
                                    kAFAdSDKBannerHeight50);
    self.bannerView.frame = bannerFrame;
    self.bannerView.alpha = 0;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        // Banner placement
        bannerFrame.origin.y = CGRectGetHeight(self.view.bounds) - kAFAdSDKBannerHeight50;
        self.bannerView.frame = bannerFrame;
        
        // TableView placement
        CGRect tableViewFrame = self.tableView.frame;
        tableViewFrame.size.height = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.bannerView.bounds);
        self.tableView.frame = tableViewFrame;
        
        self.bannerView.alpha = 1;
        
    } completion:^(BOOL finished) {
        self.bannerVisible = YES;
    }];
}

- (void)hideBanner {
    
    if (!self.isBannerVisible) {
        return;
    }
    
    // Getting the size of the hosted banner in order to resize.
    CGSize hostedViewSize = self.bannerView.hostedBannerView.bounds.size;
    
    // Banner placement
    __block CGRect bannerFrame = CGRectMake(CGRectGetWidth(self.view.bounds) / 2.0 - hostedViewSize.width / 2.0,
                                            CGRectGetHeight(self.view.bounds) - kAFAdSDKBannerHeight50,
                                            hostedViewSize.width,
                                            kAFAdSDKBannerHeight50);
    self.bannerView.frame = bannerFrame;
    
    self.bannerView.alpha = 1;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        // Banner placement
        bannerFrame.origin.y = CGRectGetHeight(self.view.bounds);
        self.bannerView.frame = bannerFrame;
        
        // TableView placement
        self.tableView.frame = self.view.bounds;
        
        self.bannerView.alpha = 0;
        
    } completion:^(BOOL finished) {
        self.bannerVisible = NO;
    }];
}

@end
