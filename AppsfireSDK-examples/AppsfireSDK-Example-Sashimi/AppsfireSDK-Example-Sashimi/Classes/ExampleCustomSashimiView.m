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

@interface ExampleCustomSashimiView() {
    
    UILabel *_labelTitle;
    UIImageView *_imageIcon;
    UILabel *_labelDownload;
    
}
- (void)_downloadIcon;

@end

@implementation ExampleCustomSashimiView

- (void)sashimiIsReadyForInitialization {
    
    //
    [self setBackgroundColor:[UIColor whiteColor ]];
    
    // label title
    _labelTitle = [[UILabel alloc] init];
    [_labelTitle setTextColor:[UIColor blackColor]];
    [_labelTitle setBackgroundColor:[UIColor clearColor]];
    [_labelTitle setText:self.title];
    [_labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [_labelTitle setNumberOfLines:2];
    [self addSubview:_labelTitle];
    
    // label download
    _labelDownload = [[UILabel alloc ] init];
    [_labelDownload setText:[self.callToActionTitle uppercaseString]];
    [_labelDownload setBackgroundColor:[UIColor clearColor ]];
    [_labelDownload setTextColor:[UIColor darkGrayColor]];
    [_labelDownload setTextAlignment:NSTextAlignmentCenter];
    [_labelDownload setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0]];
    [_labelDownload.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    [_labelDownload.layer setBorderWidth:1.0];
    [_labelDownload.layer setCornerRadius:4.0];
    [_labelDownload sizeToFit];
    [_labelDownload setFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(_labelDownload.frame) + 12.0, CGRectGetHeight(_labelDownload.frame) + 4.0)];
    [self addSubview:_labelDownload];
    
    // image icon
    _imageIcon = [[UIImageView alloc ] initWithFrame:CGRectMake(0.0, 0.0, 70.0, 70.0)];
    [_imageIcon.layer setMasksToBounds:YES];
    [_imageIcon.layer setCornerRadius:CGRectGetWidth(_imageIcon.frame)/5.4];
    [self addSubview:_imageIcon];
    [self _downloadIcon];
    
    // appsfire badge
    [self.viewAppsfireBadge setStyleMode:AFAdSDKAdBadgeStyleModeDark];
    [self addSubview:self.viewAppsfireBadge];
    
}

- (void)dealloc {
    
    _labelTitle = nil;
    _imageIcon = nil;
    _labelDownload = nil;
    
}

- (void)layoutSubviews {
    
    CGRect imageIconFrame;
    CGRect labelTitleFrame;
    CGRect labelDownloadFrame;
    CGRect appsfireBadgeFrame;
    CGFloat contentTotalHeight, componentsSpacing;
    
    //
    componentsSpacing = 6.0;
    labelTitleFrame = CGRectZero;
    labelDownloadFrame = _labelDownload.frame;
    
    // define icon frame
    imageIconFrame = CGRectMake(15.0, 0.0, 70.0, 70.0);
    imageIconFrame.origin.y = floor(CGRectGetHeight(self.frame) / 2.0 - CGRectGetHeight(imageIconFrame) / 2.0);
    
    // define appsfire badge frame
    appsfireBadgeFrame = CGRectMake(CGRectGetWidth(self.frame) - CGRectGetWidth(self.viewAppsfireBadge.frame) - 5.0, 5.0, CGRectGetWidth(self.viewAppsfireBadge.frame), CGRectGetHeight(self.viewAppsfireBadge.frame));
    
    // calculate height of title
    labelDownloadFrame.origin.x = labelTitleFrame.origin.x = CGRectGetMaxX(imageIconFrame) + 10.0;
    labelTitleFrame.size.width = CGRectGetWidth(self.frame) - labelTitleFrame.origin.x - 8.0 - 15.0;
    labelTitleFrame.size.height = [self stringSizeOfText:_labelTitle.text withFont:_labelTitle.font constrainedToSize:CGSizeMake(labelTitleFrame.size.width, _labelTitle.font.lineHeight * 2) lineBreakMode:NSLineBreakByWordWrapping].height;
    
    // calculate total height (title + download)
    contentTotalHeight = CGRectGetHeight(labelTitleFrame) + componentsSpacing + CGRectGetHeight(labelDownloadFrame);
    
    // adjust the title/download y
    labelTitleFrame.origin.y = floor(CGRectGetHeight(self.frame) / 2.0 - contentTotalHeight / 2.0);
    labelDownloadFrame.origin.y = CGRectGetMaxY(labelTitleFrame) + componentsSpacing;
    
    // set frames
    [_imageIcon setFrame:imageIconFrame];
    [_labelTitle setFrame:labelTitleFrame];
    [_labelDownload setFrame:labelDownloadFrame];
    [self.viewAppsfireBadge setFrame:appsfireBadgeFrame];
    
}

#pragma mark - Icon download

// note: this piece of code if just for the sake of the demo
// we recommend you to use a better system to download image asynchronously
// so you can put them into a queue, cancel them, etc
- (void)_downloadIcon {
    
    // there should always be an icon
    // but check in case!
    if (self.iconURL == nil)
        return;

    // dispatch content download into an async block
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSData *data;
        UIImage *image;
        
        //
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.iconURL]];
        image = [UIImage imageWithData:data];
        
        // dispatch image display on main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_imageIcon setImage:image];
            
        });
        
    });
    
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
