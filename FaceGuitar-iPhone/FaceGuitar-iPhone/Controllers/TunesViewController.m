//
//  TunesViewController.m
//  FaceGuitar-iPhone
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "TunesViewController.h"
#import "NetworkManager.h"

typedef enum { kButtonReleased, kButtonJustReleased, kButtonPressed, kButtonJustPressed } ControllerButtonState;
typedef enum { kButtonTuneA, kButtonTuneB, kButtonTuneX, kButtonTuneY, kButtonTap } ControllerButtonType;
typedef struct { ControllerButtonType buttonType; ControllerButtonState buttonState; } ControllerButtonAction;

@interface TunesViewController ()

@end

@implementation TunesViewController

@synthesize tuneABtn = _tuneABtn, tuneBBtn = _tuneBBtn, tuneXBtn = _tuneXBtn, tuneYBtn = _tuneYBtn;

- (id)init
{
    if (self = [super initWithNibName:@"TunesView" bundle:nil])
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - IBActions

- (IBAction)buttonPressed:(id)sender
{
    ControllerButtonAction action;
    if (sender == self.tuneABtn)
        action.buttonType = kButtonTuneA;
    else if (sender == self.tuneBBtn)
        action.buttonType = kButtonTuneB;
    else if (sender == self.tuneXBtn)
        action.buttonType = kButtonTuneX;
    else if (sender == self.tuneYBtn)
        action.buttonType = kButtonTuneY;
    
    action.buttonState = kButtonJustPressed;
    
    [[NetworkManager sharedNetworkManager] sendDataToServer:[NSData dataWithBytes:&action length:sizeof(action)] dataMode:GKSendDataReliable];
}

- (IBAction)buttonReleased:(id)sender
{
    ControllerButtonAction action;
    if (sender == self.tuneABtn)
        action.buttonType = kButtonTuneA;
    else if (sender == self.tuneBBtn)
        action.buttonType = kButtonTuneB;
    else if (sender == self.tuneXBtn)
        action.buttonType = kButtonTuneX;
    else if (sender == self.tuneYBtn)
        action.buttonType = kButtonTuneY;
    
    action.buttonState = kButtonJustReleased;
    
    [[NetworkManager sharedNetworkManager] sendDataToServer:[NSData dataWithBytes:&action length:sizeof(action)] dataMode:GKSendDataReliable];
}

@end
