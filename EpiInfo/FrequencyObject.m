//
//  FrequencyObject.m
//  EpiInfo
//
//  Created by John Copeland on 6/27/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "FrequencyObject.h"

@implementation FrequencyObject
@synthesize variableName = _variableName;
@synthesize variableValues = _variableValues;
@synthesize cellCounts = _cellCounts;

- (id)initWithAnalysisDataObject:(AnalysisDataObject *)dataSet AndVariable:(NSString *)variableName AndIncludeMissing:(BOOL)includeMissing
{
    self = [super init];
    
    [self setVariableName:variableName];
    
    //Get and sort all values of variable
    //Temporary array for storing values
    NSMutableArray *vma = [[NSMutableArray alloc] init];
    //Boolean for whether variable has any null values
    BOOL hasANull = NO;
    //The variable's column number in the AnalysisDataObject
    int variableColumnNumber = [(NSNumber *)[dataSet.columnNames objectForKey:self.variableName] intValue];
    //Integer case first
    if ([(NSNumber *)[dataSet.dataTypes objectForKey:[NSString stringWithFormat:@"%d", variableColumnNumber]] intValue] == 0)
    {
        //Loop through all data rows
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![vma containsObject:[NSNumber numberWithInt:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber] intValue]]])
                [vma addObject:[NSNumber numberWithInt:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber] intValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZero objectForKey:[NSString stringWithFormat:@"%d", variableColumnNumber]] boolValue])
            [vma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [vma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [vma addObject:[NSNull null]];
    }
    //Float case
    else if ([(NSNumber *)[dataSet.dataTypes objectForKey:[NSString stringWithFormat:@"%d", variableColumnNumber]] intValue] == 1)
    {
        //Loop through all data rows
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![vma containsObject:[NSNumber numberWithDouble:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber] doubleValue]]])
                [vma addObject:[NSNumber numberWithDouble:[[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber] doubleValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZero objectForKey:[NSString stringWithFormat:@"%d", variableColumnNumber]] boolValue])
            [vma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [vma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [vma addObject:[NSNull null]];
    }
    //String case
    else
    {
        //Loop through all data rows
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![vma containsObject:[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber]])
                [vma addObject:[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber]];
        }
        
        //Sort the temporary array
        //If it is Yes/No, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isYesNo objectForKey:[NSString stringWithFormat:@"%d", variableColumnNumber]] boolValue])
            [vma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [vma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [vma addObject:[NSNull null]];
    }
    
    //Copy the temporary values array to the class property values array
    [self setVariableValues:[NSArray arrayWithArray:vma]];
    
    //Get the counts for each cell
    //Start with C-array of ints
    int counts[self.variableValues.count];
    for (int i = 0; i < self.variableValues.count; i++)
        counts[i] = 0;
    //Instantiate an index for counts
    int j = 0;
    //Loop over variable values; loop over dataset and compare dataset values to possible values
    //Increment counts[j] when applicable
    for (int a = 0; a < self.variableValues.count; a++)
    {
        //Get the working current value if not null
        NSString *variableString = @"";
        if (![[self.variableValues objectAtIndex:a] isKindOfClass:[NSNull class]] &&
            [(NSNumber *)[dataSet.dataTypes objectForKey:[NSString stringWithFormat:@"%d", variableColumnNumber]] intValue] < 2)
            variableString = [[self.variableValues objectAtIndex:a] stringValue];
        else if (![[self.variableValues objectAtIndex:a] isKindOfClass:[NSNull class]])
            variableString = [self.variableValues objectAtIndex:a];
        
        for (int i = 0; i < dataSet.dataSet.count; i++)
        {
            //If dataset value is null
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber] isKindOfClass:[NSNull class]])
            {
                if (!includeMissing)
                    continue;
                    if ([[self.variableValues objectAtIndex:a] isKindOfClass:[NSNull class]])
                        counts[j]++;
                continue;
            }
            
            //If dataset value is not null
            if ([[[dataSet.dataSet objectAtIndex:i] objectAtIndex:variableColumnNumber] isEqualToString:variableString])
                counts[j]++;
        }
        j++;
    }
    
    //Copy the temporary array of counts to the class property
    NSMutableArray *tempCountsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.variableValues.count; i++)
        [tempCountsArray addObject:[NSNumber numberWithInt:counts[i]]];
    [self setCellCounts:[NSArray arrayWithArray:tempCountsArray]];
    
    return self;
}

