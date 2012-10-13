//
//  TunesViewController.h
//  FaceGuitar-iPhone
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TunesViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *tuneABtn, *tuneBBtn, *tuneXBtn, *tuneYBtn;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)buttonReleased:(id)sender;

@end
