//
//  ExampleCustomSashimiWithXIBTableViewCell.m
//  AppsfireSDK-Example-Sashimi
//
//  Created by Vincent on 18/06/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleCustomSashimiWithXIBTableViewCell.h"
#import "ExampleCustomSashimiWithXIBView.h"
#import "AppsfireAdSDK.h"

@interface ExampleCustomSashimiWithXIBTableViewCell() <AFAdSDKSashimiViewDelegate> {
    
    AFAdSDKSashimiView *_viewSashimi;
    
}

@end

@implementation ExampleCustomSashimiWithXIBTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSError *error;
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) != nil) {
        
        //
        [ self setSelectionStyle:UITableViewCellSelectionStyleNone ];
        if ([ self respondsToSelector:@selector(setSeparatorInset:) ])
            [ self setSeparatorInset:UIEdgeInsetsZero ];
        
        //
        _viewSashimi = [ AppsfireAdSDK sashimiViewForNibName:@"ExampleCustomSashimiView" andError:&error ];
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
