//
//  XLItem.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLItem.h"
#import "XLLayout.h"
#import <UIKit/UIKit.h>

@implementation XLItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        self.attrStatus = [[NSMutableAttributedString alloc] initWithString:self.status];
        [self.attrStatus addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR range:NSMakeRange(0, self.attrStatus.length)];
        [self.attrStatus addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, self.attrStatus.length)];

    }
    return self;
}

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
