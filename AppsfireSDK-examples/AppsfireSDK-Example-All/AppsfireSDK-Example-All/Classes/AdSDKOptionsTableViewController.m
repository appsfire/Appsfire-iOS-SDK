//
//  AdSDKOptionsTableViewController.m
//  Appsfire SDK Demo
//
//  Created by Ali Karagoz on 20/12/2013.
//  Copyright (c) 2013 Appsfire. All rights reserved.
//

#import "AdSDKOptionsTableViewController.h"

// Appsfire
#import "AppsfireAdSDK.h"
#import "AppsfireAdTimerView.h"

// Sashimi
#import "ExampleMinimalSashimiTableViewController.h"
#import "ExampleExtendedSashimiTableViewController.h"
#import "ExampleCustomSashimiTableViewController.h"

typedef NS_ENUM(NSUInteger, AFAdSDKSection) {
    AFAdSDKSectionInterstitial = 0,
    AFAdSDKSectionInStream,
    AFAdSDKSectionNum
};

typedef NS_ENUM(NSUInteger, AFAdSDKRowInterstitial) {
    AFAdSDKRowInterstitialSushi = 0,
    AFAdSDKRowInterstitialUramakiWithoutTimer,
    AFAdSDKRowInterstitialUramakiWithTimer,
    AFAdSDKRowInterstitialNum,
};

typedef NS_ENUM(NSUInteger, AFAdSDKRowInStream) {
    AFAdSDKRowInStreamSashimiMinimal = 0,
    AFAdSDKRowInStreamSashimiExtended,
    AFAdSDKRowInStreamSashimiCustom,
    AFAdSDKRowInStreamSashimiNum
};

@interface AdSDKOptionsTableViewController ()

@end

@implementation AdSDKOptionsTableViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self == nil) {
        return nil;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Monetization Features";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AFAdSDKSectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case AFAdSDKSectionInterstitial: {
            return AFAdSDKRowInterstitialNum;
        } break;
            
        case AFAdSDKSectionInStream: {
            return AFAdSDKRowInStreamSashimiNum;
        } break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case AFAdSDKSectionInterstitial: {
            return @"Interstial Formats";
        } break;
            
        case AFAdSDKSectionInStream: {
            return @"In-stream Formats";
        } break;
            
        default: {
            return @"";
        } break;
    }
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
    
    // Text Label
    cell.textLabel.numberOfLines = 0;
    
    // Details Text Label
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
    
    switch (indexPath.section) {
        case AFAdSDKSectionInterstitial: {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            switch (indexPath.row) {
                    
                case AFAdSDKRowInterstitialSushi: {
                    cell.textLabel.text = @"Sushi";
                } break;
                    
                case AFAdSDKRowInterstitialUramakiWithoutTimer: {
                    cell.textLabel.text = @"Uramaki";
                } break;
                    
                case AFAdSDKRowInterstitialUramakiWithTimer: {
                    cell.textLabel.text = @"Uramaki (with timer)";
                } break;
                    
                default: {
                } break;
            }
            
        } break;
            
        case AFAdSDKSectionInStream: {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            switch (indexPath.row) {
                case AFAdSDKRowInStreamSashimiMinimal: {
                    cell.textLabel.text = @"Sashimi Minimal";
                } break;
                    
                case AFAdSDKRowInStreamSashimiExtended: {
                    cell.textLabel.text = @"Sashimi Extended";
                } break;
                    
                case AFAdSDKRowInStreamSashimiCustom: {
                    cell.textLabel.text = @"Sashimi Custom";
                } break;
                    
                default: {
                } break;
            }
            
        } break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *typeString;
    BOOL shouldUseTimer = NO;
    
    switch (indexPath.section) {
        case AFAdSDKSectionInterstitial: {
            
            AFAdSDKModalType modalType;
            switch (indexPath.row) {
                    
                case AFAdSDKRowInterstitialSushi: {
                    modalType = AFAdSDKModalTypeSushi;
                    typeString = @"Sushi";
                    shouldUseTimer = NO;
                } break;
                    
                case AFAdSDKRowInterstitialUramakiWithoutTimer: {
                    modalType = AFAdSDKModalTypeUraMaki;
                    typeString = @"Uramaki";
                    shouldUseTimer = NO;
                } break;
                    
                case AFAdSDKRowInterstitialUramakiWithTimer: {
                    modalType = AFAdSDKModalTypeUraMaki;
                    typeString = @"Uramaki";
                    shouldUseTimer = YES;
                } break;
                    
                default: {
                    modalType = AFAdSDKModalTypeSushi;
                } break;
            }
            
            if (![AppsfireAdSDK isThereAModalAdAvailableForType:modalType] == AFAdSDKAdAvailabilityYes) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:typeString message:@"This Ad format is not yet ready, try again in a few seconds." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
                
            } else {
                
                // Showing a timer before presenting the Ad.
                if (shouldUseTimer) {
                    [[[AppsfireAdTimerView alloc] initWithCountdownStart:3] presentWithCompletion:^(BOOL accepted) {
                        if (accepted) {
                            [AppsfireAdSDK requestModalAd:modalType withController:self];
                        }
                    }];
                }
                
                // Simply showing the Ad.
                else {
                    [AppsfireAdSDK requestModalAd:modalType withController:self];
                }
            }
            
        } break;
            
        case AFAdSDKSectionInStream: {
            
            UIViewController *controller;
            
            switch (indexPath.row) {
                case AFAdSDKRowInStreamSashimiMinimal: {
                    controller = [[ExampleMinimalSashimiTableViewController alloc ] initWithStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:controller animated:YES];
                } break;
                    
                case AFAdSDKRowInStreamSashimiExtended: {
                    controller = [[ExampleExtendedSashimiTableViewController alloc ] initWithStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:controller animated:YES];
                } break;
                    
                case AFAdSDKRowInStreamSashimiCustom: {
                    controller = [[ExampleCustomSashimiTableViewController alloc ] initWithStyle:UITableViewStylePlain];
                    [self.navigationController pushViewController:controller animated:YES];
                } break;
                    
                default:
                    break;
            }
            
        } break;
            
        default:
            break;
    }
}

@end
