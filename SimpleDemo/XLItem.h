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

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)itemWithDict:(NSDictionary *)dict;

@end
