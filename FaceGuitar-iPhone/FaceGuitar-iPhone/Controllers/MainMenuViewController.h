//
//  MainMenuViewController.h
//  FaceGuitar-iPhone
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *connectAsTapBtn;
@property (nonatomic, weak) IBOutlet UIButton *connectAsTunesBtn;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *connectIndicatorView;
@property (nonatomic, weak) IBOutlet UILabel *networkStatusLabel;

- (IBAction)connectAsTap:(id)sender;
- (IBAction)connectAsTunes:(id)sender;

@end
