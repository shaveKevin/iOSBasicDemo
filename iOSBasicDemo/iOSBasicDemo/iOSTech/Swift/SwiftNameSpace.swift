//
//  SwiftNameSpace.swift
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/10.
//  Copyright © 2019 小风. All rights reserved.
//

import Foundation
// 对string 添加扩展 增加处理命名空间
extension String {
    public  static func SKSwiftStringToClass(targetString:String) -> AnyClass? {
        guard let  nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as? String else {
            return nil
        }
        let classArray = [NSClassFromString(targetString),NSClassFromString(nameSpace+"."+targetString)]
        return classArray.compactMap { $0 }.first
    }
}
