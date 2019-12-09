//
//  UIColor+SKDarkModeColor.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/10.
//  Copyright © 2019 小风. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (SKDarkModeColor)
/*
 返回一个UIColor对象 设置lightColor为正常模式下的颜色，darkColor为暗黑模式下的颜色
 */
+ (UIColor *)sk_setLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;


@end

NS_ASSUME_NONNULL_END
