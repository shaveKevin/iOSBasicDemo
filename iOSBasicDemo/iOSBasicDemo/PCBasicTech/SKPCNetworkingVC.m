//
//  SKPCNetworkingVC.m
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/10/15.
//  Copyright © 2019 小风. All rights reserved.
//

#import "SKPCNetworkingVC.h"

@interface SKPCNetworkingVC ()

@end

@implementation SKPCNetworkingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViews];
    [self setupData];
    [self setupLayout];
    
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)setupData {
    
}

- (void)setupLayout {
    
}


@end
// 面试题解答：1.三次握手和四次挥手指的是什么?
/*
 答：
 1.三次握手，(Three-way Handshake) 其实就是指建立一个TCP连接时，需要客户端和服务器总共发送3个包。进行三次握手的主要作用就是为了确认双方的接受能力和发送能力是否正常，指定自己的初始化序列号为后面的可靠性传送做准备。实质上就是连接服务器指定端口，建立TCP连接。并同步连接双方的序列号和确认号，交换TCP窗口大小的信息。
  刚开始客户端处于Closed状态，服务端处于listen状态。
 进行三次握手：
  * 第一次握手:客户端给服务端发送一个SYN报文，并指明客户端的初始化序列号ISN.此时客户端处于SYN_SEND状态。（此时客户端处于SYN已发送状态）
    此时 首部的同步位SYN=1,初始序号seq=x,SYN=1的报文段不能携带数据，但要消耗掉一个序号。
  * 第二次握手:服务端收到客户端发送的SYN报文以后，会以自己的SYN报文作为应答，并且也指定了自己的初始化序列号ISN(s)。同时会把客户端的ISN+1作为ASK的值，表示自己已经收到了客户端的SYN,此时服务器处于SYN_RCVD（此时服务端处于SYN收到状态）
 在确认报文段中SYN=1,ACK=1，确认号ack=x+1,初始序号seq=y。
 
 
 参考：面试官，不要再问我三次握手和四次挥手
 https://blog.csdn.net/hyg0811/article/details/102366854
 */
// 面试题解答：6.简单介绍一下WKWebView默认缓存策略
/*
 1. 是否有缓存，没有则直接发起请求，有则进行下一步
 2.是否每次都得进行资源更新校验（响应头是否有 Cache-Control:no-cache 或 Pragma:no-cache 字段），不需要则进入 3，需要则进入 4）
 3.缓存是否过期（响应头，Cache-Control:max-age、Expires、Last-Modified 启发式缓存），没过期则使用缓存，不发起请求，过期了则进入 4
 4.客户端发起资源更新校验请求（请求头，If-Modified-Since: Last-Modified 值、If-None-Match: ETag 值），如果资源没有更新，服务器返回 304，客户端使用缓存；如果资源有更新，服务器返回 200和资源

 参考链接：1.https://juejin.im/post/5df75e3a6fb9a016266459da   WKWebView 默认缓存策略与 HTTP 缓存协议
 2. https://zhuanlan.zhihu.com/p/60357719 可能是最被误用的 HTTP 响应头之一 Cache-Control: must-revalidate
 */
