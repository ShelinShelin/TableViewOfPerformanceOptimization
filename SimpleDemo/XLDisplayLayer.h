//
//  XLDisplayLayer.h
//  DisplayLayer
//
//  Created by Shelin on 16/7/6.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@protocol XLDisplayLayerDelegate <NSObject>

@required
- (void)asyncDisplayWithContext:(CGContextRef)context size:(CGSize)size isCancelled:(BOOL)isCancelled;

@optional
- (void)asyncDidDisplayLayer:(CALayer *)layer finished:(BOOL)finished;

@end

@interface XLDisplayLayer : CALayer

@end
