//
//  FUMakeupModle.m
//  FULiveDemo
//
//  Created by 孙慕 on 2019/4/1.
//  Copyright © 2019年 faceunity. All rights reserved.
//

#import "FUMakeupModle.h"

@implementation FUSingleMakeupModel
+ (FUSingleMakeupModel *)GetModelClassNamaTypeStr:(NSString *)namaTypeStr imgStr:(NSString *)Img namaValueStr:(NSString *)namaValueStr value:(float)value{
    FUSingleMakeupModel *modle = [[FUSingleMakeupModel alloc] init];
    modle.namaTypeStr = namaTypeStr;
    modle.namaImgStr = Img;
    modle.namaValueStr = namaValueStr;
    modle.value = value;
    
    return modle;
    
}
@end

@implementation FUMakeupModle

+ (NSDictionary *)objectClassInArray{
 
    return @{
             @"makeups" : @"FUSingleMakeupModel"
             };
}

+ (FUMakeupModle *)GetModelClassTitle:(NSString *)titleStr imgStr:(NSString *)Img filter:(NSString *)filter filterValue:(float)filterValue value:(float)value singleMakeups:(NSArray <FUSingleMakeupModel *>*)makeups{
    FUMakeupModle *model = [[FUMakeupModle alloc] init];
    model.titleStr = titleStr;
    model.imageStr = Img;
    model.selectedFilter = filter;
    model.selectedFilterLevel = filterValue;
    model.value = value;
    model.makeups = makeups;
    
    return  model;
}



@end
