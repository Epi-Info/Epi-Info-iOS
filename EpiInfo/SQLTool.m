//
//  SQLTool.m
//  EpiInfo
//
//  Created by John Copeland on 4/4/16.
//

#import "SQLTool.h"
#include <stdlib.h>

@implementation SQLTool
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        initialHeight = frame.size.height;
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIButton *resignButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [resignButton addTarget:self action:@selector(sqlStatementFieldResign:) forControlEvents:UIControlEventTouchUpInside];
        downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe:)];
        [downRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
        [downRecognizer setNumberOfTouchesRequired:1];
        [resignButton addGestureRecognizer:downRecognizer];
        [resignButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:resignButton];
        
        sqlStatementFieldBackground = [[UIView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4.0, 128)];
        [sqlStatementFieldBackground setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        sqlStatementField = [[UITextView alloc] initWithFrame:CGRectMake(2, 2, sqlStatementFieldBackground.frame.size.width - 4.0, sqlStatementFieldBackground.frame.size.height - 4.0)];
        [sqlStatementField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [sqlStatementField setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [sqlStatementField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [sqlStatementField setKeyboardType:UIKeyboardTypeDefault];
        [sqlStatementField setDelegate:self];
        [sqlStatementFieldBackground addSubview:sqlStatementField];
        [self addSubview:sqlStatementFieldBackground];
        
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 2, 90, 30)];
        [clearButton setImage:[UIImage imageNamed:@"ClearButtonBlue.png"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clearButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton setAccessibilityLabel:@"Clear without submitting."];
        [self addSubview:clearButton];
        
        UIButton *questionMarkButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 - clearButton.frame.size.height / 2.0, clearButton.frame.origin.y, clearButton.frame.size.height, clearButton.frame.size.height)];
        [questionMarkButton setImage:[UIImage imageNamed:@"QuestionMarkButton.png"] forState:UIControlStateNormal];
        [questionMarkButton addTarget:self action:@selector(questionMarkPressed:) forControlEvents:UIControlEventTouchUpInside];
        [questionMarkButton setAccessibilityLabel:@"SQL tool help."];
        [self addSubview:questionMarkButton];
        
        UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(sqlStatementFieldBackground.frame.origin.x + sqlStatementFieldBackground.frame.size.width - 90, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 2, 90, 30)];
        [submitButton setImage:[UIImage imageNamed:@"SubmitButtonBlue.png"] forState:UIControlStateNormal];
        [submitButton addTarget:self action:@selector(submitButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [submitButton setAccessibilityLabel:@"Submit sequel statement"];
        [self addSubview:submitButton];
    }
    
    return self;
}

- (void)submitButtonPressed:(UIButton *)sender
{
    [results removeFromSuperview];
    results = nil;
    [self setContentSize:CGSizeMake(0, 0)];
    
    if ([[sqlStatementField text] length] < 1)
        return;
    
    NSMutableString *sqlStatement = [NSMutableString stringWithString:[sqlStatementField text]];
    while ([sqlStatement characterAtIndex:0] == ' ')
        [sqlStatement deleteCharactersInRange:NSMakeRange(0, 1)];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        return;
    }
    
    // Get data tables from SQLite database
    NSMutableArray *arrayOfDatasets = [[NSMutableArray alloc] init];
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
        {
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
            
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = [NSString stringWithFormat:@"select name from sqlite_master order by name"];
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        [arrayOfDatasets addObject:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 0)] lowercaseString]];
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
        }
    }
    
    if ([sqlStatement length] > 5 && [[[sqlStatement substringWithRange:NSMakeRange(0, 6)] lowercaseString] isEqualToString:@"tables"])
    {
        [self sqlStatementFieldResign:sender];
        
        float resultsHeight = (float)[arrayOfDatasets count] * 40.0 + 40.0;
        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width - 4, resultsHeight)];
        [self addSubview:results];
