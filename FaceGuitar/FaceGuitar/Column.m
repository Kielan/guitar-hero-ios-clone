//
//  Column.m
//  FaceGuitar
//
//  Created by YangShun on 12/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "Column.h"

@implementation Column

- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"col init");
        self.dotArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)update {
    NSMutableArray *toBeRemoved = [NSMutableArray array];
    for (Dot *dot in self.dotArray) {
        dot.center = CGPointMake(dot.center.x, dot.center.y + 5);
        if (dot.center.y + 25 < 500) {
            dot.backgroundColor = [UIColor redColor];
            dot.state = kIdle;
        } else if (dot.center.y + 25 < 600) {
            dot.backgroundColor = [UIColor greenColor];
            dot.state = kHit;
        } else if (dot.center.y - 25 < 700) {
            dot.backgroundColor = [UIColor blackColor];
            dot.state = kMiss;
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
    dot.backgroundColor = [UIColor redColor];
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
