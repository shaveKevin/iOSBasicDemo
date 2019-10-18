//
//  SKBlockVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/20.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKBlockVC.h"
#import "BlockTest/BlockTest.h"
#import "BlockTest/NSObject+Add.h"
#import "BlockTest/TestModel.h"
#import "BlockTest/TestExpanded/TestExpand.h"
#import "BlockTest/TestExpanded/TestExpand+test.h"
#import "BlockTest/TestExpanded/TestExpand+Additions.h"
#import <mach/mach_time.h>
#import "BlockTest/RetainCycleModule.h"

typedef int(^MyBlockFive)(int a,int b);

typedef void(^MyBlockCycle)(int a,int b);

typedef void(^My_BlockCycle)(int a,int b);

@interface SKBlockVC ()

@property (nonatomic, strong) NSString *tempStr;

@property (strong) NSMutableArray *dataArry;

@property (nonatomic, copy) TestModel *model;
// 用copy来修饰
@property (nonatomic, copy) MyBlockFive blockFive;

@property (nonatomic, strong) MyBlockCycle  blockCycle;

@property (nonatomic, assign) NSInteger  ageTest;

@property (nonatomic, copy) int(^sumOf)(int a, int b);

@property (nonatomic, assign) BOOL is_canFly;

@property (nonatomic, strong) My_BlockCycle  block_Cycle;

@property (nonatomic, strong) NSNotification *notification;

@end

@implementation SKBlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self blockTestAutoInLine];
    self.view.backgroundColor = [UIColor whiteColor];
    [self test_canRetainCycle];
    // 系统定义的block 是否需要检测循环引用
    [self testGCD];
    // block 所在内存位置
    [self blockLocation];
    
}

- (void)myBlockOne {
    
    //1. 定义  闭包 = 一个函数 或指向函数的指针 + 该函数执行的外部的上下文变量 也就是自由变量 block 是oc对于闭包的实现。
    void (^MyBlockOne)(void) = ^(void){
        NSLog(@"无参数,无返回值");
    };
    // 调用
    MyBlockOne();
    // 2. 有参数无返回值
    // 前面的是返回值类型 void为空 int a 代表的是参数的类型
    void (^MyBlockTwo)(int a) = ^(int a) {
        NSLog(@"有参数无返回值,值为:%@ ",@(a));
    };
    MyBlockTwo(20);
    // 3. 有参数有返回值
    // 前面为返回值类型 ^为函数名的标识 后面跟着函数名
    int(^MyBlockThree) (int a) = ^(int a) {
        NSLog(@"有参数有返回值,值为:%@ ",@(a));
        return  2 * a;
    };
    NSLog(@"最后的值为:%@ ",@(MyBlockThree(30)));
    // 4 .无参数有返回值
    NSString *(^MyBlockFour)(void) = ^(void) {
        return @"你是我的温柔";
    };
    NSLog(@"无参数有返回值:%@",MyBlockFour());
    // 5. 实际开发中的block  定义一个有返回值block 参数为a和b 这样的block可以当做参数使用
//    typedef int(^MyBlockFive)(int a,int b);
   // 这里是block的实现
    self.blockFive = ^int(int a, int b) {
        // TODO
        return  a + b;
    };
    NSLog(@"开发中使用的block的值是:%@",@(self.blockFive(30,50)));
}


- (void)blockAutoConn {
    /*
       block中的变量截取  对于block外的变量引用。block默认是将其复制到block中的数据结构中来实现访问的。
       也就是说block的自动变量截取只针对内部使用的自动变量，不在block中使用则不截获，截获的变量会存储在block内部结构
       会导致block体积变大。特别要注意的是：默认情况下block只能访问不能修改局部变量的值。
     */
    // 定义一个block
    typedef void(^myBlock)(void);
  __block  int age = 10;
    self.ageTest = 10;// block  不会捕获全局变量
    NSLog(@"====block使用前===%p",&age);
    NSLog(@"====block使用前ageTest===%p",&_ageTest);

    // block 实现
    myBlock block = ^(){
        NSLog(@"====block中===%p",&age);
        NSLog(@"== age is %@",@(age));
        self.ageTest = 100;
        NSLog(@"== ageTest is %@",@(self.ageTest));
        NSLog(@"====block使用中ageTest===%p",&self->_ageTest);
    };
    // 对变量赋值
    age =  18;
    NSLog(@"====block外===%p",&age);
    NSLog(@"== ageTest的值 is %@",@(self.ageTest));
    NSLog(@"====block使用外ageTest===%p",&self->_ageTest);

// 通过打印age 的地址可以发现，block中的age其实已经不是原来的age了。并且是在block实现的时候进行捕获。捕获之后存储在block内部结构中( clang之后可以看出)
// 在block内部中如果对变量进行赋值的时候会发现报错 Variable is not assignable (missing __block type specifier)
    // self.ageTest中 全部变量不被捕获。 通过xcrun 可以看出。 当然通过打印self.ageTest的地址也可以看出.
    // 局部变量被捕获，(block中的变量没有用__block 修饰的话 在block 外部地址是不变的。而在内部被捕获,地址发生改变(改变仅仅发生在block内部)
    // 如果用__block修饰的话
    //全局变量没有被捕获(因为打印出来的地址不变)
    //调用block
    block();
    /*
     
     struct __ViewController__blockAutoConn_block_impl_0 {
     struct __block_impl impl;
     struct __ViewController__blockAutoConn_block_desc_0* Desc;
     int age;
     ViewController *self;
     __ViewController__blockAutoConn_block_impl_0(void *fp, struct __ViewController__blockAutoConn_block_desc_0 *desc, int _age, ViewController *_self, int flags=0) : age(_age), self(_self) {
     impl.isa = &_NSConcreteStackBlock;
     impl.Flags = flags;
     impl.FuncPtr = fp;
     Desc = desc;
     }
     };
     */

}

