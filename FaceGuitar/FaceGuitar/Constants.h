//
//  Constants.h
//  FaceGuitar
//
//  Created by YangShun on 12/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kRed,
    kGreen,
    kBlue,
    kYellow
} ColourType;

typedef enum {
    kIdle,
    kInZone,
    kHit,
    kMiss,
    kExpire
} DotState;