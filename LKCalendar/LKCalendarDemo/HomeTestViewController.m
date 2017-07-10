//
//  HomeTestViewController.m
//  LKTopMessage
//
//  Created by karos li on 2017/6/30.
//  Copyright © 2017年 karos. All rights reserved.
//

#import "HomeTestViewController.h"
#import "Demo1ViewController.h"

typedef  NS_ENUM(NSInteger, TestType) {
    TestTypeCalendar,
    
};

static NSArray *testTypes;

@interface HomeTestViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HomeTestViewController

+ (void)initialize {
    if (self == [HomeTestViewController self]) {
        testTypes = @[@{@"type" : @(TestTypeCalendar),
                        @"desc" : @"显示日历"},
                      ];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.tableFooterView = [UIView new];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return testTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.textLabel.text = testTypes[indexPath.row][@"desc"];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TestType type = [testTypes[indexPath.row][@"type"] integerValue];
    
    if (type == TestTypeCalendar) {
        [self.navigationController pushViewController:[Demo1ViewController new] animated:YES];
    }
}

#pragma mark - getter and setter
- (UITableView *)tableView {
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] init];
        _tableView = tableView;
    }
    
    return _tableView;
}

@end
