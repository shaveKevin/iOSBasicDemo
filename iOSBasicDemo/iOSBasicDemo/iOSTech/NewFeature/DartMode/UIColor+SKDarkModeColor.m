//
//  UIColor+SKDarkModeColor.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/10.
//  Copyright © 2019 小风. All rights reserved.
//

#import "UIColor+SKDarkModeColor.h"


@implementation UIColor (SKDarkModeColor)

+ (UIColor *)sk_setLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            if (!darkColor) {
                NSAssert(darkColor, @"不存在darkColor，是否需要设置,如果不需要请忽略");
            }
            return darkColor?darkColor:(lightColor?lightColor:[UIColor clearColor]);
        }
    }
    return lightColor?lightColor:[UIColor clearColor];
}

@end
