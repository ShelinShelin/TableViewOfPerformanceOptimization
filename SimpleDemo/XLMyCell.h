//
//  XLMyCell.h
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLLayout, XLMyCell;

@protocol XLCellDelegate <NSObject>

@optional

- (void)cellDidClickAvatar:(XLMyCell *)cell;
- (void)cellDidClickComment:(XLMyCell *)cell;
- (void)cellDidClickCompose:(XLMyCell *)cell;
- (void)cellDidClickLike:(XLMyCell *)cell;

@end


@interface XLImageView : UIView

@property (nonatomic, copy) NSString *imageName;

@end


@interface XLMyCell : UITableViewCell

@property (nonatomic, strong) XLLayout *layout;

@property (nonatomic, weak) id <XLCellDelegate> delegate;

+ (XLMyCell *)myCellWithTableView:(UITableView *)tableView;

@end

@interface XLMyCell (XLAdd)

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

