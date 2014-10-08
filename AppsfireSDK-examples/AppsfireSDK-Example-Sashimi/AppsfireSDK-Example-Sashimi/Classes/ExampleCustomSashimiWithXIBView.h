//
//  ExampleCustomSashimiWithXIBView.h
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 18/06/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "AFAdSDKSashimiView.h"

@interface ExampleCustomSashimiWithXIBView : AFAdSDKSashimiView

@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) IBOutlet UIButton *ctaButton;

@property (nonatomic, strong) IBOutlet AFAdSDKAdBadgeView *badgeView;

@end
