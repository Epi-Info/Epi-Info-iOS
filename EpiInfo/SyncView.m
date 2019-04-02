//
//  SyncView.m
//  EpiInfo
//
//  Created by John Copeland on 3/20/19.
//

#import "SyncView.h"

@implementation SyncView
@synthesize url = _url;
@synthesize rootViewController = _rootViewController;
@synthesize fakeNavBar = _fakeNavBar;

#define SUCCESS ((int) 1000)
#define INSERT_COULD_NOT_PARSE_FORM ((int) 1001)
#define INSERT_NO_FORMS_FOUND ((int) 1002)
#define INSERT_COULD_NOT_INSERT ((int) 1003)
#define UPDATE_COULD_NOT_PARSE_FORM ((int) 1004)
#define UPDATE_NO_FORMS_FOUND ((int) 1005)
#define UPDATE_COULD_NOT_UPDATE ((int) 1006)

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        [self setUrl:url];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndFakeNavBar:(UIView *)fnb
{
    self = [self initWithFrame:frame AndURL:url];
    if (self)
    {
        [self setRootViewController:rvc];
        [self setFakeNavBar:fnb];

        float uinbY = 0.0;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            uinbY = 20.0;
        UINavigationBar *uinb = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, uinbY, self.fakeNavBar.frame.size.width, 20)];
        [uinb setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [uinb setShadowImage:[UIImage new]];
        [uinb setTranslucent:YES];
        UINavigationItem *uini = [[UINavigationItem alloc] initWithTitle:@""];
        xBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissForm)];
        [xBarButton setAccessibilityLabel:@"Cancel"];
        [xBarButton setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        saveBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveTheForm)];
        [saveBarButton setAccessibilityLabel:@"Continue importing the data."];
        [saveBarButton setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [uini setRightBarButtonItem:xBarButton];
        [uini setLeftBarButtonItem:saveBarButton];
        [uinb setItems:[NSArray arrayWithObject:uini]];
        [self.fakeNavBar addSubview:uinb];
        
        UILabel *pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 150.0, 40, 280, 28)];
        [pickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [pickerLabel setText:@"Select a data destination:"];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:pickerLabel];
        
        lvSelected = [[UITextField alloc] init];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]] && [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] error:nil].count > 0)
        {
            int selectedindex = 0;
            NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] error:nil];
            NSMutableArray *pickerFiles = [[NSMutableArray alloc] init];
            [pickerFiles addObject:@""];
            int count = 0;
            for (id i in files)
            {
                count++;
                [pickerFiles addObject:[(NSString *)i substringToIndex:[(NSString *)i length] - 4]];
            }
            lv = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 150.0, 68, 300, 180) AndListOfValues:pickerFiles AndTextFieldToUpdate:lvSelected];
            [lv.picker selectRow:selectedindex inComponent:0 animated:YES];
            [lv setTag:1957];
            [self addSubview:lv];
            
            UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(lv.frame.origin.x, lv.frame.origin.y + lv.frame.size.height, 280, 28)];
            [passwordLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [passwordLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [passwordLabel setText:@"Password:"];
            [passwordLabel setBackgroundColor:[UIColor clearColor]];
            [self addSubview:passwordLabel];
            
            passwordField = [[UITextField alloc] initWithFrame:CGRectMake(passwordLabel.frame.origin.x, passwordLabel.frame.origin.y + passwordLabel.frame.size.height, 280, 40)];
            [passwordField setDelegate:self];
            [passwordField setBorderStyle:UITextBorderStyleRoundedRect];
            [passwordField setReturnKeyType:UIReturnKeyDone];
            [passwordField setSecureTextEntry:YES];
            [self addSubview:passwordField];
        }
        else
            [pickerLabel setText:@"No forms found on this device."];
    }
    return self;
}

