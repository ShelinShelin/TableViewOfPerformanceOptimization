//
//  UITableView+XLLayoutCell.h
//  SimpleDemo
//
//  Created by Shelin on 16/6/23.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLLayout;

@interface UITableView (XLLayoutCell)

- (XLLayout *)layoutCellWithKey:(NSString *)key indexPath:(NSIndexPath *)indexPath;

@end
