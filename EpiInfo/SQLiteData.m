//
//  SQLiteData.m
//  EpiInfo
//
//  Created by John Copeland on 8/12/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "SQLiteData.h"

@implementation SQLiteData
@synthesize databaseButton = _databaseButton;

- (void)makeSQLiteFullTable:(AnalysisDataObject *)ado ProvideUpdatesTo:(UIButton *)button
{
    NSString *buttonText;
    if (button)
    {
        [self setDatabaseButton:button];
        buttonText = [NSString stringWithString:[[self.databaseButton titleLabel].text substringToIndex:[[self.databaseButton titleLabel].text length] - 3]];
    }
    
    //Put the database in the device's temp directory
    NSString *databasePath = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingString:@"EpiInfo.db"]];
    
    //This is the full dataset so delete any database that is already there
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:databasePath error:nil];
    }
    
    //Now create the new database
    if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        //Convert the databasePath NSString to a char array
        const char *dbpath = [databasePath UTF8String];
        
        //Open sqlite3 analysisDB pointing to the databasePath
        if (sqlite3_open(dbpath, &analysisDB) == SQLITE_OK)
        {
            char *errMsg;
            //Build the CREATE TABLE statement
            NSString *sqlStmt = @"CREATE TABLE FULL_DATASET (";
            int vars = 0;
            for (NSString *key in ado.columnNames)
            {
                if (vars == 0)
                    sqlStmt = [sqlStmt stringByAppendingString:key];
                else
                    sqlStmt = [sqlStmt stringByAppendingString:[NSString stringWithFormat:@", %@", key]];
                
                //Conditionally make the columns INTEGER or DECIMAL
                if ([(NSNumber *)[ado.dataTypes objectForKey:[ado.columnNames objectForKey:key]] intValue] == 0)
                    sqlStmt = [sqlStmt stringByAppendingString:@" INTEGER"];
                else if ([(NSNumber *)[ado.dataTypes objectForKey:[ado.columnNames objectForKey:key]] intValue] == 1)
                    sqlStmt = [sqlStmt stringByAppendingString:@" DECIMAL"];
                vars++;
            }
            sqlStmt = [sqlStmt stringByAppendingString:@")"];
            //Convert the sqlStmt to char array
            const char *sql_stmt = [sqlStmt UTF8String];
            
            //Execute the CREATE TABLE statement
            if (sqlite3_exec(analysisDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create full table");
            }
            
            //Insert each row into the table with INSERT INTO VALUES() statements
            int k = 0;
            NSThread *statusThread;
            int denominator = (int)ado.dataSet.count;
            for (NSObject *obj in ado.dataSet)
            {
                NSString *insertStmt = @"INSERT INTO FULL_DATASET VALUES(";
                int iter = -1;
                for (NSString *key in ado.columnNames)
                {
                    iter++;
                    if (iter > 0)
                        insertStmt = [insertStmt stringByAppendingString:@","];
                    if ([[(NSArray *)obj objectAtIndex:[(NSNumber *)[ado.columnNames objectForKey:key] intValue]] isKindOfClass:[NSNull class]])
                    {
                        insertStmt = [insertStmt stringByAppendingString:@"NULL"];
                        continue;
                    }
                    if ([(NSNumber *)[ado.dataTypes objectForKey:[ado.columnNames objectForKey:key]] intValue] == 2)
                        insertStmt = [insertStmt stringByAppendingString:[NSString stringWithFormat:@"'%@'", [[(NSArray *)obj objectAtIndex:[(NSNumber *)[ado.columnNames objectForKey:key] intValue]] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]]];
                    else
                        insertStmt = [insertStmt stringByAppendingString:[(NSArray *)obj objectAtIndex:[(NSNumber *)[ado.columnNames objectForKey:key] intValue]]];
                }
                insertStmt = [insertStmt stringByAppendingString:@")"];
                //Convert the insertStmt to char array
                const char *insert_stmt = [insertStmt UTF8String];
                
                //Execute the INSERTS
                if (sqlite3_exec(analysisDB, insert_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to insert row into full table");
                }
                k++;
                if (self.databaseButton && ![statusThread isExecuting])
                {
                    int percent = (int)(((float)k / (float)denominator) * 100);
                    float rollovers;
                    int modulo = (int)(modff((float)percent / 5.0, &rollovers) * 5.0);
                    if (modulo == 0)
                    {
                        if (percent < 100)
                            statusThread = [[NSThread alloc] initWithTarget:self selector:@selector(provideUpdate:) object:[NSString stringWithFormat:@"%@ %d%%", buttonText, percent]];
                        else
                            statusThread = [[NSThread alloc] initWithTarget:self selector:@selector(provideUpdate:) object:[NSString stringWithFormat:@"%@", buttonText]];
                        [statusThread start];
                    }
                }
            }
            //Close the sqlite connection
            sqlite3_close(analysisDB);
        }
        else
        {
            NSLog(@"Failed to open/create database");
        }
    }
    
    //Copy metadata from AnalysisdataObject (from NSDictionarys to NSArrays
    self.columnNamesWorking = [[NSMutableArray alloc] initWithCapacity:ado.columnNames.count];
    self.dataTypesWorking = [[NSMutableArray alloc] initWithCapacity:ado.columnNames.count];
    self.isBinaryWorking = [[NSMutableArray alloc] initWithCapacity:ado.columnNames.count];
    self.isOneZeroWorking = [[NSMutableArray alloc] initWithCapacity:ado.columnNames.count];
    self.isYesNoWorking = [[NSMutableArray alloc] initWithCapacity:ado.columnNames.count];
    self.isTrueFalseWorking = [[NSMutableArray alloc] initWithCapacity:ado.columnNames.count];
    for (NSString *key in ado.columnNames)
    {
        [self.columnNamesWorking addObject:key];
        [self.dataTypesWorking addObject:(NSNumber *)[ado.dataTypes objectForKey:(NSNumber *)[ado.columnNames objectForKey:key]]];
        [self.isBinaryWorking addObject:(NSNumber *)[ado.isBinary objectForKey:(NSNumber *)[ado.columnNames objectForKey:key]]];
        [self.isOneZeroWorking addObject:(NSNumber *)[ado.isOneZero objectForKey:(NSNumber *)[ado.columnNames objectForKey:key]]];
        [self.isYesNoWorking addObject:(NSNumber *)[ado.isYesNo objectForKey:(NSNumber *)[ado.columnNames objectForKey:key]]];
        [self.isTrueFalseWorking addObject:(NSNumber *)[ado.isTrueFalse objectForKey:(NSNumber *)[ado.columnNames objectForKey:key]]];
    }
    self.columnNamesFull = [NSArray arrayWithArray:self.columnNamesWorking];
    self.dataTypesFull = [NSArray arrayWithArray:self.dataTypesWorking];
    self.isBinaryFull = [NSArray arrayWithArray:self.isBinaryWorking];
    self.isOneZeroFull = [NSArray arrayWithArray:self.isOneZeroWorking];
    self.isYesNoFull = [NSArray arrayWithArray:self.isYesNoWorking];
    self.isTrueFalseFull = [NSArray arrayWithArray:self.isTrueFalseWorking];
}

