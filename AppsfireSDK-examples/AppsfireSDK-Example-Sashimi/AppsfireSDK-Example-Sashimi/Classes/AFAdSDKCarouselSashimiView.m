//
//  AFAdSDKCarouselSashimiView.m
//  AFAdSDKCarouselSashimiView
//
//  Created by appsfire on 9/29/14.
//  Copyright 2014 appsfire.com
//

/*
 http://en.wikipedia.org/wiki/Zlib_License
 
 This software is provided 'as-is', without any express or implied
 warranty. In no event will the authors be held liable for any damages
 arising from the use of this software.
 
 Permission is granted to anyone to use this software for any purpose,
 including commercial applications, and to alter it and redistribute it
 freely, subject to the following restrictions:
 
 1. The origin of this software must not be misrepresented; you must not
 claim that you wrote the original software. If you use this software
 in a product, an acknowledgment in the product documentation would be
 appreciated but is not required.
 
 2. Altered source versions must be plainly marked as such, and must not be
 misrepresented as being the original software.
 
 3. This notice may not be removed or altered from any source
 distribution.
 */

#import "AFAdSDKCarouselSashimiView.h"
//
#import <UIKit/UIScrollView.h>
#import <UIKit/UIWindow.h>
#import <QuartzCore/CALayer.h>
//
#import "AppsfireAdSDK.h"
#import "AFAdSDKSashimiView.h"

// minimum margin between each element
static CGFloat const kCarouselEltMargin = 12.0;

// element width (calculated via carousel bounds)
static CGFloat const kCarouselEltWidthRatio = 0.80;

// number of additional (preloaded) elements in memory
// note: we strongly advise to not change this value
// note: to optimise a bit the memory, set 1
// note: increasing the value won't make more impressions
static NSUInteger const kCarouselAdditionalElts = 2;

// maximum number of elements displayed inside the carousel
static NSUInteger const kCarouselEltsLimit = 7;

@interface AFAdSDKCarouselSashimiView () <UIScrollViewDelegate, AFAdSDKSashimiViewDelegate>

@property (nonatomic, assign) Class sashimiClass;

@property (nonatomic, assign) AFAdSDKCarouselEffect effects;

@property (nonatomic, strong) NSMutableArray *elementsList;

@property (nonatomic, strong) UIScrollView *contentScrollView;

@property (nonatomic, assign) CGFloat elementMargin;

@property (nonatomic, assign) NSUInteger pageIndex;

- (void)updateElementsConstraints;

@end

@implementation AFAdSDKCarouselSashimiView

- (id)initWithFrame:(CGRect)frame sashimiClass:(Class)subclass effects:(AFAdSDKCarouselEffect)effects {
    
    // call super init
    if ((self = [super initWithFrame:frame]) == nil)
        return nil;
    
    // save class & effects
    self.sashimiClass = subclass;
    self.effects = effects;
    
    //
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.pageIndex = 0;
    self.elementMargin = 0.0;
    
    // instantiate a list to store elements
    self.elementsList = [NSMutableArray array];
    
    // instantiate the scroll view
    self.contentScrollView = [[UIScrollView alloc] init];
    self.contentScrollView.alwaysBounceHorizontal = YES;
    self.contentScrollView.alwaysBounceVertical = NO;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.clipsToBounds = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    [self addSubview:self.contentScrollView];
    
    //
    [self updateSashimiAds];
    
    //
    return self;
    
}

- (void)dealloc {
    
    self.elementsList = nil;
    self.contentScrollView = nil;
    
}

#pragma mark - Layout

