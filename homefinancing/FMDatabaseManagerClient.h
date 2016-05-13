//
//  FMDatabaseManagerClient.h
//  ITAS2_New
//  此类在多线程中若共享会出问题，多线程使用FMDatabaseQueueClient
//  Created by 辰 宫 on 15/1/29.
//  Copyright (c) 2015年 overmindgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface FMDatabaseManagerClient : FMDatabase

/**取得FMDB的Client实例，此类在多线程中若共享会出问题，多线程使用FMDatabaseQueueClient*/
+ (instancetype)sharedClient;

@end
