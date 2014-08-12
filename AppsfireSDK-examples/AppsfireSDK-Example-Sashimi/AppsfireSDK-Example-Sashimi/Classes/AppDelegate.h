//
//  AppDelegate.h
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 04/02/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppNavigationController;
@class AppTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AppNavigationController *navigationController;
@property (strong, nonatomic) AppTableViewController *tableViewController;

@end
