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

@property (nonatomic, strong) NSTimer *schemeTimer;

@property (nonatomic, assign) NSInteger  timeValue;

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
    self.timeValue = 0;
}

- (void)setupLayout {
    
}

- (void)methodActions {
    
    [self runloopState];
}

- (void)runLoopTest {
    SKRunLoopObject *runloopObj = [[SKRunLoopObject alloc]init];
    [runloopObj runtimeTest];
}

- (void)runloopState {
    
}

- (NSTimer *)schemeTimer {
    if (!_schemeTimer) {
        _schemeTimer = [NSTimer timerWithTimeInterval:5.0f target:self selector:@selector(printLog) userInfo:nil repeats:YES];
    }
    return _schemeTimer;
}

- (void)printLog {
    self.timeValue ++;
    NSLog(@"timeValue is  %@",@(self.timeValue));
}

@end
