//
//  EnterDataView.m
//  EpiInfo
//
//  Created by John Copeland on 12/19/13.
//

#import "EnterDataView.h"
//#import "QSEpiInfoService.h"
#import "DataEntryViewController.h"
#import "CheckCodeParser.h"
#import "ElementPairsCheck.h"
#import "ConditionsModel.h"
#import "ElementsModel.h"
#import "DialogModel.h"


#pragma mark * Private Interface


@interface EnterDataView ()

// Private properties
//@property (strong, nonatomic)   QSEpiInfoService   *epiinfoService;
@property (nonatomic)           BOOL            useRefreshControl;

@end


#pragma mark * Implementation


@implementation EnterDataView
@synthesize url = _url;
//@synthesize epiinfoService = _epiinfoService;
@synthesize locationManager = _locationManager;
@synthesize latitudeField = _latitudeField;
@synthesize longitudeField = _longitudeField;
@synthesize nameOfTheForm = _nameOfTheForm;
@synthesize dictionaryOfFields = _dictionaryOfFields;
@synthesize keywordsArray;
@synthesize dialogArray;
@synthesize dialogListArray;
@synthesize dialogTitleArray;
@synthesize elementsArray;
@synthesize elementListArray;
@synthesize conditionsArray;
@synthesize afterString;
@synthesize  requiredArray;
@synthesize elmArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // Create the todoService - this creates the Mobile Service client inside the wrapped service
        //    [self setEpiinfoService:[QSEpiInfoService defaultService]];
        seenFirstGeocodeField = NO;
        legalValuesDictionaryForRVC = [[NSMutableDictionary alloc] init];
        self.dictionaryOfFields = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndNameOfTheForm:(NSString *)notf
{
    self = [self initWithFrame:frame];
    
    if (self)
    {
        [self setNameOfTheForm:notf];
        [self setUrl:url];
        
        dataText = @"";
        formName = @"";
        contentSizeHeight = 32.0;
        
        legalValuesDictionary = [[NSMutableDictionary alloc] init];
        
        [self setContentSize:CGSizeMake(320, 506)];
        
        formCanvas = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [formCanvas setBackgroundColor:[UIColor whiteColor]];
        
        [self addSubview:formCanvas];
        [self setScrollEnabled:YES];
        //self.contentSize = formCanvas.frame.size;
        
        xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:self.url];
        [xmlParser setDelegate:self];
        [xmlParser setShouldResolveExternalEntities:YES];
        
        xmlParser1 = [[NSXMLParser alloc] initWithContentsOfURL:self.url];
        [xmlParser1 setDelegate:self];
        [xmlParser1 setShouldResolveExternalEntities:YES];
        keywordsArray = [[NSMutableArray alloc]initWithObjects:@"enable",@"disable",@"highlight",@"unhighlight",@"set-required",@"set-not-required",@"assign",@"autosearch",@"call",@"clear",@"define",@"dialog",@"execute",@"geocode",@"goto",@"hide",@"unhide",@"if",@"newrecord",@"quit",@"gotoform", nil];
        firstParse = YES;
        BOOL success = [xmlParser parse];
        
        if (success)
        {
            if (legalValuesArray)
            {
                [legalValuesDictionary setObject:legalValuesArray forKey:lastLegalValuesKey];
            }
        }
        
        firstParse = NO;
        beginColumList = NO;
        success = [xmlParser1 parse];
        
        createTableStatement = [createTableStatement stringByAppendingString:@")"];
        
        UIButton *submitButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 + 38.0, contentSizeHeight, 120, 40)];
        [submitButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [submitButton.layer setCornerRadius:4.0];
        [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
        [submitButton setImage:[UIImage imageNamed:@"SubmitButton.png"] forState:UIControlStateNormal];
        [submitButton.layer setMasksToBounds:YES];
        [submitButton.layer setCornerRadius:4.0];
        [submitButton addTarget:self action:@selector(confirmSubmitOrClear:) forControlEvents:UIControlEventTouchUpInside];
        [submitButton setTag:1];
        [self addSubview:submitButton];
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 158.0, contentSizeHeight, 120, 40)];
        [clearButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [clearButton.layer setCornerRadius:4.0];
        [clearButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [clearButton setImage:[UIImage imageNamed:@"ClearButton.png"] forState:UIControlStateNormal];
        [clearButton.layer setMasksToBounds:YES];
        [clearButton.layer setCornerRadius:4.0];
        [clearButton addTarget:self action:@selector(confirmSubmitOrClear:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton setTag:9];
        [self addSubview:clearButton];
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 - 36.0, contentSizeHeight, 72, 40)];
        [deleteButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        [deleteButton.layer setCornerRadius:4.0];
        [deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"DeleteButton.png"] forState:UIControlStateNormal];
        [deleteButton.layer setMasksToBounds:YES];
        [deleteButton.layer setCornerRadius:4.0];
        [deleteButton addTarget:self action:@selector(confirmSubmitOrClear:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setTag:7];
        [deleteButton setHidden:YES];
        [self addSubview:deleteButton];
        contentSizeHeight += 60.0;
        
        if (contentSizeHeight > 506)
        {
            [formCanvas setFrame:CGRectMake(0, 0, frame.size.width, contentSizeHeight)];
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                contentSizeHeight += 280.0;
            
            [self setContentSize:CGSizeMake(frame.size.width, contentSizeHeight)];
        }
        
        UIButton *resignAllButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, formCanvas.frame.size.width, formCanvas.frame.size.height)];
        [resignAllButton setBackgroundColor:[UIColor clearColor]];
        [resignAllButton addTarget:self action:@selector(resignAll) forControlEvents:UIControlEventTouchUpInside];
        [formCanvas addSubview:resignAllButton];
        [formCanvas sendSubviewToBack:resignAllButton];
        
        UILabel *disclaimer = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
        [disclaimer setBackgroundColor:[UIColor colorWithRed:0/255.0 green:128/255.0 blue:128/255.0 alpha:1.0]];
        [disclaimer setTextColor:[UIColor whiteColor]];
        [disclaimer setNumberOfLines:0];
        [disclaimer setLineBreakMode:NSLineBreakByWordWrapping];
        [disclaimer.layer setCornerRadius:4.0];
        [disclaimer setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [disclaimer setText:@"This feature is still under development. Touch this message to dismiss the form and return to the previous screen."];
        UIButton *dismissFormButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 300, 100)];
        [dismissFormButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
        [dismissFormButton setBackgroundColor:[UIColor clearColor]];
        //        [self addSubview:disclaimer];
        //        [self addSubview:dismissFormButton];
        
        //        [formCanvas setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhoneDataEntryBackground.png"]]];
        [formCanvas setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndNameOfTheForm:(NSString *)notf
{
    self = [self initWithFrame:frame AndURL:url AndNameOfTheForm:(NSString *)notf];
    if (self)
    {
        [self setRootViewController:rvc];
        if ([[(DataEntryViewController *)self.rootViewController backgroundImage] tag] == 4)
        {
            [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height + 80.0)];
        }
        [(DataEntryViewController *)self.rootViewController setLegalValuesDictionary:legalValuesDictionaryForRVC];
        // Hide the Back button on the nav controller
        //        [self.rootViewController.navigationItem setHidesBackButton:YES animated:YES];
        [self.rootViewController.navigationItem.leftBarButtonItem setEnabled:NO];
        
        hasAFirstResponder = NO;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
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
                NSLog(@"Failed to find Clouds table");
                return self;
            }
            else
            {
                tableAlreadyExists = 0;
                if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                {
                    NSString *selStmt = [NSString stringWithFormat:@"select count(*) as n from Clouds where FormName = '%@'", self.formName];
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
                    return self;
                else
                {
                    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
                    {
                        NSString *selStmt = [NSString stringWithFormat:@"select * from Clouds where FormName = '%@'", self.formName];
                        const char *query_stmt = [selStmt UTF8String];
                        sqlite3_stmt *statement;
                        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                        {
                            if (sqlite3_step(statement) == SQLITE_ROW)
                            {
                                if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)] isEqualToString:@"MSAzure"])
                                {
                                    //                  self.epiinfoService = [[QSEpiInfoService alloc] initWithURL:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)] AndKey:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]];
                                    //                  [self.epiinfoService setApplicationURL:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]];
                                    //                  [self.epiinfoService setApplicationKey:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]];
                                    //                  [self.epiinfoService setTableName:formName];
                                }
                                else
                                {
                                    //                  [self.epiinfoService setApplicationURL:nil];
                                    //                  [self.epiinfoService setApplicationKey:nil];
                                    //                  self.epiinfoService = [[QSEpiInfoService alloc] initWithURL:nil AndKey:nil];
                                    //                  [self.epiinfoService setTableName:formName];
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
    [self setLabelReq];
    /*CHECK for on load dialogs*/
    if (firstEdit == FALSE) {
        //NSLog(@"false");
        pageName = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"pageName"];
        
        [self checkDialogs:[pageName lowercaseString] Tag:1 type:1 from:@"before" from:@"page"];
        firstEdit = TRUE;
    }
    [self registerForKeyboardNotifications];
    [self gotoField:@"before" element:[pageName lowercaseString]];
    
    return self;
}
-(void)viewDidLoad
{
    elementsArray = [[NSMutableArray alloc]init];
    conditionsArray = [[NSMutableArray alloc]init];
    dialogArray = [[NSMutableArray alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"appear");
    
}

- (void)getMyLocation
{
    // Get coordinates
    if (!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    [self.locationManager setDistanceFilter:kCLDistanceFilterNone];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //    [self.locationManager startUpdatingLocation];
    //    [self.locationManager startMonitoringSignificantLocationChanges];
    self.updateLocationThread = [[NSThread alloc] initWithTarget:self selector:@selector(updateMyLocation) object:nil];
    [self.updateLocationThread start];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    float lat = [(CLLocation *)[locations objectAtIndex:[locations count] - 1] coordinate].latitude;
    float lon = [(CLLocation *)[locations objectAtIndex:[locations count] - 1] coordinate].longitude;
    NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
    [nsnf setMaximumFractionDigits:6];
    
    for (UIView *v in [formCanvas subviews])
        if ([v isKindOfClass:[NumberField class]])
        {
            if ([[(NumberField *)v columnName] isEqualToString:self.latitudeField])
                [(NumberField *)v setText:[nsnf stringFromNumber:[NSNumber numberWithFloat:lat]]];
            if ([[(NumberField *)v columnName] isEqualToString:self.longitudeField])
                [(NumberField *)v setText:[nsnf stringFromNumber:[NSNumber numberWithFloat:lon]]];
        }
    [self.locationManager stopUpdatingLocation];
}

- (void)updateMyLocation
{
    // Get coordinates
    [self.locationManager requestWhenInUseAuthorization];
    
    while (YES)
    {
        if ([[NSThread currentThread] isCancelled])
            [NSThread exit];
        if (geocodingCheckbox.value && [CLLocationManager locationServicesEnabled])
        {
            [self.locationManager startUpdatingLocation];
        }
        sleep(10);
    }
}

- (NSString *)formName
{
    return formName;
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied) {
        //you had denied
    }
    [manager stopUpdatingLocation];
}

#pragma mark Submit

- (void)submitButtonPressed
{
    BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(self.superview.frame.size.width - 5.0, self.superview.frame.size.height - 5.0, 10, 10)];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setNumberOfLines:0];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [bv addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [bv addSubview:uiaiv];
    
    //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Yes" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [okButton.layer setMasksToBounds:YES];
    [okButton.layer setCornerRadius:4.0];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bv addSubview:okButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        //        if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
        //        {
        //            [[NSFileManager defaultManager] removeItemAtPath:databasePath error:nil];
        //        }
        
        NSString *insertStatement = [NSString stringWithFormat:@"\ninsert into %@(GlobalRecordID", formName];
        //        NSString *valuesClause = @" values(";
        NSString *recordUUID = CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
        NSString *valuesClause = [NSString stringWithFormat:@" values('%@'", recordUUID];
        BOOL valuesClauseBegun = YES;
        NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
        [azureDictionary setObject:recordUUID forKey:@"id"];
        for (UIView *v in [formCanvas subviews])
        {
            if ([v isKindOfClass:[Checkbox class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(Checkbox *)v columnName]];
                valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%d", [(Checkbox *)v value]]];
                [azureDictionary setObject:[NSNumber numberWithBool:[(Checkbox *)v value]] forKey:[(Checkbox *)v columnName]];
            }
            else if ([v isKindOfClass:[YesNo class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(YesNo *)v columnName]];
                valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", [(YesNo *)v picked]]];
                if ([[(YesNo *)v picked] length] == 1)
                    [azureDictionary setObject:[NSNumber numberWithInt:[[(YesNo *)v picked] intValue]] forKey:[(YesNo *)v columnName]];
            }
            else if ([v isKindOfClass:[LegalValuesEnter class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(LegalValuesEnter *)v columnName]];
                if ([[(LegalValuesEnter *)v picked] isEqualToString:@"NULL"])
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                }
                else
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(LegalValuesEnter *)v picked]]];
                    [azureDictionary setObject:[NSNumber numberWithFloat:(float)[(LegalValuesEnter *)v selectedIndex].intValue] forKey:[(LegalValuesEnter *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[NumberField class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(NumberField *)v columnName]];
                valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", [(NumberField *)v value]]];
                if (![[(NumberField *)v value] isEqualToString:@"NULL"])
                {
                    [azureDictionary setObject:[NSNumber numberWithFloat:[[(NumberField *)v value] floatValue]] forKey:[(NumberField *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[PhoneNumberField class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(PhoneNumberField *)v columnName]];
                if ([[(PhoneNumberField *)v value] isEqualToString:@"NULL"])
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                }
                else
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(PhoneNumberField *)v value]]];
                    [azureDictionary setObject:[(PhoneNumberField *)v value] forKey:[(PhoneNumberField *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[DateField class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(DateField *)v columnName]];
                if ([[(DateField *)v text] length] == 0)
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                }
                else
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(DateField *)v text]]];
                    [azureDictionary setObject:[(DateField *)v text] forKey:[(DateField *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[EpiInfoTextView class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextView *)v columnName]];
                if ([[(EpiInfoTextView *)v text] length] == 0)
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                }
                else
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(EpiInfoTextView *)v text]]];
                    [azureDictionary setObject:[(EpiInfoTextView *)v text] forKey:[(EpiInfoTextView *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[EpiInfoTextField class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextField *)v columnName]];
                if ([[(EpiInfoTextField *)v text] length] == 0)
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                }
                else
                {
                    valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(EpiInfoTextField *)v text]]];
                    [azureDictionary setObject:[(EpiInfoTextField *)v text] forKey:[(EpiInfoTextField *)v columnName]];
                }
            }
        }
        insertStatement = [insertStatement stringByAppendingString:@")"];
        valuesClause = [valuesClause stringByAppendingString:@")"];
        insertStatement = [insertStatement stringByAppendingString:valuesClause];
        [azureDictionary setObject:@NO forKey:@"complete"];
        //        for (id key in azureDictionary)
        //        {
        //            NSLog(@"%@ :: %@", key, [azureDictionary objectForKey:key]);
        //        }
        //        NSLog(@"%@", createTableStatement);
        //        NSLog(@"%@", insertStatement);
        
        //Create the new table if necessary
        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
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
                const char *sql_stmt = [createTableStatement UTF8String];
                //                const char *sql_stmt = [@"drop table FoodHistory" UTF8String];
                
                //Execute the CREATE TABLE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create table: %s :::: %@", errMsg, createTableStatement);
                }
                else
                {
                    //                    NSLog(@"Table created");
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
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
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
                //Build the INSERT statement
                //Convert the sqlStmt to char array
                const char *sql_stmt = [insertStatement UTF8String];
                //                const char *sql_stmt = [@"delete from FoodHistory where caseid is null" UTF8String];
                //                const char *sql_stmt = [@"update FoodHistory set DOB = '04/23/1978' where DOB = '04/33/1978'" UTF8String];
                
                //Execute the INSERT statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    if ([[NSString stringWithUTF8String:errMsg] rangeOfString:@"has no column named"].location != NSNotFound)
                    {
                        NSString *newColumn = [[NSString stringWithUTF8String:errMsg] substringFromIndex:[[NSString stringWithUTF8String:errMsg] rangeOfString:@"has no column named"].location + 20];
                        NSString *alterTableStatement = [NSString stringWithFormat:@"alter table %@\nadd %@ %@", formName, newColumn, [alterTableElements objectForKey:newColumn]];
                        sql_stmt = [alterTableStatement UTF8String];
                        char *secondErrMsg;
                        if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &secondErrMsg) != SQLITE_OK)
                        {
                            NSLog(@"Failed to alter table: %s :::: %@", secondErrMsg, alterTableStatement);
                        }
                        else
                        {
                            [self submitButtonPressed];
                            return;
                        }
                    }
                    NSLog(@"Failed to insert row into table: %s :::: %@", errMsg, insertStatement);
                }
                else
                {
                    //                    NSLog(@"Row inserted");
                    [areYouSure setText:@"Row inserted into local database."];
                    [uiaiv setHidden:NO];
                    [uiaiv startAnimating];
                    [okButton setEnabled:NO];
                    //          NSLog(@"%@", self.epiinfoService.applicationURL);
                    //          if (self.epiinfoService.applicationURL)
                    //            [self.epiinfoService addItem:[NSDictionary dictionaryWithDictionary:azureDictionary] completion:^(NSUInteger index)
                    //             {
                    //               NSString *remoteResult = @"Row inserted into Azure cloud table.";
                    //               if ((int)index < 0)
                    //                 remoteResult = @"Could not insert row into Azure cloud table.";
                    //               [areYouSure setText:[NSString stringWithFormat:@"Row inserted into local database.\n%@", remoteResult]];
                    //               [uiaiv stopAnimating];
                    //               [uiaiv setHidden:YES];
                    //               [okButton setEnabled:YES];
                    //             }];
                    //          else
                    {
                        [uiaiv stopAnimating];
                        [uiaiv setHidden:YES];
                        [okButton setEnabled:YES];
                    }
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
        
        //        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        //        {
        //            NSString *selStmt = [NSString stringWithFormat:@"select * from %@", formName];
        //            const char *query_stmt = [selStmt UTF8String];
        ////            const char *query_stmt = "SELECT name FROM sqlite_master";
        //            sqlite3_stmt *statement;
        //            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        //            {
        //                int columnCount = sqlite3_column_count(statement);
        //                while (sqlite3_step(statement) == SQLITE_ROW)
        //                    for (int i = 0; i < columnCount; i++)
        //                        NSLog(@"%s", sqlite3_column_text(statement, i));
        //            }
        //            sqlite3_finalize(statement);
        //        }
        //        sqlite3_close(epiinfoDB);
        if ([[[NSFileManager defaultManager] attributesOfItemAtPath:databasePath error:nil] objectForKey:NSFileProtectionKey] != NSFileProtectionComplete)
            [[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey: NSFileProtectionComplete} ofItemAtPath:databasePath error:nil];
    }
    
    [self clearButtonPressed];
    
    [self.superview addSubview:bv];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [bv setFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.width)];
        [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
        [uiaiv setFrame:CGRectMake(bv.frame.size.width / 2.0 - 20.0, bv.frame.size.height / 2.0 - 60.0, 40, 40)];
        [okButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
    } completion:^(BOOL finished){
    }];
}

