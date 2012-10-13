//
//  Friend.m
//  FaceGuitar
//
//  Created by John Goh on 10/13/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import "Friend.h"
@interface Friend(){
    NSString *name;
    int fbId;
    UIImageView *imgView;
}
@end
@implementation Friend


-(Friend *)initWithName:(NSString*)_name fbId:(int)_fbId imageView:(UIImageView*)_imgView{
    self = [super init];
    if(self){
        name = _name;
        fbId = _fbId;
        imgView = _imgView;
    }
    return self;
}

-(NSString *)name{
    return name;
}
-(int) fbId{
    return fbId;
}
-(UIImageView *)imgView{
    return imgView;
}

@end
