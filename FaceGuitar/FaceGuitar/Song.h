//
//  Song.h
//  FaceGuitar
//
//  Created by Ken on 10/13/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, readonly, strong) NSString *name;
@property (nonatomic, readonly, strong) NSArray *notes;
@property (nonatomic, readonly, strong) NSString *mp3File;

@property (nonatomic, assign) NSUInteger highScore;

+ (Song *)gangnamSong;

- (id)initWithName:(NSString *)name notes:(NSArray *)notes mp3File:(NSString *)mp3File;



@end
