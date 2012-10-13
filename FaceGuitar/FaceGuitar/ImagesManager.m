//
//  ImagesManager.m
//  FaceGuitar
//
//  Created by YangShun on 13/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "ImagesManager.h"

static ImagesManager *_sharedImagesManager;

@implementation ImagesManager {

}

@synthesize redDot;
@synthesize blueDot;
@synthesize greenDot;
@synthesize yellowDot;
@synthesize grayDot;

+ (ImagesManager *)sharedImagesManager {
    if (!_sharedImagesManager) {
        _sharedImagesManager = [[ImagesManager alloc] init];
    }
    return _sharedImagesManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.redDot = [UIImage imageNamed:@"red-dot@2x.png"];
        self.blueDot = [UIImage imageNamed:@"blue-dot@2x.png"];
        self.greenDot = [UIImage imageNamed:@"green-dot@2x.png"];
        self.yellowDot = [UIImage imageNamed:@"yellow-dot@2x.png"];
        self.grayDot = [UIImage imageNamed:@"gray-dot@2x.png"];
    }
    return self;
}

@end
