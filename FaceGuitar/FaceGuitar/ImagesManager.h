//
//  ImagesManager.h
//  FaceGuitar
//
//  Created by YangShun on 13/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImagesManager : NSObject

+ (ImagesManager *)sharedImagesManager;

@property (nonatomic, strong) UIImage *redDot;
@property (nonatomic, strong) UIImage *greenDot;
@property (nonatomic, strong) UIImage *blueDot;
@property (nonatomic, strong) UIImage *yellowDot;
@property (nonatomic, strong) UIImage *grayDot;

@end
