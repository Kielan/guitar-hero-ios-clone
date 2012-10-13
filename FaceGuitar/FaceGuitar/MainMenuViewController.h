//
//  MainMenuViewController.h
//  FaceGuitar
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *hostGameBtn;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *connectIndicatorView;
@property (nonatomic, weak) IBOutlet UILabel *connectMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel *connectTapMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel *connectTunesMessageLabel;


- (IBAction)hostGame:(id)sender;
-(void)updateLoginBtn;
@end
