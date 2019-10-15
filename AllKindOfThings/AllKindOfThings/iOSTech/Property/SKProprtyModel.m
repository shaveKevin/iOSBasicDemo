//
//  SKProprtyModel.m
//  AllKindOfThings
//
//  Created by shavekevin on 2019/9/25.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKProprtyModel.h"

@interface SKProprtyModel()
{
    NSString *_foo;
}
@end
/*
 通过runtime看其实现应该是这个样子的，可以看出这里定义的实际变量并不是timeStamps 而是 instanceTImeStamps
 说明了_timeStamps 被 instanceTImeStamps替换了。而定义的upAndDown属性 系统自动生产了
extern "C" unsigned long OBJC_IVAR_$_SKProprtyModel$instanceTimeStamps;
extern "C" unsigned long OBJC_IVAR_$_SKProprtyModel$animal;
extern "C" unsigned long OBJC_IVAR_$_SKProprtyModel$_mouse;
extern "C" unsigned long OBJC_IVAR_$_SKProprtyModel$_upAndDown;
extern "C" unsigned long OBJC_IVAR_$_SKProprtyModel$_foo;
struct SKProprtyModel_IMPL {
    struct NSObject_IMPL NSObject_IVARS;
    NSString *_foo;
    NSString * _Nonnull instanceTimeStamps;
    NSString * _Nonnull animal;
    NSString * _Nonnull _mouse;
    NSString * _Nonnull _upAndDown;
};

*/
@implementation SKProprtyModel
// 解答面试题：@synthesize合成实例变量的规则是什么？假如property名为foo，存在一个名为_foo的实例变量，那么还会自动合成新变量么？
// @synthesize 合成实例变量规则
// 1.如果指定了成员变量的名称，会生成一个指定名称的成员变量。
// 2.如果这个成员已经存在了，就不再生成了。
// 3.但是如果是@synthesize foo; 这个时候还会生成一个名称为foo的成员变量：如果没有指定成员变量的名称就会自动生成一个属性同名的成员变量
// 4.如果是@synthesize mouse = _mouse; 就不会生成成员变量了。
// 假如property名为mouse，存在一个名为_mouse的实例变量，那么还会自动合成新变量么？  答案是不会。 如果强制定义的时候会报警告
// Auto property synthesis will not synthesize property '_mouse' because it cannot share an ivar with another synthesized property
@synthesize timeStamps = instanceTimeStamps;

@synthesize animal;

@synthesize mouse = _mouse;
@end


// 面试题解答:在有了自动合成属性实例变量之后，@synthesize还有哪些使用场景？
// 1.同时重写了setter和getter的时候。
// 2.重写了只读属性的getter时
// 3.使用了@dynamic时
// 4.在@protocal中定义的所有属性
// 5.在category中定义的所有属性
// 6.重载的属性
// 当在子类中重载了父类的属性，必须使用@syhthesize 来手动合成ivar
//例如：类SKSynthesizeModel中的timeStamps 属性 会报警告
//Auto property synthesis will not synthesize property 'timeStamps'; it will be implemented by its superclass, use @dynamic to acknowledge intention
// 解除警告 @dynamic timeStamps;

// 当你重写了setter 和getter 方法的时候，系统就不会生成- 实例变量和成员变量了。这个时候要么 手动创建ivar 要么使用@synthesize  title = _title; 来关联 @property 和 ivar。
// 会报错：Use of undeclared identifier '_title'; did you mean 'title'?

// 在属性类表中 /*_prop_list_t*/
/*
 static struct  {
     unsigned int entsize;  // sizeof(struct _prop_t)
     unsigned int count_of_properties;
     struct _prop_t prop_list[5];
 } _OBJC_$_PROP_LIST_SKProprtyModel __attribute__ ((used, section ("__DATA,__objc_const"))) = {
     sizeof(_prop_t),
     5,
     {{"timeStamps","T@\"NSString\",C,N,VinstanceTimeStamps"},
     {"upAndDown","T@\"NSString\",C,N,V_upAndDown"},
     {"foo","T@\"NSString\",C,N,V_foo"},
     {"animal","T@\"NSString\",C,N,Vanimal"},
     {"mouse","T@\"NSString\",C,N,V_mouse"}}
 };
*/

/*
 // @synthesize timeStamps = instanceTimeStamps;
 static NSString * _Nonnull _I_SKProprtyModel_timeStamps(SKProprtyModel * self, SEL _cmd) { return (*(NSString * _Nonnull *)((char *)self + OBJC_IVAR_$_SKProprtyModel$instanceTimeStamps)); }
 extern "C" __declspec(dllimport) void objc_setProperty (id, SEL, long, id, bool, bool);

 static void _I_SKProprtyModel_setTimeStamps_(SKProprtyModel * self, SEL _cmd, NSString * _Nonnull timeStamps) { objc_setProperty (self, _cmd, __OFFSETOFIVAR__(struct SKProprtyModel, instanceTimeStamps), (id)timeStamps, 0, 1); }


 // @synthesize animal;
 static NSString * _Nonnull _I_SKProprtyModel_animal(SKProprtyModel * self, SEL _cmd) { return (*(NSString * _Nonnull *)((char *)self + OBJC_IVAR_$_SKProprtyModel$animal)); }
 static void _I_SKProprtyModel_setAnimal_(SKProprtyModel * self, SEL _cmd, NSString * _Nonnull animal) { objc_setProperty (self, _cmd, __OFFSETOFIVAR__(struct SKProprtyModel, animal), (id)animal, 0, 1); }

 // @synthesize mouse = _mouse;
 static NSString * _Nonnull _I_SKProprtyModel_mouse(SKProprtyModel * self, SEL _cmd) { return (*(NSString * _Nonnull *)((char *)self + OBJC_IVAR_$_SKProprtyModel$_mouse)); }
 static void _I_SKProprtyModel_setMouse_(SKProprtyModel * self, SEL _cmd, NSString * _Nonnull mouse) { objc_setProperty (self, _cmd, __OFFSETOFIVAR__(struct SKProprtyModel, _mouse), (id)mouse, 0, 1); }


 static NSString * _Nonnull _I_SKProprtyModel_upAndDown(SKProprtyModel * self, SEL _cmd) { return (*(NSString * _Nonnull *)((char *)self + OBJC_IVAR_$_SKProprtyModel$_upAndDown)); }
 static void _I_SKProprtyModel_setUpAndDown_(SKProprtyModel * self, SEL _cmd, NSString * _Nonnull upAndDown) { objc_setProperty (self, _cmd, __OFFSETOFIVAR__(struct SKProprtyModel, _upAndDown), (id)upAndDown, 0, 1); }

 static NSString * _Nonnull _I_SKProprtyModel_foo(SKProprtyModel * self, SEL _cmd) { return (*(NSString **)((char *)self + OBJC_IVAR_$_SKProprtyModel$_foo)); }
 static void _I_SKProprtyModel_setFoo_(SKProprtyModel * self, SEL _cmd, NSString * _Nonnull foo) { objc_setProperty (self, _cmd, __OFFSETOFIVAR__(struct SKProprtyModel, _foo), (id)foo, 0, 1); }
 */
