//
//  FUPropSubItem.h
//  FULive
//
//  Created by 孙慕 on 2018/8/3.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FUPropItemModel.h"

typedef void(^FUPropSubItemDidClick)(BOOL isSel);
@interface FUPropSubItem : NSCollectionViewItem
/* 数据 */
@property (retain,nonatomic) FUPropSubItemModel *subModel;
/* 再次点击取消选中，回调 */
@property (copy) FUPropSubItemDidClick didClick;

@end
