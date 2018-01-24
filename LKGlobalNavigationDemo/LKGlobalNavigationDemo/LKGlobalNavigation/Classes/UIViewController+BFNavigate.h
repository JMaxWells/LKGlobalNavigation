//
//  UIViewController+BFNavigate.h
//  Pods
//
//  Created by QuanyanTech on 17/3/31.
//
//

#import <UIKit/UIKit.h>
typedef void (^completeBlock)(id result);
typedef void (^completion)();

@interface UIViewController (BFNavigate)

#pragma mark - PUSH

- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern;
- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params;
- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern completeReply:(completeBlock)callBack;
- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params completeReply:(completeBlock)callBack;
- (void)pushViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params animated:(BOOL)animate completeReply:(completeBlock)callBack;

#pragma mark - POP

- (void)popPPViewController;
- (void)popPPViewControllerAnimate:(BOOL)animated;
- (void)popToRootViewControllerAnimated:(BOOL)animated;
- (BOOL)popToViewControllerWithURLPattern:(NSString *)URLPattern animated:(BOOL)animated;

#pragma mark - PRESENT
/**
 *  completeReply:咱们主动的回调callBack
 *  completion:系统自带的完成present动作的回调。
 */
- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern;
- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern completion:(completion)completion;
- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params;
- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params completion:(completion)completion;
- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern completeReply:(completeBlock)callBack;
- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern completeReply:(completeBlock)callBack completion:(completion)completion;
- (void)presentViewControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params completeReply:(completeBlock)callBack completion:(completion)completion;
- (void)presentNavigationControllerWithURLPattern:(NSString *)URLPattern withParams:(id)params completeReply:(completeBlock)callBack completion:(completion)completion;

@end
