//
//  SKSubObject.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/27.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKSubObject.h"

@interface SKSubObject ()
// 私有属性
@property (nonatomic, strong) NSString *priObjectString;

@end
// 面试题解答： 一个objc对象如何进行内存布局？（考虑有父类的情况） 通过clang编译我们可以发现
/*
   1.子类包括父类的成员变量 以及自己的成员变量都会存储在对应的存储空间中。
   2.每一个对象内部有一个isa指针。指向它的类对象，类对象保存着本对象的方法列表(因为对象能够接受的消息列表) 成员变量列表以及属性列表
    子类(注意这是一个类不是实例)的内部也有一个isa指针指向元对象(meta class)，元对象内部存放的是类方法列表，类列表内部还有一个super class的指针。指向它的父类对象。(类方法和实例方法存储在不同的存储单元里)
 // 根对象就是NSObject 它的superclass为nil。
 // 类对象既然称之为对象，那它也是一个实例。类对象中也有一个isa指针指向它的元类(meta class) 即类对象是元类的实例。
 OC 中的对象结构图：
 ISA指针(一个对象的isa指针指向了这个类对象。一个类对象的isa指向了它的元类metaclass)
 根的实例变量
 倒数第二层父类的实例变量
 ···········
 父类的实例变量
 类的实例变量

 // 名字解释： ISA  metaClass
 OC的运行时是动态的，为每个类的定义生成了两个Objc_class 一个是普通的class 另外一个是metaclass 我们自己实现的时候可以在运行期创建这两个objc_class数据结构，然后使用objc_addClass将class注册到运行系统中，以此动态地创建一个新的类。（meta是Class对象的类。）
 ISA是一个指针：(一个对象的isa指针指向了这个类对象。一个类对象的isa指向了它的元类metaclass)
 metaClass也是一个指针：metaClass的isa指向的是根metaClass.如果该metaClass是根，metaClass指向自身，metaClasse的super Class指向父metaClass,如果该metaClas是根，则指向该metaClass对应的类。
   其中根对象就是NSObject，它的superclass指针指向nil
 
 简单的来说：一个对象的isa指向那个class，代表它是那个类的对象。那么对于class来说，它也是一个对象，它的isa指针指向什么呢？

 对于Class来说，也就需要一个描述他的类，也就是“类的类”，而meta正是“关于某事自身的某事”的解释，所以MetaClass就因此而生了。
类对象既然称为对象，那它也就是一个实例。类对象中也有一个isa指针指向它的元类(meta class)，即类对象是元类的实例。元类内部存放的是类方法列表。根元类的isa指针指向自己，super class指针指向NSObject类。
 // 面试题解答： 一个objc对象的isa指针指向什么，有什么作用？
               指向它的类对象，从而可以找到对象上的方法。
 */
@implementation SKSubObject

#warning One more question  - SKTODOList 这里有个疑问，系统对我们创建的类是怎么添加到运行系统中的?是利用Objc_addClass？
- (void)printSubObject {
    NSLog(@"富士山下");
}

+ (void)thisisSubMethod {
    NSLog(@"thisisSubMethod");
}
// 面试题：下面的代码输出什么？
/*
  - (instancetype)init {
      
      if (self = [super init]) {
          NSLog(@"[self class] == %@   %p",NSStringFromClass([self class]),[self class]);
          NSLog(@"[super class] == %@   %p",NSStringFromClass([super class]),[super class]);
      }
      return self;
  }
 // 答案都输出 SKSubObject  并且两者的地址都是相同的。
 这里主要考察的是OC中关于self和super的理解。 一般的我们都知道self是指向的调用这几个方法的这个类的本身。那么super呢。其实super是一个Magic Keyword，
 它的本质是一个编译器标示符，和self都指向同一个消息接受者。他们的不同点在于super会告诉编译器，调用class这个方法的时候，要去父类的方法，而不是本类里的。
 
 当使用self调用方法的时候，会从当前类的方法列表中开始找，如果没有，就从父类再找；而当使用super的时候，则从父类的方法列表中开始找，然后调用父类的这个方法。
 这也就是为什么不推荐在init方法中使用点语法。如果想访问实例变量iVar应该使用下划线(_iVar) 而非点语法(self.ivar)
 
点语法的坏处就是子类可能复写setter，假如person有一个子类叫Ming,这个子类专门标识哪些名字有Ming的人，该子类可能会重写LastName属性对应的设置方法。
 */
- (instancetype)init {
    
    if (self = [super init]) {
        NSLog(@"[self class] == %@   %p",NSStringFromClass([self class]),[self class]);
        //[self class] 调用的时候 直接是objc_msgSend(id self, SEL sel);
        // objc_msgSend((id)self, sel_registerName("class"))
        // [super class]调用的时候是objc_msgSendSuper(struct objc_super *super, SEL  sel);
        NSLog(@"[super class] == %@   %p",NSStringFromClass([super class]),[super class]);
        //     objc_msgSendSuper((__rw_objc_super){(id)self, (id)class_getSuperclass(objc_getClass("SKSubObject"))}, sel_registerName("class")))
        
        NSLog(@"1.[self printClass] == %@",[self printClass]);
        NSLog(@"2.[super printClass] == %@",[super printClass]);

    }
    return self;
}

- (id)printClass {
    NSLog(@"1.2 SKSubObject ===%@",self);
    return [super printClass];
}

