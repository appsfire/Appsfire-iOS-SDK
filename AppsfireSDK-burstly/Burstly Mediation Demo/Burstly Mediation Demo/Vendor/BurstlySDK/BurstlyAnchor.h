//
// BurstlyAnchor.h
// Burstly SDK
//
// Copyright 2013 Burstly Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** The anchor tag specifies the region on the frame from where the banner ad fills out.
 Specifying the anchor ensures that the ads of varying sizes (in pixels) are held in place
 with respect to their superview.
 */
typedef enum {
    BurstlyAnchorBottom			= 0x1,
    BurstlyAnchorTop			= 0x2,
    BurstlyAnchorLeft			= 0x4,
    BurstlyAnchorRight			= 0x8,
    BurstlyAnchorCenter			= 0xF  // Equal to BurstlyAnchorBottom | BurstlyAnchorTop | BurstlyAnchorLeft | BurstlyAnchorRight
} BurstlyAnchor;