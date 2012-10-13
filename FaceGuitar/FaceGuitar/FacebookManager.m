//
//  FacebookManager.m
//  FaceGuitar
//
//  Created by YangShun on 12/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "FacebookManager.h"
@interface FacebookManager(){

}
@end
@implementation FacebookManager
@synthesize session;
static FacebookManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (FacebookManager *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[FacebookManager alloc] init];
    });
    
    return sharedInstance;
}
- (BOOL)isOpen{
    return session.isOpen;
}
-(void)login{
    if(session.isOpen)return;
    if (session.state != FBSessionStateCreated) {
        // Create a new, logged out session.
        session = [[FBSession alloc] init];
    }
    
    // if the session isn't open, let's open it now and present the login UX to the user
    [session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {

    }];
}
-(void)logout{
    if(!session.isOpen)return;
    [session closeAndClearTokenInformation];
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    if (self) {
        session = [[FBSession alloc]init];
        NSLog(@"FBManager made");
    }
    
    return self;
}


@end
