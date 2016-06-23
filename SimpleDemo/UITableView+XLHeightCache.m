//
//  UITableView+XLHeightCache.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/23.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "UITableView+XLHeightCache.h"
#import "XLLayout.h"
#import <objc/runtime.h>

@interface XLCellHeightCache ()

@property (nonatomic, strong) NSCache *cellHeightCache;

- (void)cacheHeight:(CGFloat)height forKey:(NSString *)key;
- (CGFloat)heightForKey:(NSString *)key;
- (void)removeHeightForKey:(NSString *)key;
- (void)removeAllHeightCache;

@end

@implementation XLCellHeightCache

- (void)cacheHeight:(CGFloat)height forKey:(NSString *)key {
    if (height <= 0) return;
    [self.cellHeightCache setObject:@(height) forKey:key];
}

- (CGFloat)heightForKey:(NSString *)key {
    NSNumber *height = [self.cellHeightCache objectForKey:key];
    return [height floatValue];
}

- (void)removeHeightForKey:(NSString *)key {
    [self.cellHeightCache removeObjectForKey:key];
}

- (void)removeAllHeightCache {
    [self.cellHeightCache removeAllObjects];
}

#pragma mark - lazy loading

- (NSCache *)cellHeightCache {
    if (!_cellHeightCache) {
        _cellHeightCache = [[NSCache alloc] init];
    }
    return _cellHeightCache;
}

@end

/**
 ==========================================================
 
 ==========================================================
 */

@implementation UITableView (XLHeightCache)

static const char heightCacheKey;

- (XLCellHeightCache *)cellHeightCache {
    XLCellHeightCache *cache = objc_getAssociatedObject(self, &heightCacheKey);
    
    if (cache == nil) {
        
        cache = [[XLCellHeightCache alloc]init];
        objc_setAssociatedObject(self, &heightCacheKey, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

- (void)removeHeightCacheOfCellForKey:(NSString *)key {
    [self.cellHeightCache removeHeightForKey:key];
}

- (void)removeAllHeightCacheOfCell {
    [self.cellHeightCache removeAllHeightCache];
}

- (void)cacheCellHeight:(CGFloat)height forKey:(NSString *)key {
    [self.cellHeightCache cacheHeight:height forKey:key];
}

- (CGFloat)heightOfCellForKey:(NSString *)key {
    return [self.cellHeightCache heightForKey:key];
}

static const char nameKey;

- (NSMutableArray *)precacheIndexArray {
    return objc_getAssociatedObject(self, &nameKey);
}

-(void)setPrecacheIndexArray:(NSMutableArray *)precacheIndexArray {
    objc_setAssociatedObject(self, &nameKey, precacheIndexArray, OBJC_ASSOCIATION_RETAIN);
}

@end




