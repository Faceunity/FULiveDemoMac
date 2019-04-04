//
//  FUSkinTableView.m
//  FULive
//
//  Created by 孙慕 on 2018/7/31.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUSkinTableView.h"
#import "FUSkinStyle1RowView.h"
#import "FUSkinStyle2RowView.h"
#import "FUSkinStyle3RowView.h"
#import "FUAppDataCenter.h"
@interface FUSkinTableView()<NSTableViewDataSource,NSTableViewDelegate>
@end

@implementation FUSkinTableView

static NSString * indentify1 = @"SkinStyle1RowView";
static NSString * indentify2 = @"SkinStyle2RowView";

-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        NSNib *itemOneNib = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle1RowView" bundle:nil];
        [self registerNib:itemOneNib forIdentifier:indentify1];
        NSNib *itemOneNib2 = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle2RowView" bundle:nil];
        [self registerNib:itemOneNib2 forIdentifier:indentify2];
        
        self.rowSizeStyle = NSTableViewRowSizeStyleCustom;
        self.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
        self.delegate = self;
        self.dataSource = self;
        
        
    }
    return self;
}


-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [FUAppDataCenter shareManager].skinModelArray.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    if (row == 0 || row == 1) {
        FUSkinStyle2RowView *view = [tableView makeViewWithIdentifier:indentify2 owner:self];
        view.model = [FUAppDataCenter shareManager].skinModelArray[row];
        return view;
    }else{
        FUSkinStyle1RowView *view = [tableView makeViewWithIdentifier:indentify1 owner:self];
        view.model = [FUAppDataCenter shareManager].skinModelArray[row];
        return view;
    }
 
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 84;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
