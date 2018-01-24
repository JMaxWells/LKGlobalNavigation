//
//  UIViewController+BFBase.m
//  BigFan
//
//  Created by MaxWellPro on 16/4/11.
//  Copyright © 2016年 QuanYan. All rights reserved.
//

#import "UIViewController+BFBase.h"
#import "objc/runtime.h"
#import "LKGlobalNavigationController.h"
#import "UIButton+Block.h"
#import "UIView+BlockGesture.h"

#define BF_SHADOW_VIEW_DEFAULT_COLOR    [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1]
#define BF_SHADOW_VIEW_CLEAR_COLOR      [UIColor clearColor]
#define BF_SHADOW_VIEW_TAG              10010
#define BF_SYSTEM_SHADOW_VIEW_TAG       10011

/**
 *  忽略统计的页面
 */
static NSArray *ignoreControllers;
static char const *const paramsKey = "BF_BaseParamskey";
static char const *const completeBlockKey = "BF_CompleteBlockKey";
static UIImage *clearImage;
static UIImage *defaultImage;

@implementation UIViewController (BFBase)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ignoreControllers = @[@"LKGlobalNavigationController",@"LKRootViewController",@"BFLoginNavigationViewController",@"UINavigationController",@"UIImagePickerController",@"UICompatibilityInputViewController",@"UIAlertController",@"UISplitViewController",@"UIRemoteInputViewController",@"APayWapPayViewController",@"UIKeyboardCandidateGridCollectionViewController",@"UIInputWindowController",@"SWActionSheetVC",@"UIViewController"];
    });
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method didLoadMethod = class_getInstanceMethod(self, @selector(viewDidLoad));
        Method bf_didLoadMethod = class_getInstanceMethod(self, @selector(bf_viewDidLoad));
        method_exchangeImplementations(didLoadMethod, bf_didLoadMethod);
        
        Method viewWillAppearMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
        Method bf_viewWillAppearMethod = class_getInstanceMethod(self, @selector(bf_viewWillAppear:));
        method_exchangeImplementations(viewWillAppearMethod, bf_viewWillAppearMethod);
        
        Method viewWillDisappearMethod = class_getInstanceMethod(self, @selector(viewWillDisappear:));
        Method bf_viewWillDisappearMethod = class_getInstanceMethod(self, @selector(bf_viewWillDisappear:));
        method_exchangeImplementations(viewWillDisappearMethod, bf_viewWillDisappearMethod);
        
        Method viewDidAppearMethod = class_getInstanceMethod(self, @selector(viewDidAppear:));
        Method bf_viewDidAppearMethod = class_getInstanceMethod(self, @selector(bf_viewDidAppear:));
        method_exchangeImplementations(viewDidAppearMethod, bf_viewDidAppearMethod);
    });
}

- (void)bf_viewDidAppear:(BOOL)animated {
    [self bf_viewDidAppear:YES];
}

- (void)bf_viewDidLoad {
    [self bf_viewDidLoad];
    [self navShadowViewConfig];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:nil];
}

- (void)bf_viewWillAppear:(BOOL)animated {
    [self bf_viewWillAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
        if (![ignoreControllers containsObject:className]) {
            // 友盟统计
//            [MobClick beginLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
        }
    });
}

- (void)bf_viewWillDisappear:(BOOL)animated {
    [self bf_viewWillDisappear:animated];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *className = [NSString stringWithUTF8String:object_getClassName(self)];
        if (![ignoreControllers containsObject:className]) {
            // 友盟统计
//            [MobClick endLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
        }
    });
}

- (id)initWithParams:(id)params {
    if ([self init]) {
        self.params = params;
    }
    return self;
}

- (id)initWithParams:(id)params complete:(completeBlock)callBack {
    if ([self init]) {
        self.params = params;
        self.completeBlock = callBack;
    }
    return self;
}

#pragma mark 属性关联

