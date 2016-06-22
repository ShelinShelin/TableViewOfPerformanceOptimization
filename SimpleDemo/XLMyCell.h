//
//  XLMyCell.h
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLLayout;

@interface XLMyCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) XLLayout *layout;

+ (XLMyCell *)myCellWithTableView:(UITableView *)tableView;

@end
