//
//  ExampleSashimiExtendedTableViewCell.m
//  AppsfireSDK
//
//  Created by Vincent on 21/01/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleExtendedSashimiTableViewCell.h"
#import "AFAdSDKSashimiExtendedView.h"
#import "AppsfireAdSDK.h"

@interface ExampleExtendedSashimiTableViewCell() {
    
    AFAdSDKSashimiExtendedView *_viewSashimi;
    
}

@end

@implementation ExampleExtendedSashimiTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    NSError *error;
    
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) != nil) {

        //
        [ self setSelectionStyle:UITableViewCellSelectionStyleNone ];
        if ([ self respondsToSelector:@selector(setSeparatorInset:) ])
            [ self setSeparatorInset:UIEdgeInsetsZero ];
        
        // create view
        _viewSashimi = (AFAdSDKSashimiExtendedView *)[ AppsfireAdSDK sashimiViewForFormat:AFAdSDKSashimiFormatExtended withController:[UIApplication sharedApplication].keyWindow.rootViewController andError:&error ];
        
        // customize a bit
        [_viewSashimi.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
        [_viewSashimi.categoryLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11.0]];
        [_viewSashimi.taglineLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:13.0]];
        
        //
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
