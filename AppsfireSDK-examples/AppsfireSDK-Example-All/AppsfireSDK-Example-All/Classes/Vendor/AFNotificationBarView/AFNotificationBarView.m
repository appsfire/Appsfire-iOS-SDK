
// Copyright 2010-2013 Appsfire SAS. All rights reserved.
//
// Redistribution and use in source and binary forms, without
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation
// and/or other materials provided with the distribution.
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

#import "AFNotificationBarView.h"
#import "AppsfireSDK.h"

// Default duration of the show / hide duration
const CFTimeInterval kAFNotificationBarViewAnimationDuration = 0.2;

// Default height
const CGFloat kAFNotificationBarViewHeight = 40.0;

// Default count label height
const CGFloat kAFNotificationBarCountLabelHeight = 20.0;

// Default strings
static NSString * const kAFNotificationBarNoNotifications = @"You have no new notifications";
static NSString * const kAFNotificationBarNewNotifications = @"You have new notifications";

@interface AFNotificationBarView ()

@property (nonatomic, copy) NSString *noNotificationsDefaultText;
@property (nonatomic, copy) NSString *freshNotificationsDefaultText;
@property (nonatomic, assign) BOOL localeHasBeenSet;

// Updates the frame of the view
- (void)updateFrame;

// Updates everything and hides/shows the notification bar
- (void)updateState;

// Updated the count label
- (void)updateCount;

// Updates the title label
- (void)updateTitleLabel:(id)notification;

// Saves the localized or default language strings to cache for future use
- (void)saveLocalizedStringsWithDictionary:(NSDictionary *)strings;

// Loads localized string from cache
- (void)loadLocalizedStrings;

// Adds necessary observers
- (void)addObservers;

// Removes any observers
- (void)removeObservers;

@end

@implementation AFNotificationBarView

#pragma mark - Init & Dealloc

- (id)initWithContainerView:(UIView *)containerView displayMode:(AFNotificationBarViewStyle)displayMode isEnabled:(BOOL)isEnabled {
    self = [super initWithFrame:CGRectZero];
    if (self == nil) {
        return nil;
    }
    
    self.backgroundColor = [UIColor colorWithRed:0.0 / 255.0 green:114.0 / 255.0 blue:226.0 / 255.0 alpha:1.0];
    self.containerView = containerView;
    
    // By default the default mode is bottom
    _displayMode = displayMode;
    
    // By default the notification bar is enabled
    _isEnabled = isEnabled;
    
    // By default the notification bar is not hidden when count in 0
    _shouldHideWhenEmptyCount = YES;
    
    // Default duration is `kAFNotificationBarViewAnimationDuration`
    _showHideAnimationDuration = kAFNotificationBarViewAnimationDuration;
    
    // At launch it's hidden
    _isHidden = YES;
    
    // Default Insets
    _edgeInsets = UIEdgeInsetsMake(5.0, 10.0, 5.0, 10.0);
    
    // Default bar height
    _barHeight = kAFNotificationBarViewHeight;
    
    // Default text in the bar
    _noNotificationsDefaultText = kAFNotificationBarNoNotifications;
    _freshNotificationsDefaultText = kAFNotificationBarNewNotifications;
    
    _localeHasBeenSet = NO;
    
    // Title Label
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = UITextAlignmentLeft;
    
    // By default the text color is white
    _titleLabel.textColor = [UIColor whiteColor];
    
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:14.0];
    _titleLabel.minimumFontSize = 9.0;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLabel];
    
    
    // Count Label
    _countLabel = [[UILabel alloc] init];
    _countLabel.textAlignment = UITextAlignmentCenter;
    
    // By default the text color is white
    _countLabel.textColor = [UIColor whiteColor];
    
    _countLabel.backgroundColor = [UIColor redColor];
    _countLabel.font = [UIFont systemFontOfSize:14.0];
    _countLabel.minimumFontSize = 10.0;
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    _countLabel.layer.cornerRadius = 3.0;
    _countLabel.layer.masksToBounds = YES;
    _countLabel.text = @"0";
    [self addSubview:_countLabel];
    
    // Subscribing to notifications
    [self addObservers];
    
    // Updating the frame
    [self updateFrame];
    
    [self loadLocalizedStrings];
    [self updateState];
    [self updateTitleLabel:nil];
    
    return self;
}

