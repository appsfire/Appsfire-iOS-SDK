//
//  AppNavigationController.m
//  AppsfireSDK-Example-Interstitial
//
//  Created by Vincent on 20/06/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AppNavigationController.h"

@interface AppNavigationController ()

@end

@implementation AppNavigationController

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return YES;
    
}

- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
    
}

@end
