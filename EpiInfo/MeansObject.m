//
//  MeansObject.m
//  EpiInfo
//
//  Created by John Copeland on 8/21/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import "MeansObject.h"

@implementation MeansObject
@synthesize meansVariable = _meansVariable;
@synthesize meansVariableValues = _meansVariableValues;
@synthesize meansVariableFloatValues = _meansVariableFloatValues;

- (id)initWithAnalysisDataObject:(AnalysisDataObject *)dataSet AndMeansVariable:(NSString *)meansVariable AndIncludeMissing:(BOOL)includeMissing
{
    self = [super init];
    return self;
}

- (id)initWithSQLiteData:(SQLiteData *)dataSet AndWhereClause:(NSString *)whereClause AndMeansVariable:(NSString *)meansVariable AndIncludeMissing:(BOOL)includeMissing
{
    self = [super init];
    
    [self setMeansVariable:meansVariable];
    
    //Make arrays to hold the row values for the variables
    NSMutableArray *meansArray = [[NSMutableArray alloc] init];
    
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
            NSString *queryStmt = [[@"SELECT " stringByAppendingString:meansVariable] stringByAppendingString:@" FROM WORKING_DATASET"];
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
                    if (!sqlite3_column_text(statement, 0) || [[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)] isEqualToString:@"(null)"])
                    {
                    }
                    else
                    {
                        NSNumber *rslt = [NSNumber numberWithDouble:sqlite3_column_double(statement, 0)];
                        [meansArray addObject:rslt];
                    }
                }
            }
            sqlite3_finalize(statement);
        }
        //Close the sqlite database
        sqlite3_close(analysisDB);
    }
    
    float n = 0.0;
    float sum = 0.0;
    float min = 0.0;
    float max = 0.0;
    BOOL minMaxSet = NO;
    
    if ([meansArray count] == 0)
    {
        [self setMeansVariableValues:@[@"0",
                                       @"0",
                                       @"0",
                                       @"0",
                                       @"0",
                                       @"0",
                                       @"0",
                                       @"0",
                                       @"0",
                                       @"0"
                                       ]];

        [self setMeansVariableFloatValues:@[[NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.0],
                                            [NSNumber numberWithFloat:0.0]
                                            ]];
        
        return self;
    }
    
    for (int i = 0; i < meansArray.count; i++)
    {
        if ([[meansArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            continue;
        float currentValue = [(NSNumber *)[meansArray objectAtIndex:i] floatValue];
        if (!minMaxSet)
        {
            min = currentValue;
            max = currentValue;
            minMaxSet = YES;
        }
        n += 1.0;
        sum += currentValue;
        if (currentValue > max)
            max = currentValue;
        if (currentValue < min)
            min = currentValue;
    }
    float mean = sum / n;
    
    int medianI0 = (int)roundf((float)meansArray.count / 2.0);
    int medianI1 = medianI0;
    if (roundf((float)meansArray.count / 2.0) == floorf((float)meansArray.count / 2.0))
        medianI1 += 1.0;
    
    NSArray *sortedMeansArray = [meansArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber *)obj1 compare:(NSNumber *)obj2];
    }];

    float median = [(NSNumber *)[sortedMeansArray objectAtIndex:0] floatValue];
    if ([sortedMeansArray count] > 1)
        median = ([(NSNumber *)[sortedMeansArray objectAtIndex:medianI0] floatValue] + [(NSNumber *)[sortedMeansArray objectAtIndex:medianI1] floatValue]) / 2.0;
    
    float ss = 0.0;
    for (int i = 0; i < meansArray.count; i++)
    {
        if ([[meansArray objectAtIndex:i] isKindOfClass:[NSNull class]])
            continue;
        float currentValue = [(NSNumber *)[meansArray objectAtIndex:i] floatValue];
        ss += (mean - currentValue) * (mean - currentValue);
    }
    float variance = ss / (n - 1.0);
    float sdev = sqrtf(variance);
    
    float quartileResult = (float)sortedMeansArray.count / 4.0;
    float q25 = 0.0;
    float q75 = 0.0;
    if ((float)(int)quartileResult == quartileResult)
    {
        int lowerPosition = (int)quartileResult - 1;
        int upperPosition = (int)quartileResult;
        q25 = ([(NSNumber *)[sortedMeansArray objectAtIndex:lowerPosition] floatValue] + [(NSNumber *)[sortedMeansArray objectAtIndex:upperPosition] floatValue]) / 2.0;
        q75 = ([(NSNumber *)[sortedMeansArray objectAtIndex:sortedMeansArray.count - 1 - lowerPosition] floatValue] + [(NSNumber *)[sortedMeansArray objectAtIndex:sortedMeansArray.count - 1 - upperPosition] floatValue]) / 2.0;
    }
    else
    {
        q25 = [(NSNumber *)[sortedMeansArray objectAtIndex:(int)quartileResult] floatValue];
        q75 = [(NSNumber *)[sortedMeansArray objectAtIndex:sortedMeansArray.count - 1 - (int)quartileResult] floatValue];
    }
    
    NSNumberFormatter *nsnfN = [[NSNumberFormatter alloc] init];
    [nsnfN setExponentSymbol:@"e"];
    [nsnfN setPositiveFormat:@"###,###.##"];
    [nsnfN setNegativeFormat:@"-###,###.##"];
    if ((n > 0.0 && n < 0.1) || (n < 0.0 && n > -0.1))
    {
        [nsnfN setPositiveFormat:@"0.####"];
        [nsnfN setNegativeFormat:@"-0.####"];
    }
    if ((n > 0.0 && n < 0.001) || (n < 0.0 && n > -0.001) || n >= 1000000 | n <= -1000000)
    {
        [nsnfN setPositiveFormat:@"0.####E+0"];
        [nsnfN setNegativeFormat:@"-0.####E+0"];
    }
    
    NSNumberFormatter *nsnfSum = [[NSNumberFormatter alloc] init];
    [nsnfSum setExponentSymbol:@"e"];
    [nsnfSum setPositiveFormat:@"###,###.##"];
    [nsnfSum setNegativeFormat:@"-###,###.##"];
    if ((sum > 0.0 && sum < 0.1) || (sum < 0.0 && sum > -0.1))
    {
        [nsnfSum setPositiveFormat:@"0.####"];
        [nsnfSum setNegativeFormat:@"-0.####"];
    }
    if ((sum > 0.0 && n < 0.001) || (sum < 0.0 && sum > -0.001) || sum >= 1000000 | sum <= -1000000)
    {
        [nsnfSum setPositiveFormat:@"0.####E+0"];
        [nsnfSum setNegativeFormat:@"-0.####E+0"];
    }
    
    NSNumberFormatter *nsnfMean = [[NSNumberFormatter alloc] init];
    [nsnfMean setExponentSymbol:@"e"];
    [nsnfMean setPositiveFormat:@"###,###.##"];
    [nsnfMean setNegativeFormat:@"-###,###.##"];
    if ((mean > 0.0 && mean < 0.1) || (mean < 0.0 && mean > -0.1))
    {
        [nsnfMean setPositiveFormat:@"0.####"];
        [nsnfMean setNegativeFormat:@"-0.####"];
    }
    if ((mean > 0.0 && mean < 0.001) || (mean < 0.0 && mean > -0.001) || mean >= 1000000 | mean <= -1000000)
    {
        [nsnfMean setPositiveFormat:@"0.####E+0"];
        [nsnfMean setNegativeFormat:@"-0.####E+0"];
    }
    
    NSNumberFormatter *nsnfVariance = [[NSNumberFormatter alloc] init];
    [nsnfVariance setExponentSymbol:@"e"];
    [nsnfVariance setPositiveFormat:@"###,###.##"];
    [nsnfVariance setNegativeFormat:@"-###,###.##"];
    if ((variance > 0.0 && variance < 0.1) || (variance < 0.0 && variance > -0.1))
    {
        [nsnfVariance setPositiveFormat:@"0.####"];
        [nsnfVariance setNegativeFormat:@"-0.####"];
    }
    if ((variance > 0.0 && variance < 0.001) || (variance < 0.0 && variance > -0.001) || variance >= 1000000 | variance <= -1000000)
    {
        [nsnfVariance setPositiveFormat:@"0.####E+0"];
        [nsnfVariance setNegativeFormat:@"-0.####E+0"];
    }
    
    NSNumberFormatter *nsnfSdev = [[NSNumberFormatter alloc] init];
    [nsnfSdev setExponentSymbol:@"e"];
    [nsnfSdev setPositiveFormat:@"###,###.##"];
    [nsnfSdev setNegativeFormat:@"-###,###.##"];
    if ((sdev > 0.0 && sdev < 0.1) || (sdev < 0.0 && sdev > -0.1))
    {
        [nsnfSdev setPositiveFormat:@"0.####"];
        [nsnfSdev setNegativeFormat:@"-0.####"];
    }
    if ((sdev > 0.0 && sdev < 0.001) || (sdev < 0.0 && sdev > -0.001) || sdev >= 1000000 | sdev <= -1000000)
    {
        [nsnfSdev setPositiveFormat:@"0.####E+0"];
        [nsnfSdev setNegativeFormat:@"-0.####E+0"];
    }
    
    NSNumberFormatter *nsnfMin = [[NSNumberFormatter alloc] init];
    [nsnfMin setExponentSymbol:@"e"];
    [nsnfMin setPositiveFormat:@"###,###.##"];
    [nsnfMin setNegativeFormat:@"-###,###.##"];
    if ((min > 0.0 && min < 0.1) || (min < 0.0 && min > -0.1))
    {
        [nsnfMin setPositiveFormat:@"0.####"];
        [nsnfMin setNegativeFormat:@"-0.####"];
    }
    if ((min > 0.0 && min < 0.001) || (min < 0.0 && min > -0.001) || min >= 1000000 | min <= -1000000)
    {
        [nsnfMin setPositiveFormat:@"0.####E+0"];
        [nsnfMin setNegativeFormat:@"-0.####E+0"];
    }
    
    NSNumberFormatter *nsnfQ25 = [[NSNumberFormatter alloc] init];
    [nsnfQ25 setExponentSymbol:@"e"];
    [nsnfQ25 setPositiveFormat:@"###,###.##"];
    [nsnfQ25 setNegativeFormat:@"-###,###.##"];
    if ((q25 > 0.0 && q25 < 0.1) || (q25 < 0.0 && q25 > -0.1))
    {
        [nsnfQ25 setPositiveFormat:@"0.####"];
        [nsnfQ25 setNegativeFormat:@"-0.####"];
    }
    if ((q25 > 0.0 && q25 < 0.001) || (q25 < 0.0 && q25 > -0.001) || q25 >= 1000000 | q25 <= -1000000)
    {
        [nsnfQ25 setPositiveFormat:@"0.####E+0"];
        [nsnfQ25 setNegativeFormat:@"-0.####E+0"];
    }
    
    NSNumberFormatter *nsnfMedian = [[NSNumberFormatter alloc] init];
    [nsnfMedian setExponentSymbol:@"e"];
    [nsnfMedian setPositiveFormat:@"###,###.##"];
    [nsnfMedian setNegativeFormat:@"-###,###.##"];
    if ((median > 0.0 && median < 0.1) || (median < 0.0 && median > -0.1))
    {
        [nsnfMedian setPositiveFormat:@"0.####"];
        [nsnfMedian setNegativeFormat:@"-0.####"];
    }
    if ((median > 0.0 && median < 0.001) || (median < 0.0 && median > -0.001) || median >= 1000000 | median <= -1000000)
    {
        [nsnfMedian setPositiveFormat:@"0.####E+0"];
        [nsnfMedian setNegativeFormat:@"-0.####E+0"];
    }
    
    NSNumberFormatter *nsnfQ75 = [[NSNumberFormatter alloc] init];
    [nsnfQ75 setExponentSymbol:@"e"];
    [nsnfQ75 setPositiveFormat:@"###,###.##"];
    [nsnfQ75 setNegativeFormat:@"-###,###.##"];
    if ((q75 > 0.0 && q75 < 0.1) || (q75 < 0.0 && q75 > -0.1))
    {
        [nsnfQ75 setPositiveFormat:@"0.####"];
        [nsnfQ75 setNegativeFormat:@"-0.####"];
    }
    if ((q75 > 0.0 && q75 < 0.001) || (q75 < 0.0 && q75 > -0.001) || q75 >= 1000000 | q75 <= -1000000)
    {
        [nsnfQ75 setPositiveFormat:@"0.####E+0"];
        [nsnfQ75 setNegativeFormat:@"-0.####E+0"];
    }
    
    NSNumberFormatter *nsnfMax = [[NSNumberFormatter alloc] init];
    [nsnfMax setExponentSymbol:@"e"];
    [nsnfMax setPositiveFormat:@"###,###.##"];
    [nsnfMax setNegativeFormat:@"-###,###.##"];
    if ((max > 0.0 && max < 0.1) || (max < 0.0 && max > -0.1))
    {
        [nsnfMax setPositiveFormat:@"0.####"];
        [nsnfMax setNegativeFormat:@"-0.####"];
    }
    if ((max > 0.0 && max < 0.001) || (max < 0.0 && max > -0.001) || max >= 1000000 | max <= -1000000)
    {
        [nsnfMax setPositiveFormat:@"0.####E+0"];
        [nsnfMax setNegativeFormat:@"-0.####E+0"];
    }
    
    [self setMeansVariableValues:@[[nsnfN stringFromNumber:[NSNumber numberWithFloat:n]],
                                   [nsnfSum stringFromNumber:[NSNumber numberWithFloat:sum]],
                                   [nsnfMean stringFromNumber:[NSNumber numberWithFloat:mean]],
                                   [nsnfVariance stringFromNumber:[NSNumber numberWithFloat:variance]],
                                   [nsnfSdev stringFromNumber:[NSNumber numberWithFloat:sdev]],
                                   [nsnfMin stringFromNumber:[NSNumber numberWithFloat:min]],
                                   [nsnfQ25 stringFromNumber:[NSNumber numberWithFloat:q25]],
                                   [nsnfMedian stringFromNumber:[NSNumber numberWithFloat:median]],
                                   [nsnfQ75 stringFromNumber:[NSNumber numberWithFloat:q75]],
                                   [nsnfMax stringFromNumber:[NSNumber numberWithFloat:max]]
                                   ]];

    [self setMeansVariableFloatValues:@[[NSNumber numberWithFloat:n],
                                        [NSNumber numberWithFloat:sum],
                                        [NSNumber numberWithFloat:mean],
                                        [NSNumber numberWithFloat:variance],
                                        [NSNumber numberWithFloat:sdev],
                                        [NSNumber numberWithFloat:min],
                                        [NSNumber numberWithFloat:q25],
                                        [NSNumber numberWithFloat:median],
                                        [NSNumber numberWithFloat:q75],
                                        [NSNumber numberWithFloat:max]
                                        ]];
    
    return self;
}
@end
