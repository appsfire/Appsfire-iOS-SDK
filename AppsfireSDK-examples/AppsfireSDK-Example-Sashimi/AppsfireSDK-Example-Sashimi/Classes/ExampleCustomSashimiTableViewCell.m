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

@interface ExampleCustomSashimiTableViewCell() {
    
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
        _viewSashimi = [ AppsfireAdSDK sashimiViewForSubclass:[ExampleCustomSashimiView class] withController:[UIApplication sharedApplication].keyWindow.rootViewController andError:&error ];
        if ([ _viewSashimi isKindOfClass:[ UIView class ] ] && error == nil) {
            
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

@end
