//
//  SKKVCKVOVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKKVCKVOVC.h"
#import "KVOModel.h"
#import <objc/runtime.h>

// KVO - Key-Value- Observing 键值监听  用于监听某个对象中属性的改变
// KVC - Key-Value- Coding 键值编码 主要用于不调用setter方法就更改或者访问对象的属性，这只是在动态地访问或更改对象的属性，而不是在编译期。
@interface SKKVCKVOVC ()
@property (nonatomic, strong) KVOModel *kvoModel;
@end

@implementation SKKVCKVOVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setObjectMethod];
    
}

- (void)modelValueChange {
    
    KVOModel *model1 = [[KVOModel alloc]init];
    KVOModel *model2 = [[KVOModel alloc]init];
    NSLog(@"model1===%@", model1);
    model1.age = 2;
    model2.age = 2;
    // 这个时候打印model1的isa指向 我们可以看到:KVOModel
    // 这个时候打印model2的isa指向 我们可以看到:KVOModel
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [model1 addObserver:self forKeyPath:@"age" options:options context:nil];
    // 这个时候打印model1的isa指向类对象,我们可以看到:NSKVONotifying_KVOModel
    // 这个时候打印model2的isa指向类对象,我们可以看到:KVOModel
    model1.age = 10;
    model2.age = 10;
    [model1 removeObserver:self forKeyPath:@"age"];
    // 我们可以看到在对model的age进行监听的时候，model1对象所指向的类对象发生了改变，而没有添加监听的model2没有发生改变。
    /*
     model2：只关注model2的时候我们可以看到在对model2调用setAge的时候，首先找到对应的类KVOModel然后从类中找到setAge 方法进行调用。
     NSKVONotifying_KVOModel 这个类是
     
     */
}

- (void)nameChangeedMethod {
    //在设置观察者的时候。只要被观察的属性发生改变就会响应改变的方法(不论前后是不是值发生改变都会执行observe的方法)
    self.kvoModel = [[KVOModel alloc]init];
    NSLog(@"添加观察者之前： %@  %@",self.kvoModel ,object_getClass(self.kvoModel));
    self.kvoModel.name = @"shave";
    [self.kvoModel addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    NSLog(@"添加观察者之后： %@  %@",self.kvoModel ,object_getClass(self.kvoModel));
    self.kvoModel.name = @"shave";
    // 可以直接调用 这个时候name是kvoModel实例中的一个属性。这个时候把key改为_name 就不可以。因为_name不是属性而是私有的变量。(设置完@property的时候不加特殊标识系统会帮我们生成setter和getter方法)
    [self.kvoModel setValue:@"kevin" forKey:@"name"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.kvoModel.name = @"shave";
    });
}

// 手动触发KVO
- (void)handleKVOMethod {
    if (self.kvoModel) {
        self.kvoModel = [[KVOModel alloc]init];
    }
    self.kvoModel.name = @"hahaha";
    [self.kvoModel addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    [self.kvoModel willChangeValueForKey:@"name"];
    [self.kvoModel didChangeValueForKey:@"name"];
}

- (void)setObjectMethod {
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    [mutableArray addObject:@"0"];
    [mutableArray addObject:@"1"];
    [mutableArray addObject:@"2"];
    NSArray *array = @[@"name",@"label",@"test"];
//  NSArray * namarr =   [array valueForKey:@"@unionOfArrays.name"];
//    NSLog(@"%@",namarr);
}

// 注意 只要添加观察者都会调用这个方法(注意：只要观察者的类中实现了willChangeValueForKey或didChangeValueForKey方法 这个观察方法就不会响应)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"监听到===%@===的%@===改变了%@===", object, keyPath,change);
    NSLog(@"上下文====%@",context);
    if ([keyPath isEqualToString:@"age"]) {
        
    } else if ([keyPath isEqualToString:@"name"]) {
        
    }
}

- (void)dealloc {
    // 没有add的不要移除 或者加上try catch  如果没有addobserve 就去移除 那么会crash
    @try {
        [self.kvoModel removeObserver:self forKeyPath:@"age"];
        [self.kvoModel removeObserver:self forKeyPath:@"name"];
    } @catch (NSException *exception) {
        NSLog(@"异常原因： %@",exception);
    } @finally {
        //
    }
}

@end
// 面试题解答：1.addObserver:forKeyPath:options:context:各个参数的作用分别是什么，observer中需要实现哪个方法才能获得KVO回调？
/*
 答：
 ```
 - (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
 ```
 方法中的参数为： observer 观察者 keyPath 进行kvo的观察属性 options 观察的选项 一般为新值NSKeyValueObservingOptionNew 和 旧值 NSKeyValueObservingOptionOld  context是上下文。
 
   在observer 实现下面的方法可以获取KVO回调
 ```
 - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{}
 ```
 中 各参数的作用是： keyPath 进行kvo设置的观察属性 object是被观察者对象本身  change 是一个字典里面包括 观察的类型 kind  new 新值 old 旧值
  context是上下文。这个值就是监听时候传的值
 */
// 面试题解答：2.如何手动触发一个value的KVO?
/*
 答：手动触发是为了和自动触做区分。
    自动触发的场景:在kvo注册之后，对要观察的属性进行赋值。那么就触发了。
    自动触发的原理：key  value 观察者方法依赖于willChangeValueForKey和didChangeValueForKey两个方法。在一个属性被观察者发生改变之前。willChangeValueForKey会先调用，这个时候回记录旧值，当发生改变后， didChangeValueForKey也会被调用，之后observeValueForKeyPath 会被调用。从change 里面的参数 old new 就可以看出。 所以，要实现手动调用 我们只需要触发willChangeValueForKey和didChangeValueForKey就可以了。
 具体实现参考方法:
 ```
 // 手动触发KVO
 - (void)handleKVOMethod {
     if (self.kvoModel) {
         self.kvoModel = [[KVOModel alloc]init];
     }
     self.kvoModel.name = @"hahaha";
     [self.kvoModel addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
     [self.kvoModel willChangeValueForKey:@"name"];
     [self.kvoModel didChangeValueForKey:@"name"];
 }
 ```
总结：kvo触发原理，在我们调用setter方法的时候，系统会在调用setter方法之前调用willChangeValueForKey 以及didChangeValueForKey 然会调用observeValueForKeyPath
  具体可参考：apple 关于kvo 的说明:https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/KeyValueObserving/Articles/KVOCompliance.html#//apple_ref/doc/uid/20002178-SW3

 */
// 面试题解答：3. 若一个类有实例变量 NSString *_foo ，调用setValue:forKey:时，可以以foo还是 _foo 作为key？
/*
 答:都可以。前提条件是在实例变量在对应类中调用。如果是在其他类中实例化变量所在的类就不行。因为这个变量是类的私有属性。只有公开属性才可以使用。
 */

// 面试题解答：4.KVC的keyPath中的集合运算符如何使用？
/*
 答:在集合对象或者普通对象的集合属性。 才能使用。。
 */
