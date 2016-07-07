//
//  XLLabel.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLLabel.h"
#import "XLDisplayLayer.h"
#import "XLRunloopTaskManager.h"

@interface XLLabel () <XLDisplayLayerDelegate>

@end

@implementation XLLabel

- (instancetype)init {
    self = [super init];
    if (self) {
        _textBgColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - need update

- (void)layoutSubviews {
    [super layoutSubviews];
    [self needUpdate];
}

+ (Class)layerClass {
    return [XLDisplayLayer class];
}

- (void)setAttrText:(NSAttributedString *)attrText {
    if (attrText == nil || attrText.length<=0 || _attrText == attrText) {
        self.layer.contents = nil;
        return;
    }
    _attrText = attrText;
    [self needUpdate];
}

- (void)needUpdate {
    [[XLRunloopTaskManager sharedRunLoopTaskManager] addRunloopTask:^{
        [self.layer setNeedsDisplay];
    }];
}

#pragma mark - XLDisplayLayerDelegate

- (void)asyncDisplayWithContext:(CGContextRef)context size:(CGSize)size isCancelled:(BOOL)isCancelled {
    if (isCancelled) return;
    
    [_textBgColor set];
    CGContextStrokeRect(context, self.bounds);
    CGContextFillRect(context, self.bounds);
    
    if (isCancelled) return;
    [_attrText drawInRect:self.bounds];
}

- (void)asyncDidDisplayLayer:(CALayer *)layer finished:(BOOL)finished {
    
    //finished
}

@end
