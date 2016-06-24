//
//  UITableView+XLHeightCache.h
//  SimpleDemo
//
//  Created by Shelin on 16/6/23.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLLayout;

@interface XLCellLayoutCache : NSObject

@end

@interface UITableView (XLHeightCache)

- (void)removeLayoutCacheOfCellForKey:(NSString *)key;
- (void)removeAllLayoutCacheOfCell;
- (void)cacheCellLayout:(XLLayout *)layout forKey:(NSString *)key;
- (XLLayout *)cellOfLayoutForKey:(NSString *)key;

- (NSString *)cacheKeyWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  Use to store all the precache layout objects
 */
@property (nonatomic, strong) NSMutableArray *precacheLayoutArray;

/**
 *  identify for key
 */
@property (nonatomic, copy) NSString *identify;

@end