- (void)provideUpdate:(NSString *)buttonLabel
{
    [self.databaseButton setTitle:buttonLabel forState:UIControlStateHighlighted];
}

- (void)makeSQLiteWorkingTableWithWhereClause:(NSString *)whereClause
{
    //This method is called when WORKING_DATASET is to be a subset of FULL_DATASET
    
    //Get the path to the database
    NSString *databasePath = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingString:@"EpiInfo.db"]];
    
    //If it exists, create the WORKING_DATASET table
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        //Convert the databasePath NSString to a char array
        const char *dbpath = [databasePath UTF8String];
        
        //Open the sqlite analysisDB pointing to the database path
        if (sqlite3_open(dbpath, &analysisDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt = "DROP TABLE WORKING_DATASET";
            if (sqlite3_exec(analysisDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to drop working table");
            }
            //Create and execute the CREATE TABLE statement
            NSString *sqlStmt = [NSString stringWithFormat:@"CREATE TABLE WORKING_DATASET AS SELECT * FROM FULL_DATASET %@", whereClause];
            sql_stmt = [sqlStmt UTF8String];
            if (sqlite3_exec(analysisDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create working table");
            }
            //Close the database connection
            sqlite3_close(analysisDB);
        }
        else
        {
            NSLog(@"Failed to open database");
        }
    }
}

- (void)makeSQLiteWorkingTable
{
    //This method is called when WORKING_DATASET is to be the same as FULL_DATASET
    
    //Get the path to the database
    NSString *databasePath = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingString:@"EpiInfo.db"]];
    
    //If it exists, create the WORKING_DATASET table
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        //Convert the databasePath NSString to a char array
        const char *dbpath = [databasePath UTF8String];
        
        //Open the sqlite analysisDB pointing to the database path
        if (sqlite3_open(dbpath, &analysisDB) == SQLITE_OK)
        {
            char *errMsg;
            //Create and execute the CREATE TABLE statement
            const char *sql_stmt = "CREATE TABLE WORKING_DATASET AS SELECT * FROM FULL_DATASET";
            if (sqlite3_exec(analysisDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create working table");
            }
            //Close the database connection
            sqlite3_close(analysisDB);
        }
        else
        {
            NSLog(@"Failed to open database");
        }
    }
}

