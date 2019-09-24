//
//  SKPropertyVC.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKPropertyVC.h"

@interface SKPropertyVC ()

@end

@implementation SKPropertyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self normalMethod];
    [self nssetMethod];
    
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

// 非集合类

- (void)normalMethod {
    
}
// 集合类

- (void)nssetMethod {
    
}

@end
