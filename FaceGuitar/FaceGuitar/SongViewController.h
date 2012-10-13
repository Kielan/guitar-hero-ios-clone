//
//  SongViewController.h
//  FaceGuitar
//
//  Created by Ken on 10/13/12.
//  Copyright (c) 2012 YangShun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"

@protocol SongViewControllerDelegate;

@interface SongViewController : UIViewController

@property (nonatomic, weak) id<SongViewControllerDelegate> delegate;
@property (nonatomic, readonly, strong) Song *song;
@property (nonatomic, weak) IBOutlet UILabel *songNameLabel;
@property (nonatomic, weak) IBOutlet UIImageView *songImageView;
@property (nonatomic, weak) IBOutlet UIButton *songButton;

- (id)initWithSong:(Song *)song;

@end

@protocol SongViewControllerDelegate <NSObject>

- (void)songControllerDidGetSelected:(SongViewController *)songController;

@end