- (id)initWithSQLiteData:(SQLiteData *)dataSet AndWhereClause:(NSString *)whereClause AndVariable:(NSString *)variableName AndIncludeMissing:(BOOL)includeMissing
{
    self = [super init];
    
    [self setVariableName:variableName];
    
    //Make array to hold the row values for the variable
    NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:[dataSet workingTableSize]];

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
            NSString *queryStmt = [[@"SELECT " stringByAppendingString:variableName] stringByAppendingString:@" FROM WORKING_DATASET"];
            if (whereClause)
                queryStmt = [queryStmt stringByAppendingString:[NSString stringWithFormat:@" %@", whereClause]];
            //Convert the SELECT statement to a char array
            const char *query_stmt = [queryStmt UTF8String];
            //Execute the SELECT statement
            if (sqlite3_prepare_v2(analysisDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                //While the statement returns rows, read the column queried and put the value in the dataArray
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    if (!sqlite3_column_text(statement, 0))
                    {
                        [dataArray addObject:[NSNull null]];
                        continue;
                    }
                    NSString *rslt = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)];
                    [dataArray addObject:rslt];
                }
            }
            sqlite3_finalize(statement);
        }
        //Close the sqlite database
        sqlite3_close(analysisDB);
    }

    //Get and sort all values of variable
    //Temporary array for storing values
    NSMutableArray *vma = [[NSMutableArray alloc] init];
    //Boolean for whether variable has any null values
    BOOL hasANull = NO;
    //The variable's column number in the array of columns
    int variableColumnNumber = (int)[dataSet.columnNamesWorking indexOfObject:self.variableName];
    //Integer case first
    if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:variableColumnNumber] intValue] == 0)
    {
        //Loop through all data rows
        for (int i = 0; i < dataArray.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[dataArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![vma containsObject:[NSNumber numberWithInt:[[dataArray objectAtIndex:i] intValue]]])
                [vma addObject:[NSNumber numberWithInt:[[dataArray objectAtIndex:i] intValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:variableColumnNumber] boolValue])
            [vma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [vma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [vma addObject:[NSNull null]];
    }
    //Float case
    else if ([(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:variableColumnNumber] intValue] == 1)
    {
        //Loop through all data rows
        for (int i = 0; i < dataArray.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[dataArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![vma containsObject:[NSNumber numberWithDouble:[[dataArray objectAtIndex:i] doubleValue]]])
                [vma addObject:[NSNumber numberWithDouble:[[dataArray objectAtIndex:i] doubleValue]]];
        }
        
        //Sort the temporary array
        //If it is one/zero, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isOneZeroWorking objectAtIndex:variableColumnNumber] boolValue])
            [vma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [vma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [vma addObject:[NSNull null]];
    }
    //String case
    else
    {
        //Loop through all data rows
        for (int i = 0; i < dataArray.count; i++)
        {
            //If a null value is found, flip the boolean if necessary and don't add the value until last
            if ([[dataArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                hasANull = YES;
                continue;
            }
            else if ([[dataArray objectAtIndex:i] isEqualToString:@"(null)"])
            {
                hasANull = YES;
                continue;
            }
            
            //If the value isn't already in the temporary array, add it
            if (![vma containsObject:[dataArray objectAtIndex:i]])
                [vma addObject:[dataArray objectAtIndex:i]];
        }
        
        //Sort the temporary array
        //If it is Yes/No, sort it descending; otherwise sort it ascending
        if ([(NSNumber *)[dataSet.isYesNoWorking objectAtIndex:variableColumnNumber] boolValue] || [(NSNumber *)[dataSet.isTrueFalseWorking objectAtIndex:variableColumnNumber] boolValue])
            [vma sortUsingDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:nil ascending:NO]]];
        else
            [vma sortUsingSelector:@selector(compare:)];
        
        //Add the null value to the end if necessary
        if (includeMissing && hasANull)
            [vma addObject:[NSNull null]];
    }
    
    //Copy the temporary values array to the class property values array
    [self setVariableValues:[NSArray arrayWithArray:vma]];
    
    //Get the counts for each cell
    //Start with C-array of ints
    int counts[self.variableValues.count];
    for (int i = 0; i < self.variableValues.count; i++)
        counts[i] = 0;
    //Instantiate an index for counts
    int j = 0;
    //Loop over variable values; loop over dataset and compare dataset values to possible values
    //Increment counts[j] when applicable
    for (int a = 0; a < self.variableValues.count; a++)
    {
        //Get the working current value if not null
        NSString *variableString = @"";
        if (![[self.variableValues objectAtIndex:a] isKindOfClass:[NSNull class]] &&
            [(NSNumber *)[dataSet.dataTypesWorking objectAtIndex:variableColumnNumber] intValue] < 2)
            variableString = [[self.variableValues objectAtIndex:a] stringValue];
        else if (![[self.variableValues objectAtIndex:a] isKindOfClass:[NSNull class]] && ![[self.variableValues objectAtIndex:a] isEqualToString:@"(null)"])
            variableString = [self.variableValues objectAtIndex:a];
        
        for (int i = 0; i < dataArray.count; i++)
        {
            //If dataset value is null
            if ([[dataArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            {
                if (!includeMissing)
                    continue;
                if ([[self.variableValues objectAtIndex:a] isKindOfClass:[NSNull class]])
                    counts[j]++;
                continue;
            }
            else if ([[dataArray objectAtIndex:i] isEqualToString:@"(null)"])
            {
                if (!includeMissing)
                    continue;
                if ([[self.variableValues objectAtIndex:a] isKindOfClass:[NSNull class]])
                    counts[j]++;
                else if ([[self.variableValues objectAtIndex:a] isEqualToString:@"(null)"])
                    counts[j]++;
                continue;
            }
            
            //If dataset value is not null
            if ([[dataArray objectAtIndex:i] isEqualToString:variableString])
                counts[j]++;
        }
        j++;
    }
    
    //Copy the temporary array of counts to the class property
    NSMutableArray *tempCountsArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.variableValues.count; i++)
        [tempCountsArray addObject:[NSNumber numberWithInt:counts[i]]];
    [self setCellCounts:[NSArray arrayWithArray:tempCountsArray]];
    
    return self;
}
@end