- (id)initWithContainerView:(UIView *)containerView displayMode:(AFNotificationBarViewStyle)displayMode {
    return [self initWithContainerView:containerView displayMode:displayMode isEnabled:YES];
}

- (id)initWithContainerView:(UIView *)containerView {
    return [self initWithContainerView:containerView displayMode:AFNotificationBarViewStyleBottom isEnabled:YES];
}

- (void)dealloc {
    [self removeObservers];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // COUNT LABEL
    [self.countLabel sizeToFit];
    
    CGFloat countLabelWidth = CGRectGetWidth(self.countLabel.bounds) + 5.0;
    
    if (countLabelWidth < kAFNotificationBarCountLabelHeight) {
        countLabelWidth = kAFNotificationBarCountLabelHeight;
    }
    
    CGRect countLabelRect = CGRectMake(CGRectGetWidth(self.bounds) - countLabelWidth - self.edgeInsets.right,
                                       CGRectGetHeight(self.bounds) / 2.0 - kAFNotificationBarCountLabelHeight / 2.0,
                                       countLabelWidth,
                                       kAFNotificationBarCountLabelHeight);
    
    countLabelRect = CGRectIntegral(countLabelRect);
    self.countLabel.frame = countLabelRect;
    
    // TITLE LABEL
    CGFloat titleLabelWidth = CGRectGetMinX(countLabelRect) - self.edgeInsets.left;
    CGRect titleLabelRect = CGRectMake(self.edgeInsets.left, 0.0, titleLabelWidth, CGRectGetHeight(self.bounds));
    titleLabelRect = CGRectIntegral(titleLabelRect);
    self.titleLabel.frame = titleLabelRect;
}

- (void)updateFrame {
    // Positioning our view inside the container view
    CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(_containerView.bounds), _barHeight);
    
    switch (self.displayMode) {
        case AFNotificationBarViewStyleBottom: {
            self.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin);
            
            if (self.isHidden && self.isEnabled) {
                frame.origin.y = CGRectGetHeight(self.containerView.bounds);
            }
            
            else {
                frame.origin.y = CGRectGetHeight(self.containerView.bounds) - CGRectGetHeight(frame);
            }
            
        } break;
            
        case AFNotificationBarViewStyleTop: {
            self.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin);
            
            if (self.isHidden && self.isEnabled) {
                frame.origin.y = - CGRectGetHeight(self.containerView.bounds);
            }
            
            else {
                frame.origin.y = 0.0;
            }
            
        } break;
            
        default:
            break;
    }
    self.frame = frame;
}

#pragma mark - Notifications

- (void)addObservers {
    // By precaution we first remove any observers
    [self removeObservers];
    
    // Notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState) name:kAFSDKIsInitialized object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState) name:kAFSDKPanelWasPresented object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateState) name:kAFSDKPanelWasDismissed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTitleLabel:) name:kAFSDKNotificationsNumberChanged object:nil];
}

