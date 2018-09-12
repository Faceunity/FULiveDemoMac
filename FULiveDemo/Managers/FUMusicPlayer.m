//
//  FUMusicPlayer.m
//  FULive
//
//  Created by 刘洋 on 2017/10/13.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "FUMusicPlayer.h"


@interface FUMusicPlayer()
@property (retain) NSString *musicName;
@end

@implementation FUMusicPlayer


+ (FUMusicPlayer *)sharePlayer{
    static FUMusicPlayer *_sharePlayer;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharePlayer = [[FUMusicPlayer alloc] init];
        _sharePlayer.enable = YES;
    });
    
    return _sharePlayer;
}

- (void)setEnable:(BOOL)enable{
    if (_enable == enable) {
        return;
    }
    _enable = enable;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (enable) {
            [self rePlay];
        }else [self pause];
    });
}

- (void)playMusic:(NSString *)music{
    
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([selfWeak.audioPlayer isPlaying]) {
            [selfWeak.audioPlayer stop];
            selfWeak.audioPlayer = nil;
        }
        if (music) {
            NSString *path = [[NSBundle mainBundle] pathForResource:music ofType:nil];
            if (path) {
                NSURL *musicUrl = [NSURL fileURLWithPath:path];
                if (musicUrl) {
                    selfWeak.musicName = music;
                    
                    if (self.enable) {
                        selfWeak.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
                        selfWeak.audioPlayer.numberOfLoops = 100000;
                        
                        [selfWeak.audioPlayer play];
                    }
                }
            }
        }
    });
}

- (void)resume{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![selfWeak.audioPlayer isPlaying]) {
            [selfWeak.audioPlayer play];
        }
    });
}

- (void)rePlay{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        [self playMusic:selfWeak.musicName];
    });
}

- (void)pause{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([selfWeak.audioPlayer isPlaying]) {
            [selfWeak.audioPlayer pause];
        }
    });
}

- (void)stop{
    @WeakObj(self)
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([selfWeak.audioPlayer isPlaying]) {
            [selfWeak.audioPlayer stop];
        }
        
        selfWeak.audioPlayer = nil;
    });
}

- (float)playProgress {
    if (self.audioPlayer.duration > 0) {
        return self.audioPlayer.currentTime / (self.audioPlayer.duration);
    }else return 0.0;
}

- (NSTimeInterval)currentTime {
    return self.audioPlayer.currentTime;
}

@end
