//
//  SDKOptionsTableViewController.m
//  Appsfire SDK Demo
//
//  Created by Ali Karagoz on 18/09/13.
//  Copyright (c) 2013 Appsfire. All rights reserved.
//

#import "SDKOptionsTableViewController.h"

#import "AppsfireSDK.h"
#import "AFBadgeView.h"
#import "NotificationBarExampleController.h"

typedef NS_ENUM(NSUInteger, AppsfireSDKSection) {
    AppsfireSDKSectionTypes = 0,
    AppsfireSDKSectionPresentationStyles,
    AppsfireSDKSectionCustomization,
    AppsfireSDKSectionUIIntegration,
    AppsfireSDKSectionNum
};

typedef NS_ENUM(NSUInteger, AppsfireSDKTypesRow) {
    AppsfireSDKTypesRowNotifications = 0,
    AppsfireSDKTypesRowFeedback,
    AppsfireSDKTypesRowNum
};

typedef NS_ENUM(NSUInteger, AppsfireSDKPresentationStylesRow) {
    AppsfireSDKPresentationStylesRowDefault = 0,
    AppsfireSDKPresentationStylesRowFullscreen,
    AppsfireSDKPresentationStylesRowNavigation,
    AppsfireSDKPresentationStylesRowModal,
    AppsfireSDKPresentationStylesRowNum
};

typedef NS_ENUM(NSUInteger, AppsfireSDKCustomizationRow) {
    AppsfireSDKCustomizationRowColor = 0,
    AppsfireSDKCustomizationRowNum
};

typedef NS_ENUM(NSUInteger, AppsfireSDKUIIntegration) {
    AppsfireSDKUIIntegrationRowBadgeView = 0,
    AppsfireSDKUIIntegrationRowBarView,
    AppsfireSDKUIIntegrationRowNum
};

@interface SDKOptionsTableViewController ()

@property (nonatomic) UIViewController *navigationViewController;
@property (nonatomic) UIViewController *modViewController;

@end

