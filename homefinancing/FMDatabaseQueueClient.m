//
//  FMDatabaseQueueClient.m
//  ITAS2_New
//  使用FMDatabaseQueue 后台会建立系列化的G-C-D队列，并执行你传给G-C-D队列的块。这意味着 你从多线程同时调用调用方法，GDC也会按它接收的块的顺序来执行。
//  线程安全
//  Created by 辰 宫 on 15/2/12.
//  Copyright (c) 2015年 overmindgc. All rights reserved.
//

#import "FMDatabaseQueueClient.h"

static FMDatabaseQueueClient *_sharedClient = nil;

@implementation FMDatabaseQueueClient


+ (instancetype)sharedClient {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //取得数据库保存路径，通常保存沙盒Documents目录
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSLog(@"%@",directory);
        NSString *filePath = [directory stringByAppendingPathComponent:@"homefinancing"];
        //创建FMDatabaseQueue对象
        _sharedClient = [FMDatabaseQueueClient databaseQueueWithPath:filePath];

    });
    
    return _sharedClient;
}

@end
