//
//  PlayViewController.m
//  FaceGuitar
//
//  Created by YangShun on 12/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "PlayViewController.h"
#import "Controllers.h"
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "ImagesManager.h"
#import "SongPickerViewController.h"
#import "FacebookManager.h"
#import "Friend.h"

static ImagesManager *imagesManager;

@interface PlayViewController () <ControllersDelegate, UIAlertViewDelegate> {
    Column *col1;
    Column *col2;
    Column *col3;
    Column *col4;
    NSTimer *updateTimer;
    NSTimer *beatTimer;
    IBOutlet UILabel *hit;
    IBOutlet UILabel *miss;
    IBOutlet UIImageView *btmBar;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *friends;
    int rowId;
    AVAudioPlayer* audioPlayer;
    int friendIndex;
    CGFloat curYloc;
    
    IBOutlet UIButton *endRestartButton;
    IBOutlet UIButton *endChangeButton;
    IBOutlet UIImageView *endView;
}

- (IBAction)restart:(id)sender;

@end

@implementation PlayViewController

@synthesize song = _song;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [Controllers sharedControllers].delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    endChangeButton.hidden = YES;
    endRestartButton.hidden = YES;
    endView.hidden = YES;
    
    friends = [FacebookManager sharedInstance].friendsArray;
    friendIndex = 0;
    
    imagesManager = [ImagesManager sharedImagesManager];
    rowId = 0;
    CGFloat alpha = 0.0f;
    col1 = [[Column alloc] init];
    col1.frame = CGRectMake(0, 0, 120, 500);
    col1.center = CGPointMake(204, 470);
    col1.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alpha];
    col1.colour = kRed;
    [self.view addSubview:col1];
    
    col2 = [[Column alloc] init];
    col2.frame = CGRectMake(0, 0, 120, 500);
    col2.center = CGPointMake(410, 470);
    col2.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alpha];
    col2.colour = kGreen;
    [self.view addSubview:col2];
    
    col3 = [[Column alloc] init];
    col3.frame = CGRectMake(0, 0, 120, 500);
    col3.center = CGPointMake(614, 470);
    col3.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alpha];
    col3.colour = kBlue;
    [self.view addSubview:col3];
    
    col4 = [[Column alloc] init];
    col4.frame = CGRectMake(0, 0, 120, 500);
    col4.center = CGPointMake(820, 470);
    col4.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:alpha];
    col4.colour = kYellow;
    [self.view addSubview:col4];
    
    NSURL* file = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:self.song.mp3File ofType:@"mp3"]];
    NSLog(@"file: %@", file);
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
    [audioPlayer prepareToPlay];
    NSLog(@"audiop: %@", audioPlayer);

    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:btmBar];
    [self.view addSubview:scrollView];
    curYloc = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateHitCount)
                                                 name:@"hit"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateMissCount:)
                                                 name:@"miss"
                                               object:nil];
    [self startGame];
}

- (IBAction)addFriend:(id)sender {
    Friend *friend = friends[friendIndex++];
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 600, 50)];
    UIImageView *profile = friend.imgView;
    profile.frame = CGRectMake(5, 5, 40, 40);
    profile.layer.cornerRadius = 5;
    profile.layer.masksToBounds = YES;
    [view addSubview:profile];
    UILabel *whereLabel = [[UILabel alloc] init];
    
    switch (arc4random()%6) {
        case 0:
            whereLabel.text = [NSString stringWithFormat:@"You are rocking the house with %@!", friend.name];
            break;
        case 1:
            whereLabel.text = [NSString stringWithFormat:@"%@ is watching your concert!", friend.name];
            break;
        case 2:
            whereLabel.text = [NSString stringWithFormat:@"%@ is awed by your amazing skills!", friend.name];
            break;
        case 3:
            whereLabel.text = [NSString stringWithFormat:@"%@ thinks you are awesome!", friend.name];
            break;
        case 4:
            whereLabel.text = [NSString stringWithFormat:@"%@ says: 'You should do this for a living!'", friend.name];
            break;
        case 5:
            whereLabel.text = [NSString stringWithFormat:@"%@ is dancing away to the beat!'", friend.name];
            break;
        default:
            break;
    }
    
    whereLabel.backgroundColor = [UIColor clearColor];
    whereLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    whereLabel.textColor = [UIColor blackColor];
    whereLabel.frame = CGRectMake(60, 5, 500, 40);
    [view addSubview:whereLabel];
    [scrollView addSubview:view];
    view.frame = CGRectMake(0, curYloc, view.frame.size.width, view.frame.size.height);
    curYloc += 50;
    scrollView.contentSize = CGSizeMake(600, curYloc);
    NSLog(NSStringFromCGSize(scrollView.contentSize));
    if (scrollView.contentSize.height > 200) {
        [scrollView scrollRectToVisible:CGRectMake(0, scrollView.contentSize.height - 200, 600, 200) animated:YES];
    }
    NSLog(@"%@ came to watch your performance.", friend.name);
}

