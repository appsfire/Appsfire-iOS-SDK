//
//  SDKOptionsTableViewController.m
//  Appsfire SDK Demo
//
//  Created by Ali Karagoz on 18/09/13.
//  Copyright (c) 2013 Appsfire. All rights reserved.
//

#import "AppTableViewController.h"
// appsfire sdk
#import "AppsfireSDK.h"
#import "AppsfireEngageSDK.h"
// helpers
#import "AFBadgeView.h"

// sections
typedef NS_ENUM(NSUInteger, AppsfireSDKSection) {
    AppsfireSDKSectionTypes = 0,
    AppsfireSDKSectionPresentationStyles,
    AppsfireSDKSectionCustomization,
    AppsfireSDKSectionUIIntegration,
    AppsfireSDKSectionNum
};

// content types
typedef NS_ENUM(NSUInteger, AppsfireSDKTypesRow) {
    AppsfireSDKTypesRowNotifications = 0,
    AppsfireSDKTypesRowFeedback,
    AppsfireSDKTypesRowNum
};

// presentation styles
typedef NS_ENUM(NSUInteger, AppsfireSDKPresentationStylesRow) {
    AppsfireSDKPresentationStylesRowDefault = 0,
    AppsfireSDKPresentationStylesRowFullscreen,
    AppsfireSDKPresentationStylesRowNavigation,
    AppsfireSDKPresentationStylesRowModal,
    AppsfireSDKPresentationStylesRowNum
};

// customization
typedef NS_ENUM(NSUInteger, AppsfireSDKCustomizationRow) {
    AppsfireSDKCustomizationRowColor = 0,
    AppsfireSDKCustomizationRowNum
};

// integration examples
typedef NS_ENUM(NSUInteger, AppsfireSDKUIIntegration) {
    AppsfireSDKUIIntegrationRowBadgeView = 0,
    AppsfireSDKUIIntegrationRowNum
};

@interface AppTableViewController ()

@end

@implementation AppTableViewController

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style {

    if ((self = [super initWithStyle:style]) != nil) {

        // title
        self.title = @"Appsfire SDK - Engage";
    
    }
    return self;
    
}

