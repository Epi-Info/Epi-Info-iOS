//
//  TablesObject.m
//  EpiInfo
//
//  Created by labuser on 7/1/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "TablesObject.h"
#import "TablesView.h"
#import "VariableValueMapper.h"

@implementation TablesObject
@synthesize outcomeVariable = _outcomeVariable;
@synthesize exposureVariable = _exposureVariable;
@synthesize outcomeValues = _outcomeValues;
@synthesize exposureValues = _exposureValues;
@synthesize cellCounts = _cellCounts;

- (id)initWithAnalysisDataObject:(AnalysisDataObject *)dataSet AndOutcomeVariable:(NSString *)outcomeVariable AndExposureVariable:(NSString *)exposureVariable AndIncludeMissing:(BOOL)includeMissing
{
    self = [super init];
    
    [self setOutcomeVariable:outcomeVariable];
    [self setExposureVariable:exposureVariable];
    
    //Get and sort all values of outcome variable
    //Temporary array for storing values
    NSMutableArray *oma = [[NSMutableArray alloc] init];
    //Boolean for whether outcome variable has any null values
    BOOL hasANull = NO;
    //The outcome variable's column number in the AnalysisDataObject
    int outcomeColumnNumber = [(NSNumber *)[dataSet.columnNames objectForKey:self.outcomeVariable] intValue];
    //Integer case first
    if ([(NSNumber *)[dataSet.dataTypes objectForKey:[NSString stringWithFormat:@"%d", outcomeColumnNumber]] intValue] == 0)
    {
        //Loop through all data rows
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![oma containsObject:[NSNumber numberWithInt:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] intValue]]])
                [oma addObject:[NSNumber numberWithInt:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] intValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZero objectForKey:[NSString stringWithFormat:@"%d", outcomeColumnNumber]] boolValue])
            [oma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [oma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [oma addObject:[NSNull null]];
    }
    //Float case
    else if ([(NSNumber *)[dataSet.dataTypes objectForKey:[NSString stringWithFormat:@"%d", outcomeColumnNumber]] intValue] == 1)
    {
        //Loop through all data rows
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![oma containsObject:[NSNumber numberWithDouble:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] doubleValue]]])
                [oma addObject:[NSNumber numberWithDouble:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] doubleValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZero objectForKey:[NSString stringWithFormat:@"%d", outcomeColumnNumber]] boolValue])
            [oma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [oma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [oma addObject:[NSNull null]];
    }
    //String case
    else
    {
        //Loop through all data rows
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![oma containsObject:[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber]])
                [oma addObject:[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber]];
        }
        
        //Sort the temporary array
        //If it is Yes/No, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isYesNo objectForKey:[NSString stringWithFormat:@"%d", outcomeColumnNumber]] boolValue])
            [oma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [oma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [oma addObject:[NSNull null]];
    }
    
    //Do the same thing for the exposure variable
    NSMutableArray *ema = [[NSMutableArray alloc] init];
    hasANull = NO;
    int exposureColumnNumber = [(NSNumber *)[dataSet.columnNames objectForKey:self.exposureVariable] intValue];
    if ([(NSNumber *)[dataSet.dataTypes objectForKey:[NSString stringWithFormat:@"%d", exposureColumnNumber]] intValue] == 0)
    {
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            if (![ema containsObject:[NSNumber numberWithInt:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] intValue]]])
                [ema addObject:[NSNumber numberWithInt:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] intValue]]];
        }
        
        if ([(NSNumber *)[dataSet.isOneZero objectForKey:[NSString stringWithFormat:@"%d", exposureColumnNumber]] boolValue])
            [ema sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [ema sortUsingSelector:@selector(compare:)];
        
        if (includeMissing && hasANull)
            [ema addObject:[NSNull null]];
    }
    else if ([(NSNumber *)[dataSet.dataTypes objectForKey:[NSString stringWithFormat:@"%d", exposureColumnNumber]] intValue] == 1)
    {
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            if (![ema containsObject:[NSNumber numberWithDouble:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] doubleValue]]])
                [ema addObject:[NSNumber numberWithDouble:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] doubleValue]]];
        }
        
        if ([(NSNumber *)[dataSet.isOneZero objectForKey:[NSString stringWithFormat:@"%d", exposureColumnNumber]] boolValue])
            [ema sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [ema sortUsingSelector:@selector(compare:)];
        
        if (includeMissing && hasANull)
            [ema addObject:[NSNull null]];
    }
    else
    {
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            if (![ema containsObject:[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber]])
                [ema addObject:[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber]];
        }
        
        if ([(NSNumber *)[dataSet.isYesNo objectForKey:[NSString stringWithFormat:@"%d", exposureColumnNumber]] boolValue])
            [ema sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [ema sortUsingSelector:@selector(compare:)];
        
        if (includeMissing && hasANull)
            [ema addObject:[NSNull null]];
    }
    
    //Copy the temporary values arrays to the class property values arrays
    [self setOutcomeValues:[NSArray arrayWithArray:oma]];
    [self setExposureValues:[NSArray arrayWithArray:ema]];
    
    //Get the counts for each cell
    //Start with C-array of ints
    int counts[self.outcomeValues.count * self.exposureValues.count];
    for (int i = 0; i < self.outcomeValues.count * self.exposureValues.count; i++)
        counts[i] = 0;
    //Instantiate an index for counts
    int j = 0;
    //Loop over exposure and outcome values; loop over dataset and compare dataset values to possible values
    //Increment counts[j] when applicable
    for (int a = 0; a < self.exposureValues.count; a++)
    {
        //Get the working current value if not null
        NSString *exposureString = @"";
        if (![[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] &&
            [(NSNumber *)[dataSet.dataTypes objectForKey:[NSString stringWithFormat:@"%d", exposureColumnNumber]] intValue] < 2)
            exposureString = [[self.exposureValues objectAtIndex:a] stringValue];
        else if (![[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]])
            exposureString = [self.exposureValues objectAtIndex:a];
        
        for (int b = 0; b < self.outcomeValues.count; b++)
        {
            //Get the current outcome value if not null
            NSString *outcomeString = @"";
            if (![[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] &&
                [(NSNumber *)[dataSet.dataTypes objectForKey:[NSString stringWithFormat:@"%d", outcomeColumnNumber]] intValue] < 2)
                outcomeString = [[self.outcomeValues objectAtIndex:b] stringValue];
            else if (![[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]])
                outcomeString = [self.outcomeValues objectAtIndex:b];
            
            for (int i = 0; i < dataSet.dataSet.count; i++)
            {
                //If at least one of the dataset values is null
                if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] isKindOfClass:[NSNull class]] ||
                    [[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] isKindOfClass:[NSNull class]])
                {
                    if (!includeMissing)
                        continue;

                    //If outcome and exposure are null
                    if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] isKindOfClass:[NSNull class]] &&
                        [[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] isKindOfClass:[NSNull class]])
                    {
                        if ([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] &&
                            [[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]])
                            counts[j]++;
                    }
                    //If only outcome is null
                    else if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] isKindOfClass:[NSNull class]])
                    {
                        if ([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] &&
                            [[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] isEqualToString:exposureString])
                            counts[j]++;
                    }
                    //If only exposure is null
                    else
                    {
                        if ([[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] &&
                            [[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] isEqualToString:outcomeString])
                            counts[j]++;
                    }
                    continue;
                }
                
                //If neither dataset value is null                
                if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:outcomeColumnNumber] isEqualToString:outcomeString] &&
                    [[[dataSet.dataSet objectAtIndex:i] objectAtIndex:exposureColumnNumber] isEqualToString:exposureString])
                    counts[j]++;
            }
            j++;
        }
    }
    
    //Copy the temporary array of counts to the class property
    NSMutableArray *tempCountsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.outcomeValues.count * self.exposureValues.count; i++)
        [tempCountsArray addObject:[NSNumber numberWithInt:counts[i]]];
    [self setCellCounts:[NSArray arrayWithArray:tempCountsArray]];
    
    return self;
}

