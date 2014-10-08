//
//  AppTableViewController.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Ali Karagoz on 07/08/14.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AppTableViewController.h"

// Appsfire SDK
#import "AppsfireAdSDK.h"

@implementation AppTableViewController

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style {
    
    if ((self = [super initWithStyle:style]) != nil) {
        
        // title
        self.title = @"Appsfire SDK - IAP";
        self.tableView.rowHeight = 80.0;
        
    }
    return self;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
            cellTitle = @"Sushi";
        } break;
    }
    
    [cell.textLabel setText:cellTitle];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0: {
            
            // Show a sushi ad if available.
            if ([AppsfireAdSDK isThereAModalAdAvailableForType:AFAdSDKModalTypeSushi]) {
                [AppsfireAdSDK requestModalAd:AFAdSDKModalTypeSushi withController:self withDelegate:nil];
            }
            
        } break;
            
        default: {
        } break;
    }
    
}

@end