- (BOOL)decryptSyncFile
{
    NSString *encryptedString0 = [NSString stringWithContentsOfURL:self.url encoding:NSUTF8StringEncoding error:nil];
    if ([[encryptedString0 substringWithRange:NSMakeRange(0, 5)] isEqualToString:@"APPLE"])
    {
        NSString *encryptedString = [NSString stringWithString:[encryptedString0 substringFromIndex:5]];
        NSData *encryptedData = [[NSData alloc] initWithBase64EncodedString:encryptedString options:NSDataBase64EncodingEndLineWithCarriageReturn];
        CCCryptorStatus ccStatus = kCCSuccess;
        CCCryptorRef thisEncipher = NULL;
        NSData *cipherOrPlainText = nil;
        uint8_t *bufferPtr = NULL;
        size_t bufferPtrSize = 0;
        size_t remainingBytes = 0;
        size_t movedBytes = 0;
        size_t plainTextBufferSize = 0;
        size_t totalBytesWritten = 0;
        uint8_t *ptr;
        
        NSString *password = [NSString stringWithString:[passwordField text]];
        float passwordLength = (float)password.length;
        float sixteens = 16.0 / passwordLength;
        if (sixteens > 1.0)
            for (int i = 0; i < (int)sixteens; i++)
                password = [password stringByAppendingString:password];
        password = [password substringToIndex:16];
        
        ccStatus = CCCryptorCreate(kCCDecrypt,
                                   kCCAlgorithmAES128,
                                   kCCOptionPKCS7Padding, // 0x0000 or kCCOptionPKCS7Padding
                                   (const void *)[password dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                   [password dataUsingEncoding:NSUTF8StringEncoding].length,
                                   (const void *)[@"0000000000000000" dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                   &thisEncipher
                                   );
        plainTextBufferSize = [encryptedData length];
        bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
        bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t) );
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        ptr = bufferPtr;
        remainingBytes = bufferPtrSize;
        ccStatus = CCCryptorUpdate(thisEncipher, (const void *) [encryptedData bytes], plainTextBufferSize, ptr, remainingBytes, &movedBytes);
        ptr += movedBytes;
        remainingBytes -= movedBytes;
        totalBytesWritten += movedBytes;
        ccStatus = CCCryptorFinal(thisEncipher, ptr, remainingBytes, &movedBytes);
        totalBytesWritten += movedBytes;
        cipherOrPlainText = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
        CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
        if(bufferPtr) free(bufferPtr);
        dataText = [[NSString alloc] initWithData:cipherOrPlainText encoding:NSUTF8StringEncoding];
        if (!dataText)
            return NO;
    }
    return YES;
}

- (BOOL)updateAppendData
{
    NSLog(@"%@", dataText);
    arrayOfGUIDs = [[NSMutableArray alloc] init];
    arrayOfColumns = [[NSMutableArray alloc] init];
    arrayOfValues = [[NSMutableArray alloc] init];
    doingResponseDetail = NO;
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[dataText dataUsingEncoding:NSUTF8StringEncoding]];
    [parser setDelegate:self];
    [parser setShouldResolveExternalEntities:YES];
    BOOL rc = [parser parse];
    if (rc)
    {
        if ([arrayOfGUIDs count] * [arrayOfColumns count] == [arrayOfValues count])
        {
            NSLog(@"%lu rows * %lu columns = %lu values.", (unsigned long)[arrayOfGUIDs count], (unsigned long)[arrayOfColumns count], (unsigned long)[arrayOfValues count]);
            NSArray *existingColumns = [self getExistingColumns];
            for (NSString *st in arrayOfColumns)
            {
                if (![existingColumns containsObject:st])
                {
                    NSLog(@"Column %@ not found in %@.", st, [lvSelected text]);
                    return NO;
                }
            }
            NSArray *existingGUIDs = [self getExistingGUIDs];
            NSMutableArray *guidsToUpdate = [[NSMutableArray alloc] init];
            NSMutableArray *guidsToAdd = [[NSMutableArray alloc] init];
            NSMutableArray *valuesToUpdate = [[NSMutableArray alloc] init];
            NSMutableArray *valuesToAdd = [[NSMutableArray alloc] init];
            for (int i = 0; i < [arrayOfGUIDs count]; i++)
            {
                NSString *st = [arrayOfGUIDs objectAtIndex:i];
                if ([existingGUIDs containsObject:st])
                {
                    [guidsToUpdate addObject:st];
                    for (int j = 0; j < [arrayOfColumns count]; j++)
                    {
                        [valuesToUpdate addObject:[arrayOfValues objectAtIndex:i * [arrayOfColumns count] + j]];
                    }
                }
                else
                {
                    [guidsToAdd addObject:st];
                    for (int j = 0; j < [arrayOfColumns count]; j++)
                    {
                        [valuesToAdd addObject:[arrayOfValues objectAtIndex:i * [arrayOfColumns count] + j]];
                    }
                }
            }
            if ([guidsToUpdate count] > 0)
            {
                if ([self updateRowsWithGUIDs:guidsToUpdate AndValues:valuesToUpdate] != SUCCESS)
                {
                    NSLog(@"Could not update rows to be updated.");
                    return NO;
                }
            }
            if ([guidsToAdd count] > 0)
            {
                if ([self insertRowsWithGUIDs:guidsToAdd AndValues:valuesToAdd] != SUCCESS)
                {
                    NSLog(@"Could not insert rows.");
                    return NO;
                }
            }
        }
        else
        {
            NSLog(@"Colums:Values mismatch");
        }
    }
    return rc;
}

