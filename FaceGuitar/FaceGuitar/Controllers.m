//
//  Controllers.m
//  FaceGuitar
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "Controllers.h"

typedef enum { kButtonTuneA, kButtonTuneB, kButtonTuneX, kButtonTuneY, kButtonTap } ControllerButtonType;

typedef struct { ControllerButtonType buttonType; ControllerButtonState buttonState; } ControllerButtonAction;

//@interface ButtonAction : NSObject <NSCoding>
//
//@property (nonatomic, assign) ControllerButtonType buttonType;
//@property (nonatomic, assign) ControllerButtonState buttonState;
//
//@end
//
//
//@implementation ButtonAction
//
//@synthesize buttonType = _buttonType;
//@synthesize buttonState = _buttonState;
//
//- (id)initWithButtonType:(ControllerButtonType)buttonType buttonState:(ControllerButtonState)buttonState
//{
//    if (self = [super init])
//    {
//        self.buttonType = buttonType;
//        self.buttonState = buttonState;
//    }
//    return self;
//}
//
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init])
//    {
//        self.buttonType = (ControllerButtonType) [decoder decodeIntForKey:@"buttonType"];
//        self.buttonState = (ControllerButtonState) [decoder decodeIntForKey:@"buttonState"];
//    }
//    return self;
//}
//
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    [encoder encodeInt:self.buttonType forKey:@"buttonType"];
//    [encoder encodeInt:self.buttonState forKey:@"buttonState"];
//}
//
//@end


@implementation TunesController

@synthesize aButtonState = _aButtonState, bButtonState = _bButtonState, xButtonState = _xButtonState, yButtonState = _yButtonState;

@end


@implementation TapController

@synthesize tapState = _tapState;

@end


@interface Controllers ()

@property (nonatomic, readwrite, strong) TunesController *tunesController;
@property (nonatomic, readwrite, strong) TapController *tapController;

@end

@implementation Controllers

@synthesize tapController = _tapController;
@synthesize tunesController = _tunesController;

static Controllers *_sharedControllers;

+ (Controllers *)sharedControllers
{
    if (! _sharedControllers)
        _sharedControllers = [[Controllers alloc] init];
    return _sharedControllers;
}


- (id)init
{
    if (self = [super init])
    {
        self.tapController = [[TapController alloc] init];
        self.tunesController = [[TunesController alloc] init];
    }
    return self;
}


#pragma mark - GKSessionDelegate

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context
{
    ControllerButtonAction action;
    [data getBytes:&action length:sizeof(action)];
    
    NSString *buttonState = action.buttonState == kButtonJustPressed || action.buttonState == kButtonPressed ? @"Pressed" : @"Released";
    switch (action.buttonType) {
        case kButtonTuneA:
            self.tunesController.aButtonState = action.buttonState;
            NSLog(@"%@ %@", @"Tune A", buttonState);
            break;
            
        case kButtonTuneB:
            self.tunesController.bButtonState = action.buttonState;
            NSLog(@"%@ %@", @"Tune B", buttonState);
            break;
            
        case kButtonTuneX:
            self.tunesController.xButtonState = action.buttonState;
            NSLog(@"%@ %@", @"Tune X", buttonState);
            break;
            
        case kButtonTuneY:
            self.tunesController.yButtonState = action.buttonState;
            NSLog(@"%@ %@", @"Tune Y", buttonState);
            break;
            
        case kButtonTap:
            self.tapController.tapState = action.buttonState;
            NSLog(@"%@ %@", @"Tap", buttonState);
            break;
            
        default:
            break;
    }
}

@end