- (void)startGame {
    UIImageView *num1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"num-1@2x.png"]];
    UIImageView *num2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"num-2@2x.png"]];
    UIImageView *num3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"num-3@2x.png"]];
    CGPoint center = CGPointMake(512, 384);
    CGFloat scale = 1.5f;
    num1.center = center;
    num2.center = center;
    num3.center = center;
    [self.view addSubview:num3];
    [UIView animateWithDuration:0.8
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         num3.transform = CGAffineTransformMakeScale(scale, scale);
                         num3.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [num3 removeFromSuperview];
                         if (finished) {
                             [self.view addSubview:num2];
                             [UIView animateWithDuration:0.8
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  num2.transform = CGAffineTransformMakeScale(scale, scale);
                                                  num2.alpha = 0.0;
                                              }
                                              completion:^(BOOL finished){
                                                  if (finished) {
                                                      [self.view addSubview:num1];
                                                      [UIView animateWithDuration:0.8
                                                                            delay:0.0
                                                                          options:UIViewAnimationOptionCurveEaseOut
                                                                       animations:^{
                                                                           num1.transform = CGAffineTransformMakeScale(scale, scale);
                                                                           num1.alpha = 0.0;
                                                                       }
                                                                       completion:^(BOOL finished){
                                                                           if (finished) {
                                                                               [num1 removeFromSuperview];
                                                                               updateTimer = [NSTimer scheduledTimerWithTimeInterval:self.song.beatInterval / 30.0f
                                                                                                                              target:self
                                                                                                                            selector:@selector(updateColumns)
                                                                                                                            userInfo:nil
                                                                                                                             repeats:YES];
                                                                                beatTimer = [NSTimer scheduledTimerWithTimeInterval:self.song.beatInterval
                                                                                                                             target:self
                                                                                                                           selector:@selector(generateDots)
                                                                                                                           userInfo:nil
                                                                                                                            repeats:YES];
                                                                                [beatTimer fire];

                                                                               [updateTimer fire];
																				[audioPlayer playAtTime:audioPlayer.deviceCurrentTime + self.song.playDelay];
                                                                           }
                                                                       }];
                                                  }
                                              }];
                         }
                     }];

}

- (void)showHitTextAtLocation:(CGPoint)pt andType:(int)type {
    UIImage *hitImage;
    switch (type) {
        case 0:
            hitImage = imagesManager.hitText;
            break;
        case 1:
            hitImage = imagesManager.goodText;
            break;
        case 2:
            hitImage = imagesManager.greatText;
            break;
        case 3:
            hitImage = imagesManager.missText;
            break;
        default:
            break;
    }
    UIImageView *text = [[UIImageView alloc] initWithImage:hitImage];
    [self.view addSubview:text];
    text.center = pt;
    [UIView animateWithDuration:0.50
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         text.center = CGPointMake(text.center.x, text.center.y - 50);
                         text.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         if (finished) {
                             [text removeFromSuperview];
                         }
                     }];
}


- (void)buttonPressedWithNumber:(int)number
{
    CGFloat scale = 4.0f;
    switch (number) {
        case 1:
            if (col1.active) {
                col1.currHitDot.state = kHit;
                col1.active = NO;
                [self updateHitCount];
                [self showHitTextAtLocation:CGPointMake(col1.center.x, col1.frame.origin.y + 450) andType:(arc4random()%3)];
                [UIView animateWithDuration:0.35
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     col1.currHitDot.transform = CGAffineTransformMakeScale(scale, scale);
                                     col1.currHitDot.alpha = 0.0;
                                 }
                                 completion:^(BOOL finished){
                                 }];
            } else {
                [self updateMissCount:nil];
            }
            break;
        case 2:
            if (col2.active) {
                col2.currHitDot.state = kHit;
                col2.active = NO;
                [self updateHitCount];
                [self showHitTextAtLocation:CGPointMake(col2.center.x, col2.frame.origin.y + 450)
                 andType:(arc4random()%3)];
                [UIView animateWithDuration:0.35
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     col2.currHitDot.transform = CGAffineTransformMakeScale(scale, scale);
                                     col2.currHitDot.alpha = 0.0;
                                 }
                                 completion:^(BOOL finished){
                                 }];
            } else {
                [self updateMissCount:nil];
            }
            break;
        case 3:
            if (col3.active) {
                col3.currHitDot.state = kHit;
                col3.active = NO;
                [self updateHitCount];
                [self showHitTextAtLocation:CGPointMake(col3.center.x, col3.frame.origin.y + 450)
                 andType:(arc4random()%3)];
                [UIView animateWithDuration:0.35
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     col3.currHitDot.transform = CGAffineTransformMakeScale(scale, scale);
                                     col3.currHitDot.alpha = 0.0;
                                 }
                                 completion:^(BOOL finished){
                                 }];
            } else {
                [self updateMissCount:nil];
            }
            break;
        case 4:
            if (col4.active) {
                col4.currHitDot.state = kHit;
                col4.active = NO;
                [self updateHitCount];
                [self showHitTextAtLocation:CGPointMake(col4.center.x, col4.frame.origin.y + 450)
                 andType:(arc4random()%3)];
                [UIView animateWithDuration:0.35
                                      delay:0.0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     col4.currHitDot.transform = CGAffineTransformMakeScale(scale, scale);
                                     col4.currHitDot.alpha = 0.0;
                                 }
                                 completion:^(BOOL finished){
                                 }];
            } else {
                [self updateMissCount:nil];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)press:(id)sender {
    int number = ((UIButton*)sender).tag;
    [self buttonPressedWithNumber:number];
}

