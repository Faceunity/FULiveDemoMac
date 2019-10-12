//
//  FUComboBox.m
//  FULive
//
//  Created by 孙慕 on 2018/8/3.
//  Copyright © 2018年 faceunity. All rights reserved.
//

#import "FUComboBox.h"
#import "FUComBoxTableRowView.h"
@implementation FUComboBox

#pragma mark - Public methods

-(void)setArrowColor:(NSColor *)arrowColor{
    _arrowColor = arrowColor;
    [self setNeedsDisplay:YES];
}

-(void)setTileColor:(NSColor *)tileColor{
    _tileColor = tileColor;
    [self setNeedsDisplay:YES];
}

-(void)setBorderColor:(NSColor *)borderColor{
    _borderColor = borderColor;
    [self setNeedsDisplay:YES];
}

#pragma mark - Private methods

-(void)fu_initializeComboBox{
    [self setFocusRingType:NSFocusRingTypeNone];
    [self setEditable:NO];
    [self setSelectable:NO];
    _arrowColor = [NSColor whiteColor];
    _tileColor =  FUColor_HEX(0x09DA4BE);
    _borderColor = FUColor_HEX(0x9DA4BE);
    _disableColor = FUColor_HEX(0xb4b5bd);
  }

#pragma mark - Override methods

-(instancetype)init{
    self = [super init];
    if(self){
        [self fu_initializeComboBox];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if(self){
        [self fu_initializeComboBox];
    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
     [self fu_initializeComboBox];
    m_isPopUpOpen = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willPopUp:)
                                                 name:NSComboBoxWillPopUpNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willDismiss:)
                                                 name:NSComboBoxWillDismissNotification
                                               object:self];
}

- (void)drawRect:(NSRect)dirtyRect {

//    [self getPopTableView];
//    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.indexOfSelectedItem] byExtendingSelection:false];
//    NSLog(@"-------%ld----%@",self.indexOfSelectedItem,self.tableView);
    NSRect cellFrame = dirtyRect;
    cellFrame.size.width = NSWidth([self bounds]);
    cellFrame.origin.y = NSMaxY([self bounds]) - 26;
    cellFrame.size.height = 24;
    cellFrame.origin.x = 0;
    cellFrame = NSInsetRect(cellFrame, 0.5, 0.5);
    [[NSColor whiteColor] set];
    NSRectFill(cellFrame);
    
    //Draw Border
    NSBezierPath *pathBorder = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:2.0 yRadius:2.0];
    [pathBorder setLineWidth:1.0];
    if(self.enabled){
        [_borderColor set];
    }else{
        [_disableColor set];
    }
    [pathBorder stroke];
    
    //Draw Tile
    NSRect bounds = NSMakeRect(cellFrame.origin.x + cellFrame.size.width - cellFrame.size.height, cellFrame.origin.y, cellFrame.size.height, cellFrame.size.height);
    NSBezierPath *pathBk = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(bounds, 0.5, 0.5) xRadius:0.0 yRadius:0.0];
    if(self.enabled){
        [_tileColor set];
    }else{
        [_disableColor set];
    }
    [pathBk fill];
    
    //Draw Arrow
    NSBezierPath *pathArrow = [NSBezierPath bezierPath];
    NSPoint pt1 = NSMakePoint(NSMidX(bounds) - 4, NSMidY(bounds) - 2);
    NSPoint pt2 = NSMakePoint(NSMidX(bounds) , NSMidY(bounds) + 3);
    NSPoint pt3 = NSMakePoint(NSMidX(bounds) + 4, NSMidY(bounds) - 2);
    [pathArrow moveToPoint:pt1];
    [pathArrow lineToPoint:pt2];
    [pathArrow lineToPoint:pt3];
    [pathArrow setLineWidth:1.5];
    
    [_arrowColor set];
    [pathArrow fill];
    
    //Draw String
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString: self.stringValue];
    [attrString beginEditing];
    
    if(self.enabled){
        [attrString addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, [attrString length])];
    }else{
        [attrString addAttribute:NSForegroundColorAttributeName value:_disableColor range:NSMakeRange(0, [attrString length])];
    }
    [attrString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [attrString length])];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:self.alignment];
    
    if (nil != paragraphStyle) {
        [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,[attrString length])];
        [attrString addAttribute:NSForegroundColorAttributeName value:_tileColor range:NSMakeRange(0,[attrString length])];
    }
    
    [attrString endEditing];
    NSRect rctString = cellFrame;
    rctString.origin.x += 5;
    rctString.origin.y += 2;
    rctString.size.width -= (NSHeight(cellFrame) + 5);
    [attrString drawInRect:rctString];
}


- (void)willPopUp:(NSNotification *)notification {
    m_isPopUpOpen = YES;
    
}

- (void)willDismiss:(NSNotification *)notification {
    m_isPopUpOpen = NO;
}

- (void)getPopTableView{
    if (_tableView) {
        return;
    }
    NSWindow *popUpWindow = [self comboBoxPopUpWindow];
    
    for (NSView* subView1 in ((NSView*)popUpWindow.contentView).subviews) {
        if (subView1.class == [NSClipView class]) {
            for (NSView* subView2 in subView1.subviews) {
                if ([subView2.class isSubclassOfClass:[NSTableView class]]) {
                    _tableView = (NSTableView*)subView2;
                    _tableView.dataSource = self;
                    _tableView.delegate = self;
                    [_tableView reloadData];
               //     [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:self.indexOfSelectedItem] byExtendingSelection:false];
                    break;
                }
            }
            
            break;
        }
    }
}

- (NSWindow *)comboBoxPopUpWindow {
    NSWindow *child = nil;
    for (child in [[self window] childWindows]) {
        if ([[child className] isEqualToString:@"NSComboBoxWindow"]) {
            break;
        }
    }    
    return child;
}


#pragma  mark ----  NSTableViewDataSource方法  -----

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.objectValues.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    
    NSString *rowData = [NSString stringWithFormat:@"%@",self.objectValues[row]];
    return rowData;
    
}

#pragma  mark ----  NSTableViewdelegate方法  -----
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSTextField * view = [tableView makeViewWithIdentifier:@"cellId" owner:self];
    if (view==nil) {
        view = [[NSTextField alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        [view setWantsLayer:YES];
        view.layer.backgroundColor = [NSColor clearColor].CGColor;
        view.drawsBackground = NO;
        view.identifier = @"cellId";
        view.bordered = NO;
    }
    view.stringValue = @"11111";
    return view;
    
}

- (NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row
{
    FUComBoxTableRowView *rowView = [[FUComBoxTableRowView alloc] init];
    return rowView;
}

-(void)selectItemWithObjectValue:(id)object{
    [super selectItemWithObjectValue:object];
    [_tableView reloadData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
