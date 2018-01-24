//
//  UIButton+Block.m
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/30.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>
static const void *UIButtonBlockKey = &UIButtonBlockKey;

@implementation UIButton (Block)

- (void)addActionHandler:(TouchedBlock)touchHandler {
    objc_setAssociatedObject(self, UIButtonBlockKey, touchHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(actionTouched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)actionTouched:(UIButton *)btn {
    //fix execute block times
    static BOOL isOnGoing = NO;
    if (isOnGoing) {
        return;
    }
    TouchedBlock block = objc_getAssociatedObject(self, UIButtonBlockKey);
    if (block) {
        isOnGoing = YES;
        block(btn.tag);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isOnGoing = NO;
        });
    }else {
        isOnGoing = NO;
    }
}

@end

