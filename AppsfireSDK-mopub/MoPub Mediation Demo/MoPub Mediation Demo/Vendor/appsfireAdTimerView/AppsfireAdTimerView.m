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

#import "AppsfireAdTimerView.h"
#import <QuartzCore/QuartzCore.h>

// time instead of a real second
#define kAppsfireAdTimerFakeSecond  0.70

// gray used for text (countdown, explanation, ...)
#define kAppsfireAdTimerColorGray1  [ UIColor colorWithRed:70.0/255.0 green:73.0/255.0 blue:74.0/255.0 alpha:1.0 ]

// gray used for skip button
#define kAppsfireAdTimerColorGray2  [ UIColor colorWithWhite:134.0/255.0 alpha:1.0 ]

#pragma mark - Spinner View

@interface AppsfireAdTimerSpinnerView : UIView

@property (nonatomic, strong) UIColor *strokeColor;

- (id)initWithFrame:(CGRect)frame initialCountdown:(NSInteger)countdown;
- (void)startAnimation;
- (void)stopAnimation;

@end

@interface AppsfireAdTimerSpinnerView() {
    
    NSInteger countdownCurrent;
    CADisplayLink *animationDisplayLink;
    CFTimeInterval animationLastTime;
    CGFloat animationAngleStart, animationAngleEnd;
    BOOL animationInvert;
    BOOL wasAnimating;
    
}
- (void)handleDisplayLink:(CADisplayLink *)link;

@end

@implementation AppsfireAdTimerSpinnerView

- (id)initWithFrame:(CGRect)frame initialCountdown:(NSInteger)countdown {
    
    if ((self = [super initWithFrame:frame]) != nil) {
        
        //
        [ self setOpaque:NO ];
        [ self setBackgroundColor:[ UIColor clearColor ] ];
        
        //
        countdownCurrent = countdown;
        _strokeColor = kAppsfireAdTimerColorGray1;
        
        //
        animationDisplayLink = nil;
        animationAngleStart = animationAngleEnd = 0.0;
        animationInvert = NO;
        wasAnimating = NO;
        
    }
    return self;
    
}

- (void)dealloc {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _strokeColor = nil;
    
}

