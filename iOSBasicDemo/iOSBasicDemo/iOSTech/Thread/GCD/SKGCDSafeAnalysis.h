//
//  SKGCDSafeAnalysis.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/20.
//  Copyright © 2019 小风. All rights reserved.
//

#import <Foundation/Foundation.h>
// 面试题：使用多线程应该注意哪些问题？怎么解决？
// 面试题：iOS有哪些锁？你都使用过哪些？他们的应用场景是什么？
// 面试题：自旋锁和互斥锁有什么区别？
// 面试题：atomic和nonatomic有什么区别？atomic一定是线程安全的吗?
NS_ASSUME_NONNULL_BEGIN

@interface SKGCDSafeAnalysis : NSObject

@property (atomic, copy) NSString  *userName;

@end

NS_ASSUME_NONNULL_END

/*
 nonatomic和atomic
 setter和getter方法的时候会加锁 spinlock    可参考objc4的objc-accessors.mm
 给属性加上atomic修饰。可以保证属性的setter和getter都是原子性操作，也就是保证sette如何getter内部是线程同步的
 。但是不能保证使用的时候是安全的。
 objc_getProperty方法实现大致如下：
 ```
 // Retain release world
 id *slot = (id*) ((char*)self + offset);
 if (!atomic) return *slot;
     
 // Atomic retain release world
 spinlock_t& slotlock = PropertyLocks[slot];
 slotlock.lock();
 id value = objc_retain(*slot);
 slotlock.unlock();
 ```
 */
