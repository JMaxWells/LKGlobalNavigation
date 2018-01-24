//
//  UIViewController+BFBase.h
//  BigFan
//
//  Created by QuanyanTech on 16/4/11.
//  Copyright © 2016年 QuanyanTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeBlock)(id result);
typedef void (^rightButtonItemActionBlock)();
typedef void (^rightButtonItemsActionBlock)(NSInteger itemIndex);

@interface UIViewController (BFBase)

/**
 *  外部传入的参数
 */
@property (nonatomic, strong) id params;
/**
 *  外部传入的block参数
 */
@property (nonatomic, copy) completeBlock completeBlock;

/**
 *  初始化
 */
- (id)initWithParams:(id)params;
- (id)initWithParams:(id)params complete:(completeBlock)callBack;

#pragma  mark - RightBarButtonItems
/**
 *  添加带文字的rightButtonItem
 *
 *  @param title button的title
 *  @param block button的点击事件处理block
 */
- (void)setRightButtonItemWithTitle:(nonnull NSString *)title actionBlock:(nullable rightButtonItemActionBlock)block;

/**
 *  添加带图片的rightButtonItem
 *
 *  @param image button的图片
 *  @param block button的点击事件处理block
 */
- (void)setRightButtonItemWithImage:(nonnull UIImage *)image actionBlock:(nullable rightButtonItemActionBlock)block;

/**
 *  添加带文字的rightButtonItem，并返回button，可以自己修改button的属性
 *
 *  @param title button的title
 *  @param block button的点击事件处理block
 *
 *  @return 返回添加的按钮
 */
- (nonnull UIButton *)setAndReturnRightButtonItemWithTitle:(nonnull NSString *)title actionBlock:(nullable rightButtonItemActionBlock)block;

/**
 *  添加带图片的rightButtonItem，并返回button，可以自己修改button的属性
 *
 *  @param image button的image
 *  @param block button的点击事件处理block
 *
 *  @return 返回添加的按钮
 */
- (nonnull UIButton *)setAndReturnRightButtonItemWithImage:(nonnull UIImage *)image actionBlock:(nullable rightButtonItemActionBlock)block;

/**
 *  使用自定义的view去创建rightBarButtonItem
 *
 *  @param customView 自定义view
 *  @param block      button点击事件处理block
 */
- (void)setRightButtonItemViewCustomView:(nonnull UIView *)customView actionBlock:(nullable rightButtonItemActionBlock)block;

/**
 *  设置rightBarButtonItems
 *
 *  @param images buttonItem的图片
 *  @param block  button点击事件的处理block，根据tag来区分是点击的哪一个，tag为数组元素的下表
 */
- (void)setRightButtonItemsWithImages:(nonnull NSArray<UIImage *> *)imagesArray actionBlock:(nullable rightButtonItemsActionBlock)block;
/**
 *  设置rightBarButtonItems
 *
 *  @param titlesArray button标题数组
 *  @param block       button的点击事件处理block
 */
- (void)setRightButtonItemsWithTitles:(nonnull NSArray<NSString *> *)titlesArray actionBlock:(nullable rightButtonItemsActionBlock)block;
/**
 *  设置返回和关闭按钮
 *
 *  @param titlesArray button标题数组
 *  @param block       button的点击事件处理block
 */
- (void)setBackAndLeftButtonItemWithTitle:(nonnull NSArray<NSString *> *)titlesArray actionBlock:(nullable rightButtonItemsActionBlock)block;
/**
 *  设置返回和关闭按钮
 *
 *  @param images buttonItem的图片
 *  @param block  button点击事件的处理block，根据tag来区分是点击的哪一个，tag为数组元素的下表
 */
- (void)setBackAndLeftButtonItemWithImages:(nonnull NSArray<UIImage *> *)imagesArray actionBlock:(nullable rightButtonItemsActionBlock)block;

/**
 *  设置leftBarButtonItem
 *
 *  @param title 标题
 *  @param block button的点击处理block
 */
- (void)setLeftButtonItemWithTitle:(nullable NSString *)title actionBlock:(nullable rightButtonItemActionBlock)block;
/**
 *  设置leftBarButtonItem
 *
 *  @param image 图标
 *  @param block button的点击处理block
 */
- (void)setLeftButtonItemWithImage:(nullable UIImage *)image actionBlock:(nullable rightButtonItemActionBlock)block;

/**
 *  设置leftBarButtonItem
 *
 *  @param image 图标
 *  @param block 回调
 *
 *  @return 将按钮返回，用于修改
 */
- (nonnull UIButton *)setAndReturnLeftButtonItemWithImage:(nonnull UIImage *)image actionBlock:(nullable rightButtonItemActionBlock)block;

- (nonnull UIButton *)setAndReturnLeftButtonItemWithTitle:(nonnull NSString *)title actionBlock:(nullable rightButtonItemActionBlock)block;

#pragma mark - NavBar Setting
/**
 导航栏的底部的线条是否隐藏
 需要注意的是在需要的地方隐藏，在离开界面的时候需要显示出来以免影响其他界面
 @param hidden 是否隐藏
 */
- (void)navShadowImageHidden:(BOOL)hidden;

/**
 配置导航栏底部线条的颜色，主要是对于导航栏颜色和视图是一个颜色
 需要注意的是需要在设置颜色之后，离开界面的时候设置为BF_SHADOW_VIEW_DEFAULT_COLOR
 @param color 颜色
 */
- (void)configNavShadowViewColor:(UIColor *)color;

@end
