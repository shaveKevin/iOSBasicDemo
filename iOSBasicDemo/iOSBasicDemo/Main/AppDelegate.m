//
//  AppDelegate.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/19.
//  Copyright © 2019 小风. All rights reserved.
//

#import "AppDelegate.h"
#import "NSObject+SKHookSelector.h"
/*
 clang 命令
 xcrun  -sdk iphoneos clang -arch arm64 -rewrite-objc xxx -o ooo.cpp

 xcrun 是命令xcode  run
 -sdk   iphoneos  调用iphoneos的sdk
 -arch  arm64 这是arm64架构
 -rewrite-objc  执行方法
  xxx  原类
 -o 输出
 ooo.cpp 目标类
 */
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [NSObject hookSelector];
    NSObject *obj = [[NSObject alloc]init];
    [obj methodTest];
    NSLog(@"%p",__func__);

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"%p",__func__);

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"%p",__func__);

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"%p",__func__);

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"%p",__func__);

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"%p",__func__);
}

@end

// 面试题答案：App都有哪些运行状态？
/*
 答：未运行，未激活，激活，后台，挂起。
 未运行：程序未启动
 未激活：程序在前台运行，不过没有接受到事件。
 激活：程序在前台运行且受到了事件。
 后台：程序在后台而且能执行代码，大多程序进入这个状态后会在这个状态停留一会，时间到之后会进入挂起状态。
 挂起：程序在后台不能执行代码。系统会自动把程序变成这个状态而且不会发出通知。当挂起时，程序还是停留在内存中，系统内存低时，系统就把挂起的程序清除掉。
 */

