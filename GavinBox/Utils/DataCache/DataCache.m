//
//  DataCache.m
//  GavinBox
//
//  Created by Gavin on 14-10-18.
//  Copyright (c) 2014年 TryingX. All rights reserved.
//

#import "DataCache.h"

@implementation DataCache
+(NSString *)getCacherDirection
{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *pathStr = [array lastObject];
    pathStr = [pathStr stringByAppendingPathComponent:@"LoveXJ"];
    return pathStr;
}
+(void)setObjectData:(NSData *)data withKey:(NSString *)key withColumName:(NSString *)columName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *columDirection  = [self.getCacherDirection stringByAppendingPathComponent:columName];
    NSString *fileName = [columDirection stringByAppendingPathComponent:key];
    
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.getCacherDirection isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:self.getCacherDirection withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (![fileManager fileExistsAtPath:columDirection isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:columDirection withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSError *error;
    @try {
        [data writeToFile:fileName options:NSDataWritingAtomic error:&error];
    }
    @catch (NSException *e) {
        
    }
}
+(NSData *)objectForKey:(NSString *)key withColumName:(NSString *)columName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *columDirection = [self.getCacherDirection stringByAppendingPathComponent:columName];
    NSString *fileName = [columDirection stringByAppendingPathComponent:key];
    
    BOOL isDir = YES;
    if ([fileManager fileExistsAtPath:fileName isDirectory:&isDir]) {
        NSData *data = [NSData dataWithContentsOfFile:fileName];
        return data;
    }
    return nil;
}
+(void)removeObjectWithKey:(NSString *)key withColumName:(NSString *)columName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *columDiretion = [self.getCacherDirection stringByAppendingPathComponent:columName];
    NSString *fileName = [columDiretion stringByAppendingPathComponent:key];
    
    BOOL isdir = YES;
    NSError *error;
    if ([fileManager fileExistsAtPath:fileName isDirectory:&isdir]) {
        [fileManager removeItemAtPath:fileName error:&error];
    }
}
+(void)clearCache //清除缓存
{
    
}
+(float)sizeOfCache //缓存大小
{
    long size = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray* array = [fileManager contentsOfDirectoryAtPath:[self getCacherDirection] error:nil];
    for(int i = 0; i< [array count]; i++)
    {
        NSString *fullPath = [[self getCacherDirection] stringByAppendingPathComponent:[array objectAtIndex:i]];
        
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size+= fileAttributeDic.fileSize;
        }
    }
    return size/(1024.0*1024.0);
}
/*
   历史记录
 */
+(void)addDictObject:(NSDictionary *)dict forKey:(NSString *)key forColumnName:(NSString *)columnName;
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directoryName = [self.getCacherDirection stringByAppendingPathComponent:columnName];
    NSString *fileName = [directoryName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    
    BOOL isDir = YES;
    if (![fileManager fileExistsAtPath:self.getCacherDirection isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:self.getCacherDirection withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if (![fileManager fileExistsAtPath:directoryName isDirectory:&isDir]) {
        [fileManager createDirectoryAtPath:directoryName withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    @try {
       BOOL ret = [dict writeToFile:fileName atomically:YES];
        NSLog(@"ret = %d",ret);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.debugDescription);
        NSLog(@"%@",exception.description);
    }
}
+(NSMutableDictionary *)objectDictForKey:(NSString *)key forColumnName:(NSString *)columnName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directoryName = [self.getCacherDirection stringByAppendingPathComponent:columnName];
    NSString *fileName = [directoryName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    BOOL isDir = YES;
    if ([fileManager fileExistsAtPath:fileName isDirectory:&isDir]) {
      //  NSData *data = [[fileManager attributesOfItemAtPath:fileName error:nil] objectForKey:NSFileModificationDate];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
        return dict;
    }
    
    return nil;
}
+(void)clearHistoryDictForKey:(NSString *)key forColumnName:(NSString *)columnName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directoryName = [self.getCacherDirection stringByAppendingPathComponent:columnName];
    NSString *fileName = [directoryName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",key]];
    BOOL isDir = YES;
    if ([fileManager fileExistsAtPath:directoryName  isDirectory:&isDir]) {
        if ([fileManager fileExistsAtPath:fileName isDirectory:&isDir]) {
            [fileManager removeItemAtPath:fileName error:nil];
        }
    }
}
@end
