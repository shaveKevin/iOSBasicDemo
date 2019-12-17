//
//  SKCategoryObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/18.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKCategoryObj.h"

@implementation SKCategoryObj

- (void)testCategoryObjMethod {
    NSLog(@"当前类的Obj");    
    
}

@end
// 面试题解答：如果分类中和原类都有同一个方法那么他们的执行顺序是什么样的？他们的顺序是否可以调整？如果可以，怎么调整呢？
/*
 答：如果原类和分类都有同一个方法那么他们的执行顺序是 分类方法执行，原类方法不执行。首先在编译期的时候，他们单独编译，原类产生原类的方法list，分类产生自己的分类方法list，在runtime的作用下，(运行期做做方法的合并)通过method attatch 对当前类的方法 属性 协议等进行合并。当我们调用方法的时候，会先把原类的方法通过memorycopy方法拷贝到方法列表中，然后通过memcopymove将分类的方法拷贝到方法列表中。当方法调用查找的时候，首先查找到的是分类的方法，因为分类方法最后添加到方法列表中。所以先执行了分类犯法，原类的方法没有被执行，并不是被覆盖。
 他们的执行顺序可以调整。
  思路：拿到当前类的所有方法，根据分类和原类方法在方法列表中的位置，我们可以知道原类方法在最后。找到对应的方法进行调用。调用的时候可以采用IMP 来执行方法，也可以通过objc_msgSend 来进行方法调用。
方法如下：
 ```
   u_int count = 0;
   Method *methods = class_copyMethodList([obj class], &count);
   NSInteger index = 0;
   for (int i = count; i >0; i--) {
       SEL name = method_getName(methods[i]);
       NSString *strName =  [NSString stringWithCString:sel_getName(name) encoding:kCFStringEncodingUTF8];
       if ([strName isEqualToString:@"testCategoryObjMethod"]) {
           index = i;
           break;
       }
   }
   SEL sel = method_getName(methods[index]);
   IMP imp = method_getImplementation(methods[index]);
   ((void(*)(id,SEL))imp)(obj,sel);
   // 还可以用
 //   ((void (*)(id,SEL))objc_msgSend)(obj, sel);
 ```
 */
