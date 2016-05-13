//
//  ITASBaseStorage.m
//  ITAS2_New
//
//  Created by 辰 宫 on 15/1/29.
//  Copyright (c) 2015年 overmindgc. All rights reserved.
//

#import "GCBaseStorage.h"
#import "FMDatabaseManagerClient.h"
#import "FMDatabaseQueueClient.h"
#import <objc/runtime.h>

@implementation GCBaseStorage

/**************************常用存储方法************************/

//- (void)saveNetworkCacheDict:(NSDictionary *)dataDict byUrl:(NSString *)url paramDict:(NSDictionary *)paramDict staffNum:(NSString *)staffNum
//{
//    //json化参数
//    NSError *jsonError;
//    NSData *paramJsonData = [NSJSONSerialization dataWithJSONObject:paramDict options:NSJSONWritingPrettyPrinted error:&jsonError];
//    NSString *paramJson = [[NSString alloc] initWithData:paramJsonData encoding:NSUTF8StringEncoding];
//    
//    //执行更新sql语句，用于插入、修改、删除
//    [[FMDatabaseQueueClient sharedClient] inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:@"insert into network_cache_table (staffNum,url,param_json,dictionary_data) values (?,?,?,?);"staffNum,url,paramJson,dataDict];
//    }];
//}
//
//- (NSDictionary *)selectNetworkCacheByUrl:(NSString *)url paramDict:(NSDictionary *)paramDict
//{
//    return nil;
//}


//根据model创建表
- (BOOL)createTableWithModelClass:(Class)modelClass
{
    NSString *table_name = [self tableNameByModel:modelClass];
    
    NSString *columStr = @"";

    //成员变量个数
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量
    Ivar *ivars = class_copyIvarList(modelClass, &ivarsCnt);
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        //　获取变量值
        columStr = [columStr stringByAppendingFormat:@"%@,",key];
    }
    free(ivars);
    
    if ([[columStr substringWithRange:NSMakeRange(columStr.length - 1,1)] isEqualToString:@","]) {
        columStr = [columStr substringToIndex:columStr.length - 1];
    }
    
    NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@);",table_name,columStr];
    
    BOOL success = [self executeNonQuery:createSql arg:nil];
    
    return success;
}

//根据model查询数据
- (NSArray *)selectModelArrayByClass:(Class)modelClass params:(NSDictionary *)paramDict orderBy:(NSString *)columName isDesc:(BOOL)desc
{
    NSString *selectSql = [self selectSqlByModelClass:modelClass params:paramDict orderBy:columName isDesc:desc limitStartLine:-1 perSize:-1];
    
    NSArray *resultArray = [self executeQueueQuery:selectSql];
    
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    for (NSDictionary *noticeDict in resultArray) {
        GCDBModel *model  = [[modelClass alloc] initWithDict:noticeDict];
        [modelArray addObject:model];
    }
    return modelArray;
}

//根据model分页查询数据
- (NSArray *)selectModelArrayByClass:(Class)modelClass params:(NSDictionary *)paramDict orderBy:(NSString *)columName isDesc:(BOOL)desc limitStartLine:(NSInteger)startLine perSize:(NSInteger)perSize
{
    NSString *selectSql = [self selectSqlByModelClass:modelClass params:paramDict orderBy:columName isDesc:desc limitStartLine:startLine perSize:perSize];
    
    NSArray *resultArray = [self executeQueueQuery:selectSql];
    
    NSMutableArray *modelArray = [[NSMutableArray alloc] init];
    for (NSDictionary *noticeDict in resultArray) {
        GCDBModel *model  = [[modelClass alloc] initWithDict:noticeDict];
        [modelArray addObject:model];
    }
    return modelArray;
}

//向表中插入多条Model数据
- (void)insertToTableWithArray:(NSArray *)modelArray
{
    NSMutableArray *sqlArray = [[NSMutableArray alloc] init];
    for (NSObject *model in modelArray) {
        [sqlArray addObject:[self insertSqlByModel:model]];
    }
    [self executeQueueNonQueryInTransaction:sqlArray];
}

//向表中插入一条Model数据
- (void)insertToTableWithModel:(NSObject *)model
{
    NSString *insertSql = [self insertSqlByModel:model];
    
    [self executeNonQuery:insertSql arg:nil];
}

//先删除已有的再向表中插入一条Model数据
- (void)insertToTableWithModel:(NSObject *)model afterDelete:(NSDictionary *)paramDict
{
    NSArray *resultArray = [self selectModelArrayByClass:[model class] params:paramDict orderBy:nil isDesc:NO];
    if (resultArray.count > 0) {
        [self deleteFromTableByClass:[model class] params:paramDict];
    }
    
    NSString *insertSql = [self insertSqlByModel:model];
    
    [self executeNonQuery:insertSql arg:nil];
}

