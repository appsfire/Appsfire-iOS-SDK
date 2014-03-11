//
//  NotificationBarExampleController.m
//  Appsfire SDK Demo
//
//  Created by Ali Karagoz on 20/09/13.
//  Copyright (c) 2013 Appsfire. All rights reserved.
//

#import "NotificationBarExampleController.h"
#import "AFNotificationBarView.h"
#import "AppsfireSDK.h"

@interface NotificationBarExampleController ()

@property (nonatomic) AFNotificationBarView *notificationBar;

@end

@implementation NotificationBarExampleController

- (void)loadView {
    [super loadView];
    
    // The background color of the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // On iOS 7, by default the view goes under the navigation bar and this is not what we want.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Adding a button in order to manually show / hide the notification bar.
    UIButton *backgroundButton = [[UIButton alloc] initWithFrame:self.view.bounds];
    backgroundButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    [backgroundButton addTarget:self action:@selector(didTouchButton:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundButton setTitle:@"Tap here to show / hide" forState:UIControlStateNormal];
    [backgroundButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:backgroundButton];
    
    // Creating our notification bar.
    self.notificationBar = [[AFNotificationBarView alloc] initWithContainerView:self.view displayMode:AFNotificationBarViewStyleBottom];
    [self.notificationBar addTarget:self action:@selector(didTouchNotificationBar:) forControlEvents:UIControlEventTouchUpInside];
    
    // Forces the notification bar to be shown at start.
    //[self.notificationBar showAnimated:NO];
    
    // Changes the "roundness" of the count label.
    //self.notificationBar.countLabel.layer.cornerRadius = 4.0;
    
    // Changes the color of the notification bar.
    //self.notificationBar.backgroundColor = [UIColor redColor];
    //self.notificationBar.countLabel.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:114.0 / 255.0 blue:226.0 / 255.0 alpha:1.0];
    
    // Changes the height of the notification bar.
    //self.notificationBar.barHeight = 60.0;
    
    // Changes the display mode.
    //self.notificationBar.displayMode = AFNotificationBarViewStyleTop;
    
    // Shows it even if there is no notifications.
    //self.notificationBar.shouldHideWhenEmptyCount = NO;
}

- (void)didTouchNotificationBar:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [AppsfireSDK presentPanelForContent:AFSDKPanelContentDefault withStyle:AFSDKPanelStyleFullscreen];
}

- (void)didTouchButton:(id)sender {
    if(self.notificationBar.isHidden) {
        [self.notificationBar show];
    } else {
        [self.notificationBar hide];
    }
}

@end
