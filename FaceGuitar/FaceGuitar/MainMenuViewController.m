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
#import "PlayViewController.h"
#import "AppDelegate.h"

typedef enum { kNetworkDisconnected, kNetworkConnecting, kNetworkConnected } NetworkStatus;

static NSString * const HostGKSessionID = @"FaceGuitar";
static NSString * const TapGKSessionID = @"Tap";
static NSString * const TunesGKSessionID = @"Tunes";
static NSString * const FaceGuitarGKSessionID = @"FaceGuitar";

@interface MainMenuViewController () <GKSessionDelegate> {

    IBOutlet UIImageView *chordIV;
    IBOutlet UIImageView *strumIV;
    IBOutlet UIButton *guitarGuy;
    IBOutlet UIImageView *logo;
    
}

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
    [self shiftButtonsDown];
    logo.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    self.connectIndicatorView.hidden = YES;
    self.connectMessageLabel.hidden = YES;
    self.connectTapMessageLabel.hidden = YES;
    self.connectTunesMessageLabel.hidden = YES;
    [UIView animateWithDuration:0.65
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         logo.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.35
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.hostGameBtn.center = CGPointMake(self.hostGameBtn.center.x, self.hostGameBtn.center.y - 500);
                                          }
                                          completion:^(BOOL finished){
                                          }];
                     }];
}

- (void)shiftButtonsDown {
    
    self.hostGameBtn.center = CGPointMake(self.hostGameBtn.center.x, self.hostGameBtn.center.y + 500);
    chordIV.center = CGPointMake(chordIV.center.x, chordIV.center.y + 500);
    strumIV.center = CGPointMake(strumIV.center.x, strumIV.center.y + 500);
    guitarGuy.center = CGPointMake(guitarGuy.center.x, guitarGuy.center.y + 500);
}

- (void)shiftButtonsUp {
    [UIView animateWithDuration:0.35
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         chordIV.center = CGPointMake(chordIV.center.x, chordIV.center.y - 500);
                         strumIV.center = CGPointMake(strumIV.center.x, strumIV.center.y - 500);
                         guitarGuy.center = CGPointMake(guitarGuy.center.x, guitarGuy.center.y - 500);
                     }
                     completion:^(BOOL finished){
                     }];
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
            self.hostGameBtn.hidden = YES;
            self.connectIndicatorView.hidden = NO;
            self.connectMessageLabel.hidden = NO;
            self.connectTapMessageLabel.hidden = NO;
            self.connectTunesMessageLabel.hidden = NO;
            
            [self.connectIndicatorView startAnimating];
//            self.connectMessageLabel.text = @"Waiting for devices";
//            self.connectTapMessageLabel.text = @"Waiting for tap controller";
//            self.connectTunesMessageLabel.text = @"Waiting for tune controller";
            break;
            
        case kNetworkConnected:
        {
            UIImage *guitarImage = [UIImage imageNamed:@"guitarguy-on@2x.png"];
            [guitarGuy setImage:guitarImage forState:UIControlStateNormal];
            self.connectMessageLabel.text = @"All controllers connected";
            self.connectIndicatorView.hidden = YES;
        }
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
    [self shiftButtonsUp];
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
                UIImage *strumOn = [UIImage imageNamed:@"button-strum-on@2x.png"];
                strumIV.image = strumOn;
//                self.connectTapMessageLabel.text = @"Tap Controller connected";
                networkManager.tapControllerPeerID = peerID;
            }
            else if (! networkManager.tunesControllerPeerID && [peerIDName isEqualToString:TunesGKSessionID])
            {
                UIImage *chordOn = [UIImage imageNamed:@"button-chord-on@2x.png"];
                chordIV.image = chordOn;
//                self.connectTunesMessageLabel.text = @"Tunes Controller connected";
                networkManager.tunesControllerPeerID = peerID;
            }
            
            if (networkManager.tapControllerPeerID && networkManager.tunesControllerPeerID)
            {
                self.networkStatus = kNetworkConnected;
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

- (IBAction)startGame:(id)sender {
    
    NSUInteger i = 0;
    NetworkManager *networkManager = [NetworkManager sharedNetworkManager];
    [networkManager sendDataToControllers:[NSData dataWithBytes:&i length:sizeof(i)] dataMode:GKSendDataReliable];
    
    PlayViewController  *playController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.transitionController transitionToViewController:playController withOptions:UIViewAnimationTransitionCurlUp];
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
