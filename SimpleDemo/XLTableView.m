//
//  XLTableView.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLTableView.h"
#import "XLLayout.h"
#import "UITableView+XLHeightCache.h"

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
    CFRunLoopObserverRef defaultModeObserver = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity _) {
        
        if (self.precacheIndexArray.count == 0) {
            
            CFRunLoopRemoveObserver(runloop, observer, kCFRunLoopDefaultMode);
            CFRelease(observer);
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
    
    CFRunLoopAddObserver(runloop, defaultModeObserver, kCFRunLoopDefaultMode);
}

//pre cache cell height
- (void)precacheIndexPathIfNeeded:(XLLayout *)layout {
    [layout layoutCalculate];
    NSLog(@"--- %f", layout.cellHeight);
    
}

@end


