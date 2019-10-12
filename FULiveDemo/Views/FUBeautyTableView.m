//
//  FUBeautyTableView.m
//  FULive
//
//  Created by 孙慕 on 2018/8/1.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUBeautyTableView.h"
#import "FUSkinStyle1RowView.h"
#import "FUSkinStyle3RowView.h"


@interface FUBeautyTableView()<NSTableViewDataSource,NSTableViewDelegate>

@end

@implementation FUBeautyTableView

static NSString * indentify1 = @"SkinStyle1RowView";
static NSString * indentify2 = @"SkinStyle3RowView";

-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        NSNib *itemOneNib = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle1RowView" bundle:nil];
        [self registerNib:itemOneNib forIdentifier:indentify1];
        NSNib *itemOneNib2 = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle3RowView" bundle:nil];
        [self registerNib:itemOneNib2 forIdentifier:indentify2];
        
        self.rowSizeStyle = NSTableViewRowSizeStyleCustom;
        self.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
 
        self.delegate = self;
        self.dataSource = self;
        _dataArray = [FUAppDataCenter shareManager].beautyModelCustomArray;
        
    }
    return self;
}


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return _dataArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    if (row == 0) {
        FUSkinStyle3RowView *view = [tableView makeViewWithIdentifier:indentify2 owner:self];
        view.model = _dataArray[row];
        @WeakObj(self);
        view.didClickBlock = ^(int index) {
            if (index == 4) {
              selfWeak.dataArray = [FUAppDataCenter shareManager].beautyModelCustomArray;
            }else{
              selfWeak.dataArray = [FUAppDataCenter shareManager].beautyModeldefaultArray;
            }
            [self reloadData];
        };
        return view;
    }else{
        FUSkinStyle1RowView *view = [tableView makeViewWithIdentifier:indentify1 owner:self];
        view.model = _dataArray[row];
        return view;
    }
    
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 92;
}
@end
