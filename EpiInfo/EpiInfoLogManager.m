//
//  EpiInfoLogManager.m
//  EpiInfo
//
//  Created by John Copeland on 5/16/17.
//

#import "EpiInfoLogManager.h"

@implementation EpiInfoLogManager
+ (void)addToActivityLog:(NSString *)str
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *activityLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Activity_Log.txt"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:activityLogFile];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}

+ (void)addToErrorLog:(NSString *)str
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *errorLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Error_Log.txt"];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:errorLogFile];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}

+ (void)resetActivityLog
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *activityLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Activity_Log.txt"];
    [[NSString stringWithFormat:@"Epi Info iOS App Activity Log\n"] writeToFile:activityLogFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

+ (void)resetErrorLog
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *errorLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Error_Log.txt"];
    [[NSString stringWithFormat:@"Epi Info iOS App Error Log\n"] writeToFile:errorLogFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
}

+ (void)removeOldLinesFromLogs
{
    
}
@end
