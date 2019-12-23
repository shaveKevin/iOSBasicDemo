//
//  SKIBOutletObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/23.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKIBOutletObj.h"

@implementation SKIBOutletObj

@end
// 面试题解答：1.IBOutlet连出来的视图属性为什么可以被设置成weak?
/*
 答:既然已经在storyboard和xib中存在了，说明视图已经对它有了强引用了。  但是还有一个通过storyboard创建的vc会有一个_topLevelObjectsToKeepAliveFromStoryboard 私有数组强引用所有top level 的对象。所以即使outlet声明成weak也无所谓。
 
 参考链接：https://stackoverflow.com/questions/7678469/should-iboutlets-be-strong-or-weak-under-arc
 */
// 面试题：2.IB中User Defined Runtime Attributes如何使用？
/*
  答：它能够通过kvc的方式配置一些在interface builder 中不能配置的属性，它可以帮助vc实现减负。例如一些配置不需要在vc中写代码 直接通过interface builder就可以实现。
 具体使用可参考链接：iOS开发中，User Defined Runtime Attributes的应用 https://www.jianshu.com/p/2da5ac166e2b 
*/