#pragma mark Update

- (void)updateButtonPressed
{
    BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(self.superview.frame.size.width - 5.0, self.superview.frame.size.height - 5.0, 10, 10)];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setNumberOfLines:0];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [bv addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [bv addSubview:uiaiv];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Oh Kay" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [okButton.layer setMasksToBounds:YES];
    [okButton.layer setCornerRadius:4.0];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bv addSubview:okButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        NSString *insertStatement = [NSString stringWithFormat:@"\nupdate %@\nset ", formName];
        
        NSString *recordUUID = [NSString stringWithString:recordUIDForUpdate];
        NSString *valuesClause = [NSString stringWithFormat:@" values('%@'", recordUUID];
        BOOL valuesClauseBegun = NO;
        NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
        [azureDictionary setObject:recordUUID forKey:@"id"];
        for (UIView *v in [formCanvas subviews])
        {
            if ([v isKindOfClass:[Checkbox class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(Checkbox *)v columnName]];
                insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %d", [(Checkbox *)v value]]];
                [azureDictionary setObject:[NSNumber numberWithBool:[(Checkbox *)v value]] forKey:[(Checkbox *)v columnName]];
            }
            else if ([v isKindOfClass:[YesNo class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(YesNo *)v columnName]];
                insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", [(YesNo *)v picked]]];
                if ([[(YesNo *)v picked] length] == 1)
                    [azureDictionary setObject:[NSNumber numberWithInt:[[(YesNo *)v picked] intValue]] forKey:[(YesNo *)v columnName]];
            }
            else if ([v isKindOfClass:[LegalValuesEnter class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(LegalValuesEnter *)v columnName]];
                if ([[(LegalValuesEnter *)v picked] isEqualToString:@"NULL"])
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                }
                else
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(LegalValuesEnter *)v picked]]];
                    [azureDictionary setObject:[NSNumber numberWithFloat:(float)[(LegalValuesEnter *)v selectedIndex].intValue] forKey:[(LegalValuesEnter *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[NumberField class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(NumberField *)v columnName]];
                insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", [(NumberField *)v value]]];
                if (![[(NumberField *)v value] isEqualToString:@"NULL"])
                {
                    [azureDictionary setObject:[NSNumber numberWithFloat:[[(NumberField *)v value] floatValue]] forKey:[(NumberField *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[PhoneNumberField class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(PhoneNumberField *)v columnName]];
                if ([[(PhoneNumberField *)v value] isEqualToString:@"NULL"])
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                }
                else
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(PhoneNumberField *)v value]]];
                    [azureDictionary setObject:[(PhoneNumberField *)v value] forKey:[(PhoneNumberField *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[DateField class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(DateField *)v columnName]];
                if ([[(DateField *)v text] length] == 0)
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                }
                else
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(DateField *)v text]]];
                    [azureDictionary setObject:[(DateField *)v text] forKey:[(DateField *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[EpiInfoTextView class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextView *)v columnName]];
                if ([[(EpiInfoTextView *)v text] length] == 0)
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                }
                else
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(EpiInfoTextView *)v text]]];
                    [azureDictionary setObject:[(EpiInfoTextView *)v text] forKey:[(EpiInfoTextView *)v columnName]];
                }
            }
            else if ([v isKindOfClass:[EpiInfoTextField class]])
            {
                if (valuesClauseBegun)
                {
                    insertStatement = [insertStatement stringByAppendingString:@",\n"];
                    valuesClause = [valuesClause stringByAppendingString:@",\n"];
                }
                valuesClauseBegun = YES;
                insertStatement = [insertStatement stringByAppendingString:[(EpiInfoTextField *)v columnName]];
                if ([[(EpiInfoTextField *)v text] length] == 0)
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                }
                else
                {
                    insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(EpiInfoTextField *)v text]]];
                    [azureDictionary setObject:[(EpiInfoTextField *)v text] forKey:[(EpiInfoTextField *)v columnName]];
                }
            }
        }
        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@"\nwhere GlobalRecordID = '%@'", recordUIDForUpdate]];
        
        [azureDictionary setObject:@NO forKey:@"complete"];
        
        //Create the new table if necessary
        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
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
                const char *sql_stmt = [createTableStatement UTF8String];
                //                const char *sql_stmt = [@"drop table FoodHistory" UTF8String];
                
                //Execute the CREATE TABLE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to create table: %s :::: %@", errMsg, createTableStatement);
                }
                else
                {
                    //                    NSLog(@"Table created");
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open/create database");
            }
        }
        
        // Update the row
        tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
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
                //Build the CREATE TABLE statement
                //Convert the sqlStmt to char array
                const char *sql_stmt = [insertStatement UTF8String];
                
                //Execute the UPDATE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    if ([[NSString stringWithUTF8String:errMsg] rangeOfString:@"has no column named"].location != NSNotFound)
                    {
                        NSString *newColumn = [[NSString stringWithUTF8String:errMsg] substringFromIndex:[[NSString stringWithUTF8String:errMsg] rangeOfString:@"has no column named"].location + 20];
                        NSString *alterTableStatement = [NSString stringWithFormat:@"alter table %@\nadd %@ %@", formName, newColumn, [alterTableElements objectForKey:newColumn]];
                        sql_stmt = [alterTableStatement UTF8String];
                        char *secondErrMsg;
                        if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &secondErrMsg) != SQLITE_OK)
                        {
                            NSLog(@"Failed to alter table: %s :::: %@", secondErrMsg, alterTableStatement);
                        }
                        else
                        {
                            [self updateButtonPressed];
                            return;
                        }
                    }
                    NSLog(@"Failed to insert row into table: %s :::: %@", errMsg, insertStatement);
                }
                else
                {
                    //                    NSLog(@"Row inserted");
                    [areYouSure setText:@"Local database row updated."];
                    [uiaiv setHidden:NO];
                    [uiaiv startAnimating];
                    [okButton setEnabled:NO];
                    //          if (self.epiinfoService.applicationURL)
                    //          {
                    //            [self.epiinfoService addItem:[NSDictionary dictionaryWithDictionary:azureDictionary] completion:^(NSUInteger index)
                    //             {
                    //               NSString *remoteResult = @"Azure cloud table row updated.";
                    //               if ((int)index < 0)
                    //                 remoteResult = @"Could not update Azure cloud table.";
                    //               [areYouSure setText:[NSString stringWithFormat:@"Row inserted into local database.\n%@", remoteResult]];
                    //               [uiaiv stopAnimating];
                    //               [uiaiv setHidden:YES];
                    //               [okButton setEnabled:YES];
                    //             }];
                    //          }
                    //          else
                    {
                        [uiaiv stopAnimating];
                        [uiaiv setHidden:YES];
                        [okButton setEnabled:YES];
                    }
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
    
    [self clearButtonPressed];
    
    [self.superview addSubview:bv];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [bv setFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.width)];
        [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
        [uiaiv setFrame:CGRectMake(bv.frame.size.width / 2.0 - 20.0, bv.frame.size.height / 2.0 - 60.0, 40, 40)];
        [okButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
    } completion:^(BOOL finished){
    }];
}

#pragma mark Delete

- (void)deleteButtonPressed
{
    BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(self.superview.frame.size.width - 5.0, self.superview.frame.size.height - 5.0, 10, 10)];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setNumberOfLines:0];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [bv addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [bv addSubview:uiaiv];
    
    UIButton *okButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [okButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Oh Kay" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [okButton.layer setMasksToBounds:YES];
    [okButton.layer setCornerRadius:4.0];
    [okButton addTarget:self action:@selector(okButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [bv addSubview:okButton];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        NSString *insertStatement = [NSString stringWithFormat:@"\ndelete from %@", formName];
        
        NSString *recordUUID = [NSString stringWithString:recordUIDForUpdate];
        
        NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
        [azureDictionary setObject:recordUUID forKey:@"id"];
        
        insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@"\nwhere GlobalRecordID = '%@'", recordUIDForUpdate]];
        
        [azureDictionary setObject:@NO forKey:@"complete"];
        
        // Delete the row
        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", formName];
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
                //Build the DELETE FROM TABLE statement
                //Convert the sqlStmt to char array
                const char *sql_stmt = [insertStatement UTF8String];
                
                //Execute the UPDATE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to delete row from table: %s :::: %@", errMsg, insertStatement);
                }
                else
                {
                    [areYouSure setText:@"Local database row deleted."];
                    [uiaiv setHidden:NO];
                    [uiaiv startAnimating];
                    [okButton setEnabled:NO];
                    //          if (self.epiinfoService.applicationURL)
                    //          {
                    //            [self.epiinfoService deleteItem:[NSDictionary dictionaryWithDictionary:azureDictionary] completion:^(NSUInteger index)
                    //             {
                    //               NSString *remoteResult = @"Row delete from Azure cloud table.";
                    //               if ((int)index < 0)
                    //                 remoteResult = @"Could not delete row from Azure cloud table.";
                    //               [areYouSure setText:[NSString stringWithFormat:@"Row delete from local database.\n%@", remoteResult]];
                    //               [uiaiv stopAnimating];
                    //               [uiaiv setHidden:YES];
                    //               [okButton setEnabled:YES];
                    //             }];
                    //          }
                    //          else
                    {
                        [uiaiv stopAnimating];
                        [uiaiv setHidden:YES];
                        [okButton setEnabled:YES];
                    }
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open database or delete record");
            }
        }
        else
        {
            NSLog(@"Could not find table");
        }
    }
    
    [self clearButtonPressed];
    
    [self.superview addSubview:bv];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [bv setFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.width)];
        [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
        [uiaiv setFrame:CGRectMake(bv.frame.size.width / 2.0 - 20.0, bv.frame.size.height / 2.0 - 60.0, 40, 40)];
        [okButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
    } completion:^(BOOL finished){
    }];
}

