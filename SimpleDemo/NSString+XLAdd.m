//
//  NSString+XLAdd.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/23.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "NSString+XLAdd.h"

@implementation NSString (XLAdd)

- (CGSize)sizeWithMaxWidth:(CGFloat)maxWidth font:(UIFont *)font {
    
    CGSize textNeedSize = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    
    return textNeedSize;
}

@end
