//
//  FUFiltersItemsController.m
//  FULiveDemoMac
//
//  Created by 刘洋 on 2018/3/10.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUFiltersItemsController.h"
#import "FUManager.h"
#import "FUHeaderView.h"
#import "FUFooterView.h"

@interface FUFiltersItemsController ()<NSCollectionViewDelegate,NSCollectionViewDataSource,NSCollectionViewDelegateFlowLayout>
@property (weak) IBOutlet NSSlider *filterValueSlider;
@property (weak) IBOutlet NSCollectionView *collectionView;
@property (weak) IBOutlet NSTextField *filterValueLabel;
@end

@implementation FUFiltersItemsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    self.view.wantsLayer = YES;
    
    self.collectionView.wantsLayer = YES;
    self.collectionView.layer.backgroundColor = [NSColor colorWithWhite:0.5 alpha:1.0].CGColor;
    [self.collectionView setNeedsDisplay:YES];
    
    NSCollectionViewFlowLayout *viewFlowLayout = self.collectionView.collectionViewLayout;
    viewFlowLayout.itemSize = NSMakeSize(63, 78);
    viewFlowLayout.sectionInset = NSEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    viewFlowLayout.minimumInteritemSpacing = 10.0;
    viewFlowLayout.minimumLineSpacing = 10.0;
    if (@available(macOS 10.12, *)) {
        viewFlowLayout.sectionHeadersPinToVisibleBounds = YES;
    } else {
        // Fallback on earlier versions
    }
    
    NSUInteger section = 0;
    NSUInteger item = 0;
    if ([[FUManager shareManager].filtersDataSource containsObject:[FUManager shareManager].selectedFilter]) {
        section = 0;
        item = [[FUManager shareManager].filtersDataSource indexOfObject:[FUManager shareManager].selectedFilter];
    }else if ([[FUManager shareManager].beautyFiltersDataSource containsObject:[FUManager shareManager].selectedFilter]){
        section = 1;
        item = [[FUManager shareManager].beautyFiltersDataSource indexOfObject:[FUManager shareManager].selectedFilter];
    }
    
    NSUInteger indexes[2] = {section,item};
    NSIndexPath *indexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:sizeof(indexes)/sizeof(NSUInteger)];
    [self.collectionView selectItemsAtIndexPaths:[NSSet setWithObject:indexPath] scrollPosition:NSCollectionViewScrollPositionNone];
    self.filterValueSlider.doubleValue = [FUManager shareManager].selectedFilterLevel;
    self.filterValueLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].selectedFilterLevel];
}

#pragma NSCollectionViewDelegate,NSCollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(NSCollectionView *)collectionView{
    return 2;
}

- (NSInteger)collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return [FUManager shareManager].filtersDataSource.count;
    }
    return [FUManager shareManager].beautyFiltersDataSource.count;
}

- (NSCollectionViewItem *)collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath{
    
    NSCollectionViewItem *item = [collectionView makeItemWithIdentifier:@"FUFilterItemsViewItem" forIndexPath:indexPath];
    
    NSString *imageName;
    
    if (indexPath.section == 0) {
        imageName = [FUManager shareManager].filtersDataSource[indexPath.item];
    }else{
        imageName = [FUManager shareManager].beautyFiltersDataSource[indexPath.item];
    }

    NSImage *image = [NSImage imageNamed:imageName];
    item.imageView.image = image;
    
    
    NSString *name = [FUManager shareManager].filtersCHName[imageName];
    if (name.length == 0) {
        name = imageName;
    }
    item.textField.stringValue = name;
    
    return item;
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths{
    NSIndexPath *indexPath = indexPaths.anyObject;

    NSString * selectedFilter;
    
    if (indexPath.section == 0) {
        selectedFilter = [FUManager shareManager].filtersDataSource[indexPath.item];
    }else{
        selectedFilter = [FUManager shareManager].beautyFiltersDataSource[indexPath.item];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [FUManager shareManager].selectedFilter = selectedFilter;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.filterValueSlider.doubleValue = [FUManager shareManager].selectedFilterLevel;
            self.filterValueLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].selectedFilterLevel];
        });
    });

}

- (NSView *)collectionView:(NSCollectionView *)collectionView viewForSupplementaryElementOfKind:(NSCollectionViewSupplementaryElementKind)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if (kind == NSCollectionElementKindSectionHeader) {
        FUHeaderView *headerView = [collectionView makeSupplementaryViewOfKind:NSCollectionElementKindSectionHeader withIdentifier:@"FUHeaderView" forIndexPath:indexPath];
        headerView.nameLabel.stringValue = indexPath.section == 0 ? @"普通滤镜":@"美颜滤镜";
        return headerView;
    }
    else if (kind == NSCollectionElementKindSectionFooter){
        FUFooterView *footerView = [collectionView makeSupplementaryViewOfKind:NSCollectionElementKindSectionFooter withIdentifier:@"FUFooterView" forIndexPath:indexPath];
        return footerView;
    }
    return nil;
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return NSMakeSize(collectionView.frame.size.width, 30);
}

- (NSSize)collectionView:(NSCollectionView *)collectionView layout:(NSCollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return NSMakeSize(collectionView.frame.size.width, 0.0);
}

- (IBAction)filterValueDidChanged:(NSSlider *)sender {
    [FUManager shareManager].filtersLevel[[FUManager shareManager].selectedFilter] = @(sender.doubleValue);
    self.filterValueLabel.stringValue = [NSString stringWithFormat:@"%.01f",[FUManager shareManager].selectedFilterLevel];
}
@end
