//
//  ExampleCustomSashimiTableViewCell.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 05/02/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleCustomSashimiTableViewCell.h"
#import "ExampleCustomSashimiView.h"
#import "AppsfireAdSDK.h"

@interface ExampleCustomSashimiTableViewCell() <AFAdSDKSashimiViewDelegate> {
    
    AFAdSDKSashimiView *_viewSashimi;
    
}

@end

@implementation ExampleCustomSashimiTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSError *error;
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) != nil) {
        
        //
        [ self setSelectionStyle:UITableViewCellSelectionStyleNone ];
        if ([ self respondsToSelector:@selector(setSeparatorInset:) ])
            [ self setSeparatorInset:UIEdgeInsetsZero ];
        
        //
        _viewSashimi = [ AppsfireAdSDK sashimiViewForSubclass:[ExampleCustomSashimiView class] forZone:@"/3180317/square/af" andError:&error ];
        if ([ _viewSashimi isKindOfClass:[ UIView class ] ] && error == nil) {
        
            _viewSashimi.delegate = self;
            [_viewSashimi setFrame:self.bounds];
            [self.contentView addSubview:_viewSashimi];
            
        }
        
    }
    return self;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [_viewSashimi setFrame:self.bounds];
    
}

- (UIViewController *)viewControllerForSashimiView:(AFAdSDKSashimiView *)sashimiView {
    
    return [UIApplication sharedApplication].keyWindow.rootViewController;
    
}

@end