//        [self sendSubviewToBack:results];
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, results.frame.size.width, 40)];
        [header setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [header setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [header setTextAlignment:NSTextAlignmentCenter];
        [header setTextColor:[UIColor whiteColor]];
        [header setText:@"Epi Info Tables on this Device"];
        [header setUserInteractionEnabled:YES];
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
        [headerTap setNumberOfTapsRequired:1];
        [header addGestureRecognizer:headerTap];
        [results addSubview:header];
        
        float yValue = 0.0;
        for (id table in arrayOfDatasets)
        {
            yValue += 40.0;
            UILabel *rowLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, yValue, results.frame.size.width - 4, 40)];
            [rowLabel setBackgroundColor:[UIColor clearColor]];
            [rowLabel setTextColor:[UIColor blackColor]];
            [rowLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [rowLabel setTextAlignment:NSTextAlignmentLeft];
            [rowLabel setText:(NSString *)table];
            [rowLabel setUserInteractionEnabled:YES];
            UITapGestureRecognizer *rowLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
            [rowLabelTap setNumberOfTapsRequired:1];
            UILongPressGestureRecognizer *rowLabelLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [rowLabelLongPress setMinimumPressDuration:1.0];
            [rowLabel addGestureRecognizer:rowLabelTap];
            [rowLabel addGestureRecognizer:rowLabelLongPress];
            [results addSubview:rowLabel];
        }
        [self setContentSize:CGSizeMake(self.frame.size.width, results.frame.origin.y + results.frame.size.height + 80)];
    }
    
    else if (([sqlStatement length] > 4 && [[[sqlStatement substringWithRange:NSMakeRange(0, 5)] lowercaseString] isEqualToString:@"meta "]) || ([sqlStatement length] > 8 && [[[sqlStatement substringWithRange:NSMakeRange(0, 9)] lowercaseString] isEqualToString:@"metadata "]))
    {
        int tablePosition = 9;
        if ([[[sqlStatement substringWithRange:NSMakeRange(0, 5)] lowercaseString] isEqualToString:@"meta "])
        {
            tablePosition = 5;
        }
        
        NSMutableString *tableToMeta = [NSMutableString stringWithString:[sqlStatement substringFromIndex:tablePosition]];
        while ([tableToMeta characterAtIndex:0] == ' ')
            [tableToMeta deleteCharactersInRange:NSMakeRange(0, 1)];
        while ([tableToMeta characterAtIndex:[tableToMeta length] - 1] == ' ')
            [tableToMeta deleteCharactersInRange:NSMakeRange([tableToMeta length] - 1, 1)];
        
        if ([tableToMeta containsString:@" "])
        {
            float resultsHeight = 40.0;
            results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width - 4, resultsHeight)];
            [self addSubview:results];
//            [self sendSubviewToBack:results];
            
            UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, results.frame.size.width, 40)];
            [header setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [header setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [header setTextAlignment:NSTextAlignmentCenter];
            [header setTextColor:[UIColor whiteColor]];
            [header setText:[NSString stringWithFormat:@"Too many arguments: %@", tableToMeta]];
            [header setUserInteractionEnabled:YES];
            UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
            [headerTap setNumberOfTapsRequired:1];
            [header addGestureRecognizer:headerTap];
            [results addSubview:header];
            return;
        }
        if (![arrayOfDatasets containsObject:[tableToMeta lowercaseString]])
        {
            float resultsHeight = 40.0;
            results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width - 4, resultsHeight)];
            [self addSubview:results];
//            [self sendSubviewToBack:results];
            
            UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, results.frame.size.width, 40)];
            [header setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [header setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [header setTextAlignment:NSTextAlignmentCenter];
            [header setTextColor:[UIColor whiteColor]];
            [header setText:[NSString stringWithFormat:@"Table %@ not found.", tableToMeta]];
            [header setUserInteractionEnabled:YES];
            UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
            [headerTap setNumberOfTapsRequired:1];
            [header addGestureRecognizer:headerTap];
            [results addSubview:header];
            return;
        }
        
        [self sqlStatementFieldResign:sender];
        
        NSMutableArray *arrayOfColumns = [[NSMutableArray alloc] init];
        
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
            {
                NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
                
                if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                {
                    NSString *selStmt = [NSString stringWithFormat:@"select * from %@", tableToMeta];
                    const char *query_stmt = [selStmt UTF8String];
                    sqlite3_stmt *statement;
                    if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        while (sqlite3_step(statement) == SQLITE_ROW)
                        {
                            int i = 0;
                            while (sqlite3_column_name(statement, i))
                            {
                                [arrayOfColumns addObject:[[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)]];
                                i++;
                            }
                            break;
                        }
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(epiinfoDB);
            }
        }
        
        AnalysisDataObject *ado = [[AnalysisDataObject alloc] initWithStoredDataTable:tableToMeta];
        
        float resultsHeight = (float)[arrayOfColumns count] * 40.0 + 40.0;
        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width - 4, resultsHeight)];
        [self addSubview:results];