- (int)addColumnToWorkingTable:(NSString *)columnName ColumnType:(NSNumber *)columnType
{
    //Get the path to the database
    NSString *databasePath = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingString:@"EpiInfo.db"]];
    
    //If it exists, create the WORKING_DATASET table
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        //Convert the databasePath NSString to a char array
        const char *dbpath = [databasePath UTF8String];
        
        //Open the sqlite analysisDB pointing to the database path
        if (sqlite3_open(dbpath, &analysisDB) == SQLITE_OK)
        {
            char *errMsg;
            //Create and execute the ALTER TABLE statement
            NSString *alterStmt = [NSString stringWithFormat:@"ALTER TABLE WORKING_DATASET ADD %@", columnName];
            if ([columnType intValue] == 0)
                alterStmt = [alterStmt stringByAppendingString:@" INTEGER"];
            else if ([columnType intValue] == 1)
                alterStmt = [alterStmt stringByAppendingString:@" DECIMAL"];
            const char *sql_stmt = [alterStmt UTF8String];
            if (sqlite3_exec(analysisDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to alter working table");
                return [self workingTableSize];
            }
            //Close the database connection
            sqlite3_close(analysisDB);
        }
        else
        {
            NSLog(@"Failed to open database");
            return [self workingTableSize];
        }
        [self.columnNamesWorking addObject:columnName];
        if ([columnType intValue] == 3)
        {
            [self.dataTypesWorking addObject:[NSNumber numberWithInt:2]];
            [self.isBinaryWorking addObject:[NSNumber numberWithBool:YES]];
            [self.isOneZeroWorking addObject:[NSNumber numberWithBool:NO]];
            [self.isTrueFalseWorking addObject:[NSNumber numberWithBool:NO]];
            [self.isYesNoWorking addObject:[NSNumber numberWithBool:YES]];
        }
        else
        {
            [self.dataTypesWorking addObject:columnType];
            [self.isBinaryWorking addObject:[NSNumber numberWithBool:NO]];
            [self.isOneZeroWorking addObject:[NSNumber numberWithBool:NO]];
            [self.isTrueFalseWorking addObject:[NSNumber numberWithBool:NO]];
            [self.isYesNoWorking addObject:[NSNumber numberWithBool:NO]];
        }
    }
    return [self workingTableSize];
}

- (int)workingTableSize
{
    //This method gets and returns the size of WORKING_DATASET by submitting SELECT COUNT(*)
    int size = -1;
    
    NSString *databasePath = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingString:@"EpiInfo.db"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &analysisDB) == SQLITE_OK)
        {
            const char *query_stmt = "SELECT COUNT(*) AS N FROM WORKING_DATASET";
            if (sqlite3_prepare_v2(analysisDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    size = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(analysisDB);
    }
    
    return size;
}

- (int)fullTableSize
{
    //This method gets and returns the size of WORKING_DATASET by submitting SELECT COUNT(*)
    int size = -1;
    
    NSString *databasePath = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingString:@"EpiInfo.db"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_open(dbpath, &analysisDB) == SQLITE_OK)
        {
            const char *query_stmt = "SELECT COUNT(*) AS N FROM FULL_DATASET";
            if (sqlite3_prepare_v2(analysisDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    size = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(analysisDB);
    }
    
    return size;
}
@end
