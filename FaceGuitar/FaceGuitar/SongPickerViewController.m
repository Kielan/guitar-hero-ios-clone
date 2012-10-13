//
//  SongPickerViewController.m
//  FaceGuitar
//
//  Created by Ken on 10/13/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "SongPickerViewController.h"
#import "Song.h"
#import "SongViewController.h"
#import "AppDelegate.h"
#import "PlayViewController.h"

@interface SongPickerViewController () <SongViewControllerDelegate>

//- (void)chooseSong:(UITapGestureRecognizer *)tapGestureRecognizer;

@property (nonatomic, strong) NSMutableArray *songControllers;

@end

@implementation SongPickerViewController

- (id)init
{
    if (self = [super initWithNibName:@"SongPickerViewController" bundle:nil])
    {
        NSArray *songs = [Song songs];
        self.songControllers = [NSMutableArray arrayWithCapacity:songs.count];
        
        CGFloat x = 200, y = 768.0 / 2, xSpacing = 50;
        CGFloat songViewWidth = 309;
        CGFloat totalWidth = songs.count * songViewWidth + (songs.count - 1) * xSpacing;
        x = (1024 - totalWidth) / 2 + songViewWidth/2;
        for (Song *song in songs)
        {
            SongViewController *songController = [[SongViewController alloc] initWithSong:song];
            songController.view.center = CGPointMake(x, y);
            songController.delegate = self;
//            UITapGestureRecognizer *chooseSongGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseSong:)];
//            [songController.view addGestureRecognizer:chooseSongGesture];
            [self.view addSubview:songController.view];
            [self.songControllers addObject:songController];
            
            x += songController.view.frame.size.width + xSpacing;
        }
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//- (void)chooseSong:(UITapGestureRecognizer *)tapGestureRecognizer
//{
//    UIView *view = [tapGestureRecognizer view];
//    SongViewController *songController = (SongViewController *)[view nextResponder];
//}

- (void)songControllerDidGetSelected:(SongViewController *)songController
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    PlayViewController *viewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    viewController.song = songController.song;
    [appDelegate.transitionController transitionToViewController:viewController withOptions:UIViewAnimationTransitionFlipFromLeft];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
