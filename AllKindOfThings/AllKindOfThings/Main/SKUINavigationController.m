//
//  SKUINavigationController.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/20.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKUINavigationController.h"

@interface SKUINavigationController ()

@end

@implementation SKUINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:animated];
}


@end