- (void)blockBlock {
    
    typedef void(^myBlock)(void);
    __block int age = 10;
   TestModel *testModel = [[TestModel alloc]init];
    
    // block 实现 对于__block 修饰的变量在block中复制的是其引用的地址来访问实现的。此时值是可以被更改的。对age 添加__block之后，发生了变化
    // 在不加__block之前只是一个普通变量 int age 而加了__block 之后变成了一个结构体 __Block_byref_age_0
    NSLog(@"====block前===%p  age is %@",&age,@(age));
    NSLog(@"====block前 ===testModel %p  testModel is %@",&testModel,testModel);

    myBlock block = ^(){
        age = 50;
        NSLog(@"====block中重新赋值===%p  age is %@",&age,@(age));
        NSLog(@"====block中 ===testModel %p  testModel is %@",&testModel,testModel);
    };
    age = 20;
    block();
    NSLog(@"====block后===%p  age is %@",&age,@(age));
    NSLog(@"====block中 ===testModel %p  testModel is %@",&testModel,testModel);

}
/*
 struct __ViewController__blockBlock_block_impl_0 {
 struct __block_impl impl;
 struct __ViewController__blockBlock_block_desc_0* Desc;
 TestModel *testModel;
 __Block_byref_age_0 *age; // by ref
 __ViewController__blockBlock_block_impl_0(void *fp, struct __ViewController__blockBlock_block_desc_0 *desc, TestModel *_testModel, __Block_byref_age_0 *_age, int flags=0) : testModel(_testModel), age(_age->__forwarding) {
 impl.isa = &_NSConcreteStackBlock;
 impl.Flags = flags;
 impl.FuncPtr = fp;
 Desc = desc;
 }
 };
 */