//        [self sendSubviewToBack:results];
        
        UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, results.frame.size.width, 40)];
        [header setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [header setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [header setTextAlignment:NSTextAlignmentCenter];
        [header setTextColor:[UIColor whiteColor]];
        [header setText:[NSString stringWithFormat:@"%@ Metadata", tableToMeta]];
        [header setUserInteractionEnabled:YES];
        UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
        [headerTap setNumberOfTapsRequired:1];
        [header addGestureRecognizer:headerTap];
        [results addSubview:header];
        
        float yValue = 0.0;
        {
            yValue += 40.0;
            UILabel *rowLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, yValue, (results.frame.size.width - 4) * 0.667, 40)];
            [rowLabel setBackgroundColor:[UIColor clearColor]];
            [rowLabel setTextColor:[UIColor blackColor]];
            [rowLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [rowLabel setTextAlignment:NSTextAlignmentLeft];
            [rowLabel setText:@"Number of Rows"];
            [rowLabel setNumberOfLines:0];
            [rowLabel setLineBreakMode:NSLineBreakByCharWrapping];
            [rowLabel setUserInteractionEnabled:YES];
            UITapGestureRecognizer *rowLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
            [rowLabelTap setNumberOfTapsRequired:1];
            UILongPressGestureRecognizer *rowLabelLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [rowLabelLongPress setMinimumPressDuration:1.0];
            [rowLabel addGestureRecognizer:rowLabelTap];
            [rowLabel addGestureRecognizer:rowLabelLongPress];
            [results addSubview:rowLabel];
            
            UILabel *rowLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(rowLabel.frame.origin.x + rowLabel.frame.size.width, yValue, (results.frame.size.width - 4) * .333, 40)];
            [rowLabel2 setBackgroundColor:[UIColor clearColor]];
            [rowLabel2 setTextColor:[UIColor blackColor]];
            [rowLabel2 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [rowLabel2 setTextAlignment:NSTextAlignmentLeft];
            [rowLabel2 setText:[NSString stringWithFormat:@"%lu", (unsigned long)[[ado dataSet] count]]];
            [rowLabel2 setUserInteractionEnabled:YES];
            UITapGestureRecognizer *rowLabelTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
            [rowLabelTap2 setNumberOfTapsRequired:1];
            UILongPressGestureRecognizer *rowLabelLongPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [rowLabelLongPress2 setMinimumPressDuration:1.0];
            [rowLabel2 addGestureRecognizer:rowLabelTap2];
            [rowLabel2 addGestureRecognizer:rowLabelLongPress2];
            [results addSubview:rowLabel2];
        }
        for (id key in arrayOfColumns)
        {
            yValue += 40.0;
            UILabel *rowLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, yValue, (results.frame.size.width - 4) * 0.667, 40)];
            [rowLabel setBackgroundColor:[UIColor clearColor]];
            [rowLabel setTextColor:[UIColor blackColor]];
            [rowLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [rowLabel setTextAlignment:NSTextAlignmentLeft];
            [rowLabel setText:(NSString *)key];
            [rowLabel setNumberOfLines:0];
            [rowLabel setLineBreakMode:NSLineBreakByCharWrapping];
            [rowLabel setUserInteractionEnabled:YES];
            UITapGestureRecognizer *rowLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
            [rowLabelTap setNumberOfTapsRequired:1];
            UILongPressGestureRecognizer *rowLabelLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [rowLabelLongPress setMinimumPressDuration:1.0];
            [rowLabel addGestureRecognizer:rowLabelTap];
            [rowLabel addGestureRecognizer:rowLabelLongPress];
            [results addSubview:rowLabel];
            
            UILabel *rowLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(rowLabel.frame.origin.x + rowLabel.frame.size.width, yValue, (results.frame.size.width - 4) * .333, 40)];
            [rowLabel2 setBackgroundColor:[UIColor clearColor]];
            [rowLabel2 setTextColor:[UIColor blackColor]];
            [rowLabel2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [rowLabel2 setTextAlignment:NSTextAlignmentLeft];
            [rowLabel2 setText:@"Int"];
            if ([(NSNumber *)[[ado dataTypes] objectForKey:[[ado columnNames] objectForKey:key]] intValue] == 1)
                [rowLabel2 setText:@"Float"];
            else if ([(NSNumber *)[[ado dataTypes] objectForKey:[[ado columnNames] objectForKey:key]] intValue] > 1)
                [rowLabel2 setText:@"Char"];
            if ([(NSNumber *)[[ado isOneZero] objectForKey:[[ado columnNames] objectForKey:key]] intValue] == 1)
                [rowLabel2 setText:@"1/0"];
            else if ([(NSNumber *)[[ado isYesNo] objectForKey:[[ado columnNames] objectForKey:key]] intValue] == 1)
                [rowLabel2 setText:@"Yes/No"];
            else if ([(NSNumber *)[[ado isTrueFalse] objectForKey:[[ado columnNames] objectForKey:key]] intValue] == 1)
                [rowLabel2 setText:@"True/False"];
            else if ([(NSNumber *)[[ado isBinary] objectForKey:[[ado columnNames] objectForKey:key]] intValue] == 1)
                [rowLabel2 setText:[[rowLabel2 text] stringByAppendingString:@" (Binary)"]];
            [rowLabel2 setUserInteractionEnabled:YES];
            UITapGestureRecognizer *rowLabelTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
            [rowLabelTap2 setNumberOfTapsRequired:1];
            UILongPressGestureRecognizer *rowLabelLongPress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [rowLabelLongPress2 setMinimumPressDuration:1.0];
            [rowLabel2 addGestureRecognizer:rowLabelTap2];
            [rowLabel2 addGestureRecognizer:rowLabelLongPress2];
            [results addSubview:rowLabel2];
        }
        [self setContentSize:CGSizeMake(self.frame.size.width, results.frame.origin.y + results.frame.size.height + 80)];
    }
    
    else if ([sqlStatement length] > 6 && [[[sqlStatement substringWithRange:NSMakeRange(0, 7)] lowercaseString] isEqualToString:@"select "])
    {
        NSMutableArray *arrayOfColumns = [[NSMutableArray alloc] init];
        NSMutableArray *arrayOfWidths = [[NSMutableArray alloc] init];
        NSMutableArray *arrayOfRows = [[NSMutableArray alloc] init];
        BOOL querySucceeded = YES;
        float totalWidthOfResults = 0.0;
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
            {
                NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
                
                if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                {
                    NSString *selStmt = sqlStatement;
                    const char *query_stmt = [selStmt UTF8String];
                    sqlite3_stmt *statement;
                    if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                    {
                        [self sqlStatementFieldResign:sender];
                        
                        BOOL firstRow = YES;
                        while (sqlite3_step(statement) == SQLITE_ROW)
                        {
                            NSMutableArray *rowArray = [[NSMutableArray alloc] init];
                            int i = 0;
                            while (sqlite3_column_name(statement, i))
                            {
                                if (firstRow)
                                {
                                    [arrayOfColumns addObject:[[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)]];
                                    float cellWidth = [(NSString *)[arrayOfColumns lastObject] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]}].width + 16.0;
                                    if (cellWidth < 80.0)
                                        cellWidth = 80.0;
                                    [arrayOfWidths addObject:[NSNumber numberWithFloat:cellWidth]];
                                    totalWidthOfResults += [(NSNumber *)[arrayOfWidths lastObject] intValue];
                                }
                                [rowArray addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                                i++;
                            }
                            firstRow = NO;
                            [arrayOfRows addObject:rowArray];
                        }
                    }
                    else
                    {
                        querySucceeded = NO;
                        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width, 60)];
                        [self addSubview:results];
                        UITextView *sqlMessage = [[UITextView alloc] initWithFrame:CGRectMake(2, 0, results.frame.size.width - 4.0, 60)];
                        [sqlMessage setEditable:NO];
                        [sqlMessage setText:[NSString stringWithFormat:@"SQL Error: %s", sqlite3_errmsg(epiinfoDB)]];
                        [sqlMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                        [results addSubview:sqlMessage];
                    }
                    sqlite3_finalize(statement);
                }
                sqlite3_close(epiinfoDB);
            }
        }
        
        if (!querySucceeded)
            return;
        
        float resultsHeight = (float)[arrayOfRows count] * 40.0 + 40.0;
        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, totalWidthOfResults, resultsHeight)];
        [self addSubview:results];