- (void)removeObservers {
    // Unsubscribing from all notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Setter

- (void)setShouldHideWhenEmptyCount:(BOOL)shouldHideWhenEmptyCount {
    _shouldHideWhenEmptyCount = shouldHideWhenEmptyCount;
    
    if (!_shouldHideWhenEmptyCount) {
        [self showAnimated:NO];
    }
}

- (void)setIsEnabled:(BOOL)isEnabled {
    _isEnabled = isEnabled;
    
    // We hide it if it's not enabled
    if (!_isEnabled) {
        [self removeObservers];
        [self hideAnimated:NO];
    }
}

- (void)setBarHeight:(CGFloat)barHeight {
    _barHeight = barHeight;
    
    // Updating the frame
    [self updateFrame];
}

- (void)setDisplayMode:(AFNotificationBarViewStyle)displayMode {
    _displayMode = displayMode;
    
    // Updating the frame
    [self updateFrame];
}

- (void)setContainerView:(UIView *)containerView {
    if (_containerView == containerView) {
        return;
    }
    
    if (containerView == nil) {
        [NSException raise:NSInvalidArgumentException format:@"AFNotificationBarView must have a containerView"];
    }
    
    _containerView = containerView;
}

- (void)setCount:(NSUInteger)count {
    if (_count == count) {
        return;
    }
    
    _count = count;
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
    
    [self setNeedsDisplay];
}

- (void)setNoNotificationsText:(NSString *)noNotificationsText {
    _noNotificationsText = noNotificationsText;
    [self updateTitleLabel:nil];
}

- (void)setFreshNotificationsText:(NSString *)freshNotificationsText {
    _freshNotificationsText = freshNotificationsText;
    [self updateTitleLabel:nil];
}

#pragma mark - Show  / Hide

- (void)showAnimated:(BOOL)animated {
    if (!self.isHidden || !self.isEnabled) {
        return;
    }
    
    // Adding our view to the container view
    [self.containerView addSubview:self];
    [self updateFrame];
    
    CFTimeInterval animationDuration = animated ? self.showHideAnimationDuration : 0.0;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect frame = self.frame;
        
        switch (self.displayMode) {
            case AFNotificationBarViewStyleBottom: {
                frame.origin.y = CGRectGetHeight(self.containerView.bounds) - CGRectGetHeight(frame);
            } break;
                
            case AFNotificationBarViewStyleTop: {
                frame.origin.y = 0.0;
            } break;
                
            default:
                break;
        }
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        _isHidden = NO;
    }];
}

- (void)hideAnimated:(BOOL)animated {
    if (self.isHidden) {
        return;
    }
    
    CFTimeInterval animationDuration = animated ? self.showHideAnimationDuration : 0.0;
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        CGRect frame = self.frame;
        
        switch (self.displayMode) {
            case AFNotificationBarViewStyleBottom: {
                frame.origin.y = CGRectGetHeight(self.containerView.bounds) + CGRectGetHeight(frame);
            } break;
                
            case AFNotificationBarViewStyleTop: {
                frame.origin.y = - CGRectGetHeight(frame);
            } break;
                
            default:
                break;
        }
        
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        // Removing our view to the container view
        [self removeFromSuperview];
        
        _isHidden = YES;
    }];
}

- (void)show {
    [self showAnimated:YES];
}

- (void)hide {
    [self hideAnimated:YES];
}

#pragma mark - SDK Events

- (void)updateState {
    [self updateCount];
    
    // Hiding
    if (self.count <= 0 && self.shouldHideWhenEmptyCount && !self.isHidden) {
        [self hide];
    }
    
    // Showing
    else if (self.count > 0 && self.isHidden) {
        [self show];
    }
    
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)updateCount {
    self.count = [AppsfireSDK numberOfPendingNotifications];
    [self setNeedsDisplay];
    [self setNeedsLayout];
}

