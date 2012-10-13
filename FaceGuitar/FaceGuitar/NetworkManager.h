//
//  NetworkManager.h
//  FaceGuitar
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface NetworkManager : NSObject

//@property (nonatomic, readonly, strong) GKSession *gkSession;
@property (nonatomic, strong) GKSession *gkSession;
@property (nonatomic, assign) NSString *tapControllerPeerID;
@property (nonatomic, assign) NSString *tunesControllerPeerID;

+ (NetworkManager *)sharedNetworkManager;

- (void)sendDataToTapController:(NSData *)data dataMode:(GKSendDataMode)dataMode;
- (void)sendDataToTunesController:(NSData *)data dataMode:(GKSendDataMode)dataMode;
- (void)sendDataToControllers:(NSData *)data dataMode:(GKSendDataMode)dataMode;

@end
