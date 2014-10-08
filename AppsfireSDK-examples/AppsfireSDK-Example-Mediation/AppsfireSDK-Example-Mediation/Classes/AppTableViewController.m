//
//  AppTableViewController.m
//  AppsfireSDK-Example-Mediation
//
//  Created by Ali Karagoz on 01/10/14.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AppTableViewController.h"

// Appsfire SDK
#import "AppsfireAdSDK.h"

#import "AFInterstitialViewController.h"
#import "AFBannerViewController.h"

@implementation AppTableViewController

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style {
    
    if ((self = [super initWithStyle:style]) != nil) {
        
        // title
        self.title = @"Appsfire SDK - Mediation";
        self.tableView.rowHeight = 80.0;
        
    }
    return self;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier" ];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdentifier"];
    }
    
    // Setting the title
    NSString *cellTitle;
    switch (indexPath.row) {
        case 0: {
            cellTitle = @"Interstitial";
        } break;
            
        case 1: {
            cellTitle = @"Banner";
        } break;
            
        default: {
        } break;
    }
    
    [cell.textLabel setText:cellTitle];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0: {
            AFInterstitialViewController *interstitialViewController = [[AFInterstitialViewController alloc] init];
            [self.navigationController pushViewController:interstitialViewController animated:YES];
        } break;
            
        case 1: {
            AFBannerViewController *bannerViewController = [[AFBannerViewController alloc] init];
            [self.navigationController pushViewController:bannerViewController animated:YES];
        } break;
            
        default: {
        } break;
    }
    
}

@end
