//
//  FUSkinStyle3RowView.h
//  FULive
//
//  Created by 孙慕 on 2018/7/31.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FUBeautyModel.h"
typedef void(^FUSkinStyle3RowViewItemDidClick)(int index);
@interface FUSkinStyle3RowView : NSTableRowView
/* 数据 */
@property (retain,nonatomic) FUBeautyModel *model;
/* 点击选中第几个回调 */
@property (copy) FUSkinStyle3RowViewItemDidClick didClickBlock;


@end
