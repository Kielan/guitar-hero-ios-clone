//
//  Song.m
//  FaceGuitar
//
//  Created by Ken on 10/13/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "Song.h"

@interface Song ()

@property (nonatomic, readwrite, strong) NSArray *notes;
@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *mp3File;

@end

@implementation Song

@synthesize name = _name, notes =  _notes, mp3File = _mp3File, highScore = _highScore;

+ (NSArray *)songs
{
    return [NSArray arrayWithObjects:[Song gangnamSong], nil];
}

+ (Song *)gangnamSong
{
    return [[Song alloc] initWithName:@"Gangnam Style" notes:[NSArray arrayWithObjects:
            @"1000",@"0100",@"0100",@"0001",@"1000",@"0010",@"0100",@"1000",
            @"1000",@"0100",@"0100",@"0001",@"1000",@"0010",@"0100",@"1000",
            @"1000",@"0110",@"0110",@"0001",@"1000",@"0010",@"0100",@"1100",
            @"1000",@"0110",@"0110",@"0001",@"1000",@"0010",@"0100",@"1100",
            @"1000",@"0100",@"0100",@"0001",@"1000",@"0010",@"0100",@"1100",
            @"1000",@"0100",@"0100",@"0001",@"0110",@"0110",@"1110",@"1110",
            @"1100",@"1100",@"1100",@"1100",@"0011",@"0011",@"0011",@"0011",
            @"1000",@"0100",@"0100",@"0001",@"1000",@"0010",@"0100",@"1000",
            @"1100",@"1100",@"1100",@"1100",@"0011",@"0011",@"0011",@"0011",
            @"1000",@"0100",@"0100",@"0001",@"0110",@"0110",@"1110",@"1110",
            @"0000",@"0000",@"0000",@"0000",@"1111",@"0000",@"0000",@"0000",
            @"0000",@"0000",@"0000",@"0000",@"0000",@"0000",@"0000",@"0000",nil] mp3File:@"gangnam"];
}

- (id)initWithName:(NSString *)name notes:(NSArray *)notes mp3File:(NSString *)mp3File
{
    if (self = [super init])
    {
        self.name = name;
        self.notes = notes;
        self.mp3File = mp3File;
    }
    return self;
}

@end
