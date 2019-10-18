//
//  SKRunloopVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/20.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKRunloopVC.h"
#import "SKRunLoopObject.h"
#import <Masonry/Masonry.h>
#import <DSTBaseDevUtils/DSTWeakProxy.h>
#import "SKTimerTest.h"

@interface SKRunloopVC ()

@property (nonatomic, strong) NSTimer *schemeTimer;

@property (nonatomic, assign) NSInteger  timeValue;

@property (nonatomic, strong) SKTimerTest  *timerTest;


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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 1. 纳秒级定时器测试
    /*
    [test matchAbsoluteTime];
     2.DisplayLinkTest
       [self.timerTest testCADisplayLink];
     3. GCD test
     [self.timerTest  testGCDTimer];

     */

  
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *terminalBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    [terminalBtn setTitle:@"暂停按钮" forState:UIControlStateNormal];
    [self.view addSubview:terminalBtn];
    [terminalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.topMargin.mas_equalTo(20);
    }];
    [terminalBtn addTarget:self action:@selector(terminalTimer) forControlEvents:UIControlEventTouchUpInside];
    [terminalBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    UIButton *stopBtn   = [UIButton buttonWithType:UIButtonTypeCustom];
    [stopBtn setTitle:@"停止按钮" forState:UIControlStateNormal];
    [self.view addSubview:stopBtn];
    [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.mas_equalTo(20);
        make.left.equalTo(terminalBtn.mas_right).offset(100);
    }];
    [stopBtn addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchUpInside];
    [stopBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
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
// 暂停
- (void)terminalTimer {
    [self runloopState];
//    [self.schemeTimer setFireDate:[NSDate distantFuture]];
}
//停止(销毁定时器)-> 这里要注意 可能产生循环引用
// 注意这里invalidate 会停止timer 并且 将其从runloop中移除。
// 产生循环引用的原因主要是 timer的使用对象和timer timer 和runloop之间的循环引用

/*
 会产生循环引用。产生循环引用的链条是： 对象强引用timer  timer 强引用对象。。 并且runloop也引用了timer。 如果我们按照正常的像block一样解除循环引用的方法是行不通的。因为虽然对象对timer的引用为弱引用，但是timer对对象的引用却还是强引用。
 解决方法：参考yykit中的YYWeakProxy。
 它的原理是：对象-> timer -> proxy(这里的proxy继承自NSProxy)-> (消息转发)target -> 对象。
 这个时候target为弱引用。如果对象的引用计数为0了，那么target就会被置为nil。这样就打破循环引用了。
 可参考链接：https://juejin.im/post/5a30f86ef265da4325294b3b
 还有一种解决方法是：在vc中使用视图将要消失的时候 停掉定时器 并且置为nil。（在停掉定时器的时候，runloop也被移除）
 还有另外一种方式是 不用target 使用block的初始化方式。 这种缺点是iOS10+并且由于是block所以要处理block循环引用的问题。
  ```
 if (@available(iOS 10.0, *)) {
        self.schemeTimer = [NSTimer timerWithTimeInterval:1.0f repeats:YES block:^(NSTimer * _Nonnull timer) {
        }];
    } else {
        // Fallback on earlier versions
    }
  ```
 */
- (void)stopTimer {
    [self.schemeTimer invalidate];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 注意:这样写不保险，首先不能确定这里消失的时机 是否要停掉定时器.
  //   [self stopTimer];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self stopTimer];
}

- (void)runloopState {
    [self.schemeTimer fire];

}

- (NSTimer *)schemeTimer {
    if (!_schemeTimer) {
        _schemeTimer = [NSTimer timerWithTimeInterval:5.0f target:[DSTWeakProxy proxyWithTarget:self] selector:@selector(printLog) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_schemeTimer forMode:NSRunLoopCommonModes];
    }
    return _schemeTimer;
}

- (SKTimerTest *)timerTest {
    if (!_timerTest) {
        _timerTest = [[SKTimerTest alloc]init];
    }
    return _timerTest;
}
- (void)printLog {
    self.timeValue ++;
    NSLog(@"timeValue is  %@",@(self.timeValue));
}

- (void)dealloc {
    if (_schemeTimer) {
        _schemeTimer = nil;
        NSLog(@"已销毁 ===timer  %@",_schemeTimer);
    } else {
        NSLog(@"不存在");
    }
}
@end