- (int)insertRowsWithGUIDs:(NSArray *)newGUIDs AndValues:(NSArray *)newValues
{
    int rows = (int)[newGUIDs count];
    int columns = (int)[arrayOfColumns count];
    
    createTableStatement = @"";
    dictionaryOfColumnsAndTypes = [[NSMutableDictionary alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        NSString *epiInfoForms = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"];
        NSURL *templateFile = [[NSURL alloc] initWithString:[@"file://" stringByAppendingString:[[[epiInfoForms stringByAppendingString:@"/"] stringByAppendingString:[lvSelected text]] stringByAppendingString:@".xml"]]];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:templateFile];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:YES];
        BOOL rc = [parser parse];
        if (!rc)
        {
            NSLog(@"Could not parse form template.");
            return INSERT_COULD_NOT_PARSE_FORM;
        }
    }
    else
    {
        NSLog(@"No forms on this device.");
        return INSERT_NO_FORMS_FOUND;
    }

    NSMutableString *insertString = [NSMutableString stringWithString:[NSString stringWithFormat:@"insert into %@(GlobalRecordId", [lvSelected text]]];
    for (int i = 0; i < columns; i++)
    {
        [insertString appendString:@", "];
        [insertString appendString:[arrayOfColumns objectAtIndex:i]];
    }
    [insertString appendString:@")"];
    for (int i = 0; i < rows; i++)
    {
        NSMutableString *valuesClause = [NSMutableString stringWithString:[NSString stringWithFormat:@"values('%@'", [newGUIDs objectAtIndex:i]]];
        for (int j = 0; j < columns; j++)
        {
            int indx = i * columns + j;
            [valuesClause appendString:@", "];
            if ([(NSNumber *)[dictionaryOfColumnsAndTypes objectForKey:[arrayOfColumns objectAtIndex:j]] intValue] > 1)
            {
                [valuesClause appendString:@"'"];
            }
            if ([(NSNumber *)[dictionaryOfColumnsAndTypes objectForKey:[arrayOfColumns objectAtIndex:j]] intValue] == 3)
            {
                NSString *syncDate = [newValues objectAtIndex:indx];
                NSArray *dateParts = [syncDate componentsSeparatedByString:@"-"];
                NSString *mmddyyyy = @"";
                if ([dateParts count] != 3)
                {
                    mmddyyyy = [[syncDate stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                }
                else
                    mmddyyyy = [NSString stringWithFormat:@"%@/%@/%@", [dateParts objectAtIndex:1], [dateParts objectAtIndex:2], [dateParts objectAtIndex:0]];
                [valuesClause appendString:mmddyyyy];
            }
            else
                [valuesClause appendString:[newValues objectAtIndex:indx]];
            if ([(NSNumber *)[dictionaryOfColumnsAndTypes objectForKey:[arrayOfColumns objectAtIndex:j]] intValue] > 1)
            {
                [valuesClause appendString:@"'"];
            }
        }
        [valuesClause appendString:@")"];
        NSString *sqlStatement = [NSString stringWithFormat:@"%@ %@", insertString, valuesClause];
        NSLog(@"%@", sqlStatement);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
        {
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
            
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                const char *query_stmt = [sqlStatement UTF8String];
                if (sqlite3_exec(epiinfoDB, query_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to insert row into table.");
                    return INSERT_COULD_NOT_INSERT;
                }
            }
        }
        sqlite3_close(epiinfoDB);
    }
    return SUCCESS;
}

- (int)updateRowsWithGUIDs:(NSArray *)existingGuids AndValues:(NSArray *)updatedValues
{
    int rows = (int)[existingGuids count];
    int columns = (int)[arrayOfColumns count];
    
    createTableStatement = @"";
    dictionaryOfColumnsAndTypes = [[NSMutableDictionary alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
    {
        NSString *epiInfoForms = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"];
        NSURL *templateFile = [[NSURL alloc] initWithString:[@"file://" stringByAppendingString:[[[epiInfoForms stringByAppendingString:@"/"] stringByAppendingString:[lvSelected text]] stringByAppendingString:@".xml"]]];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:templateFile];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:YES];
        BOOL rc = [parser parse];
        if (!rc)
        {
            NSLog(@"Could not parse form template.");
            return UPDATE_COULD_NOT_PARSE_FORM;
        }
    }
    else
    {
        NSLog(@"No forms on this device.");
        return UPDATE_NO_FORMS_FOUND;
    }

    for (int i = 0; i < rows; i++)
    {
        NSMutableString *updateString = [NSMutableString stringWithString:[NSString stringWithFormat:@"update %@\nset ", [lvSelected text]]];
        NSString *whereClause = [NSString stringWithFormat:@" where GlobalRecordId = '%@'", [existingGuids objectAtIndex:i]];
        for (int j = 0; j < columns; j++)
        {
            int indx = i * columns + j;
            if (j > 0)
            {
                [updateString appendString:@",\n"];
            }
            [updateString appendString:[arrayOfColumns objectAtIndex:j]];
            [updateString appendString:@" = "];
            if ([(NSNumber *)[dictionaryOfColumnsAndTypes objectForKey:[arrayOfColumns objectAtIndex:j]] intValue] > 1)
            {
                [updateString appendString:@"'"];
            }
            if ([(NSNumber *)[dictionaryOfColumnsAndTypes objectForKey:[arrayOfColumns objectAtIndex:j]] intValue] == 3)
            {
                NSString *syncDate = [updatedValues objectAtIndex:indx];
                NSArray *dateParts = [syncDate componentsSeparatedByString:@"-"];
                NSString *mmddyyyy = @"";
                if ([dateParts count] != 3)
                {
                    mmddyyyy = [[syncDate stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                }
                else
                    mmddyyyy = [NSString stringWithFormat:@"%@/%@/%@", [dateParts objectAtIndex:1], [dateParts objectAtIndex:2], [dateParts objectAtIndex:0]];
                [updateString appendString:mmddyyyy];
            }
            else
                [updateString appendString:[updatedValues objectAtIndex:indx]];
            if ([(NSNumber *)[dictionaryOfColumnsAndTypes objectForKey:[arrayOfColumns objectAtIndex:j]] intValue] > 1)
            {
                [updateString appendString:@"'"];
            }
        }
        NSString *sqlStatement = [NSString stringWithFormat:@"%@\n%@", updateString, whereClause];
        NSLog(@"%@", sqlStatement);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
        {
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
            
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                const char *query_stmt = [sqlStatement UTF8String];
                if (sqlite3_exec(epiinfoDB, query_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to update row in table.");
                    return UPDATE_COULD_NOT_UPDATE;
                }
            }
        }
        sqlite3_close(epiinfoDB);
    }
    return SUCCESS;
}

- (BOOL)deleteRowsWithGUIDs:(NSArray *)existingGuids
{
    NSMutableString *guidList = [NSMutableString stringWithString:[NSString stringWithFormat:@"'%@'", [arrayOfGUIDs objectAtIndex:0]]];
    for (int i = 1; i < [arrayOfGUIDs count]; i++)
    {
        [guidList appendString:[NSString stringWithFormat:@", '%@'", [arrayOfGUIDs objectAtIndex:i]]];
    }
    NSString *sqlStatement = [NSString stringWithFormat:@"delete from %@ where GlobalRecordId in (%@)", [lvSelected text], guidList];
    NSLog(@"%@", sqlStatement);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            char *errMsg;
            const char *query_stmt = [sqlStatement UTF8String];
            if (sqlite3_exec(epiinfoDB, query_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to delete row from table.");
                return NO;
            }
        }
    }
    sqlite3_close(epiinfoDB);
    return YES;
}

- (NSArray *)getExistingGUIDs
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select GlobalRecordId from %@", [lvSelected text]];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    int i = 0;
                    while (sqlite3_column_name(statement, i))
                    {
                        [nsma addObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                        i++;
                    }
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
    }
    return [NSArray arrayWithArray:nsma];
}

- (NSArray *)getExistingColumns
{
    NSMutableArray *nsma = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select * from %@", [lvSelected text]];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    int i = 0;
                    while (sqlite3_column_name(statement, i))
                    {
                        [nsma addObject:[[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)]];
                        i++;
                    }
                    break;
                }
            }
            else
            {
                createTableStatement = @"";
                dictionaryOfColumnsAndTypes = [[NSMutableDictionary alloc] init];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
                {
                    NSString *epiInfoForms = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"];
                    NSURL *templateFile = [[NSURL alloc] initWithString:[@"file://" stringByAppendingString:[[[epiInfoForms stringByAppendingString:@"/"] stringByAppendingString:[lvSelected text]] stringByAppendingString:@".xml"]]];
                    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:templateFile];
                    [parser setDelegate:self];
                    [parser setShouldResolveExternalEntities:YES];
                    BOOL rc = [parser parse];
                    if (!rc)
                    {
                        NSLog(@"Could not parse form template.");
                        return [NSArray arrayWithArray:nsma];
                    }
                    else
                    {
                        createTableStatement = [createTableStatement stringByAppendingString:@")"];
                        char *errMsg;
                        const char *sql_stmt = [createTableStatement UTF8String];
                        if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                        {
                            NSLog(@"Failed to create table: %s :::: %@", errMsg, createTableStatement);
                            [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to create table: %s :::: %@\n", [NSDate date], errMsg, createTableStatement]];
                        }
                        else
                        {
                            [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: SUBMIT: %@ table created\n", [NSDate date], formName]];
                            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                            {
                                while (sqlite3_step(statement) == SQLITE_ROW)
                                {
                                    int i = 0;
                                    while (sqlite3_column_name(statement, i))
                                    {
                                        [nsma addObject:[[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)]];
                                        i++;
                                    }
                                    break;
                                }
                            }
                        }
                    }
                }
                else
                {
                    NSLog(@"No forms on this device.");
                    return [NSArray arrayWithArray:nsma];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
    }
    return [NSArray arrayWithArray:nsma];
}

- (void)saveTheForm
{
    if ([[passwordField text] length] == 0 || [[lvSelected text] length] == 0)
        return;
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        BOOL rc = [self decryptSyncFile];
        if (rc)
            rc = [self updateAppendData];
        [self removeFromSuperview];
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
            [self.rootViewController.view.layer setTransform:CATransform3DIdentity];
        } completion:^(BOOL finished){
        }];
    }];
}

