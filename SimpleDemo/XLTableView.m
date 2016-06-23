//
//  XLTableView.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLTableView.h"
#import <objc/runtime.h>

@implementation XLTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return self;
}

@end

@implementation XLTableView (XLAdd)

char nameKey;

- (NSMutableArray *)precacheIndexArray {
    return objc_getAssociatedObject(self, &nameKey);
}

-(void)setPrecacheIndexArray:(NSMutableArray *)precacheIndexArray {
    objc_setAssociatedObject(self, &nameKey, precacheIndexArray, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