- (void)blockCopyAction {
    // block的存储域以及copy操作
    //在C++ 中存在栈区(stack)  堆区(heap) 全局区/静态区(初始化/非初始化) 文字常量区  程序代码区
    // block 有三种类型
    //全局块(_NSConcreteGlobalBlock) 数据区域
    //栈块(_NSConcreteStackBlock)
    //堆块(_NSConcreteMallocBlock)
    // 全局块存在于全局内存中，相当于单例。
    // 栈块存在于栈内存中，超出其作用域马上被销毁
    // 堆块存在于堆内存中，是一个带有引用计数的对象，需要自行管理其内存。
    // 简而言之，存储在栈中的block就是栈块，存储在堆中的就是堆块，既不在栈中也不在堆中的块就是全局块。
    /*
     -----------------------------------------
                        栈
     -----------------------------------------
                        堆
     -----------------------------------------
                    .data(区)
                     (数据区域)
     -----------------------------------------
                    .text(区)
                     (程序区域)
     -----------------------------------------
     // 遇到一个block怎么判断其存储位置呢？
     1. block不访问外界变量(包括栈中和堆中的变量)
     block既不在栈中又不在堆中，在代码段中，arc和mrc下都是如此，此时为全局块
     2. block访问外界变量
     mrc环境下，访问外界变量的block默认存储在栈中，
     arc环境下，访问外界变量的block默认存储在堆中，(实际上也是放在栈区，然后arc情况下又自动拷贝到堆区，)自动释放。

     ARC下，访问外界变量的block为什么要自动从栈区拷贝到堆区呢？
     
     答：栈上的block，如果其所属的变量作用域结束，该block就被废弃，如同一般的自动变量。当然block中的__block变量也同时被废弃。
     为了解决栈块在其变量作用域结束之后被废弃(释放)的问题，我们需要把block复制到堆中，延长其生命周期。开启arc的时候，
     大多数啊情况下编译器会恰当地判断是否要将block从栈赋值到堆，
     如果有，自动生成将block从栈上复制到堆上的代码。block的复制执行操作是copy实例方法。block只要调用了copy方法，栈块就会变成堆块。
     block变量作用域结束时，栈上的__block变量和block一同被废弃。复制到堆上的__block变量和block在变量作用域结束时不受影响。
     
     typedef int(^blk_t)(int);
     blk_t  func(int rate) {
     return ^{
     (int count) {
     return rate* count;
     };
     }
     };
     
    分析可知：上面的函数返回的block是配置在栈上的。所以返回函数调用方法时，
     block变量作用域就结束了。block会被释放掉，但是在arc下有效，
     因为在这种情况下，编译器会自动完成复制。
     
     在非arc情况下则需要开发者调用copyd方法手动复制，现在基本上都是在用arc，所以这种复制内容不再研究。
     
     将block从栈上复制到堆上相当消耗CPU，所以当block设置在栈上也能够使用时，就不要复制了。因为此时的复制只是在浪费CPU资源。
     block的复制操作执行的是copy实例方法，不同类型的block使用copy方法的效果如下：
     
     block 类型                   副本源的配置存储区域         复制效果
     
     _NSConcreteStackBlock                栈              从栈复制到堆
     
     _NSConcreGlobalBlock              程序的数据区域        什么也不做
 
     _NSConcreteMallocBlock               堆              引用计数增加
     
     
     从上面可以知道，block在堆中的copy会造成引用计数增加，这与其他的OC对象是一样的
     虽然block在栈中也是以对象的身份存在的，但是栈块没有引用计数，因为不需要，栈内的内存由编译器自动分配释放。
     
     不管block存储域在何处，用copyg方法复制都不会引起任何问题，在不确定时调用copy方法即可。
     在arc有效的时候，多次调用copy方法完全没有问题。
     blk = [[[[block copy]copy]copy]copy];
     经过多次复制，变量blk仍然持有block的强引用，该block不会被废弃。
     */


}

- (void)printCopyRetainCount {
// 因为这个没有初始化 所以为NULL  bt 命令的使用打印出堆栈的信息  bt all 打印出所有堆栈的信息
    self.blockFive = ^int(int a, int b) {
        // TODO
        return  a + b;
    };
  // 打印出引用计数 使用copy copy  不会影响其引用计数 retain count = 1  这个只是在实现的时候才会有retaincount
 printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)([[self.blockFive copy] copy])));
    
}

- (void)blockForward {
    //  在copy操作之后，既然__block变量也被copy到堆上去了，那么访问该变量的是访问栈上的还是堆上的呢？
    /*
     栈
     __block变量用结构体
     __forwarding  指向自己本身的指针
     
      复制到堆上以后
     
     栈
     __block变量用结构体
     __forwarding 指向复制到堆上的__block变量用结构体的指针
     
     堆
     __block变量用结构体
     __forwarding 指向本身的指针
     
     通过__forwarding无论是在block中还是在block外访问__block变量，也不管该变量在栈上还是堆上
     都能顺利地访问同一个__block变量
     */
}

- (void)retainCycleIML {
    // 这个类将block作为自己的属性变量。然后该类在block的方法体中又使用了该类本身
    //Capturing 'self' strongly in this block is likely to lead to a retain cycle  运行直接报警告
    __weak typeof (self)weakSelf = self;
    self.blockCycle = ^(int a, int b){
        [weakSelf testTimeCaluate];
    };
    // 这种情况下不会产生循环引用
    typedef void(^MyBlockCycleOne)(int a,int b);
    MyBlockCycleOne cycleOne = ^(int  a, int b) {
        [self testTimeCaluate];
    };
    //循环引用的解决办法：
    //1.arc下，使用__weak来打破循环引用
    //2.在mrc情况下，使用__block __block typeof(self)blockSelf = self;
    RetainCycleModule *moudle = [[RetainCycleModule alloc]init];
    // 如果不执行这个block 那么里面声明的 tep就不会释放 那么内存泄漏就会一直存在(就是一直没释放)
    [moudle excuteBlock];
    
}

