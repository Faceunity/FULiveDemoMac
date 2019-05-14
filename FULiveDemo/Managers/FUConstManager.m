//
//  FUConstManage.m
//  FULive
//
//  Created by 孙慕 on 2018/7/27.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUConstManager.h"

@implementation FUConstManager

+(CGColorRef )colorForBackground{
   
    return [NSColor colorWithRed:252 green:253 blue:255 alpha:1].CGColor;
}

/**
 #FCFDFF卡片模块色
 */
+(NSColor *)colorForBackground_card{
    return  FUColor_HEX(0xFCFDFF);
}

/**
 #17012D导航栏
 */
+(NSColor *)colorForBackground_nav{
    return  FUColor_HEX(0x17012D);
}

/**
 #7787e9选中（鼠标滑上色）
 */
+(NSColor *)colorForBackground_sel{
    return  FUColor_HEX(0x7787e9);
}

/**
 #32305c页签按钮色
 */
+(NSColor *)colorForBackground_page{
    return  FUColor_HEX(0x32305c);
}

/**
 #5c6071主要文本色
 */
+(NSColor *)colorForBackground_text0{
    return  FUColor_HEX(0x5c6071);
}

/**
 #2F3658次要文本色
 */
+(NSColor *)colorForBackground_text1{
    return FUColor_HEX(0x2F3658);
}

/**
 #C5C7D9页签文字色
 */
+(NSColor *)colorForBackground_text2{
   return FUColor_HEX(0xC5C7D9);
}

/**
 #959CB4按钮默认状态
 */
+(NSColor *)colorForBackground_btnNo{
   return FUColor_HEX(0x959CB4);
}

/**
 #E0E3EE拉条默认色
 */
+(NSColor *)colorForBackground_slideNo{
   return FUColor_HEX(0xE0E3EE);
}

/**
 #E9EAF2背景灰色
 */
+(NSColor *)colorForBackground_gray{
    return FUColor_HEX(0xE9EAF2);
}

/**
导航栏文字大小 16px
*/
+(NSFont *)font_nav{
   return [NSFont systemFontOfSize:16];
}

/**
 按钮文字大小 14px
 */
+(NSFont *)font_btn{
    return [NSFont systemFontOfSize:14];
}


/**
 提示文字大小 13px
 */
+(NSFont *)font_art{
    return [NSFont systemFontOfSize:13];
}


/**
 描述文字大小 12px
 */
+(NSFont *)font_verb{
    return [NSFont systemFontOfSize:12];
}

/**
 切换摄像机通知字符串
 */
+(NSString *)notiCenterForDeviceChange{
    return @"FUCameraSetControllerDeviceChange";
}

@end