- (void)setParams:(id)params {
    objc_setAssociatedObject(self, paramsKey, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)params {
    return objc_getAssociatedObject(self, paramsKey);
}

- (void)setCompleteBlock:(completeBlock)completeBlock {
    objc_setAssociatedObject(self, completeBlockKey, completeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (completeBlock)completeBlock {
    return objc_getAssociatedObject(self, completeBlockKey);
}

#pragma mark - SetRightBarButtonItem

- (void)setRightButtonItemWithTitle:(NSString *)title actionBlock:(rightButtonItemActionBlock)block
{
    [self setRightButtonItemWithFrame:CGRectMake(0, 0, 70, 44)
                                title:title
                                image:nil
                          actionBlock:block];
}

- (void)setRightButtonItemWithImage:(UIImage *)image actionBlock:(rightButtonItemActionBlock)block
{
    [self setRightButtonItemWithFrame:CGRectMake(0,12,20,20)
                                title:nil
                                image:image
                          actionBlock:block];
}

- (UIButton *)setAndReturnRightButtonItemWithTitle:(NSString *)title actionBlock:(rightButtonItemActionBlock)block
{
    return [self setRightButtonItemWithFrame:CGRectMake(0, 0, 70, 44)
                                       title:title
                                       image:nil
                                 actionBlock:block];
}

- (UIButton *)setAndReturnRightButtonItemWithImage:(UIImage *)image actionBlock:(rightButtonItemActionBlock)block
{
    return [self setRightButtonItemWithFrame:CGRectMake(0,12,20,20)
                                       title:nil
                                       image:image
                                 actionBlock:block];
}

- (void)setRightButtonItemViewCustomView:(UIView *)customView actionBlock:(rightButtonItemActionBlock)block
{
    [customView addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        if (block)
        {
            block();
        }
    }];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -4;
    self.navigationController.topViewController.navigationItem.rightBarButtonItems = @[negativeSpacer,rightButtonItem];
}

- (UIButton *)setRightButtonItemWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image actionBlock:(rightButtonItemActionBlock)block
{
    UIButton *rightButton = [self buttonItemWithFrame:frame title:title image:image];
    [rightButton addActionHandler:block];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    /**
     *  width为负数时，相当于btn向右移动width数值个像素，由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整
     *  为0；width为正数时，正好相反，相当于往左移动width数值个像素
     */
    negativeSpacer.width = -4;
    //当为主控制器的时候topViewController为BFMainViewController，其他的都为self
    self.navigationController.topViewController.navigationItem.rightBarButtonItems = @[negativeSpacer,rightButtonItem];
    return rightButton;
}

- (void)setRightButtonItemsWithImages:(nonnull NSArray<UIImage *> *)imagesArray actionBlock:(nullable rightButtonItemsActionBlock)block
{
    NSAssert(imagesArray.count > 0, @"参数不合法，请传入非空的图片数组");
    NSMutableArray *itemsA = [NSMutableArray array];
    for (NSInteger i = imagesArray.count - 1; i < imagesArray.count; i --)
    {
        UIButton *button = [self buttonItemWithFrame:CGRectMake(0, 12, 20, 20) title:nil image:imagesArray[i]];
        button.tag = i;
        [button addActionHandler:block];
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [itemsA addObject:rightButtonItem];
        
        if ( i > 0 ) {
            UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                            target:nil
                                                                                            action:nil];
            negativeSpacer.width = 20;
            [itemsA addObject:negativeSpacer];
            
        }
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -10;
    [itemsA insertObject:negativeSpacer atIndex:0];
    self.navigationController.topViewController.navigationItem.rightBarButtonItems = itemsA;
}

- (void)setRightButtonItemsWithTitles:(nonnull NSArray<NSString *> *)titlesArray actionBlock:(nullable rightButtonItemsActionBlock)block
{
    NSAssert(titlesArray.count > 0, @"参数不合法，请传入非空的标题数组");
    NSMutableArray *itemsA = [NSMutableArray array];
    for (NSInteger i = titlesArray.count - 1; i < titlesArray.count; i --)
    {
        NSString *titleStr = titlesArray[i];
        CGSize titleSize = [titleStr boundingRectWithSize:CGSizeMake(70, 44) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
        UIButton *button = [self buttonItemWithFrame:CGRectMake(0, 0, titleSize.width, 44) title:titlesArray[i] image:nil];
        button.tag = i;
        [button addActionHandler:block];
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [itemsA addObject:rightButtonItem];
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
    negativeSpacer.width = -10;
    [itemsA insertObject:negativeSpacer atIndex:0];
    self.navigationController.topViewController.navigationItem.rightBarButtonItems = itemsA;
}

- (void)setBackAndLeftButtonItemWithTitle:(nonnull NSArray<NSString *> *)titlesArray actionBlock:(nullable rightButtonItemsActionBlock)block
{
    NSAssert(titlesArray.count > 0, @"参数不合法，请传入非空的标题数组");
    NSMutableArray *itemsA = [NSMutableArray array];
    for (NSInteger i = 0; i < titlesArray.count; i ++)
    {
        NSString *titleStr = titlesArray[i];
        CGSize titleSize = [titleStr boundingRectWithSize:CGSizeMake(70, 44) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size;
        UIButton *button = [self buttonItemWithFrame:CGRectMake(0, 0, titleSize.width, 44) title:titlesArray[i] image:nil];
        button.tag = i;
        if ( i == 0 ) {
            [button setImage:[UIImage imageNamed:@"title_icon_return"] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, titleSize.width + 40, 44);
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 10);
        }
        [button addActionHandler:block];
        UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [itemsA addObject:rightButtonItem];
    }
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -25;
    [itemsA insertObject:negativeSpacer atIndex:0];
    self.navigationController.topViewController.navigationItem.leftBarButtonItems = itemsA;
}

- (void)setBackAndLeftButtonItemWithImages:(nonnull NSArray<UIImage *> *)imagesArray actionBlock:(nullable rightButtonItemsActionBlock)block{
    NSAssert(imagesArray.count > 0, @"参数不合法，请传入非空的图片数组");
    NSMutableArray *itemsA = [NSMutableArray array];
    for (NSInteger i = 0; i < imagesArray.count; i ++)
    {
        UIButton *button = [self buttonItemWithFrame:CGRectMake(0, 12, 22, 22) title:nil image:imagesArray[i]];
        button.tag = i;
        [button addActionHandler:block];
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [itemsA addObject:leftButtonItem];
        
        if ( i > 0 ) {
            UIButton *spacer = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, 3, 20)];
            spacer.userInteractionEnabled = NO;
            UIBarButtonItem *spacerItem = [[UIBarButtonItem alloc] initWithCustomView:spacer];
            [itemsA addObject:spacerItem];
        }
        
    }
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -3;
    [itemsA insertObject:negativeSpacer atIndex:0];
    self.navigationController.topViewController.navigationItem.leftBarButtonItems = itemsA;
}

//返回一个按钮方法
- (UIButton *)buttonItemWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image
{
    UIButton *buttonItem = [UIButton buttonWithType:UIButtonTypeSystem];
    buttonItem.backgroundColor = [UIColor clearColor];
    [buttonItem setTitleColor:[UIColor colorWithRed:45/255.0 green:45/255.0 blue:55/255.0 alpha:1] forState:UIControlStateNormal];
    buttonItem.frame = frame;
    if (title)
    {
        buttonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        buttonItem.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [buttonItem setTitle:title forState:UIControlStateNormal];
    }
    if (image)
    {
        [buttonItem setBackgroundImage:image forState:UIControlStateNormal];
    }
    return buttonItem;
}

- (void)setLeftButtonItemWithTitle:(NSString *)title actionBlock:(rightButtonItemActionBlock)block
{
    UIButton *leftButton = [self buttonItemWithFrame:CGRectMake(0, 0, 70, 44) title:title image:nil];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton addActionHandler:block];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)setLeftButtonItemWithImage:(UIImage *)image actionBlock:(rightButtonItemActionBlock)block
{
    UIButton *leftButton = [self buttonItemWithFrame:CGRectMake(0, 12, 20, 20) title:nil image:image];
    [leftButton addActionHandler:block];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (nonnull UIButton *)setAndReturnLeftButtonItemWithImage:(nonnull UIImage *)image actionBlock:(nullable rightButtonItemActionBlock)block
{
    UIButton *leftButton = [self buttonItemWithFrame:CGRectMake(0, 12, 20, 20) title:nil image:image];
    [leftButton addActionHandler:block];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = leftButtonItem;
    return leftButton;
}

- (nonnull UIButton *)setAndReturnLeftButtonItemWithTitle:(nonnull NSString *)title actionBlock:(nullable rightButtonItemActionBlock)block
{
    UIButton *leftButton = [self buttonItemWithFrame:CGRectMake(0, 0, 44, 44) title:title image:nil];
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [leftButton addActionHandler:block];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = leftButtonItem;
    return leftButton;
}

#pragma Custom Method

- (void)navShadowViewConfig {
    if (self.navigationController.navigationBar) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            UIImageView *systemView = [self getShadowViewInNavigationBar:self.navigationController.navigationBar];
            systemView.tag = BF_SYSTEM_SHADOW_VIEW_TAG;
            systemView.hidden = YES;
            
            UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, [UIScreen mainScreen].bounds.size.width, .5)];
            shadowView.backgroundColor = BF_SHADOW_VIEW_DEFAULT_COLOR;
            shadowView.tag = BF_SHADOW_VIEW_TAG;
            [self.navigationController.navigationBar addSubview:shadowView];
            [self.navigationController.navigationBar bringSubviewToFront:shadowView];
        });
    }
}

