//
//  FUMusicPlayer.h
//  FULive
//
//  Created by 刘洋 on 2017/10/13.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface FUMusicPlayer : NSObject

@property (nonatomic, assign) BOOL enable;
@property (retain) AVAudioPlayer *audioPlayer;

+ (FUMusicPlayer *)sharePlayer;

- (void)playMusic:(NSString *)music;

- (void)rePlay;

- (void)stop;

- (void)resume;

- (void)pause;

- (float)playProgress;

- (NSTimeInterval)currentTime;
@end