#pragma mark - Table View DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return AppsfireSDKSectionNum;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
            
        // content types
        case AppsfireSDKSectionTypes:
        {
            return AppsfireSDKTypesRowNum;
            break;
        }
            
        // presentation styles
        case AppsfireSDKSectionPresentationStyles:
        {
            return AppsfireSDKPresentationStylesRowNum;
            break;
        }
            
        // customization
        case AppsfireSDKSectionCustomization:
        {
            return AppsfireSDKCustomizationRowNum;
            break;
        }
            
        // integration examples
        case AppsfireSDKSectionUIIntegration:
        {
            return AppsfireSDKUIIntegrationRowNum;
            break;
        }
            
        //
        default:
        {
            return 0;
            break;
        }
            
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
            
        // content types
        case AppsfireSDKSectionTypes:
        {
            return @"Content Types";
            break;
        }
          
        // presentation styles
        case AppsfireSDKSectionPresentationStyles:
        {
            return @"Presentation Styles";
            break;
        }
            
        // customization
        case AppsfireSDKSectionCustomization:
        {
            return @"Customization";
            break;
        }
            
        // integration examples
        case AppsfireSDKSectionUIIntegration:
        {
            return @"Integration Examples";
            break;
        }
        
        //
        default:
        {
            return @"";
            break;
        }
            
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 90.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"Cell";
    
    // try to get a reusable cell
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // or... create it
    if (!cell) {
        
        // alloc init
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        // customize
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.numberOfLines = 0;
        cell.detailTextLabel.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
        
    }
    
    // configure the cell
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    //
    return cell;
    
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;
    
    //
    switch (indexPath.section)
    {
        // content types
        case AppsfireSDKSectionTypes:
        {
            switch (indexPath.row)
            {
                // notifications' wall
                case AppsfireSDKTypesRowNotifications:
                {
                    cell.textLabel.text = @"Notification Wall";
                    cell.detailTextLabel.text = @"Show the list of the notifications that are available.";
                    break;
                }
                    
                // feedback form
                case AppsfireSDKTypesRowFeedback:
                {
                    cell.textLabel.text = @"Feedback Form";
                    cell.detailTextLabel.text = @"Show the Feedback form.";
                    break;
                }
                    
                //
                default:
                {
                    break;
                }
            }
            break;
        }
            
        // presentation styles
        case AppsfireSDKSectionPresentationStyles:
        {
            switch (indexPath.row)
            {
                // overlay default
                case AppsfireSDKPresentationStylesRowDefault:
                {
                    cell.textLabel.text = @"Default";
                    cell.detailTextLabel.text = @"Floating style presentation.";
                    break;
                }
                    
                // overlay fullscreen
                case AppsfireSDKPresentationStylesRowFullscreen:
                {
                    cell.textLabel.text = @"Fullscreen";
                    cell.detailTextLabel.text = @"Full screen presentation style";
                    break;
                }
                    
                // pushed into nav controller
                case AppsfireSDKPresentationStylesRowNavigation:
                {
                    cell.textLabel.text = @"UIViewController (Navigation Controller)";
                    cell.detailTextLabel.text = @"Push/Pop presentation style in a navigation controller.";
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                    
                // presented as a modal
                case AppsfireSDKPresentationStylesRowModal:
                {
                    cell.textLabel.text = @"UIViewController (Modal Presentation)";
                    cell.detailTextLabel.text = @"Modal presentation style.";
                    break;
                }
                 
                //
                default:
                {
                    break;
                }
            }
            break;
        }
            
        // customization
        case AppsfireSDKSectionCustomization:
        {
            switch (indexPath.row)
            {
                // color
                case AppsfireSDKCustomizationRowColor:
                {
                    cell.textLabel.text = @"Color customization";
                    cell.detailTextLabel.text = @"You have the ability to customize the color of the panel.";
                    break;
                }
                    
                //
                default:
                {
                    break;
                }
            }
            break;
        }
            
        // integration examples
        case AppsfireSDKSectionUIIntegration:
        {
            switch (indexPath.row)
            {
                // badge
                case AppsfireSDKUIIntegrationRowBadgeView:
                {
                    UIView *accessoryView;
                    AFBadgeView *badgeView;
                    
                    //
                    cell.textLabel.text = @"Badge View";
                    cell.detailTextLabel.text = @"Get the number of notifications via a circular badge.";
                    
                    // for the demo we are going to add a badge to our table view cell
                    accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
                    accessoryView.userInteractionEnabled = NO;
                    accessoryView.backgroundColor = [UIColor clearColor];
                    //
                    badgeView = [[AFBadgeView alloc] initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
                    [accessoryView addSubview:badgeView];
                    
                    // change the color of the badge
                    //badgeView.backgroundView.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:114.0 / 255.0 blue:226.0 / 255.0 alpha:1.0];
                    
                    // change the "roundness of the badge"
                    //badgeView.backgroundView.layer.cornerRadius = 4.0;
                    
                    //
                    cell.accessoryView = accessoryView;
                    
                    //
                    break;
                }
                    
                default:
                {
                    break;
                }
            }
            break;
        }
            
        //
        default:
        {
            break;
        }
            
    }
    
}

#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // deselect row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // action
    switch (indexPath.section)
    {
        // content types
        case AppsfireSDKSectionTypes:
        {
            switch (indexPath.row)
            {
                // open notifications' wall
                case AppsfireSDKTypesRowNotifications:
                {
                    [AppsfireEngageSDK presentPanelForContent:AFSDKPanelContentDefault withStyle:AFSDKPanelStyleDefault];
                    break;
                }
                    
                // open feedback form
                case AppsfireSDKTypesRowFeedback:
                {
                    [AppsfireEngageSDK presentPanelForContent:AFSDKPanelContentFeedbackOnly withStyle:AFSDKPanelStyleDefault];
                    break;
                }
                
                //
                default:
                {
                    break;
                }
            }
            break;
        }
            
        // presentation styles
        case AppsfireSDKSectionPresentationStyles:
        {
            switch (indexPath.row)
            {
                // display with the default overlay
                case AppsfireSDKPresentationStylesRowDefault:
                {
                    [AppsfireEngageSDK presentPanelForContent:AFSDKPanelContentDefault withStyle:AFSDKPanelStyleDefault];
                    break;
                }
                    
                // display with the fullscreen overlay
                case AppsfireSDKPresentationStylesRowFullscreen:
                {
                    [AppsfireEngageSDK presentPanelForContent:AFSDKPanelContentDefault withStyle:AFSDKPanelStyleFullscreen];
                    break;
                }
                 
                // display inside a navigation controller
                // /!\ you must implement `-panelViewControllerNeedsToBeDismissed:` to correctly dismiss the controller that you display!
                case AppsfireSDKPresentationStylesRowNavigation:
                {
                    NSError *error;
                    UIViewController *panelController;
                    
                    //
                    panelController = [AppsfireEngageSDK getPanelViewControllerWithError:&error];
                    
                    //
                    if (panelController != nil) {
                        [self.navigationController pushViewController:panelController animated:YES];
                    } else {
                        NSLog(@"Error while getting the panel view controller: %@", error.localizedDescription);
                    }
                    
                    //
                    break;
                }
                    
                // display as a modal controller
                // /!\ you must implement `-panelViewControllerNeedsToBeDismissed:` to correctly dismiss the controller that you display!
                case AppsfireSDKPresentationStylesRowModal:
                {
                    NSError *error;
                    UIViewController *panelController;
                    
                    //
                    panelController = [AppsfireEngageSDK getPanelViewControllerWithError:&error];
                    
                    //
                    if (panelController != nil) {
                        [self.navigationController presentModalViewController:panelController animated:YES];
                    } else {
                        NSLog(@"Error while getting the panel view controller : %@", error.localizedDescription);
                    }
                    
                    //
                    break;
                }
                    
                default:
                {
                    break;
                }
            }
            break;
        }
            
        // customization
        case AppsfireSDKSectionCustomization:
        {
            switch (indexPath.row)
            {
                // open notifications' panel with a custom color
                case AppsfireSDKCustomizationRowColor:
                {
                    [AppsfireEngageSDK setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:148.0/255.0 blue:18.0/255.0 alpha:1.0] textColor:[UIColor whiteColor]];
                    [AppsfireEngageSDK presentPanelForContent:AFSDKPanelContentDefault withStyle:AFSDKPanelStyleDefault];
                    break;
                }
                 
                //
                default:
                {
                    break;
                }
            }
            
            break;
        }
            
        // integration examples
        case AppsfireSDKSectionUIIntegration:
        {
            switch (indexPath.row)
            {
                // open notifications' wall
                // /!\ you must implement `-panelViewControllerNeedsToBeDismissed:` to correctly dismiss the controller that you display!
                case AppsfireSDKUIIntegrationRowBadgeView:
                {
                    NSError *error;
                    UIViewController *panelController;
                    
                    //
                    panelController = [AppsfireEngageSDK getPanelViewControllerWithError:&error];
                    
                    //
                    if (panelController != nil) {
                        [self.navigationController pushViewController:panelController animated:YES];
                    } else {
                        NSLog(@"Error while getting the panel view controller : %@", error.localizedDescription);
                    }
                    
                    //
                    break;
                }
                    
                default:
                {
                    break;
                }
            }
            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
}

@end
