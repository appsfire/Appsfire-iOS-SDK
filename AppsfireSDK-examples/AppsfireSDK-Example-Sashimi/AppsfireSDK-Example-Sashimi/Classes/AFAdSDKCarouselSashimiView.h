//
//  AFAdSDKCarouselSashimiView.h
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

@import UIKit.UIView;

/*!
 *  @brief Enum for specifying the effect(s) applied to the carousel.
 */

typedef NS_OPTIONS(NSUInteger, AFAdSDKCarouselEffect) {
    /** No effect */
    AFAdSDKCarouselEffectNone   = 0,
    /** Fade */
    AFAdSDKCarouselEffectFade   = 0 << 1,
    /** Scale */
    AFAdSDKCarouselEffectScale  = 1 << 1
};

@interface AFAdSDKCarouselSashimiView : UIView

/*!
 *  @brief Initialization
 *
 *  @param frame The frame of the view
 *  @param subclass A sashimi subclass. You can set `AFAdSDKSashimiMinimalView` or `AFAdSDKSashimiExtendedView` for templates, or just create your custom sashimi.
 *  @param effects Effects you would like in the carousel. Set `AFAdSDKCarouselEffectNone` if none.
 *
 *  @return View of the carousel.
 */

- (id)initWithFrame:(CGRect)frame sashimiClass:(Class)subclass effects:(AFAdSDKCarouselEffect)effects;

/*!
 *  @brief Ask sashimi ads to be updated. It's automatically called when you instanciate the view. You only need to call this method if you create an instance of this view before sashimi ads were downloaded (and so available for display).
 */

- (void)updateSashimiAds;

@end
