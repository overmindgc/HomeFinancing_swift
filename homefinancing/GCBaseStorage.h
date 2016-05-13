//
//  ITASBaseStorage.h
//  ITAS2_New
//  基础数据本地存储类
//  Created by 辰 宫 on 15/1/29.
//  Copyright (c) 2015年 overmindgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDBModel.h"

@interface GCBaseStorage : NSObject

/***常用存储方法****/

/**根据model创建表*/
- (BOOL)createTableWithModelClass:(Class)modelClass;

/**根据model查询数据*/
- (NSArray *)selectModelArrayByClass:(Class)modelClass params:(NSDictionary *)paramDict orderBy:(NSString *)columName isDesc:(BOOL)desc;

/**根据model分页查询数据*/
- (NSArray *)selectModelArrayByClass:(Class)modelClass params:(NSDictionary *)paramDict orderBy:(NSString *)columName isDesc:(BOOL)desc limitStartLine:(NSInteger)startLine perSize:(NSInteger)perSize;

/**向表中插入多条Model数据*/
- (void)insertToTableWithArray:(NSArray *)modelArray;

/**向表中插入一条Model数据*/
- (void)insertToTableWithModel:(NSObject *)model;

/**先删除已有的再向表中插入一条Model数据*/
- (void)insertToTableWithModel:(NSObject *)model afterDelete:(NSDictionary *)paramDict;

/**删除表中数据*/
- (void)deleteFromTableByClass:(Class)modelClass params:(NSDictionary *)paramDict;

/**更新表中数据*/
- (void)updateFromTableByClass:(Class)modelClass set:(NSDictionary *)setDict params:(NSDictionary *)paramDict;

/**根据表明查询有多少条记录*/
- (NSInteger)columnCountByClass:(Class)modelClass params:(NSDictionary *)paramDict;

/***基础方法****/

/**根据model获取表名*/
- (NSString *)tableNameByModel:(id)model;

/**队列执行更新sql语句，用于插入、修改、删除，此方法线程安全*/
-(void)executeQueueNonQuery:(NSString *)sql;
/**队列采用事物执行更新sql语句，用于插入、修改、删除，此方法线程安全*/
-(void)executeQueueNonQueryInTransaction:(NSArray *)sqlArr;
/**队列执行查询sql语句，此方法线程安全*/
-(NSArray *)executeQueueQuery:(NSString *)sql;

/**执行更新sql语句，用于插入、修改、删除，多线程不安全*/
- (BOOL)executeNonQuery:(NSString *)sql arg:(id)arg;

/**执行查询sql语句，多线程不安全*/
- (NSArray *)executeQuery:(NSString *)sql;

/**检查是否有这张表*/
- (BOOL)checkHasTable:(NSString *)tableName;

@end
