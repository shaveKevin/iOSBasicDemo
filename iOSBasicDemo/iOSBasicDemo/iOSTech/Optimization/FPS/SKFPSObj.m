//
//  SKFPSObj.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/12/15.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKFPSObj.h"

@implementation SKFPSObj

@end
// 面试题答案：如何设计一个复杂的页面，并保证页面不卡顿？
/*
分析：回答这题目可以从这些方面来分析：1.设计思路2.卡顿原理(如何保证不卡顿)3.卡顿检测
 答：1.如果设计一个复杂页面这里采用的是frame来实现
    2.卡顿的原理：cpu和gpu花时间太长。优化思路：尽可能减少cpu gpu的消耗
    3.卡顿检测：按照60fps的刷帧率，每隔16.7ms就会有一次vSync信号(垂直同步信号)
   平时所说的“卡顿”主要是因为在主线程执行了比较耗时的操作
    可以添加Observer到主线程RunLoop中，通过监听RunLoop状态切换的耗时，以达到监控卡顿的目的
 
 CPU 优化：
 1.尽量用轻量级的对象，比如用不到事件处理的地方，可以考虑使用CALayer取代UIView
 2.不要频繁地调用UIView的相关属性，比如frame、bounds、transform等属性，尽量减少不必要的修改
 3.尽量提前计算好布局，在有需要时一次性调整对应的属性，不要多次修改属性
 4.Autolayout会比直接设置frame消耗更多的CPU资源
 5.图片的size最好刚好跟UIImageView的size保持一致
 6.控制一下线程的最大并发数量
 7.尽量把耗时的操作放到子线程:文本处理（尺寸计算、绘制）图片处理（解码、绘制）
GPU优化：
 1.尽量避免短时间内大量图片的显示，尽可能将多张图片合成一张进行显示
 2.GPU能处理的最大纹理尺寸是4096x4096，一旦超过这个尺寸，就会占用CPU资源进行处理，所以纹理尽量不要超过这个尺寸
 3.尽量减少视图数量和层次
 4.减少透明的视图（alpha<1），不透明的就设置opaque为YES
 5.尽量避免出现离屏渲染

 */
// cpu和gpu相关
/*
  在屏幕成像的过程中，CPU和GPU起着至关重要的作用
  CPU（Central Processing Unit，中央处理器）：对象的创建和销毁、对象属性的调整、布局计算、文本的计算和排版、图片的格式转换和解码、图像的绘制（Core Graphics）

 GPU（Graphics Processing Unit，图形处理器）：纹理的渲染
在iOS中是双缓冲机制，有前帧缓存、后帧缓存

  
 */
// 什么是离屏渲染？
/*
 答：在OpenGL中，GPU有2种渲染方式
On-Screen Rendering：当前屏幕渲染，在当前用于显示的屏幕缓冲区进行渲染操作
Off-Screen Rendering：离屏渲染，在当前屏幕缓冲区以外新开辟一个缓冲区进行渲染操作
  
 一.离屏渲染消耗性能的原因：
1.需要创建新的缓冲区
2.离屏渲染的整个过程，需要多次切换上下文环境，先是从当前屏幕（On-Screen）切换到离屏（Off-Screen）；等到离屏渲染结束以后，将离屏缓冲区的渲染结果显示到屏幕上，又需要将上下文环境从离屏切换到当前屏幕
 
 二.哪些操作会触发离屏渲染？
 1.光栅化，layer.shouldRasterize = YES
 2.遮罩，layer.mask
 3.圆角，同时设置layer.masksToBounds = YES、layer.cornerRadius大于0（考虑通过CoreGraphics绘制裁剪圆角，或者叫美工提供圆角图片
）
 4.阴影，layer.shadowXXX(如果设置了layer.shadowPath就不会产生离屏渲染)
 */
// 离屏渲染相关资料： ··关于iOS离屏渲染的深入研究 https://zhuanlan.zhihu.com/p/72653360

