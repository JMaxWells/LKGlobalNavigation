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

- (void)dealloc {
    NSLog(@"\n %@ is dealloc \n",[self class]);
}

@end
