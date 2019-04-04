//
//  FUFilterViewItem.h
//  FULive
//
//  Created by 孙慕 on 2018/8/2.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FUFilterModel.h"
#import "FUMakeupModle.h"
@interface FUFilterViewItem : NSCollectionViewItem

@property (retain,nonatomic) FUFilterModel *model;

@property (retain,nonatomic) FUMakeupModle *makeupModel;

@end