- (void)dismissForm
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * -0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * -1.0, 0.0, 1.0, 0.0);
            [self.rootViewController.view.layer setTransform:rotate];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                CATransform3D rotate = CATransform3DIdentity;
                rotate.m34 = 1.0 / -2000;
                rotate = CATransform3DRotate(rotate, M_PI * -1.5, 0.0, 1.0, 0.0);
                [self.rootViewController.view.layer setTransform:rotate];
            } completion:^(BOOL finished){
                [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                    CATransform3D rotate = CATransform3DIdentity;
                    rotate.m34 = 1.0 / -2000;
                    rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
                    [self.rootViewController.view.layer setTransform:CATransform3DIdentity];
                } completion:^(BOOL finished){
                }];
            }];
        }];
    }];
}

- (void)removeFromSuperview
{
    [self.fakeNavBar removeFromSuperview];
    [super removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark XML Parsing Methods

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"SurveyResponse"])
    {
        NSString *guidString = [attributeDict objectForKey:@"SurveyResponseID"];
        [arrayOfGUIDs addObject:guidString];
    }
    else if ([elementName isEqualToString:@"ResponseDetail"])
    {
        doingResponseDetail = YES;
        NSString *columnName = [attributeDict objectForKey:@"QuestionName"];
        if (![arrayOfColumns containsObject:columnName])
            [arrayOfColumns addObject:columnName];
    }
    else if ([elementName isEqualToString:@"Field"])
    {
        if (createTableStatement == nil)
        {
            createTableStatement = @"";
        }
        if (dictionaryOfColumnsAndTypes == nil)
        {
            dictionaryOfColumnsAndTypes = [[NSMutableDictionary alloc] init];
        }
        if ([createTableStatement length] == 0)
        {
            createTableStatement = [NSString stringWithFormat:@"create table %@(GlobalRecordID text", [lvSelected text]];
        }
        if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"1"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"2"])
        {
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"3"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"4"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"5"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ real", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:1] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"6"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"7"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:3] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"8"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"9"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"10"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ integer", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:0] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"11"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ integer", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:0] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"15"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"17"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"18"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"19"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"14"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"12"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
        else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"25"])
        {
            createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@",\n%@ text", [attributeDict objectForKey:@"Name"]]];
            [dictionaryOfColumnsAndTypes setObject:[NSNumber numberWithInt:2] forKey:[attributeDict objectForKey:@"Name"]];
        }
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!doingResponseDetail)
        return;
    [arrayOfValues addObject:string];
    doingResponseDetail = NO;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
