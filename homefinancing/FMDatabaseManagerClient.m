//
//  FMDatabaseManagerClient.m
//  ITAS2_New
//
//  Created by 辰 宫 on 15/1/29.
//  Copyright (c) 2015年 overmindgc. All rights reserved.
//

#import "FMDatabaseManagerClient.h"

static FMDatabaseManagerClient *_sharedClient = nil;

@implementation FMDatabaseManagerClient

+ (instancetype)sharedClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //取得数据库保存路径，通常保存沙盒Documents目录
        NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSLog(@"%@",directory);
        NSString *filePath = [directory stringByAppendingPathComponent:@"homefinancing"];
        //创建FMDatabase对象
        _sharedClient = [FMDatabaseManagerClient databaseWithPath:filePath];
        //打开数据上
        if ([_sharedClient open]) {
            NSLog(@"数据库打开成功!");
        }else{
            NSLog(@"数据库打开失败!");
        }
    });
    
    return _sharedClient;
}

@end
