//
//  NSAttributedString+XLAdd.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "NSAttributedString+XLAdd.h"

@implementation NSAttributedString (XLAdd)

- (CGSize)boundingRectWithMaxWidh:(CGFloat)maxWidh {
    return [self boundingRectWithSize:CGSizeMake(maxWidh, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
}

@end
