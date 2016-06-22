//
//  XLLayout.h
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class XLItem;

@interface XLLayout : NSObject

@property (nonatomic, assign, readonly) CGFloat cellHeight;;
@property (nonatomic, strong) XLItem *item;

@end