//        [self sendSubviewToBack:results];
        
        int cells = 0;
        float xPos = 0.0;
        int index = 0;
        for (id key in arrayOfColumns)
        {
            UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(xPos, 0, [(NSNumber *)[arrayOfWidths objectAtIndex:index] floatValue], 40)];
            [header setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
            [header setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [header setTextAlignment:NSTextAlignmentCenter];
            [header setTextColor:[UIColor whiteColor]];
            [header setText:[NSString stringWithFormat:@"%@", (NSString *)key]];
            [header setUserInteractionEnabled:YES];
            UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
            [headerTap setNumberOfTapsRequired:1];
            UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            [headerLongPress setMinimumPressDuration:1.0];
            [header addGestureRecognizer:headerTap];
            [header addGestureRecognizer:headerLongPress];
            [results addSubview:header];
            xPos += [(NSNumber *)[arrayOfWidths objectAtIndex:index] floatValue];
            index++;
            cells ++;
        }
        
        float yValue = 0.0;
        for (id key in arrayOfRows)
        {
            yValue += 40.0;
            float xPosition = 0.0;
            int i = 0;
            for (id cell in (NSArray *)key)
            {
                UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(xPosition, yValue, [(NSNumber *)[arrayOfWidths objectAtIndex:i] floatValue], 40)];
                [header setBackgroundColor:[UIColor clearColor]];
                [header setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [header setTextAlignment:NSTextAlignmentCenter];
                [header setTextColor:[UIColor blackColor]];
                [header setText:[NSString stringWithFormat:@"%@", (NSString *)cell]];
                [header setNumberOfLines:0];
                [header setLineBreakMode:NSLineBreakByCharWrapping];
                [header setUserInteractionEnabled:YES];
                UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
                [headerTap setNumberOfTapsRequired:1];
                UILongPressGestureRecognizer *headerLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
                [headerLongPress setMinimumPressDuration:1.0];
                [header addGestureRecognizer:headerTap];
                [header addGestureRecognizer:headerLongPress];
                [results addSubview:header];
                xPosition += [(NSNumber *)[arrayOfWidths objectAtIndex:i] floatValue];
                i++;
                cells ++;
            }
            if (cells > 2000)
            {
                [results setFrame:CGRectMake(results.frame.origin.x, results.frame.origin.y, results.frame.size.width, yValue + 40.0 + 60.0)];
                UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, yValue + 40.0, self.frame.size.width - 4.0, 60.0)];
                [footer setBackgroundColor:[UIColor clearColor]];
                [footer setFont:[UIFont fontWithName:@"HelveticaHeue" size:16.0]];
                [footer setTextColor:[UIColor blackColor]];
                [footer setText:[NSString stringWithFormat:@"Data display limit reached after %d rows.", (int)(yValue / 40.0)]];
                [footer setNumberOfLines:0];
                [footer setLineBreakMode:NSLineBreakByWordWrapping];
                [footer setUserInteractionEnabled:YES];
                UITapGestureRecognizer *footerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
                [footerTap setNumberOfTapsRequired:1];
                [footer addGestureRecognizer:footerTap];
                [results addSubview:footer];
                break;
            }
        }
        [self setContentSize:CGSizeMake(results.frame.origin.x + results.frame.size.width + 32.0, results.frame.origin.y + results.frame.size.height + 80)];
    }
    
    else if ([sqlStatement length] > 6 && [[[sqlStatement substringWithRange:NSMakeRange(0, 7)] lowercaseString] isEqualToString:@"update "])
    {
        if ([[sqlStatement lowercaseString] containsString:@"guid()"])
            sqlStatement = [NSMutableString stringWithString:[[sqlStatement lowercaseString] stringByReplacingOccurrencesOfString:@"guid()" withString:[NSString stringWithFormat:@"'%@'", CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)))]]];
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
            {
                NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
                
                if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                {
                    char *errMsg;
                    NSString *sqlStmt = sqlStatement;
                    const char *sql_stmt = [sqlStmt UTF8String];
                    if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) == SQLITE_OK)
                    {
                        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width, 60)];
                        [self addSubview:results];
                        UILabel *sqlMessage = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, results.frame.size.width - 4.0, 60)];
                        [sqlMessage setText:[NSString stringWithFormat:@"%d row(s) updated.", sqlite3_changes(epiinfoDB)]];
                        [sqlMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                        [results addSubview:sqlMessage];
                    }
                    else
                    {
                        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width, 60)];
                        [self addSubview:results];
                        UITextView *sqlMessage = [[UITextView alloc] initWithFrame:CGRectMake(2, 0, results.frame.size.width - 4.0, 60)];
                        [sqlMessage setEditable:NO];
                        [sqlMessage setText:[NSString stringWithFormat:@"SQL Error: %s", sqlite3_errmsg(epiinfoDB)]];
                        [sqlMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                        [results addSubview:sqlMessage];
                    }
                }
                sqlite3_close(epiinfoDB);
            }
        }
    }
    
    else if ([sqlStatement length] > 6 && [[[sqlStatement substringWithRange:NSMakeRange(0, 7)] lowercaseString] isEqualToString:@"insert "])
    {
        if ([[sqlStatement lowercaseString] containsString:@"guid()"])
            sqlStatement = [NSMutableString stringWithString:[[sqlStatement lowercaseString] stringByReplacingOccurrencesOfString:@"guid()" withString:[NSString stringWithFormat:@"'%@'", CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)))]]];
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
            {
                NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
                
                if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                {
                    char *errMsg;
                    NSString *sqlStmt = sqlStatement;
                    const char *sql_stmt = [sqlStmt UTF8String];
                    if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) == SQLITE_OK)
                    {
                        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width, 60)];
                        [self addSubview:results];
                        UILabel *sqlMessage = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, results.frame.size.width - 4.0, 60)];
                        [sqlMessage setText:[NSString stringWithFormat:@"%d row(s) inserted.", sqlite3_changes(epiinfoDB)]];
                        [sqlMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                        [results addSubview:sqlMessage];
                    }
                    else
                    {
                        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width, 60)];
                        [self addSubview:results];
                        UITextView *sqlMessage = [[UITextView alloc] initWithFrame:CGRectMake(2, 0, results.frame.size.width - 4.0, 60)];
                        [sqlMessage setEditable:NO];
                        [sqlMessage setText:[NSString stringWithFormat:@"SQL Error: %s", sqlite3_errmsg(epiinfoDB)]];
                        [sqlMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                        [results addSubview:sqlMessage];
                    }
               }
                sqlite3_close(epiinfoDB);
            }
        }
    }
    
    else if ([sqlStatement length] > 6 && [[[sqlStatement substringWithRange:NSMakeRange(0, 7)] lowercaseString] isEqualToString:@"delete "])
    {
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
            {
                NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
                
                if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                {
                    char *errMsg;
                    NSString *sqlStmt = sqlStatement;
                    const char *sql_stmt = [sqlStmt UTF8String];
                    if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) == SQLITE_OK)
                    {
                        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width, 60)];
                        [self addSubview:results];
                        UILabel *sqlMessage = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, results.frame.size.width - 4.0, 60)];
                        [sqlMessage setText:[NSString stringWithFormat:@"%d row(s) deleted.", sqlite3_changes(epiinfoDB)]];
                        [sqlMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                        [results addSubview:sqlMessage];
                    }
                    else
                    {
                        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width, 60)];
                        [self addSubview:results];
                        UITextView *sqlMessage = [[UITextView alloc] initWithFrame:CGRectMake(2, 0, results.frame.size.width - 4.0, 60)];
                        [sqlMessage setEditable:NO];
                        [sqlMessage setText:[NSString stringWithFormat:@"SQL Error: %s", sqlite3_errmsg(epiinfoDB)]];
                        [sqlMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                        [results addSubview:sqlMessage];
                    }
                }
                sqlite3_close(epiinfoDB);
            }
        }
    }
    
    else if ([sqlStatement length] > 4 && [[[sqlStatement substringWithRange:NSMakeRange(0, 5)] lowercaseString] isEqualToString:@"drop "])
    {
        results = [[UIView alloc] initWithFrame:CGRectMake(2, sqlStatementFieldBackground.frame.origin.y + sqlStatementFieldBackground.frame.size.height + 34, self.frame.size.width, 60)];
        [self addSubview:results];
        UILabel *sqlMessage = [[UILabel alloc] initWithFrame:CGRectMake(2, 0, results.frame.size.width - 4.0, 60)];
        [sqlMessage setText:[NSString stringWithFormat:@"DROP not supported. Use \"Table from Device\" to delete tables."]];
        [sqlMessage setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        UITapGestureRecognizer *sqlMessageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sqlStatementFieldResign:)];
        [sqlMessageTap setNumberOfTapsRequired:1];
        [sqlMessage addGestureRecognizer:sqlMessageTap];
        [results addSubview:sqlMessage];
    }
}

