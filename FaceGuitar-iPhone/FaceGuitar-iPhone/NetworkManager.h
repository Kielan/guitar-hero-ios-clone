//
//  NetworkManager.h
//  FaceGuitar-iPhone
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface NetworkManager : NSObject

//@property (nonatomic, readonly, strong) GKSession *gkSession;
@property (nonatomic, strong) GKSession *gkSession;
@property (nonatomic, strong) NSString *serverPeerID;

+ (NetworkManager *)sharedNetworkManager;

- (void)sendDataToServer:(NSData *)data dataMode:(GKSendDataMode)dataMode;

@end
