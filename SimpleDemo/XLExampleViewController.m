//
//  XLExampleViewController.m
//  SimpleDemo
//
//  Created by Shelin on 16/7/2.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLExampleViewController.h"

@implementation XLExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bg_image.jpg" ofType:nil];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    imageView.image = image;
    [self.view addSubview:imageView];
    
    UIView *view_1 = [[UIView alloc] initWithFrame:CGRectMake(50, 100, self.view.frame.size.width - 100, 100)];
    view_1.backgroundColor = [UIColor whiteColor];
    view_1.alpha = 0.5;
    [self.view addSubview:view_1];
    
    UIView *view_2 = [[UIView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(view_1.frame) + 30 , self.view.frame.size.width - 100, 100)];
    view_2.backgroundColor = [UIColor whiteColor];
    view_2.alpha = 1.0;
    [self.view addSubview:view_2];
    
}

@end
