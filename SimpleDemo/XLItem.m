//
//  XLItem.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLItem.h"

@implementation XLItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)itemWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