- (void)confirmSubmitOrClear:(UIButton *)sender
{
    /* if (formCanvas.isViewLoaded && formCanvas.view.window){
     // viewController is visible
     }*/
    
    [self resignAll];
    
    /*FOR CLEAR*/
    if (sender.tag == 9 || sender.tag == 7) {
        BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, self.superview.frame.size.height - (formCanvas.frame.size.height - sender.frame.origin.y), sender.frame.size.width, sender.frame.size.height)];
        
        UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bv.frame.size.width - 20, 36)];
        [areYouSure setBackgroundColor:[UIColor clearColor]];
        [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
        if (sender.tag == 9)
            [areYouSure setText:@"Clear all fields without submitting?"];
        else if (sender.tag == 8)
            [areYouSure setText:@"Update this record?"];
        else if (sender.tag == 7)
            [areYouSure setText:@"Delete this record?"];
        else
            [areYouSure setText:@"Submit this record?"];
        [areYouSure setNumberOfLines:0];
        [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
        [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
        [areYouSure setTextAlignment:NSTextAlignmentCenter];
        [bv addSubview:areYouSure];
        
        //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
        UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        [yesButton setImage:[UIImage imageNamed:@"YesButton.png"] forState:UIControlStateNormal];
        [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
        [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [yesButton.layer setMasksToBounds:YES];
        [yesButton.layer setCornerRadius:4.0];
        if (sender.tag == 9)
            [yesButton addTarget:self action:@selector(clearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        else if (sender.tag == 8)
            [yesButton addTarget:self action:@selector(updateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        else if (sender.tag == 7)
            [yesButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        else
            [yesButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [bv addSubview:yesButton];
        
        //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
        UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
        [noButton setImage:[UIImage imageNamed:@"NoButton.png"] forState:UIControlStateNormal];
        [noButton setTitle:@"No" forState:UIControlStateNormal];
        [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        [noButton.layer setMasksToBounds:YES];
        [noButton.layer setCornerRadius:4.0];
        [noButton addTarget:self action:@selector(doNotSubmitOrClear) forControlEvents:UIControlEventTouchUpInside];
        [bv addSubview:noButton];
        
        [self.superview addSubview:bv];
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [bv setFrame:CGRectMake(0, self.frame.size.height - self.frame.size.width, self.frame.size.width, self.frame.size.width)];
            [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
            [yesButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
            [noButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 + 22.0, 120, 40)];
        } completion:^(BOOL finished){
        }];
    }
    
    /*FOR SUBMIT*/
    else
    {
        
        if ([self onSubmitRequiredFrom:@"if"])
        {

            [self checkDialogs:[pageName lowercaseString] Tag:1 type:1 from:@"after" from:@"page"];
            
            BlurryView *bv = [[BlurryView alloc] initWithFrame:CGRectMake(sender.frame.origin.x, self.superview.frame.size.height - (formCanvas.frame.size.height - sender.frame.origin.y), sender.frame.size.width, sender.frame.size.height)];
            
            UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bv.frame.size.width - 20, 36)];
            [areYouSure setBackgroundColor:[UIColor clearColor]];
            [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            if (sender.tag == 9)
                [areYouSure setText:@"Clear all fields without submitting?"];
            else if (sender.tag == 8)
                [areYouSure setText:@"Update this record?"];
            else if (sender.tag == 7)
                [areYouSure setText:@"Delete this record?"];
            else
                [areYouSure setText:@"Submit this record?"];
            [areYouSure setNumberOfLines:0];
            [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
            [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
            [areYouSure setTextAlignment:NSTextAlignmentCenter];
            [bv addSubview:areYouSure];
            
            //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
            UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
            [yesButton setImage:[UIImage imageNamed:@"YesButton.png"] forState:UIControlStateNormal];
            [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
            [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [yesButton.layer setMasksToBounds:YES];
            [yesButton.layer setCornerRadius:4.0];
            if (sender.tag == 9)
                [yesButton addTarget:self action:@selector(clearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            else if (sender.tag == 8)
                [yesButton addTarget:self action:@selector(updateButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            else if (sender.tag == 7)
                [yesButton addTarget:self action:@selector(deleteButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            else
                [yesButton addTarget:self action:@selector(submitButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [bv addSubview:yesButton];
            
            //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
            UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
            [noButton setImage:[UIImage imageNamed:@"NoButton.png"] forState:UIControlStateNormal];
            [noButton setTitle:@"No" forState:UIControlStateNormal];
            [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [noButton.layer setMasksToBounds:YES];
            [noButton.layer setCornerRadius:4.0];
            [noButton addTarget:self action:@selector(doNotSubmitOrClear) forControlEvents:UIControlEventTouchUpInside];
            [bv addSubview:noButton];
            
            [self.superview addSubview:bv];
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [bv setFrame:CGRectMake(0, self.frame.size.height - self.frame.size.width, self.frame.size.width, self.frame.size.width)];
                [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
                [yesButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
                [noButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 + 22.0, 120, 40)];
            } completion:^(BOOL finished){
            }];
        }
        // }
        
        else
        {
            [self onSubmitRequiredFrom:@"else"];
        }
    }
}
- (void)doNotSubmitOrClear
{
    for (UIView *v in [self.superview subviews])
        if ([v isKindOfClass:[BlurryView class]])
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [v setFrame:CGRectMake(0, self.superview.frame.size.height, v.frame.size.width, v.frame.size.width)];
            } completion:^(BOOL finished){
                [v removeFromSuperview];
            }];
        }
}
- (void)clearButtonPressed
{
    for (id v in [formCanvas subviews])
    {
        if ([v isKindOfClass:[UITextField class]])
            [(UITextField *)v setText:nil];
        else if ([v isKindOfClass:[UITextView class]])
            [(UITextView *)v setText:nil];
        else if ([v isKindOfClass:[YesNo class]])
            [(YesNo *)v reset];
        else if ([v isKindOfClass:[LegalValuesEnter class]])
            [(LegalValuesEnter *)v reset];
        else if ([v isKindOfClass:[Checkbox class]])
            [(Checkbox *)v reset];
        [v setEnabled:YES];
    }
    [self resignAll];
    [self setContentOffset:CGPointZero animated:YES];
    [self doNotSubmitOrClear];
    //    [self.locationManager stopUpdatingLocation];
    //    [self getMyLocation];
    for (UIView *v in [self subviews])
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            if ([(UIButton *)v tag] == 8)
            {
                [(UIButton *)v setTag:1];
                [(UIButton *)v setImage:[UIImage imageNamed:@"SubmitButton.png"] forState:UIControlStateNormal];
            }
            if ([(UIButton *)v tag] == 7)
            {
                [(UIButton *)v setHidden:YES];
            }
        }
    }
}
- (void)okButtonPressed
{
    for (UIView *v in [self.superview subviews])
        if ([v isKindOfClass:[BlurryView class]])
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                [v setFrame:CGRectMake(0, -v.frame.size.height, v.frame.size.width, v.frame.size.width)];
            } completion:^(BOOL finished){
                [v removeFromSuperview];
            }];
        }
}

#pragma mark ResignAll

- (void)resignAll
{
    for (id v in [formCanvas subviews])
    {
        if ([v isKindOfClass:[UITextField class]] && [v isFirstResponder])
        {
            [(UITextField *)v resignFirstResponder];
            //      [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            //        [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
            //          NSLog(@"resignall HEIGHT-----%f",self.contentSize.height);
            //
            //      } completion:^(BOOL finished){
            //        hasAFirstResponder = NO;
            //      }];
        }
        else if ([v isKindOfClass:[UITextView class]] && [v isFirstResponder])
        {
            [(UITextView *)v resignFirstResponder];
            //      [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            //        [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
            //      } completion:^(BOOL finished){
            //        hasAFirstResponder = NO;
            //      }];
        }
    }
}

- (void)dismissForm;
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        [(DataEntryViewController *)self.rootViewController setLegalValuesDictionary:nil];
        // Return the Back button to the nav controller
        [self.rootViewController.navigationItem setHidesBackButton:NO animated:YES];
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [self.rootViewController.view.layer setTransform:rotate];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
            [self.rootViewController.view.layer setTransform:rotate];
        } completion:^(BOOL finished){
        }];
    }];
}
#pragma mark XmlParser

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    ElementsModel *epc = [[ElementsModel alloc]init];
    if(elementListArray.count<1)
    {
        elementListArray = [[NSMutableArray alloc]init];
        elmArray = [[NSMutableArray alloc]init];
        requiredArray = [[NSMutableArray alloc]init];
        require = 0;
        valid = 0;
    }
    NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
    [nsnf setMaximumFractionDigits:6];
    
    dataText = [dataText stringByAppendingString:[NSString stringWithFormat:@"\n%@", elementName]];
    
    if (firstParse)
    {
        //        int pageNo = 0;
        if ([elementName isEqualToString:@"Page"])
        {
            pageName = [attributeDict objectForKey:@"Name"];
            [[NSUserDefaults standardUserDefaults] setObject:pageName forKey:@"pageName"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            firstEdit = FALSE;
            
            //            NSLog(@"Page %@", [attributeDict objectForKey:@"PageId"]);
            //            pageNo = [[attributeDict objectForKey:@"PageId"] intValue];
            if (!self.pagesArray)
            {
                self.pagesArray = [[NSMutableArray alloc] init];
                self.pageIDs = [[NSMutableArray alloc] init];
                self.checkboxes = [[NSMutableDictionary alloc] init];
            }
            [[self pagesArray] addObject:[[NSMutableArray alloc] init]];
            [[self pageIDs] addObject:[attributeDict objectForKey:@"PageId"]];
            
            //            NSLog(@"%d", [[self pagesArray] count]);
        }
        if ([elementName isEqualToString:@"Field"] && [[attributeDict objectForKey:@"FieldTypeId"] intValue] < 26 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 2 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 13 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 15 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 20 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 21 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 22 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 23 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 24 &&
            [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 16)
        {
            //            NSLog(@"\t%@", [attributeDict objectForKey:@"Name"]);
            [(NSMutableArray *)[[self pagesArray] objectAtIndex:self.pagesArray.count - 1] addObject:[attributeDict objectForKey:@"Name"]];
        }
        if ([elementName isEqualToString:@"SourceTable"])
        {
            if (legalValuesArray)
            {
                [legalValuesDictionary setObject:legalValuesArray forKey:lastLegalValuesKey];
            }
            legalValuesArray = [[NSMutableArray alloc] init];
            [legalValuesArray addObject:@""];
            lastLegalValuesKey = [attributeDict objectForKey:@"TableName"];
        }
        if ([elementName isEqualToString:@"Item"])
        {
            if (legalValuesArray)
                for (id key in attributeDict)
                    [legalValuesArray addObject:[attributeDict objectForKey:key]];
        }
    }
    
    else
    {
        NSString *commaOrParen;
        if ([elementName isEqualToString:@"View"])
        {
            //            formName = [attributeDict objectForKey:@"Name"];
            formName = self.nameOfTheForm;
            // Tell the Azure service the table name.
            //      [self.epiinfoService setTableName:formName];
            
            createTableStatement = [NSString stringWithFormat:@"create table %@(GlobalRecordID text", formName];
            alterTableElements = [[NSMutableDictionary alloc] init];
            beginColumList = NO;
            
            if ([attributeDict objectForKey:@"CheckCode"])
            {
                ccp = [[CheckCodeParser alloc]init];
                NSString *checkCodeString = [attributeDict objectForKey:@"CheckCode"];
                ccp.edv = self;
                NSString *valueToSave = checkCodeString;
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"checkcode"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [ccp parseCheckCode:checkCodeString];
                
                
                int geocodePosition = (int)[[checkCodeString stringByReplacingOccurrencesOfString:@"The GEOCODE command requires an active Internet connection" withString:@""] rangeOfString:@"GEOCODE"].location;
                if (geocodePosition >= 0 && geocodePosition < [checkCodeString stringByReplacingOccurrencesOfString:@"The GEOCODE command requires an active Internet connection" withString:@""].length)
                {
                    NSString *geocodeString = [[checkCodeString stringByReplacingOccurrencesOfString:@"The GEOCODE command requires an active Internet connection" withString:@""] substringFromIndex:geocodePosition];
                    int commaPosition = (int)[geocodeString rangeOfString:@","].location;
                    geocodeString = [geocodeString substringFromIndex:commaPosition + 1];
                    commaPosition = (int)[geocodeString rangeOfString:@","].location;
                    [self setLatitudeField:[[geocodeString substringToIndex:commaPosition] stringByReplacingOccurrencesOfString:@" " withString:@""]];
                    geocodeString = [geocodeString substringFromIndex:commaPosition + 1];
                    commaPosition = (int)[geocodeString rangeOfString:@"End-Click"].location;
                    [self setLongitudeField:[[[[geocodeString substringToIndex:commaPosition] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
                }
                /* while ((int)[checkCodeString rangeOfString:@"//"].location >= 0 && (int)[checkCodeString rangeOfString:@"//"].location < checkCodeString.length)
                 {
                 NSRange slashrange = [checkCodeString rangeOfString:@"//"];
                 NSRange crrange = [[checkCodeString substringFromIndex:(int)slashrange.location] rangeOfString:@"\n"];
                 NSRange range = NSMakeRange(slashrange.location, crrange.location + crrange.length);
                 checkCodeString = [checkCodeString stringByReplacingCharactersInRange:range withString:@""];
                 }
                 self.dictionaryOfWordsArrays = [[NSMutableDictionary alloc] init];
                 while ((int)[checkCodeString rangeOfString:@"Field "].location >= 0 && (int)[checkCodeString rangeOfString:@"Field "].location < checkCodeString.length)
                 {
                 NSRange fieldrange = [checkCodeString rangeOfString:@"Field "];
                 NSRange endfieldrange = [checkCodeString rangeOfString:@"End-Field"];
                 //          NSLog(@"\n%@", [[checkCodeString substringToIndex:endfieldrange.location] substringFromIndex:fieldrange.location + fieldrange.length]);
                 NSArray *wordsArray = [[[[checkCodeString substringToIndex:endfieldrange.location] substringFromIndex:fieldrange.location + fieldrange.length] stringByReplacingOccurrencesOfString:@"\t" withString:@""] componentsSeparatedByString:@"\n"];
                 //          NSLog(@"%@", wordsArray);
                 [self.dictionaryOfWordsArrays setObject:wordsArray forKey:(NSString *)[wordsArray objectAtIndex:0]];
                 checkCodeString = [checkCodeString substringFromIndex:endfieldrange.location + endfieldrange.length];
                 }*/
                NSMutableArray *eleTemArray = [[NSMutableArray alloc]init];
                eleTemArray=[ccp sendArray];
                [self copyToArray:eleTemArray];
            }
        }
        if ([elementName isEqualToString:@"Field"])
        {
            if ([[attributeDict objectForKey:@"FieldTypeId"] intValue] < 26 &&
                [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 2 &&
                [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 13 &&
                [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 15 &&
                [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 20 &&
                [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 21 &&
                [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 22 &&
                [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 23 &&
                [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 24 &&
                [[attributeDict objectForKey:@"FieldTypeId"] intValue] != 16)
            {
                
                if (beginColumList)
                    commaOrParen = @",";
                else
                    commaOrParen = @",";
                
                float elementLabelHeight = 40.0;
                if (tagNum<100) {
                    tagNum = 100;
                }
                UILabel *elementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, contentSizeHeight, self.frame.size.width - 40, 40)];
                
                
                if (([[attributeDict objectForKey:@"IsRequired"] caseInsensitiveCompare:@"true"] ==  NSOrderedSame)&&(![[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"10"]))
                {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:@"*"];
                    
                    [elementLabel setText:[NSString stringWithFormat:@"%@ %@", [attributeDict objectForKey:@"PromptText"],attributedString]];
                    [elementLabel setText:[[elementLabel.text stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""]];
                    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]  initWithAttributedString: elementLabel.attributedText];
                    
                    [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(text.length-2, 1)];
                    [elementLabel setAttributedText: text];
                    
                }
                
                else
                {
                    [elementLabel setText:[NSString stringWithFormat:@"%@", [attributeDict objectForKey:@"PromptText"]]];
                }
                
                [elementLabel setTextAlignment:NSTextAlignmentLeft];
                [elementLabel setNumberOfLines:0];
                [elementLabel setLineBreakMode:NSLineBreakByWordWrapping];
                float fontsize = 14.0;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    fontsize = 24.0;
                [elementLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]];
                elementLabel.tag = tagNum;
                tagNum++;
                //NSLog(@"tag is %d",tagNum);
                [formCanvas addSubview:elementLabel];
                if ([elementLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]}].width > self.frame.size.width - 40.0)
                {
                    elementLabelHeight = 20.0 * (fontsize / 14.0) * ((float)((int)([elementLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]}].width / (self.frame.size.width - 40.0))) + 1.0);
                    [elementLabel setFrame:CGRectMake(20, contentSizeHeight, self.frame.size.width - 40.0, elementLabelHeight)];
                    contentSizeHeight += (elementLabelHeight - 40.0);
                }
                int carriageReturns = 1;
                NSString *elementLabelTextSubstring = [NSString stringWithString:elementLabel.text];
                while (elementLabelTextSubstring.length > 0)
                {
                    int crPos = (int)[elementLabelTextSubstring rangeOfString:@"\n"].location;
                    if (crPos < elementLabelTextSubstring.length && crPos >= 0)
                    {
                        carriageReturns ++;
                        elementLabelTextSubstring = [elementLabelTextSubstring substringFromIndex:crPos + 1];
                    }
                    else
                        break;
                }
                if (carriageReturns > (int)(elementLabelHeight / 20.0))
                {
                    elementLabelHeight += 20.0 * (float)(carriageReturns - (int)(elementLabelHeight / 20.0));
                    [elementLabel setFrame:CGRectMake(20, contentSizeHeight, self.frame.size.width - 40.0, elementLabelHeight)];
                    contentSizeHeight += 20.0 * (float)(carriageReturns - (int)(elementLabelHeight / 20.0));
                }
                if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"1"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    EpiInfoTextField *tf = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 1;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:1 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:1 from:@"before" from:@"page"])
                    {
                        //              [tf setBackgroundColor:[UIColor yellowColor]];
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [tf setBackgroundColor:selectedColor];
                        
                        
                        
                    }
                    
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:1 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }

                   // [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:1];
                    
                    tagNum++;
                    /* [tf setHidden:YES];
                     if([tf isHidden])
                     {
                     //              self.bViewTopConstraint.constant = self.aViewTopConstraint.constant;
                     contentSizeHeight -= 40.0;
                     }
                     else
                     {
                     contentSizeHeight += 40.0;
                     
                     }*/
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (self.dictionaryOfWordsArrays)
                    {
                        NSString *checkCodeFieldName = [self.dictionaryOfWordsArrays objectForKey:[attributeDict objectForKey:@"Name"]];
                        if (checkCodeFieldName)
                        {
                            [tf setCheckcode:[[CheckCode alloc] init]];
                            [(CheckCode *)[tf checkcode] setTheWords:(NSArray *)checkCodeFieldName];
                        }
                    }
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"2"])
                {
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"3"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    UppercaseTextField *tf = [[UppercaseTextField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                    }
                    else
                    {
                        required = NO;
                    }
                    
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 3;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:3 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                        
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:3 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [tf setBackgroundColor:selectedColor];
                    }
                    
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:3 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
                    //[self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:3];
                    
                    tagNum++;
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"4"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 160)];
                    [bg setBackgroundColor:[UIColor blackColor]];
                    [formCanvas addSubview:bg];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [bg setFrame:CGRectMake(40, bg.frame.origin.y, MIN(1.5 * bg.frame.size.width, formCanvas.frame.size.width - 80), 160)];
                    EpiInfoTextView *tf = [[EpiInfoTextView alloc] initWithFrame:CGRectMake(bg.frame.origin.x + 1, bg.frame.origin.y + 1, bg.frame.size.width - 2, bg.frame.size.height - 2)];
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                        
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 4;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:4 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:4 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [tf setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:4 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                        
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:4];
                    
                    tagNum++;
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 160;
                    [tf setDelegate:self];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    beginColumList = YES;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"5"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    NumberField *tf = [[NumberField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                        
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 5;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:5 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:5 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [tf setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:5 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                        
                    }
                    //[self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:5];
                    
                    tagNum++;
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ real", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"real" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (self.dictionaryOfWordsArrays)
                    {
                        NSString *checkCodeFieldName = [self.dictionaryOfWordsArrays objectForKey:[attributeDict objectForKey:@"Name"]];
                        if (checkCodeFieldName)
                        {
                            [tf setCheckcode:[[CheckCode alloc] init]];
                            [(CheckCode *)[tf checkcode] setTheWords:(NSArray *)checkCodeFieldName];
                            [(CheckCode *)[tf checkcode] setDictionaryOfFields:self.dictionaryOfFields];
                        }
                    }
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    if (seenFirstGeocodeField && ([[attributeDict objectForKey:@"Name"] isEqualToString:self.latitudeField] || [[attributeDict objectForKey:@"Name"] isEqualToString:self.longitudeField]))
                    {
                        contentSizeHeight += 40.0;
                        UIView *hideTheGeocodeCheckbox = [[UIView alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 5, 160, 30)];
                        geocodingCheckbox = [[Checkbox alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                        [hideTheGeocodeCheckbox addSubview:geocodingCheckbox];
                        UILabel *useDeviceLocation = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 120, 30)];
                        [useDeviceLocation setText:@"Use device location"];
                        [useDeviceLocation setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
                        [hideTheGeocodeCheckbox addSubview:useDeviceLocation];
                        [formCanvas addSubview:hideTheGeocodeCheckbox];
                    }
                    if ([[attributeDict objectForKey:@"Name"] isEqualToString:self.latitudeField] || [[attributeDict objectForKey:@"Name"] isEqualToString:self.longitudeField])
                        seenFirstGeocodeField = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"6"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    PhoneNumberField *tf = [[PhoneNumberField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 6;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:6 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:6 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [tf setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:6 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:6];
                    
                    tagNum++;
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"7"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    DateField *tf = [[DateField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 7;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:7 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:7 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        //              [elementLabel setBackgroundColor:selectedColor];
                        [tf setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:7 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:7];
                    
                    tagNum++;
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    [tf setTemplateFieldID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"FieldId"] intValue]]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"8"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    TimeField *tf = [[TimeField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 8;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:8 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:8 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        //              [elementLabel setBackgroundColor:selectedColor];
                        [tf setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:8 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                        
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:8];
                    
                    tagNum++;
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"9"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    DateTimeField *tf = [[DateTimeField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 9;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:9 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:9 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        //              [elementLabel setBackgroundColor:selectedColor];
                        [tf setBackgroundColor:selectedColor];
                        
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:9 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                        
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:9];
                    
                    tagNum++;
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"10"])
                {
                    float fieldWidth = 768 - 100;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    else
                        fontsize = 24.0;
                    [elementLabel setFrame:CGRectMake(60, contentSizeHeight, fieldWidth, 40)];
                    while ([elementLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]}].width > fieldWidth)
                        fontsize -= 0.1;
                    [elementLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]];
                    Checkbox *cb = [[Checkbox alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 5, 30, 30)];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [cb setFrame:CGRectMake(40, cb.frame.origin.y, 30, 30)];
                        [elementLabel setFrame:CGRectMake(80, contentSizeHeight, fieldWidth, 40)];
                    }
                    cb.tag = tagNum;
                    BOOL required;
//                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
//                    {
//                        required = YES;
//                        require++;
//                    }
//                    else
//                    {
                        required = NO;
                   
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 10;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:10 from:@"before" from:@"page"])
                    {
                        [cb setUserInteractionEnabled:NO];
                        [cb setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:10 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [cb setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:10 from:@"before" from:@"page"])
                    {
                        [cb setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                        
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:10];
                    
                    tagNum++;
                    [formCanvas addSubview:cb];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ integer", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"integer" forKey:[attributeDict objectForKey:@"Name"]];
                    [cb setColumnName:[attributeDict objectForKey:@"Name"]];
                    [cb setCheckboxAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    [self.checkboxes setObject:@"A" forKey:[attributeDict objectForKey:@"Name"]];
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:cb forKey:[attributeDict objectForKey:@"Name"]];
                    if (self.dictionaryOfWordsArrays)
                    {
                        NSString *checkCodeFieldName = [self.dictionaryOfWordsArrays objectForKey:[attributeDict objectForKey:@"Name"]];
                        if (checkCodeFieldName)
                        {
                            [cb setCheckcode:[[CheckCode alloc] init]];
                            [(CheckCode *)[cb checkcode] setTheWords:(NSArray *)checkCodeFieldName];
                        }
                    }
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"11"])
                {
                    YesNo *yn = [[YesNo alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180)];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [yn setFrame:CGRectMake(20, yn.frame.origin.y, yn.frame.size.width, yn.frame.size.height)];
                    yn.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 11;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:11 from:@"before" from:@"page"])
                    {
                        [yn setUserInteractionEnabled:NO];
                        [yn setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:11 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        //              [elementLabel setBackgroundColor:selectedColor];
                        [yn setBackgroundColor:selectedColor];
                        
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:11 from:@"before" from:@"page"])
                    {
                        [yn setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:11];
                    
                    tagNum++;
                    [formCanvas addSubview:yn];
                    contentSizeHeight += 160;
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ integer", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"integer" forKey:[attributeDict objectForKey:@"Name"]];
                    [yn setColumnName:[attributeDict objectForKey:@"Name"]];
                    [yn setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:yn forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"15"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    MirrorField *tf = [[MirrorField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 15;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:15 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:15 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [tf setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:15 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:15];
                    
                    tagNum++;
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    [tf setSourceFieldID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"SourceFieldId"] intValue]]];
                    [tf setEnabled:NO];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"17"])
                {
                    LegalValuesEnter *lv = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
                    lv.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 17;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:17 from:@"before" from:@"page"])
                    {
                        [lv setUserInteractionEnabled:NO];
                        [lv setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:17 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        //              [elementLabel setBackgroundColor:selectedColor];
                        [lv setBackgroundColor:selectedColor];
                        
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:17 from:@"before" from:@"page"])
                    {
                        [lv setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                        
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:17];
                    
                    tagNum++;
                    [formCanvas addSubview:lv];
                    contentSizeHeight += 160;
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [lv setColumnName:[attributeDict objectForKey:@"Name"]];
                    // Add the array of values to the root view controller's legal values dictionary
                    //Add check for nil
                    //if ([attributeDict objectForKey:@"SourceTableName"]) {
                    if([legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]])
                    {
                        NSString *tblName = [attributeDict objectForKey:@"SourceTableName"];
                        NSLog(@"*****%@",tblName);
                        
                        [legalValuesDictionaryForRVC setObject:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]] forKey:[lv.columnName lowercaseString]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"18"])
                {
                    NSMutableArray *fullArray = [legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]];
                    NSMutableArray *evenArray = [[NSMutableArray alloc] init];
                    NSMutableArray *oddArray = [[NSMutableArray alloc] init];
                    [evenArray addObject:@""];
                    [oddArray addObject:@""];
                    for (int i = 1; i < fullArray.count; i++)
                        if (i % 2 == 0)
                            [evenArray addObject:[fullArray objectAtIndex:i]];
                        else
                            [oddArray addObject:[fullArray objectAtIndex:i]];
                    
                    EpiInfoCodesField *lv = [[EpiInfoCodesField alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:oddArray];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
                    [lv setTextColumnValues:evenArray];
                    lv.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 18;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:18 from:@"before" from:@"page"])
                    {
                        [lv setUserInteractionEnabled:NO];
                        [lv setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:18 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [lv setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:18 from:@"before" from:@"page"])
                    {
                        [lv setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:18];
                    
                    tagNum++;
                    [formCanvas addSubview:lv];
                    contentSizeHeight += 160;
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [lv setColumnName:[attributeDict objectForKey:@"Name"]];
                    [lv setTextColumnName:[attributeDict objectForKey:@"TextColumnName"]];
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"19"])
                {
                    LegalValuesEnter *lv = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
                    lv.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 19;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:19 from:@"before" from:@"page"])
                    {
                        [lv setUserInteractionEnabled:NO];
                        [lv setAlpha:0.5];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:19 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [lv setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:19 from:@"before" from:@"page"])
                    {
                        [lv setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:19];
                    
                    [formCanvas addSubview:lv];
                    contentSizeHeight += 160;
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [lv setColumnName:[attributeDict objectForKey:@"Name"]];
                    [legalValuesDictionaryForRVC setObject:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]] forKey:[lv.columnName lowercaseString]];
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"14"])
                {
                    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 60, 60)];
                    [iv setImage:[UIImage imageNamed:@"PhoneRH"]];
                    iv.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 14;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:14 from:@"before" from:@"page"])
                    {
                        [iv setUserInteractionEnabled:NO];
                        [iv setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:14 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [iv setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:14 from:@"before" from:@"page"])
                    {
                        [iv setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:14];
                    
                    tagNum++;
                    [formCanvas addSubview:iv];
                    contentSizeHeight += 60;
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"12"])
                {
                    NSString *list = [attributeDict objectForKey:@"List"];
                    int pipes = (int)[list rangeOfString:@"||"].location;
                    NSString *valuesList = [list substringToIndex:pipes];
                    EpiInfoOptionField *lv = [[EpiInfoOptionField alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[NSMutableArray arrayWithArray:[valuesList componentsSeparatedByString:@","]]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                        [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
                    lv.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 12;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:12 from:@"before" from:@"page"])
                    {
                        [lv setUserInteractionEnabled:NO];
                        [lv setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:12 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        //              [elementLabel setBackgroundColor:selectedColor];
                        [lv setBackgroundColor:selectedColor];
                        
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:12 from:@"before" from:@"page"])
                    {
                        [lv setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:12];
                    
                    tagNum++;
                    [formCanvas addSubview:lv];
                    contentSizeHeight += 160;
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [lv setColumnName:[attributeDict objectForKey:@"Name"]];
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"25"])
                {
                    NSString *stringWidth = [attributeDict objectForKey:@"ControlWidthPercentage"];
                    if ([stringWidth containsString:@"."])
                    {
                        [nsnf setDecimalSeparator:@"."];
                    }
                    else if ([stringWidth containsString:@","])
                    {
                        [nsnf setDecimalSeparator:@","];
                    }
                    float fieldWidth = (768 - 40) * [[nsnf numberFromString:stringWidth] floatValue];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && fieldWidth > 280.0)
                        fieldWidth = 280.0;
                    if (fieldWidth < 40.0)
                        fieldWidth = 50.0;
                    EpiInfoUniqueIDField *tf = [[EpiInfoUniqueIDField alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, fieldWidth, 40)];
                    tf.tag = tagNum;
                    BOOL required;
                    if ([[attributeDict objectForKey:@"IsRequired"]caseInsensitiveCompare:@"true"]==NSOrderedSame)
                    {
                        required = YES;
                        require++;
                    }
                    else
                    {
                        required = NO;
                    }
                    epc.req = required;
                    epc.elementName = [attributeDict objectForKey:@"Name"];
                    epc.type = 25;
                    epc.tag = tagNum;
                    epc.promptText = [attributeDict objectForKey:@"PromptText"];
                    epc.input = 1;
                    [elementListArray addObject:epc];
                    [elmArray addObject:[[attributeDict objectForKey:@"Name"] lowercaseString]];
                    if([self checkElements:[attributeDict objectForKey:@"Name"] Tag:tagNum type:25 from:@"before" from:@"page"])
                    {
                        [tf setUserInteractionEnabled:NO];
                        [tf setAlpha:0.5f];
                    }
                    if([self checkHighlight:[attributeDict objectForKey:@"Name"] Tag:tagNum type:25 from:@"before" from:@"page"])
                    {
                        UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
                        [tf setBackgroundColor:selectedColor];
                    }
                    if([self checkHidden:[attributeDict objectForKey:@"Name"] Tag:tagNum type:25 from:@"before" from:@"page"])
                    {
                        [tf setHidden:YES];
                        [elementLabel setHidden:YES];
                        contentSizeHeight -= 40.0;
                        contentSizeHeight -= elementLabelHeight;
                    }
//                    [self setLabelReq:epc.elementName tag:epc.tag text:epc.promptText type:25];
                    
                    tagNum++;
                    [tf setBorderStyle:UITextBorderStyleRoundedRect];
                    [formCanvas addSubview:tf];
                    contentSizeHeight += 40.0;
                    [tf setDelegate:self];
                    [tf setReturnKeyType:UIReturnKeyDone];
                    createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
                    [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
                    [tf setColumnName:[attributeDict objectForKey:@"Name"]];
                    [tf setAccessibilityLabel:[attributeDict objectForKey:@"Name"]];
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    {
                        [tf setFrame:CGRectMake(40, tf.frame.origin.y, MIN(1.5 * tf.frame.size.width, formCanvas.frame.size.width - 80), 40)];
                        [tf setFont:[UIFont fontWithName:@"HelveticaNeue" size:24.0]];
                    }
                    beginColumList = YES;
                    [self.dictionaryOfFields setObject:tf forKey:[attributeDict objectForKey:@"Name"]];
                }
                else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"21"])
                {
                    contentSizeHeight -= 25.0;
                }
                else
                {
                    //                                NSLog(@"%@", [attributeDict objectForKey:@"FieldTypeId"]);
                }
                contentSizeHeight += 60.0;
            }
        }
    }
    
    for (id key in attributeDict)
    {
        if ([key isEqualToString:@"Name"] || [key isEqualToString:@"PromptText"] || [key isEqualToString:@"FieldTypeId"])
        {
            dataText = [dataText stringByAppendingString:[NSString stringWithFormat:@"\n\t\t%@ = %@", key, [attributeDict objectForKey:key]]];
        }
    }
    
    // Set up any mirroring
    for (UIView *v in [formCanvas subviews])
    {
        if ([v isKindOfClass:[MirrorField class]])
            for (UIView *v0 in [formCanvas subviews])
            {
                if ([v0 isKindOfClass:[DateField class]])
                    if ([(DateField *)v0 templateFieldID] && [[(DateField *)v0 templateFieldID] intValue] == [[(MirrorField *)v sourceFieldID] intValue])
                    {
                        [(DateField *)v0 setMirroringMe:(MirrorField *)v];
                        [v setFrame:CGRectMake(v.frame.origin.x, v.frame.origin.y, v0.frame.size.width, v0.frame.size.height)];
                    }
            }
        else if ([v isKindOfClass:[EpiInfoCodesField class]])
            for (UIView *v0 in [formCanvas subviews])
            {
                if ([v0 isKindOfClass:[EpiInfoTextField class]])
                    if ([[(EpiInfoTextField *)v0 columnName] isEqualToString:[(EpiInfoCodesField *)v textColumnName]])
                        [(EpiInfoCodesField *)v setTextColumnField:(EpiInfoTextField *)v0];
            }
    }
}

