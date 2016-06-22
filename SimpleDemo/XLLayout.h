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

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define MARGIN 10.0f
#define ICON_SIZE 40.0f
#define TEXT_FONT [UIFont systemFontOfSize:14.0f]
#define TEXT_COLOR [UIColor colorWithRed:0.72f green:0.72f blue:0.72f alpha:1.0f]

@interface XLLayout : NSObject

@property (nonatomic, assign, readonly) CGFloat cellHeight;
@property (nonatomic, assign, readonly) CGRect iconLayout;
@property (nonatomic, assign, readonly) CGRect userNameLayout;
@property (nonatomic, assign, readonly) CGRect statusLayout;
@property (nonatomic, assign, readonly) CGRect imagesLayout;
@property (nonatomic, assign, readonly) CGRect toolBarLayout;

@property (nonatomic, strong) XLItem *item;

@end
