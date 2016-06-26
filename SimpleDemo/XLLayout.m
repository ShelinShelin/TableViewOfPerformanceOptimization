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
#import "NSString+XLAdd.h"

@implementation XLLayout

static int i = 0;

- (void)layoutCalculate {
    
//    NSLog(@"layoutCalculate - %d", i++);
    //iconView layout
    
    _iconLayout = CGRectMake(MARGIN, MARGIN, ICON_SIZE, ICON_SIZE);
    
    //userName layout
    CGSize userNameSize = [_item.userName sizeWithMaxWidth:MAXFLOAT font:TEXT_FONT];
    _userNameLayout = CGRectMake(CGRectGetMaxX(_iconLayout) + MARGIN, MARGIN, userNameSize.width, userNameSize.height);
    
    //from layout
    CGSize fromSize = [_item.from sizeWithMaxWidth:MAXFLOAT font:MID_TEXT_FONT];
    _fromLayout = CGRectMake(_userNameLayout.origin.x, CGRectGetMaxY(_userNameLayout) + MARGIN / 2.0, fromSize.width, fromSize.height);
    
    //public time
    CGSize publicTimeSize = [_item.publicTime sizeWithMaxWidth:MAXFLOAT font:MID_TEXT_FONT];
    _publicTimeLayout = CGRectMake(CGRectGetMaxX(_fromLayout) + MARGIN, _fromLayout.origin.y, publicTimeSize.width, publicTimeSize.height);
    
    //status layout
    NSMutableAttributedString *muAttrStr = [[NSMutableAttributedString alloc] initWithString:_item.status];
    [muAttrStr addAttribute:NSForegroundColorAttributeName value:TEXT_COLOR range:NSMakeRange(0, muAttrStr.length)];
    [muAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, muAttrStr.length)];
    
    CGSize textSize = [muAttrStr boundingRectWithMaxWidh:(SCREEN_WIDTH - 2 * MARGIN)];
    _statusLayout = CGRectMake(MARGIN, CGRectGetMaxY(_iconLayout) + MARGIN, textSize.width, textSize.height);
    
    //images layout
    CGSize imagesSize;
    switch (_item.images.count) {
        case 0:
            imagesSize = CGSizeMake(0, 0);
            break;
        case 1:
        case 2:
        case 3:
            imagesSize = CGSizeMake(SCREEN_WIDTH - 2 * MARGIN, IMAGE_SIZE);
            break;
        case 4:
        case 5:
        case 6:
            imagesSize = CGSizeMake(SCREEN_WIDTH - 2 * MARGIN, IMAGE_SIZE * 2);
            break;
        case 7:
        case 8:
        case 9:
            imagesSize = CGSizeMake(SCREEN_WIDTH - 2 * MARGIN, IMAGE_SIZE * 3);
            break;
        default:
            break;
    }
    _imagesLayout = CGRectMake(MARGIN, CGRectGetMaxY(_statusLayout) + MARGIN, imagesSize.width, imagesSize.height);
    
    //tool bar layot
    _toolBarLayout = CGRectMake(MARGIN, CGRectGetMaxY(_imagesLayout) + MARGIN, SCREEN_WIDTH - 2 * MARGIN, 44);
    
    CGFloat spacing = (SCREEN_WIDTH - 3 * 30) / 4.0;
    
    _composeLayout = CGRectMake(spacing, _toolBarLayout.origin.y, 30, 30);
    
    _commentLayout = CGRectMake(spacing * 2 + 30, _toolBarLayout.origin.y, 30, 30);
    
    _likeLayout = CGRectMake(spacing * 3 + 60, _toolBarLayout.origin.y, 30, 30);
    
}

- (CGFloat)cellHeight {
    return CGRectGetMaxY(_toolBarLayout) + MARGIN;
}

- (CGRect)postBgLayout {
    return CGRectMake(0, 0, SCREEN_WIDTH, self.cellHeight - MARGIN);
}

@end
