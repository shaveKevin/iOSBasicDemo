//
//  SKSynthesizeModel.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKSynthesizeModel.h"

@interface SKSynthesizeModel ()

@property (nonatomic, copy) NSString *timeStamps;

@end

@implementation SKSynthesizeModel
// 面试题解答：@synthesize和@dynamic分别有什么作用？
/*
    1. @proprerty 有两个对应的词，一个是@synthesize 一个是@sdynamic，如果@synthesize和@dynamic都没写。那么默认的就是@synthesize  var = _var;
    2. @synthesize 的语义是如果你没有手动实现setter 和 getter 方法。那么编译器会自动为你加上这两个方法。
    3. @dynamic 告诉编译器，setter和getter方法由用户自己实现，不自动生成。(对于readonly的属性只需要提供getter即可)
    假如一个属性被声明为@dynamic var 如果你没有实现setter 和getter方法，虽然编译的时候不会报错，但是当程序运行到 instance.var = someVar 的时候，由于缺少setter方法 而crash 报错信息为:（-[SKPropertyTestModel setTitle:]: unrecognized selector sent to instance 0x2803a51a0） 当运行到someVar= var的时候。由于缺少getter 方法而crash.报错信息为:（ -[SKPropertyTestModel title]: unrecognized selector sent to instance 0x2829a0160）在编译的时候没问题，在运行的时候才会去执行对应的方法，这就是所谓的动态绑定。
 
 */
// 加这个关键字必须得手动实现setter 和getter否则的话调用的时候会crash
@dynamic timeStamps;

@end