- (void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID
{
    [self clearButtonPressed];
    if (geocodingCheckbox)
        [geocodingCheckbox reset];
    
    queriedColumnsAndValues = [[NSMutableDictionary alloc] init];
    
    NSString *tableName = [tableNameAndGUID objectAtIndex:0];
    NSString *guid = [tableNameAndGUID objectAtIndex:1];
    recordUIDForUpdate = guid;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
    if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
    {
        NSString *selStmt = [NSString stringWithFormat:@"select * from %@ where globalrecordid = '%@'", tableName, guid];
        
        const char *query_stmt = [selStmt UTF8String];
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                int i = 0;
                while (sqlite3_column_name(statement, i))
                {
                    NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                    if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                    {
                        i++;
                        continue;
                    }
                    [queriedColumnsAndValues setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] forKey:[columnName lowercaseString]];
                    i++;
                }
                break;
            }
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(epiinfoDB);
    
    for (UIView *v in [formCanvas subviews])
    {
        if ([v isKindOfClass:[EpiInfoTextField class]])
        {
            [(EpiInfoTextField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(EpiInfoTextField *)v columnName] lowercaseString]]];
        [self checkRequiredstr:[(EpiInfoTextField *)v columnName] Tag:[(EpiInfoTextField *)v tag] type:1 from:@"after" str:[(EpiInfoTextField *)v text]];
        }
        else if ([v isKindOfClass:[EpiInfoTextView class]])
        {
            [(EpiInfoTextView *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(EpiInfoTextView *)v columnName] lowercaseString]]];
            [self checkRequiredstr:[(EpiInfoTextView *)v columnName] Tag:[(EpiInfoTextView *)v tag] type:4 from:@"after" str:[(EpiInfoTextView *)v text]];
        }
        else if ([v isKindOfClass:[Checkbox class]])
        {
            [(Checkbox *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(Checkbox *)v columnName] lowercaseString]]];
        }
        else if ([v isKindOfClass:[YesNo class]])
        {
            [(YesNo *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(YesNo *)v columnName] lowercaseString]]];
            [self checkRequiredstr:[(YesNo *)v columnName] Tag:[(YesNo *)v tag] type:11 from:@"after" str:[(YesNo *)v picked]];
        }
        else if ([v isKindOfClass:[NumberField class]])
        {
            [(NumberField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(NumberField *)v columnName] lowercaseString]]];
            [self checkRequiredstr:[(NumberField *)v columnName] Tag:[(NumberField *)v tag] type:5 from:@"after" str:[(NumberField *)v text]];
        }
        else if ([v isKindOfClass:[PhoneNumberField class]])
        {
            [(PhoneNumberField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(PhoneNumberField *)v columnName] lowercaseString]]];
            [self checkRequiredstr:[(PhoneNumberField *)v columnName] Tag:[(PhoneNumberField *)v tag] type:6 from:@"after" str:[(PhoneNumberField *)v text]];
        }
        else if ([v isKindOfClass:[DateField class]])
        {
            [(DateField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(DateField *)v columnName] lowercaseString]]];
            [self checkRequiredstr:[(DateField *)v columnName] Tag:[(DateField *)v tag] type:7 from:@"after" str:[(DateField *)v text]];
        }
        else if ([v isKindOfClass:[UppercaseTextField class]])
        {
            [(UppercaseTextField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(UppercaseTextField *)v columnName] lowercaseString]]];
            [self checkRequiredstr:[(UppercaseTextField *)v columnName] Tag:[(UppercaseTextField *)v tag] type:3 from:@"after" str:[(UppercaseTextField *)v text]];
        }
        else if ([v isKindOfClass:[LegalValuesEnter class]])
        {
            [(LegalValuesEnter *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(LegalValuesEnter *)v columnName] lowercaseString]]];
            [(LegalValuesEnter *)v setPicked:(NSString *)[queriedColumnsAndValues objectForKey:[[(LegalValuesEnter *)v columnName] lowercaseString]]];
            [self checkRequiredstr:[(LegalValuesEnter *)v columnName] Tag:[(LegalValuesEnter *)v tag] type:17 from:@"after" str:[(LegalValuesEnter *)v picked]];
        }
        else
            continue;
    }
    for (UIView *v in [self subviews])
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            if ([(UIButton *)v tag] == 1)
            {
                [(UIButton *)v setTag:8];
                [(UIButton *)v setImage:[UIImage imageNamed:@"UpdateButton.png"] forState:UIControlStateNormal];
            }
            if ([(UIButton *)v tag] == 7)
            {
                [(UIButton *)v setHidden:NO];
            }
        }
    }
    /*NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"checkcode"];
    [ccp parseCheckCode:savedValue];
    NSLog(@"%@",savedValue);*/
}

