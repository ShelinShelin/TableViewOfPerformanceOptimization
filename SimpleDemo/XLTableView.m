//
//  XLTableView.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLTableView.h"
#import "XLLayout.h"
#import "UITableView+XLHeightCache.h"

@interface XLTableView ()

@property (nonatomic, strong) NSMutableArray *indexPathArray;

@end

@implementation XLTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

@end


