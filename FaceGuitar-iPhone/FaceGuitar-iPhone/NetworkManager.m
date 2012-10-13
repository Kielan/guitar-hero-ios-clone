//
//  NetworkManager.m
//  FaceGuitar-iPhone
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
@synthesize serverPeerID = _serverPeerID;

+ (NetworkManager *)sharedNetworkManager
{
    if (! _sharedNetworkManager)
        _sharedNetworkManager = [[NetworkManager alloc] init];
    return _sharedNetworkManager;
}

- (void)sendDataToServer:(NSData *)data dataMode:(GKSendDataMode)dataMode
{
    //[self.gkSession sendDataToAllPeers:data withDataMode:dataMode error:nil];
    [self.gkSession sendData:data toPeers:[NSArray arrayWithObject:self.serverPeerID] withDataMode:dataMode error:nil];
}

@end