- (void)questionMarkPressed:(UIButton *)sender
{
    instructionsView = [[UIView alloc] initWithFrame:CGRectMake(0, initialHeight - 54, self.frame.size.width, initialHeight - 54)];
    [instructionsView setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
    [self addSubview:instructionsView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, instructionsView.frame.size.width - 4, instructionsView.frame.size.height - 4)];
    [whiteView setBackgroundColor:[UIColor whiteColor]];
    [instructionsView addSubview:whiteView];
    
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 30.0)];
    [header setBackgroundColor:[UIColor clearColor]];
    [header setText:@"SQL Tool Help"];
    [header setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
    [header setTextAlignment:NSTextAlignmentCenter];
    [header setTextColor:[UIColor blackColor]];
    [whiteView addSubview:header];
    
    UILabel *instructions = [[UILabel alloc] initWithFrame:CGRectMake(2, 30, whiteView.frame.size.width - 4, whiteView.frame.size.height - 30)];
    [instructions setBackgroundColor:[UIColor clearColor]];
    [instructions setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    [instructions setTextColor:[UIColor blackColor]];
    [instructions setTextAlignment:NSTextAlignmentLeft];
    [instructions setNumberOfLines:0];
    [instructions setLineBreakMode:NSLineBreakByWordWrapping];
    NSMutableString *instructionsText = [NSMutableString stringWithString:@"Swipe down on this screen to return to previous screen."];
    [instructionsText appendString:@"\n\nSwipe down on the SQL Tool to return to Analyze Data."];
    [instructionsText appendString:@"\n\nSubmit TABLES to get a list of Epi Info tables on this device."];
    [instructionsText appendString:@"\n\nSubmit METADATA <table name> (or META <table name>) to see a table's columns, data types, and number of rows."];
    [instructionsText appendString:@"\n\nTouch and hold an output field's or column header's text for one second to copy its value to the clipboard."];
    [instructionsText appendString:@"\n\nUse the guid() function to generate a unique GlobalRecordID. (Note: this function generates a single value per submit so do not use when updating more than one record.)"];
    [instructions setText:instructionsText];
    [whiteView addSubview:instructions];
    
    UIView *swipeDownView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, instructionsView.frame.size.width, instructionsView.frame.size.height)];
    [swipeDownView setBackgroundColor:[UIColor clearColor]];
    UISwipeGestureRecognizer *instructionsDownSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissInstructionsView:)];
    [instructionsDownSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [instructionsDownSwipe setNumberOfTouchesRequired:1];
    [swipeDownView addGestureRecognizer:instructionsDownSwipe];
    [instructionsView addSubview:swipeDownView];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [instructionsView setFrame:CGRectMake(0, 0, instructionsView.frame.size.width, instructionsView.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)dismissInstructionsView:(id)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [instructionsView setFrame:CGRectMake(0, initialHeight, instructionsView.frame.size.width, instructionsView.frame.size.height)];
    } completion:^(BOOL finished){
        [instructionsView removeFromSuperview];
    }];
}

-(void)clearButtonPressed:(UIButton *)sender
{
    [sqlStatementField setText:@""];
}

- (void)downSwipe:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setFrame:CGRectMake(0, initialHeight, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

- (BOOL)sqlStatementFieldResign:(id)sender
{
    BOOL boo = [sqlStatementField resignFirstResponder];
    return boo;
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer state] == UIGestureRecognizerStateRecognized)
    {
        UILabel *sender = (UILabel *)[gestureRecognizer view];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:[sender text]];
        UIAlertView *copyNotice = [[UIAlertView alloc] initWithTitle:@"Copy" message:@"Field text copied to clipboard." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [copyNotice show];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
