//
//  ViewController.m
//  DPCycleScrollView
//
//  Created by yxw on 15/9/6.
//  Copyright (c) 2015年 yxw. All rights reserved.
//

#import "ViewController.h"
#import "DPCycleScrollView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, DPCycleScrollViewDatasource, DPCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *bgTableView;
@property (nonatomic, strong) DPCycleScrollView *headerView;
@end

@implementation ViewController
@synthesize bgTableView;
@synthesize headerView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    bgTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    bgTableView.delegate = self;
    bgTableView.dataSource = self;
    [bgTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:bgTableView];
    
    headerView = [[DPCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200)];
    headerView.delegate = self;
    headerView.datasource = self;
    bgTableView.tableHeaderView = headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"hello world";
    
    return cell;
}

#pragma mark - DPCycleScrollViewDatasource
- (NSInteger)numberOfPagesInCycleScrollView:(DPCycleScrollView *)csView
{
    return 3;
}

- (UIView *)cycleScrollView:(DPCycleScrollView *)csView pageAtIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:csView.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", @(index + 1)]];
    
    return imageView;
}

#pragma mark - DPCycleScrollViewDelegate
- (void)cycleScrollView:(DPCycleScrollView *)csView clickPageAtIndex:(NSInteger)index
{
    NSLog(@"clickPageAtIndex:%@", @(index));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