- (void)blockExample {
    // 1.block 作为变量
    int (^sum)(int, int);//定义一个block变量sum
    // 一般来说返回值省略 sum = ^(int a, int b){ return  a * b;};
    sum = ^int(int a, int b) {
        return a * b;
    };
    NSLog(@"sum is === %@",@(sum(20,30)));
    // 2.block作为属性
    typedef int (^BlockProperty)(int,int);
    BlockProperty  block = ^(int a , int b) {
        return a *a * b * b;
    };
    NSLog(@"block is === %@",@(block(2,3)));
    // 作为对象的属性声明，copy后block会转移到堆中和对象一起；
  //  @property (nonatomic,copy) BlockProperty blockTest; // 使用typedef
  //  @property (nonatomic,copy) int (^sum)(int, int); // 不使用typedef

    self.sumOf = ^int(int a, int b) {
        return a / b;
    };
    NSLog(@"不使用typedef=== %@",@(self.sumOf(10, 2)));
    
}

- (void)testBlockHaha {
    // 调用
    [self testTimeConsume:^{
        // 无参数无返回值
        NSLog(@"无参数无返回值");
    }];
    
    [self testTimeConsumeOne:^(NSString *name) {
        NSLog(@"name  到底是啥的===%@",name);
    }];
}

- (CGFloat)testTimeConsume:(void(^)(void))middleBlock{
    CFTimeInterval startTime = CACurrentMediaTime();
    middleBlock();
    CFTimeInterval endTime = CACurrentMediaTime();
    return endTime - startTime;
}

- (CGFloat)testTimeConsumeOne:(void(^)(NSString *name))middleBlock{
    CFTimeInterval startTime = CACurrentMediaTime();
    middleBlock(@"俺有参数");
    CFTimeInterval endTime = CACurrentMediaTime();
    return endTime - startTime;
}


- (void)blockCallBack {
    // block回调是关于block最常用的内容，比如网络下载，我们可以用block实现下载成功与失败的回调的反馈。
    // 开发者在block没有发布之前，实现回基本是通过代理的方式实现的。比如负责网络请求的NSURLConnection类，通过多个协议方法实现了请求中的事件处理，
    //而在最新的环境下，使用的NSURLSession已经采用block的方式处理任务请求了。各种第三方的网络请求框架也都在使用block进行回调处理.
    // 这种转变很一部分原因在于block使用简单。逻辑清晰，灵活等原因。
   // 例如：DownloadManager类
    
}

- (void)blockTestAutoInLine {
    
    typedef int (^blk_t)(int);
    for (int i = 0; i < 10; i ++) {
        blk_t  blt= ^int(int a) {
            return (a * i);
        };
        blt(2);
    }
    int k;
    for (int i = 0; i < 10; i ++) {
        k = i;
        blk_t blk = ^(int m) {
            return m;
        };
        blk(k);
    }
    
    //__block变量存储域
    // 一个block 从栈复制到堆上的时候，使用的所有的__block变量也都会复制到堆上并被block持有。
    //若此时__block变量已经在堆上，则被该block持有。
    // 若配置在堆上的block被废弃，那么她所有的__block变量也就被释放。
    // 下面代码执行之后 retain count = 1

    __block int val = 0;
    void (^blk)(void) = [^(){
        ++val;
    } copy];
    ++val;
    blk();
    printf("retain count = %ld\n",CFGetRetainCount((__bridge CFTypeRef)(blk)));
    //利用copy方法复制使用了__block变量中的block语法，于是二者从栈复制到堆上。
    
    id array= [NSMutableArray arrayWithCapacity:3];
    typedef void (^blk_m)(id);

    blk_m blm = ^(id obj) {
        [array addObject:obj];
        NSLog(@"array count====%@",@([array count]));
    };
    blm([[NSObject alloc]init]);
    blm([[NSObject alloc]init]);
    blm([[NSObject alloc]init]);
    //array count====1 array count====2 array count====3
    // 这意味着在赋值给变量array的对象在超超出其作用域的时候依然存在。
    // 什么时候栈上的block会复制到堆上。
    //. 1.调用block的copy实例方法。
    //. 2.将block作为函数参数返回值返回时，编译器会自动进行copy操作。
    //. 3.将block赋值给附有__strong修饰符id类型的类或block类型的成员变量
    //. 4.在方法名中含有usingblock的cocoa框架方法或GCD中的api传递的block时
    //. block从栈复制到堆上的时候copy方法被调用。
    //. 释放复制到堆上的block 谁都不持有block而使其被废弃的是偶调用dispose函数。相当于dealloc实例方法。
    //（如果没人持有就放弃走dealloc方法）
    // 如果block不复制到堆上，则其不会持有截获的对象，对象会随着变量作用域的结束而结束
    // 野指针是指的是没有初始化的指针
    // 悬垂指针指的是使用的时候已经被释放的指针。
    
}


- (void)testTimeCaluate {
    
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent();
    CFAbsoluteTime endTime = (CFAbsoluteTimeGetCurrent() - startTime);
    NSLog(@"TIME  IS  : %f ms", endTime * 1000.0);
    
}

