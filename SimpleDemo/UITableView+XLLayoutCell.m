//
//  UITableView+XLLayoutCell.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/23.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "UITableView+XLLayoutCell.h"
#import "XLLayout.h"

@implementation UITableView (XLLayoutCell)

- (XLLayout *)layoutCellWithKey:(NSString *)key indexPath:(NSIndexPath *)indexPath {
    if (key.length == 0) return 0;
    
    if ([self layoutCellForKey:key].cellHeight) {
        return [self layoutCellForKey:key];
    }
    
    XLLayout *layout = self.precacheLayoutArray[indexPath.row];
    [layout layoutCalculate];
    [self cacheCellLayout:layout forKey:[self cacheKeyWithIndexPath:indexPath]];
    
    return layout;
}

@end
