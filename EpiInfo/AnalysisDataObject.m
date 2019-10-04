//
//  AnalysisDataObject.m
//  EpiInfo
//
//  Created by John Copeland on 6/24/13.
//

#import "AnalysisDataObject.h"

@implementation AnalysisDataObject
@synthesize columnNames = _columnNames;
@synthesize dataTypes = _dataTypes;
@synthesize dataDefinitions = _dataDefinitions;
@synthesize dataSet = _dataSet;
@synthesize isBinary = _isBinary;
@synthesize isOneZero = _isOneZero;
@synthesize isYesNo = _isYesNo;
@synthesize isTrueFalse = _isTrueFalse;
@synthesize listOfFilters = _listOfFilters;

- (NSMutableString *)whereClause
{
    if (whereClause)
        return whereClause;
    else
        return [NSMutableString stringWithString:@""];
}

- (NSDictionary *)dataDefinitions
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Integer", [NSString stringWithFormat:@"%d", 0],
            @"Decimal", [NSString stringWithFormat:@"%d", 1],
            @"String", [NSString stringWithFormat:@"%d", 2],
            nil];
}

- (id)initWithAnalysisDataObject:(AnalysisDataObject *)analysisDataObject
{
    self = [super init];
    
    [self setColumnNames:[NSDictionary dictionaryWithDictionary:analysisDataObject.columnNames]];
    [self setDataTypes:[NSDictionary dictionaryWithDictionary:analysisDataObject.dataTypes]];
    [self setIsBinary:[NSDictionary dictionaryWithDictionary:analysisDataObject.isBinary]];
    [self setIsOneZero:[NSDictionary dictionaryWithDictionary:analysisDataObject.isOneZero]];
    [self setIsYesNo:[NSDictionary dictionaryWithDictionary:analysisDataObject.isYesNo]];
    [self setDataSet:[NSArray arrayWithArray:analysisDataObject.dataSet]];
    
    return self;
}

- (id)initWithAnalysisDataObject:(AnalysisDataObject *)analysisDataObject AndTableName:(NSString *)tableName AndFilters:(NSMutableArray *)filters
{
    self = [self initWithAnalysisDataObject:analysisDataObject];
    
    if ([filters count] > 0)
    {
        NSLog(@"Add filtering here...");
        if ([tableName length] == 0)
            return self;
        if ([filters count] == 1 && [(NSString *)[filters objectAtIndex:0] length] == 0)
            return self;
        
        self = [self initWithStoredDataTable:tableName AndFilters:filters];
        [self setListOfFilters:filters];
    }
    
    return self;
}

- (id)initWithStoredDataTable:(NSString *)tableName
{
    self = [super init];
    
    NSMutableArray *mutableFullDataSet = [[NSMutableArray alloc] init];
    NSMutableArray *mutableColumns = [[NSMutableArray alloc] init];
    NSMutableArray *columnNumbers = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select * from %@", tableName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                BOOL firstRow = YES;
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    int i = 0;
                    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
                    while (sqlite3_column_name(statement, i))
                    {
                        if (firstRow)
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            [mutableColumns addObject:columnName];
                            [columnNumbers addObject:[NSString stringWithFormat:@"%d", i]];
                        }
                        [rowArray addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                        i++;
                    }
                    firstRow = NO;
                    [mutableFullDataSet addObject:[NSArray arrayWithArray:rowArray]];
                }
                [self setColumnNames:[NSMutableDictionary dictionaryWithObjects:columnNumbers forKeys:[NSArray arrayWithArray:mutableColumns]]];
                [self setDataSet:[NSArray arrayWithArray:mutableFullDataSet]];
                
                //Set up the column types
                [self determineCSVDataTypes];
            }
        }
        sqlite3_close(epiinfoDB);
    }
    
    return self;
}

