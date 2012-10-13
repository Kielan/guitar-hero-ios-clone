//
//  MainMenuViewController.m
//  FaceGuitar-iPhone
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "MainMenuViewController.h"
#import "NetworkManager.h"
#import "AppDelegate.h"
#import "TapViewController.h"
#import "TunesViewController.h"

typedef enum { kNetworkDisconnected, kNetworkConnecting, kNetworkConnected } NetworkStatus;
typedef enum { kControllerTap, kControllerTunes } ControllerType;

static NSString * const HostGKSessionID = @"FaceGuitar";
static NSString * const TapGKSessionID = @"Tap";
static NSString * const TunesGKSessionID = @"Tunes";
static NSString * const FaceGuitarGKSessionID = @"FaceGuitar";

@interface MainMenuViewController () <GKSessionDelegate>

@property (nonatomic, assign) NetworkStatus networkStatus;
@property (nonatomic, assign) ControllerType controllerType;

@end

@implementation MainMenuViewController

@synthesize connectAsTapBtn = _connectAsTapBtn;
@synthesize connectAsTunesBtn = _connectAsTunesBtn;
@synthesize connectIndicatorView = _connectIndicatorView;
@synthesize networkStatusLabel = _networkStatusLabel;
@synthesize networkStatus = _networkStatus;
@synthesize controllerType = _controllerType;

- (id)init
{
    if (self = [super initWithNibName:@"MainMenu" bundle:nil])
    {
        self.networkStatus = kNetworkDisconnected;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.connectIndicatorView.hidden = YES;
    self.networkStatusLabel.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setNetworkStatus:(NetworkStatus)networkStatus
{
    _networkStatus = networkStatus;
    NSString *controllerTypeName = self.controllerType == kControllerTap ? TapGKSessionID : TunesGKSessionID;
    
    switch (self.networkStatus) {
        case kNetworkDisconnected:
            break;
            
        case kNetworkConnecting:
            self.connectAsTapBtn.enabled = NO;
            self.connectAsTunesBtn.enabled = NO;
            
            self.connectIndicatorView.hidden = NO;
            [self.connectIndicatorView startAnimating];
            
            self.networkStatusLabel.hidden = NO;
            self.networkStatusLabel.text = [NSString stringWithFormat:@"Connecting as %@...", controllerTypeName, nil];
            break;
            
            
        case kNetworkConnected:
            self.networkStatusLabel.text = [NSString stringWithFormat:@"Connected as %@.\nWaiting for game to start", controllerTypeName, nil];
            break;
            
        default:
            break;
    }
}


#pragma mark - IBActions

- (IBAction)connectAsTap:(id)sender
{
    self.controllerType = kControllerTap;
    self.networkStatus = kNetworkConnecting;
    
    NetworkManager *networkManager = [NetworkManager sharedNetworkManager];
    networkManager.gkSession = [[GKSession alloc] initWithSessionID:FaceGuitarGKSessionID displayName:TapGKSessionID sessionMode:GKSessionModeClient];
    networkManager.gkSession.delegate = self;
    [networkManager.gkSession setDataReceiveHandler:self withContext:nil];
    networkManager.gkSession.available = YES;
}


- (IBAction)connectAsTunes:(id)sender
{
    self.controllerType = kControllerTunes;
    self.networkStatus = kNetworkConnecting;
    
    NetworkManager *networkManager = [NetworkManager sharedNetworkManager];
    networkManager.gkSession = [[GKSession alloc] initWithSessionID:FaceGuitarGKSessionID displayName:TunesGKSessionID sessionMode:GKSessionModeClient];
    networkManager.gkSession.delegate = self;
    [networkManager.gkSession setDataReceiveHandler:self withContext:nil];
    networkManager.gkSession.available = YES;
}


#pragma mark - GKSessionDelegate

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIViewController *viewController = self.controllerType == kControllerTap ? [[TapViewController alloc] init] : [[TunesViewController alloc] init];
    [appDelegate.transitionController transitionToViewController:viewController withOptions:UIViewAnimationOptionTransitionFlipFromBottom];
}

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateAvailable:
            NSLog(@"didChangeState: peer %@ available", [session displayNameForPeer:peerID]);
            
            if (session.sessionMode == GKSessionModeClient)
                [session connectToPeer:peerID withTimeout:5];
            break;
            
        case GKPeerStateConnected:
        {
            self.networkStatus = kNetworkConnected;
            
            NetworkManager *networkManager = [NetworkManager sharedNetworkManager];
            NSString *peerIDName = [session displayNameForPeer:peerID];
            if (! networkManager.serverPeerID && [peerIDName isEqualToString:HostGKSessionID])
                networkManager.serverPeerID = peerID;
        }
			NSLog(@"didChangeState: peer %@ connected", [session displayNameForPeer:peerID]);
            break;
            
        case GKPeerStateDisconnected:
			NSLog(@"didChangeState: peer %@ disconnected", [session displayNameForPeer:peerID]);
            break;
            
        case GKPeerStateUnavailable:
			NSLog(@"didChangeState: peer %@ unavailable", [session displayNameForPeer:peerID]);
            break;
            
        case GKPeerStateConnecting:
			NSLog(@"didChangeState: peer %@ connecting", [session displayNameForPeer:peerID]);
            break;
            
        default:
            break;
    }
}

- (void)session:(GKSession *)session didReceiveConnectionRequestFromPeer:(NSString *)peerID
{
	NSLog(@"didReceiveConnectionRequestFromPeer: %@", [session displayNameForPeer:peerID]);
}

- (void)session:(GKSession *)session connectionWithPeerFailed:(NSString *)peerID withError:(NSError *)error
{
    NSLog(@"connectionWithPeerFailed: peer: %@, error: %@", [session displayNameForPeer:peerID], error);    
}

- (void)session:(GKSession *)session didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: error: %@", error);
}

@end
