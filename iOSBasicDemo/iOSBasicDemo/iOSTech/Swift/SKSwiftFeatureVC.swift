//
//  SKSwiftFeatureVC.swift
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/10.
//  Copyright © 2019 小风. All rights reserved.
//
// 面试题 Swift和OC相比有什么优缺点？请简要说明。
// 面试题：OC与Swift混编的时候有哪些需要注意的点，请简要说明。
// 面试题：Swift 的命名空间是什么？有什么用？
// 面试题：为什么说Swift是类型安全的?
import UIKit

class SKSwiftFeatureVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = UIColor.sk_setLightColor(UIColor.red, darkColor: UIColor.blue)
        
    }
    // 注意方法只有用@objc修饰才可以OC类调用到 
   @objc public func printLog() {
        print("这个方法对OC可见")
    }

}
// 面试题解答：为什么说Swift是类型安全的?
/*
 答：因为swift是强类型语言，很多数据是值传递类型写时复制。
 */
