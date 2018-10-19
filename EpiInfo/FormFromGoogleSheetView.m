//
//  FormFromGoogleSheetView.m
//  EpiInfo
//
//  Created by John Copeland on 10/18/18.
//

#import "FormFromGoogleSheetView.h"

@implementation FormFromGoogleSheetView

- (id)initWithFrame:(CGRect)frame andSender:(UIButton *)sender
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        float textViewX = 4.0;
        float textViewWidth = 312.0;
        for (UIView *v in [[sender superview] subviews])
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                if ([[[(UIButton *)v titleLabel] text] containsString:@"Open"])
                {
                    self.runButton = [[UIButton alloc] initWithFrame:v.frame];
                    [self.runButton.layer setMasksToBounds:YES];
                    [self.runButton.layer setCornerRadius:4.0];
                    [self.runButton.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
                    [self.runButton.layer setBorderWidth:1.0];
                    [self.runButton setTitle:@"Make Form" forState:UIControlStateNormal];
                    [self.runButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [self.runButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
                    [self.runButton addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
                    [self.runButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.runButton addTarget:self action:@selector(buttonDragged:) forControlEvents:UIControlEventTouchDragExit];
                    [self.runButton setTag:1011];
                    [self addSubview:self.runButton];
                }
                else if ([[[(UIButton *)v titleLabel] text] containsString:@"Manage"])
                {
                    self.dismissButton = [[UIButton alloc] initWithFrame:v.frame];
                    [self.dismissButton.layer setMasksToBounds:YES];
                    [self.dismissButton.layer setCornerRadius:4.0];
                    [self.dismissButton.layer setBorderColor:[[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] CGColor]];
                    [self.dismissButton.layer setBorderWidth:1.0];
                    [self.dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
                    [self.dismissButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
                    [self.dismissButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
                    [self.dismissButton addTarget:self action:@selector(buttonTouchedDown:) forControlEvents:UIControlEventTouchDown];
                    [self.dismissButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [self.dismissButton addTarget:self action:@selector(buttonDragged:) forControlEvents:UIControlEventTouchDragExit];
                    [self.dismissButton setTag:1100];
                    [self addSubview:self.dismissButton];
                }
            }
            else if ([v isKindOfClass:[LegalValuesEnter class]])
            {
                textViewX = v.frame.origin.x;
                textViewWidth = v.frame.size.width;
                devclve = (LegalValuesEnter *)v;
            }
        }
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(textViewX, 4, textViewWidth, self.runButton.frame.origin.y - 8.0)];
        [backgroundView setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        sheetURL = [[UITextView alloc] initWithFrame:CGRectMake(1, 1, backgroundView.frame.size.width - 2.0, backgroundView.frame.size.height - 2.0)];
        [sheetURL setTextColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [sheetURL setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [sheetURL setText:@"Paste link to public Google sheet here."];
        [sheetURL setDelegate:self];
        [backgroundView addSubview:sheetURL];
        [self addSubview:backgroundView];
    }
    
    return self;
}

- (void)buttonPressed:(UIButton *)sender
{
    [sheetURL resignFirstResponder];
    [sender setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    if ([sender tag] == 1011)
    {
        NSString *requestString = [@"https://functions-zfj4.azurewebsites.net/api/EpiFormMaker?name=" stringByAppendingString:[sheetURL text]];
        NSURL *requestURL = [NSURL URLWithString:requestString];
        NSThread *generateFormThread = [[NSThread alloc] initWithTarget:self selector:@selector(tryToGenerateForm:) object:requestURL];
        [generateFormThread start];
        
        [sheetURL setTextColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [sheetURL setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [sheetURL setText:@"Processing..."];
    }
    else if ([sender tag] == 1100)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CGRect sheetViewFrame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
            [self setFrame:sheetViewFrame];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)buttonTouchedDown:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
}
- (void)buttonDragged:(UIButton *)sender
{
    [sender setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
}

- (void)tryToGenerateForm:(NSURL *)request
{
    NSString *resultsString = [NSString stringWithContentsOfURL:request encoding:NSUTF8StringEncoding error:nil];
    
    if (resultsString != nil && [[resultsString substringToIndex:9] isEqualToString:@"<Template"] && [resultsString containsString:@"<Field Name="])
    {
        int firstQuote = (int)[resultsString rangeOfString:@"Template Name=\""].length;
        int secondQuote = (int)[resultsString rangeOfString:@"\" CreateDate="].location;
        NSString *formName = [resultsString substringWithRange:NSMakeRange(firstQuote + 1, secondQuote - firstQuote - 1)];
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]] && formName.length > 0)
            {
                NSString *filePathAndName = [[[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] stringByAppendingString:@"/"] stringByAppendingString:formName] stringByAppendingString:@".xml"];
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePathAndName])
                {
                    [[NSFileManager defaultManager] removeItemAtPath:filePathAndName error:nil];
                }
                [resultsString writeToFile:filePathAndName atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
                // Write the cloud info to the cloud database
                // Create the database if it doesn't exist
                if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"]])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
                }
                if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"]])
                {
                    NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase/Clouds.db"];
                    
                    //Create the new table if necessary
                    int tableAlreadyExists = 0;
                    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                    {
                        NSString *selStmt = @"select count(name) as n from sqlite_master where name = 'Clouds'";
                        const char *query_stmt = [selStmt UTF8String];
                        sqlite3_stmt *statement;
                        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            if (sqlite3_step(statement) == SQLITE_ROW)
                                tableAlreadyExists = sqlite3_column_int(statement, 0);
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(epiinfoDB);
                    if (tableAlreadyExists < 1)
                    {
                        //Convert the databasePath NSString to a char array
                        const char *dbpath = [databasePath UTF8String];
                        
                        //Open sqlite3 analysisDB pointing to the databasePath
                        if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
                        {
                            char *errMsg;
                            //Build the CREATE TABLE statement
                            //Convert the sqlStmt to char array
                            NSString *createTableStatement = @"create table Clouds(FormName text, CloudDataType text, CloudDataBase text, CloudDataKey text)";
                            const char *sql_stmt = [createTableStatement UTF8String];
                            
                            //Execute the CREATE TABLE statement
                            if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                            {
                                NSLog(@"Failed to create table: %s :::: %@", errMsg, createTableStatement);
                            }
                            else
                            {
                                NSLog(@"Table created");
                            }
                            //Close the sqlite connection
                            sqlite3_close(epiinfoDB);
                        }
                        else
                        {
                            NSLog(@"Failed to open/create database");
                        }
                    }
                    
                    // Insert the row
                    tableAlreadyExists = 0;
                    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                    {
                        NSString *selStmt = @"select count(name) as n from sqlite_master where name = 'Clouds'";
                        const char *query_stmt = [selStmt UTF8String];
                        sqlite3_stmt *statement;
                        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            if (sqlite3_step(statement) == SQLITE_ROW)
                                tableAlreadyExists = sqlite3_column_int(statement, 0);
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(epiinfoDB);
                    if (tableAlreadyExists >= 1)
                    {
                        //Convert the databasePath NSString to a char array
                        const char *dbpath = [databasePath UTF8String];
                        
                        //Open sqlite3 analysisDB pointing to the databasePath
                        if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
                        {
                            char *errMsg;
                            NSString *insertStatement = [NSString stringWithFormat:@"delete from Clouds where FormName = '%@'", formName];
                            const char *sql_stmt = [insertStatement UTF8String];
                            
                            //Execute the CREATE TABLE statement
                            if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                            {
                                NSLog(@"Failed to remove row from table: %s :::: %@", errMsg, insertStatement);
                            }
                            else
                            {
                                NSLog(@"Row removed");
                            }
                            insertStatement = [NSString stringWithFormat:@"insert into Clouds values('%@', '%@', '%@', '%@')", formName, nil, nil, nil];
                            sql_stmt = [insertStatement UTF8String];
                            
                            //Execute the CREATE TABLE statement
                            if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                            {
                                NSLog(@"Failed to insert row into table: %s :::: %@", errMsg, insertStatement);
                            }
                            else
                            {
                                NSLog(@"Row inserted");
                            }
                            //Close the sqlite connection
                            sqlite3_close(epiinfoDB);
                        }
                        else
                        {
                            NSLog(@"Failed to open database or insert record");
                        }
                    }
                    else
                    {
                        NSLog(@"Could not find table");
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [sheetURL setTextColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
            [sheetURL setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sheetURL setText:[NSString stringWithFormat:@"%@ form generated from Google sheet. Dismiss this screen and return to \"Enter Data\" to open the form.", formName]];
            
            int selectedindex = 0;
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] error:nil];
            NSMutableArray *pickerFiles = [[NSMutableArray alloc] init];
            [pickerFiles addObject:@""];
            int count = 0;
            for (id i in files)
            {
                if ([(NSString *)i characterAtIndex:0] == '_')
                    continue;
                count++;
                [pickerFiles addObject:[(NSString *)i substringToIndex:[(NSString *)i length] - 4]];
            }
            [devclve setListOfValues:pickerFiles];
            [devclve.picker selectRow:selectedindex inComponent:0 animated:YES];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [sheetURL setTextColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
            [sheetURL setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sheetURL setText:@"Could not generate the form. Please check the Google sheet URL."];
        });
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [sheetURL setText:@""];
    [sheetURL setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
    [sheetURL setTextColor:[UIColor blackColor]];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
