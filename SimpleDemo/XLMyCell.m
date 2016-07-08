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
#import "XLDisplayLayer.h"

/**
 ==========================================================
 XLImageView
 ==========================================================
 */

@interface XLImageView () <XLDisplayLayerDelegate>


@end


@implementation XLImageView

#pragma mark - need update

- (void)layoutSubviews {
    [super layoutSubviews];
//    [self needUpdate];
}

+ (Class)layerClass {
    return [XLDisplayLayer class];
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
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
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGContextFillRect(context, self.frame);
    CGContextStrokeRect(context, self.frame);
    
    if (isCancelled) return;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:_imageName ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    if (isCancelled) return;
    CGContextRotateCTM(context, M_PI);
    CGContextScaleCTM(context, -1, 1);
    CGContextTranslateCTM(context, 0, -height);
    
    if (isCancelled) return;
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    
}

- (void)asyncDidDisplayLayer:(CALayer *)layer finished:(BOOL)finished {
    //finished
}


@end


/**
 ==========================================================
 XLMyCell
 ==========================================================
 */

@interface XLMyCell () <XLDisplayLayerDelegate>

@property (nonatomic, strong) XLLabel *statusLabel;
@property (nonatomic, strong) UIImageView *postBgView;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) NSMutableArray *imageViewArray;

@end

@implementation XLMyCell {
    UIImageView *_imageView;
}

#pragma mark - public mehted

+ (XLMyCell *)myCellWithTableView:(UITableView *)tableView {
    static NSString *identif = @"XLMyCell";
    XLMyCell *cell = [tableView dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[XLMyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - override

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
            XLImageView *imageView = [[XLImageView alloc] init];
            imageView.hidden = YES;
            imageView.backgroundColor = [UIColor lightGrayColor];
            [self.imageViewArray addObject:imageView];
            [self.contentView addSubview:imageView];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self needUpdate];
}

#pragma mark - setter

- (void)setLayout:(XLLayout *)layout {
    
    if (_layout == layout) return;
    _layout = layout;

    [self needUpdate];
    XLItem *item = layout.item;
    
    //post bg
    self.postBgView.frame = layout.postBgLayout;
    
    //avatar
    self.avatarView.frame = layout.iconLayout;
    [self.avatarView setImage:[UIImage imageNamed:item.iconName] forState:UIControlStateNormal];
    
    //status label
    self.statusLabel.frame = layout.statusLayout;
    self.statusLabel.attrText = item.attrStatus;
    
    //set images
    [self setImages];
}

#pragma mark - need update

+ (Class)layerClass {
    return [XLDisplayLayer class];
}

- (void)needUpdate {
    [[XLRunloopTaskManager sharedRunLoopTaskManager] addRunloopTask:^{
        [self.layer setNeedsDisplay];
    }];
}

#pragma mark - XLDisplayLayerDelegate

- (void)asyncDisplayWithContext:(CGContextRef)context size:(CGSize)size isCancelled:(BOOL)isCancelled {
    
    if (isCancelled) return;
    self.postBgView.layer.contents = nil;
    XLItem *item = _layout.item;
    
    [BG_COLOR set];
    CGContextStrokeRect(context, _layout.postBgLayout);
    CGContextFillRect(context, _layout.postBgLayout);
    
    if (isCancelled) return;
    //user name
    [item.userName drawInRect:_layout.userNameLayout withAttributes:@{NSFontAttributeName : TEXT_FONT}];
    
    //from
    [item.from drawInRect:_layout.fromLayout withAttributes:@{NSFontAttributeName : MID_TEXT_FONT, NSForegroundColorAttributeName : TEXT_COLOR}];
    
    //public time
    [item.publicTime drawInRect:_layout.publicTimeLayout withAttributes:@{NSFontAttributeName : MID_TEXT_FONT, NSForegroundColorAttributeName : TEXT_COLOR}];
    
    if (isCancelled) return;
    [[UIImage imageNamed:@"ImageResources.bundle/timeline_icon_retweet"] drawInRect:_layout.composeLayout blendMode:kCGBlendModeNormal alpha:1.0f];
    
    [[UIImage imageNamed:@"ImageResources.bundle/timeline_icon_comment"] drawInRect:_layout.commentLayout blendMode:kCGBlendModeNormal alpha:1.0f];
    
    [[UIImage imageNamed:@"ImageResources.bundle/timeline_icon_unlike"] drawInRect:_layout.likeLayout blendMode:kCGBlendModeNormal alpha:1.0f];

}

- (void)asyncDidDisplayLayer:(CALayer *)layer finished:(BOOL)finished {
    if (!finished) return;
    self.postBgView.layer.contents = layer.contents;
}

- (void)setImages {
    
    XLItem *item = _layout.item;
    [self clearDraw];
    
    for (int i = 0; i < item.images.count; i ++)  {
        XLImageView *imageView = self.imageViewArray[i];
        imageView.frame = CGRectMake(i % 3 * (IMAGE_SIZE + MARGIN) + MARGIN,  CGRectGetMaxY(_layout.statusLayout) + MARGIN + i / 3 * (IMAGE_SIZE + MARGIN), IMAGE_SIZE, IMAGE_SIZE);
        imageView.hidden = NO;
        imageView.imageName = item.images[i];
    }
}

- (void)clearDraw {
    for (XLImageView *imageView in self.imageViewArray) {
        imageView.hidden = YES;
        imageView.layer.contents = nil;
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


/**
 ==========================================================
 XLMyCell + XLAdd
 ==========================================================
 */

#pragma mark - XLMyCell + XLAdd

@implementation XLMyCell (XLAdd)

- (NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, @selector(indexPath));
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, @selector(indexPath), indexPath, OBJC_ASSOCIATION_RETAIN);
}

@end

