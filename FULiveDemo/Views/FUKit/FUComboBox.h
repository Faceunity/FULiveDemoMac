//
//  FUComboBox.h
//  FULive
//
//  Created by 孙慕 on 2018/8/3.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FUComboBox : NSComboBox<NSTableViewDelegate,NSTableViewDataSource,NSComboBoxCellDataSource>{
            BOOL m_isPopUpOpen;
}
/* 三角形颜色 */
@property   (nonatomic,strong)      NSColor         *arrowColor;
/* 标题颜色 */
@property   (nonatomic,strong)      NSColor         *tileColor;
/* 边框颜色 */
@property   (nonatomic,strong)      NSColor         *borderColor;
@property   (nonatomic,strong)      NSColor         *disableColor;

@property (retain) NSTableView *tableView;

@end
