//
//  SKRuntimeVC.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/19.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKRuntimeVC.h"
#import "NSObject+SKRuntimeAssociatedObject.h"

@interface SKRuntimeVC ()

@end

@implementation SKRuntimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
    [self setupLayout];
    
    [self runtimeProperty];
    
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)setupData {
    
}

- (void)setupLayout {
    
}



- (void)runtimeProperty {
    // 对类添加属性 采用的是runtime
    NSObject *objc = [[NSObject alloc] init];
    objc.timeValue = @"这是时间诶";
    NSLog(@"%@",objc.timeValue);
    
}


@end
