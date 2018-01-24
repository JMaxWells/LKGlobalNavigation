//
//  LKAutomation.h
//  larklite
//
//  Created by MaxWellPro on 2017/4/20.
//  Copyright © 2017年 QuanYanTech. All rights reserved.
//

#ifndef LKAutomation_h
#define LKAutomation_h

#ifndef	weakify
#if __has_feature(objc_arc)
#define weakify( x )	autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x;
#else	// #if __has_feature(objc_arc)
#define weakify( x )	autoreleasepool{} __block __typeof__(x) __block_##x##__ = x;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	weakify

#ifndef	normalize
#if __has_feature(objc_arc)
#define normalize( x )	try{} @finally{} __typeof__(x) x = __weak_##x##__;
#else	// #if __has_feature(objc_arc)
#define normalize( x )	try{} @finally{} __typeof__(x) x = __block_##x##__;
#endif	// #if __has_feature(objc_arc)
#endif	// #ifndef	@normalize

#undef	IMPLEMENT_LOAD
#define IMPLEMENT_LOAD( x ) \
+ (void)load \
{ \
@autoreleasepool \
{ \
[LKGlobalNavigationController registerURLPattern:x viewControllerClass:[self class]]; \
} \
}

#undef	IMPLEMENT_DEALLOC
#define IMPLEMENT_DEALLOC \
- (void)dealloc \
{ \
NSLog(@"\n %@ is dealloc \n",[self class]); \
}

#endif /* LKAutomation_h */
