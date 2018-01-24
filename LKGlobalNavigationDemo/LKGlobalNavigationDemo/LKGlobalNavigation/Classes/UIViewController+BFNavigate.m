//
//  UIViewController+BFNavigate.m
//  Pods
//
//  Created by QuanyanTech on 17/3/31.
//
//

#import "UIViewController+BFNavigate.h"
#import "objc/runtime.h"
#import "LKGlobalNavigationController.h"

static char const *const paramsKey = "BF_BaseParamskey";
static char const *const completeBlockKey = "BF_CompleteBlockKey";


@implementation UIViewController (BFNavigate)

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

- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern {
    [self pushViewControllerWithURLPattern:URLPattern withParams:nil];
}

- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params {
    [self pushViewControllerWithURLPattern:URLPattern withParams:params completeReply:nil];
}

- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern  completeReply:(completeBlock)callBack {
    [self pushViewControllerWithURLPattern:URLPattern withParams:nil completeReply:callBack];
}

- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params completeReply:(completeBlock)callBack {
    [self pushViewControllerWithURLPattern:URLPattern withParams:params animated:YES completeReply:callBack];
}

- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params animated:(BOOL)animate completeReply:(completeBlock)callBack {
    Class vcClass = [LKGlobalNavigationController findViewControllerClassWithURLPattern:URLPattern];
    NSLog(@"\n-------------------------- URLPattern is %@ ------------------------\n",URLPattern);
    UIViewController *existVc = [LKGlobalNavigationController sharedInstance].viewControllers.lastObject;
    if ( [existVc isKindOfClass:[vcClass class]] && [existVc.params isEqualToDictionary:params]) {
        return;
    }
    UIViewController *vc = [[vcClass alloc] initWithParams:params complete:callBack];
    
    [[LKGlobalNavigationController sharedInstance] pushViewController:vc animated:animate];
}

- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern {
    [self presentViewControllerWithURLPattern:URLPattern withParams:nil completeReply:nil completion:nil];
}

- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern completion:(completion)completion {
    [self presentViewControllerWithURLPattern:URLPattern withParams:nil completeReply:nil completion:completion];
}

- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id )params {
    [self presentViewControllerWithURLPattern:URLPattern withParams:params completeReply:nil completion:nil];
}

- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id )params completion:(completion)completion {
    [self presentViewControllerWithURLPattern:URLPattern withParams:params completeReply:nil completion:completion];
}

- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern completeReply:(completeBlock)callBack  {
    [self presentViewControllerWithURLPattern:URLPattern withParams:nil completeReply:callBack completion:nil];
}

- (void)presentViewControllerWithPattern:(NSString *)URLPattern completeReply:(completeBlock)callBack completion:(completion)completion {
    [self presentViewControllerWithURLPattern:URLPattern withParams:nil completeReply:callBack completion:completion];
}

- (void)presentNavigationControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params completeReply:(completeBlock)callBack completion:(completion)completion {
    Class vcClass = [LKGlobalNavigationController findViewControllerClassWithURLPattern:URLPattern];
    if (!vcClass) {
        NSLog(@"未找到ViewController");
        return;
    }
    UIViewController *vc = [[vcClass alloc] initWithParams:params complete:callBack];
    if (vc) {
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
        UIBarButtonItem *leftItem = nvc.navigationItem.backBarButtonItem;
        [leftItem setTitle:nil];
        [leftItem setBackgroundImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        //[leftItem setTintColor:[UIColor whiteColor]];
        
        [nvc.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
        [nvc.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        [nvc.navigationBar setTintColor:[UIColor blackColor]];
        [nvc.navigationBar setBarStyle:UIBarStyleDefault];
        [nvc.navigationBar setTranslucent:NO];
        [nvc.navigationBar setShadowImage:[self imageWithColor:[UIColor clearColor]]];//去掉导航栏底部的黑线
        [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
        
        [self presentViewController:nvc animated:YES completion:completion];
    }
    else
        NSLog(@"未找到ViewController");
}

- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params completeReply:(completeBlock)callBack completion:(completion)completion {
    Class vcClass = [LKGlobalNavigationController findViewControllerClassWithURLPattern:URLPattern];
    if (!vcClass) {
        NSLog(@"未找到ViewController");
        return;
    }
    UIViewController *vc = [[vcClass alloc] initWithParams:params complete:callBack];
    if (vc) {
        [self presentViewController:vc animated:YES completion:completion];
    }
    else
        NSLog(@"未找到ViewController");
}

- (void)popPPViewController {
    [self popPPViewControllerAnimate:YES];
}

- (void)popPPViewControllerAnimate:(BOOL)animated {
    [self popoverPresentationControllerAnimated:animated completion:nil];
}

- (void)popoverPresentationControllerAnimated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    if ([self isKindOfClass:[UITabBarController class]]) {
        if (animated) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.3f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromLeft;
            [[LKGlobalNavigationController sharedInstance].view.layer addAnimation:transition forKey:nil];
        }
        [[LKGlobalNavigationController sharedInstance] popViewControllerAnimated:NO];
    }
    else
        [[LKGlobalNavigationController sharedInstance] popViewControllerAnimated:animated];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
    [[LKGlobalNavigationController sharedInstance] popToRootViewControllerAnimated:animated];
}

- (BOOL)popToViewControllerWithURLPattern:(NSString *)URLPattern animated:(BOOL)animated {
    UIViewController *vc = [LKGlobalNavigationController findAnExistViewControllerWithURLPattern:URLPattern];
    if (vc) {
        [[LKGlobalNavigationController sharedInstance] popToViewController:vc animated:animated];
        return YES;
    }
    return NO;
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
