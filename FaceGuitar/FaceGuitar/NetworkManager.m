//
//  NetworkManager.m
//  FaceGuitar
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import "NetworkManager.h"

static NetworkManager *_sharedNetworkManager;


@interface NetworkManager()

//@property (nonatomic, readwrite, strong) GKSession *gkSession;

@end


@implementation NetworkManager

@synthesize gkSession = _gkSession;
@synthesize tapControllerPeerID = _tapControllerPeerID;
@synthesize tunesControllerPeerID = _tunesControllerPeerID;

+ (NetworkManager *)sharedNetworkManager
{
    if (! _sharedNetworkManager)
        _sharedNetworkManager = [[NetworkManager alloc] init];
    return _sharedNetworkManager;
}


- (void)sendDataToControllers:(NSData *)data dataMode:(GKSendDataMode)dataMode
{
    [self.gkSession sendDataToAllPeers:data withDataMode:dataMode error:nil];
}

- (void)sendDataToTapController:(NSData *)data dataMode:(GKSendDataMode)dataMode
{
    
}

- (void)sendDataToTunesController:(NSData *)data dataMode:(GKSendDataMode)dataMode
{
    
}

@end
