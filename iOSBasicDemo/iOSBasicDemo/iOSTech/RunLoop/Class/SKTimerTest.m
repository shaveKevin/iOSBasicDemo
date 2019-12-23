
//
//  SKTimerTest.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/14.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKTimerTest.h"
#include <mach/mach.h>
#include <mach/mach_time.h>
#import <QuartzCore/CADisplayLink.h>
#import <DSTBaseDevUtils/DSTWeakProxy.h>

static const uint64_t NANOS_PER_USEC = 1000ULL;
static const uint64_t NANOS_PER_MILLISEC = 1000ULL * NANOS_PER_USEC;
static const uint64_t NANOS_PER_SEC = 1000ULL * NANOS_PER_MILLISEC;
 
static mach_timebase_info_data_t timebase_info;

static uint64_t nanos_to_abs(uint64_t nanos) {
    return nanos * timebase_info.denom / timebase_info.numer;
}


static NSMutableDictionary *timerDict;
static dispatch_semaphore_t semphore;

@interface SKTimerTest  ()

@property (nonatomic, assign) NSInteger  timeValue;

@property (nonatomic, strong) CADisplayLink *displayLink;

@property(nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) dispatch_source_t sourceTimer;

@end

//面试题解答：NSTimer有什么缺点?定时器除了用NSTimer意外还有其他的方式没？
/*
 答：定时器的缺点：
 1.精确度不够，由于定时器在一个runloop中被检测一次，所以在这一次的runloop中如果做了耗时的操作，当前runloop持续的时间超过了定时器的间隔时间，那么下次执行的时间就会被延后。这就导致了精度的问题。解决方法:可以在子线程处理数据，然后在主线程进行打印或者做其他与UI相关的处理。
  2. runloop模式的影响，由于runloop有在scrollview滑动的时候有另外一种模式 如果设置runloop模式的时候设置成default模式 那么在scrollview滚动的时候当前定时器会暂停执行。直到滑动结束runloop模式切换为default的时候才会恢复。
   3.循环引用。具体原因见： https://t.zsxq.com/mEMZrfU
 

 通过以下三种方式也可以实现NSTimer mach_absolute_time() CADisplayLink 以及GCD的dispatch_source_t
 1.使用mach_absolute_time()来实现更高精度的定时器。iPhone上有这么一个均匀变化的东西来提供给我们作为时间参考，就是CPU的时钟周期数（ticks）。 通过mach_absolute_time()获取CPU已运行的tick数量。将tick数经过转换变成秒或者纳秒，从而实现时间的计算。见matchAbsoluteTime。  理论上来说这个是最精准的定时器->纳秒级别的定时器。
    2.CADisplayLink是一个频率能达到屏幕刷新率的定时器类。iPhone屏幕刷新频率为60帧/秒，也就是说最小间隔可以达到1/60s。 所以一般来说这个设置的时候是以1s为基准的。CADisplayLink的使用也需要手动加到runloop中，使用的时候仍然需要注意循环引用。
    3.GCD实现使用了dispatch_source_t 来实现，使用的时候注意要创建、配置、开启timer。由于这里调用的时候用的是block 所以要注意block产生的循环引用问题。
 
 CADisplayLink 和NSTimer 的不同之处：
 1.原理不同 CADisplayLink以特定模式注册到runloop后，每当屏幕显示内容刷新结束的时候，runloop就会向CADisplayLink指定的target发送一次指定的selector消息， CADisplayLink类对应的selector就会被调用一次。
 NSTimer以指定的模式注册到runloop后，每当设定的周期时间到达后，runloop会向指定的target发送一次指定的selector消息。
 
 2.精确度不同
  NSTimer的精确度就显得低了点，比如NSTimer的触发时间到的时候，runloop如果在忙于别的调用，触发时间就会推迟到下一个runloop周期。更有甚者，在OS X v10.9以后为了尽量避免在NSTimer触发时间到了而去中断当前处理的任务，NSTimer新增了tolerance属性，让用户可以设置可以容忍的触发的时间范围。
 
 3.使用场合不同
 CADisplayLink使用场合相对专一，适合做界面的不停重绘，比如视频播放的时候需要不停地获取下一帧用于界面渲染。
 NSTimer的使用范围要广泛的多，各种需要单次或者循环定时处理的任务都可以使用。
 
 总结：一般来说NSTimer已经足够用，如果想要精度高一点的可以使用gcd的或者CADisplayLink，但是CADisplayLink 有限制。刷新频率根据系统的屏幕刷新频率，这也限制了使用的场景。mach_absolute_time 这个精确度更高一点一般用于计算函数的执行时间。
 
 CADisplayLink和NSTimer会对target产生强引用，如果target又对他们产生强引用，就会产生循环引用。
 */
 //
