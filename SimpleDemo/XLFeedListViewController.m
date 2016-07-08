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
#import "XLRunloopTaskManager.h"

@interface XLFeedListViewController () <UITableViewDelegate, UITableViewDataSource, XLCellDelegate>

@property (nonatomic, strong) XLTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation XLFeedListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
        
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
            [array addObjectsFromArray:tempArray];
        }
        
        self.dataArray = array.mutableCopy;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
        });
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[XLRunloopTaskManager sharedRunLoopTaskManager] removeAllRunloopTask];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLMyCell *cell = [XLMyCell myCellWithTableView:tableView];
    cell.delegate = self;
    cell.indexPath = indexPath;
    XLLayout *layout = (XLLayout *)self.dataArray[indexPath.row];
    cell.layout = layout;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    XLLayout *layout = (XLLayout *)self.dataArray[indexPath.row];
    return layout.cellHeight;
}

#pragma mark - XLCellDelegate

- (void)cellDidClickAvatar:(XLMyCell *)cell {
    NSLog(@"%s", __FUNCTION__);
}

- (void)cellDidClickComment:(XLMyCell *)cell {
    NSLog(@"%s", __FUNCTION__);
}

- (void)cellDidClickCompose:(XLMyCell *)cell {
    NSLog(@"%s", __FUNCTION__);
}

- (void)cellDidClickLike:(XLMyCell *)cell {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - lazy loading

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}

- (XLTableView *)tableView {
    if (!_tableView) {
        _tableView = [[XLTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
