//
//  XLFeedListViewController.m
//  SimpleDemo
//
//  Created by Shelin on 16/6/16.
//  Copyright © 2016年 Shelin. All rights reserved.
//

#import "XLFeedListViewController.h"
#import "XLTableView.h"
#import "XLMyCell.h"
#import "XLItem.h"
#import "XLLayout.h"
#import "UITableView+XLHeightCache.h"

@interface XLFeedListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) XLTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XLFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i = 0; i < 5; i ++) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"feedlist" ofType:@"json"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            
            NSDictionary *feedListDict  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSArray *feedlist = feedListDict[@"feedlist"];
            NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *itemDict in feedlist) {
                
                XLItem *item = [XLItem itemWithDict:itemDict];
                XLLayout *layout = [[XLLayout alloc] init];
                layout.item = item;
                [tempArray addObject:layout];
            }
            [self.dataArray addObjectsFromArray:tempArray];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.precacheIndexArray = self.dataArray.mutableCopy;
            [self.tableView reloadData];
        });
    });
}

#pragma mark - lazy loading

- (XLTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"%@",self.dataArray );
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLMyCell *cell = [XLMyCell myCellWithTableView:tableView];
    XLLayout *layout = self.dataArray[indexPath.row];
    cell.layout = layout;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    XLLayout *layout = self.dataArray[indexPath.row];
    return layout.cellHeight;
}

#pragma mark - lazy loading

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

@end
