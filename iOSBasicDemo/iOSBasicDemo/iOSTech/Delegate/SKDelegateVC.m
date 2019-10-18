
//
//  SKDelegateVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKDelegateVC.h"
#import "SKDelegateProtocal.h"
#import "SKDelegateTestView.h"
#import <Masonry/Masonry.h>

@interface SKDelegateVC ()<SKDelegateProtocal,SKDelegateObjectProtocal>

@property (nonatomic, assign) id<SKDelegateProtocal>  delegate;

@property (nonatomic, strong) SKDelegateTestView * testView;

@end

@implementation SKDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.delegate.nameProperty = @"9999";
    self.testView  = [[SKDelegateTestView alloc]init];
    [self.view addSubview:self.testView];
    self.testView.delegate = self;
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.topMargin.mas_equalTo(50);
        make.height.mas_equalTo(200);
    }];
    
}


- (void)dealloc {
    NSLog(@"当前控制器已被销毁");
    
}
- (void)testDelegateObjcControl {
    NSLog(@"这是个哈哈哈");
}
- (void)testControl {
    NSLog(@"test");
}
@synthesize nameProperty;

@end