#pragma mark UIResponders

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    

    activeField = textField;
    
    
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    [self resignFirstResponder];
    activeField = nil;
    //[self endEditing:YES];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (hasAFirstResponder)
        return YES;

    activeField = textView;
    hasAFirstResponder = YES;
    
    return YES;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification {
    if (activeField.tag != 0) {
        if (activeField.tag>104 || activeField.tag < 99) {
            NSDictionary* info = [aNotification userInfo];
            CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
            CGRect bkgndRect = activeField.superview.frame;
            bkgndRect.size.height += kbSize.height;
            [activeField.superview setFrame:bkgndRect];
            [self setContentOffset:CGPointMake(0.0, activeField.frame.origin.y-kbSize.height) animated:YES];
        }
  
    }
//        permRect = CGRectMake(activeField.frame.origin.x, activeField.frame.origin.y, activeField.frame.size.width, activeField.frame.size.height);
    //CGPoint aRect = CGPointMake(activeField.frame.origin, activeField.frame.size);
    

}
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
   // [self setContentOffset:(0,permRect) animated:YES];

}

- (void)keyboardWillHide:(NSNotification *)n
{
    [self setContentOffset:CGPointZero animated:YES];

}


#pragma mark responder

- (void)fieldBecameFirstResponder:(id)field
{
    if (elementsArray.count<1) {
        elementsArray = [ccp sendArray];
        // NSLog(@"FIELD satya %lu",(unsigned long)elementsArray.count);
    }
    if ([field isKindOfClass:[DateField class]])
    {
        [self resignAll];
        DateField *dateField = (DateField *)field;
        // NSLog(@"%@ became first responder", [dateField columnName]);
        [self checkHighlight:[dateField columnName] Tag:[dateField tag] type:7 from:@"before" from:@"field"];
        [self checkHidden:[dateField columnName] Tag:[dateField tag] type:7 from:@"before" from:@"field"];
        [self checkDialogs:[dateField columnName] Tag:1 type:7 from:@"before" from:@"field"];
        [self checkElements:[dateField columnName] Tag:[dateField tag] type:7 from:@"before" from:@"field"];

        
    }
    if ([field isKindOfClass:[EpiInfoTextField class]])
    {
        [self resignAll];
        EpiInfoTextField *etf = (EpiInfoTextField *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:1 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:1 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:1 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:1 from:@"before" from:@"field"];

        
        
        
    }
    if ([field isKindOfClass:[EpiInfoTextView class]])
    {
        [self resignAll];
        EpiInfoTextView *etf = (EpiInfoTextView *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:4 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:4 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:4 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:4 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[UppercaseTextField class]])
    {
        [self resignAll];
        UppercaseTextField *etf = (UppercaseTextField *)field;
        //NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:3 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:3 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:3 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:3 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[NumberField class]])
    {
        [self resignAll];
        NumberField *etf = (NumberField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:5 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:5 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:5 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:5 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[PhoneNumberField class]])
    {
        [self resignAll];
        PhoneNumberField *etf = (PhoneNumberField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:6 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:6 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:6 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:6 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[TimeField class]])
    {
        [self resignAll];
        TimeField *etf = (TimeField *)field;
        NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:8 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:8 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:8 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:8 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[DateTimeField class]])
    {
        [self resignAll];
        DateTimeField *etf = (DateTimeField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:9 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:9 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:9 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:9 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[EpiInfoOptionField class]])
    {
        [self resignAll];
        EpiInfoOptionField *etf = (EpiInfoOptionField *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:12 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:12 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:12 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:12 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[LegalValuesEnter class]])
    {
        [self resignAll];
        LegalValuesEnter *etf = (LegalValuesEnter *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:17 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:17 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:17 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:17 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[EpiInfoUniqueIDField class]])
    {
        [self resignAll];
        EpiInfoUniqueIDField *etf = (EpiInfoUniqueIDField *)field;
        // NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:25 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:25 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:25 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:25 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[Checkbox class]])
    {
        [self resignAll];
        Checkbox *etf = (Checkbox *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:10 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:10 from:@"before" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:1 type:10 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:10 from:@"before" from:@"field"];

        
        
    }
    if ([field isKindOfClass:[YesNo class]])
    {
        [self resignAll];
        YesNo *etf = (YesNo *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkDialogs:[etf columnName] Tag:1 type:11 from:@"before" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:11 from:@"before" from:@"field"];
        [self checkHighlight:[etf columnName] Tag:[etf tag] type:10 from:@"before" from:@"field"];
        [self checkElements:[etf columnName] Tag:[etf tag] type:10 from:@"before" from:@"field"];

        
        
    }
    //[self resignFirstResponder];
}


- (void)fieldResignedFirstResponder:(id)field
{
    if ([field isKindOfClass:[EpiInfoTextField class]])
    {
        EpiInfoTextField *etf = (EpiInfoTextField *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkElements:[etf columnName] Tag:[etf tag] type:1 from:@"after" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:[etf tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:1 from:@"after" from:@"field"];

        BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:1 from:@"after" str:etf.text];
        if (required) {
            etf.layer.borderWidth = 1.0f;
            etf.layer.borderColor = [[UIColor redColor] CGColor];
            etf.layer.cornerRadius = 5;
            etf.clipsToBounds      = YES;
            
        }
        else
        {
            etf.layer.borderWidth = 1.0f;
            etf.layer.borderColor = [[UIColor clearColor] CGColor];
            etf.layer.cornerRadius = 5;
            etf.clipsToBounds      = YES;
            [etf setAlpha:1.0f];
        }
        [self gotoField:@"after" element:[etf columnName]];

        
    }
    if ([field isKindOfClass:[UppercaseTextField class]])
    {
        UppercaseTextField *etf = (UppercaseTextField *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkElements:[etf columnName] Tag:[etf tag] type:3 from:@"after" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:[etf tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:3 from:@"after" from:@"field"];

        BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:3 from:@"after" str:etf.text];
        if (required) {
            etf.layer.borderWidth = 1.0f;
            etf.layer.borderColor = [[UIColor redColor] CGColor];
            etf.layer.cornerRadius = 5;
            etf.clipsToBounds      = YES;
            
        }
        else
        {
            etf.layer.borderWidth = 1.0f;
            etf.layer.borderColor = [[UIColor clearColor] CGColor];
            etf.layer.cornerRadius = 5;
            etf.clipsToBounds      = YES;
            [etf setAlpha:1.0f];
            
        }
        
        [self gotoField:@"after" element:[etf columnName]];

    }
    
    if ([field isKindOfClass:[EpiInfoTextView class]])
    {
        EpiInfoTextView *etf = (EpiInfoTextView *)field;
        //   NSLog(@"%@",[etf columnName]);
        [self checkElements:[etf columnName] Tag:[etf tag] type:4 from:@"after" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:[etf tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:4 from:@"after" from:@"field"];

        BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:4 from:@"after" str:etf.text];
        if (required) {
            etf.layer.borderWidth = 1.0f;
            etf.layer.borderColor = [[UIColor redColor] CGColor];
            etf.layer.cornerRadius = 5;
            etf.clipsToBounds      = YES;
            
        }
        else
        {
            etf.layer.borderWidth = 1.0f;
            etf.layer.borderColor = [[UIColor clearColor] CGColor];
            etf.layer.cornerRadius = 5;
            etf.clipsToBounds      = YES;
            [etf setAlpha:1.0f];
            
        }
        [self gotoField:@"after" element:[etf columnName]];

        
    }
    if ([field isKindOfClass:[NumberField class]])
    {
        NumberField *numField = (NumberField *)field;
        //   NSLog(@"%@ resigned first responder", [numField columnName]);
        [self checkElements:[numField columnName] Tag:[numField tag] type:5 from:@"after" from:@"field"];
        [self checkDialogs:[numField columnName] Tag:[numField tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[numField columnName] Tag:[numField tag] type:5 from:@"after" from:@"field"];

        BOOL required = [self checkRequiredstr:[numField columnName] Tag:[numField tag] type:5 from:@"after" str:numField.text];
        if (required) {
            numField.layer.borderWidth = 1.0f;
            numField.layer.borderColor = [[UIColor redColor] CGColor];
            numField.layer.cornerRadius = 5;
            numField.clipsToBounds      = YES;
            
        }
        else
        {
            numField.layer.borderWidth = 1.0f;
            numField.layer.borderColor = [[UIColor clearColor] CGColor];
            numField.layer.cornerRadius = 5;
            numField.clipsToBounds      = YES;
            [numField setAlpha:1.0f];
            
        }
        
        [self gotoField:@"after" element:[numField columnName]];

    }
    
    if ([field isKindOfClass:[PhoneNumberField class]])
    {
        PhoneNumberField *numField = (PhoneNumberField *)field;
        //     NSLog(@"%@ resigned first responder", [numField columnName]);
        [self checkElements:[numField columnName] Tag:[numField tag] type:6 from:@"after" from:@"field"];
        [self checkDialogs:[numField columnName] Tag:[numField tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[numField columnName] Tag:[numField tag] type:6 from:@"after" from:@"field"];

        BOOL required = [self checkRequiredstr:[numField columnName] Tag:[numField tag] type:6 from:@"after" str:numField.text];
        if (required) {
            numField.layer.borderWidth = 1.0f;
            numField.layer.borderColor = [[UIColor redColor] CGColor];
            numField.layer.cornerRadius = 5;
            numField.clipsToBounds      = YES;
            
        }
        else
        {
            numField.layer.borderWidth = 1.0f;
            numField.layer.borderColor = [[UIColor clearColor] CGColor];
            numField.layer.cornerRadius = 5;
            numField.clipsToBounds      = YES;
            [numField setAlpha:1.0f];
            
        }
        [self gotoField:@"after" element:[numField columnName]];

    }
    
    
    if ([field isKindOfClass:[DateField class]])
    {
        DateField *dateField = (DateField *)field;
        // NSLog(@"%@ resigned first responder", [dateField columnName]);
        [self checkElements:[dateField columnName] Tag:[dateField tag] type:7 from:@"after" from:@"field"];
        [self checkDialogs:[dateField columnName] Tag:[dateField tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[dateField columnName] Tag:[dateField tag] type:7 from:@"after" from:@"field"];

        BOOL required = [self checkRequiredstr:[dateField columnName] Tag:[dateField tag] type:7 from:@"after" str:dateField.text];
        if (required) {
            dateField.layer.borderWidth = 1.0f;
            dateField.layer.borderColor = [[UIColor redColor] CGColor];
            dateField.layer.cornerRadius = 5;
            dateField.clipsToBounds      = YES;
            
        }
        else
        {
            dateField.layer.borderWidth = 1.0f;
            dateField.layer.borderColor = [[UIColor clearColor] CGColor];
            dateField.layer.cornerRadius = 5;
            dateField.clipsToBounds      = YES;
            [dateField setAlpha:1.0f];
            
        }
        [self gotoField:@"after" element:[dateField columnName]];

    }
    if ([field isKindOfClass:[TimeField class]])
    {
        TimeField *timeField = (TimeField *)field;
        //    NSLog(@"%@ resigned first responder", [timeField columnName]);
        [self checkElements:[timeField columnName] Tag:[timeField tag] type:8 from:@"after" from:@"field"];
        [self checkDialogs:[timeField columnName] Tag:[timeField tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[timeField columnName] Tag:[timeField tag] type:8 from:@"after" from:@"field"];

        BOOL required = [self checkRequiredstr:[timeField columnName] Tag:[timeField tag] type:8 from:@"after" str:timeField.text];
        if (required) {
            timeField.layer.borderWidth = 1.0f;
            timeField.layer.borderColor = [[UIColor redColor] CGColor];
            timeField.layer.cornerRadius = 5;
            timeField.clipsToBounds      = YES;
            
        }
        else
        {
            timeField.layer.borderWidth = 1.0f;
            timeField.layer.borderColor = [[UIColor clearColor] CGColor];
            timeField.layer.cornerRadius = 5;
            timeField.clipsToBounds      = YES;
            [timeField setAlpha:1.0f];
            
        }
        [self gotoField:@"after" element:[timeField columnName]];
 
    }
    if ([field isKindOfClass:[DateTimeField class]])
    {
        DateTimeField *dateTimeField = (DateTimeField *)field;
        //   NSLog(@"%@ resigned first responder", [dateTimeField columnName]);
        [self checkElements:[dateTimeField columnName] Tag:[dateTimeField tag] type:9 from:@"after" from:@"field"];
        [self checkDialogs:[dateTimeField columnName] Tag:[dateTimeField tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[dateTimeField columnName] Tag:[dateTimeField tag] type:9 from:@"after" from:@"field"];

        BOOL required = [self checkRequiredstr:[dateTimeField columnName] Tag:[dateTimeField tag] type:9 from:@"after" str:dateTimeField.text];
        if (required) {
            dateTimeField.layer.borderWidth = 1.0f;
            dateTimeField.layer.borderColor = [[UIColor redColor] CGColor];
            dateTimeField.layer.cornerRadius = 5;
            dateTimeField.clipsToBounds      = YES;
            
        }
        else
        {
            dateTimeField.layer.borderWidth = 1.0f;
            dateTimeField.layer.borderColor = [[UIColor clearColor] CGColor];
            dateTimeField.layer.cornerRadius = 5;
            dateTimeField.clipsToBounds      = YES;
            [dateTimeField setAlpha:1.0f];
            
        }
        [self gotoField:@"after" element:[dateTimeField columnName]];

    }
    
    if ([field isKindOfClass:[YesNo class]])
    {
        YesNo *etf = (YesNo *)field;
        //  NSLog(@"%@",[etf columnName]);
        [self checkElements:[etf columnName] Tag:[etf tag] type:11 from:@"after" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:[etf tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:11 from:@"after" from:@"field"];

        //  NSLog(@"%@",etf.picked);
        //        if ([[etf picked]intValue] == 0)
        // if (![[etf picked]containsString:@"1"])//||[[etf picked]containsString:@"0"])
        if ([[etf picked]isEqualToString:@"NULL"])
        {
            //     NSLog(@"%d",[[etf picked]intValue]);
            BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:11 from:@"after" str:@""];
            if (required)
            {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor redColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                
            }
            else
            {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor clearColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                [etf setAlpha:1.0f];
                
            }

        }
        
        else if ([etf picked].length == 1)
        {
            BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:11 from:@"after" str:@"value"];
            if (required) {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor redColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                
            }
            else
            {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor clearColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                [etf setAlpha:1.0f];
            }
        }
        [self gotoField:@"after" element:[etf columnName]];

        
    }
    
    if ([field isKindOfClass:[EpiInfoOptionField class]])
    {
        EpiInfoOptionField *etf = (EpiInfoOptionField *)field;
        //   NSLog(@"%@",[etf columnName]);
        [self checkElements:[etf columnName] Tag:[etf tag] type:12 from:@"after" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:[etf tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:12 from:@"after" from:@"field"];

        // NSLog(@"%@",etf.picked);
        if ([[etf picked]isEqualToString:@"NULL"])
        {
            BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:12 from:@"after" str:@""];
            if (required) {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor redColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                
            }
            else
            {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor clearColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                [etf setAlpha:1.0f];
                
            }
        }
        
        else if ([etf picked].length == 1)
        {
            BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:12 from:@"after" str:@"value"];
            if (required) {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor redColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                
            }
            else
            {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor clearColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                [etf setAlpha:1.0f];
            }
        }
        
        [self gotoField:@"after" element:[etf columnName]];

        
    }
    if ([field isKindOfClass:[LegalValuesEnter class]])
    {
        LegalValuesEnter *etf = (LegalValuesEnter *)field;
        //     NSLog(@"%@",[etf columnName]);
        [self checkElements:[etf columnName] Tag:[etf tag] type:17 from:@"after" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:[etf tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:17 from:@"after" from:@"field"];

        //    NSLog(@"%@",etf.picked);
        //        if ([[etf picked]intValue] == 0)
        // if (![[etf picked]containsString:@"1"])//||[[etf picked]containsString:@"0"])
        if ([[etf picked]isEqualToString:@"NULL"])
        {
            //    NSLog(@"%d",[[etf picked]intValue]);
            BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:17 from:@"after" str:@""];
            if (required)
            {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor redColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                
            }
            else
            {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor clearColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                [etf setAlpha:1.0f];
                
            }
        }
        
        else if (([etf picked].length == 1)||([etf picked].length>1))
        {
            BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:17 from:@"after" str:@"value"];
            if (required) {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor redColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                
            }
            else
            {
                etf.layer.borderWidth = 1.0f;
                etf.layer.borderColor = [[UIColor clearColor] CGColor];
                etf.layer.cornerRadius = 5;
                etf.clipsToBounds      = YES;
                [etf setAlpha:1.0f];
            }
        }
//        NSLog(@"%lu",(unsigned long)etf.picked.length);
        [self gotoField:@"after" element:[etf columnName]];

    }
    
    if ([field isKindOfClass:[EpiInfoUniqueIDField class]])
    {
        EpiInfoUniqueIDField *etf = (EpiInfoUniqueIDField *)field;
        //    NSLog(@"%@",[etf columnName]);
        [self checkElements:[etf columnName] Tag:[etf tag] type:25 from:@"after" from:@"field"];
        [self checkDialogs:[etf columnName] Tag:[etf tag] type:1 from:@"after" from:@"field"];
        [self checkHidden:[etf columnName] Tag:[etf tag] type:25 from:@"after" from:@"field"];

        
        BOOL required = [self checkRequiredstr:[etf columnName] Tag:[etf tag] type:25 from:@"after" str:etf.text];
        if (required) {
            etf.layer.borderWidth = 1.0f;
            etf.layer.borderColor = [[UIColor redColor] CGColor];
            etf.layer.cornerRadius = 5;
            etf.clipsToBounds      = YES;
            
        }
        else
        {
            etf.layer.borderWidth = 1.0f;
            etf.layer.borderColor = [[UIColor clearColor] CGColor];
            etf.layer.cornerRadius = 5;
            etf.clipsToBounds      = YES;
            [etf setAlpha:1.0f];
            
        }
        
        [self gotoField:@"after" element:[etf columnName]];

    }
    
}

- (void)checkboxChanged:(Checkbox *)checkbox
{
    // NSLog(@"%@ changed", [checkbox columnName]);
    [self checkElements:[checkbox columnName] Tag:[checkbox tag] type:10 from:@"after" from:@"field"];
    [self checkDialogs:[checkbox columnName] Tag:[checkbox tag] type:1 from:@"after" from:@"field"];
    [self checkHidden:[checkbox columnName] Tag:[checkbox tag] type:10 from:@"after" from:@"field"];

    [self gotoField:@"after" element:[checkbox columnName]];

    
    
}

#pragma mark Checkcode

-(void)getCheckCodeValues:(NSString *)eleName from:(NSString *)fromVal befAf:(NSString *)befAfVal ty:(int)type
{
    
}
-(void)copyToArray:(NSMutableArray *)eleArray
{
    if (elementsArray.count<1) {
        elementsArray = [[NSMutableArray alloc]init];
        elementsArray = eleArray;
        //    NSLog(@"count %lu %lu",(unsigned long)elementsArray.count,(unsigned long)eleArray.count);
    }
    //NSLog(@"OUT");
}

-(void)getDialogs
{
    ElementPairsCheck *epc = [[ElementPairsCheck alloc]init];
    if (dialogArray.count<1) {
        dialogArray = [[NSMutableArray alloc]init];
        dialogListArray = [[NSMutableArray alloc]init];
        dialogTitleArray = [[NSMutableArray alloc]init];
    }
    if (elementsArray.count<1) {
        elementsArray = [ccp sendArray];
        
    }
    for (int i=0; i<elementsArray.count; i++)
    {
        epc = [elementsArray objectAtIndex:i];
        NSString *conditionWord;
        NSString *conditionWordOne;
        NSUInteger count = [self numberOfWordsInString:epc.name];
        conditionWord= [[[epc.name componentsSeparatedByString:@" "] objectAtIndex:0]lowercaseString];
        if (count>1) {
            NSRange range = [epc.name rangeOfString:conditionWord];
            conditionWordOne=[epc.name stringByReplacingCharactersInRange:range withString:@""];
            conditionWordOne = [[self removeSp:conditionWordOne]lowercaseString];
        }

        NSString *eleSp= [self removeSp:epc.stringValue];
        eleSp=[[eleSp stringByReplacingOccurrencesOfString:@"DIALOG" withString:@"dialog"]stringByReplacingOccurrencesOfString:@"Dialog" withString:@"dialog"];
        eleSp=[[[eleSp stringByReplacingOccurrencesOfString:@"TITLETEXT" withString:@"titletext"]stringByReplacingOccurrencesOfString:@"Titletext" withString:@"titletext"]stringByReplacingOccurrencesOfString:@"TitleText" withString:@"titletext"];
        

        if([eleSp containsString:@"dialog"])

        {
            NSArray* dialogArraySingle = [eleSp componentsSeparatedByString: @"dialog"];
            for (int i=0; i<dialogArraySingle.count; i++) {
                
                NSString *item = [dialogArraySingle objectAtIndex:i];
                if ([item containsString:@"\""]) {
                    //[dialogArraySingle removeObject:item];
                    DialogModel *dmc = [[DialogModel alloc]initWithFrom:conditionWord name:conditionWordOne beforeAfter:epc.condition title:item subject:@"" displayed:NO];
                    
                    [dialogArray addObject:dmc];
                }
                
            }
        }
    }
    
    /*for (int j = 0; j<dialogArray.count; j++) {
     */
    // for (DialogModel *dmc in dialogArray) {
    for (int i =0; i<dialogArray.count; i++)
    {
        DialogModel *dmc = [dialogArray objectAtIndex:i];
        BOOL isFirst = FALSE;
        NSScanner *scanner = [NSScanner scannerWithString:dmc.title];
        NSString *tmp;
        NSMutableArray *target = [NSMutableArray array];
        
        
        while ([scanner isAtEnd] == NO)
        {
            [scanner scanUpToString:@"\"" intoString:NULL];
            [scanner scanString:@"\"" intoString:NULL];
            [scanner scanUpToString:@"\"" intoString:&tmp];
            if ([scanner isAtEnd] == NO)
            {
                if (isFirst == FALSE)
                {
                    [target addObject:tmp];
                    [scanner scanString:@"\"" intoString:NULL];
                    isFirst = TRUE;
                    dmc.subject = tmp;
                    [dialogArray replaceObjectAtIndex:i withObject:dmc];
                }
                else
                {
                    break;
                }
                
            }
        }
        NSString *tempo = dmc.title;
        NSString *replace=[NSString stringWithFormat:@"\"%@\"",dmc.subject];
        tempo = [tempo stringByReplacingOccurrencesOfString:replace withString:@""];
        //            NSLog(@"%@---%@",tempo,replace);
        tempo = [self removeSp:tempo];
        if ([[[tempo componentsSeparatedByString:@" "] objectAtIndex:0] containsString:@"titletext"])

        {
            //NSLog(@"%@",tempo);
            NSScanner *scanner = [NSScanner scannerWithString:tempo];
            NSString *tmp;
            
            while ([scanner isAtEnd] == NO)
            {
                [scanner scanUpToString:@"\"" intoString:NULL];
                [scanner scanString:@"\"" intoString:NULL];
                [scanner scanUpToString:@"\"" intoString:&tmp];
                if ([scanner isAtEnd] == NO)
                {
                    [scanner scanString:@"\"" intoString:NULL];
                    dmc.title = tmp;
                    [dialogArray replaceObjectAtIndex:i withObject:dmc];
                    
                }
            }
            
        }
        else
        {
            [dialogArray removeObjectAtIndex:i];
            i--;
        }
        
    }
    for (DialogModel *dmc in dialogArray) {
        if ([dmc.from isEqualToString:@"page"] &&[dmc.beforeAfter isEqualToString:@"after"]) {
            // NSLog(@"-----PAGE AFTER %@---------%@",dmc.from,dmc.name);
            [dialogListArray addObject:dmc.name];
        }
    }
    
}
-(void)getDisEnb
{
    ElementPairsCheck *epc = [[ElementPairsCheck alloc]init];
    if (conditionsArray.count<1) {
        conditionsArray = [[NSMutableArray alloc]init];
        
    }
    if (elementsArray.count<1) {
        elementsArray = [ccp sendArray];
        
    }
    for (int i=0; i<elementsArray.count; i++)
    {
        epc = [elementsArray objectAtIndex:i];
        NSString *conditionWord;
        NSString *conditionWordOne;
        NSUInteger count = [self numberOfWordsInString:epc.name];
        conditionWord= [[[epc.name componentsSeparatedByString:@" "] objectAtIndex:0]lowercaseString];
        if (count>1) {
            NSRange range = [epc.name rangeOfString:conditionWord];
            conditionWordOne=[epc.name stringByReplacingCharactersInRange:range withString:@""];
            conditionWordOne = [[self removeSp:conditionWordOne]lowercaseString];
            
        }
        conditionWordOne=[[conditionWordOne stringByReplacingOccurrencesOfString:@" Before" withString:@""]stringByReplacingOccurrencesOfString:@" before" withString:@""];

        NSString *elmt;
        NSString *lastElmt;
        int eleCount = [self numberOfWordsInString:epc.stringValue];
        NSString *eleSp= [[self removeSp:epc.stringValue]lowercaseString];
        for (int j = 0; j<eleCount; j++) {
            elmt = [[eleSp componentsSeparatedByString:@" "]objectAtIndex:j];
            
            // NSLog(@"Satya - %@ %d",elmt,j);
            
            if (![elmt isEqualToString:@""] && elmt)
            {
                if ([self checkKeyWordArray:elmt])
                {
                    if ([elmt isEqualToString:@"disable"]) {
                        
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"disable"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"disable";
                        j++;
                        
                    }
                    else if ([elmt isEqualToString:@"enable"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"enable"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"enable";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"set-required"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"required"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"required";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"set-not-required"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"notrequired"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"notrequired";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"highlight"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"highlight"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"highlight";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"unhighlight"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"unhighlight"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"unhighlight";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"goto"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"goto"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"goto";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"clear"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"clear"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"clear";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"hide"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"hidden"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"hidden";
                        j++;
                    }
                    else if ([elmt isEqualToString:@"unhide"]) {
                        ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j+1] beforeAfter:epc.condition condition:@"unhidden"];
                        [conditionsArray addObject:cModel];
                        lastElmt = @"unhidden";
                        j++;
                    }
                    
                }
                
                else{
                    ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j] beforeAfter:epc.condition condition:lastElmt];
                    [conditionsArray addObject:cModel];
                }
            }
            
            
            
        }
        
    }
    
}
//      keywordsArray = [[NSMutableArray alloc]initWithObjects:@"enable",@"disable",@"highlight",@"unhighlight",@"set-required",@"set-not-required", nil];
/* if ([self checkKeyWordArray:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j]])
 {
 }
 else
 {
 ConditionsModel *cModel = [[ConditionsModel alloc]initWithFrom:conditionWord name:conditionWordOne element:[[eleSp componentsSeparatedByString:@" "]objectAtIndex:j] beforeAfter:epc.condition condition:@"disable"];
 [conditionsArray addObject:cModel];
 }
 */

