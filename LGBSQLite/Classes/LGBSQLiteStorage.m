//
//  LGBSQLiteStorage.m
//  Pods
//
//  Created by lgb789 on 2017/1/4.
//
//

#import "LGBSQLiteStorage.h"
#import <objc/runtime.h>
#import "LGBSQLiteManager.h"

static const NSString *__defaultDataBase = @"__defaultDataBase";

@interface LGBSQLiteStorage ()
@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) NSMutableArray *properties;
@property (nonatomic, strong) LGBSQLiteManager *manager;
@end

@implementation LGBSQLiteStorage

-(BOOL)createTableWithClass:(Class)name
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(name, &count);
    NSString *columns = @"";
    NSString *type = @"text";
    for (int i = 0; i < count; i++) {
        objc_property_t p = properties[i];
        NSString *pName = [NSString stringWithUTF8String:property_getName(p)];
        [self.properties addObject:pName];
        if (columns.length > 0) {
            columns = [columns stringByAppendingString:@","];
        }
        columns = [columns stringByAppendingString:[NSString stringWithFormat:@"%@ %@", pName, type]];
    }
    
    free(properties);
    NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (%@)", self.tableName, columns];
    return [self.manager executeNonSqlite:sql];
}

-(instancetype)initWithClass:(Class)name dbName:(NSString *)dbName
{
    self = [super init];
    if (self) {
        self.tableName = [NSString stringWithUTF8String:class_getName(name)];
        self.manager = [[LGBSQLiteManager alloc] initWithDatabaseName:(dbName ? dbName : __defaultDataBase)];
        if([self createTableWithClass:name] == NO){
            NSLog(@"create table error.");
        }
    }
    return self;
}

-(instancetype)initWithClass:(Class)name
{
    return [self initWithClass:name dbName:nil];
}

-(BOOL)insertObj:(id)obj
{
    NSString *columns = @"";
    NSString *values = @"";
    for (NSString *n in self.properties) {
        if (columns.length > 0) {
            columns = [columns stringByAppendingString:@","];
        }
        columns = [columns stringByAppendingString:n];
        
        if (values.length > 0) {
            values = [values stringByAppendingString:@","];
        }
        id v = [obj valueForKey:n];
        values = [values stringByAppendingString:[NSString stringWithFormat:@"'%@'", v]];
    }
    NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@) values(%@)", self.tableName, columns, values];
    NSLog(@"add sql:%@", sql);
    return [self.manager executeNonSqlite:sql];
}

-(BOOL)deleteObj:(id)obj
{
    NSString *columns = @"";
    
    for (NSString *n in self.properties) {
        if (columns.length > 0) {
            columns = [columns stringByAppendingString:@" and "];
        }
        id v = [obj valueForKey:n];
        columns = [columns stringByAppendingString:[NSString stringWithFormat:@"%@='%@'", n, v]];
    }
    
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@", self.tableName, columns];
    NSLog(@"del sql:%@", sql);
    return [self.manager executeNonSqlite:sql];
}

-(BOOL)deleteObjByKey:(NSString *)key value:(id)value
{
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@='%@'", self.tableName, key, value];
    return [self.manager executeNonSqlite:sql];
}

-(BOOL)updateObj:(id)obj key:(NSString *)key
{
    NSString *columns = @"";
    for (NSString *n in self.properties) {
        id value = [obj valueForKey:n];
        NSString *c = [NSString stringWithFormat:@"%@='%@'", n, value];
        if (columns.length > 0) {
            columns = [columns stringByAppendingString:@","];
        }
        columns = [columns stringByAppendingString:c];
    }
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@ where %@='%@'", self.tableName, columns, key, [obj valueForKey:key]];
    return [self.manager executeNonSqlite:sql];
}

-(NSArray *)getObjs
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@", self.tableName];
    return [self getObjsWithSql:sql];
}

-(NSArray *)getObjsByKey:(NSString *)key value:(id)value
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@='%@'", self.tableName, key, value];
    return [self getObjsWithSql:sql];
}

-(NSArray *)getObjsWithSql:(NSString *)sql
{
    NSArray *arr = [self.manager executeSqlite:sql];
    NSMutableArray *objs = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        Class c = NSClassFromString(self.tableName);
        id obj = [c new];
        
        for (NSString *n in self.properties) {
            id value = [dic objectForKey:n];
            [obj setValue:value forKey:n];
            
        }
        
        [objs addObject:obj];
    }
    return objs;
}

-(NSArray *)getObjsFrom:(NSInteger)fromIndex count:(NSInteger)count
{
    NSString *sql = [NSString stringWithFormat:@"select * from %@ limit %d offset %d", self.tableName, count, fromIndex];
    return [self getObjsWithSql:sql];
}

-(NSMutableArray *)properties
{
    if (_properties == nil) {
        _properties = [NSMutableArray array];
    }
    return _properties;
}

@end
