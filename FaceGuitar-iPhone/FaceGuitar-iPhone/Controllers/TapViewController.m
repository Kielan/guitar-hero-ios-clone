//
//  TapViewController.m
//  FaceGuitar-iPhone
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "TapViewController.h"
#import "NetworkManager.h"

typedef enum { kButtonReleased, kButtonJustReleased, kButtonPressed, kButtonJustPressed } ControllerButtonState;
typedef enum { kButtonTuneA, kButtonTuneB, kButtonTuneX, kButtonTuneY, kButtonTap } ControllerButtonType;
typedef struct { ControllerButtonType buttonType; ControllerButtonState buttonState; } ControllerButtonAction;


@interface TapViewController ()

@end

@implementation TapViewController

@synthesize tapButton = _tapButton;

- (id)init
{
    if (self = [super initWithNibName:@"TapView" bundle:nil])
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
    action.buttonType = kButtonTap;
    action.buttonState = kButtonJustPressed;
    
    [[NetworkManager sharedNetworkManager] sendDataToServer:[NSData dataWithBytes:&action length:sizeof(action)] dataMode:GKSendDataReliable];
}

- (IBAction)buttonReleased:(id)sender
{   
    ControllerButtonAction action;
    action.buttonType = kButtonTap;
    action.buttonState = kButtonJustReleased;
    
    [[NetworkManager sharedNetworkManager] sendDataToServer:[NSData dataWithBytes:&action length:sizeof(action)] dataMode:GKSendDataReliable];
}

@end
