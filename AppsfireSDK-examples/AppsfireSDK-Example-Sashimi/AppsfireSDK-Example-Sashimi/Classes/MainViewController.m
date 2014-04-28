//
//  AFSDKTableViewController.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 04/02/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "MainViewController.h"
// helpers
#import "AppsfireAdSDK.h"
// controllers
#import "ExampleMinimalSashimiTableViewController.h"
#import "ExampleExtendedSashimiTableViewController.h"
#import "ExampleCustomSashimiTableViewController.h"
#import "ExampleUdonNoodleTableViewController.h"

@implementation MainViewController

- (void)viewDidLoad {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);

    self.title = @"Sashimi Examples";
    self.tableView.rowHeight = 80.0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellTitle;
    UITableViewCell *cell;
    
    // get cell
    cell = [ tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (cell == nil) {
        
        cell = [ [ UITableViewCell alloc ] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ];
        [ cell setSelectionStyle:UITableViewCellSelectionStyleNone ];
        
    }
    
    // update title
    switch (indexPath.row) {
        case 0:
            cellTitle = @"Sashimi Minimal";
            break;
        case 1:
            cellTitle = @"Sashimi Extended";
            break;
        case 2:
            cellTitle = @"Sashimi Custom";
            break;
        case 3:
            cellTitle = @"Udon Noodle (Pull-to-Refresh)";
            break;
        default:
            cellTitle = @"";
            break;
    }
    [ cell.textLabel setText:cellTitle ];
    
    //
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *controller;
    
    switch (indexPath.row) {
        
        // sashimi minimal
        case 0:
        {
            controller = [[ExampleMinimalSashimiTableViewController alloc ] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }

        // sashimi extended
        case 1:
        {
            controller = [[ExampleExtendedSashimiTableViewController alloc ] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }

        // sashimi custom
        case 2:
        {
            controller = [[ExampleCustomSashimiTableViewController alloc ] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        
        // udon noodle
        case 3:
        {
            controller = [[ExampleUdonNoodleTableViewController alloc ] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }

        default:
            break;
    }
    
}

@end
