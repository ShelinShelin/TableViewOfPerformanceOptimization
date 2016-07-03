//
//  XLItem.h
//  SimpleDemo
//
//  Created by Shelin on 16/6/22.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLItem : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, copy) NSString *publicTime;
@property (nonatomic, copy) NSString *from;

@property (nonatomic, strong) NSMutableAttributedString *attrStatus;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)itemWithDict:(NSDictionary *)dict;

@end
