//
//  ExampleUdonNoodleTableViewController.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Ali on 14/04/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleUdonNoodleTableViewController.h"
// helpers
#import "AppsfireAdSDK.h"
// views
#import "AFAdSDKUdonNoodleControl.h"

@interface ExampleUdonNoodleTableViewController () <AFAdSDKUdonNoodleControlDelegate>

@property (nonatomic, strong) NSMutableArray *arraySource;

@property (nonatomic, strong) AFAdSDKUdonNoodleControl *udonNoodleControl;

@end

@implementation ExampleUdonNoodleTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    if ((self = [super initWithStyle:style]) != nil) {
        
        //
        self.title = @"Udon Noodle";
        self.tableView.rowHeight = 100.0;
                
        //
        self.arraySource = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LoremIpsum" ofType:@"plist"]];
        
    }
    return self;
    
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.udonNoodleControl = [[AFAdSDKUdonNoodleControl alloc] initWithScrollView:self.tableView];
    self.udonNoodleControl.delegate = self;
    [self.udonNoodleControl addTarget:self action:@selector(doRefresh:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Udon Noodle adjustments.
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        CGFloat topOffset = self.topLayoutGuide.length;
        self.udonNoodleControl.defaultTopContentOffset = topOffset;
    }
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

#pragma mark - Refreshing

- (void)doRefresh:(AFAdSDKUdonNoodleControl *)refreshControl {
    [refreshControl beginRefreshing];
    NSLog(@"Refreshing...");
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshControl endRefreshing];
        NSLog(@"Refreshed!");
    });
}

#pragma mark - AFAdSDKUdonNoodleControlDelegate

- (UIViewController *)viewControllerForUdonNoodleControl:(AFAdSDKUdonNoodleControl *)udonNoodleControl {
    return self;
}

- (void)udonNoodleControl:(AFAdSDKUdonNoodleControl *)udonNoodleControl customizeSashimiView:(AFAdSDKSashimiMinimalView *)sashimiView {
    
    // Uncomment the following lines to see the effect of customization.
    /*
     // Changing the background color to a lighter gray.
     sashimiView.contentBackgroundColor = [UIColor colorWithRed:240.0 / 255.0 green:240.0 / 255.0 blue:240.0 / 255.0 alpha:1.0];
     
     // Changing the color of the title to yellow.
     sashimiView.titleLabel.textColor = [UIColor colorWithRed:213.0 / 255.0 green:198.0 / 255.0 blue:136.0 / 255.0 alpha:1.0];
     
     // Changing the color of the icon color to black.
     sashimiView.iconBorderColor = [UIColor blackColor];
     */
}

@end
