//
//  XJDataCache.h
//  GavinBox
//
//  Created by Gavin on 14-10-18.
//  Copyright (c) 2014年 TryingX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject
+(NSString *)getCacherDirection;

+(void)setObjectData:(NSData *)data withKey:(NSString *)key withColumName:(NSString *)columName;
+(NSData *)objectForKey:(NSString *)key withColumName:(NSString *)columName;
+(void)removeObjectWithKey:(NSString *)key withColumName:(NSString *)columName;
+(void)clearCache; //清除缓存
+(float)sizeOfCache; //缓存大小

/*
   历史记录
*/
+(void)addDictObject:(NSDictionary *)dict forKey:(NSString *)key forColumnName:(NSString *)columnName;
+(NSMutableDictionary *)objectDictForKey:(NSString *)key forColumnName:(NSString *)columnName;
+(void)clearHistoryDictForKey:(NSString *)key forColumnName:(NSString *)columnName;

@end
