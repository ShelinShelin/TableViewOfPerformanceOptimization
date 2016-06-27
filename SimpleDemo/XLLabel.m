//
//  XLLabel.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLLabel.h"

@implementation XLLabel {
    UIImageView *_bgImageView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _textBgColor = [UIColor whiteColor];
        _bgImageView = [[UIImageView alloc] init];
        [self addSubview:_bgImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _bgImageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

- (void)setAttrText:(NSAttributedString *)attrText {
    if (attrText == nil || attrText.length<=0 || _attrText == attrText) {
        _bgImageView.image = nil;
        return;
    }
    _attrText = attrText;
    _bgImageView.image = nil;
    
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
            
            _bgImageView.image = image;
        });
    });
}



@end
