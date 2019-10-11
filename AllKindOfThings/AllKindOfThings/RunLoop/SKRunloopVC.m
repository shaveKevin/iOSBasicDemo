//
//  SKRunloopVC.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/20.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKRunloopVC.h"
#import "SKRunLoopObject.h"
@interface SKRunloopVC ()

@end

@implementation SKRunloopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
    [self setupLayout];
    [self methodActions];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setupData {
    
}

- (void)setupLayout {
    
}

- (void)methodActions {
    [self runLoopTest];
}

- (void)runLoopTest {
    SKRunLoopObject *runloopObj = [[SKRunLoopObject alloc]init];
}
@end