- (id)initWithStoredDataTable:(NSString *)tableName AndFilters:(NSMutableArray *)filters
{
    NSDictionary *columnNames = [NSDictionary dictionaryWithDictionary:self.columnNames];
    NSDictionary *dataTypes = [NSDictionary dictionaryWithDictionary:self.dataTypes];
    self = [super init];
    
    NSMutableArray *mutableFullDataSet = [[NSMutableArray alloc] init];
    NSMutableArray *mutableColumns = [[NSMutableArray alloc] init];
    NSMutableArray *columnNumbers = [[NSMutableArray alloc] init];
    
    whereClause = [[NSMutableString alloc] init];
    [whereClause appendString:@"WHERE"];
    for (int i = 0; i < [filters count]; i++)
    {
        NSString *condition = [filters objectAtIndex:i];
        NSArray *conditionComponents = [condition componentsSeparatedByString:@" "];
        NSString *variable = [conditionComponents objectAtIndex:0];
        NSString *contraction = @"";
        int startIndex = 1;
        if ([variable isEqualToString:@"AND"] || [variable isEqualToString:@"OR"])
        {
            variable = [conditionComponents objectAtIndex:startIndex++];
            contraction = [conditionComponents objectAtIndex:0];
        }
        NSMutableString *operatorAndValue = [NSMutableString stringWithString:[conditionComponents objectAtIndex:startIndex++]];
        for (int j = startIndex; j < [conditionComponents count]; j++)
        {
            [operatorAndValue appendFormat:@" %@", [conditionComponents objectAtIndex:j]];
        }
        NSString *operator = @"";
        NSString *value = @"";
        if ([operatorAndValue isEqualToString:@"is missing"] || ([operatorAndValue length] > 10 && [[operatorAndValue substringToIndex:10] isEqualToString:@"is missing"]))
        {
            operator = @" is ";
            value = @"null";
        }
        else if ([operatorAndValue isEqualToString:@"is not missing"] || ([operatorAndValue length] > 14 && [[operatorAndValue substringToIndex:14] isEqualToString:@"is not missing"]))
        {
            operator = @" is not ";
            value = @"null";
        }
        else if ([operatorAndValue length] > 6 && [[operatorAndValue substringToIndex:6] isEqualToString:@"equals"])
        {
            operator = @" = ";
            value = [operatorAndValue substringFromIndex:7];
        }
        else if ([operatorAndValue length] > 15 && [[operatorAndValue substringToIndex:15] isEqualToString:@"is not equal to"])
        {
            operator = @" <> ";
            value = [operatorAndValue substringFromIndex:16];
        }
        else if ([operatorAndValue length] > 24 && [[operatorAndValue substringToIndex:24] isEqualToString:@"is less than or equal to"])
        {
            operator = @" <= ";
            value = [operatorAndValue substringFromIndex:25];
        }
        else if ([operatorAndValue length] > 12 && [[operatorAndValue substringToIndex:12] isEqualToString:@"is less than"])
        {
            operator = @" < ";
            value = [operatorAndValue substringFromIndex:13];
        }
        else if ([operatorAndValue length] > 27 && [[operatorAndValue substringToIndex:27] isEqualToString:@"is greater than or equal to"])
        {
            operator = @" >= ";
            value = [operatorAndValue substringFromIndex:27];
        }
        else if ([operatorAndValue length] > 15 && [[operatorAndValue substringToIndex:15] isEqualToString:@"is greater than"])
        {
            operator = @" > ";
            value = [operatorAndValue substringFromIndex:16];
        }
        int valueLength = (int)[value length];
        while ([value length] > 0 && [value characterAtIndex:valueLength - 1] == ' ')
        {
            value = [value substringToIndex:[value length] - 1];
            valueLength = (int)[value length];
        }
        NSNumber *variableIndex = (NSNumber *)[columnNames objectForKey:variable];
        NSNumber *variableType = (NSNumber *)[dataTypes objectForKey:variableIndex];
        int vt = [variableType intValue];
        if (vt == 2 && ![operator containsString:@"is"])
            value = [[@"'" stringByAppendingString:value] stringByAppendingString:@"'"];
        [whereClause appendFormat:@" %@ %@ %@ %@", contraction, variable, operator, value];
    }

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select * from %@ %@", tableName, whereClause];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                BOOL firstRow = YES;
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    int i = 0;
                    NSMutableArray *rowArray = [[NSMutableArray alloc] init];
                    while (sqlite3_column_name(statement, i))
                    {
                        if (firstRow)
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            [mutableColumns addObject:columnName];
                            [columnNumbers addObject:[NSString stringWithFormat:@"%d", i]];
                        }
                        [rowArray addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                        i++;
                    }
                    firstRow = NO;
                    [mutableFullDataSet addObject:[NSArray arrayWithArray:rowArray]];
                }
                [self setColumnNames:[NSMutableDictionary dictionaryWithObjects:columnNumbers forKeys:[NSArray arrayWithArray:mutableColumns]]];
                [self setDataSet:[NSArray arrayWithArray:mutableFullDataSet]];
                
                //Set up the column types
                [self determineCSVDataTypes];
            }
        }
        sqlite3_close(epiinfoDB);
    }
    
    return self;
}

