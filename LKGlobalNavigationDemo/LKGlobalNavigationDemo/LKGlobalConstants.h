//
//  LKGlobalConstants.h
//  LKGlobalNavigationDemo
//
//  Created by MaxWellPro on 2018/1/24.
//  Copyright © 2018年 QuanYanTech. All rights reserved.
//

#ifndef LKGlobalConstants_h
#define LKGlobalConstants_h

// 屏幕尺寸
#define SCREEN_WIDTH                                    (MIN( [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height ))
#define SCREEN_HEIGHT                                   (MAX( [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height ))
#define STATUS_HEIGHT                                   ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define SCREEN_HEIGHT_OUT_NAV                           (SCREEN_HEIGHT - 44 - STATUS_HEIGHT)

// 系统控件默认高度
#define StatusBarHeight                                 (20.f)
#define TopBarHeight                                    (44.f)
#define BottomBarHeight                                 (49.f)
#define CellDefaultHeight                               (44.f)
#define EnglishKeyboardHeight                           (216.f)
#define ChineseKeyboardHeight                           (252.f)

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


#define URL_FIRST_VC                                    @"lark://firstVC"
#define URL_SECOND_VC                                   @"lark://secondVC"
#define URL_THIRD_VC                                    @"lark://thirdVC"
#define URL_FOURTH_VC                                   @"lark://fourthVC"

#endif /* LKGlobalConstants_h */
