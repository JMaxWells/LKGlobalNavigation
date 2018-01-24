//
//  ThirdViewController.m
//  LKGlobalNavigationDemo
//
//  Created by MaxWellPro on 2018/1/24.
//  Copyright © 2018年 QuanYanTech. All rights reserved.
//

#import "ThirdViewController.h"
#import "LKGlobalNavigationController.h"
#import "LKGlobalConstants.h"
#import "UIViewController+BFNavigate.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

+ (void)load {
    [LKGlobalNavigationController registerURLPattern:URL_THIRD_VC viewControllerClass:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Page C";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回Page A" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT_OUT_NAV)];
    [self.view addSubview:button];
}

- (void)clickAction:(id)sender {
    // Pop To Page A
    [self popToViewControllerWithURLPattern:URL_FIRST_VC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