-(BOOL)checkKeyWordArray:(NSString *)str
{
    BOOL present =  NO;
    
    if ([keywordsArray containsObject:str]) {
        present = YES;
    }
    return present;
}
- (NSUInteger)numberOfWordsInString:(NSString *)str
{
    NSArray *words = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger count = 0;
    for (NSString *word in words) {
        if (![word isEqualToString:@""])
            count++;
    }
    return count;
}

-(NSString *)removeSp:(NSString *)newStr
{
    NSString *tmp;
    
    tmp= [newStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newTmp = [tmp stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    return newTmp;
    
}

#pragma mark checkElements

-(BOOL)checkElements:(NSString *)name Tag:(NSInteger *)newTag type:(int)newType from:(NSString *)befAft from:(NSString *)newFrom
{
    BOOL value = NO;
    ConditionsModel *cpm = [[ConditionsModel alloc]init];
    if (conditionsArray.count<1)
    {
        [self getDialogs];
        [self getDisEnb];
    }
    
    for (cpm in conditionsArray)
    {
        if ([befAft isEqualToString:@"before"])
        {
            if([cpm.beforeAfter isEqualToString:@"before"])
            {
                if (([cpm.element caseInsensitiveCompare:name] == NSOrderedSame) && [cpm.condition isEqualToString:@"clear"])
                {
                    for (ElementsModel *emc in elementListArray)
                    {
                        if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                        {
                            [self clear:emc.tag type:emc.type];
                            
                        }
                    }
                    
                }
            }
        }
        else if ([befAft isEqualToString:@"after"])
        {
            if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"clear"])
            {
                for (ElementsModel *emc in elementListArray)
                {
                    if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                    {
                        [self clear:emc.tag type:emc.type];
                        break;
                    }
                }
                
            }
        }

        /*BEFORE*/
        if ([befAft isEqualToString:@"before"])
        {
            
        
        if ([cpm.beforeAfter caseInsensitiveCompare:@"before"] == NSOrderedSame)
        {
            
            if (([cpm.element caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"disable"])
            {
                value = YES;
                // NSLog(@"%@---%@",cpm.element,name);
                
                
            }
            //Enable
            else if([cpm.condition isEqualToString:@"enable"])
            {
                value = NO;
            }
            
        }
            
                   
        }
        
        /*AFTER*/
        else if ([befAft caseInsensitiveCompare:@"after"]==NSOrderedSame)
        {
            //            NSLog(@"%@%@",cpm.beforeAfter,befAft);
            
            if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"disable"] )
            {
                for (ElementsModel *emc in elementListArray)
                {
                    if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                    {
                        [self disable:emc.tag type:emc.type];
                    }
                }
            }
            //Enable
            if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"enable"])
            {
                for (ElementsModel *emc in elementListArray)
                {
                    if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                    {
                        [self enable:emc.tag type:emc.type];
                        
                    }
                }
                
            }
            if ([cpm.condition isEqualToString:@"required"]&&([cpm.name caseInsensitiveCompare:name] == NSOrderedSame))
            {
                for (int i = 0; i<elementListArray.count; i++) {
                    ElementsModel *emc = [elementListArray objectAtIndex:i];
                    
                    if (([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)&&(emc.type !=10))
                    {
                        // NSLog(@"SATYA - %@-----%@",emc.elementName,cpm.element);
                        if (!(emc.req == YES)) {
                            
                            require++;
                            emc.req = YES;
                            [elementListArray replaceObjectAtIndex:i withObject:emc];
                            [self setLabelReqAfter:emc.elementName tag:emc.tag text:emc.promptText reqnot:YES];
                            
                        }
                    }
                }
                
            }
            if ([cpm.condition isEqualToString:@"notrequired"]&&([cpm.name caseInsensitiveCompare:name] == NSOrderedSame))
            {
                for (int i = 0; i<elementListArray.count; i++)
                {
                    ElementsModel *emc = [elementListArray objectAtIndex:i];
                    
                    if (([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)&&(emc.type !=10))
                    {
                        if (emc.req ==  YES)
                        {
                            require--;
                            
                            emc.req = NO;
                            [elementListArray replaceObjectAtIndex:i withObject:emc];
                            [self setLabelReqAfter:emc.elementName tag:emc.tag text:emc.promptText reqnot:NO];
                        }
                        
                    }
                }
                
            }
            
            
            
            //Highlight
            if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"highlight"])
            {
                for (ElementsModel *emc in elementListArray)
                {
                    if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                    {
                        [self highlight:emc.tag type:emc.type];
                        
                    }
                }
                
            }
            if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"unhighlight"])
            {
                for (ElementsModel *emc in elementListArray)
                {
                    if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                    {
                        [self unhighlight:emc.tag type:emc.type];
                        
                    }
                }
                
            }

        }
    }
    return value;
}
#pragma mark Dialog

