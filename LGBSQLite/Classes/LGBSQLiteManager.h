//
//  LGBSQLiteManager.h
//  Pods
//
//  Created by lgb789 on 2017/1/4.
//
//

#import <Foundation/Foundation.h>

@interface LGBSQLiteManager : NSObject

+(LGBSQLiteManager *)shared;

-(NSArray *)executeSqlite:(NSString *)sql;

-(BOOL)executeNonSqlite:(NSString *)sql;

@end
