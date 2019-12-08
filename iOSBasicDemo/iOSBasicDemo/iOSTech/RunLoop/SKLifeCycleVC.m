//
//  SKLifeCycleVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/8.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKLifeCycleVC.h"
#import "SKLifeCycleVC.h"

@interface SKLifeCycleVC ()

@end

@implementation SKLifeCycleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"B Class === viewDidLoad");
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)loadView {
    [super loadView];
    NSLog(@"B Class === loadView");

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"B Class === viewWillAppear");

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"B Class === viewDidAppear");

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"B Class === viewWillDisappear");

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"B Class === viewDidDisappear");
}


- (void)dealloc {
    NSLog(@"B Class === dealloc");
}

@end