/*
 objc_super 是一个结构体
 struct objc_super {
       __unsafe_unretained id receiver;
       __unsafe_unretained Class super_class;
 };
 */
// 总结：
/*
 1. 当我们在调用[self class]的时候，实际先调用的是objc_msgSend函数，第一个参数是当前SKSubObject这个实例，然后在SKSubObject类里面去找-(Class)class; 这个方法,如果没有就去父类(SKObjectObject)里面找,如果也没有那就到了基类NSObject类。而在runtime中对class方法的实现返回的是当前类本身。
 2. 当我们在调用[super class]的时候，会被转换成objc_msgSendSuper函数，第一步先构造objc_super结构体，结构体第一个成员就是self，第二个成员就是
 (id)class_getSuperclass(objc_getClass("SKSubObject"))实际上这个时候返回的是SKObjectObject 第二步是从SKObjectObject类中去找-(Class)class;
 没有，然后去NSObject中去找，最后内部是使用objc_msgSend(objc_super receiver, @selector(class))去调用。 这个时候的调用和[self class ]基本一样。所以结果返回仍然是SKSubObject。
 // 可以这么简单的理解。 [super class]调用只是一个标记。告诉编译器我调用的方法都从父类中取(其实找class 方法的话最终都是在基类NSObject中)，而打印的时候仍然是本类的方法。
 
 */
// runtime中对class的实现
  /*
   - (Class)class {
      return object_getClass(self);
   }
   */
      
      
@end

/*
 extern "C" unsigned long OBJC_IVAR_$_SKSubObject$_subObjectString;
 struct SKSubObject_IMPL {
     struct SKObjectObject_IMPL SKObjectObject_IVARS; // 父类的一堆东西都保存在父类中 子类继承自父类 拥有父类的属性方法(暴露出来的)
     NSString * _Nonnull _subObjectString;
 };
 
 extern "C" unsigned long int OBJC_IVAR_$_SKSubObject$_subObjectString __attribute__ ((used, section ("__DATA,__objc_ivar"))) = __OFFSETOFIVAR__(struct SKSubObject, _subObjectString);
 extern "C" unsigned long int OBJC_IVAR_$_SKSubObject$_priObjectString __attribute__ ((used, section ("__DATA,__objc_ivar"))) = __OFFSETOFIVAR__(struct SKSubObject, _priObjectString);

 static struct _ivar_list_t {
     unsigned int entsize;  // sizeof(struct _prop_t)
     unsigned int count;
     struct _ivar_t ivar_list[2];
 } _OBJC_$_INSTANCE_VARIABLES_SKSubObject __attribute__ ((used, section ("__DATA,__objc_const"))) = {
     sizeof(_ivar_t),
     2,
     {{(unsigned long int *)&OBJC_IVAR_$_SKSubObject$_subObjectString, "_subObjectString", "@\"NSString\"", 3, 8},
      {(unsigned long int *)&OBJC_IVAR_$_SKSubObject$_priObjectString, "_priObjectString", "@\"NSString\"", 3, 8}}
 };

 static struct _method_list_t{
     unsigned int entsize;  // sizeof(struct _objc_method)
     unsigned int method_count;
     struct _objc_method method_list[5];
 } _OBJC_$_INSTANCE_METHODS_SKSubObject __attribute__ ((used, section ("__DATA,__objc_const"))) = {
     sizeof(_objc_method),
     5,
     {{(struct objc_selector *)"printSubObject", "v16@0:8", (void *)_I_SKSubObject_printSubObject},
     {(struct objc_selector *)"subObjectString", "@16@0:8", (void *)_I_SKSubObject_subObjectString},
     {(struct objc_selector *)"setSubObjectString:", "v24@0:8@16", (void *)_I_SKSubObject_setSubObjectString_},
     {(struct objc_selector *)"priObjectString", "@16@0:8", (void *)_I_SKSubObject_priObjectString},
     {(struct objc_selector *)"setPriObjectString:", "v24@0:8@16", (void *)_I_SKSubObject_setPriObjectString_}}
 };

 static struct _method_list_t {
     unsigned int entsize;  // sizeof(struct _objc_method)
     unsigned int method_count;
     struct _objc_method method_list[1];
 } _OBJC_$_CLASS_METHODS_SKSubObject __attribute__ ((used, section ("__DATA,__objc_const"))) = {
     sizeof(_objc_method),
     1,
     {{(struct objc_selector *)"thisisSubMethod", "v16@0:8", (void *)_C_SKSubObject_thisisSubMethod}}
 };

 static struct _prop_list_t {
     unsigned int entsize;  // sizeof(struct _prop_t)
     unsigned int count_of_properties;
     struct _prop_t prop_list[1];
 } _OBJC_$_PROP_LIST_SKSubObject __attribute__ ((used, section ("__DATA,__objc_const"))) = {
     sizeof(_prop_t),
     1,
     {{"subObjectString","T@\"NSString\",&,N,V_subObjectString"}}
 };

 */

// 参考链接：
/*
 1.ios isa 是什么鬼??? https://blog.csdn.net/yst19910702/article/details/51443901
 2.Why is MetaClass in Objective-C？  https://juejin.im/entry/59bb8b895188257e70531bf9
 3.刨根问底Objective－C Runtime（1）－ Self & Super  https://blog.csdn.net/u011344883/article/details/41512683
 */