- (void)timeOfMach {
    mach_timebase_info_data_t timebase;
    mach_timebase_info(&timebase);
    uint64_t start = mach_absolute_time();
    uint64_t end = mach_absolute_time();
    uint64_t cost = (end - start) * timebase.numer / timebase.denom;
    NSLog(@"方法耗时: %f ms",(CGFloat)cost / NSEC_PER_SEC * 1000.0);
}

- (void)testExpandedProperty {
    TestExpand *expand = [[TestExpand alloc]init];
    expand.mustProperty = @"99999";
    [expand testExpanded];
    NSLog(@"mustProperty====%@",expand.mustProperty);
}


- (void)tempArrayTemp {
    
    TestModel *model = [[TestModel alloc]init];
    //shavekevin 这个常量存在常量区域 所以是__NSConstantStringImpl
    model.name = @"shavekevin";
    NSMutableArray *array= [NSMutableArray arrayWithObjects:@"1",model,@2,nil];
    [self testArray:array];
    
}
// 转成cpp文件是这样的。 通过objc_msgSend 这个函数进行方法调用和赋值
/*
 static void _I_ViewController_tempArrayTemp(ViewController * self, SEL _cmd) {
 TestModel *model = ((TestModel *(*)(id, SEL))(void *)objc_msgSend)((id)((TestModel *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("TestModel"), sel_registerName("alloc")), sel_registerName("init"));
 ((void (*)(id, SEL, NSString * _Nonnull))(void *)objc_msgSend)((id)model, sel_registerName("setName:"), (NSString *)&__NSConstantStringImpl__var_folders_b0_wtsz92hn2qg2znkty6jcjtj40000gn_T_ViewController_4ed715_mi_0);
 NSMutableArray *array= ((NSMutableArray * _Nonnull (*)(id, SEL, ObjectType _Nonnull, ...))(void *)objc_msgSend)((id)objc_getClass("NSMutableArray"), sel_registerName("arrayWithObjects:"), (id _Nonnull)(NSString *)&__NSConstantStringImpl__var_folders_b0_wtsz92hn2qg2znkty6jcjtj40000gn_T_ViewController_4ed715_mi_1, (TestModel *)model, ((NSNumber *(*)(Class, SEL, int))(void *)objc_msgSend)(objc_getClass("NSNumber"), sel_registerName("numberWithInt:"), 2), __null);
 ((void (*)(id, SEL, NSMutableArray *))(void *)objc_msgSend)((id)self, sel_registerName("testArray:"), (NSMutableArray *)array);
 }
 
 }
 // 后面跟随的是值以及长度
 static __NSConstantStringImpl __NSConstantStringImpl__var_folders_b0_wtsz92hn2qg2znkty6jcjtj40000gn_T_ViewController_4ed715_mi_0 __attribute__ ((section ("__DATA, __cfstring"))) = {__CFConstantStringClassReference,0x000007c8,"shavekevin",10};
 static __NSConstantStringImpl __NSConstantStringImpl__var_folders_b0_wtsz92hn2qg2znkty6jcjtj40000gn_T_ViewController_4ed715_mi_1 __attribute__ ((section ("__DATA, __cfstring"))) = {__CFConstantStringClassReference,0x000007c8,"1",1};
 */


- (void)testArray:(NSMutableArray *)array {
    // 如果self.dataArry 用copy修饰那么 就默认这个数组是不可变的。用不可变的数组remove元素的时候就闪退。
    // *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSArrayI removeObjectAtIndex:]: unrecognized selector sent to instance 0x6000034b05a0'
    
    //  xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc ViewController.m -o ViewController-arm64.cpp
    self.dataArry = array;
    [self.dataArry removeObjectAtIndex:0];
    // 使用自旋锁的目的是确保临界区只有一个线程可以访问，自旋锁的实现思路很简单，理论来说只要定义一个全局变量，用来表示锁可可用情况即可，自旋锁是使用忙等机制如果在临界区域执行时间过长，不建议使用自旋锁，因为在while循环中，线程处于忙等状态。拜拜浪费CPU时间，最终因为超时被操作系统抢占时间片。
    

    
    // 修饰的时候用了自旋锁 也就是atomic  还在创建的时候会生产一些额外的代码用于帮助编写多线程程序，这会带来性能问题，通过声明nontaomic可以节省这些虽然很小但是不必要的开销。
    // 在默认情况下，由编译器所合成的方法会通过锁定机制确保其原子性如果属性具备 nonatomic 特质，则不使用自旋锁。请注意，尽管没有名为“atomic”的特质(如果某属性不具备 nonatomic 特质，那它就是“原子的”(atomic))。
    // 在iOS开发中，你会发现，几乎所有属性都声明为 nonatomic。
    // 一般情况下并不要求属性必须是“原子的”，因为这并不能保证“线程安全” ( thread safety)，若要实现“线程安全”的操作，还需采用更为深层的锁定机制才行。例如，一个线程在连续多次读取某属性值的过程中有别的线程在同时改写该值，那么即便将属性声明为 atomic，也还是会读到不同的属性值。
    
    //因此，开发iOS程序时一般都会使用 nonatomic 属性。但是在开发 Mac OS X 程序时，使用 atomic 属性通常都不会有性能瓶颈。
    
}

