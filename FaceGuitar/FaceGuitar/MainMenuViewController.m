//
//  MainMenuViewController.m
//  FaceGuitar
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "MainMenuViewController.h"
#import "NetworkManager.h"
#import "Controllers.h"

typedef enum { kNetworkDisconnected, kNetworkConnecting, kNetworkConnected } NetworkStatus;

static NSString * const HostGKSessionID = @"FaceGuitar";
static NSString * const TapGKSessionID = @"Tap";
static NSString * const TunesGKSessionID = @"Tunes";
static NSString * const FaceGuitarGKSessionID = @"FaceGuitar";

@interface MainMenuViewController () <GKSessionDelegate>

@property (nonatomic, assign) NetworkStatus networkStatus;

@end

@implementation MainMenuViewController

@synthesize hostGameBtn = _hostGameBtn;
@synthesize connectIndicatorView = _connectIndicatorView;
@synthesize connectMessageLabel = _connectMessageLabel;
@synthesize connectTapMessageLabel = _connectTapMessageLabel;
@synthesize connectTunesMessageLabel = _connectTunesMessageLabel;
@synthesize networkStatus = _networkStatus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.networkStatus = kNetworkDisconnected;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.connectIndicatorView.hidden = YES;
    self.connectMessageLabel.hidden = YES;
    self.connectTapMessageLabel.hidden = YES;
    self.connectTunesMessageLabel.hidden = YES;
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

- (void)setNetworkStatus:(NetworkStatus)networkStatus
{
    _networkStatus = networkStatus;
    
    switch (self.networkStatus) {
        case kNetworkDisconnected:
            break;
            
        case kNetworkConnecting:
            self.hostGameBtn.enabled = NO;
            self.connectIndicatorView.hidden = NO;
            self.connectMessageLabel.hidden = NO;
            self.connectTapMessageLabel.hidden = NO;
            self.connectTunesMessageLabel.hidden = NO;
            
            [self.connectIndicatorView startAnimating];
            self.connectMessageLabel.text = @"Waiting for devices";
            self.connectTapMessageLabel.text = @"Waiting for tap controller";
            self.connectTunesMessageLabel.text = @"Waiting for tune controller";
            break;
            
        case kNetworkConnected:
            self.connectMessageLabel.text = @"All controllers connected";
            self.connectIndicatorView.hidden = YES;
            break;
            
        default:
            break;
    }
}


#pragma mark - IBActions

- (IBAction)hostGame:(id)sender
{
    self.networkStatus = kNetworkConnecting;
    
    NetworkManager *networkManager = [NetworkManager sharedNetworkManager];
    networkManager.gkSession = [[GKSession alloc] initWithSessionID:FaceGuitarGKSessionID displayName:HostGKSessionID sessionMode:GKSessionModeServer];
    networkManager.gkSession.delegate = self;
    [networkManager.gkSession setDataReceiveHandler:[Controllers sharedControllers] withContext:nil];
    networkManager.gkSession.available = YES;
}


#pragma mark - GKSessionDelegate

- (void)session:(GKSession *)session peer:(NSString *)peerID didChangeState:(GKPeerConnectionState)state
{
    switch (state) {
        case GKPeerStateAvailable:
            NSLog(@"didChangeState: peer %@ available", [session displayNameForPeer:peerID]);
            
            if (session.sessionMode == GKSessionModeClient)
                [session connectToPeer:peerID withTimeout:5];
            break;
            
        case GKPeerStateConnected:
			NSLog(@"didChangeState: peer %@ connected", [session displayNameForPeer:peerID]);
        {
            NetworkManager *networkManager = [NetworkManager sharedNetworkManager];
            NSString *peerIDName = [session displayNameForPeer:peerID];
            if (! networkManager.tapControllerPeerID && [peerIDName isEqualToString:TapGKSessionID])
            {
                self.connectTapMessageLabel.text = @"Tap Controller connected";
                networkManager.tapControllerPeerID = peerID;   
            }
            else if (! networkManager.tunesControllerPeerID && [peerIDName isEqualToString:TunesGKSessionID])
            {
                self.connectTunesMessageLabel.text = @"Tunes Controller connected";
                networkManager.tunesControllerPeerID = peerID;
            }
            
            if (networkManager.tapControllerPeerID && networkManager.tunesControllerPeerID)
            {
                self.networkStatus = kNetworkConnected;
                NSUInteger i = 0;
                
                [networkManager sendDataToControllers:[NSData dataWithBytes:&i length:sizeof(i)] dataMode:GKSendDataReliable];
            }
        }
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
    
    NetworkManager *networkManager = [NetworkManager sharedNetworkManager];
    NSString *peerIDName = [session displayNameForPeer:peerID];
    
    if ((! networkManager.tapControllerPeerID && [peerIDName isEqualToString:TapGKSessionID]) ||
        (! networkManager.tunesControllerPeerID && [peerIDName isEqualToString:TunesGKSessionID]))
        [session acceptConnectionFromPeer:peerID error:nil];
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