@implementation SKTimerTest

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerDict = [NSMutableDictionary dictionary];
        semphore = dispatch_semaphore_create(1);
    });
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.timeValue = 0;
    }
    return self;
}


- (void)matchAbsoluteTime {
    
    if (self.timeValue >= 5) {
        return;
    }
    waitSeconds(5);
    [self addMethod];
    [self matchAbsoluteTime];
}

- (void)testCADisplayLink {
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)testGCDTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
          _timer = nil;
      }
    // 创建主队列
      dispatch_queue_t queue = dispatch_get_main_queue();
      //创建一个定时器（dispatch_source_t本质上还是一个OC对象）
      self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
      //设置定时器的开始时间
      dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0*NSEC_PER_SEC));
    //设置定时器的时间间隔
      uint64_t interval = (uint64_t)(5.0*NSEC_PER_SEC);
    // 设置当前timer为执行者
      dispatch_source_set_timer(self.timer, start, interval, 0);
      //设置定时器定时方法回调
      __weak typeof(self) weakSelf = self;
      dispatch_source_set_event_handler(weakSelf.timer, ^{
          //定时器需要执行的操作
          [weakSelf addMethod];
      });
      //启动定时器（默认是暂停）--- 注意它暂停之后其实就是销毁了。。。重新开启的时候需要重新加载
      dispatch_resume(self.timer);
}

- (void)paustTimer {
    
    if (_timer) {
        dispatch_cancel(_timer);
        _timer = nil;
        NSLog(@"开始销毁displayLink...");
    } else {
        NSLog(@"定时器已销毁");
    }
}


- (void)addMethod {
    self.timeValue++;
    NSLog(@"timeValue = %@",@(self.timeValue));
    if (_displayLink) {
        if (self.timeValue >= 5) {
            [self endTimer];
        }
    }
    
    if (_timer) {
        if (self.timeValue >= 5) {
            [self paustTimer];
        }
    }
}

void waitSeconds(int seconds) {
    mach_timebase_info(&timebase_info);
    uint64_t time_to_wait = nanos_to_abs(seconds * NANOS_PER_SEC);
    uint64_t now = mach_absolute_time();
    mach_wait_until(now + time_to_wait);
}

// 依然需要注意循环引用
// 保证调用频率和屏幕的刷帧频率一致，60fps
- (CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:[DSTWeakProxy proxyWithTarget:self] selector:@selector(addMethod)];
        _displayLink.frameInterval = 60;
    }
    return _displayLink;
}

- (void)endTimer {
    if (_displayLink) {
        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink invalidate];
        _displayLink = nil;
        NSLog(@"开始销毁displayLink...");
    } else {
        if (_timer) {
            [self paustTimer];
        } else {
            NSLog(@"定时器已销毁");
        }
    }
}

- (void)dealloc {
    [self endTimer];
}

+ (NSString *)executeTask:(void (^)(void))action startAt:(NSTimeInterval)start timeInterval:(NSTimeInterval)timeInterval repeats:(BOOL)repeats async:(BOOL)async {
    
    //  如果任务不存在。开始时间小于0. 时间间隔小于0并且重复定时器，那么不创建定时器返回为空。
    if(!action || start < 0 || (timeInterval < 0 && repeats))return nil;
    // 创建队列
    dispatch_queue_t queue = async?dispatch_get_global_queue(0, 0):dispatch_get_main_queue();
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              timeInterval * NSEC_PER_SEC, 0);
    // 加锁  字典的存取都要保证安全
    dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
    NSString *timerID = [NSString stringWithFormat:@"%zd",timerDict.count];
    timerDict[timerID] = timer;
    dispatch_semaphore_signal(semphore);
    dispatch_source_set_event_handler(timer, ^{
        action();
        // 如果不需要重复执行。那么就取消掉。定时器取消就是销毁。
        if (!repeats) {
            [self cancelTask:timerID];
        }
    });
    dispatch_resume(timer);
    return timerID;
}

+ (void)cancelTask:(NSString *)taskID {
    if (taskID.length == 0) return;
    dispatch_semaphore_wait(semphore, DISPATCH_TIME_FOREVER);
    dispatch_source_t timer = timerDict[taskID];
    if (timer) {
        dispatch_source_cancel(timer);
    }
    [timerDict removeObjectForKey:taskID];
    dispatch_semaphore_signal(semphore);
}

@end
