//
//  LGBSQLiteStorage.h
//  Pods
//
//  Created by lgb789 on 2017/1/4.
//
//

#import <Foundation/Foundation.h>

@interface LGBSQLiteStorage : NSObject


/**
 初始化

 @param name 要保存的类
 @param dbName 数据库名
 @return LGBSQLiteStorage
 */
-(instancetype)initWithClass:(Class)name dbName:(NSString *)dbName;

/**
 初始化

 @param name 类名
 @return LGBSQLiteStorage
 */
-(instancetype)initWithClass:(Class)name;

/**
 插入一个对象到数据库

 @param obj 要插入的对象
 @return 是否插入成功
 */
-(BOOL)insertObj:(id)obj;

/**
 删除数据库中的一个对象

 @param obj 要删除的对象
 @return 是否删除成功
 */
-(BOOL)deleteObj:(id)obj;

/**
 通过属性值删除对象

 @param key 属性名
 @param value 属性值
 @return 是否删除成功
 */
-(BOOL)deleteObjByKey:(NSString *)key value:(id)value;

/**
 根据属性值修改对象

 @param obj 要修改的对象
 @param key 属性名
 @return 是否修改成功
 */
-(BOOL)updateObj:(id)obj key:(NSString *)key;

/**
 获取所有对象

 @return 对象数组
 */
-(NSArray *)getObjs;

/**
 通过属性获取对象

 @param key 属性名
 @param value 属性值
 @return 对象数组
 */
-(NSArray *)getObjsByKey:(NSString *)key value:(id)value;

/**
 从开始位置获取指定数量对象

 @param fromIndex 开始位置
 @param count 要获取的数量
 @return 返回对象数组
 */
-(NSArray *)getObjsFrom:(NSInteger)fromIndex count:(NSInteger)count;

@end