- (void)layoutSubviews {
    
    NSUInteger index, count;
    CGSize elementSize;
    UIView *elementView;
    CGRect scrollViewFrame;
    UIEdgeInsets scrollViewInsets;
    
    //
    elementSize = CGSizeMake(floorf(CGRectGetWidth(self.bounds) * kCarouselEltWidthRatio), CGRectGetHeight(self.bounds));
    self.elementMargin = fmin((CGRectGetWidth(self.bounds) - elementSize.width) / 4, kCarouselEltMargin);
    
    // define scrollview frame
    scrollViewFrame = CGRectZero;
    scrollViewFrame.size.width = elementSize.width + self.elementMargin;
    scrollViewFrame.size.height = elementSize.height;
    scrollViewFrame.origin.x = CGRectGetWidth(self.bounds) / 2.0 - CGRectGetWidth(scrollViewFrame) / 2.0;
    if (!CGRectEqualToRect(self.contentScrollView.frame, scrollViewFrame))
        self.contentScrollView.frame = scrollViewFrame;
    
    // check / reset scrollview content inset to zero because of iOS7
    // and apply a horizontal inset of 1.0 to avoid a weird glitch with UIScrollView
    scrollViewInsets = UIEdgeInsetsMake(0.0, 1.0, 0.0, 1.0);
    if (!UIEdgeInsetsEqualToEdgeInsets(self.contentScrollView.contentInset, scrollViewInsets))
        self.contentScrollView.contentInset = scrollViewInsets;
    
    // parse each element view
    for (count = 0, index = 0; index < [self.elementsList count]; index++) {
        
        // get view
        elementView = self.elementsList[index];
        if (![elementView isKindOfClass:[UIView class]])
            continue;
        
        // update its frame
        elementView.transform = CGAffineTransformIdentity;
        [elementView setFrame:CGRectMake(self.elementMargin / 2.0 + count * (elementSize.width + self.elementMargin), 0.0, elementSize.width, elementSize.height)];
        
        // if no superview yet, add it to the scrollview
        if (elementView.superview != self.contentScrollView)
            [self.contentScrollView addSubview:elementView];
        
        //
        count++;
        
    }
    
    // update scrollview content size
    self.contentScrollView.contentSize = CGSizeMake((elementSize.width + self.elementMargin) * count, elementSize.height);
    
    //
    [self updateElementsConstraints];
    
    // adjust content offset
    // mainly needed when device changed of orientation (and thus that the bounds dramatically change)
    if (self.contentScrollView.contentOffset.x != self.pageIndex * CGRectGetWidth(self.contentScrollView.bounds))
        self.contentScrollView.contentOffset = CGPointMake(self.pageIndex * CGRectGetWidth(self.contentScrollView.bounds), 0.0);
    
}

