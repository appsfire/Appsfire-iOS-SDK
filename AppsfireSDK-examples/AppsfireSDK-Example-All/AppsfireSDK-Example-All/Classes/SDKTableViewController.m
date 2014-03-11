//
//  SDKTableViewController.m
//  Appsfire SDK Demo
//
//  Created by Ali Karagoz on 16/09/13.
//  Copyright (c) 2013 Appsfire. All rights reserved.
//

#import "SDKTableViewController.h"

#import "AppsfireAdSDK.h"
#import "SDKOptionsTableViewController.h"
#import "AdSDKOptionsTableViewController.h"

typedef NS_ENUM(NSUInteger, AppsfireSDKSections) {
    AppsfireSDKSectionsSDK = 0,
    AppsfireSDKSectionsAdSDK,
    AppsfireSDKSectionsNum
};

@interface SDKTableViewController ()

@property (nonatomic, strong) SDKOptionsTableViewController *sdkTableViewController;
@property (nonatomic, strong) AdSDKOptionsTableViewController *adSdkTableViewController;

@end

@implementation SDKTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self == nil) {
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Title
    self.title = @"Appsfire SDK Demo";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AppsfireSDKSectionsNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configuring our cell
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.detailTextLabel.numberOfLines = 0;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section) {
        case AppsfireSDKSectionsSDK: {
            cell.textLabel.text = @"Engagement Features";
            cell.detailTextLabel.text = @"See examples of the presentation styles and some provided UI elements.";
        } break;
            
        case AppsfireSDKSectionsAdSDK: {
            cell.textLabel.text = @"Monetization Features";
            cell.detailTextLabel.text = @"Get an overview of our advertisement solutions.";
        } break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
            
        case AppsfireSDKSectionsSDK: {
            self.sdkTableViewController = [[SDKOptionsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:self.sdkTableViewController animated:YES];
        } break;
            
        case AppsfireSDKSectionsAdSDK: {
            self.adSdkTableViewController = [[AdSDKOptionsTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:self.adSdkTableViewController animated:YES];
        } break;
            
        default:
            break;
    }
}

@end
