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
#import "sqlite3.h"

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
