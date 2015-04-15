//
//  ExampleHimonoViewController.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 13/04/2015.
//  Copyright (c) 2015 Appsfire. All rights reserved.
//

#import "ExampleHimonoViewController.h"
// helpers
#import "AppsfireSDKConstants.h"
// views
#import "AFAdSDKHimonoBannerView.h"

@interface ExampleHimonoViewController() <UITableViewDataSource, AFAdSDKHimonoBannerViewDelegate>

@property (nonatomic, strong) NSMutableArray *arraySource;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) AFAdSDKHimonoBannerView *himonoBannerView;

@end

@implementation ExampleHimonoViewController

- (id)init {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    if ((self = [super init]) != nil) {
        
        //
        self.title = @"Himono";
        
        //
        self.arraySource = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LoremIpsum" ofType:@"plist"]];
        
    }
    return self;
    
}

- (void)loadView {
    
    CGFloat himonoHeight;
        
    //
    [super loadView];
    
    //
    self.view.backgroundColor = [UIColor whiteColor];
    
    // table view
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100.0;
    [self.view addSubview:self.tableView];

    // himono height
    // use bigger view on iPad
    himonoHeight = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? kAFAdSDKBannerHeight90 : kAFAdSDKBannerHeight50;

    // himono view
    self.himonoBannerView = [[AFAdSDKHimonoBannerView alloc] initWithAdSize:CGSizeMake(320.0, himonoHeight)];
    self.himonoBannerView.backgroundColor = [UIColor lightGrayColor];
    self.himonoBannerView.delegate = self;
    [self.himonoBannerView loadAd];
    
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    
    CGRect himonoViewFrame;
    CGRect tableViewFrame;
    
    // himono
    himonoViewFrame = CGRectZero;
    if (self.himonoBannerView.loaded) {
        himonoViewFrame.size = CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.himonoBannerView.frame));
        himonoViewFrame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(himonoViewFrame);
        self.himonoBannerView.frame = himonoViewFrame;
        if (self.himonoBannerView.superview == nil)
            [self.view addSubview:self.himonoBannerView];
    }
    
    // table view
    tableViewFrame = self.view.bounds;
    tableViewFrame.size.height -= CGRectGetHeight(himonoViewFrame);
    self.tableView.frame = tableViewFrame;
    
}

#pragma mark - Himono Delegate

- (void)himonoBannerViewDidLoadAd:(AFAdSDKHimonoBannerView *)himonoBannerView {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    // refresh layout in order to reveal himono
    // only if superview is nil, meaning that it isn't displayed yet
    if (self.himonoBannerView.superview == nil)
        [self.view setNeedsLayout];
    
}

- (void)himonoBannerViewDidFailToLoadAd:(AFAdSDKHimonoBannerView *)himonoBannerView withError:(NSError *)error {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

}

- (UIViewController *)viewControllerForHimonoBannerView:(AFAdSDKHimonoBannerView *)himonoBannerView {
    
    return self;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arraySource count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id sourceObject;
    NSString *celluid;
    UITableViewCell *cell;
    
    // get source object
    sourceObject = nil;
    if (indexPath.row < [self.arraySource count]) {
        sourceObject = self.arraySource[indexPath.row];
    }
    
    // determine cell id
    celluid = @"classic";
    
    // get cell
    cell = [tableView dequeueReusableCellWithIdentifier:celluid];
    if (!cell) {
        
        // create cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:celluid];
        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [cell.textLabel setNumberOfLines:1];
        [cell.detailTextLabel setNumberOfLines:3];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        
        // no selection
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    [cell.textLabel setText:sourceObject[@"title"]];
    [cell.detailTextLabel setText:sourceObject[@"content"]];
    
    return cell;
    
}

@end
