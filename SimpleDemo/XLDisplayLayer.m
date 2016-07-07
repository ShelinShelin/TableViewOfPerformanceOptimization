//
//  XLDisplayLayer.m
//  DisplayLayer
//
//  Created by Shelin on 16/7/6.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLDisplayLayer.h"


@implementation XLDisplayLayer {
    BOOL _isCancelled;
}

- (instancetype)init {
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _isCancelled = NO;
        });
    }
    return self;
}

#pragma mark - display action

- (void)setNeedsDisplay {
    [self cancelAsyncDisplay];
    _isCancelled = NO;
    [super setNeedsDisplay];
}

- (void)display {
    super.contents = super.contents;
    [self asyncDisplay];
}

- (void)dealloc {
    [self cancelAsyncDisplay];
}

#pragma mark - cancel display

- (void)cancelAsyncDisplay {
    _isCancelled = YES;
}

#pragma mark - async display

- (void)asyncDisplay {
    
    BOOL opaque = self.opaque;
    CGSize size = self.bounds.size;
    CGFloat scale = self.contentsScale;
    CGColorRef backgroundColor = (opaque && self.backgroundColor) ? CGColorRetain(self.backgroundColor) : NULL;

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (_isCancelled) {
            CGColorRelease(backgroundColor);
            return;
        }
        UIGraphicsBeginImageContextWithOptions(size, opaque, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (opaque) {   //不透明
            CGContextSaveGState(context);
            
            if (!backgroundColor || CGColorGetAlpha(backgroundColor) < 1) {
                CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
                CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                CGContextFillPath(context);
            }
            if (backgroundColor) {
                CGContextSetFillColorWithColor(context, backgroundColor);
                CGContextAddRect(context, CGRectMake(0, 0, size.width * scale, size.height * scale));
                CGContextFillPath(context);
            }
            
            CGContextRestoreGState(context);
            CGColorRelease(backgroundColor);
        }
        [self _asyncDisplayWithContext:context size:size isCancelled:_isCancelled];
        
        if (_isCancelled) {
            UIGraphicsEndImageContext();
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _asyncDidDisplayLayer:self finished:NO];
                
            });
            return;
        }
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        if (_isCancelled) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _asyncDidDisplayLayer:self finished:NO];
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_isCancelled) {
                [self _asyncDidDisplayLayer:self finished:NO];
            } else {
                self.contents = (__bridge id)(image.CGImage);
                [self _asyncDidDisplayLayer:self finished:YES];
            }
        });
    });
}

- (void)_asyncDisplayWithContext:(CGContextRef)context
                            size:(CGSize)size
                     isCancelled:(BOOL)isCancelled {
    
    if ([self.delegate respondsToSelector:@selector(asyncDisplayWithContext:size:isCancelled:)]) {
        [self.delegate asyncDisplayWithContext:context
                                          size:size
                                   isCancelled:isCancelled];
    }
}

- (void)_asyncDidDisplayLayer:(CALayer *)layer
                     finished:(BOOL)finished {
    
    if ([self.delegate respondsToSelector:@selector(asyncDidDisplayLayer:finished:)]) {
        [self.delegate asyncDidDisplayLayer:self
                                   finished:finished];
    }
}

@end
