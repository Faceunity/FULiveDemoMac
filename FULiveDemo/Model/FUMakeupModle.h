//
//  FUMakeupModle.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/4/1.
//  Copyright © 2019年 faceunity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface FUSingleMakeupModel : NSObject
/* 美妆图片 */
@property (copy) NSString* namaImgStr;
/* 美妆图片键值 */
@property (copy) NSString* namaTypeStr;
/* 美妆程度键值 */
@property (copy) NSString* namaValueStr;
/* 美妆程度值 */
@property (assign) float  value;

+ (FUSingleMakeupModel *)GetModelClassNamaTypeStr:(NSString *)namaTypeStr imgStr:(NSString *)Img namaValueStr:(NSString *)namaValueStr value:(float)value;

@end


@interface FUMakeupModle : NSObject
/* 图片 */
@property (retain) NSString *imageStr;
/* 标题 */
@property (retain) NSString *titleStr;
/* 选中的滤镜 */
@property (copy) NSString *selectedFilter;
/* 选中滤镜的 level*/
@property (assign) double selectedFilterLevel;
/* 程度值 */
@property (assign) float     value;

/* 组合妆对应所有子妆容 */
@property (nonatomic, strong) NSArray <FUSingleMakeupModel *>* makeups;

+ (FUMakeupModle *)GetModelClassTitle:(NSString *)titleStr imgStr:(NSString *)Img filter:(NSString *)filter filterValue:(float)filterValue value:(float)value singleMakeups:(NSArray <FUSingleMakeupModel *>*)makeups;

@end

NS_ASSUME_NONNULL_END
