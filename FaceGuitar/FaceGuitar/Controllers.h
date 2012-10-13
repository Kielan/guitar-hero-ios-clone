//
//  Controllers.h
//  FaceGuitar
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

typedef enum { kButtonReleased, kButtonJustReleased, kButtonPressed, kButtonJustPressed } ControllerButtonState;


@interface TunesController : NSObject

@property (nonatomic, assign) ControllerButtonState aButtonState, bButtonState, xButtonState, yButtonState;

@end


@interface TapController : NSObject

@property (nonatomic, assign) ControllerButtonState tapState;

@end


@interface Controllers : NSObject <GKSessionDelegate>

@property (nonatomic, readonly, strong) TunesController *tunesController;
@property (nonatomic, readonly, strong) TapController *tapController;

+ (Controllers *)sharedControllers;

@end
