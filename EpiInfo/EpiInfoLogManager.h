//
//  EpiInfoLogManager.h
//  EpiInfo
//
//  Created by John Copeland on 5/16/17.
//

#import <Foundation/Foundation.h>

@interface EpiInfoLogManager : NSObject
+(void)addToActivityLog:(NSString *)str;
+(void)addToErrorLog:(NSString *)str;
+(void)resetActivityLog;
+(void)resetErrorLog;
+(void)removeOldLinesFromLogs;
@end
