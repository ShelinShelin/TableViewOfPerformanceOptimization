//
//  XLLayout.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLLayout.h"

#define margin 10.0f
#define iconSize 40.0f
#define textFont [UIFont systemFontOfSize:14.0f]
#define textColor [UIColor colorWithRed:0.72.f green:0.72.f blue:0.72.f alpha:1.0f]

@implementation XLLayout {
    CGRect _iconLayout;
    CGRect _userNameLayout;
    CGRect _statusLayout;
    CGRect _imageLayout;
}

- (void)setItem:(XLItem *)item {
    if (_item == item) return;
    _item = item;
    
    //iconView layout
    _iconLayout = CGRectMake(margin, margin, iconSize, iconSize);
    
    //userName layout
    _userNameLayout = CGRectMake(CGRectGetMaxX(_iconLayout) + margin, margin, 100, 100);
    
    //status layout
    
    //images layout
    
    //tool bar layot
    
}

- (CGFloat)cellHeight {
    return 100;
}

@end
