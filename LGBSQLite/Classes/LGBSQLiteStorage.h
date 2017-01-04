//
//  LGBSQLiteStorage.h
//  Pods
//
//  Created by lgb789 on 2017/1/4.
//
//

#import <Foundation/Foundation.h>

@interface LGBSQLiteStorage : NSObject

-(instancetype)initWithClass:(Class)name dbName:(NSString *)dbName;

-(BOOL)insertObj:(id)obj;

-(BOOL)deleteObj:(id)obj;

-(BOOL)deleteObjByKey:(NSString *)key value:(id)value;

-(BOOL)updateObj:(id)obj key:(NSString *)key;

-(NSArray *)getObjs;

-(NSArray *)getObjsByKey:(NSString *)key value:(id)value;

@end
