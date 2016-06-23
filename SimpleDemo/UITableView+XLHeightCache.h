//
//  UITableView+XLHeightCache.h
//  SimpleDemo
//
//  Created by Shelin on 16/6/23.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XLCellHeightCache : NSObject

@end


@interface UITableView (XLHeightCache)

- (void)removeHeightCacheOfCellForKey:(NSString *)key;
- (void)removeAllHeightCacheOfCell;

- (void)cacheCellHeight:(CGFloat)height forKey:(NSString *)key;
- (CGFloat)heightOfCellForKey:(NSString *)key;


@property (nonatomic, strong) NSMutableArray *precacheIndexArray;

@end
