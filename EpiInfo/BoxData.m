//
//  BoxData.m
//  EpiInfo
//
//  Created by John Copeland on 6/9/20.
//

#import "BoxData.h"
#import "EnterDataView.h"
#import "EpiInfoControlProtocol.h"
#import "YesNo.h"
#import "LegalValuesEnter.h"
#import "EpiInfoOptionField.h"
#import "NumberField.h"
#import "sqlite3.h"
@import BoxContentSDK;

@implementation BoxData

- (id)initWithFormName:(NSString *)fn AndDictionaryOfPages:(NSDictionary *)dop AndNoTwo:(BOOL)no2
{
    self = [super init];
    if (self)
    {
        formName = fn;
        notwo = no2;
        
        NSMutableDictionary *mutableDictionaryOfControls = [[NSMutableDictionary alloc] init];
        NSMutableArray *mutableArrayOfYesNoFieldNames = [[NSMutableArray alloc] init];
        for (NSString *key in dop)
        {
            EnterDataView *tempedv = (EnterDataView *)[dop objectForKey:key];
            for (UIView *v in [[tempedv formCanvas] subviews])
            {
                if ([v conformsToProtocol:@protocol(EpiInfoControlProtocol)])
                {
                    [mutableDictionaryOfControls setObject:v forKey:[(UIView <EpiInfoControlProtocol> *)v columnName]];
                    if ([v isKindOfClass:[YesNo class]])
                        [mutableArrayOfYesNoFieldNames addObject:[[(YesNo *)v columnName] lowercaseString]];
                }
            }
        }
        arrayOfYesNoFieldNames = [NSArray arrayWithArray:mutableArrayOfYesNoFieldNames];
        dictionaryOfControls = [NSDictionary dictionaryWithDictionary:mutableDictionaryOfControls];
    }
    return self;
}

- (BOOL)sendAllRecordsToBox
{
    NSThread *boxThread = [[NSThread alloc] initWithTarget:self selector:@selector(sendAllRecordsToBoxInBackground) object:nil];
    [boxThread start];
    return YES;
}

- (BOOL)sendAllRecordsToBoxInBackground
{
    sqlite3 *epiinfoDB;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select * from %@", formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    // SEND FOREIGN KEYS TO BOX IF FORM IS A CHILD FORM
                    NSMutableDictionary *boxDictionary = [[NSMutableDictionary alloc] init];
                    if (notwo)
                        [boxDictionary setObject:[NSNumber numberWithInt:1003036077] forKey:@"_updateStamp"];
                    int i = 0;
                    while (sqlite3_column_name(statement, i))
                    {
                        NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                        if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                        {
                            [boxDictionary setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] forKey:@"id"];
                        }
                        else
                        {
                            if (notwo)
                            {
                                if ([arrayOfYesNoFieldNames containsObject:[columnName lowercaseString]])
                                {
                                    int ynvalue = 0;
                                    NSString *ynstringvalue = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                                    if (ynstringvalue)
                                    {
                                        if ([ynstringvalue length] > 0 && ![ynstringvalue containsString:@"null"])
                                        {
                                            ynvalue = 2 - [ynstringvalue intValue];
                                        }
                                     }
                                    [boxDictionary setObject:[NSNumber numberWithInt:ynvalue] forKey:columnName];
                                    i++;
                                    continue;
                                }
                            }
                            NSObject *columnText = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                            if ([(NSString *)columnText isEqualToString:@"(null)"])
                            {
                                i++;
                                continue;
                            }
                            if ([dictionaryOfControls objectForKey:columnName])
                            {
                                UIView *controlForColumn = [dictionaryOfControls objectForKey:columnName];
                                if ([controlForColumn isKindOfClass:[NumberField class]])
                                {
                                    NSDecimalNumber *nsdn = [NSDecimalNumber decimalNumberWithString:(NSString *)columnText];
                                    columnText = nsdn;
                                }
                                else if ([arrayOfYesNoFieldNames containsObject:[columnName lowercaseString]])
                                {
                                    if ([(NSString *)columnText length] > 0)
                                    {
                                        int ynvalue = [(NSString *)columnText intValue];
                                        columnText = [NSNumber numberWithInt:ynvalue];
                                    }
                                }
                                else if ([controlForColumn isKindOfClass:[EpiInfoOptionField class]])
                                {
                                    
                                }
                                else if ([controlForColumn isKindOfClass:[LegalValuesEnter class]])
                                {
                                    NSArray *valuesArray = [(LegalValuesEnter *)controlForColumn listOfStoredValues];
                                    if ([valuesArray containsObject:columnText])
                                    {
                                        unsigned long indexOfObject = [valuesArray indexOfObject:columnText];
                                        columnText = [NSString stringWithFormat:@"%lu", indexOfObject];
                                    }
                                }
                            }
                            [boxDictionary setObject:columnText forKey:columnName];
                        }
                        i++;
                    }
                    // JSON section for Box;
                    NSArray *users = [BOXContentClient users];
                    if ([users count] > 0)
                    {
                        NSError *jerror;
                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:boxDictionary options:0 error:&jerror];
                        if (jsonData)
                        {
                            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                            NSLog(@"\n%@", jsonString);
                        }
                        else
                        {
                            NSLog(@"%@", jerror);
                        }
                        BOXUser *user0 = [users objectAtIndex:0];
                        BOXContentClient *client0 = [BOXContentClient clientForUser:user0];
                        BOXSearchRequest *searchRequest = [client0 searchRequestWithQuery:@"__EpiInfo" inRange:NSMakeRange(0, 1000)];
                        [searchRequest setType:@"folder"];
                        [searchRequest setContentTypes:@[@"name"]];
                    }
                }
            }
        }
    }
    else
        return NO;
    return YES;
}

- (BOOL)retrieveAllRecordsFromBox
{
    return YES;
}

@end
