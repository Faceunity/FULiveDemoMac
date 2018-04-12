//
//  FUItemsController.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/9.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUItemsController.h"
#import "FUManager.h"
#import "FUFooterView.h"

@interface FUItemsController ()<NSCollectionViewDelegate,NSCollectionViewDataSource>

@property (weak) IBOutlet NSCollectionView *collectionView;

@end

@implementation FUItemsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.collectionView.wantsLayer = YES;
    self.collectionView.layer.backgroundColor = [NSColor colorWithWhite:0.5 alpha:1.0].CGColor;
    [self.collectionView setNeedsDisplay:YES];
    
    NSCollectionViewFlowLayout *viewFlowLayout = self.collectionView.collectionViewLayout;
    viewFlowLayout.itemSize = NSMakeSize(63, 63);
    viewFlowLayout.sectionInset = NSEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    viewFlowLayout.minimumInteritemSpacing = 10.0;
    viewFlowLayout.minimumLineSpacing = 10.0;
    if (@available(macOS 10.12, *)) {
        viewFlowLayout.sectionHeadersPinToVisibleBounds = YES;
    } else {
        // Fallback on earlier versions
    }
    
    
    NSUInteger indexes[2] = {0,[[FUManager shareManager].itemsDataSource indexOfObject:[FUManager shareManager].selectedItem]};
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:sizeof(indexes)/sizeof(NSUInteger)];
    [self.collectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
}

#pragma NSCollectionViewDelegate,NSCollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [FUManager shareManager].itemsDataSource.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath{
    NSCollectionViewItem *item = [collectionView makeItemWithIdentifier:@"FUItemsViewItem" forIndexPath:indexPath];
    
    NSString *imageName = [FUManager shareManager].itemsDataSource[indexPath.item];
    NSImage *image = [NSImage imageNamed:imageName];
    item.imageView.image = image;
    
    return item;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths{
    NSIndexPath *indexPath = indexPaths.anyObject;
    if (indexPath.item < [FUManager shareManager].itemsDataSource.count) {

        [[FUManager shareManager] loadItem:[FUManager shareManager].itemsDataSource[indexPath.item]];
    }
}

@end
