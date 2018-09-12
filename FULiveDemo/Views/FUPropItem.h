//
//  FUPropItem.h
//  FULive
//
//  Created by 孙慕 on 2018/8/2.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FUPropItemModel.h"


typedef void(^FUPropItemDidClick)(BOOL isSel);
@interface FUPropItem : NSCollectionViewItem
/* 数据 */
@property (retain,nonatomic) FUPropItemModel *model;
/* 再次点击取消选中，回调 */
@property (copy) FUPropItemDidClick didClick;

@end
