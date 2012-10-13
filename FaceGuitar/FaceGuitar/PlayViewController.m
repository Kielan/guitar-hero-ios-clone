//
//  PlayViewController.m
//  FaceGuitar
//
//  Created by YangShun on 12/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController () {
    Column *col1;
    Column *col2;
    Column *col3;
    Column *col4;
    NSTimer *updateTimer;
    int counter;
}

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    counter = 0;
    
    col1 = [[Column alloc] init];
    col1.frame = CGRectMake(0, 0, 120, 600);
    col1.center = CGPointMake(204, 420);
    col1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:col1];
    
    col2 = [[Column alloc] init];
    col2.frame = CGRectMake(0, 0, 120, 600);
    col2.center = CGPointMake(410, 420);
    col2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:col2];
    
    col3 = [[Column alloc] init];
    col3.frame = CGRectMake(0, 0, 120, 600);
    col3.center = CGPointMake(614, 420);
    col3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:col3];
    
    col4 = [[Column alloc] init];
    col4.frame = CGRectMake(0, 0, 120, 600);
    col4.center = CGPointMake(820, 420);
    col4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:col4];

    updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f
                                                   target:self
                                                 selector:@selector(updateColumns)
                                                 userInfo:nil
                                                  repeats:YES];
    [updateTimer fire];
    // Do any additional setup after loading the view from its nib.
}

- (void)generateDots {
    if (arc4random() % 3 == 0) {
        [col1 addBlock];
    }
    if (arc4random() % 3 == 0) {
        [col2 addBlock];
    }
    if (arc4random() % 3 == 0) {
        [col3 addBlock];
    }
    if (arc4random() % 3 == 0) {
        [col4 addBlock];
    }
}

- (void)updateColumns {
    counter++;
    if (counter == 30) {
        [self generateDots];
        counter = 0;
    }
    [col1 update];
    [col2 update];
    [col3 update];
    [col4 update];
    NSLog(@"col1: %d, col2: %d, col3: %d, col4: %d", col1.dotArray.count,
                                                      col2.dotArray.count,
                                                      col3.dotArray.count,
                                                      col4.dotArray.count);
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

@end
