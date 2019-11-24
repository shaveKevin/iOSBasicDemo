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