- (void)startAnimation {
    
    //
    if (animationDisplayLink != nil)
        return;
    
    //
    animationInvert = NO;
    animationAngleStart = animationAngleEnd = 0.0;
    animationLastTime = CACurrentMediaTime();
    
    //
    animationDisplayLink = [ CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:) ];
    [animationDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)stopAnimation {
    
    if (animationDisplayLink != nil) {
        [animationDisplayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        animationDisplayLink = nil;
        [self setNeedsDisplay];
    }
    
}

- (void)handleDisplayLink:(CADisplayLink *)link {
    
    CGFloat animationAngle;
    CFTimeInterval currentTime, elapsedTime;
    
    //
    currentTime = CACurrentMediaTime();
    elapsedTime = currentTime - animationLastTime;
    animationLastTime = currentTime;
    
    //
    if (!animationInvert) {
        
        animationAngle = animationAngleEnd;
        animationAngle += elapsedTime / kAppsfireAdTimerFakeSecond;
        if (animationAngle >= 1.0) {
            animationAngleEnd = 0.0;
            animationAngleStart = fmod(animationAngle, 1.0);
            animationInvert = !animationInvert;
            countdownCurrent--; if (countdownCurrent < 0) countdownCurrent = 0;
        } else {
            animationAngleEnd = animationAngle;
        }
        
    } else {
        
        animationAngle = animationAngleStart;
        animationAngle += elapsedTime / kAppsfireAdTimerFakeSecond;
        if (animationAngle >= 1.0) {
            animationAngleStart = 0.0;
            animationAngleEnd = fmod(animationAngle, 1.0);
            animationInvert = !animationInvert;
            countdownCurrent--; if (countdownCurrent < 0) countdownCurrent = 0;
        } else {
            animationAngleStart = animationAngle;
        }
        
    }
    
    //
    [ self setNeedsDisplay ];
    
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context;
    CGFloat animationWidth, pageControlWidth;
    UIFont *countdownFont;
    
    //
    context = UIGraphicsGetCurrentContext();
    
    //
    animationWidth = fminf(CGRectGetWidth(rect), CGRectGetHeight(rect));
    pageControlWidth = 2.5;
    
    // number
    CGContextSaveGState(context);
    {
        // font && color
        countdownFont = [ UIFont fontWithName:@"HelveticaNeue-Light" size:countdownCurrent >= 10 ? 24 : 28.0 ];
        [ kAppsfireAdTimerColorGray1 set ];
        
        //
        [ [ NSString stringWithFormat:@"%d", countdownCurrent ] drawInRect:CGRectMake(0.0, floor(CGRectGetMidY(rect) - countdownFont.lineHeight / 2.0), CGRectGetWidth(rect), countdownFont.lineHeight) withFont:countdownFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter ];
    }
    CGContextRestoreGState(context);
    
    // circle
    CGContextSaveGState(context);
    {
        // stroke width
        CGContextSetLineWidth(context, pageControlWidth);
        
        // stroke color
        CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
        
        // arc
        CGContextAddArc(context, floor(CGRectGetWidth(rect)/2.0), floor(CGRectGetHeight(rect)/2.0), (animationWidth - pageControlWidth*2.0)/2.0, (M_PI*2.0*animationAngleStart)-M_PI_2, (M_PI*2.0*animationAngleEnd)-M_PI_2, NO);
        
        // draw stroke
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    
}

- (void)didMoveToSuperview {
    
    if (self.superview != nil && wasAnimating) {
        wasAnimating = NO;
        [ self startAnimation ];
    } else if (self.superview == nil) {
        wasAnimating = YES;
        [ self stopAnimation ];
    }
    
}

@end

#pragma mark - Inner View

@interface AppsfireAdTimerInnerView : UIView

@property (nonatomic, strong) UILabel *labelExplanation;
@property (nonatomic, strong) UIButton *buttonDontShowAd;
@property (nonatomic, strong) AppsfireAdTimerSpinnerView *viewSpinner;

- (id)initWithWidth:(CGFloat)width initialCountdown:(NSInteger)countdown;

@end

@interface AppsfireAdTimerInnerView()

- (void)_initializeLayout;

@end

@implementation AppsfireAdTimerInnerView

- (id)initWithWidth:(CGFloat)width initialCountdown:(NSInteger)countdown {
    
    if ((self = [super initWithFrame:CGRectMake(0.0, 0.0, width, 100.0)]) != nil) {
        
        //
        [ self setOpaque:NO ];
        [ self setBackgroundColor:[ UIColor clearColor ] ];
        
        // view - spinner
        _viewSpinner = [ [ AppsfireAdTimerSpinnerView alloc ] initWithFrame:CGRectMake(0.0, 0.0, 48.0, 48.0) initialCountdown:countdown ];
        [ self addSubview:_viewSpinner ];
        
        // label - explanation
        _labelExplanation = [ [ UILabel alloc ] init ];
        [ _labelExplanation setBackgroundColor:[ UIColor clearColor ] ];
        [ _labelExplanation setTextColor:kAppsfireAdTimerColorGray1 ];
        [ _labelExplanation setTextAlignment:NSTextAlignmentCenter ];
        [ _labelExplanation setNumberOfLines:0 ];
        [ _labelExplanation setLineBreakMode:NSLineBreakByWordWrapping ];
        [ _labelExplanation setFont:[ UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0 ] ];
        [ _labelExplanation setText:@"We'd like to show you some promotion supporting our app" ];
        [ self addSubview:_labelExplanation ];
        
        // button - don't show ad
        _buttonDontShowAd = [ [ UIButton alloc ] init ];
        [ _buttonDontShowAd setBackgroundColor:[ UIColor clearColor ] ];
        [ _buttonDontShowAd setTitleColor:kAppsfireAdTimerColorGray2 forState:UIControlStateNormal ];
        [ _buttonDontShowAd.titleLabel setFont:[ UIFont fontWithName:@"HelveticaNeue" size:17.0 ] ];
        [ _buttonDontShowAd setTitle:@"Skip Ad" forState:UIControlStateNormal ];
        [ self addSubview:_buttonDontShowAd ];
        
        //
        [ self _initializeLayout ];
        
        //[ self debug ];
        
    }
    return self;
    
}

- (void)debug {
    
    [ _viewSpinner setBackgroundColor:[ UIColor grayColor ] ];
    [ _labelExplanation setBackgroundColor:[ UIColor yellowColor ] ];
    [ _buttonDontShowAd setBackgroundColor:[ UIColor orangeColor ] ];
    
}

- (void)dealloc {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _labelExplanation = nil;
    _buttonDontShowAd = nil;
    _viewSpinner = nil;
    
}

#pragma mark Layout

- (void)_initializeLayout {
    
    UIEdgeInsets padding;
    CGFloat viewCountdownBottomMargin, labelExplanationBottomMargin;
    CGRect viewCountdownFrame, labelExplanationFrame, buttonCloseFrame, selFrame;
    
    //
    padding = UIEdgeInsetsMake(12.0, 10.0, 0.0, 10.0);
    viewCountdownBottomMargin = 5.0;
    labelExplanationBottomMargin = 8.0;
    viewCountdownFrame = labelExplanationFrame = buttonCloseFrame = CGRectZero;
    
    // label countdown (define width + calculate height)
    viewCountdownFrame.size = _viewSpinner.frame.size;
    viewCountdownFrame.origin = CGPointMake(floor(CGRectGetWidth(self.frame) / 2.0 - CGRectGetWidth(viewCountdownFrame) / 2.0), padding.top);
    [ _viewSpinner setFrame:viewCountdownFrame ];
    
    // label explanation (define width + calculate height)
    labelExplanationFrame.origin = CGPointMake(padding.left, CGRectGetMaxY(viewCountdownFrame) + viewCountdownBottomMargin);
    labelExplanationFrame.size.width = CGRectGetWidth(self.frame) - padding.left - padding.right;
    labelExplanationFrame.size.height = [ self stringSizeOfText:_labelExplanation.text withFont:_labelExplanation.font constrainedToSize:CGSizeMake(labelExplanationFrame.size.width, CGFLOAT_MAX) lineBreakMode:_labelExplanation.lineBreakMode ].height;
    [ _labelExplanation setFrame:labelExplanationFrame ];
    
    // button close (define width / height)
    buttonCloseFrame.origin = CGPointMake(0.0, CGRectGetMaxY(labelExplanationFrame) + labelExplanationBottomMargin);
    buttonCloseFrame.size.width = CGRectGetWidth(self.frame);
    buttonCloseFrame.size.height = 44.0;
    [ _buttonDontShowAd setFrame:buttonCloseFrame ];
    
    // self frame - adjust height
    selFrame = CGRectZero;
    selFrame.size = self.frame.size;
    selFrame.size.height = padding.top + CGRectGetHeight(viewCountdownFrame) + viewCountdownBottomMargin + CGRectGetHeight(labelExplanationFrame) + labelExplanationBottomMargin + CGRectGetHeight(buttonCloseFrame);
    [ self setFrame:selFrame ];
    
}

#pragma mark String Size Helper

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

#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context;
    UIBezierPath *pathBackground;
    
    //
    context = UIGraphicsGetCurrentContext();
    
    // draw background
    CGContextSaveGState(context);
    {
        // define path
        pathBackground = [ UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:5.0 ];
        
        // define background color
        [ [ UIColor colorWithRed:221.0/255.0 green:226.0/255.0 blue:226.0/255.0 alpha:0.9 ] setFill ];
        
        // draw
        [ pathBackground fill ];
    }
    CGContextRestoreGState(context);
    
    // draw line above close button
    CGContextSaveGState(context);
    {
        // line width
        CGContextSetLineWidth(context, 1.0);
        
        // line color
        CGContextSetStrokeColorWithColor(context, kAppsfireAdTimerColorGray2.CGColor);
        
        // line path
        CGContextMoveToPoint(context, 0.0, CGRectGetMinY(_buttonDontShowAd.frame));
        CGContextAddLineToPoint(context, CGRectGetMaxX(_buttonDontShowAd.frame), CGRectGetMinY(_buttonDontShowAd.frame));
        
        // draw
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
    
}

@end


#pragma mark - Main View

@interface AppsfireAdTimerView() {
    
    NSInteger _countdownMax;
    AppsfireAdTimerInnerView *_viewInner;
    AppsfireAdTimerCompletion _completionBlock;
    NSTimer *_timerCountdown;
    UIDeviceOrientation _lastKnownOrientation;
    
}
- (void)_refreshLayoutAndOrientation;
- (void)_deviceOrientationDidChange;
- (void)_presentAnimationStep:(NSInteger)step;
- (void)_handleCountdownEnd;
- (void)_handleCloseButton;
- (void)_dismissAndTerminateWithSuccess:(BOOL)success;

@end

@implementation AppsfireAdTimerView

- (id)initWithCountdownStart:(NSInteger)startNumber {
    
    CGRect frame;
    CGFloat viewInnerWidth;
    
    //
    frame = [ UIScreen mainScreen ].bounds;
    
    //
    if ((self = [super initWithFrame:frame]) != nil) {
        
        //
        _timerCountdown = nil;
        _completionBlock = nil;
        [ self setBackgroundColor:[ UIColor colorWithWhite:0.0 alpha:0.45 ] ];

        // countdown
        _countdownMax = startNumber;
        if (_countdownMax <= 0 || _countdownMax > 10)
            _countdownMax = 3;
        
        //
        viewInnerWidth = 270.0;
        _viewInner = [ [ AppsfireAdTimerInnerView alloc ] initWithWidth:viewInnerWidth initialCountdown:_countdownMax ];
        [ _viewInner setFrame:CGRectMake(floor(CGRectGetWidth(frame) / 2.0 - CGRectGetWidth(_viewInner.frame) / 2.0), floor(CGRectGetHeight(frame) / 2.0 - CGRectGetHeight(_viewInner.frame) / 2.0), CGRectGetWidth(_viewInner.frame), CGRectGetHeight(_viewInner.frame)) ];
        [ _viewInner.buttonDontShowAd addTarget:self action:@selector(_handleCloseButton) forControlEvents:UIControlEventTouchUpInside ];
        [ self addSubview:_viewInner ];
        
        //
        [ self _refreshLayoutAndOrientation ];
        
        // orientation did change
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
        
    }
    return self;
    
}

- (void)dealloc {
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [ [ NSNotificationCenter defaultCenter ] removeObserver:self ];
    _viewInner = nil;
    _completionBlock = nil;
    _timerCountdown = nil;
    
}

#pragma mark - Layout / Resize / Rotation

- (void)_refreshLayoutAndOrientation {
    
    CGSize screenBounds;
    UIDeviceOrientation deviceOrientation;
    CGFloat orientationTransformationValue;
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
        
    // decide orientation
    _lastKnownOrientation = deviceOrientation = [ UIDevice currentDevice ].orientation;
    // if orientation isn't valid, then convert from status bar
    if (!UIDeviceOrientationIsValidInterfaceOrientation(_lastKnownOrientation)) {
        switch ([ UIApplication sharedApplication ].statusBarOrientation) {
            case UIInterfaceOrientationPortrait:
                deviceOrientation = UIDeviceOrientationPortrait;
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
                break;
            case UIInterfaceOrientationLandscapeLeft:
                deviceOrientation = UIDeviceOrientationLandscapeRight;
                break;
            case UIInterfaceOrientationLandscapeRight:
                deviceOrientation = UIDeviceOrientationLandscapeLeft;
                break;
            default:
                deviceOrientation = UIDeviceOrientationPortrait;
                break;
        }
        _lastKnownOrientation = deviceOrientation;
    }
    
    //
    screenBounds = [ UIScreen mainScreen ].bounds.size;
    
    // apply transform
    orientationTransformationValue = 0.0;
    if (deviceOrientation == UIDeviceOrientationLandscapeRight)
        orientationTransformationValue = 1.5;
    else if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
        orientationTransformationValue = 0.5;
    else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown)
        orientationTransformationValue = -1.0;
    [ _viewInner setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, M_PI*orientationTransformationValue) ];
    
    // adjust origin
    [ _viewInner setFrame:CGRectMake(floor(screenBounds.width / 2.0 - CGRectGetWidth(_viewInner.frame) / 2.0), floor(screenBounds.height / 2.0 - CGRectGetHeight(_viewInner.frame) / 2.0), CGRectGetWidth(_viewInner.frame), CGRectGetHeight(_viewInner.frame)) ];
    
}