- (id)initWithSQLiteData:(SQLiteData *)dataSet AndWhereClause:(NSString *)whereClause AndOutcomeVariable:(NSString *)outcomeVariable AndExposureVariable:(NSString *)exposureVariable AndIncludeMissing:(BOOL)includeMissing
{
    self = [super init];
    
    [self setOutcomeVariable:outcomeVariable];
    [self setExposureVariable:exposureVariable];
    
    //Make arrays to hold the row values for the variables
    NSMutableArray *outcomeArray = [[NSMutableArray alloc] init];
    NSMutableArray *exposureArray = [[NSMutableArray alloc] init];
    
    //Get the path to the sqlite database
    NSString *databasePath = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingString:@"EpiInfo.db"]];
    
    //If the database exists, query the WORKING_DATASET
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        //Convert the databasePath to a char array
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        
        //Open the database
        if (sqlite3_open(dbpath, &analysisDB) == SQLITE_OK)
        {
            //Build the SELECT statement
            NSString *queryStmt = [[[[@"SELECT " stringByAppendingString:outcomeVariable] stringByAppendingString:@", "] stringByAppendingString:exposureVariable] stringByAppendingString:@" FROM WORKING_DATASET"];
            if (whereClause)
                queryStmt = [queryStmt stringByAppendingString:[NSString stringWithFormat:@" %@", whereClause]];
            //Convert the SELECT statement to a char array
           const char *query_stmt = [queryStmt UTF8String];
            //Execute the SELECT statement
            if (sqlite3_prepare_v2(analysisDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                //While the statement returns rows, read the column queried and put the values in the outcomeArray and exposureArray
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    if (!sqlite3_column_text(statement, 0))
                    {
                        [outcomeArray addObject:[NSNull null]];
                    }
                    else
                    {
                        NSString *rslt0 = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                        NSString *rslt = [NSString stringWithUTF8String:[rslt0 cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                        [outcomeArray addObject:rslt];
                    }
                    if (!sqlite3_column_text(statement, 1))
                    {
                        [exposureArray addObject:[NSNull null]];
                    }
                    else
                    {
                        NSString *rslt0 = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                        NSString *rslt = [NSString stringWithUTF8String:[rslt0 cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                        [exposureArray addObject:rslt];
                    }
                }
            }
            sqlite3_finalize(statement);
        }
        //Close the sqlite database
        sqlite3_close(analysisDB);
    }
    
    //Get and sort all values of outcome variable
    //Temporary array for storing values
    NSMutableArray *oma = [[NSMutableArray alloc] init];
    //Boolean for whether outcome variable has any null values
    BOOL hasANull = NO;
    //The outcome variable's column number in the array of column names
    int outcomeColumnNumber = (int)[dataSet.columnNamesWorking indexOfObject:self.outcomeVariable];
    //Integer case first
    if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:outcomeColumnNumber] intValue] == 0)
    {
        //Loop through all data rows
        for (int i = 0; i < outcomeArray.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![oma containsObject:[NSNumber numberWithInt:[[outcomeArray objectAtIndex:i] intValue]]])
                [oma addObject:[NSNumber numberWithInt:[[outcomeArray objectAtIndex:i] intValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:outcomeColumnNumber] boolValue])
            [oma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [oma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [oma addObject:[NSNull null]];
    }
    //Float case
    else if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:outcomeColumnNumber] intValue] == 1)
    {
        //Loop through all data rows
        for (int i = 0; i < outcomeArray.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![oma containsObject:[NSNumber numberWithDouble:[[outcomeArray objectAtIndex:i] doubleValue]]])
                [oma addObject:[NSNumber numberWithDouble:[[outcomeArray objectAtIndex:i] doubleValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:outcomeColumnNumber] boolValue])
            [oma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [oma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [oma addObject:[NSNull null]];
    }
    //String case
    else
    {
        //Loop through all data rows
        for (int i = 0; i < outcomeArray.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            if ([[outcomeArray objectAtIndex:i] isEqualToString:@"(null)"])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![oma containsObject:[outcomeArray objectAtIndex:i]])
                [oma addObject:[outcomeArray objectAtIndex:i]];
        }
        
        //Sort the temporary array
        //If it is Yes/No, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isYesNoWorking objectAtIndex:outcomeColumnNumber] boolValue] || [(NSNumber *)[dataSet.isTrueFalseWorking objectAtIndex:outcomeColumnNumber] boolValue])
            [oma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [oma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [oma addObject:[NSNull null]];
    }
    
    //Do the same thing for the exposure variable
    NSMutableArray *ema = [[NSMutableArray alloc] init];
    hasANull = NO;
    int exposureColumnNumber = (int)[dataSet.columnNamesWorking indexOfObject:self.exposureVariable];
    if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:exposureColumnNumber] intValue] == 0)
    {
        for (int i = 0; i < exposureArray.count; i++)
        {
            if ([[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            if (![ema containsObject:[NSNumber numberWithInt:[[exposureArray objectAtIndex:i] intValue]]])
                [ema addObject:[NSNumber numberWithInt:[[exposureArray objectAtIndex:i] intValue]]];
        }
        
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:exposureColumnNumber] boolValue])
            [ema sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [ema sortUsingSelector:@selector(compare:)];
        
        if (includeMissing && hasANull)
            [ema addObject:[NSNull null]];
    }
    else if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:exposureColumnNumber] intValue] == 1)
    {
        for (int i = 0; i < exposureArray.count; i++)
        {
            if ([[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            if (![ema containsObject:[NSNumber numberWithDouble:[[exposureArray objectAtIndex:i] doubleValue]]])
                [ema addObject:[NSNumber numberWithDouble:[[exposureArray objectAtIndex:i] doubleValue]]];
        }
        
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:exposureColumnNumber] boolValue])
            [ema sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [ema sortUsingSelector:@selector(compare:)];
        
        if (includeMissing && hasANull)
            [ema addObject:[NSNull null]];
    }
    else
    {
        for (int i = 0; i < exposureArray.count; i++)
        {
            if ([[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            else if ([[exposureArray objectAtIndex:i] isEqualToString:@"(null)"])
            {
                hasANull = YES;
                continue;
            }
            
            if (![ema containsObject:[exposureArray objectAtIndex:i]])
                [ema addObject:[exposureArray objectAtIndex:i]];
        }
        
        if ([(NSNumber *)[dataSet.isYesNoWorking objectAtIndex:exposureColumnNumber] boolValue] ||[(NSNumber *)[dataSet.isTrueFalseWorking objectAtIndex:exposureColumnNumber] boolValue])
            [ema sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [ema sortUsingSelector:@selector(compare:)];
        
        if (includeMissing && hasANull)
            [ema addObject:[NSNull null]];
    }
    
    //Copy the temporary values arrays to the class property values arrays
    [self setOutcomeValues:[NSArray arrayWithArray:oma]];
    [self setExposureValues:[NSArray arrayWithArray:ema]];
    
    //Get the counts for each cell
    //Start with C-array of ints
    int counts[self.outcomeValues.count * self.exposureValues.count];
    for (int i = 0; i < self.outcomeValues.count * self.exposureValues.count; i++)
        counts[i] = 0;
    //Instantiate an index for counts
    int j = 0;
    //Loop over exposure and outcome values; loop over dataset and compare dataset values to possible values
    //Increment counts[j] when applicable
    for (int a = 0; a < self.exposureValues.count; a++)
    {
        //Get the working current value if not null
        NSString *exposureString = @"";
        if (![[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] &&
            [(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:exposureColumnNumber] intValue] < 2)
            exposureString = [[self.exposureValues objectAtIndex:a] stringValue];
        else if (![[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] && ![[self.exposureValues objectAtIndex:a] isEqualToString:@"(null)"])
            exposureString = [self.exposureValues objectAtIndex:a];
        
        for (int b = 0; b < self.outcomeValues.count; b++)
        {
            //Get the current outcome value if not null
            NSString *outcomeString = @"";
            if (![[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] &&
                [(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:outcomeColumnNumber] intValue] < 2)
                outcomeString = [[self.outcomeValues objectAtIndex:b] stringValue];
            else if (![[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] && ![[self.outcomeValues objectAtIndex:b] isEqualToString:@"(null)"])
                outcomeString = [self.outcomeValues objectAtIndex:b];
            
            for (int i = 0; i < outcomeArray.count; i++)
            {
                //If at least one of the dataset values is null
                if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[outcomeArray objectAtIndex:i] isEqualToString:@"(null)"] ||
                    [[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[exposureArray objectAtIndex:i] isEqualToString:@"(null)"])
                {
                    if (!includeMissing)
                        continue;
                    
                    //If outcome and exposure are null
                    if (([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[outcomeArray objectAtIndex:i] isEqualToString:@"(null)"]) &&
                        ([[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[exposureArray objectAtIndex:i] isEqualToString:@"(null)"]))
                    {
                        if (([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] || ([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSString class]] && [[self.outcomeValues objectAtIndex:b] isEqualToString:@"(null)"])) &&
                            ([[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] || ([[self.exposureValues objectAtIndex:a] isKindOfClass:[NSString class]] && [[self.exposureValues objectAtIndex:a] isEqualToString:@"(null)"])))
                            counts[j]++;
                    }
                    //If only outcome is null
                    else if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[outcomeArray objectAtIndex:i] isEqualToString:@"(null)"])
                    {
                        if (([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] || ([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSString class]] && [[self.outcomeValues objectAtIndex:b] isEqualToString:@"(null)"])) &&
                            [[exposureArray objectAtIndex:i] isEqualToString:exposureString])
                            counts[j]++;
                    }
                    //If only exposure is null
                    else
                    {
                        if (([[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] || ([[self.exposureValues objectAtIndex:a] isKindOfClass:[NSString class]] && [[self.exposureValues objectAtIndex:a] isEqualToString:@"(null)"])) &&
                            [[outcomeArray objectAtIndex:i] isEqualToString:outcomeString])
                            counts[j]++;
                    }
                    continue;
                }
                
                //If neither dataset value is null
                if ([[outcomeArray objectAtIndex:i] isEqualToString:outcomeString] &&
                    [[exposureArray objectAtIndex:i] isEqualToString:exposureString])
                    counts[j]++;
            }
            j++;
        }
    }
    
    //Copy the temporary array of counts to the class property
    NSMutableArray *tempCountsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.outcomeValues.count * self.exposureValues.count; i++)
        [tempCountsArray addObject:[NSNumber numberWithInt:counts[i]]];
    [self setCellCounts:[NSArray arrayWithArray:tempCountsArray]];
    
    return self;
}

- (id)initWithSQLiteData:(SQLiteData *)dataSet AndWhereClause:(NSString *)whereClause AndOutcomeVariable:(NSString *)outcomeVariable AndExposureVariable:(NSString *)exposureVariable AndIncludeMissing:(BOOL)includeMissing ForTablesView:(UIView *)tablesView
{
    self = [super init];
    
    [self setOutcomeVariable:outcomeVariable];
    [self setExposureVariable:exposureVariable];
    
    //Make arrays to hold the row values for the variables
    NSMutableArray *outcomeArray = [[NSMutableArray alloc] init];
    NSMutableArray *exposureArray = [[NSMutableArray alloc] init];
    
    //Get the path to the sqlite database
    NSString *databasePath = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingString:@"EpiInfo.db"]];
    
    //If the database exists, query the WORKING_DATASET
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        //Convert the databasePath to a char array
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        
        //Open the database
        if (sqlite3_open(dbpath, &analysisDB) == SQLITE_OK)
        {
            //Build the SELECT statement
            NSString *queryStmt = [[[[@"SELECT " stringByAppendingString:outcomeVariable] stringByAppendingString:@", "] stringByAppendingString:exposureVariable] stringByAppendingString:@" FROM WORKING_DATASET"];
            if (whereClause)
                queryStmt = [queryStmt stringByAppendingString:[NSString stringWithFormat:@" %@", whereClause]];
            //Convert the SELECT statement to a char array
           const char *query_stmt = [queryStmt UTF8String];
            //Execute the SELECT statement
            if (sqlite3_prepare_v2(analysisDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                //While the statement returns rows, read the column queried and put the values in the outcomeArray and exposureArray
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    if (!sqlite3_column_text(statement, 0))
                    {
                        [outcomeArray addObject:[NSNull null]];
                    }
                    else
                    {
                        NSString *rslt0 = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                        NSString *rslt = [NSString stringWithUTF8String:[rslt0 cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                        [outcomeArray addObject:rslt];
                    }
                    if (!sqlite3_column_text(statement, 1))
                    {
                        [exposureArray addObject:[NSNull null]];
                    }
                    else
                    {
                        NSString *rslt0 = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                        NSString *rslt = [NSString stringWithUTF8String:[rslt0 cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                        [exposureArray addObject:rslt];
                    }
                }
            }
            sqlite3_finalize(statement);
        }
        //Close the sqlite database
        sqlite3_close(analysisDB);
    }
    
    BOOL outcomeismapped = NO;
    BOOL exposureismapped = NO;
    if (tablesView)
    {
        if ([tablesView isKindOfClass:[TablesView class]])
        {
            if ([(TablesView *)tablesView outcomeValueMapper])
            {
                VariableValueMapper *outcomeValueMapper = [(TablesView *)tablesView outcomeValueMapper];
                if ([[[outcomeValueMapper onesUITV] indexPathsForSelectedRows] count] > 0 &&
                    [[[outcomeValueMapper zerosUITV] indexPathsForSelectedRows] count] > 0)
                {
                    outcomeismapped = YES;
                    NSArray *onesNSIPs = [[outcomeValueMapper onesUITV] indexPathsForSelectedRows];
                    NSArray *zerosNSIPs = [[outcomeValueMapper zerosUITV] indexPathsForSelectedRows];
                    NSMutableArray *oneStrings = [[NSMutableArray alloc] init];
                    NSMutableArray *zeroStrings = [[NSMutableArray alloc] init];
                    for (NSIndexPath *nsip in onesNSIPs)
                    {
                        NSString *nss;
                        NSObject *nso = [[outcomeValueMapper onesNSMA] objectAtIndex:nsip.row];
                        if ([nso isKindOfClass:[NSString class]])
                            nss = (NSString *)nso;
                        else if ([nso isKindOfClass:[NSNumber class]])
                            nss = [NSString stringWithFormat:@"%@", (NSNumber *)nso];
                        else if ([nso isKindOfClass:[NSNull class]])
                            nss = @"(null)";
                        if ([nss isEqualToString:@"<null>"])
                            nss = @"(null)";
                        if (![oneStrings containsObject:nss])
                            [oneStrings addObject:nss];
                    }
                    for (NSIndexPath *nsip in zerosNSIPs)
                    {
                        NSString *nss;
                        NSObject *nso = [[outcomeValueMapper zerosNSMA] objectAtIndex:nsip.row];
                        if ([nso isKindOfClass:[NSString class]])
                            nss = (NSString *)nso;
                        else if ([nso isKindOfClass:[NSNumber class]])
                            nss = [NSString stringWithFormat:@"%@", (NSNumber *)nso];
                        else if ([nso isKindOfClass:[NSNull class]])
                            nss = @"(null)";
                        if ([nss isEqualToString:@"<null>"])
                            nss = @"(null)";
                        if (![zeroStrings containsObject:nss])
                            [zeroStrings addObject:nss];
                    }
                    for (int oaindex = 0; oaindex < [outcomeArray count]; oaindex++)
                    {
                        if ([oneStrings containsObject:[outcomeArray objectAtIndex:oaindex]])
                            [outcomeArray setObject:@"1" atIndexedSubscript:oaindex];
                        else if ([zeroStrings containsObject:[outcomeArray objectAtIndex:oaindex]])
                            [outcomeArray setObject:@"0" atIndexedSubscript:oaindex];
                        else if ([[outcomeArray objectAtIndex:oaindex] isKindOfClass:[NSNull class]] && [oneStrings containsObject:@"(null)"])
                            [outcomeArray setObject:@"1" atIndexedSubscript:oaindex];
                        else if ([[outcomeArray objectAtIndex:oaindex] isKindOfClass:[NSNull class]] && [zeroStrings containsObject:@"(null)"])
                            [outcomeArray setObject:@"0" atIndexedSubscript:oaindex];
                        else
                            [outcomeArray setObject:@"(null)" atIndexedSubscript:oaindex];
                    }
                }
            }
            if ([(TablesView *)tablesView exposureValueMapper])
            {
                VariableValueMapper *exposureValueMapper = [(TablesView *)tablesView exposureValueMapper];
                if ([[[exposureValueMapper onesUITV] indexPathsForSelectedRows] count] > 0 &&
                    [[[exposureValueMapper zerosUITV] indexPathsForSelectedRows] count] > 0)
                {
                    exposureismapped = YES;
                    NSArray *onesNSIPs = [[exposureValueMapper onesUITV] indexPathsForSelectedRows];
                    NSArray *zerosNSIPs = [[exposureValueMapper zerosUITV] indexPathsForSelectedRows];
                    NSMutableArray *oneStrings = [[NSMutableArray alloc] init];
                    NSMutableArray *zeroStrings = [[NSMutableArray alloc] init];
                    for (NSIndexPath *nsip in onesNSIPs)
                    {
                        NSString *nss;
                        NSObject *nso = [[exposureValueMapper onesNSMA] objectAtIndex:nsip.row];
                        if ([nso isKindOfClass:[NSString class]])
                            nss = (NSString *)nso;
                        else if ([nso isKindOfClass:[NSNumber class]])
                            nss = [NSString stringWithFormat:@"%@", (NSNumber *)nso];
                        else if ([nso isKindOfClass:[NSNull class]])
                            nss = @"(null)";
                        if ([nss isEqualToString:@"<null>"])
                            nss = @"(null)";
                        if (![oneStrings containsObject:nss])
                            [oneStrings addObject:nss];
                    }
                    for (NSIndexPath *nsip in zerosNSIPs)
                    {
                        NSString *nss;
                        NSObject *nso = [[exposureValueMapper zerosNSMA] objectAtIndex:nsip.row];
                        if ([nso isKindOfClass:[NSString class]])
                            nss = (NSString *)nso;
                        else if ([nso isKindOfClass:[NSNumber class]])
                            nss = [NSString stringWithFormat:@"%@", (NSNumber *)nso];
                        else if ([nso isKindOfClass:[NSNull class]])
                            nss = @"(null)";
                        if ([nss isEqualToString:@"<null>"])
                            nss = @"(null)";
                        if (![zeroStrings containsObject:nss])
                            [zeroStrings addObject:nss];
                    }
                    for (int eaindex = 0; eaindex < [exposureArray count]; eaindex++)
                    {
                        if ([oneStrings containsObject:[exposureArray objectAtIndex:eaindex]])
                            [exposureArray setObject:@"1" atIndexedSubscript:eaindex];
                        else if ([zeroStrings containsObject:[exposureArray objectAtIndex:eaindex]])
                            [exposureArray setObject:@"0" atIndexedSubscript:eaindex];
                        else if ([[exposureArray objectAtIndex:eaindex] isKindOfClass:[NSNull class]] && [oneStrings containsObject:@"(null)"])
                            [exposureArray setObject:@"1" atIndexedSubscript:eaindex];
                        else if ([[exposureArray objectAtIndex:eaindex] isKindOfClass:[NSNull class]] && [zeroStrings containsObject:@"(null)"])
                            [exposureArray setObject:@"0" atIndexedSubscript:eaindex];
                        else
                            [exposureArray setObject:@"(null)" atIndexedSubscript:eaindex];
                    }
                }
            }
        }
    }
    
    //Get and sort all values of outcome variable
    //Temporary array for storing values
    NSMutableArray *oma = [[NSMutableArray alloc] init];
    //Boolean for whether outcome variable has any null values
    BOOL hasANull = NO;
    //The outcome variable's column number in the array of column names
    int outcomeColumnNumber = (int)[dataSet.columnNamesWorking indexOfObject:self.outcomeVariable];
    //Integer case first
    if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:outcomeColumnNumber] intValue] == 0)
    {
        //Loop through all data rows
        for (int i = 0; i < outcomeArray.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![oma containsObject:[NSNumber numberWithInt:[[outcomeArray objectAtIndex:i] intValue]]])
                [oma addObject:[NSNumber numberWithInt:[[outcomeArray objectAtIndex:i] intValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:outcomeColumnNumber] boolValue] || outcomeismapped)
            [oma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [oma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [oma addObject:[NSNull null]];
    }
    //Float case
    else if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:outcomeColumnNumber] intValue] == 1)
    {
        //Loop through all data rows
        for (int i = 0; i < outcomeArray.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![oma containsObject:[NSNumber numberWithDouble:[[outcomeArray objectAtIndex:i] doubleValue]]])
                [oma addObject:[NSNumber numberWithDouble:[[outcomeArray objectAtIndex:i] doubleValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:outcomeColumnNumber] boolValue])
            [oma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [oma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [oma addObject:[NSNull null]];
    }
    //String case
    else
    {
        //Loop through all data rows
        for (int i = 0; i < outcomeArray.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            if ([[outcomeArray objectAtIndex:i] isEqualToString:@"(null)"])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![oma containsObject:[outcomeArray objectAtIndex:i]])
                [oma addObject:[outcomeArray objectAtIndex:i]];
        }
        
        //Sort the temporary array
        //If it is Yes/No, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isYesNoWorking objectAtIndex:outcomeColumnNumber] boolValue] || [(NSNumber *)[dataSet.isTrueFalseWorking objectAtIndex:outcomeColumnNumber] boolValue])
            [oma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [oma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [oma addObject:[NSNull null]];
    }
    
    //Do the same thing for the exposure variable
    NSMutableArray *ema = [[NSMutableArray alloc] init];
    hasANull = NO;
    int exposureColumnNumber = (int)[dataSet.columnNamesWorking indexOfObject:self.exposureVariable];
    if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:exposureColumnNumber] intValue] == 0)
    {
        for (int i = 0; i < exposureArray.count; i++)
        {
            if ([[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            if (![ema containsObject:[NSNumber numberWithInt:[[exposureArray objectAtIndex:i] intValue]]])
                [ema addObject:[NSNumber numberWithInt:[[exposureArray objectAtIndex:i] intValue]]];
        }
        
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:exposureColumnNumber] boolValue] || exposureismapped)
            [ema sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [ema sortUsingSelector:@selector(compare:)];
        
        if (includeMissing && hasANull)
            [ema addObject:[NSNull null]];
    }
    else if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:exposureColumnNumber] intValue] == 1)
    {
        for (int i = 0; i < exposureArray.count; i++)
        {
            if ([[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            if (![ema containsObject:[NSNumber numberWithDouble:[[exposureArray objectAtIndex:i] doubleValue]]])
                [ema addObject:[NSNumber numberWithDouble:[[exposureArray objectAtIndex:i] doubleValue]]];
        }
        
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:exposureColumnNumber] boolValue])
            [ema sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [ema sortUsingSelector:@selector(compare:)];
        
        if (includeMissing && hasANull)
            [ema addObject:[NSNull null]];
    }
    else
    {
        for (int i = 0; i < exposureArray.count; i++)
        {
            if ([[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            else if ([[exposureArray objectAtIndex:i] isEqualToString:@"(null)"])
            {
                hasANull = YES;
                continue;
            }
            
            if (![ema containsObject:[exposureArray objectAtIndex:i]])
                [ema addObject:[exposureArray objectAtIndex:i]];
        }
        
        if ([(NSNumber *)[dataSet.isYesNoWorking objectAtIndex:exposureColumnNumber] boolValue] ||[(NSNumber *)[dataSet.isTrueFalseWorking objectAtIndex:exposureColumnNumber] boolValue])
            [ema sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [ema sortUsingSelector:@selector(compare:)];
        
        if (includeMissing && hasANull)
            [ema addObject:[NSNull null]];
    }
    
    //Copy the temporary values arrays to the class property values arrays
    [self setOutcomeValues:[NSArray arrayWithArray:oma]];
    [self setExposureValues:[NSArray arrayWithArray:ema]];
    
    //Get the counts for each cell
    //Start with C-array of ints
    int counts[self.outcomeValues.count * self.exposureValues.count];
    for (int i = 0; i < self.outcomeValues.count * self.exposureValues.count; i++)
        counts[i] = 0;
    //Instantiate an index for counts
    int j = 0;
    //Loop over exposure and outcome values; loop over dataset and compare dataset values to possible values
    //Increment counts[j] when applicable
    for (int a = 0; a < self.exposureValues.count; a++)
    {
        //Get the working current value if not null
        NSString *exposureString = @"";
        if (![[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] &&
            [(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:exposureColumnNumber] intValue] < 2)
            exposureString = [[self.exposureValues objectAtIndex:a] stringValue];
        else if (![[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] && ![[self.exposureValues objectAtIndex:a] isEqualToString:@"(null)"])
            exposureString = [self.exposureValues objectAtIndex:a];
        
        for (int b = 0; b < self.outcomeValues.count; b++)
        {
            //Get the current outcome value if not null
            NSString *outcomeString = @"";
            if (![[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] &&
                [(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:outcomeColumnNumber] intValue] < 2)
                outcomeString = [[self.outcomeValues objectAtIndex:b] stringValue];
            else if (![[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] && ![[self.outcomeValues objectAtIndex:b] isEqualToString:@"(null)"])
                outcomeString = [self.outcomeValues objectAtIndex:b];
            
            for (int i = 0; i < outcomeArray.count; i++)
            {
                //If at least one of the dataset values is null
                if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[outcomeArray objectAtIndex:i] isEqualToString:@"(null)"] ||
                    [[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[exposureArray objectAtIndex:i] isEqualToString:@"(null)"])
                {
                    if (!includeMissing)
                        continue;
                    
                    //If outcome and exposure are null
                    if (([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[outcomeArray objectAtIndex:i] isEqualToString:@"(null)"]) &&
                        ([[exposureArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[exposureArray objectAtIndex:i] isEqualToString:@"(null)"]))
                    {
                        if (([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] || ([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSString class]] && [[self.outcomeValues objectAtIndex:b] isEqualToString:@"(null)"])) &&
                            ([[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] || ([[self.exposureValues objectAtIndex:a] isKindOfClass:[NSString class]] && [[self.exposureValues objectAtIndex:a] isEqualToString:@"(null)"])))
                            counts[j]++;
                    }
                    //If only outcome is null
                    else if ([[outcomeArray objectAtIndex:i] isKindOfClass:[NSNull class]] || [[outcomeArray objectAtIndex:i] isEqualToString:@"(null)"])
                    {
                        if (([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSNull class]] || ([[self.outcomeValues objectAtIndex:b] isKindOfClass:[NSString class]] && [[self.outcomeValues objectAtIndex:b] isEqualToString:@"(null)"])) &&
                            [[exposureArray objectAtIndex:i] isEqualToString:exposureString])
                            counts[j]++;
                    }
                    //If only exposure is null
                    else
                    {
                        if (([[self.exposureValues objectAtIndex:a] isKindOfClass:[NSNull class]] || ([[self.exposureValues objectAtIndex:a] isKindOfClass:[NSString class]] && [[self.exposureValues objectAtIndex:a] isEqualToString:@"(null)"])) &&
                            [[outcomeArray objectAtIndex:i] isEqualToString:outcomeString])
                            counts[j]++;
                    }
                    continue;
                }
                
                //If neither dataset value is null
                if ([[outcomeArray objectAtIndex:i] isEqualToString:outcomeString] &&
                    [[exposureArray objectAtIndex:i] isEqualToString:exposureString])
                    counts[j]++;
            }
            j++;
        }
    }
    
    //Copy the temporary array of counts to the class property
    NSMutableArray *tempCountsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.outcomeValues.count * self.exposureValues.count; i++)
        [tempCountsArray addObject:[NSNumber numberWithInt:counts[i]]];
    [self setCellCounts:[NSArray arrayWithArray:tempCountsArray]];
    
    return self;
}@end
