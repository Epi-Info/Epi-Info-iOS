//
//  SaveFormView.m
//  EpiInfo
//
//  Created by John Copeland on 12/3/13.
//

#import "SaveFormView.h"

@implementation SaveFormView
@synthesize url = _url;
@synthesize rootViewController = _rootViewController;
@synthesize formView = _formView;
@synthesize formName = _formName;
@synthesize cloudDataType = _cloudDataType;
@synthesize cloudDataBase = _cloudDataBase;
@synthesize cloudDataKey = _cloudDataKey;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIImageView *imageBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        if (frame.size.height < 500.0)
            [imageBackground setImage:[UIImage imageNamed:@"iPhone4Background.png"]];
        else
            [imageBackground setImage:[UIImage imageNamed:@"iPhone5Background.png"]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [imageBackground setImage:[UIImage imageNamed:@"iPadBackground.png"]];
//        [self addSubview:imageBackground];
        
        UIView *nonImageBackground = [[UIView alloc] initWithFrame:imageBackground.frame];
        [nonImageBackground setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:nonImageBackground];
        
        fakeNavBar = [[UILabel alloc] initWithFrame:CGRectMake(0, -40, frame.size.width, 40)];
        [fakeNavBar setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [fakeNavBar setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]];
        [fakeNavBar setTextAlignment:NSTextAlignmentCenter];
        [fakeNavBar setTextColor:[UIColor whiteColor]];
        [fakeNavBar setText:@"Save Epi Info Form"];
        [self addSubview:fakeNavBar];
        
        UILabel *typeFormNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 28)];
        [typeFormNameLabel setTextColor:[UIColor whiteColor]];
        [typeFormNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [typeFormNameLabel setText:@"Form name:"];
        [typeFormNameLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:typeFormNameLabel];

        typeFormName = [[UITextField alloc] initWithFrame:CGRectMake(20, 48, 280, 40)];
        [typeFormName setBorderStyle:UITextBorderStyleRoundedRect];
        [typeFormName setReturnKeyType:UIReturnKeyDone];
        [typeFormName setDelegate:self];
        [self addSubview:typeFormName];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(198, frame.size.height - 42, 120, 40)];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [saveButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [saveButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [saveButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [saveButton.layer setMasksToBounds:YES];
        [saveButton.layer setCornerRadius:4.0];
        [saveButton addTarget:self action:@selector(saveButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveButton];
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(2, frame.size.height - 42, 120, 40)];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [cancelButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [cancelButton.layer setMasksToBounds:YES];
        [cancelButton.layer setCornerRadius:4.0];
        [cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame AndRootViewController:(UIViewController *)rvc AndFormView:(UIView *)fv AndFormName:(NSString *)fn AndURL:(NSURL *)url
{
    self = [self initWithFrame:frame];
    if (self)
    {
        [self setRootViewController:rvc];
        [self setFormView:fv];
        [self setFormName:fn];
        [self setUrl:url];
        [typeFormName setText:self.formName];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] withIntermediateDirectories:NO attributes:nil error:nil];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
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
                if ([[pickerFiles objectAtIndex:count] isEqualToString:typeFormName.text])
                    selectedindex = count;
            }
            UILabel *pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 28)];
            [pickerLabel setTextColor:[UIColor whiteColor]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [pickerLabel setText:@"Existing forms:"];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            
            LegalValues *lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 100, 300, 180) AndListOfValues:pickerFiles AndTextFieldToUpdate:typeFormName];
            [lv.picker selectRow:selectedindex inComponent:0 animated:YES];
            [self addSubview:lv];
            
            [self addSubview:pickerLabel];
        }
        UILabel *repositoriesLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 280, 280, 28)];
        [repositoriesLabel setTextColor:[UIColor blackColor]];
        [repositoriesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [repositoriesLabel setText:@"Cloud database credentials (optional):"];
        [repositoriesLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:repositoriesLabel];
        
        UIView *repositoryButtonsView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 310, self.frame.size.width, 80)];
        [repositoryButtonsView0 setBackgroundColor:[UIColor clearColor]];
        [self addSubview:repositoryButtonsView0];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            UIButton *azureButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, repositoryButtonsView0.frame.size.width - 40, 40)];
            [azureButton setTitle:@"Cloud Database" forState:UIControlStateNormal];
            [azureButton setAccessibilityLabel:@"Cloud Database Credentials"];
            [azureButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            [azureButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [azureButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [azureButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [azureButton.layer setMasksToBounds:YES];
            [azureButton.layer setCornerRadius:4.0];
            [azureButton addTarget:self action:@selector(msButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [repositoryButtonsView0 addSubview:azureButton];
        }
        else
        {
            [repositoryButtonsView0 setFrame:CGRectMake(0, repositoriesLabel.frame.origin.y + 40, self.frame.size.width, 96)];
            UIButton *azureButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 280, 40)];
            [azureButton setTitle:@"Cloud Database" forState:UIControlStateNormal];
            [azureButton setAccessibilityLabel:@"Cloud Database Credentials"];
            [azureButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
            [azureButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [azureButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [azureButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [azureButton.layer setMasksToBounds:YES];
            [azureButton.layer setCornerRadius:4.0];
            [azureButton addTarget:self action:@selector(msButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [repositoryButtonsView0 addSubview:azureButton];
        }
    }
    return self;
}

- (void)msButtonPressed
{
    [self setCloudDataType:@"MSAzure"];
    
    float ratio = 280.0 / 320.0;
    msAzureCredsView = [[UIView alloc] initWithFrame:CGRectMake(20, 290, 280, 40)];
    
    UIImageView *msAzureCredsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    if (self.frame.size.height < 500.0)
        [msAzureCredsImageView setImage:[UIImage imageNamed:@"iPhone4Background.png"]];
    else
        [msAzureCredsImageView setImage:[UIImage imageNamed:@"iPhone5Background.png"]];
//    [msAzureCredsView addSubview:msAzureCredsImageView];
    
    UIView *nonImageBackground = [[UIView alloc] initWithFrame:msAzureCredsImageView.frame];
    [nonImageBackground setBackgroundColor:[UIColor whiteColor]];
    [msAzureCredsView addSubview:nonImageBackground];
    
    UILabel *applicationURLLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * ratio, 20 * ratio, 280 * ratio, 28 * ratio)];
    [applicationURLLabel setTextColor:[UIColor blackColor]];
    [applicationURLLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [applicationURLLabel setText:@"Application Name:"];
    [applicationURLLabel setBackgroundColor:[UIColor clearColor]];
    [msAzureCredsView addSubview:applicationURLLabel];
    
    EpiInfoTextField *applicationURL = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(20 * ratio, 48 * ratio, 280 * ratio, 40 * ratio)];
    [applicationURL setBorderStyle:UITextBorderStyleRoundedRect];
    [applicationURL setReturnKeyType:UIReturnKeyDone];
    [applicationURL setDelegate:self];
    [applicationURL setColumnName:@"cloudDataBase"];
    [applicationURL setAccessibilityLabel:@"Cloud application name"];
    [applicationURL setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [msAzureCredsView addSubview:applicationURL];
    
    UILabel *applicationKeyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * ratio, 90 * ratio, 280 * ratio, 28 * ratio)];
    [applicationKeyLabel setTextColor:[UIColor blackColor]];
    [applicationKeyLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [applicationKeyLabel setText:@"Application Token:"];
    [applicationKeyLabel setBackgroundColor:[UIColor clearColor]];
    [msAzureCredsView addSubview:applicationKeyLabel];
    
    EpiInfoTextField *applicationKey = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(20 * ratio, 118 * ratio, 280 * ratio, 40 * ratio)];
    [applicationKey setBorderStyle:UITextBorderStyleRoundedRect];
    [applicationKey setReturnKeyType:UIReturnKeyDone];
    [applicationKey setDelegate:self];
    [applicationKey setColumnName:@"cloudDataKey"];
    [applicationKey setAccessibilityLabel:@"Cloud application security token"];
    [applicationKey setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [msAzureCredsView addSubview:applicationKey];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        ratio = 76.0 / self.frame.size.width;
        [msAzureCredsView setFrame:CGRectMake(20, 290, 76, 76)];
        [msAzureCredsImageView setFrame:CGRectMake(0, 0, 76, 76)];
        [msAzureCredsImageView setImage:[UIImage imageNamed:@"iPadBackground.png"]];
    }

    [self addSubview:msAzureCredsView];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [msAzureCredsView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [nonImageBackground setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [applicationURLLabel setFrame:CGRectMake(20, 20, 280, 28)];
        [applicationURL setFrame:CGRectMake(20, 48, 280, 40)];
        [applicationKeyLabel setFrame:CGRectMake(20, 90, 280, 28)];
        [applicationKey setFrame:CGRectMake(20, 118, 280, 40)];
    } completion:^(BOOL finished){
        UINavigationBar *uinb = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 20, msAzureCredsView.frame.size.width, 20)];
        [uinb setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        [uinb setShadowImage:[UIImage new]];
        [uinb setTranslucent:YES];
        UINavigationItem *uini = [[UINavigationItem alloc] initWithTitle:@""];
        UIBarButtonItem *xBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(msXButtonPressed:)];
        [xBarButton setAccessibilityLabel:@"Close"];
        [xBarButton setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [uini setRightBarButtonItem:xBarButton];
        [uinb setItems:[NSArray arrayWithObject:uini]];
        [msAzureCredsView addSubview:uinb];
    }];
}
- (void)msXButtonPressed:(id)button
{
//    [button removeFromSuperview];
    [(UIBarButtonItem *)button setTintColor:[UIColor clearColor]];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [msAzureCredsView setFrame:CGRectMake(20, 290, 76, 76)];
            for (UIView *v in [msAzureCredsView subviews])
            {
                if ([v isKindOfClass:[UIImageView class]])
                    [v setFrame:CGRectMake(0, 0, 76, 76)];
                else
                    [v setFrame:CGRectMake(1, 30, 1, 1)];
            }
        }
        else
        {
            [msAzureCredsView setFrame:CGRectMake(20, 290, 280, 40)];
            for (UIView *v in [msAzureCredsView subviews])
            {
                if ([v isKindOfClass:[UIImageView class]])
                    [v setFrame:CGRectMake(0, 0, 280, 40)];
                else
                    [v setFrame:CGRectMake(20 * 280 / 320.0, 90 * 280 / 320.0, 280 * 280 / 320.0, 1)];
            }
        }
    } completion:^(BOOL finished){
        for (UIView *v in [msAzureCredsView subviews])
        {
            if ([v isKindOfClass:[EpiInfoTextField class]])
            {
                if ([[(EpiInfoTextField *)v columnName] isEqualToString:@"cloudDataBase"])
                    [self setCloudDataBase:[(EpiInfoTextField *)v text]];
                else if ([[(EpiInfoTextField *)v columnName] isEqualToString:@"cloudDataKey"])
                    [self setCloudDataKey:[(EpiInfoTextField *)v text]];
            }
        }

        [msAzureCredsView removeFromSuperview];
    }];
}

