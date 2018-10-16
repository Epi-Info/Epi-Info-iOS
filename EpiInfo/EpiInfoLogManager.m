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
    NSThread *activityLogLineRemovalThread = [[NSThread alloc] initWithTarget:self selector:@selector(activityLogLinesRemoval) object:nil];
    [activityLogLineRemovalThread start];
    NSThread *errorLogLineRemovalThread = [[NSThread alloc] initWithTarget:self selector:@selector(errorLogLinesRemoval) object:nil];
    [errorLogLineRemovalThread start];
}

+ (void)activityLogLinesRemoval
{
    NSLog(@"Checking activity log for old lines");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *activityLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Activity_Log.txt"];
    NSString *activityString = [NSString stringWithContentsOfFile:activityLogFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *activityArray = [activityString componentsSeparatedByString:@"\n"];
    
    int firstI = -1;
    
    if (activityArray.count > 2)
    {
        for (int i = 1; i < activityArray.count; i++)
        {
            NSString *firstString = [[[activityArray objectAtIndex:i] componentsSeparatedByString:@" "] objectAtIndex:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [dateFormatter dateFromString:firstString];
            if (!dateFromString)
                continue;
            unsigned int unitFlags = NSCalendarUnitDay;
            
            NSDateComponents *conversionInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:dateFromString toDate:[NSDate date] options:0];
            
            int days = (int)[conversionInfo day];
            
            if (days < 31)
            {
                firstI = i;
                break;
            }
        }
    }
    else
    {
        NSLog(@"Nothing in the activity log");
        return;
    }
    
    if (firstI == -1)
    {
        NSString *stringToWrite = [NSString stringWithFormat:@"%@\n", [activityArray objectAtIndex:0]];
        [stringToWrite writeToFile:activityLogFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"Nothing under 31 dys old in the activity log");
    }
    else if (firstI == 1)
    {
        NSLog(@"Everything under 31 days old in the activity log");
        return;
    }
    else
    {
        NSMutableString *stringToWrite = [[NSMutableString alloc] init];
        [stringToWrite appendString:[NSString stringWithFormat:@"%@\n", [activityArray objectAtIndex:0]]];
        for (int i = firstI; i < activityArray.count; i++)
        {
            [stringToWrite appendString:[NSString stringWithFormat:@"%@\n", [activityArray objectAtIndex:i]]];
        }
        [stringToWrite writeToFile:activityLogFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"Some older than 30 days; some not (in the activity log)");
    }
    NSLog(@"Finished checking activity log");
}

+ (void)errorLogLinesRemoval
{
    NSLog(@"Checking error log for old lines");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *errorLogFile = [[[paths objectAtIndex:0] stringByAppendingString:@"/Logs"] stringByAppendingPathComponent:@"Error_Log.txt"];
    NSString *errorString = [NSString stringWithContentsOfFile:errorLogFile encoding:NSUTF8StringEncoding error:nil];
    NSArray *errorArray = [errorString componentsSeparatedByString:@"\n"];
    
    int firstI = -1;
    
    if (errorArray.count > 2)
    {
        for (int i = 1; i < errorArray.count; i++)
        {
            NSString *firstString = [[[errorArray objectAtIndex:i] componentsSeparatedByString:@" "] objectAtIndex:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSDate *dateFromString = [dateFormatter dateFromString:firstString];
            if (!dateFromString)
                continue;
            unsigned int unitFlags = NSCalendarUnitDay;
            
            NSDateComponents *conversionInfo = [[NSCalendar currentCalendar] components:unitFlags fromDate:dateFromString toDate:[NSDate date] options:0];
            
            int days = (int)[conversionInfo day];
            
            if (days < 31)
            {
                firstI = i;
                break;
            }
        }
    }
    else
    {
        NSLog(@"Nothing in the error log");
        return;
    }
    
    if (firstI == -1)
    {
        NSString *stringToWrite = [NSString stringWithFormat:@"%@\n", [errorArray objectAtIndex:0]];
        [stringToWrite writeToFile:errorLogFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"Nothing under 31 dys old in the error log");
    }
    else if (firstI == 1)
    {
        NSLog(@"Everything under 31 days old in the error log");
        return;
    }
    else
    {
        NSMutableString *stringToWrite = [[NSMutableString alloc] init];
        [stringToWrite appendString:[NSString stringWithFormat:@"%@\n", [errorArray objectAtIndex:0]]];
        for (int i = firstI; i < errorArray.count; i++)
        {
            [stringToWrite appendString:[NSString stringWithFormat:@"%@\n", [errorArray objectAtIndex:i]]];
        }
        [stringToWrite writeToFile:errorLogFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"Some older than 30 days; some not (in the error log)");
    }
    NSLog(@"Finished checking error log");
}
@end
