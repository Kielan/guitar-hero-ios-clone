//
//  SongViewController.m
//  FaceGuitar
//
//  Created by Ken on 10/13/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "SongViewController.h"

@interface SongViewController ()

@property (nonatomic, readwrite, strong) Song *song;

//- (void)chosen;

- (void)songSelected;

@end

@implementation SongViewController

@synthesize song = _song, songImageView = _songImageView, songNameLabel = _songNameLabel, delegate = _delegate;


- (id)initWithSong:(Song *)song
{
    if (self = [super initWithNibName:@"SongViewController" bundle:nil])
    {
        self.song = song;
    }
//    if (self = [super init])
//    {
//        self.view = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
//        [(UIButton*)self.view addTarget:self action:@selector(chosen) forControlEvents:UIControlEventTouchUpInside];
//    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.songNameLabel.text = self.song.name;
//    self.songImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.song.name]];
    
    //[self.songButton setTitle:self.song.name forState:UIControlStateNormal];
//    [self.songButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"song-%@", self.song.mp3File]] forState:UIControlStateNormal];
    [self.songButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"song-%@", self.song.mp3File]] forState:UIControlStateNormal];
    [self.songButton addTarget:self action:@selector(songSelected) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)songSelected
{
    [self.delegate songControllerDidGetSelected:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
