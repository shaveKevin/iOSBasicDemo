//
//  SKThreadDeadLockVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/19.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKThreadLearningVC.h"
#import "SKGCDTestObj.h"
#import "SKGCDPrintObj.h"
#import "SKGCDObj.h"
#import "SKGCDSafeAnalysis.h"

@interface SKThreadLearningVC ()

@end

@implementation SKThreadLearningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
    [self setupLayout];
    [self privateMethod];
    [self threadMethodListAction];
    
    [self threadMethodAction];
    
    [self gcdSafeAnalysis];
    
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupData {
    
}

- (void)setupLayout {
    
}

- (void)privateMethod {
    SKGCDTestObj *obj = [[SKGCDTestObj alloc]init];
//    [obj createSerialQueue];
//    [obj createConcurrentQueue];
//    [obj createDispatchBarrierAsync];
//    [obj createDispatchNotify];
//    [obj createDeadLock];
//    [obj queueSetSpecificFunc];
//    [obj reentrantMethod];
//    [obj syncMainThread];
    
    
    
}

- (void)threadMethodListAction {
    SKGCDPrintObj *printObj = [[SKGCDPrintObj alloc]init];

}

- (void)threadMethodAction {
    SKGCDObj *obj = [[SKGCDObj alloc]init];
}

- (void)gcdSafeAnalysis {
    SKGCDSafeAnalysis *safe = [[SKGCDSafeAnalysis alloc]init];
    
}

@end