-(void)checkDialogs:(NSString *)name Tag:(NSInteger *)newTag type:(int)newType from:(NSString *)befAft from:(NSString *)newFrom
{
    //dialogTitleArray = [[NSMutableArray alloc]init];
    NSString *fromVal;
    for (int i = 0; i<dialogArray.count; i++)
    {
        DialogModel *dmc = [dialogArray objectAtIndex:i];
        if ([dmc.beforeAfter caseInsensitiveCompare:@"before"] == NSOrderedSame)
        {
            if (([dmc.name containsString:name]) &&  [befAft isEqualToString:dmc.beforeAfter]&& (dmc.displayed == NO))
            {
                //NSLog(@"%@---%@",dmc.name,name);
                [dialogTitleArray addObject:dmc.title];
                [dialogTitleArray addObject:dmc.subject];
                [dialogTitleArray addObject:[NSNumber numberWithInt:i]];

                fromVal = @"";

                alertBefore = FALSE;
                
            }
            
            
        }
        else if ([dmc.beforeAfter caseInsensitiveCompare:@"after"] == NSOrderedSame)
        {
            name =[name lowercaseString];
            //Fix page vs field compare
            if (([dmc.name isEqualToString:name]) &&  [befAft isEqualToString:dmc.beforeAfter] && (dmc.displayed == NO))
            {
                alertBefore = TRUE;

                [dialogTitleArray addObject:dmc.title];
                [dialogTitleArray addObject:dmc.subject];
                [dialogTitleArray addObject:[NSNumber numberWithInt:i]];
                fromVal = newFrom;
                
               //For Submit button
                if ([dialogListArray containsObject:dmc.name])
                {
                    [dialogListArray removeObject:dmc.name];
                }
               // break;
            }

            
            
        }
        
    }
    [self showAlertsQueuedTag:newTag];
}

#pragma mark checkRequire

-(BOOL)checkRequiredstr:(NSString *)name Tag:(NSInteger *)newTag type:(int)newType from:(NSString *)befAft str:(NSString *)
newStr{
    
    BOOL reqYes;
    NSInteger *idx = [elmArray indexOfObject:[name lowercaseString]];
    ElementsModel *emc = [elementListArray objectAtIndex:idx];
    if (([emc.elementName caseInsensitiveCompare:name]==NSOrderedSame) && (emc.req == true ))
    {
        if ([newStr isEqualToString:@""])
        {
            reqYes = YES;
            emc.input = 0;
            [elementListArray replaceObjectAtIndex:idx withObject:emc];
            if (![requiredArray containsObject:emc.elementName]) {
                [requiredArray addObject:emc.elementName];
                if (valid>0)
                {
                    valid--;
                }
            }
        }
        else
        {
            reqYes = NO;
            emc.input = 1;
            [elementListArray replaceObjectAtIndex:idx withObject:emc];
            
            
            if ([requiredArray containsObject:emc.elementName]) {
                [requiredArray removeObject:emc.elementName];
                valid++;
            }
        }
    }
    else
    {
        reqYes = NO;
        emc.input = 1;
        [elementListArray replaceObjectAtIndex:idx withObject:emc];
        
        
    }
    return reqYes;
}

#pragma mark checkHighlight