- (void)OSSpinLock {
    /*
     BOOL lock = false;// 默认所示打开的，默认没加锁
     do {
     
     } while (test_and_set(&lock)); // test_and_set 这是一个原子操作
     
     Critical section;// 临界区
     lock = false;// 释放当前锁，这样别的线程可以进入临界区
     Remainder section;// 不需要锁保护的代码
     */
    //
    
}

- (void)testStr{
    
    self.tempStr = @"哈哈哈哈";
    NSMutableString *muteableStr = [[NSMutableString alloc] initWithString:@"this is mutable str"];
    self.tempStr = muteableStr;
    NSLog(@"====totalStr===%@",self.tempStr);
    
}

// 链式编程
- (void)linkTest {
    NSInteger result = [NSString sk_makeTool:^(BlockTool *make) {
        make.add(30).add(50).minus(20);
    }];
    NSLog(@"%ld",(long)result);
    
}

//- (void)blockTest {
//    BlockTest *block =[[BlockTest  alloc]init];
//    block.block0 = ^{
//        NSLog(@"执行block0");
//    };
//    block.blockHaha = ^(id  _Nonnull sender) {
//        NSLog(@"执行block哈哈哈  ====%@",sender);
//    };
//
//    block.ActionBlock2 = ^NSString * _Nonnull(NSString * _Nonnull argu1, NSString * _Nonnull argu2) {
//        return [NSString stringWithFormat:@"%@=======%@",argu1,argu2];
//    };
//    [block actionBlock];
//    [block testBlock1:^(NSString * _Nonnull str) {
//        NSLog(@"……%@",str);
//    }];
//}

- (void)testLength {
    
    NSInteger numberofMax = [self lengthOfLongestSubstring:@"bacdbbb"];
    NSLog(@"====%ld",(long)numberofMax);
}

// break 在循环块中的作用是跳出当前正在循环的循环体。 contunue 结束本次循环 比如for循环中执行到第几次只有满足条件之后不继续往下走了。后面的次数中可能还有不满足条件的继续走
- (NSInteger)lengthOfLongestSubstring:(NSString *)str{
    
    NSInteger size,i=0;
    NSInteger j,k= 0;
    NSInteger max = 0;
    size= str.length;
    for (j = 0; j < size; j++) {
        for (k = i; k < j; k++) {
            NSString *str1 = [str substringWithRange:NSMakeRange(k, 1)];
            NSString *str2 = [str substringWithRange:NSMakeRange(j, 1)];
            if ([str1 isEqualToString:str2]) {
                i  = k+1;
                break;
            }
        }
        NSLog(@"循环第%@遍,i 为%@, k为%@,  max 为%@",@(j), @(i) ,@(k),@(max));
        if (j-i+1 > max) {
            max = j-i+1;
        }
    }
    return max;
}




- (void)test_canRetainCycle {
    __weak typeof(self)weakSelf = self;
    
    self.block_Cycle = ^(int a, int b) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        // 注意 如果这里用weak来i调用会报错：Dereferencing a __weak pointer is not allowed due to possible null value caused by race condition, assign it to strong variable first. 意思是：对一个weak‘指针的解引用是不允许的，因为可能在竞态条件下变成null，所以把他定义成strong属性
        strongSelf->_is_canFly = YES;
    };
    self.block_Cycle(2, 3);
}


- (void)testGCD {
    
    // 这种不会产生循环引用  因为只有block持有self  而self 并没有持有block 所以不会产生循环引用。
    dispatch_async(dispatch_get_main_queue(), ^{
        [self linkTest];
    });
    __weak typeof(self)weakSelf = self;
    // 注意这里会产生循环引用，因为self 持有了block block 也持有了self;
    _notification = [[NSNotificationCenter defaultCenter ] addObserverForName:@"test" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf linkTest];

    }];
    
}

