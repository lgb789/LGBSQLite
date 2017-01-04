//
//  LGBSQLiteManager.m
//  Pods
//
//  Created by lgb789 on 2017/1/4.
//
//

#import "LGBSQLiteManager.h"
#import <sqlite3.h>
#import <CommonCrypto/CommonDigest.h>

#define kDatabaseName    @"LGBSQLite.db"

@interface LGBSQLiteManager ()
@property (nonatomic, assign) sqlite3 *database;
@end

@implementation LGBSQLiteManager

+(LGBSQLiteManager *)shared
{
    static LGBSQLiteManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [LGBSQLiteManager new];
    });
    return _manager;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self openDatabase];
    }
    return self;
}

-(NSString *)md5WithString:(NSString *)str
{
    const char *ptr = [str UTF8String];
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(ptr, (unsigned int)strlen(ptr), md5Buffer);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", md5Buffer[i]];
    }
    
    return output;
}

-(NSString *)getFileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filename = [self md5WithString:kDatabaseName];
    filename = [path stringByAppendingPathComponent:filename];
    return filename;
}

-(BOOL)openDatabase
{
    NSString *filename = [self getFileName];
    if(sqlite3_open([filename UTF8String], &_database) != SQLITE_OK){
        return NO;
    }
    return YES;
}

-(NSArray *)executeSqlite:(NSString *)sql
{
    NSMutableArray *arr = [NSMutableArray array];
    sqlite3_stmt *stmt;
    if(sqlite3_prepare_v2(_database, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK){
        while(sqlite3_step(stmt) == SQLITE_ROW){
            int columntCount = sqlite3_column_count(stmt);
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            for (int i = 0; i < columntCount; i++) {
                const char *name = sqlite3_column_name(stmt, i);
                const unsigned char *value = sqlite3_column_text(stmt, i);
                [dic setObject:[NSString stringWithUTF8String:(const char *)value] forKey:[NSString stringWithUTF8String:name]];
            }
            [arr addObject:dic];
        }
    }
    return arr;
}

-(BOOL)executeNonSqlite:(NSString *)sql
{
    char *err;
    if(sqlite3_exec(_database, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK){
        NSLog(@"sql excute err:%s", err);
        return NO;
    }
    return YES;
}

@end