//删除表中数据
- (void)deleteFromTableByClass:(Class)modelClass params:(NSDictionary *)paramDict
{
    NSString *table_name = [self tableNameByModel:modelClass];
    NSString *paramStr = [self paramStrByDict:paramDict];
    
    NSString *deleteSql;
    if (paramDict) {
        deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",table_name,paramStr];
    } else {
        deleteSql = [NSString stringWithFormat:@"DELETE FROM %@",table_name];
    }
    [self executeNonQuery:deleteSql arg:nil];
}

//更新表中数据
- (void)updateFromTableByClass:(Class)modelClass set:(NSDictionary *)setDict params:(NSDictionary *)paramDict
{
    NSString *table_name = [self tableNameByModel:modelClass];
    
    NSString *setStr = @"";
    NSInteger count = 0;
    for (NSString *key in setDict) {
        NSString *value = [setDict valueForKey:key];
        count++;
        if (count == [setDict allKeys].count) {
            setStr = [setStr stringByAppendingFormat:@"%@='%@'",key,value];
        } else {
            setStr = [setStr stringByAppendingFormat:@"%@='%@', ",key,value];
        }
        
    }
    
    NSString *paramStr = [self paramStrByDict:paramDict];
    
    NSString *updateSql;
    if (paramDict) {
        updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@",table_name,setStr,paramStr];
    } else {
        updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ ",table_name,setStr];
    }
    [self executeNonQuery:updateSql arg:nil];
}

- (NSInteger)columnCountByClass:(Class)modelClass params:(NSDictionary *)paramDict
{
    NSString *table_name = [self tableNameByModel:modelClass];
    
    NSString *paramStr = [self paramStrByDict:paramDict];
    NSString *countSql;
    if (paramDict) {
        countSql = [NSString stringWithFormat:@"SELECT count(*) FROM %@ WHERE %@",table_name,paramStr];
    } else {
        countSql = [NSString stringWithFormat:@"SELECT count(*) FROM %@ ",table_name];
    }
    NSArray *resultArray = [self executeQuery:countSql];
    NSInteger tableNum = 0;
    if (resultArray && resultArray.count > 0) {
        NSDictionary *resultDic = [resultArray objectAtIndex:0];
        tableNum = [[resultDic valueForKey:@"count(*)"] integerValue];
    }
    return tableNum;
}
/***********************基础方法***************************/

//根据model获取表名
- (NSString *)tableNameByModel:(id)model
{
    //获取的名字默认会加上项目名，取出后半部分
    NSString *modelName = [NSString stringWithUTF8String:object_getClassName(model)];
    NSArray *sepNames = [modelName componentsSeparatedByString:@"."];
    if (sepNames.count > 1) {
        NSString *table_name = sepNames[1];
        return table_name;
    } else {
        return nil;
    }
}

//根据model和过滤参数字典生成select语句
- (NSString *)selectSqlByModelClass:(Class)modelClass params:(NSDictionary *)paramDict orderBy:(NSString *)columName isDesc:(BOOL)desc limitStartLine:(NSInteger)startLine perSize:(NSInteger)perSize
{
    NSString *table_name = [self tableNameByModel:modelClass];
    
    NSString *paramStr = [self paramStrByDict:paramDict];
    
    NSString *orderByStr = @"";
    NSString *descStr = @"";
    if (columName) {
        orderByStr = [orderByStr stringByAppendingFormat:@"ORDER BY %@",columName];
        if (desc) {
            descStr = @"DESC";
        } else {
            descStr = @"ASC";
        }
    }
    
    NSString *limitStr = @"";
    if (startLine !=-1 && perSize != -1) {
        limitStr = [limitStr stringByAppendingFormat:@"LIMIT %ld OFFSET %ld",(long)perSize,(long)startLine];
    }
    
    NSString *selectSql;
    if (paramDict) {
        selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ %@ %@ %@",table_name,paramStr,orderByStr,descStr,limitStr];
    } else {
        selectSql = [NSString stringWithFormat:@"SELECT * FROM %@ %@ %@ %@",table_name,orderByStr,descStr,limitStr];
    }
    
    
    return selectSql;
}