- (void)blockLocation {
    __block int a = 10;
    NSLog(@"定义前a的地址为： %p a的值为%@",&a,@(a));// 栈区
    void(^foo)(void) = ^ {
        a = 15;
        NSLog(@"block中a的地址为： %p a的值为%@",&a,@(a));// 堆区
    };
    NSLog(@"定义后a的地址为： %p  a的值为%@",&a,@(a));// 堆区
    foo();
    NSLog(@"调用后a的地址为： %p a的值为%@",&a,@(a));// 堆区
    
    [self testBlockStack];
    
}

- (void)testBlockStack {
    
    // 打印%p为指针地址  %@ 后面用 &x  来修饰标识的是对象的地址
     NSMutableString *blockString = [NSMutableString stringWithString:@"echo"];
    NSLog(@"定义之前：------------------------------------\n blockString指向的堆中地址：%p；a在栈中的指针地址：%p", blockString, &blockString);
    void(^blockTest)(void) = ^{
        blockString.string = @"john  snow";
        NSLog(@"block内部：------------------------------------\n blockString指向的堆中地址：%p；a在栈中的指针地址：%p", blockString, &blockString);
        // 下面的这段代码会报错：Variable is not assignable (missing __block type specifier)
        // blockString = [NSMutableString stringWithString:@"雅俗共赏"];
    };
    blockTest();
    NSLog(@"调用之后：------------------------------------\n blockString指向的堆中地址：%p；a在栈中的指针地址：%p", blockString, &blockString);
    //打印的结果为：
     //定义之前：------------------------------------blockString指向的堆中地址：0x2838d4780；a在栈中的指针地址：0x16bb0f878
     //block内部:------------------------------------blockString指向的堆中地址：0x2838d4780；a在栈中的指针地址：0x2838d4830
     //调用之后：------------------------------------blockString指向的堆中地址：0x2838d4780；a在栈中的指针地址：0x16bb0f878
    // 这里有个疑问:为什么打印%p在堆上，打印%@用&修饰在栈上?
    // 这里的blockString已经由基本数据类型，变成了对象类型。block会对对象类型的指针进行copy。copy到堆中，但是并不会改变指针所指向的堆中的地址，所以在上面的代码中 block内部修改的实际是blockString指向的堆中的内容。
    
    // 上面说的不允许修改外部变量的值，这里说的外部变量 s值 值得是栈中指针的内存地址。栈是红灯区，堆才是绿灯区。不能修改的是“栈”不是：堆“。
    
}


- (void)dealloc {
    NSLog(@"delloc了");
}

@end
// 面试题解答：1.使用block时什么情况会发生引用循环，如何解决？
/*
 答： 如果在block中使用附有__strong修饰符修饰的对象类型自动变量，那么block从栈复制到堆时，该对象为block所持有。这样容易引起循环引用。
  简单的说：就是在一个对象中强引用了block，在block中又强引用了该对象，就会产生循环引用。(可参考方法:retainCycleIML)
  解决方法是：1.这个对象使用__weak或者__block修饰符之后再block中使用。 注意arc下用__weak mrc下用__block
          2.在block使用完之后 将block置为nil  例如将test_canRetainCycle 在 self.block_Cycle(2, 3); 执行之后加上self.block_Cycle = nil 也可解决循环引用的问题，但是如果block有一个方法并不是在block调用结束之后立即使用的，并且希望这个方法正确执行 那么这个方法就行不通了。只能采用第一种方式来解决。
 3. @weakly  @strongly
 其实weakly和strongly等价于
 @weakify(self) = @autoreleasepool{} __weak __typeof__ (self) self_weak_ = self;
 @strongify(self) = @autoreleasepool{} __strong __typeof__(self) self = self_weak_;


 例如：test_canRetainCycle中block外部的的__weak 和  block内部的__strong
 (其中加__weak的时候是为了在block内部使用的时候不会强引用当前对象，不会造成引用计数+1，防止了循环引用。而用__strong的目的是一旦进入block执行，假设不允许self在这个执行过程中释放，就需要加入strongself，block执行完毕之后这个strongself会自动释放，m不会存在循环引用问题，如果要在block内多次访问self，那么需要使用strongself)

 循环引用的检测可以参考FB开源的一个工具：FBRetainCycleDetector 腾讯在此基础上也封装了一个工具：MLeaksFinder  具体可以github搜索
 */
// 面试题解答：2.在block内如何修改block外部变量？
 
