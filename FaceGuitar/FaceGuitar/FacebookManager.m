//
//  FacebookManager.m
//  FaceGuitar
//
//  Created by YangShun on 12/10/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "FacebookManager.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Friend.h"
#define MAX_FRIENDS 50

@interface FacebookManager(){
    NSMutableArray *friendsArray;
    UIImage *placeholderImage;
}
@end
@implementation FacebookManager
@synthesize session;
@synthesize friendsArray;

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
    [self handleDidBecomeActive];
}
-(void)handleDidBecomeActive{
    [FBSession.activeSession handleDidBecomeActive];
    if (session.isOpen){
        NSString *urlStr = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends?fields=id,name,picture&access_token=%@",
                            session.accessToken];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSData* data = [NSData dataWithContentsOfURL:url];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if([dict valueForKey:@"Error"]){
            NSLog(@"error");
        }else{
            NSArray* friendsResult = [dict valueForKey:@"data"];
            if([friendsResult count]>0){
                int random = arc4random()%[friendsResult count];
                friendsArray = [NSMutableArray array];
                for(int i=0;i<[friendsResult count]&&[friendsArray count]<MAX_FRIENDS;i++){
                    int j=(i+random)%[friendsResult count];
                    NSDictionary *friendDict = [friendsResult objectAtIndex:j];
                    NSDictionary *friendImage = [(NSDictionary*)[friendDict objectForKey:@"picture"] objectForKey:@"data"];
                    if((BOOL) [friendImage objectForKey:@"is_silhouette"])
                        NSLog(@"");
                    else NSLog(@"bye");
                    NSString *fName = [friendDict valueForKey:@"name"];
                    int fId = [(NSString*)[friendDict valueForKey:@"id"] intValue];
                    UIImageView *fImgView = [[UIImageView alloc] init];
                    [fImgView setImageWithURL:[NSURL URLWithString:[friendImage valueForKey:@"url"]] placeholderImage:placeholderImage];
                    Friend *friend = [[Friend alloc] initWithName:fName fbId:fId imageView:fImgView];
                    [friendsArray addObject:friend];
                    
                }
            }
        }
    }else{
        friendsArray = nil;
    }
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
        placeholderImage = [UIImage imageNamed:@"placeholder.gif"];
        
    }
    
    return self;
}


@end
