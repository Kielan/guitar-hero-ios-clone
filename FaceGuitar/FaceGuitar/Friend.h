//
//  Friend.h
//  FaceGuitar
//
//  Created by John Goh on 10/13/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Friend : NSObject{

}
-(Friend *)initWithName:(NSString*)name fbId:(int)fbId imageView:(UIImageView*)imgView;
-(NSString *)name;
-(int) fbId;
-(UIImageView *)imgView;
@end
