//
//  TapViewController.h
//  FaceGuitar-iPhone
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TapViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *tapButton;

- (IBAction)buttonPressed:(id)sender;
- (IBAction)buttonReleased:(id)sender;

@end
