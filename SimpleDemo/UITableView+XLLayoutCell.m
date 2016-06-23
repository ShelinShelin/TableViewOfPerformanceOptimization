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

- (CGFloat)heightForLayoutCellWithKey:(NSString *)key {
    if (key.length == 0) return 0;
        
    CGFloat cellHeight = [self heightOfCellForKey:key];
    return cellHeight;
}

@end