- (void)updateElementsConstraints {
    
    CGFloat ratio;
    UIView *elementView;
    NSUInteger index, eltsCount;
    CGFloat* elementsWith;
    CGPoint elementCenter;
    
    // no need to continue if no effect was enabled
    if (self.effects == AFAdSDKCarouselEffectNone)
        return;
    
    //
    eltsCount = [self.elementsList count];
    
    // alloc some memory for this list of widths
    elementsWith = (CGFloat *)malloc(sizeof(CGFloat) * eltsCount);
    for (index = 0; index < eltsCount; index++) {
        *(elementsWith + index) = 0.0;
    }
    
    // adjust alpha & scale for each element
    for (index = 0; index < eltsCount; index++) {
        
        // get view
        elementView = self.elementsList[index];
        if (![elementView isKindOfClass:[UIView class]])
            continue;
        
        // calculate `ratio`
        // must be between 0 and 1, where 0 = full size
        ratio = fmin(fabs(((self.contentScrollView.contentOffset.x + CGRectGetWidth(self.contentScrollView.bounds) / 2.0) - (self.contentScrollView.bounds.size.width * (index + 0.5))) / CGRectGetWidth(self.contentScrollView.bounds)), 1.0);
        
        // face
        if (self.effects & AFAdSDKCarouselEffectFade)
            elementView.alpha = ((1.0 - ratio) * 0.3) + 0.7;
        
        // scale
        if (self.effects & AFAdSDKCarouselEffectScale)
            elementView.transform = CGAffineTransformScale(CGAffineTransformIdentity, ((1.0 - ratio) * 0.25) + 0.75, ((1.0 - ratio) * 0.25) + 0.75);
        
        //
        *(elementsWith + index) = CGRectGetWidth(elementView.frame);
        
    }
    
    // adjust center of each element
    // mainly needed for `scale` effect
    for (index = 0; index < eltsCount; index++) {
        
        // get view
        elementView = self.elementsList[index];
        if (![elementView isKindOfClass:[UIView class]])
            continue;
        
        // calculate `ratio`
        // can be any value
        ratio = ((self.contentScrollView.contentOffset.x + CGRectGetWidth(self.contentScrollView.bounds) / 2.0) - ((index + 0.5) * CGRectGetWidth(self.contentScrollView.bounds))) / CGRectGetWidth(self.contentScrollView.bounds);
        
        // don't touch the y
        elementCenter.y = elementView.center.y;
        
        // begin at the middle of the cell
        elementCenter.x = (CGRectGetWidth(self.contentScrollView.bounds) * (index + 0.5));
        
        // adjust element inside its cell
        elementCenter.x += ((CGRectGetWidth(self.contentScrollView.bounds) - CGRectGetWidth(elementView.frame) - self.elementMargin) / 2.0) * ((ratio > 0) ? 1.0 : -1.0);
        
        // make the element exceed its cell if needed
        // in theory we could accumulate several values, but as only 3 ads are displayed at the time, it's not needed
        if ((ratio - 1.0) > 0 && index < (eltsCount - 1))
            elementCenter.x += (self.contentScrollView.bounds.size.width - *(elementsWith + index + 1)) - self.elementMargin;
        else if ((ratio + 1.0) < 0 && index > 0)
            elementCenter.x -= (self.contentScrollView.bounds.size.width - *(elementsWith + index - 1)) - self.elementMargin;
        
        //
        elementView.center = elementCenter;
        
    }
    
    //
    free(elementsWith);
    
}

#pragma mark - Scroll View Delegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    // calculate new page index depending target offset and scrollview width
    self.pageIndex = (NSUInteger)((*targetContentOffset).x / CGRectGetWidth(self.contentScrollView.bounds));
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self updateElementsConstraints];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self updateSashimiAds];
    
}

#pragma mark - Update Sashimi Ads

- (void)updateSashimiAds {
    
    NSUInteger index;
    NSInteger missingAds;
    AFAdSDKSashimiView *sashimiView;
    
    // check that we didn't exceed the limit
    if ([self.elementsList count] >= kCarouselEltsLimit)
        return;
    
    // calculate the number of ads we need to load
    missingAds = (kCarouselAdditionalElts + 1) - ([self.elementsList count] - self.pageIndex);
    if (missingAds <= 0)
        return;
    
    //
    for (index = 0; index < missingAds; index++) {
        
        // check that at least one ad is available
        if ([AppsfireAdSDK numberOfSashimiAdsAvailableForSubclass:self.sashimiClass forZone:@"/3180317/square/af"] == 0)
            break;
        
        // get the ad && add it to the list
        sashimiView = (AFAdSDKSashimiView *)[AppsfireAdSDK sashimiViewForSubclass:self.sashimiClass forZone:@"/3180317/square/af" andError:nil];
        if (sashimiView != nil) {
            
            //
            sashimiView.delegate = self;
            
            // apply gray border
            sashimiView.layer.borderColor = [UIColor colorWithWhite:199.0/255.0 alpha:1.0].CGColor;
            sashimiView.layer.borderWidth = 1.0;
            
            //
            [self.elementsList addObject:sashimiView];
            
        }
        
        
    }
    
    // update layout
    [self setNeedsLayout];
    
}

#pragma mark - Hit Test

// due to the paging mode, we have to apply a trick to recognize the touches outside the scrollview bounds

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *childView = nil;
    
    if ((childView = [super hitTest:point withEvent:event]) == self)
        return self.contentScrollView;
    
    return childView;
    
}

#pragma mark - Sashimi View Delegate

- (UIViewController *)viewControllerForSashimiView:(AFAdSDKSashimiView *)sashimiView {
    
    return [UIApplication sharedApplication].keyWindow.rootViewController;
    
}

@end