- (void)updateHitCount {
    int value = [hit.text intValue];
    value++;
    if (value%3 == 0) {
        [self addFriend:nil];
    }
    hit.text = [NSString stringWithFormat:@"%d", value];
}

- (void)updateMissCount:(NSNotification*)notification {
    if (notification) {
        NSValue *value = [notification object];
        CGPoint pt = [value CGPointValue];
        [self showHitTextAtLocation:pt andType:3];
    }
    miss.text = [NSString stringWithFormat:@"%d", [miss.text intValue]+1];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self restart:self];
}

- (void)generateDots {
//    if (arc4random() % 3 == 0) {
//        [col1 addBlock];
//    }
//    if (arc4random() % 3 == 0) {
//        [col2 addBlock];
//    }
//    if (arc4random() % 3 == 0) {
//        [col3 addBlock];
//    }
//    if (arc4random() % 3 == 0) {
//        [col4 addBlock];
//    }
    if (rowId >= self.song.notes.count)
    {
        [updateTimer invalidate];
        [beatTimer invalidate];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                                            message:@"Game Over"
                                                           delegate:self
                                                  cancelButtonTitle:@"Replay"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
        int row[4];
        int n = [[self.song.notes objectAtIndex:rowId] intValue];
        
        for (int i = 3; i >= 0; i--)
        {
            row[i] = n % 10;
            n /= 10;
        }
        if (row[0]) {
            [col1 addBlock];
        }
        if (row[1]) {
            [col2 addBlock];
        }
        if (row[2]) {
            [col3 addBlock];
        }
        if (row[3]) {
            [col4 addBlock];
        }
    }

    rowId++;
}

- (void)updateColumns {
    [col1 update];
    [col2 update];
    [col3 update];
    [col4 update];
//    NSLog(@"col1: %d, col2: %d, col3: %d, col4: %d", col1.active,
//                                                      col2.active,
//                                                      col3.active,
//                                                      col4.active);
}

- (void)generateDotForCol1:(BOOL)one
                      col2:(BOOL)two
                      col3:(BOOL)three
                      col4:(BOOL)four {
    if (one) {
        [col1 addBlock];
    }
    if (two) {
        [col2 addBlock];
    }
    if (three) {
        [col3 addBlock];
    }
    if (four) {
        [col4 addBlock];
    }
}

- (IBAction)back:(id)sender {
    [updateTimer invalidate];
    [beatTimer invalidate];
    [audioPlayer stop];
    
    SongPickerViewController  *songPickerController = [[SongPickerViewController alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.transitionController transitionToViewController:songPickerController withOptions:UIViewAnimationTransitionCurlUp];
}

- (IBAction)pause:(id)sender {
    
}

- (IBAction)restart:(id)sender {
    [updateTimer invalidate];
    [beatTimer invalidate];
    [audioPlayer stop];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    PlayViewController *viewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    viewController.song = self.song;
    [appDelegate.transitionController transitionToViewController:viewController withOptions:UIViewAnimationTransitionFlipFromLeft];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)controllers:(Controllers *)controllers didChangeButtonStateButtonType:(ControllerButtonType)buttonType newButtonState:(ControllerButtonState)buttonState
{
    if (buttonType == kButtonTap && (buttonState == kButtonPressed || buttonState == kButtonJustPressed))
    {
        TunesController *tunesController = [Controllers sharedControllers].tunesController;
        if (tunesController.aButtonState == kButtonPressed || tunesController.aButtonState == kButtonJustPressed)
            [self buttonPressedWithNumber:4];
        if (tunesController.bButtonState == kButtonPressed || tunesController.bButtonState == kButtonJustPressed)
            [self buttonPressedWithNumber:3];
        if (tunesController.xButtonState == kButtonPressed || tunesController.xButtonState == kButtonJustPressed)
            [self buttonPressedWithNumber:2];
        if (tunesController.yButtonState == kButtonPressed || tunesController.yButtonState == kButtonJustPressed)
            [self buttonPressedWithNumber:1];
    }
}

@end
