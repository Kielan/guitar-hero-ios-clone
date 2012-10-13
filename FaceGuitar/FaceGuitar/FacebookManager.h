//
//  FacebookManager.h
//  FaceGuitar
//
//  Created by YangShun on 12/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
@interface FacebookManager : NSObject
{
    FBSession *session;
}
@property FBSession *session;
@property (nonatomic, strong) NSMutableArray *friendsArray;

+ (FacebookManager*)sharedInstance;
- (BOOL)isOpen;
- (void)login;
- (void)logout;
- (void)handleDidBecomeActive;
@end
