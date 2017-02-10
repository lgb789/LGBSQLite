//
//  LGBSQLiteManager.h
//  Pods
//
//  Created by lgb789 on 2017/1/4.
//
//

#import <Foundation/Foundation.h>

@interface LGBSQLiteManager : NSObject

/**
 初始化

 @param name 数据库名
 @return LGBSQLiteManager
 */
-(instancetype)initWithDatabaseName:(NSString *)name;

/**
 执行有返回值的sql语句

 @param sql sql语句
 @return 返回的结果
 */
-(NSArray *)executeSqlite:(NSString *)sql;

/**
 执行没有返回值的sql语句

 @param sql sql语句
 @return 是否执行成功
 */
-(BOOL)executeNonSqlite:(NSString *)sql;

@end