-(BOOL)checkHighlight:(NSString *)name Tag:(NSInteger *)newTag type:(int)newType from:(NSString *)befAft from:(NSString *)newFrom
{
    BOOL value = NO;
    ConditionsModel *cpm = [[ConditionsModel alloc]init];
    if (conditionsArray.count<1)
    {
        [self getDisEnb];
    }
    
    for (cpm in conditionsArray)
    {
        if ([cpm.beforeAfter isEqualToString:@"before"]) {
            
            if ([newFrom isEqualToString:@"page"])
            {
                if (([cpm.element caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"highlight"])
                {
                    //[self highlight:newTag type:newType];
                    value = YES;
                }
                
                if (([cpm.element caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"unhighlight"])
                {
                    //[self unhighlight:newTag type:newType];
                    value = NO;
                }
            }
            
            else if([newFrom isEqualToString:@"field"])
            {
                
                if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"highlight"])
                {
                    for (ElementsModel *emc in elementListArray)
                    {
                        if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                        {
                            [self highlight:emc.tag type:emc.type];
                            
                        }
                    }
                    
                }
                if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"unhighlight"])
                {
                    for (ElementsModel *emc in elementListArray)
                    {
                        if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                        {
                            [self unhighlight:emc.tag type:emc.type];
                            
                        }
                    }
                    
                }
                
            }
        }
    }
    return value;
}

-(BOOL)checkHidden:(NSString *)name Tag:(NSInteger *)newTag type:(int)newType from:(NSString *)befAft from:(NSString *)newFrom
{
    BOOL value = NO;
    ConditionsModel *cpm = [[ConditionsModel alloc]init];
    if (conditionsArray.count<1)
    {
        [self getDisEnb];
    }
    
    for (cpm in conditionsArray)
    {
        if ([cpm.beforeAfter isEqualToString:@"before"]) {
            
            if ([newFrom isEqualToString:@"page"])
            {
                if (([cpm.element caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"hidden"])
                {
                    //[self highlight:newTag type:newType];
                    value = YES;
                }
                
                if (([cpm.element caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"unhidded"])
                {
                    //[self unhighlight:newTag type:newType];
                    value = NO;
                }
            }
            
            else if([newFrom isEqualToString:@"field"])
            {
                
                if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"hidden"])
                {
                    for (ElementsModel *emc in elementListArray)
                    {
                        if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                        {
                            [self hide:emc.tag type:emc.type];
                            
                        }
                    }
                    
                }
                if (([cpm.name caseInsensitiveCompare:name] == NSOrderedSame) &&  [befAft isEqualToString:cpm.beforeAfter] && [cpm.condition isEqualToString:@"unhidden"])
                {
                    for (ElementsModel *emc in elementListArray)
                    {
                        if ([emc.elementName caseInsensitiveCompare:cpm.element]==NSOrderedSame)
                        {
                            [self hide:emc.tag type:emc.type];
                            
                        }
                    }
                    
                }
                
            }
        }
    }
    return value;
}

-(void)gotoField:(NSString *)newFrom element:(NSString *)newElement
{
    for (ConditionsModel *cpm in conditionsArray)
    {
        if ([newFrom isEqualToString:@"before"])
        {
            if ([cpm.condition isEqualToString:@"goto"] && [cpm.beforeAfter isEqualToString:@"before"] )
            {
                if ([cpm.name isEqualToString:newElement])
                {
                    BOOL there = [elmArray containsObject:cpm.element];
                    if (there)
                    {
                        NSUInteger idx = [elmArray indexOfObject:cpm.element];
                        ElementsModel *emc = [elementListArray objectAtIndex:idx];
                        [self gotoFormField:emc.type tag:emc.tag];
                        break;
                        
                    }
                }
            }
        }
        else if([newFrom isEqualToString:@"after"])
        {
            if ([cpm.condition isEqualToString:@"goto"] && [cpm.beforeAfter isEqualToString:@"after"])
            {
                if ([cpm.name caseInsensitiveCompare:newElement]==NSOrderedSame)
                {
                    BOOL there = [elmArray containsObject:cpm.element];
                    if (there)
                    {
                        NSUInteger idx = [elmArray indexOfObject:cpm.element];
                        ElementsModel *emc = [elementListArray objectAtIndex:idx];
                        //[self gotoFormField:emc.type tag:emc.tag];
                        //DELAY by .5 secs for first responder to resign

                       double delayInSeconds = 0.5;
                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                            [self gotoFormField:emc.type tag:emc.tag];
                        });
                        break;
                        
                    }
                }
            }
        }
    }
    
}

#pragma mark checkUIManipulation

-(void)disable:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:NO];
            [utf setAlpha:0.5f];
            break;
        }
        default:
            break;
    }
    
}

-(void)enable:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:1.0f];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:0.5f];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:0.5f];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:0.5f];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:0.5f];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:0.5f];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setUserInteractionEnabled:YES];
            [utf setAlpha:0.5f];
            break;
        }
        default:
            break;
    }
    
}
//Highlight & Unhighlight
-(void)highlight:(int)eleTag type:(int)newType
{
    UIColor *selectedColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:194/255.0 alpha:1];
    
    switch (newType)
    {
            case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 11:
        {
            NSLog(@"y/n");
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            //            UILabel *utf = (UILabel *)[formCanvas viewWithTag:eleTag-1];
            [utf setBackgroundColor:selectedColor];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:selectedColor];
            break;
        }
        default:
            break;
    }
    
}

-(void)unhighlight:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor whiteColor]];
            
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setBackgroundColor:[UIColor clearColor]];
            break;
        }
        default:
            break;
    }
    
}

-(void)gotoMissingFieldtype:(int)newType tag:(NSInteger *)newTag
{
    switch (newType) {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:newTag];
            utf.layer.borderWidth = 1.0f;
            utf.layer.borderColor = [[UIColor redColor] CGColor];
            utf.layer.cornerRadius = 5;
            utf.clipsToBounds      = YES;
            [utf becomeFirstResponder];
            break;
        }
        default:
            break;
    }
}

-(void)gotoFormField:(int)newType tag:(NSInteger *)newTag
{
   // [self endEditing:YES];
    switch (newType) {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:newTag];
            [utf becomeFirstResponder];
            break;
        }
            
        default:
            break;
    }
}

/*CLEAR*/

-(void)clear:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setFormFieldValue:NULL];

            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setTrueFalse:0];
            [utf setBackgroundColor:[UIColor whiteColor]];
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf reset];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf reset];

            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf reset];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf reset];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf reset];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setImage:@""];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setText:@""];
            break;
        }
            default:
            break;
    }
    
}

/*hide*/

-(void)hide:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            [utf setBackgroundColor:[UIColor whiteColor]];
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:YES];
            break;
        }
        default:
            break;
    }
    
}

/*unhide*/

-(void)unhide:(int)eleTag type:(int)newType
{
    switch (newType)
    {
        case 1:
        {
            EpiInfoTextField *utf = (EpiInfoTextField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 3:
        {
            UppercaseTextField *utf = (UppercaseTextField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 4:
        {
            EpiInfoTextView *utf = (EpiInfoTextView *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 5:
        {
            NumberField *utf = (NumberField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 6:
        {
            PhoneNumberField *utf = (PhoneNumberField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 7:
        {
            DateField *utf = (DateField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 8:
        {
            TimeField *utf = (TimeField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 9:
        {
            DateTimeField *utf = (DateTimeField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 10:
        {
            Checkbox *utf = (Checkbox *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            break;
        }
        case 11:
        {
            YesNo *utf = (YesNo *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 12:
        {
            EpiInfoOptionField *utf = (EpiInfoOptionField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            
            break;
        }
        case 15:
        {
            NSLog(@"Mirror");
            MirrorField *utf = (MirrorField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            break;
        }
        case 17:
        {
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            break;
        }
        case 18:
        {
            NSLog(@"codes");
            EpiInfoCodesField *utf = (EpiInfoCodesField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            break;
        }
        case 19:
        {
            NSLog(@"legalcomment");
            LegalValuesEnter *utf = (LegalValuesEnter *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            break;
        }
        case 14:
        {
            NSLog(@"image");
            UIImageView *utf = (UIImageView *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            break;
        }
        case 25:
        {
            NSLog(@"unique");
            EpiInfoUniqueIDField *utf = (EpiInfoUniqueIDField *)[formCanvas viewWithTag:eleTag];
            [utf setHidden:NO];
            break;
        }
        default:
            break;
    }
    
}

-(NSUInteger)getIndexEle:(NSString *)newElet
{
    NSUInteger idx = [elmArray indexOfObject:newElet];
    return idx;
}

-(void)showAlrt:(UIAlertController *)alrt
{
    UIWindow *keyWin = [[UIApplication sharedApplication]keyWindow];
    UIViewController *mainVC = [keyWin rootViewController];
    [mainVC presentViewController:alrt animated:YES completion:nil];

}

-(void)showAlertsQueuedTag:(int)newTag
{
    if (dialogTitleArray.count>1) {
        int count = (dialogTitleArray.count/3);
        int i =0;
    NSString *title = [dialogTitleArray objectAtIndex:i];
    NSString *subject = [dialogTitleArray objectAtIndex:i+1];
    int index = [[dialogTitleArray objectAtIndex:i+2]intValue];
    DialogModel *dmc = [dialogArray objectAtIndex:index];
    dmc.displayed = YES;
    [dialogArray replaceObjectAtIndex:index withObject:dmc];
    [dialogTitleArray removeObjectAtIndex:0];
    [dialogTitleArray removeObjectAtIndex:0];
    [dialogTitleArray removeObjectAtIndex:0];

        if (count==1) {
            [self endEditing:YES];
        }
    UIAlertAction *defaultAction ;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:subject preferredStyle:UIAlertControllerStyleAlert];

    if (dialogTitleArray.count>1) {
        defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                UITextField *utf = (UITextField *)[formCanvas viewWithTag:newTag];
                [utf resignFirstResponder];

                [self showAlertsQueuedTag:newTag];


                
            });
        }];
    }
    else
    {
        defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            UITextField *utf = (UITextField *)[formCanvas viewWithTag:newTag];
            [utf resignFirstResponder];

           // [self gotoField:@"before" element:[pageName lowercaseString]];


        }];
        
    }
        [alert addAction:defaultAction];

        [self showAlrt:alert];
    }
//    else
//    {
//        [self gotoField:@"before" element:[pageName lowercaseString]];
//
//    }

    
}

#pragma mark checkSubmitValidation

-(BOOL)onSubmitRequiredFrom:(NSString *)from
{
    BOOL done = NO;
    int counter = 0;
    
    for (ElementsModel *emc in elementListArray) {
        counter++;
        if (emc.req == YES && emc.input == NO)
        {
            
            if ([from isEqualToString:@"else"]) {
                [self showAlertForType:emc.type tag:emc.tag];
            }
            //            if ([from isEqualToString:@"elsealert"]) {
            //            [self gotoMissingFieldtype:emc.type tag:emc.tag];
            //            }
            done = NO;
            break;
            
        }
        if (counter == elementListArray.count) {
            done = YES;
        }
    }
    return done;
}

-(void)showAlertForType:(int)newType tag:(NSInteger *)newTag
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Missing Required Fields" message:@"Please fill in all required fields" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self gotoMissingFieldtype:newType tag:newTag];
        
    }];
    
    [alert addAction:defaultAction];
    // UIViewController *uvc = [[[[UIApplication sharedApplication] delegate] window] rootViewController] ;
    //[self presentViewController:alert animated:YES completion:nil];
    
    UIWindow *keyWin = [[UIApplication sharedApplication]keyWindow];
    UIViewController *mainVC = [keyWin rootViewController];
    [mainVC presentViewController:alert animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification* notification){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

#pragma mark checkRequiredLabels

-(void)setLabelReq
{
    BOOL req = NO;
    BOOL notReq = NO;
    for (ConditionsModel *cpm in conditionsArray)
    {
        if ([cpm.condition isEqualToString:@"required"] && [cpm.beforeAfter isEqualToString:@"before"])
        {
            BOOL there = [elmArray containsObject:cpm.element];
            if (there) {
                int idx = [elmArray indexOfObject:cpm.element];
                ElementsModel *emc = [elementListArray objectAtIndex:idx];
                int ty = 10;
//                NSLog(@"%d %lu",emc.type,(unsigned long)idx);
                if (emc.type == ty) {
                    emc.req = NO;
                    notReq = YES;
                    [elementListArray replaceObjectAtIndex:idx withObject:emc];
                    [self setLabels:NO tag:emc.tag label:emc.promptText];

                }
                else
                {
                    
                    if (!(emc.req == YES))
                    {
                        require++;
                        emc.req = YES;
                        req = YES;
                        [elementListArray replaceObjectAtIndex:idx withObject:emc];
                        [self setLabels:YES tag:emc.tag label:emc.promptText];

                    }
                }
                
            }
            
        }
        if ([cpm.condition isEqualToString:@"notrequired"]&&[cpm.beforeAfter isEqualToString:@"before"])
        {
            BOOL there = [elmArray containsObject:cpm.element];
            if (there) {
                NSUInteger idx = [elmArray indexOfObject:cpm.element];
                ElementsModel *emc = [elementListArray objectAtIndex:idx];
                if (emc.req == YES) {
                    require--;
                    emc.req = NO;
                    notReq = YES;
                    [elementListArray replaceObjectAtIndex:idx withObject:emc];
                    [self setLabels:NO tag:emc.tag label:emc.promptText];

                }
            }
        }
    }

}

-(void)setLabels:(BOOL)req tag:(int)newTag label:(NSString *)newText
{

        UILabel *eleLabel = (UILabel *)[formCanvas viewWithTag:newTag-1];

        if (req == YES) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:@"*"];
            
            [eleLabel setText:[NSString stringWithFormat:@"%@ %@", newText,attributedString]];
            [eleLabel setText:[[eleLabel.text stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""]];
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc]  initWithAttributedString: eleLabel.attributedText];
            
            [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(text.length-2, 1)];
            [eleLabel setAttributedText: text];
        }
        else if (req == NO)
        {
            eleLabel.text = newText;
            
        }
}
-(void)setLabelReqAfter:(NSString *)newName tag:(int)newTag text:(NSString *)newText reqnot:(BOOL)newReq;
{
    BOOL req = newReq;
    UILabel *eleLabel = (UILabel *)[formCanvas viewWithTag:newTag-1];
    
    if (req == YES) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]  initWithString:@"*"];
        
        [eleLabel setText:[NSString stringWithFormat:@"%@ %@", newText,attributedString]];
        [eleLabel setText:[[eleLabel.text stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""]];
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc]  initWithAttributedString: eleLabel.attributedText];
        
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(text.length-2, 1)];
        [eleLabel setAttributedText: text];
    }
    else if (req == NO)
    {
        eleLabel.text = newText;
        UITextField *utf = (UITextField *)[formCanvas viewWithTag:newTag];
        utf.layer.borderWidth = 1.0f;
        utf.layer.borderColor = [[UIColor clearColor] CGColor];
        utf.layer.cornerRadius = 5;
        utf.clipsToBounds      = YES;
        [utf setAlpha:1.0f];
        
        
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
