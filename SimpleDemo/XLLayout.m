//
//  XLLayout.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLLayout.h"
#import "XLItem.h"
#import "NSAttributedString+XLAdd.h"

@implementation XLLayout

- (void)setItem:(XLItem *)item {
    if (_item == item) return;
    _item = item;
    
    //iconView layout
    _iconLayout = CGRectMake(MARGIN, MARGIN, ICON_SIZE, ICON_SIZE);
    
    //userName layout
    _userNameLayout = CGRectMake(CGRectGetMaxX(_iconLayout) + MARGIN, MARGIN, 100, ICON_SIZE);
    
    //status layout
    NSMutableAttributedString *muAttrStr = [[NSMutableAttributedString alloc] initWithString:item.status];
    [muAttrStr addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR range:NSMakeRange(0, muAttrStr.length)];
    [muAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, muAttrStr.length)];
    
    CGSize textSize = [muAttrStr boundingRectWithMaxWidh:(SCREEN_WIDTH - 2 * MARGIN)];
    _statusLayout = CGRectMake(MARGIN, CGRectGetMaxY(_iconLayout) + MARGIN, textSize.width, textSize.height);
    
    //images layout
    CGSize imagesSize;
    switch (item.images.count) {
        case 0:
            imagesSize = CGSizeMake(0, 0);
            break;
        case 1:
        case 2:
        case 3:
            imagesSize = CGSizeMake(SCREEN_WIDTH - 2 * MARGIN, 80);
            break;
        case 4:
        case 5:
        case 6:
            imagesSize = CGSizeMake(SCREEN_WIDTH - 2 * MARGIN, 80 * 2);
            break;
        case 7:
        case 8:
        case 9:
            imagesSize = CGSizeMake(SCREEN_WIDTH - 2 * MARGIN, 80 * 3);
            break;
        default:
            break;
    }
    _imagesLayout = CGRectMake(MARGIN, CGRectGetMaxY(_statusLayout) + MARGIN, imagesSize.width, imagesSize.height);
    
    //tool bar layot
    _toolBarLayout = CGRectMake(MARGIN, CGRectGetMaxY(_imagesLayout) + MARGIN, SCREEN_WIDTH - 2 * MARGIN, 44);
    
}

- (CGFloat)cellHeight {
    return CGRectGetMaxY(_toolBarLayout) + MARGIN;
}

@end
