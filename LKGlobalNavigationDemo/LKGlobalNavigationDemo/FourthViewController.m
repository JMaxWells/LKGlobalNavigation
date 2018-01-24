//
//  FourthViewController.m
//  LKGlobalNavigationDemo
//
//  Created by MaxWellPro on 2018/1/24.
//  Copyright © 2018年 QuanYanTech. All rights reserved.
//

#import "FourthViewController.h"
#import "LKGlobalNavigationController.h"
#import "LKGlobalConstants.h"

@interface FourthViewController ()

@end

@implementation FourthViewController

+ (void)load {
    [LKGlobalNavigationController registerURLPattern:URL_FOURTH_VC viewControllerClass:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"这是Present出来的Page D";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"关闭" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT_OUT_NAV)];
    [self.view addSubview:button];
}

- (void)clickAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"\n %@ is dealloc \n",[self class]);
}

@end
