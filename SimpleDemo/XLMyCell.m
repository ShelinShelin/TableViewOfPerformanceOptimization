//
//  XLMyCell.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLMyCell.h"
#import "XLLabel.h"
#import "XLLayout.h"
#import "XLItem.h"
#import "UIView+XLAdd.h"
#import "XLRunloopTaskManager.h"
#import <objc/runtime.h>

@interface XLMyCell () {
    BOOL _isDrawing;
}

@property (nonatomic, strong) XLLabel *statusLabel;
@property (nonatomic, strong) UIImageView *postBgView;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@end

@implementation XLMyCell {
    UIImageView *_imageView;
}

+ (XLMyCell *)myCellWithTableView:(UITableView *)tableView {
    static NSString *_id = @"XL";
    XLMyCell *cell = [tableView dequeueReusableCellWithIdentifier:_id];
    if (!cell) {
        cell = [[XLMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_id];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.postBgView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.postBgView];
        
        self.avatarView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.avatarView addTarget:self action:@selector(avatarClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.avatarView addCornerMaskLayerWithRadius:ICON_SIZE / 2.0];
        [self.contentView addSubview:self.avatarView];
        
        self.statusLabel = [[XLLabel alloc] init];
        self.statusLabel.textBgColor = BG_COLOR;
        self.statusLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + 10, 10, [UIScreen mainScreen].bounds.size.width - CGRectGetWidth(_imageView.frame) - 30, CGRectGetHeight(_imageView.frame));
        
        [self.contentView addSubview:self.statusLabel];
        
        self.imageViewArray = [NSMutableArray arrayWithCapacity:9];
        for (int i = 0; i < 9; i ++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.hidden = YES;
            imageView.backgroundColor = [UIColor lightGrayColor];
            [self.imageViewArray addObject:imageView];
            [self.contentView addSubview:imageView];
        }
    }
    return self;
}

- (void)setLayout:(XLLayout *)layout {
    
    if (_layout == layout) return;
    _layout = layout;
    
    XLItem *item = layout.item;
    
    //post bg
    self.postBgView.frame = layout.postBgLayout;
    
    //avatar
    self.avatarView.frame = layout.iconLayout;
    [self.avatarView setImage:[UIImage imageNamed:item.iconName] forState:UIControlStateNormal];
    
    //status label
    self.statusLabel.frame = layout.statusLayout;
    NSMutableAttributedString *muAttrStr = [[NSMutableAttributedString alloc] initWithString:item.status];
    [muAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, muAttrStr.length)];
    [muAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, muAttrStr.length)];
    self.statusLabel.attrText = muAttrStr;
    
    [self drawImages];
    [self draw];
}

#pragma mark - draw image

- (void)draw {
    
    if (_isDrawing) return;
    
    self.postBgView.image = nil;
    
    XLItem *item = _layout.item;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _isDrawing = YES;
        
        UIGraphicsBeginImageContextWithOptions(_layout.postBgLayout.size, YES, 0);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [BG_COLOR set];
        CGContextStrokeRect(context, _layout.postBgLayout);
        CGContextFillRect(context, _layout.postBgLayout);
        
        //user name
        [item.userName drawInRect:_layout.userNameLayout withAttributes:@{NSFontAttributeName : TEXT_FONT}];
        
        //from
        [item.from drawInRect:_layout.fromLayout withAttributes:@{NSFontAttributeName : MID_TEXT_FONT, NSForegroundColorAttributeName : TEXT_COLOR}];
        
        //public time
        [item.publicTime drawInRect:_layout.publicTimeLayout withAttributes:@{NSFontAttributeName : MID_TEXT_FONT, NSForegroundColorAttributeName : TEXT_COLOR}];
        
        [[UIImage imageNamed:@"ImageResources.bundle/timeline_icon_retweet"] drawInRect:_layout.composeLayout blendMode:kCGBlendModeNormal alpha:1.0f];
        
        [[UIImage imageNamed:@"ImageResources.bundle/timeline_icon_comment"] drawInRect:_layout.commentLayout blendMode:kCGBlendModeNormal alpha:1.0f];
        
        [[UIImage imageNamed:@"ImageResources.bundle/timeline_icon_unlike"] drawInRect:_layout.likeLayout blendMode:kCGBlendModeNormal alpha:1.0f];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.postBgView.image = image;
            _isDrawing = NO;
        });
    });
}

- (void)drawImages {
    
    XLItem *item = _layout.item;
    
    [self clearDraw];
    
    for (int i = 0; i < item.images.count; i ++)  {
        UIImageView *imageView = self.imageViewArray[i];
        imageView.hidden = NO;
        imageView.frame = CGRectMake(i % 3 * (IMAGE_SIZE + MARGIN) + MARGIN,  CGRectGetMaxY(_layout.statusLayout) + MARGIN + i / 3 * (IMAGE_SIZE + MARGIN), IMAGE_SIZE, IMAGE_SIZE);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIGraphicsBeginImageContextWithOptions(imageView.frame.size, YES, 0);
                
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextFillRect(context, imageView.frame);
                CGContextStrokeRect(context, imageView.frame);
                
                NSString *filePath = [[NSBundle mainBundle] pathForResource:item.images[i] ofType:nil];
                UIImage *image = [UIImage imageWithContentsOfFile:filePath];
                
                CGContextRotateCTM(context, M_PI);
                CGContextScaleCTM(context, -1, 1);
                CGContextTranslateCTM(context, 0, -imageView.frame.size.height);
                CGContextDrawImage(context, CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height), image.CGImage);
                
                UIImage *temp = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[XLRunloopTaskManager sharedRunLoopTaskManager] addRunloopTask:^{
                        imageView.image = temp;
                    }];                
                });
            });
    }
}

- (void)clearDraw {
    for (UIImageView *imageView in self.imageViewArray) {
        imageView.hidden = YES;
        imageView.image = nil;
    }
}

#pragma mark - click action

- (void)avatarClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(cellDidClickAvatar:)]) {
        [self.delegate cellDidClickAvatar:self];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    if (CGRectContainsPoint(self.layout.commentLayout, point)) {
        if ([self.delegate respondsToSelector:@selector(cellDidClickComment:)]) {
            [self.delegate cellDidClickComment:self];
        }
        return;
    }
    if (CGRectContainsPoint(self.layout.composeLayout, point)) {
        if ([self.delegate respondsToSelector:@selector(cellDidClickCompose:)]) {
            [self.delegate cellDidClickCompose:self];
        }
        return;
    }
    if (CGRectContainsPoint(self.layout.likeLayout, point)) {
        if ([self.delegate respondsToSelector:@selector(cellDidClickLike:)]) {
            [self.delegate cellDidClickLike:self];
        }
        return;
    }
}

@end

#pragma mark - XLMyCell + XLAdd

@implementation XLMyCell (XLAdd)

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, @selector(indexPath));
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, @selector(indexPath), indexPath, OBJC_ASSOCIATION_RETAIN);
}

@end