- (id)initWithCSVFile:(NSString *)pathAndFileName
{
    self = [super init];

    NSString *fileText = @"";
    NSString *rowText = @"";
    unsigned numberOfLines, index, stringLength = (unsigned int)[fileText length];
    numberOfLines = 0;
    
    NSMutableArray *mutableFullDataSet = [[NSMutableArray alloc] init];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Check whether file actually exists at path
    if ([fileManager fileExistsAtPath:pathAndFileName])
    {
        //Read the filecontents into a string
        fileText = [NSString stringWithContentsOfFile:pathAndFileName encoding:NSStringEncodingConversionAllowLossy error:nil];
        stringLength = (unsigned int)[fileText length];
        
        //Separate the data file into individual lines
        for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++)
        {
            rowText = [fileText substringFromIndex:index];
            int oldIndex = index;
            index = (unsigned int)NSMaxRange([fileText lineRangeForRange:NSMakeRange(index, 0)]);
            rowText = [rowText substringToIndex:index - oldIndex];
            
            //If line-1, parse column names
            if (numberOfLines == 0)
            {
                //Ignore quotes and carriage returns
                NSArray *columns = [[[rowText stringByReplacingOccurrencesOfString:@"\"" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] componentsSeparatedByString:@","];
                NSMutableArray *columnNumbers = [[NSMutableArray alloc] init];
                for (int i = 0; i < [columns count]; i++)
                    [columnNumbers addObject:[NSString stringWithFormat:@"%d", i]];
                //Set the columnNames dictionary
                [self setColumnNames:[NSMutableDictionary dictionaryWithObjects:columnNumbers forKeys:columns]];
            }
            else
            {
                //If not row-1, create NSArray from row of text and add to full dataset array
                NSMutableArray *rowArray = [NSMutableArray arrayWithArray:[[[rowText stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%c", 0x0d] withString:@""] componentsSeparatedByString:@","]];
                for (int i = 0; i < rowArray.count; i++)
                {
                    if ([(NSString *)[rowArray objectAtIndex:i] isEqualToString:@"TRUE"])
                        [rowArray setObject:@"1" atIndexedSubscript:i];
                    if ([(NSString *)[rowArray objectAtIndex:i] isEqualToString:@"FALSE"])
                        [rowArray setObject:@"0" atIndexedSubscript:i];
                }
                [mutableFullDataSet addObject:rowArray];
            }
        }
        [self setDataSet:[NSArray arrayWithArray:mutableFullDataSet]];
        
        //Set up the column types
        [self determineCSVDataTypes];
    }

    return self;
}

- (id)initWithVariablesArray:(NSMutableArray *)variables AndDataArray:(NSMutableArray *)data
{
    self = [super init];
    
    NSArray *columns = [NSArray arrayWithArray:variables];
    NSMutableArray *columnNumbers = [[NSMutableArray alloc] init];
    for (int i = 0; i < columns.count; i++)
        [columnNumbers addObject:[NSString stringWithFormat:@"%d", i]];
    [self setColumnNames:[NSMutableDictionary dictionaryWithObjects:columnNumbers forKeys:columns]];
    [self setDataSet:[NSArray arrayWithArray:data]];
    
    [self determineCSVDataTypes];
    
    //Remove leading and trailing zeros from numbers
    for (id key in self.dataTypes)
    {
        if ([(NSNumber *)[self.dataTypes objectForKey:key] intValue] == 0)
        {
            for (int i = 0; i < self.dataSet.count; i++)
            {
                if ([[[self.dataSet objectAtIndex:i] objectAtIndex:[(NSNumber *)key intValue]] isKindOfClass:[NSNull class]])
                    continue;
                [(NSMutableArray *)[self.dataSet objectAtIndex:i] setObject:[[NSNumber numberWithInt:[[[self.dataSet objectAtIndex:i] objectAtIndex:[(NSNumber *)key intValue]] intValue]] stringValue] atIndexedSubscript:[(NSNumber *)key intValue]];
            }
        }
        else if ([(NSNumber *)[self.dataTypes objectForKey:key] intValue] == 1)
        {
            for (int i = 0; i < self.dataSet.count; i++)
            {
                if ([[[self.dataSet objectAtIndex:i] objectAtIndex:[(NSNumber *)key intValue]] isKindOfClass:[NSNull class]])
                    continue;
                [(NSMutableArray *)[self.dataSet objectAtIndex:i] setObject:[[NSNumber numberWithDouble:[[[self.dataSet objectAtIndex:i] objectAtIndex:[(NSNumber *)key intValue]] doubleValue]] stringValue] atIndexedSubscript:[(NSNumber *)key intValue]];
            }
        }
    }
    
    return self;
}

- (void)determineCSVDataTypes
{
    //Empty arrays for keys and values
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    //Add initial values (default data type is integer) to keys and values
    for (int i = 0; i < self.columnNames.count; i++)
    {
        [keys addObject:[NSString stringWithFormat:@"%d", i]];
        [values addObject:[NSNumber numberWithInt:0]];
    }
    
    //Create a tempory dictionary with the initial values and keys
    NSMutableDictionary *temporaryDictionary = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    
    //Change data types to decimals or strings when necessary
    for (int i = 0; i < self.columnNames.count; i++)
    {
        for (int j = 0; j < self.dataSet.count; j++)
        {
            //Allow dots and empty spaces to be integers or decimals
            if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isKindOfClass:[NSNull class]])
                continue;
            if ([[[[self.dataSet objectAtIndex:j] objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""])
                continue;
            if ([[[[self.dataSet objectAtIndex:j] objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"."])
                continue;
            if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:@"(null)"])
                continue;

            //Need two NSScanner objects: one to scan for non-numbers and another to scan for non-integers
            NSScanner *scanner0 = [NSScanner scannerWithString:[[self.dataSet objectAtIndex:j] objectAtIndex:i]];
            NSScanner *scanner1 = [NSScanner scannerWithString:[[self.dataSet objectAtIndex:j] objectAtIndex:i]];
            
            //Scan for non-numbers and set type to String if found
            if (!([scanner0 scanFloat:nil] && [scanner0 isAtEnd]))
            {
                [temporaryDictionary setValue:[NSNumber numberWithInt:2] forKey:[[NSNumber numberWithInt:i] stringValue]];
                //No need to continue this loop; it's already known to be String
                break;
            }
            
            //If type is already decimal, no need to check for decimal
            if ([(NSNumber *)[temporaryDictionary objectForKey:[NSString stringWithFormat:@"%d", i]] integerValue] > 0)
                continue;
            
            //Scan for non-integers
            if (!([scanner1 scanInt:nil] && [scanner1 isAtEnd]))
            {
                [temporaryDictionary setValue:[NSNumber numberWithInt:1] forKey:[[NSNumber numberWithInt:i] stringValue]];
            }
        }
    }
    
    [self setDataTypes:[NSDictionary dictionaryWithDictionary:temporaryDictionary]];
    
    //Next determine whether columns are binary
    temporaryDictionary = nil;
    keys = nil;
    values = nil;
    keys = [[NSMutableArray alloc] init];
    values = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.columnNames.count; i++)
    {
        [keys addObject:[NSString stringWithFormat:@"%d", i]];
        [values addObject:[NSNumber numberWithBool:YES]];
    }
    temporaryDictionary = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    for (int i = 0; i < self.columnNames.count; i++)
    {
        NSString *firstValue = nil;
        NSString *secondValue = nil;
        for (int j = 0; j < self.dataSet.count; j++)
        {
            if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isKindOfClass:[NSNull class]])
                continue;
            if ([(NSNumber *)[self.dataTypes objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] < 2 &&
                ([[[[self.dataSet objectAtIndex:j] objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[[[self.dataSet objectAtIndex:j] objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"."]))
                continue;
            if ([(NSNumber *)[self.dataTypes objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 2 &&
                [[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:@""])
                continue;
            
            if (firstValue == nil)
            {
                firstValue = (NSString *)[[self.dataSet objectAtIndex:j] objectAtIndex:i];
                continue;
            }
            if ([(NSString *)[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:firstValue])
            {
                continue;
            }
            if (secondValue == nil)
            {
                secondValue = (NSString *)[[self.dataSet objectAtIndex:j] objectAtIndex:i];
                continue;
            }
            if (!([(NSString *)[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:firstValue] || [(NSString *)[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:secondValue]))
            {
                [temporaryDictionary setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
                break;
            }
        }
    }
    [self setIsBinary:[NSDictionary dictionaryWithDictionary:temporaryDictionary]];
    
    //Next determine whether any binary columns are One-Zero or Yes-No
    temporaryDictionary = nil;
    temporaryDictionary = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    NSMutableDictionary *temporaryDictionary2 = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    NSMutableDictionary *temporaryDictionary3 = [NSMutableDictionary dictionaryWithObjects:values forKeys:keys];
    for (int i = 0; i < self.columnNames.count; i++)
    {
        if ([(NSNumber *)[self.isBinary objectForKey:[NSString stringWithFormat:@"%d", i]] boolValue])
        {
            if ([(NSNumber *)[self.dataTypes objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 0)
            {
                for (int j = 0; j < self.dataSet.count; j++)
                {
                    if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isKindOfClass:[NSNull class]])
                        continue;
                    if (([[[[self.dataSet objectAtIndex:j] objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[[[self.dataSet objectAtIndex:j] objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"."]))
                        continue;
                    if (!([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:@"1"] || [[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:@"0"]))
                    {
                        [temporaryDictionary setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
                        break;
                    }
                }
            }
            else
            {
                [temporaryDictionary setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
            }
            if ([(NSNumber *)[self.dataTypes objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 2)
            {
                for (int j = 0; j < self.dataSet.count; j++)
                {
                    if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isKindOfClass:[NSNull class]])
                        continue;
                    if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:@""])
                        continue;
                    if (!([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:@"Yes"] || [[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:@"No"]))
                    {
                        [temporaryDictionary2 setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
                        break;
                    }
                }
            }
            else
            {
                [temporaryDictionary2 setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
            }
            if ([(NSNumber *)[self.dataTypes objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 2)
            {
                for (int j = 0; j < self.dataSet.count; j++)
                {
                    if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isKindOfClass:[NSNull class]])
                        continue;
                    if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:@""])
                        continue;
                    if (!([[[[self.dataSet objectAtIndex:j] objectAtIndex:i] uppercaseString] isEqualToString:@"TRUE"] || [[[[self.dataSet objectAtIndex:j] objectAtIndex:i] uppercaseString] isEqualToString:@"FALSE"]))
                    {
                        [temporaryDictionary3 setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
                        break;
                    }
                }
            }
            else
            {
                [temporaryDictionary3 setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
            }
        }
        else
        {
            [temporaryDictionary setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
            [temporaryDictionary2 setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
            [temporaryDictionary3 setValue:[NSNumber numberWithBool:NO] forKey:[[NSNumber numberWithInt:i] stringValue]];
        }
    }
    [self setIsOneZero:[NSDictionary dictionaryWithDictionary:temporaryDictionary]];
    [self setIsYesNo:[NSDictionary dictionaryWithDictionary:temporaryDictionary2]];
    [self setIsTrueFalse:[NSDictionary dictionaryWithDictionary:temporaryDictionary3]];
    
    //Set missing values to null strings
    for (int i = 0; i < self.dataTypes.count; i++)
    {
        if ([(NSNumber *)[self.dataTypes objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] < 2)
        {
            for (int j = 0; j < self.dataSet.count; j++)
            {
                if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isKindOfClass:[NSNull class]])
                    continue;
                if ([[[[self.dataSet objectAtIndex:j] objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""] || [[[[self.dataSet objectAtIndex:j] objectAtIndex:i] stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@"."])
                {
                    [(NSMutableArray *)[self.dataSet objectAtIndex:j] replaceObjectAtIndex:i withObject:[NSNull null]];
                }
            }
            continue;
        }
        
        if ([(NSNumber *)[self.dataTypes objectForKey:[NSString stringWithFormat:@"%d", i]] intValue] == 2)
        {
            for (int j = 0; j < self.dataSet.count; j++)
            {
                if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isKindOfClass:[NSNull class]])
                    continue;
                if ([[[self.dataSet objectAtIndex:j] objectAtIndex:i] isEqualToString:@""])
                {
                    [(NSMutableArray *)[self.dataSet objectAtIndex:j] replaceObjectAtIndex:i withObject:[NSNull null]];
                }
            }
            continue;
        }
    }
}
@end
