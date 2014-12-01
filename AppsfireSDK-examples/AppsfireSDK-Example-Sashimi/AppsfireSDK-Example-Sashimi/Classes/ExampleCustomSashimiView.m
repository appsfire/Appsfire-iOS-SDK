//
//  ExampleCustomSashimiView.m
//  AppsfireSDK
//
//  Created by Vincent on 14/01/2014.
//  Copyright (c) 2014 Appsfire. All rights reserved.
//

#import "ExampleCustomSashimiView.h"
//
#import <QuartzCore/QuartzCore.h>

@interface ExampleCustomSashimiView()

// title label
@property (nonatomic, strong) UILabel *titleLabel;

// icon image
@property (nonatomic, strong) UIImageView *iconImage;

// call-to-action label
@property (nonatomic, strong) UILabel *ctaLabel;

@end

@implementation ExampleCustomSashimiView

- (void)sashimiIsReadyForInitialization {
    
    //
    [self setBackgroundColor:[UIColor whiteColor ]];
    
    // title label
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setText:self.title];
    [_titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [_titleLabel setNumberOfLines:2];
    [self addSubview:_titleLabel];
    
    // call-to-action label
    _ctaLabel = [[UILabel alloc ] init];
    [_ctaLabel setText:[self.callToActionTitle uppercaseString]];
    [_ctaLabel setBackgroundColor:[UIColor clearColor ]];
    [_ctaLabel setTextColor:[UIColor darkGrayColor]];
    [_ctaLabel setTextAlignment:NSTextAlignmentCenter];
    [_ctaLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0]];
    [_ctaLabel.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [_ctaLabel.layer setBorderWidth:1.0];
    [_ctaLabel.layer setCornerRadius:4.0];
    [_ctaLabel sizeToFit];
    [_ctaLabel setFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_ctaLabel.frame) + 12.0, CGRectGetHeight(_ctaLabel.frame) + 4.0)];
    [self addSubview:_ctaLabel];
    
    // icon image
    _iconImage = [[UIImageView alloc ] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
    [_iconImage.layer setMasksToBounds:YES];
    [_iconImage.layer setCornerRadius:CGRectGetWidth(_iconImage.frame)/5.4];
    [self addSubview:_iconImage];
    
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
            [strongSelf.iconImage setImage:image];
            
        }];
        
    }
    
    // appsfire badge
    [self.viewAppsfireBadge setStyleMode:AFAdSDKAdBadgeStyleModeDark];
    [self addSubview:self.viewAppsfireBadge];
    
}

- (void)dealloc {
    
    _titleLabel = nil;
    _ctaLabel = nil;
    _iconImage = nil;
    
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
    ctaLabelFrame = _ctaLabel.frame;
    
    // define icon frame
    iconImageFrame = CGRectMake(15.0, 0.0, 70.0, 70.0);
    iconImageFrame.origin.y = floor(CGRectGetHeight(self.frame) / 2.0 - CGRectGetHeight(iconImageFrame) / 2.0);
    
    // define appsfire badge frame
    appsfireBadgeFrame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.viewAppsfireBadge.frame) - 5.0, 5.0, CGRectGetWidth(self.viewAppsfireBadge.frame), CGRectGetHeight(self.viewAppsfireBadge.frame));
    
    // calculate height of title
    ctaLabelFrame.origin.x = titleLabelFrame.origin.x = CGRectGetMaxX(iconImageFrame) + 10.0;
    titleLabelFrame.size.width = CGRectGetWidth(self.frame) - titleLabelFrame.origin.x - 8.0 - 15.0;
    titleLabelFrame.size.height = [self stringSizeOfText:_titleLabel.text withFont:_titleLabel.font constrainedToSize:CGSizeMake(titleLabelFrame.size.width, _titleLabel.font.lineHeight * 2) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    // calculate total height (title + download)
    contentTotalHeight = CGRectGetHeight(titleLabelFrame) + componentsSpacing + CGRectGetHeight(ctaLabelFrame);
    
    // adjust the title/download y
    titleLabelFrame.origin.y = floor(CGRectGetHeight(self.frame) / 2.0 - contentTotalHeight / 2.0);
    ctaLabelFrame.origin.y = CGRectGetMaxY(titleLabelFrame) + componentsSpacing;
    
    // set frames
    [_iconImage setFrame:iconImageFrame];
    [_titleLabel setFrame:titleLabelFrame];
    [_ctaLabel setFrame:ctaLabelFrame];
    [self.viewAppsfireBadge setFrame:appsfireBadgeFrame];
    
}

#pragma mark - String Size Helper

- (CGSize)stringSizeOfText:(NSString *)text withFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode {
    
    CGRect boundingRect;
    NSDictionary *attributes;
    NSMutableParagraphStyle *paragrapheStyle;
    
    // sanity check on the font
    if (font == nil || ![font isKindOfClass:UIFont.class])
        font = [UIFont systemFontOfSize:12.0];
    
    // iOS7+ method
    if ([ text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:) ]) {
        
        // paragraphe style
        paragrapheStyle = [[NSMutableParagraphStyle alloc] init];
        paragrapheStyle.lineBreakMode = lineBreakMode;
        
        // wrap into dictionary
        attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragrapheStyle };
        
        // getting the size of the string
        boundingRect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        // boundingRectWithSize:options:attributes:context won't return a rounded integer so we need to do it ourselves.
        boundingRect = CGRectIntegral(boundingRect);
        
        return boundingRect.size;
        
    }
    
    // legacy method
    else {
        
        return [text sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
        
    }
    
}

@end
