//
//  XLRunloopTaskManager.h
//  SimpleDemo
//
//  Created by Shelin on 16/6/25.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef BOOL (^XLRunloopTask)(void);

@interface XLRunloopTaskManager : NSObject

+ (instancetype)sharedRunLoopTaskManager;

- (void)addRunloopTask:(XLRunloopTask)runloopTask;

- (void)removeAllRunloopTask;

@end