- (void)updateTitleLabel:(id)notification {
    // If we receive the translations
    if ([notification userInfo] != nil && [[notification userInfo] respondsToSelector:@selector(objectForKey:)]) {
        
        NSString *displayStringNone = [[notification userInfo] objectForKey:@"displayStringNone"];
        NSString *displayStringNew = [[notification userInfo] objectForKey:@"displayStringNew"];
        
        // If the users did not provide translations we use the default ones
        if (self.noNotificationsText == nil && !self.localeHasBeenSet) {
            if (displayStringNone != nil && [displayStringNone isKindOfClass:NSString.class]) {
                self.noNotificationsDefaultText = displayStringNone;
            } else {
                self.noNotificationsDefaultText = kAFNotificationBarNoNotifications;
            }
        }
        
        // If the users did not provide translations we use the default ones
        if (self.freshNotificationsText == nil && !self.localeHasBeenSet) {
            if (displayStringNew != nil && [displayStringNew isKindOfClass:NSString.class]) {
                self.freshNotificationsDefaultText = displayStringNew;
            } else {
                self.freshNotificationsDefaultText = kAFNotificationBarNewNotifications;
            }
        }
        
        if (displayStringNew != nil && displayStringNone != nil) {
            [self saveLocalizedStringsWithDictionary:@{
                                                       @"NO_NOTIFICATIONS" : displayStringNone,
                                                       @"NEW_NOTIFICATIONS" : displayStringNew
                                                       }];
        }
    }
    
    [self updateState];
    
    // Updating the label
    if (self.count <= 0) {
        if (self.noNotificationsText == nil) {
            self.titleLabel.text = self.noNotificationsDefaultText;
        }
        
        else {
            self.titleLabel.text = self.noNotificationsText;
        }
        
    } else {
        if (self.freshNotificationsText == nil) {
            self.titleLabel.text = self.freshNotificationsDefaultText;
        }
        
        else {
            self.titleLabel.text = self.freshNotificationsText;
        }
    }
}

#pragma mark - Behavioral functions

- (void)saveLocalizedStringsWithDictionary:(NSDictionary *)strings {
    if (strings == nil || [strings count] == 0) {
        NSLog(@"AFNotificationBarView -saveLocalizedStringsWithDictionary: did not receive a valid dictionary; will retry later");
        return;
    }
    
    // Only save if a) There is no existing saved file or b) The existing saved strings are different
    NSString *cachePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"];
    NSString *stringsFilePath = [cachePath stringByAppendingPathComponent:@"AFNotificationBarViewStrings"];
    
    NSFileManager *fileManager	= [NSFileManager defaultManager];
    BOOL stringFileExists = [fileManager fileExistsAtPath:stringsFilePath];
    
    // If the file exists we change the strings if they are different
    if (stringFileExists) {
        NSDictionary *existing = [NSDictionary dictionaryWithContentsOfFile:stringsFilePath];
        NSString *noNotifications = [existing valueForKey:@"NO_NOTIFICATIONS"];
        NSString *newNotifications = [existing valueForKey:@"NEW_NOTIFICATIONS"];
        
        if (!([newNotifications isEqualToString:[strings valueForKey:@"NEW_NOTIFICATIONS"]] && [noNotifications isEqualToString:[strings valueForKey:@"NO_NOTIFICATIONS"]])) {
            // They are different, save them to cache
            [strings writeToFile:stringsFilePath atomically:YES];
        }
    }
    
    else {
        [strings writeToFile:stringsFilePath atomically:YES];
    }
}

- (void)loadLocalizedStrings {
    NSString *cachePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library"] stringByAppendingPathComponent:@"Caches"];
    NSString *stringsFilePath = [cachePath stringByAppendingPathComponent:@"AFNotificationBarViewStrings"];
    
    NSFileManager *fileManager	= [NSFileManager defaultManager];
    BOOL stringFileExists = [fileManager fileExistsAtPath:stringsFilePath];
    
    // If the file exists we load the strings from it
    if (stringFileExists) {
        // The file exists so we have previously stored files to cache. Let's load these strings now
        NSDictionary *strings = [NSDictionary dictionaryWithContentsOfFile:stringsFilePath];
        self.noNotificationsDefaultText = [NSString stringWithString:[strings valueForKey:@"NO_NOTIFICATIONS"]];
        self.freshNotificationsDefaultText = [NSString stringWithString:[strings valueForKey:@"NEW_NOTIFICATIONS"]];
        
        self.localeHasBeenSet = YES;
    }
}

@end