//根据model生成insert语句
- (NSString *)insertSqlByModel:(NSObject *)model
{
    NSString *table_name = [self tableNameByModel:model];
    
    NSString *columNameStr = @"";
    NSString *valueStr = @"";
    //取得当前类类型
    Class cls = [model class];
    //成员变量个数
    unsigned int ivarsCnt = 0;
    //　获取类成员变量列表，ivarsCnt为类成员数量
    Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
    
    //　遍历成员变量列表，其中每个变量都是Ivar类型的结构体
    for (const Ivar *p = ivars; p < ivars + ivarsCnt; ++p)
    {
        Ivar const ivar = *p;
        
        //　获取变量名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 若此变量未在类结构体中声明而只声明为Property，则变量名加前缀 '_'下划线
        // 比如 @property(retain) NSString *abc;则 key == _abc;
        //　获取变量值
        id value = [model valueForKey:key];
        if (!value) {
            value = @"";
        }
        if ([value isKindOfClass:[NSString class]]) {
            columNameStr = [columNameStr stringByAppendingFormat:@"%@,",key];
            valueStr = [valueStr stringByAppendingFormat:@"'%@',",value];
        }
        
    }
    free(ivars);
    
    if ([[columNameStr substringWithRange:NSMakeRange(columNameStr.length - 1,1)] isEqualToString:@","]) {
        columNameStr = [columNameStr substringToIndex:columNameStr.length - 1];
    }
    if ([[valueStr substringWithRange:NSMakeRange(valueStr.length - 1,1)] isEqualToString:@","]) {
        valueStr = [valueStr substringToIndex:valueStr.length - 1];
    }
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",table_name,columNameStr,valueStr];
    
    return insertSql;
}

//根据参数dict返回参数sql的字符串
- (NSString *)paramStrByDict:(NSDictionary *)paramDict
{
    NSString *paramStr = @"";
    NSInteger count = 0;
    for (NSString *key in paramDict) {
        NSString *value = [paramDict valueForKey:key];
        count++;
        if (count == [paramDict allKeys].count) {
            paramStr = [paramStr stringByAppendingFormat:@"%@='%@'",key,value];
        } else {
            paramStr = [paramStr stringByAppendingFormat:@"%@='%@' and ",key,value];
        }
        
    }
    return paramStr;
}

//队列执行更新sql语句，用于插入、修改、删除，此方法线程安全
-(void)executeQueueNonQuery:(NSString *)sql
{
    //执行更新sql语句，用于插入、修改、删除
    [[FMDatabaseQueueClient sharedClient] inDatabase:^(FMDatabase *db) {
        [db executeQuery:sql];
    }];
}

//队列采用事物执行更新sql语句，用于插入、修改、删除，此方法线程安全
-(void)executeQueueNonQueryInTransaction:(NSArray *)sqlArr
{
    [[FMDatabaseQueueClient sharedClient] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL whoopsSomethingWrongHappened = NO;
        for (NSString *sql in sqlArr) {
            if (![db executeUpdate:sql]) {
                whoopsSomethingWrongHappened = YES;
            }
        }
        if (whoopsSomethingWrongHappened) {
            *rollback = YES;
            return;
        }
    }];
}

//队列执行查询sql语句，此方法线程安全
-(NSArray *)executeQueueQuery:(NSString *)sql
{
    NSMutableArray *array = [NSMutableArray array];
    [[FMDatabaseQueueClient sharedClient] inDatabase:^(FMDatabase *db) {
        //执行查询sql语句
        FMResultSet *result = [db executeQuery:sql];
        while (result.next) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (int i=0; i<result.columnCount; ++i) {
                if ([result stringForColumnIndex:i]) {
                    dic[[result columnNameForIndex:i]] = [result stringForColumnIndex:i];
                }
            }
            [array addObject:dic];
        }
    }];
    return array;
}

//执行更新sql语句，用于插入、修改、删除，多线程不安全
- (BOOL)executeNonQuery:(NSString *)sql arg:(id)arg {
    if (![[FMDatabaseManagerClient sharedClient] executeUpdate:sql,arg]) {
        NSLog(@"执行SQL语句过程中发生错误！");
        return NO;
    }
    return YES;
}

//执行查询sql语句，多线程不安全
- (NSArray *)executeQuery:(NSString *)sql {
    NSMutableArray *array = [NSMutableArray array];
    FMResultSet *result = [[FMDatabaseManagerClient sharedClient] executeQuery:sql];
    while (result.next) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (int i=0; i<result.columnCount; ++i) {
            dic[[result columnNameForIndex:i]] = [result objectForColumnIndex:i];
        }
        [array addObject:dic];
    }
    
    return array;
}

- (BOOL)checkHasTable:(NSString *)tableName
{
    NSArray *resultArray = [self executeQuery:[NSString stringWithFormat:@"SELECT count(*) FROM sqlite_master WHERE type='table' AND name='%@'",tableName]];
    NSInteger tableNum = 0;
    if (resultArray && resultArray.count > 0) {
        tableNum = (NSInteger)[resultArray objectAtIndex:0];
    }
    if (tableNum == 0) {
        return NO;
    } else {
        return YES;
    }
}

@end
