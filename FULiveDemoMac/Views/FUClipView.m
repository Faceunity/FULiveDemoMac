//
//  FUClipView.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/12.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUClipView.h"

@interface FUClipView ()
@property (weak) IBOutlet NSCollectionView *collectionView;
@end

@implementation FUClipView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    if (!NSEqualSizes(self.collectionView.frame.size, self.bounds.size)) {
        self.collectionView.frame = self.bounds;
    }
}

@end
