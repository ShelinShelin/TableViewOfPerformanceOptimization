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

@interface XLMyCell ()

@property (nonatomic, strong) XLLabel *label;
@property (nonatomic, strong) UIImageView *postBgView;
@property (nonatomic, strong) UIButton *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;

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
        
        self.avatarView = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.avatarView addCornerMaskLayerWithRadius:ICON_SIZE / 2.0];
        [self.contentView addSubview:self.avatarView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:self.nameLabel];
        
        
        self.label = [[XLLabel alloc] init];
        self.label.textColor = [UIColor lightGrayColor];
        
        self.label.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + 10, 10, [UIScreen mainScreen].bounds.size.width - CGRectGetWidth(_imageView.frame) - 30, CGRectGetHeight(_imageView.frame));
        
        
        
        
        
//        _imageView = [[UIImageView alloc] init];
//        _imageView.frame = CGRectMake(10, 10, 80, 80);
//        _imageView.image =[UIImage imageNamed:@"bg_image.jpg"];
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setLayout:(XLLayout *)layout {
    
    if (_layout == layout) return;
    
    XLItem *item = layout.item;
    
    self.avatarView.frame = layout.iconLayout;
    [self.avatarView setImage:[UIImage imageNamed:item.iconName] forState:UIControlStateNormal];
    
    self.nameLabel.frame = layout.userNameLayout;
    self.nameLabel.text = item.userName;
    
    
    self.label.frame = layout.statusLayout;
    NSMutableAttributedString *muAttrStr = [[NSMutableAttributedString alloc] initWithString:item.status];
    [muAttrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, muAttrStr.length)];
    [muAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, muAttrStr.length)];
    self.label.attrText = muAttrStr;

    
}


@end
