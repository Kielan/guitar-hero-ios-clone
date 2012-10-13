//
//  Column.m
//  FaceGuitar
//
//  Created by YangShun on 12/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "Column.h"
#import "ImagesManager.h"

@implementation Column

static ImagesManager *imagesManager;

@synthesize dotArray = _dotArray, colour = _colour, numGreen = _numGreen, currHitDot = _currHitDot, active = _active;

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"col init");
        self.dotArray = [[NSMutableArray alloc] init];
        self.numGreen = 0;
        imagesManager = [ImagesManager sharedImagesManager];
    }
    return self;
}

- (void)update {
    NSMutableArray *toBeRemoved = [NSMutableArray array];
    for (Dot *dot in self.dotArray) {
        dot.center = CGPointMake(dot.center.x, dot.center.y + 5);
        if (dot.center.y + 25 < 500) {
//            dot.backgroundColor = [UIColor redColor];
            dot.state = kIdle;
        } else if (dot.center.y + 25 < 600) {
            self.currHitDot = dot;
            if (dot.state == kIdle) {
//                dot.backgroundColor = [UIColor greenColor];
                self.active = YES;
                dot.state = kInZone;
            }
        } else if (dot.center.y - 25 < 700) {
            if (dot.state == kInZone) {
                // this dot was missed!
                self.active = NO;
                NSValue *value = [NSValue valueWithCGPoint:CGPointMake(self.center.x, 700)];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"miss" object:value];
                dot.image = imagesManager.grayDot;
                dot.state = kMiss;
            }
        } else {
            dot.state = kExpire;
            [dot removeFromSuperview];
            //[self.dotArray removeObject:dot];
            [toBeRemoved addObject:dot];
        }
    }
    [self.dotArray removeObjectsInArray:toBeRemoved];
}

- (void)addBlock {
    Dot *dot = [[Dot alloc] init];
    dot.frame = CGRectMake (0, 0, 50, 50);
    switch (self.colour) {
        case kRed:
            dot.image = imagesManager.redDot;
            break;
        case kBlue:
            dot.image = imagesManager.blueDot;
            break;
        case kGreen:
            dot.image = imagesManager.greenDot;
            break;
        case kYellow:
            dot.image = imagesManager.yellowDot;
            break;
    }
    dot.backgroundColor = [UIColor clearColor];
    dot.center = CGPointMake(60, 0);
    dot.state = kIdle;
    
    [self addSubview:dot];
    [self.dotArray addObject:dot];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