- (void)saveButtonPressed
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [self.formView removeFromSuperview];
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
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]] && typeFormName.text.length > 0)
            {
                NSString *filePathAndName = [[[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] stringByAppendingString:@"/"] stringByAppendingString:typeFormName.text] stringByAppendingString:@".xml"];
                if ([[NSFileManager defaultManager] fileExistsAtPath:filePathAndName])
                {
                    [[NSFileManager defaultManager] removeItemAtPath:filePathAndName error:nil];
                }
                NSString *xmlText = [self fixPageIdValues:[NSMutableString stringWithString:[NSString stringWithContentsOfFile:[NSString stringWithUTF8String:[self.url fileSystemRepresentation]] encoding:NSUTF8StringEncoding error:nil]]];
                [xmlText writeToFile:filePathAndName atomically:YES encoding:NSUTF8StringEncoding error:nil];
                
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
                            NSString *insertStatement = [NSString stringWithFormat:@"delete from Clouds where FormName = '%@'", typeFormName.text];
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
                            insertStatement = [NSString stringWithFormat:@"insert into Clouds values('%@', '%@', '%@', '%@')", typeFormName.text, self.cloudDataType, self.cloudDataBase, self.cloudDataKey];
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
                //
                // Write the Google sheet info to the Google sheet database
                // Create the database if it doesn't exist
                if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/GoogleSheetDatabase"]])
                {
                    [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/GoogleSheetDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
                }
                if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/GoogleSheetDatabase"]])
                {
                    NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/GoogleSheetDatabase/GoogleSheetInfo.db"];
                    
                    //Create the new table if necessary
                    int tableAlreadyExists = 0;
                    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                    {
                        NSString *selStmt = @"select count(name) as n from sqlite_master where name = 'GoogleSheets'";
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
                            NSString *createTableStatement = @"create table GoogleSheets(FormName text, GoogleSheetURL text)";
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
                        NSString *selStmt = @"select count(name) as n from sqlite_master where name = 'GoogleSheets'";
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
                            NSString *insertStatement = [NSString stringWithFormat:@"delete from GoogleSheets where FormName = '%@'", typeFormName.text];
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
                // Finished with the Google sheet database
            }
            [self createOrAlterSQLTable];
        }];
    }];
}

