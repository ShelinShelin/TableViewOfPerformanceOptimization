//
//  XLTableView.h
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XLTableView;

@interface XLTableView : UITableView


@end


@interface XLTableView (XLAdd)

@property (nonatomic, strong) NSMutableArray *precacheIndexArray;

@end