- (void)_deviceOrientationDidChange {
    
    NSLog(@"%s (mainThread=%d)", __PRETTY_FUNCTION__, [NSThread isMainThread]);
    
    //
    if (UIDeviceOrientationIsValidInterfaceOrientation([UIDevice currentDevice].orientation) && [UIDevice currentDevice].orientation != _lastKnownOrientation) {
        
        // rotate with animation
        [ UIView animateWithDuration:[UIApplication sharedApplication].statusBarOrientationAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            [ self _refreshLayoutAndOrientation ];
            
        } completion:nil ];
        
    }
    
}

#pragma mark Presentation

//
- (void)presentWithCompletion:(AppsfireAdTimerCompletion)completion {

    //
    _completionBlock = [ completion copy ];
   
    //
    [ self _presentAnimationStep:1 ];
    
}

- (void)_presentAnimationStep:(NSInteger)step {
    
    switch (step) {
            
        // quickly fade in wrapper view
        case 1:
        {
            //
            [[UIApplication sharedApplication].keyWindow addSubview:self];
            [ self setAlpha:0.0 ];

            //
            [ UIView animateWithDuration:0.20 animations:^{
                
                [ self setAlpha:1.0 ];
                
            } completion:^(BOOL finished) {
                
                // start spinner animation
                [ _viewInner.viewSpinner startAnimation ];
                
                // start timer
                _timerCountdown = [ NSTimer scheduledTimerWithTimeInterval:(_countdownMax * kAppsfireAdTimerFakeSecond + 0.01) target:self selector:@selector(_handleCountdownEnd) userInfo:nil repeats:NO ];
                
            } ];
            
            break;
        }

        default:
            break;
    }
    
}

#pragma mark Countdown

- (void)_handleCountdownEnd {
    
    //
    _timerCountdown = nil;
    
    //
    [ self _dismissAndTerminateWithSuccess:YES ];

}

#pragma mark Close Button

- (void)_handleCloseButton {
    
    // cancel countdown
    [ _timerCountdown invalidate ], _timerCountdown = nil;
    
    //
    [ self _dismissAndTerminateWithSuccess:NO ];

}

#pragma mark Dismiss and terminate

- (void)_dismissAndTerminateWithSuccess:(BOOL)success {
    
    // stop spinner animation
    [ _viewInner.viewSpinner stopAnimation ];
    
    //
    [ UIView animateWithDuration:0.20 animations:^{
        
        [ self setAlpha:0.0 ];
        
    } completion:^(BOOL finished) {
        
        //
        if (_completionBlock != nil)
            _completionBlock(success);
        
        //
        [ self removeFromSuperview ];
        
    } ];
    
}

@end
