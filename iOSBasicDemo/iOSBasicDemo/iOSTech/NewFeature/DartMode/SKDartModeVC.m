//
//  SKDartModeVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/10.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKDartModeVC.h"
#import "UIView+SKDarkModeColor.h"
#import "UIColor+SKDarkModeColor.h"

@interface SKDartModeVC ()
<UIContentContainer>

@end

@implementation SKDartModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 这个类还可以做一下扩展 比如支持rgb以及支持16进制的颜色等等 。还可以对UIColor添加一个类目 例如：
//    [self.view sk_setBackgroundColor:[UIColor redColor] darkColor:[UIColor blueColor]];
    // 这个是直接对UIColor添加类目  个人认为第二个比较好。通知可以支持16进制的颜色。
    self.view.backgroundColor = [UIColor sk_setLightColor:[UIColor redColor] darkColor:[UIColor blueColor]];
 
}
// 当模式发生改变的时候会调用这个方法 这个方法使用模式是iOS8+
- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    NSLog(@"模式发生改变了");
    self.view.backgroundColor = [UIColor sk_setLightColor:[UIColor redColor] darkColor:[UIColor blueColor]];
}



@end

// 面试题答案：夜间模式你是怎么适配的？
/* 首先我们通过api可以知道：系统为我们提供了一个动态更改颜色的api
```
+ (UIColor *)colorWithDynamicProvider:(UIColor * (^)(UITraitCollection *traitCollection))dynamicProvider API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos);
- (UIColor *)initWithDynamicProvider:(UIColor * (^)(UITraitCollection *traitCollection))dynamicProvider API_AVAILABLE(ios(13.0), tvos(13.0)) API_UNAVAILABLE(watchos);
 ```
 通过这个api可以对不同模式下的颜色进行设置。
 同时模式的改变我们在VC中可以检测到 我们可以对其做处理。
 夜间模式不会对纯色做出相应的改变。自定义的类如果设置了颜色，目标颜色就是当前设置的颜色。不论在什么模式下。
 如果不对颜色做特殊处理。那么系统会自动处理。
 
 
*/
