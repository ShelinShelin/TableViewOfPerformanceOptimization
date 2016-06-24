//
//  UITableView+XLLayoutCell.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/23.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "UITableView+XLLayoutCell.h"
#import "UITableView+XLHeightCache.h"

@implementation UITableView (XLLayoutCell)

- (XLLayout *)layoutCellWithKey:(NSString *)key {
    if (key.length == 0) return 0;
    
    return [self cellOfLayoutForKey:key];
}

@end