- (void)cancelButtonPressed
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        [self.formView setHidden:NO];
        [self removeFromSuperview];
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
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

- (NSString *)fixPageIdValues:(NSMutableString *)xmlText
{
    long substringStartPosition = 0;
    int pageNumber = 1;
    BOOL containsPage = [[xmlText substringFromIndex:substringStartPosition] containsString:@"<Page "];
    while ([[xmlText substringFromIndex:substringStartPosition] containsString:@"<Page "])
    {
        containsPage = [[xmlText substringFromIndex:substringStartPosition] containsString:@"<Page "];
        substringStartPosition += (long)[[xmlText substringFromIndex:substringStartPosition] rangeOfString:@"<Page "].location;
        substringStartPosition += (long)[[xmlText substringFromIndex:substringStartPosition] rangeOfString:@"PageId=\""].location + 8;
        NSString *pageNumberString = [NSString stringWithFormat:@"%d", pageNumber++];
        long relativePositionOfSecondQuote = (long)[[xmlText substringFromIndex:substringStartPosition] rangeOfString:@"\""].location;
        substringStartPosition += relativePositionOfSecondQuote + 1;
        NSString *actualPageString = [NSString stringWithFormat:@" ActualPageNumber=\"%@\"", pageNumberString];
        int actualPageStringLength = (int)[actualPageString length];
        [xmlText insertString:actualPageString atIndex:substringStartPosition];
        substringStartPosition += actualPageStringLength;
        containsPage = [[xmlText substringFromIndex:substringStartPosition] containsString:@"<Page "];
    }
    return [NSString stringWithString:xmlText];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}

