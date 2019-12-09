//
//  UIView+SKDarkModeColor.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/10.
//  Copyright © 2019 小风. All rights reserved.
//

#import "UIView+SKDarkModeColor.h"


@implementation UIView (SKDarkModeColor)

- (void)sk_setBackgroundColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    if (@available(iOS 13.0, *)) {
        self.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (!darkColor) {
                NSAssert(!darkColor, @"不存在darkColor，是否需要设置,如果不需要请忽略");
            }
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkColor?darkColor:(lightColor?lightColor:[UIColor clearColor]);
            } else {
                return lightColor?lightColor:[UIColor clearColor];
            }
        }];
    }
    self.backgroundColor = lightColor?lightColor:[UIColor clearColor];
}

@end
