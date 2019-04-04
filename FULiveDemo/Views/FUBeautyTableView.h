//
//  FUBeautyTableView.h
//  FULive
//
//  Created by 孙慕 on 2018/8/1.
//  Copyright © 2018年 faceunity. All rights reserved.
//
//  -----------     美颜设置列表视图    ----------

#import <Cocoa/Cocoa.h>
#import "FUAppDataCenter.h"

@interface FUBeautyTableView : NSTableView
@property(strong)NSArray <FUBeautyModel *> *dataArray;
@end
