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
