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

@interface XLMyCell () {
    BOOL _isDrawing;
}

@property (nonatomic, strong) XLLabel *statusLabel;
@property (nonatomic, strong) UIImageView *postBgView;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) NSMutableArray *imageArray;


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
        [self.avatarView addCornerMaskLayerWithRadius:ICON_SIZE / 2.0];
        [self.contentView addSubview:self.avatarView];
        
        self.statusLabel = [[XLLabel alloc] init];
        self.statusLabel.textBgColor = BG_COLOR;
        self.statusLabel.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + 10, 10, [UIScreen mainScreen].bounds.size.width - CGRectGetWidth(_imageView.frame) - 30, CGRectGetHeight(_imageView.frame));
        
        [self.contentView addSubview:self.statusLabel];
        
        self.imageArray = [NSMutableArray arrayWithCapacity:9];
        for (int i = 0; i < 3; i ++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.backgroundColor = [UIColor lightGrayColor];
            [self.imageArray addObject:imageView];
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
    
    //label
    self.statusLabel.frame = layout.statusLayout;
    NSMutableAttributedString *muAttrStr = [[NSMutableAttributedString alloc] initWithString:item.status];
    [muAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, muAttrStr.length)];
    [muAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, muAttrStr.length)];
    self.statusLabel.attrText = muAttrStr;
    
    [self drawImages];
    [self draw];
}

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
    
    for (int i = 0; i < 3; i ++)  {
        UIImageView *imageView = self.imageArray[i];
        imageView.frame = CGRectMake(i * (IMAGE_SIZE + MARGIN) + MARGIN, CGRectGetMaxY(_layout.statusLayout) + MARGIN, IMAGE_SIZE, IMAGE_SIZE);
        
        imageView.image = nil;
        
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
                    
                    imageView.image = temp;
                
                });
            });
    }
}


@end
