//
//  AppTableViewController.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 04/02/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AppTableViewController.h"
// helpers
#import "AppsfireAdSDK.h"
// controllers
#import "ExampleMinimalSashimiTableViewController.h"
#import "ExampleExtendedSashimiTableViewController.h"
#import "ExampleCustomSashimiTableViewController.h"
#import "ExampleCustomSashimiWithXIBTableViewController.h"
#import "ExampleUdonNoodleTableViewController.h"
#import "ExampleCarouselSashimiTableViewController.h"
#import "ExampleHimonoViewController.h"

@implementation AppTableViewController

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style {
    
    if ((self = [super initWithStyle:style]) != nil) {
        
        // title
        self.title = @"Appsfire SDK - Sashimi";
        self.tableView.rowHeight = 65.0;

    }
    return self;
    
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return 6;
    else
        return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0)
        return @"All the formats";
    else
        return @"Helper classes";
    
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
    if (indexPath.section == 0) {
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
                cellTitle = @"Sashimi Custom (with XIB)";
                break;
            case 4:
                cellTitle = @"Udon Noodle (Pull-to-Refresh)";
                break;
            case 5:
                cellTitle = @"Himono (Banner)";
                break;
            default:
                cellTitle = @"";
                break;
        }
    }
    else {
        switch (indexPath.row) {
            case 0:
                cellTitle = @"Carousel";
                break;
            default:
                cellTitle = @"";
                break;
        }
    }
    [ cell.textLabel setText:cellTitle ];
    
    //
    return cell;
    
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIViewController *controller;
    
    // all formats
    if (indexPath.section == 0) {
    
        switch (indexPath.row) {
            
            // sashimi minimal
            case 0:
            {
                controller = [[ExampleMinimalSashimiTableViewController alloc] initWithStyle:UITableViewStylePlain];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }

            // sashimi extended
            case 1:
            {
                controller = [[ExampleExtendedSashimiTableViewController alloc] initWithStyle:UITableViewStylePlain];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }

            // sashimi custom
            case 2:
            {
                controller = [[ExampleCustomSashimiTableViewController alloc] initWithStyle:UITableViewStylePlain];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }

            // sashimi custom (with XIB)
            case 3:
            {
                controller = [[ExampleCustomSashimiWithXIBTableViewController alloc] initWithStyle:UITableViewStylePlain];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }

            // udon noodle
            case 4:
            {
                controller = [[ExampleUdonNoodleTableViewController alloc] initWithStyle:UITableViewStylePlain];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            // himono
            case 5:
            {
                controller = [[ExampleHimonoViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];                
                break;
            }

            default:
                break;
        }
            
    }
    
    // helper classes
    else {
        
        switch (indexPath.row) {
                
            // carousel
            case 0:
            {
                controller = [[ExampleCarouselSashimiTableViewController alloc] initWithStyle:UITableViewStylePlain];
                [self.navigationController pushViewController:controller animated:YES];
                break;
            }
                
            default:
                break;
        }
        
    }
    
}

@end
