//
//  AFAppDelegate.h
//  Appsfire SDK Demo
//
//  Created by Vincent on 19/06/14.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppNavigationController;
@class AppTableViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) AppNavigationController *navigationController;
@property (nonatomic, strong) AppTableViewController *tableViewController;

@end
