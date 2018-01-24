//
//  SecondViewController.m
//  LKGlobalNavigationDemo
//
//  Created by MaxWellPro on 2018/1/24.
//  Copyright © 2018年 QuanYanTech. All rights reserved.
//

#import "SecondViewController.h"
#import "LKGlobalNavigationController.h"
#import "LKGlobalConstants.h"
#import "UIViewController+BFNavigate.h"
#import "UIViewController+BFBase.h"
#import "LKAutomation.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

+ (void)load {
    [LKGlobalNavigationController registerURLPattern:URL_SECOND_VC viewControllerClass:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Page B";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 收到PageA的传参
    if (self.params) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"PageB Alert"
                                                            message:[NSString stringWithFormat:@"收到PageA的传值：%@",self.params]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点击跳转到Page C" forState:(UIControlStateNormal)];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [button setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT_OUT_NAV)];
    [self.view addSubview:button];
    
    self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>
    
    // 设置导航栏按钮
    @weakify(self)
    [self setRightButtonItemWithTitle:@"回调"
                          actionBlock:^{
                              @normalize(self)
                              // 发起回调
                              if (self.completeBlock) {
                                  self.completeBlock(@"来自B页面的CallBack");
                              }
        
    }];
}

- (void)clickAction:(id)sender {
    [self pushViewControllerWithURLPattern:URL_THIRD_VC];
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
