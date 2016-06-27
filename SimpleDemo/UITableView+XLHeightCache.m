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

/**
 ==========================================================
 XLCellHeightCache: Used to cache layout objects
 ==========================================================
 */

@interface XLCellLayoutCache ()

@property (nonatomic, strong) NSCache *cellLayoutCache;

- (void)cacheLayout:(XLLayout *)layout forKey:(NSString *)key;
- (XLLayout *)layoutForKey:(NSString *)key;
- (void)removeLayoutForKey:(NSString *)key;
- (void)removeAllLayoutCache;

@end

@implementation XLCellLayoutCache

- (void)cacheLayout:(XLLayout *)layout forKey:(NSString *)key {
    if (layout == nil) return;
    [self.cellLayoutCache setObject:layout forKey:key];
}

- (XLLayout *)layoutForKey:(NSString *)key {
    XLLayout *layout = [self.cellLayoutCache objectForKey:key];
    return layout;
}

- (void)removeLayoutForKey:(NSString *)key {
    [self.cellLayoutCache removeObjectForKey:key];
}

- (void)removeAllLayoutCache {
    [self.cellLayoutCache removeAllObjects];
}

#pragma mark - lazy loading

- (NSCache *)cellLayoutCache {
    if (!_cellLayoutCache) {
        _cellLayoutCache = [[NSCache alloc] init];
    }
    return _cellLayoutCache;
}

@end

/**
 ==========================================================
 UITableView + XLHeightCache
 ==========================================================
 */

@implementation UITableView (XLHeightCache)

/**
 *  exchange of reloadDataMethod and myReloadDataMethod
 */
//+ (void)load {
//    SEL reloadDataMethod = @selector(reloadData);
//    SEL myReloadDataMethod = @selector(myReloadData);
//    
//    Method originalMethod = class_getInstanceMethod(self, reloadDataMethod);
//    Method swizzledMethod = class_getInstanceMethod(self, myReloadDataMethod);
//    method_exchangeImplementations(originalMethod, swizzledMethod);
//}
//
//- (void)myReloadData {
//    [self myReloadData];
//    //register runloop observer]
//    [self registerRunloopObserver];
//}

/**
 *  tableView all indexPath to be cache
 */
- (NSArray *)allIndexPathsToBePrecached {

    NSMutableArray *allIndexPaths = @[].mutableCopy;

    for (NSInteger section = 0; section < [self numberOfSections]; section ++) {
        for (NSInteger row = 0; row < [self numberOfRowsInSection:section]; row ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];

            //When the layout cache is does not exist
            if (![self layoutCellForKey:[self cacheKey:indexPath]].cellHeight) {
                [allIndexPaths addObject:indexPath];
            } 
        }
    }
    return allIndexPaths.copy;
}

/**
 *  add runloop observer, calculate the layout in runloop spare time
 */
//- (void)registerRunloopObserver {
//    if (![self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) return;
//    
//    NSMutableArray *indexPathsToBePrecachedArray = self.allIndexPathsToBePrecached.mutableCopy;
//    CFRunLoopRef runloop = CFRunLoopGetCurrent();
//    CFRunLoopObserverRef defaultModeObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
//        
//        if (indexPathsToBePrecachedArray.count == 0) {
//            CFRunLoopRemoveObserver(runloop, observer, kCFRunLoopDefaultMode);
//            CFRelease(observer);
//            return;
//        }
//        
//        NSIndexPath *indexPath = indexPathsToBePrecachedArray.firstObject;
//        [indexPathsToBePrecachedArray removeObject:indexPath];
//        
//        [self performSelector:@selector(precacheIndexPathIfNeeded:)
//                     onThread:[NSThread mainThread]
//                   withObject:indexPath
//                waitUntilDone:NO
//                        modes:@[NSDefaultRunLoopMode]];
//    });
//    
//    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopDefaultMode);
//}

/**
 *  calculatec pre cache cell height
 */
- (void)precacheIndexPathIfNeeded:(NSIndexPath *)indexPath {
    
    XLLayout *layout = self.precacheLayoutArray[indexPath.row];
    [layout layoutCalculate];
    [self cacheCellLayout:layout forKey:[self cacheKey:indexPath]];
}

#pragma mark - privite method

- (NSString *)cacheKey:(NSIndexPath *)indexPath {
    return [NSString stringWithFormat:@"%@%ld", self.identify, [indexPath hash]];
}

#pragma public method

- (void)removeLayoutCacheOfCellForKey:(NSString *)key {
    [self.celllayoutCache removeLayoutForKey:key];
}

- (void)removeAllLayoutCacheOfCell {
    [self.celllayoutCache removeAllLayoutCache];
}

- (void)cacheCellLayout:(XLLayout *)layout forKey:(NSString *)key {
    [self.celllayoutCache cacheLayout:layout forKey:key];
}

- (XLLayout *)layoutCellForKey:(NSString *)key {
    return [self.celllayoutCache layoutForKey:key];
}

#pragma mark - getter setter

static const char heightCacheKey;

- (XLCellLayoutCache *)celllayoutCache {
    XLCellLayoutCache *cache = objc_getAssociatedObject(self, &heightCacheKey);
    
    if (cache == nil) {
        
        cache = [[XLCellLayoutCache alloc] init];
        objc_setAssociatedObject(self, &heightCacheKey, cache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return cache;
}

- (NSMutableArray *)precacheLayoutArray {
    return objc_getAssociatedObject(self, @selector(precacheLayoutArray));
}

- (void)setPrecacheLayoutArray:(NSMutableArray *)precacheLayoutArray {
    objc_setAssociatedObject(self, @selector(precacheLayoutArray), precacheLayoutArray, OBJC_ASSOCIATION_RETAIN);
}

- (NSString *)identify {
    return objc_getAssociatedObject(self, @selector(identify));
}

- (void)setIdentify:(NSString *)identify {
    objc_setAssociatedObject(self, @selector(identify), identify, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
