
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

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, AFNotificationBarViewStyle) {
    AFNotificationBarViewStyleBottom = 0,
    AFNotificationBarViewStyleTop
};

@interface AFNotificationBarView : UIControl

// Duration of the animation when showing / hiding the notification bar
@property (nonatomic, assign) CFTimeInterval showHideAnimationDuration;

// Height of the notification bar. By default it is set to 40pt
@property (nonatomic, assign) CGFloat barHeight;

// Enumerator that allows to choose the where the view should be fixed
@property (nonatomic, assign) AFNotificationBarViewStyle displayMode;

// Boolean that tells us if the notification is show or hidden. Default is  NO
@property (nonatomic, assign, readonly) BOOL isHidden;

// Count value which is displayed in the badge
@property (nonatomic, assign, readonly) NSUInteger count;

// Boolean whether the notification bar should be hidden when the count is 0. Default is YES
@property (nonatomic, assign) BOOL shouldHideWhenEmptyCount;

// Boolean to enable/disable the bar view, and disabling it make it hidden. Default is YES
@property (nonatomic, assign) BOOL isEnabled;

// UIEdgeInsets that controls the insets of the notification bar
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

// View that is containing the notification bar
@property (nonatomic, strong) UIView *containerView;

// Title in the notification bar
@property (nonatomic, strong) UILabel *titleLabel;

// Count label at the right side of the bar
@property (nonatomic, strong) UILabel *countLabel;

// Text to be displayed in the notification bar when there are no notifications.
// By default the text is English : "You have no new notifications" until we receive the
// translations for the user's language from the server and this can happen at any time.
@property (nonatomic, copy) NSString *noNotificationsText;

// Text to be displayed in the notification bar when there are new notifications.
// By default the text is English : "You have new notifications" until we receive the
// translations for the user's language from the server and this can happen at any time.
@property (nonatomic, copy) NSString *freshNotificationsText;

// Default initializer which allow us to set the container view and the display mode
- (id)initWithContainerView:(UIView *)containerView displayMode:(AFNotificationBarViewStyle)displayMode;

// Initializer which allow us to set the container view, the display mode and the initial enabled / disabled state
- (id)initWithContainerView:(UIView *)containerView displayMode:(AFNotificationBarViewStyle)displayMode isEnabled:(BOOL)isEnabled;

// Initializer with a display mode of `AFNotificationBarViewStyleBottom`
- (id)initWithContainerView:(UIView *)containerView;

// Show the notification bar with the defined animation boolean
- (void)showAnimated:(BOOL)animated;

// Hides the notification bar with the defined animation boolean
- (void)hideAnimated:(BOOL)animated;

// Show the notification bar with an animation
- (void)show;

// Hides the notification bar with an animation
- (void)hide;

@end