- (void)createOrAlterSQLTable
{
    createTableStatement = @"";
    dictionaryOfColumnsAndTypes = [[NSMutableDictionary alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]] && typeFormName.text.length > 0)
    {
        NSString *filePathAndName = [[[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] stringByAppendingString:@"/"] stringByAppendingString:typeFormName.text] stringByAppendingString:@".xml"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePathAndName])
        {
            NSURL *templateFile = [[NSURL alloc] initWithString:[@"file://" stringByAppendingString:filePathAndName]];
            NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:templateFile];
            [parser setDelegate:self];
            [parser setShouldResolveExternalEntities:YES];
            BOOL success = [parser parse];
            if (success)
            {
                NSMutableArray *existingColumns = [[NSMutableArray alloc] init];
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
                {
                    NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
                    
                    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                    {
                        NSString *selStmt = [NSString stringWithFormat:@"select * from %@", [typeFormName text]];
                        const char *query_stmt = [selStmt UTF8String];
                        sqlite3_stmt *statement;
                        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            int i = 0;
                            while (sqlite3_column_name(statement, i))
                            {
                                [existingColumns addObject:[[[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)] lowercaseString]];
                                i++;
                            }
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
                                [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: SUBMIT: %@ table created\n", [NSDate date], [typeFormName text]]];
                            }
                        }
                        if ([existingColumns count] > 0)
                        {
                            NSMutableArray *newColumns = [[NSMutableArray alloc] init];
                            for (NSString *str in dictionaryOfColumnsAndTypes)
                            {
                                if (![existingColumns containsObject:[str lowercaseString]])
                                    [newColumns addObject:str];
                            }
                            if ([newColumns count] > 0)
                            {
                                NSMutableString *alterClause = [NSMutableString stringWithFormat:@"alter table %@ add", [typeFormName text]];
                                for (int i = 0; i < [newColumns count]; i++)
                                {
                                    if (i > 0)
                                        [alterClause appendString:@","];
                                    [alterClause appendFormat:@" %@ ", [newColumns objectAtIndex:i]];
                                    int varType = [(NSNumber *)[dictionaryOfColumnsAndTypes objectForKey:[newColumns objectAtIndex:i]] intValue];
                                    if (varType == 0)
                                        [alterClause appendString:@"integer"];
                                    else if (varType == 1)
                                        [alterClause appendString:@"real"];
                                    else
                                        [alterClause appendString:@"text"];
                                }
                                const char *sql_stmt = [alterClause UTF8String];
                                char *secondErrMsg;
                                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &secondErrMsg) != SQLITE_OK)
                                {
                                    NSLog(@"Failed to alter table: %s :::: %@", secondErrMsg, alterTableStatement);
                                    [EpiInfoLogManager addToErrorLog:[NSString stringWithFormat:@"%@:: SUBMIT: Failed to alter table: %s :::: %@\n", [NSDate date], secondErrMsg, alterTableStatement]];
                                }
                                else
                                {
                                    [EpiInfoLogManager addToActivityLog:[NSString stringWithFormat:@"%@:: SUBMIT: %@ table altered\n", [NSDate date], [typeFormName text]]];
                                }
                            }
                        }
                        sqlite3_finalize(statement);
                    }
                    sqlite3_close(epiinfoDB);
                }
            }
        }
    }
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
    if ([elementName isEqualToString:@"Field"])
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
            createTableStatement = [NSString stringWithFormat:@"create table %@(GlobalRecordID text", [typeFormName text]];
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
