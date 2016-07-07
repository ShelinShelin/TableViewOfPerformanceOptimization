//
//  XLRunloopTaskManager.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/25.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLRunloopTaskManager.h"

@interface XLRunloopTaskManager ()

@property (nonatomic, strong) NSMutableArray *runloopTaskArray;

@end

@implementation XLRunloopTaskManager

#pragma mark - public method

+ (instancetype)sharedRunLoopTaskManager {
    static XLRunloopTaskManager *manager;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[XLRunloopTaskManager alloc] init];
        [self registerRunLoopDefaultModeObserver:manager];
    });
    return manager;
}

- (void)addRunloopTask:(XLRunloopTask)runloopTask {
    if (!runloopTask) return;
    @synchronized (self) {
        [self.runloopTaskArray addObject:runloopTask];
    }
}

- (void)removeAllRunloopTask {
    [self.runloopTaskArray removeAllObjects];
}

#pragma mark - privite method

+ (void)registerRunLoopDefaultModeObserver:(XLRunloopTaskManager *)manager {
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    
    CFRunLoopObserverRef defaultModeObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting | kCFRunLoopExit, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        if (!manager.runloopTaskArray.count) return;
    
        [self performSelector:@selector(defaultModeRunLoopCallBack:)
                     onThread:[NSThread mainThread]
                   withObject:manager
                waitUntilDone:NO
                        modes:@[NSRunLoopCommonModes]];

    });
    
    CFRunLoopAddObserver(runLoop, defaultModeObserver, kCFRunLoopCommonModes);
    CFRelease(defaultModeObserver);
}

/**
 *  runloop call back
 */
+ (void)defaultModeRunLoopCallBack:(XLRunloopTaskManager *)manager {
    
    XLRunloopTask runloopTask = manager.runloopTaskArray.firstObject;
    if (runloopTask) {
        runloopTask();
    }
    @synchronized (self) {
        [manager.runloopTaskArray removeObjectAtIndex:0];
    }
}

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        _runloopTaskArray = @[].mutableCopy;
    }
    return self;
}

@end
