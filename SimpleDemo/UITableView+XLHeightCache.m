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

- (void)cacheLayout:(XLLayout *)layout forKey:(NSString *)key;
- (XLLayout *)layoutForKey:(NSString *)key;
- (void)removeLayoutForKey:(NSString *)key;
- (void)removeAllLayoutCache;

@end

@implementation XLCellHeightCache

- (void)cacheLayout:(XLLayout *)layout forKey:(NSString *)key {
    if (layout == nil) return;
    [self.cellHeightCache setObject:layout forKey:key];
}

- (XLLayout *)layoutForKey:(NSString *)key {
    XLLayout *layout = [self.cellHeightCache objectForKey:key];
    return layout;
}

- (void)removeLayoutForKey:(NSString *)key {
    [self.cellHeightCache removeObjectForKey:key];
}

- (void)removeAllLayoutCache {
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


+ (void)load {
    SEL reloadDataMethod = @selector(reloadData);
    SEL myReloadDataMethod = @selector(myReloadData);
    
    Method originalMethod = class_getInstanceMethod(self, reloadDataMethod);
    Method swizzledMethod = class_getInstanceMethod(self, myReloadDataMethod);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)myReloadData {
    [self myReloadData];
    [self precacheIfNeeded];
}

static const char heightCacheKey;

// tableView all indexPath to be cache
- (NSArray *)allIndexPathsToBePrecached {
    
    NSMutableArray *allIndexPaths = @[].mutableCopy;
    
    for (NSInteger section = 0; section < [self numberOfSections]; section ++) {
        for (NSInteger row = 0; row < [self numberOfRowsInSection:section]; row ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            if (![self cellOfLayoutForKey:[self cacheKeyWithIndexPath:indexPath]]) {
                [allIndexPaths addObject:indexPath];
            } 
        }
    }
    return allIndexPaths.copy;
}

- (void)precacheIfNeeded {
    if (![self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return;
    }
    [self addRunloopObserver];
}

- (void)addRunloopObserver {
    
    NSMutableArray *muIndexPathsToBePrecached = self.allIndexPathsToBePrecached.mutableCopy;
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverRef defaultModeObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
        
        if (muIndexPathsToBePrecached.count == 0) {
            CFRunLoopRemoveObserver(runloop, observer, kCFRunLoopDefaultMode);
            CFRelease(observer);
            return;
        }
        
        NSIndexPath *indexPath = muIndexPathsToBePrecached.firstObject;
        [muIndexPathsToBePrecached removeObject:indexPath];
        
        [self performSelector:@selector(precacheIndexPathIfNeeded:)
                     onThread:[NSThread mainThread]
                   withObject:indexPath
                waitUntilDone:NO
                        modes:@[NSDefaultRunLoopMode]];
    });
    
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopDefaultMode);
}

//calculatec pre cache cell height
- (void)precacheIndexPathIfNeeded:(NSIndexPath *)indexPath {
    
    XLLayout *layout = self.precacheIndexArray[indexPath.row];
    [layout layoutCalculate];
    
    //缓存高度
    [self cacheCellLayout:layout forKey:[self cacheKeyWithIndexPath:indexPath]];
}

#pragma mark - privite method

- (NSString *)cacheKeyWithIndexPath:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%@%ld", self.identify, [indexPath hash]];
}

#pragma public method

- (void)removeLayoutCacheOfCellForKey:(NSString *)key {
    [self.cellHeightCache removeLayoutForKey:key];
}

- (void)removeAllLayoutCacheOfCell {
    [self.cellHeightCache removeAllLayoutCache];
}

- (void)cacheCellLayout:(XLLayout *)layout forKey:(NSString *)key {
    [self.cellHeightCache cacheLayout:layout forKey:key];
}

- (XLLayout *)cellOfLayoutForKey:(NSString *)key {
    return [self.cellHeightCache layoutForKey:key];
}

#pragma mark - getter setter

- (XLCellHeightCache *)cellHeightCache {
    XLCellHeightCache *cache = objc_getAssociatedObject(self, &heightCacheKey);
    
    if (cache == nil) {
        
        cache = [[XLCellHeightCache alloc]init];
        objc_setAssociatedObject(self, &heightCacheKey, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

static const char nameKey;

- (NSMutableArray *)precacheIndexArray {
    return objc_getAssociatedObject(self, &nameKey);
}

- (void)setPrecacheIndexArray:(NSMutableArray *)precacheIndexArray {
    objc_setAssociatedObject(self, &nameKey, precacheIndexArray, OBJC_ASSOCIATION_RETAIN);
}

static const char identifyKey;

- (NSString *)identify {
    return objc_getAssociatedObject(self, &identifyKey);
}

- (void)setIdentify:(NSString *)identify {
    objc_setAssociatedObject(self, &identifyKey, identify, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
