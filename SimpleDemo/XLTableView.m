//
//  XLTableView.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLTableView.h"
#import "XLLayout.h"
#import <objc/runtime.h>

@implementation XLTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addRunloopObserver];
    }
    return self;
}

- (void)addRunloopObserver {
    
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
        
            if (self.precacheIndexArray.count == 0) {
                
                CFRunLoopRemoveObserver(runloop, observer, kCFRunLoopDefaultMode);
                CFRelease(observer); // 注意释放，否则会造成内存泄露
                return;
            }
        
        XLLayout *layout = self.precacheIndexArray.firstObject;
        [self.precacheIndexArray removeObject:layout];
        
        [self performSelector:@selector(precacheIndexPathIfNeeded:)
                     onThread:[NSThread mainThread]
                   withObject:layout
                waitUntilDone:NO
                        modes:@[NSDefaultRunLoopMode]];
    });
    
    CFRunLoopAddObserver(runloop, observer, kCFRunLoopDefaultMode);
}

//pre cache cell height
- (void)precacheIndexPathIfNeeded:(XLLayout *)layout {
    [layout layoutCalculate];
    NSLog(@"--- %f", layout.cellHeight);
    
    
}

@end

@implementation XLTableView (XLAdd)

char nameKey;

- (NSMutableArray *)precacheIndexArray {
    return objc_getAssociatedObject(self, &nameKey);
}

-(void)setPrecacheIndexArray:(NSMutableArray *)precacheIndexArray {
    objc_setAssociatedObject(self, &nameKey, precacheIndexArray, OBJC_ASSOCIATION_RETAIN);
}

@end

