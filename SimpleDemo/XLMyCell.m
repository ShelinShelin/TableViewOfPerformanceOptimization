//
//  XLMyCell.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLMyCell.h"

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
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image =[UIImage imageNamed:@"bg_image.jpg"];
        
        self.label = [[UILabel alloc] init];
        self.label.font = [UIFont systemFontOfSize:10];
        self.label.numberOfLines = 0;

        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_label];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(10, 10, 80, 80);
    self.label.frame = CGRectMake(CGRectGetMaxX(_imageView.frame) + 10, 10, [UIScreen mainScreen].bounds.size.width - CGRectGetWidth(_imageView.frame) - 30, CGRectGetHeight(_imageView.frame));
}



@end
