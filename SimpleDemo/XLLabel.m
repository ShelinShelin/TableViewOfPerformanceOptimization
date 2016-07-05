//
//  XLLabel.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLLabel.h"

@implementation XLLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        _textBgColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setAttrText:(NSAttributedString *)attrText {
    if (attrText == nil || attrText.length<=0 || _attrText == attrText) {
        self.layer.contents = nil;
        return;
    }
    _attrText = attrText;
    self.layer.contents = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [_textBgColor set];
        
        CGContextStrokeRect(context, self.bounds);
        CGContextFillRect(context, self.bounds);
        
        [attrText drawInRect:self.bounds];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.contents = (__bridge id _Nullable)(image.CGImage);
        });
    });
}



@end
