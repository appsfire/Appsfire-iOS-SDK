//
//  ExampleCustomNativeAdView.m
//  AppsfireSDK-Example-Native
//
//  Created by Vincent on 09/04/2015.
//  Copyright (c) 2015 appsfire. All rights reserved.
//

#import "ExampleCustomNativeAdView.h"
// objects
#import "AFNativeAd.h"
// views
#import "AFAdSDKAdBadgeView.h"

@import UIKit.UILabel;
@import UIKit.UIImageView;
@import UIKit.NSStringDrawing;
@import UIKit.NSAttributedString;
@import QuartzCore.QuartzCore;

@interface ExampleCustomNativeAdView ()

// title label
@property (nonatomic, strong) UILabel *titleLabel;

// icon image
@property (nonatomic, strong) UIImageView *iconImage;

// call-to-action label
@property (nonatomic, strong) UILabel *ctaLabel;

// badge view
@property (nonatomic, strong) AFAdSDKAdBadgeView *badgeView;

@end

@implementation ExampleCustomNativeAdView

- (id)init {
    
    //
    if ((self = [super init]) == nil)
        return nil;
    
    //
    self.backgroundColor = [UIColor whiteColor];
    
    // title label
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [self.titleLabel setNumberOfLines:2];
    [self addSubview:self.titleLabel];
    
    // call-to-action label
    self.ctaLabel = [[UILabel alloc ] init];
    [self.ctaLabel setBackgroundColor:[UIColor clearColor ]];
    [self.ctaLabel setTextColor:[UIColor darkGrayColor]];
    [self.ctaLabel setTextAlignment:NSTextAlignmentCenter];
    [self.ctaLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0]];
    [self.ctaLabel.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [self.ctaLabel.layer setBorderWidth:1.0];
    [self.ctaLabel.layer setCornerRadius:4.0];
    [self addSubview:self.ctaLabel];
    
    // icon image
    self.iconImage = [[UIImageView alloc ] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
    [self.iconImage.layer setMasksToBounds:YES];
    [self.iconImage.layer setCornerRadius:CGRectGetWidth(self.iconImage.frame)/5.4];
    [self addSubview:self.iconImage];
    
    // appsfire badge view
    self.badgeView = [[AFAdSDKAdBadgeView alloc] init];
    self.badgeView.styleMode = AFAdSDKAdBadgeStyleModeDark;
    [self addSubview:self.badgeView];
    
    //
    return self;
    
}

- (void)dealloc {
    
    self.titleLabel = nil;
    self.ctaLabel = nil;
    self.iconImage = nil;
    self.badgeView = nil;
    
}

- (void)layoutSubviews {
    
    CGRect iconImageFrame;
    CGRect titleLabelFrame;
    CGRect ctaLabelFrame;
    CGRect appsfireBadgeFrame;
    CGFloat contentTotalHeight, componentsSpacing;
    
    //
    componentsSpacing = 6.0;
    titleLabelFrame = CGRectZero;
    ctaLabelFrame = self.ctaLabel.frame;
    
    // define icon frame
    iconImageFrame = CGRectMake(15.0, 0.0, 70.0, 70.0);
    iconImageFrame.origin.y = floor(CGRectGetHeight(self.frame) / 2.0 - CGRectGetHeight(iconImageFrame) / 2.0);
    
    // define appsfire badge frame
    appsfireBadgeFrame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.badgeView.frame) - 5.0, 5.0, CGRectGetWidth(self.badgeView.frame), CGRectGetHeight(self.badgeView.frame));
    
    // calculate height of title
    ctaLabelFrame.origin.x = titleLabelFrame.origin.x = CGRectGetMaxX(iconImageFrame) + 10.0;
    titleLabelFrame.size.width = CGRectGetWidth(self.frame) - titleLabelFrame.origin.x - 8.0 - 15.0;
    titleLabelFrame.size.height = [self stringSizeOfText:self.titleLabel.text withFont:self.titleLabel.font constrainedToSize:CGSizeMake(titleLabelFrame.size.width, self.titleLabel.font.lineHeight * 2) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    // calculate total height (title + download)
    contentTotalHeight = CGRectGetHeight(titleLabelFrame) + componentsSpacing + CGRectGetHeight(ctaLabelFrame);
    
    // adjust the title/download y
    titleLabelFrame.origin.y = floor(CGRectGetHeight(self.frame) / 2.0 - contentTotalHeight / 2.0);
    ctaLabelFrame.origin.y = CGRectGetMaxY(titleLabelFrame) + componentsSpacing;
    
    // set frames
    [self.iconImage setFrame:iconImageFrame];
    [self.titleLabel setFrame:titleLabelFrame];
    [self.ctaLabel setFrame:ctaLabelFrame];
    [self.badgeView setFrame:appsfireBadgeFrame];
    
}

#pragma mark - Set Native Ad

- (void)setNativeAd:(AFNativeAd *)nativeAd {
    
    // check object class
    if (![nativeAd isKindOfClass:[AFNativeAd class]])
        return;
    
    // disconnect previous object
    if (_nativeAd != nil)
        [_nativeAd disconnectViewForDisplay];
    
    // connect with new object
    _nativeAd = nativeAd;
    [_nativeAd connectViewForDisplay:self withClickableViews:nil];
    
    // title
    self.titleLabel.text = self.nativeAd.title;
    
    // call to action
    self.ctaLabel.text = [self.nativeAd.callToAction uppercaseString];
    [self.ctaLabel sizeToFit];
    [self.ctaLabel setFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.ctaLabel.frame) + 12.0, CGRectGetHeight(self.ctaLabel.frame) + 4.0)];

    // download the icon thanks to the helper method
    // there should always be an icon, but in case, check before downloading it!
    if (self.nativeAd.iconURL != nil) {
        
        // as there is a block, make sure to use a weak property!
        __weak typeof(self) weakSelf = self;
        
        //
        [self.nativeAd downloadAsset:self.nativeAd.iconURL completion:^(UIImage *image) {
            
            // transform our weak self to a strong one!
            // only if self wasn't deallocated in the meantime
            if (weakSelf == nil)
                return;
            typeof(weakSelf) __strong strongSelf = weakSelf;
            
            //
            [strongSelf.iconImage setImage:image];
            
        }];
        
    }
    
    //
    [self setNeedsLayout];

}

#pragma mark - String Size Helper

- (CGSize)stringSizeOfText:(NSString *)text withFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    CGSize boundingSize;
    NSDictionary *attributes;
    NSMutableParagraphStyle *paragrapheStyle;
    
    //
    if (![text isKindOfClass:[NSString class]])
        return CGSizeZero;
    
    // sanity check on the font
    if (![font isKindOfClass:[UIFont class]])
        font = [UIFont systemFontOfSize:12.0];
    
    // on iOS6- we use the legacy method
    if ([ text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:) ]) {
        
        return [text sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
        
    }
    
    // on iOS7+ we use the new method
    else {
        
        // paraphe style
        paragrapheStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapheStyle.lineBreakMode = lineBreakMode;
        
        // attributes
        attributes = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragrapheStyle};
        
        // get the size of the string
        boundingSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        
        // but the previous method won't return a rounded integer
        // so we need to do it ourselves
        boundingSize.width = fmin(ceil(boundingSize.width), size.width);
        boundingSize.height = fmin(ceil(boundingSize.height), size.height);
        
        return boundingSize;
        
    }
    
}

@end
