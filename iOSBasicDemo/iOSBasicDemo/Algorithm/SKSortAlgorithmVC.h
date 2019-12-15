//
//  SKSortAlgorithmVC.h
//  iOSBasicDemo
//
//  Created by shavekevin on 2019/9/26.
//  Copyright © 2019 小风. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 算法题：1.LRU有哪些应用？(yycache 设计参考链接：https://blog.ibireme.com/2015/10/26/yycache/)
// 面试题：什么是深度优先搜索(DFS)? 什么是广度优先搜索(BFS)?
// DFS是一条链一条链的搜索，而BFS是逐层进行搜索，这是他俩一个很大的区别。
// BFS利用队列来进行计算。搜索时首先将初始状态添加到队列里，此后从队列的最前端不断取出状态，把从该状态而可以转移到的状态（这些状态还未被访问）加入到队列里，如此重复，直到队列被取空或找到了问题的解。
// 例如： 给定整数a1、a2、a3、..............、an，判断是否可以从中选出若干个数，使得他们的和恰好为k。这个利用DFS 来处理
// 例如：给定一个大小为n * m的迷宫，迷宫由通道和墙壁组成，每一步都可以向邻接的上下左右四格的通道移动，请求出从起点到终点的最小步数。假设：从起点一定可以到达终点。（S代表起点，G代表终点） 迷宫问题 这个利用BFS来处理。BFS可以用来求最短路径，最少操作等问题，所以可以用BFS来做


  
@interface SKSortAlgorithmVC : UIViewController

@end

NS_ASSUME_NONNULL_END
