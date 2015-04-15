//
//  ExampleCustomSashimiWithXIBView.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 18/06/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleCustomSashimiWithXIBView.h"
//
#import "AFAdSDKAdBadgeView.h"

@implementation ExampleCustomSashimiWithXIBView

- (void)awakeFromNib {
    
    // icon: make it round
    [_iconImageView.layer setMasksToBounds:YES];
    [_iconImageView.layer setCornerRadius:CGRectGetWidth(_iconImageView.bounds)/5.4];
    
    // badge: select mode
    [_badgeView setBackgroundColor:[UIColor whiteColor]];
    [_badgeView setStyleMode:AFAdSDKAdBadgeStyleModeDark];
    
    // cta: add border + content padding
    [_ctaButton.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [_ctaButton.layer setBorderWidth:1.0];
    [_ctaButton.layer setCornerRadius:4.0];
    [_ctaButton setContentEdgeInsets:UIEdgeInsetsMake(2.0, 6.0, 2.0, 6.0)];
    
}

- (void)sashimiIsReadyForInitialization {
    
    // title
    [_titleLabel setText:self.title];
    
    // download the icon thanks to the helper method
    // there should always be an icon, but in case, check before downloading it!
    if (self.iconURL != nil) {
        
        // as there is a block, make sure to use a weak property!
        __weak typeof(self) weakSelf = self;
        
        //
        [self downloadAsset:AFAdSDKAppAssetTypeIcon completion:^(UIImage *image) {
            
            // transform our weak self to a strong one!
            // only if self wasn't deallocated in the meantime
            if (weakSelf == nil)
                return;
            typeof(weakSelf) __strong strongSelf = weakSelf;
            
            //
            [strongSelf.iconImageView setImage:image];
            
        }];
        
    }
    
    // cta
    // set title and adjust size
    [_ctaButton setTitle:[self.callToActionTitle uppercaseString] forState:UIControlStateNormal];
    [_ctaButton sizeToFit];
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    // avoid the button to take the event
    return self;
    
}

@end
