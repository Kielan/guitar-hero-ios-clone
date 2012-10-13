//
//  Column.h
//  FaceGuitar
//
//  Created by YangShun on 12/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "Dot.h"

@interface Column : UIImageView

@property(nonatomic, strong) NSMutableArray* dotArray;
@property(nonatomic) ColourType colour;
@property(nonatomic) int numGreen;
@property(nonatomic, strong) Dot *currHitDot;
@property(nonatomic) BOOL active;

- (void)addBlock;
- (void)update;

@end
