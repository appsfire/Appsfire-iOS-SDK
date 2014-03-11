
// Copyright 2010-2013 Appsfire SAS. All rights reserved.
//
// Redistribution and use in source and binary forms, without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2. Redistributions in binaryform must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided withthe distribution.
//
// THIS SOFTWARE IS PROVIDED BY APPSFIRE SAS ``AS IS'' AND ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
// EVENT SHALL APPSFIRE SAS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
// INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
// BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
// DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
// ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "AFBadgeView.h"
#import "AppsfireSDK.h"

// Duration of the transition animations
static CFTimeInterval const kAFBadgeViewAnimationDuration = 0.2;

// Scale factor that allow us nicely fit the label inside the badge view
static CGFloat const kAFBadgeViewFontRatio = 2.2;

@interface AFBadgeView ()

// Common initializer used by the various default initializer
- (void)initializer;

@end

@implementation AFBadgeView

#pragma mark - Init & Dealloc

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    
    [self initializer];
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self == nil) {
        return nil;
    }
    
    [self initializer];
    
    return self;
}

- (void)dealloc {
    // Unsubscribing from all notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initializer {
    // We don't want the view to be opaque
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    // Setting the badge count to 0 at start
    _count = 0;
    
    // By default the badge is not visible
    self.alpha = 0;
    
    // By default the change of the badge count is animated
    _isAnimated = YES;
    
    // By default we hide the badge if there are no pending notifications
    _shouldHideWhenEmptyCount = NO;
    
    // BACKGROUND VIEW
    // The badge view can only be square that is why we set the height == width
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetWidth(self.bounds))];
    _backgroundView.userInteractionEnabled = NO;
    _backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    
    // The default background color is red
    _backgroundView.backgroundColor = [UIColor redColor];
    
    // By default we try to have a round badge
    _backgroundView.layer.cornerRadius = floorf(CGRectGetWidth(self.bounds) / 2.0);
    
    [self addSubview:_backgroundView];
    
    // TEXT LABEL
    _textLabel = [[UILabel alloc] init];
    _textLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _textLabel.textAlignment = UITextAlignmentCenter;
    _textLabel.text = @"0";

    // By defaul the text color is white
    _textLabel.textColor = [UIColor whiteColor];
    
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.adjustsFontSizeToFitWidth = YES;
    
    // Automagically set the font size
    CGFloat fontSize = floorf(CGRectGetWidth(self.bounds) / kAFBadgeViewFontRatio);
    _textLabel.font = [UIFont boldSystemFontOfSize:fontSize];
    _textLabel.minimumFontSize = fontSize - 4.0;
    
    [self addSubview:_textLabel];
    
    // Notifications / Callbacks to update the badge
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState) name:kAFSDKIsInitialized object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeCount) name:kAFSDKNotificationsNumberChanged object:nil];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Text Label
    CGRect textLabelRect = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    textLabelRect = CGRectIntegral(textLabelRect);
    self.textLabel.frame = textLabelRect;
}

#pragma mark - Setter

- (void)setCount:(NSUInteger)count {
    _count = count;
    
    self.textLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
    
    [self updateState];
    
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    if (!self.enabled) {
        self.alpha = 0.0;
    }
    
    else {
        [self updateState];
    }
}

#pragma mark -

- (void)updateState {
    if (!self.enabled) {
        return;
    }
    
    // Are we animating the change?
    CFTimeInterval animationDuration = _isAnimated ? kAFBadgeViewAnimationDuration : 0.0;
    
    [UIView animateWithDuration:animationDuration animations:^(void) {
        if ([AppsfireSDK isInitialized] && self.count != 0) {
            self.alpha = 1.0;
        }
        
        else if (!_shouldHideWhenEmptyCount) {
            self.alpha = 0.5;
        }
        
        else {
            self.alpha = 0.0;
        }
    }];
}

- (void)updateBadgeCount {
    self.count = [AppsfireSDK numberOfPendingNotifications];
}

@end
