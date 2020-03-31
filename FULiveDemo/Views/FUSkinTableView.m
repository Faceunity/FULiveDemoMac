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
#import "FUSkinStyle4RowView.h"
#import "FUAppDataCenter.h"
@interface FUSkinTableView()<NSTableViewDataSource,NSTableViewDelegate>
@end

@implementation FUSkinTableView

static NSString * indentify1 = @"SkinStyle1RowView";
static NSString * indentify2 = @"SkinStyle2RowView";
static NSString * indentify3 = @"SkinStyle4RowView";

-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
//        NSNib *itemOneNib = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle1RowView" bundle:nil];
//        [self registerNib:itemOneNib forIdentifier:indentify1];
//        NSNib *itemOneNib2 = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle2RowView" bundle:nil];
//        [self registerNib:itemOneNib2 forIdentifier:indentify2];
//
//        NSNib *itemOneNib3 = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle4RowView" bundle:nil];
//        [self registerNib:itemOneNib3 forIdentifier:indentify3];
        
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
    
    if (row == 0) {
//        FUSkinStyle2RowView *view = [tableView makeViewWithIdentifier:indentify2 owner:self];
        FUSkinStyle2RowView *view = nil;
        NSNib *xib = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle2RowView" bundle:nil];
        NSArray *viewsArray = [[NSArray alloc] init];
        [xib instantiateWithOwner:nil topLevelObjects:&viewsArray];
        for (int i = 0; i < viewsArray.count; i++) {
            if ([viewsArray[i] isKindOfClass:[FUSkinStyle2RowView class]]) {
                view = (FUSkinStyle2RowView *)viewsArray[i];
                break;
               }
        }
        view.model = [FUAppDataCenter shareManager].skinModelArray[row];
        return view;
    }else if (row == 1){
        FUSkinStyle4RowView *view = nil;
        NSNib *xib = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle4RowView" bundle:nil];
        NSArray *viewsArray = [[NSArray alloc] init];
        [xib instantiateWithOwner:nil topLevelObjects:&viewsArray];
        for (int i = 0; i < viewsArray.count; i++) {
            if ([viewsArray[i] isKindOfClass:[FUSkinStyle4RowView class]]) {
                view = (FUSkinStyle4RowView *)viewsArray[i];
                break;
               }
        }
//        FUSkinStyle4RowView *view = [tableView makeViewWithIdentifier:indentify3 owner:self];
        view.model = [FUAppDataCenter shareManager].skinModelArray[row];
        return view;
    }else{
        FUSkinStyle1RowView *view = nil;
        NSNib *xib = [[NSNib alloc] initWithNibNamed:@"FUSkinStyle1RowView" bundle:nil];
        NSArray *viewsArray = [[NSArray alloc] init];
        [xib instantiateWithOwner:nil topLevelObjects:&viewsArray];
        for (int i = 0; i < viewsArray.count; i++) {
            if ([viewsArray[i] isKindOfClass:[FUSkinStyle1RowView class]]) {
                view = (FUSkinStyle1RowView *)viewsArray[i];
                break;
               }
        }
//        FUSkinStyle1RowView *view = [tableView makeViewWithIdentifier:indentify1 owner:self];
        view.model = [FUAppDataCenter shareManager].skinModelArray[row];
        return view;
    }
 
}


- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 92;
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
