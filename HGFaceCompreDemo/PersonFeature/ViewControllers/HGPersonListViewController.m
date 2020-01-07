//
//  HGPersonListViewController.m
//  HGFaceCompreDemo
//
//  Created by 黄纲 on 2020/1/7.
//  Copyright © 2020 Gang. All rights reserved.
//

#import "HGPersonListViewController.h"
#import "HGPersonListTableViewCell.h"
#import "HGDBManager.h"

@interface HGPersonListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation HGPersonListViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}

#pragma mark - UI
- (void)initUI{
    self.title = @"人脸列表";
    self.dataList = [[HGDBManager sharedInstance]getPersonList].mutableCopy;
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

#pragma mark - Methods

#pragma mark - Actions

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGPersonListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HGPersonListTableViewCell"];
    [cell configCellWithModel:self.dataList[indexPath.row]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    HGPersonFeatureModel *model = self.dataList[indexPath.row];
    [[HGDBManager sharedInstance] deletePerson:model.personCardid];
    [self.dataList removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationLeft];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[HGPersonListTableViewCell class] forCellReuseIdentifier:@"HGPersonListTableViewCell"];
    }
    return _tableView;
}

#pragma mark - Getters

#pragma mark - Setters


@end