@implementation SDKOptionsTableViewController

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
    self.title = @"Engagement Features";
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return AppsfireSDKSectionNum;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case AppsfireSDKSectionTypes: {
            return AppsfireSDKTypesRowNum;
        } break;
            
        case AppsfireSDKSectionPresentationStyles: {
            return AppsfireSDKPresentationStylesRowNum;
        } break;
            
        case AppsfireSDKSectionCustomization: {
            return AppsfireSDKCustomizationRowNum;
        } break;
            
        case AppsfireSDKSectionUIIntegration : {
            return AppsfireSDKUIIntegrationRowNum;
        } break;
            
        default: {
            return 0;
        } break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case AppsfireSDKSectionTypes: {
            return @"Content Types";
        } break;
            
        case AppsfireSDKSectionPresentationStyles: {
            return @"Presentation Styles";
        } break;
            
        case AppsfireSDKSectionCustomization: {
            return @"Customization";
        } break;
            
        case AppsfireSDKSectionUIIntegration: {
            return @"Integration Examples";
        } break;
            
        default: {
            return @"";
        } break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
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
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    
    switch (indexPath.section) {
            
        case AppsfireSDKSectionTypes: {
            switch (indexPath.row) {
                case AppsfireSDKTypesRowNotifications: {
                    cell.textLabel.text = @"Notification Wall";
                    cell.detailTextLabel.text = @"Show the list of the notifications that are available.";
                } break;
                    
                case AppsfireSDKTypesRowFeedback: {
                    cell.textLabel.text = @"Feedback Form";
                    cell.detailTextLabel.text = @"Show the Feedback form.";
                } break;
                    
                default:
                    break;
            }
            
        } break;
            
        case AppsfireSDKSectionPresentationStyles: {
            switch (indexPath.row) {
                case AppsfireSDKPresentationStylesRowDefault: {
                    cell.textLabel.text = @"Default";
                    cell.detailTextLabel.text = @"Floating style presentation.";
                } break;
                    
                case AppsfireSDKPresentationStylesRowFullscreen: {
                    cell.textLabel.text = @"Fullscreen";
                    cell.detailTextLabel.text = @"Full screen presentation style";
                } break;
                    
                case AppsfireSDKPresentationStylesRowNavigation: {
                    cell.textLabel.text = @"UIViewController (Navigation Controller)";
                    cell.detailTextLabel.text = @"Push/Pop presentation style in a navigation controller.";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                } break;
                    
                case AppsfireSDKPresentationStylesRowModal: {
                    cell.textLabel.text = @"UIViewController (Modal Presentation)";
                    cell.detailTextLabel.text = @"Modal presentation style.";
                } break;
                    
                default:
                    break;
            }
            
        } break;
            
        case AppsfireSDKSectionCustomization: {
            switch (indexPath.row) {
                case AppsfireSDKCustomizationRowColor: {
                    cell.textLabel.text = @"Color customization";
                    cell.detailTextLabel.text = @"You have the ability to customize the color of the panel.";
                } break;
                    
                default:
                    break;
            }
            
        } break;
            
        case AppsfireSDKSectionUIIntegration: {
            switch (indexPath.row) {
                case AppsfireSDKUIIntegrationRowBadgeView: {
                    cell.textLabel.text = @"Badge View";
                    cell.detailTextLabel.text = @"Get the number of notifications via a circular badge.";
                    
                    // For the demo we are going to add a badge to our table view cell
                    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
                    accessoryView.userInteractionEnabled = NO;
                    accessoryView.backgroundColor = [UIColor clearColor];
                    
                    AFBadgeView *badgeView = [[AFBadgeView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
                    [accessoryView addSubview:badgeView];
                    [badgeView updateBadgeCount];
                    
                    // Change the color of the badge
                    //badgeView.backgroundView.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:114.0 / 255.0 blue:226.0 / 255.0 alpha:1.0];
                    
                    // Change the "roundness of the badge"
                    //badgeView.backgroundView.layer.cornerRadius = 4.0;
                    
                    cell.accessoryView = accessoryView;
                } break;
                    
                case AppsfireSDKUIIntegrationRowBarView: {
                    cell.textLabel.text = @"Notification Bar View";
                    cell.detailTextLabel.text = @"Access to the notifications via a bar view.";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                } break;
                    
                default:
                    break;
            }
        } break;
            
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case AppsfireSDKSectionTypes: {
            switch (indexPath.row) {
                case AppsfireSDKTypesRowNotifications: {
                    [AppsfireSDK presentPanelForContent:AFSDKPanelContentDefault withStyle:AFSDKPanelStyleDefault];
                } break;
                    
                case AppsfireSDKTypesRowFeedback: {
                    [AppsfireSDK presentPanelForContent:AFSDKPanelContentFeedbackOnly withStyle:AFSDKPanelStyleDefault];
                } break;
                    
                default:
                    break;
            }
            
        } break;
            
        case AppsfireSDKSectionPresentationStyles: {
            switch (indexPath.row) {
                case AppsfireSDKPresentationStylesRowDefault: {
                    [AppsfireSDK presentPanelForContent:AFSDKPanelContentDefault withStyle:AFSDKPanelStyleDefault];
                } break;
                    
                case AppsfireSDKPresentationStylesRowFullscreen: {
                    [AppsfireSDK presentPanelForContent:AFSDKPanelContentDefault withStyle:AFSDKPanelStyleFullscreen];
                } break;
                    
                case AppsfireSDKPresentationStylesRowNavigation: {
                    
                    NSError *error;
                    self.navigationViewController = [AppsfireSDK getPanelViewControllerWithError:&error];
                    
                    if (self.navigationViewController != nil) {
                        [self.navigationController pushViewController:self.navigationViewController animated:YES];
                    } else {
                        NSLog(@"Error while getting the panel view controller : %@", error.localizedDescription);
                    }
                    
                } break;
                    
                case AppsfireSDKPresentationStylesRowModal: {
                    
                    // Note that if you want to easily dismiss the modally presented controller
                    // you can implement the delegate method `-panelViewControllerNeedsToBeDismissed:`
                    
                    NSError *error;
                    self.modViewController = [AppsfireSDK getPanelViewControllerWithError:&error];
                    
                    if (self.modViewController != nil) {
                        [self.navigationController presentModalViewController:self.modViewController animated:YES];
                    } else {
                        NSLog(@"Error while getting the panel view controller : %@", error.localizedDescription);
                    }
                    
                } break;
                    
                default:
                    break;
            }
            
        } break;
            
        case AppsfireSDKSectionCustomization: {
            switch (indexPath.row) {
                case AppsfireSDKCustomizationRowColor: {
                    [AppsfireSDK setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:148.0/255.0 blue:18.0/255.0 alpha:1.0] textColor:[UIColor whiteColor]];
                    [AppsfireSDK presentPanelForContent:AFSDKPanelContentDefault withStyle:AFSDKPanelStyleDefault];
                } break;
                    
                default:
                    break;
            }
            
        } break;
            
        case AppsfireSDKSectionUIIntegration: {
            switch (indexPath.row) {
                case AppsfireSDKUIIntegrationRowBadgeView: {
                    NSError *error;
                    self.navigationViewController = [AppsfireSDK getPanelViewControllerWithError:&error];
                    
                    if (self.navigationController != nil) {
                        [self.navigationController pushViewController:self.navigationViewController animated:YES];
                    } else {
                        NSLog(@"Error while getting the panel view controller : %@", error.localizedDescription);
                    }
                    
                } break;
                    
                case AppsfireSDKUIIntegrationRowBarView: {
                    NotificationBarExampleController *notificationBarExampleController = [[NotificationBarExampleController alloc] init];
                    [self.navigationController pushViewController:notificationBarExampleController animated:YES];
                    
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
