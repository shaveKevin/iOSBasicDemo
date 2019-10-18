//
//  SKKVCKVOVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/24.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKKVCKVOVC.h"
#import "KVOModel.h"
// KVO - Key-Value- Observing 键值监听  用于监听某个对象中属性的改变
// KVC - Key-Value- Coding 键值编码 主要用于不调用setter方法就更改或者访问对象的属性，这只是在动态地访问或更改对象的属性，而不是在编译期。
@interface SKKVCKVOVC ()

@end

@implementation SKKVCKVOVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self modelValueChange];
    
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"监听到===%@===的%@===改变了%@===", object, keyPath,change);
}

@end
