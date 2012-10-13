//
//  AppDelegate.h
//  FaceGuitar-iPhone
//
//  Created by Ken on 10/12/12.
//  Copyright (c) 2012 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, readonly, nonatomic) TransitionController *transitionController;

@end
