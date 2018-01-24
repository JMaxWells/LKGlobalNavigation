//
//  FirstViewController.m
//  LKGlobalNavigationDemo
//
//  Created by MaxWellPro on 2018/1/24.
//  Copyright © 2018年 QuanYanTech. All rights reserved.
//

#import "FirstViewController.h"
#import "LKGlobalNavigationController.h"
#import "LKGlobalConstants.h"
#import "UIViewController+BFNavigate.h"

@interface FirstViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FirstViewController

// 向LKGlobalNavigation注册当前页面的URL 或者可以使用IMPLEMENT_LOAD(URL_FIRST_VC)注册
+ (void)load {
    [LKGlobalNavigationController registerURLPattern:URL_FIRST_VC viewControllerClass:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Page A";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT_OUT_NAV)];
}

- (void)viewDidLayoutSubviews {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = @[@"Push PageB",@"Present PageD"][indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // Push To Page B
        [self pushViewControllerWithURLPattern:URL_SECOND_VC
                                    withParams:@16// 向PageB传参
                                 completeReply:^(id result) {//向PageB传回调
                                     // 收到PageB发出的回调
                                     if (result) {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PageA Alert"
                                                                                             message:[NSString stringWithFormat:@"收到PageB的回调：%@",result]
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"确定"
                                                                                   otherButtonTitles:nil, nil];
                                         [alertView show];
                                     }
                                 }];
    }
    else if (indexPath.row == 1) {
        // Present To Page D
        [self presentNavigationControllerWithURLPattern:URL_FOURTH_VC
                                             withParams:NULL
                                          completeReply:NULL
                                             completion:NULL];
    }
}

#pragma mark - Setter & Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setShowsVerticalScrollIndicator:NO];
        [_tableView setShowsHorizontalScrollIndicator:NO];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _tableView;
}

- (void)dealloc {
    NSLog(@"\n %@ is dealloc \n",[self class]);
}

@end
