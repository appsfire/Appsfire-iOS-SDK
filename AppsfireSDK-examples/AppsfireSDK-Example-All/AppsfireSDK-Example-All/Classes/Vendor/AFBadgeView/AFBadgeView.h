
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

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface AFBadgeView : UIControl

// The background view of the badge
@property (nonatomic, strong) UIView *backgroundView;

// The label which displays the count value
@property (nonatomic, strong) UILabel *textLabel;

// Count value which is displayed in the badge
@property (nonatomic, assign, readonly) NSUInteger count;

// Boolean value that controls if the transitions should be animated. Default is YES
@property (nonatomic, assign) BOOL isAnimated;

// Boolean whether the badge should be hidden when the count is 0. Default is YES
@property (nonatomic, assign) BOOL shouldHideWhenEmptyCount;

// Updates the badge count.
- (void)updateBadgeCount;

// Updates the visible state.
- (void)updateState;

@end