/*
 答：我们都知道：Block不允许修改外部变量的值，这里说的是外部变量的值，值得是栈中指针的内存地址，__block起到的作用是只要观察到该变量被block所持有。
    就将外部栈中的地址放到了堆中，进而在block内部也可以修改外部变量的值。
    Block不允许修改外部变量的值、apple这样设计。考虑到了block的特殊性。block是匿名内部类同样属于函数的范畴。变量进入到block，实际上已经改变了其作用域。在几个作用域进行切换的时候，如果不加上这样的限制，变量的可维护性就大大降低了。还有一种情况是，如果在block内部定义了临时变量，变量名字和外部的变量的名字相同。那么是不是被允许呢？正因为有这样的机制（不允许修改外部变量的值）所以这样的情景才能实现。 于是乎，栈区变成了红灯区，堆区变成了绿灯区。
 ```
 __block int a = 10;
  NSLog(@"定义前a的地址为： %p a的值为%@",&a,@(a));
  void(^foo)(void) = ^ {
      a = 15;
      NSLog(@"block中a的地址为： %p a的值为%@",&a,@(a));
  };
  NSLog(@"定义后a的地址为： %p  a的值为%@",&a,@(a));
  foo();
  NSLog(@"调用后a的地址为： %p a的值为%@",&a,@(a));
 打印结果为：
 定义前a的地址为： 0x16b92b958 a的值为10
 定义后a的地址为： 0x281594618  a的值为10
 block中a的地址为： 0x281594618 a的值为15
 调用后a的地址为： 0x281594618 a的值为15
 可以看出在block执行之前 block值没有发生改变，
 执行完block之后 block的值发生改变。
 定义前的变量存储在栈上，定义后的变量存储在堆上
 定义后和block内部的block地址是一样的。block内部的变量会被copy到堆区。block内部打印的地址也就是堆的地址。因而可以知道
 定义后打印的地址也是堆地址。
 看到这里不禁会问 你怎么知道打印的是堆地址？
 把定义前和定义后两个地址转换为10进制
 
       地址        16进制        10进制
 
   0x16b92b958   16b92b958     6099745112
   0x281594618   281594618     10760046104
 
 差值为 4660300992 大约 4444.40936279M
 
 因为堆地址要小于栈地址，又因为iOS 中一个进程中的栈区内存只有1M mac也只有8M，显然这个时候变量a已经在堆区了。

 这也充分说明了：变量a在定义前是在栈区，只要进入到block区域，就变成了堆区。这才是__block关键字的作用。
     
__block关键字修饰之后，int类型也从4个字节变成了32个字节，这是从Foundation框架malloc出来的。这也就证实了上面的结论。
 (改变的原因是堆栈地址的变更)
 ```
  NSMutableString *blockString = [NSMutableString stringWithString:@"echo"];
 NSLog(@"定义之前：------------------------------------\n blockString指向的堆中地址：%p；a在栈中的指针地址：%p", blockString, &blockString);
 void(^blockTest)(void) = ^{
     blockString.string = @"john  snow";
     NSLog(@"block内部：------------------------------------\n blockString指向的堆中地址：%p；a在栈中的指针地址：%p", blockString, &blockString);
     // 下面的这段代码会报错：Variable is not assignable (missing __block type specifier)
     // blockString = [NSMutableString stringWithString:@"雅俗共赏"];
 };
 blockTest();
 ```
 NSLog(@"调用之后：------------------------------------\n blockString指向的堆中地址：%p；a在栈中的指针地址：%p", blockString, &blockString);
 //打印的结果为：
  //定义之前：------------------------------------blockString指向的堆中地址：0x2838d4780；a在栈中的指针地址：0x16bb0f878
  //block内部:------------------------------------blockString指向的堆中地址：0x2838d4780；a在栈中的指针地址：0x2838d4830
  //调用之后：------------------------------------blockString指向的堆中地址：0x2838d4780；a在栈中的指针地址：0x16bb0f878
 // 这里有个疑问:为什么打印%p在堆上，打印%@用&修饰在栈上?
 // 这里的blockString已经由基本数据类型，变成了对象类型。block会对对象类型的指针进行copy。copy到堆中，但是并不会改变指针所指向的堆中的地址，所以在上面的代码中 block内部修改的实际是blockString指向的堆中的内容。
 
 // 上面说的不允许修改外部变量的值，这里说的外部变量的值 指的得是栈中指针的内存地址。栈是红灯区，堆才是绿灯区。不能修改的是“栈”不是：堆“。

 
 ```
 
 */

// 面试题解答：3.使用系统的某些block api（如UIView的block版本写动画时），是否也考虑引用循环问题？
/*
 答：不需要考虑。产生循环引用的原因是相互引用。系统的api是单向引用，不会产生循环引用的问题，但是使用gcd和通知中心的时候需要考虑。拿gcd来说，如果gcd内部使用了self，而gcd的其他参数是属性变量的话，那么需要考虑循环引用。会不会产生循环引用以及要不要处理循环引用的问题，主要还是看使用的时候有没有形成环，如果形成环。那就需要处理循环引用的问题。
 */

