//
//  XLExampleList.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLExampleList.h"
#import "XLTableView.h"

@interface XLExampleList () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XLTableView *tableView;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;

@end

@implementation XLExampleList


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ExampleList";
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self.view addSubview:self.tableView];
    
    [self addCellItemWithTitle:@"Feed List" className:@"XLFeedListViewController"];
    
}

- (void)addCellItemWithTitle:(NSString *)title className:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *_id = @"XL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_id];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_id];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Class c = NSClassFromString(self.classNames[indexPath.row]);
    
    [self.navigationController pushViewController:[[c alloc] init] animated:YES];
}

#pragma mark - lazt loading

- (XLTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
