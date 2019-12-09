//
//  UIView+SKDarkModeColor.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/10.
//  Copyright © 2019 小风. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 这个太有局限性 不建议使用。
@interface UIView (SKDarkModeColor)

- (void)sk_setBackgroundColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

@end

NS_ASSUME_NONNULL_END
