//
//  FUConstManage.h
//  FULive
//
//  Created by 孙慕 on 2018/7/27.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
@interface FUConstManager : NSObject




/**
 #FCFDFF卡片模块色
 */
+(NSColor *)colorForBackground_card;

/**
 #17012D导航栏
 */
+(NSColor *)colorForBackground_nav;

/**
 #7787e9选中（鼠标滑上色）
 */
+(NSColor *)colorForBackground_sel;

/**
 #32305c页签按钮色
 */
+(NSColor *)colorForBackground_page;

/**
 #5c6071主要文本色
 */
+(NSColor *)colorForBackground_text0;

/**
 #2F3658次要文本色
 */
+(NSColor *)colorForBackground_text1;

/**
 #C5C7D9页签文字色
 */
+(NSColor *)colorForBackground_text2;

/**
 #959CB4按钮默认状态
 */
+(NSColor *)colorForBackground_btnNo;

/**
 #E0E3EE拉条默认色
 */
+(NSColor *)colorForBackground_slideNo;

/**
 #E9EAF2背景灰色
 */
+(NSColor *)colorForBackground_gray;


/**
 导航栏文字大小 16px
 */
+(NSFont *)font_nav;

/**
 按钮文字大小 14px
 */
+(NSFont *)font_btn;


/**
 提示文字大小 13px
 */
+(NSFont *)font_art;


/**
 描述文字大小 12px
 */
+(NSFont *)font_verb;


/**
 切换摄像机通知字符串
 */
+(NSString *)notiCenterForDeviceChange;

@end