- (UIImageView *)getShadowViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getShadowViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
}

- (void)navShadowImageHidden:(BOOL)hidden
{
    UIView *shadowView = [self.navigationController.navigationBar viewWithTag:BF_SHADOW_VIEW_TAG];
    if (hidden) {
        shadowView.backgroundColor = BF_SHADOW_VIEW_CLEAR_COLOR;
    }else {
        shadowView.backgroundColor = BF_SHADOW_VIEW_DEFAULT_COLOR;
    }
}

- (void)configNavShadowViewColor:(UIColor *)color {
    if (self.navigationController.navigationBar) {
        UIView *shadowView = [self.navigationController.navigationBar viewWithTag:BF_SHADOW_VIEW_TAG];
        UIImageView *systemShadowView = [self.navigationController.navigationBar viewWithTag:BF_SYSTEM_SHADOW_VIEW_TAG];
        
        shadowView.backgroundColor = color ?: BF_SHADOW_VIEW_DEFAULT_COLOR;
        if ([color isEqual:BF_SHADOW_VIEW_DEFAULT_COLOR]) {
            [self.navigationController.navigationBar setShadowImage:[self imageWithColor:color]];
            systemShadowView.hidden = YES;
        }else {
            systemShadowView.hidden = NO;
            [self.navigationController.navigationBar setShadowImage:[self imageWithColor:color]];
        }
    }
}

#pragma mark - Private Method

- (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1, 1)];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end

