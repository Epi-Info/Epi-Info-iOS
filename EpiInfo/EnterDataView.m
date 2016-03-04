//
//  EnterDataView.m
//  EpiInfo
//
//  Created by John Copeland on 12/19/13.
//

#import "EnterDataView.h"
//#import "QSEpiInfoService.h"
#import "DataEntryViewController.h"


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

- (void)setParentRecordGUID:(NSString *)prguid
{
    parentRecordGUID = prguid;
    
    int lengthOfCreateTableStatement = (int)[createTableStatement length];
    createTableStatement = [[createTableStatement substringToIndex:lengthOfCreateTableStatement - 1] stringByAppendingString:@",\nFKEY text)"];
}
- (NSString *)parentRecordGUID
{
    return parentRecordGUID;
}

- (NSString *)guidToSendToChild
{
    if (guidBeingUpdated)
        return guidBeingUpdated;
    else if (newRecordGUID)
        return newRecordGUID;
    else return @"";
}

- (void)setPageToDisplay:(int)pageNumber
{
    pageToDisplay = pageNumber;
}

- (BOOL)getIsFirstPage
{
    return isFirstPage;
}
-(BOOL)getIsLastPage
{
    return isLastPage;
}

- (void)setDictionaryOfPages:(NSMutableDictionary *)dop
{
    dictionaryOfPages = dop;
    [dictionaryOfPages setObject:self forKey:[NSString stringWithFormat:@"Page%d", pageToDisplay]];
}

- (UIView *)formCanvas
{
    return formCanvas;
}

- (void)setGuidBeingUpdated:(NSString *)gbu
{
    guidBeingUpdated = gbu;
    recordUIDForUpdate = gbu;
}

- (void)setPopulateInstructionCameFromLineList:(BOOL)yesNo
{
    populateInstructionCameFromLineList = yesNo;
}

- (void)setPageBeingDisplayed:(NSNumber *)page
{
    pageBeingDisplayed = page;
}
- (NSNumber *)pageBeingDisplayed
{
    return pageBeingDisplayed;
}

- (void)setMyOrangeBanner:(UIView *)mob
{
    myOrangeBanner = mob;
}
- (UIView *)myOrangeBanner
{
    return myOrangeBanner;
}

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
      newRecordGUID = CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
      
//      NSThread *guidThread = [[NSThread alloc] initWithTarget:self selector:@selector(logTheGUIDS) object:nil];
//      [guidThread start];
  }
  return self;
}

- (void)logTheGUIDS
{
    while (YES)
    {
        NSLog(@"newRecordGUID = %@", newRecordGUID);
        NSLog(@"guidBeingUpdated = %@", guidBeingUpdated);
        sleep(5);
        if (!self)
            break;
    }
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page
{
  self = [self initWithFrame:frame];
  
  if (self)
  {
    pageToDisplay = page;
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
    
    xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:self.url];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities:YES];
    
    xmlParser1 = [[NSXMLParser alloc] initWithContentsOfURL:self.url];
    [xmlParser1 setDelegate:self];
    [xmlParser1 setShouldResolveExternalEntities:YES];
    
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
    // New code for separating pages
    if (!isLastPage)
    {
        [submitButton setEnabled:NO];
    }
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
    
    // New code for separating pages
    previousPageButton = [[UIButton alloc] initWithFrame:CGRectMake(clearButton.frame.origin.x - 44, clearButton.frame.origin.y, 40, 40)];
    [previousPageButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [previousPageButton.layer setCornerRadius:4.0];
    [previousPageButton setTitle:@"Previous Page" forState:UIControlStateNormal];
    [previousPageButton setImage:[UIImage imageNamed:@"PreviousPage.png"] forState:UIControlStateNormal];
    [previousPageButton.layer setMasksToBounds:YES];
    [previousPageButton.layer setCornerRadius:4.0];
    [previousPageButton addTarget:self action:@selector(previousOrNextPageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [previousPageButton setTag:pageToDisplay - 1];
    [previousPageButton setHidden:YES];
    [self addSubview:previousPageButton];
    if (isFirstPage)
    {
        [previousPageButton setEnabled:NO];
    }
    else
    {
        [previousPageButton setEnabled:YES];
    }
    nextPageButton = [[UIButton alloc] initWithFrame:CGRectMake(submitButton.frame.origin.x + 124, submitButton.frame.origin.y, 40, 40)];
    [nextPageButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [nextPageButton.layer setCornerRadius:4.0];
    [nextPageButton setTitle:@"Next Page" forState:UIControlStateNormal];
    [nextPageButton setImage:[UIImage imageNamed:@"NextPage.png"] forState:UIControlStateNormal];
    [nextPageButton.layer setMasksToBounds:YES];
    [nextPageButton.layer setCornerRadius:4.0];
    [nextPageButton addTarget:self action:@selector(previousOrNextPageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [nextPageButton setTag:pageToDisplay + 1];
    [nextPageButton setHidden:YES];
    [self addSubview:nextPageButton];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [previousPageButton setFrame:CGRectMake(clearButton.frame.origin.x, clearButton.frame.origin.y + 42, 40, 40)];
        [nextPageButton setFrame:CGRectMake(submitButton.frame.origin.x + submitButton.frame.size.width - 40, submitButton.frame.origin.y + 42, 40, 40)];
//        contentSizeHeight += 42;
    }
    if (isLastPage)
    {
        [nextPageButton setEnabled:NO];
    }
    else
    {
        [nextPageButton setEnabled:YES];
    }
    
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
//    [resignAllButton addTarget:self action:@selector(userSwipedToTheRight) forControlEvents:UISwipeGestureRecognizerDirectionRight];
      UISwipeGestureRecognizer *leftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipedToTheLeft)];
      [leftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
      [leftRecognizer setNumberOfTouchesRequired:1];
      [resignAllButton addGestureRecognizer:leftRecognizer];
      UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(userSwipedToTheRight)];
      [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
      [rightRecognizer setNumberOfTouchesRequired:1];
      [resignAllButton addGestureRecognizer:rightRecognizer];
//    [resignAllButton addTarget:self action:@selector(userSwipedToTheLeft) forControlEvents:UISwipeGestureRecognizerDirectionLeft];
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
    [formCanvas setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:240/255.0 alpha:1.0]];
  }
  
  return self;
}

// New code for separating pages
- (void)userSwipedToTheLeft
{
    if ([nextPageButton isEnabled])
    {
        [self previousOrNextPageButtonPressed:nextPageButton];
    }
}
- (void)userSwipedToTheRight
{
    if ([previousPageButton isEnabled])
    {
        [self previousOrNextPageButtonPressed:previousPageButton];
    }
}
- (void)previousOrNextPageButtonPressed:(UIButton *)sender
{
    if (!dictionaryOfPages)
    {
        dictionaryOfPages = [[NSMutableDictionary alloc] init];
    }
    [dictionaryOfPages setObject:self forKey:[NSString stringWithFormat:@"Page%d", pageToDisplay]];
    if ([sender tag] < pageToDisplay)
    {
        [UIView transitionWithView:self.window
                          duration:0.4f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
                        }
                        completion:^(BOOL finished){
                            [self removeFromSuperview];
                        }];
    }
    else
    {
        [UIView transitionWithView:self.window
                          duration:0.4f
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                        }
                        completion:^(BOOL finished){
                            [self removeFromSuperview];
                        }];
    }
    [self resignAll];
    [self removeFromSuperview];
    [self setContentOffset:CGPointZero animated:NO];
    if ([dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]])
    {
        [self.rootViewController.view addSubview:[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]]];
        [self.rootViewController.view bringSubviewToFront:[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]]];
        [(EnterDataView *)[dictionaryOfPages objectForKey:[NSString stringWithFormat:@"Page%ld", (long)[sender tag]]] setGuidBeingUpdated:recordUIDForUpdate];
    }
    else
    {
        EnterDataView *edv = [[EnterDataView alloc] initWithFrame:self.frame AndURL:self.url AndRootViewController:self.rootViewController AndNameOfTheForm:self.nameOfTheForm AndPageToDisplay:(int)[sender tag]];
        [edv setDictionaryOfPages:dictionaryOfPages];
        [edv setGuidBeingUpdated:guidBeingUpdated];
        [edv setMyOrangeBanner:myOrangeBanner];
        if (guidBeingUpdated)
        {
            [edv populateFieldsWithRecord:@[tableBeingUpdated, guidBeingUpdated]];
        }
        [self.rootViewController.view addSubview:edv];
        [self.rootViewController.view bringSubviewToFront:edv];
    }
    for (UIView *v in [self.rootViewController.view subviews])
    {
        if ([[v backgroundColor] isEqual:[UIColor colorWithRed:221/255.0 green:85/225.0 blue:12/225.0 alpha:0.95]])
        {
            [self.rootViewController.view bringSubviewToFront:v];
            for (UIView *l in [v subviews])
            {
                if ([l isKindOfClass:[UILabel class]])
                {
                    [(UILabel *)l setText:[NSString stringWithFormat:@"%@, page %d of %lu", formName, (int)[sender tag], (unsigned long)[self pagesArray].count]];
                }
            }
        }
    }
}

- (id)initWithFrame:(CGRect)frame AndURL:(NSURL *)url AndRootViewController:(UIViewController *)rvc AndNameOfTheForm:(NSString *)notf AndPageToDisplay:(int)page
{
  self = [self initWithFrame:frame AndURL:url AndNameOfTheForm:(NSString *)notf AndPageToDisplay:page];
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
    // New code for separating pages
  if (!dictionaryOfPages)
  {
    dictionaryOfPages = [[NSMutableDictionary alloc] init];
  }
  [dictionaryOfPages setObject:self forKey:[NSString stringWithFormat:@"Page%d", pageToDisplay]];
  return self;
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

- (void)submitButtonPressed
{
  guidBeingUpdated = nil;
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
      // Switched from creating UID at submit time to load-form/clear-form time
//    NSString *recordUUID = CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
    NSString *valuesClause = [NSString stringWithFormat:@" values('%@'", newRecordGUID];
    BOOL valuesClauseBegun = YES;
      if (parentRecordGUID)
      {
          insertStatement = [insertStatement stringByAppendingString:@",\nFKEY"];
          valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@",\n'%@'", parentRecordGUID]];
      }
    NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
    [azureDictionary setObject:newRecordGUID forKey:@"id"];
      for (id key in dictionaryOfPages)
      {
          EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
          for (UIView *v in [[tempedv formCanvas] subviews])
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
              else if ([v isKindOfClass:[LegalValues class]])
              {
                  if (valuesClauseBegun)
                  {
                      insertStatement = [insertStatement stringByAppendingString:@",\n"];
                      valuesClause = [valuesClause stringByAppendingString:@",\n"];
                  }
                  valuesClauseBegun = YES;
                  insertStatement = [insertStatement stringByAppendingString:[(LegalValues *)v columnName]];
                  if ([[(LegalValues *)v picked] isEqualToString:@"NULL"])
                  {
                      valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"%@", @"NULL"]];
                  }
                  else
                  {
                      valuesClause = [valuesClause stringByAppendingString:[NSString stringWithFormat:@"'%@'", [(LegalValues *)v picked]]];
                      [azureDictionary setObject:[NSNumber numberWithFloat:(float)[(LegalValues *)v selectedIndex].intValue] forKey:[(LegalValues *)v columnName]];
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

- (void)updateButtonPressed
{
  guidBeingUpdated = nil;
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
      for (id key in dictionaryOfPages)
      {
          EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
          for (UIView *v in [[tempedv formCanvas] subviews])
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
              else if ([v isKindOfClass:[LegalValues class]])
              {
                  if (valuesClauseBegun)
                  {
                      insertStatement = [insertStatement stringByAppendingString:@",\n"];
                      valuesClause = [valuesClause stringByAppendingString:@",\n"];
                  }
                  valuesClauseBegun = YES;
                  insertStatement = [insertStatement stringByAppendingString:[(LegalValues *)v columnName]];
                  if ([[(LegalValues *)v picked] isEqualToString:@"NULL"])
                  {
                      insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = %@", @"NULL"]];
                  }
                  else
                  {
                      insertStatement = [insertStatement stringByAppendingString:[NSString stringWithFormat:@" = '%@'", [(LegalValues *)v picked]]];
                      [azureDictionary setObject:[NSNumber numberWithFloat:(float)[(LegalValues *)v selectedIndex].intValue] forKey:[(LegalValues *)v columnName]];
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
    updatevisibleScreenOnly = NO;
  
  [self.superview addSubview:bv];
    NSLog(@"Superview == %@", self.superview);
    [self clearButtonPressed];
  [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
    [bv setFrame:CGRectMake(0, 0, self.superview.frame.size.width, self.superview.frame.size.width)];
    [areYouSure setFrame:CGRectMake(10, 10, bv.frame.size.width - 20, 72)];
    [uiaiv setFrame:CGRectMake(bv.frame.size.width / 2.0 - 20.0, bv.frame.size.height / 2.0 - 60.0, 40, 40)];
    [okButton setFrame:CGRectMake(bv.frame.size.width / 2.0 - 60.0, bv.frame.size.height / 2.0 - 22.0, 120, 40)];
  } completion:^(BOOL finished){
  }];
}

- (void)deleteButtonPressed
{
  guidBeingUpdated = nil;
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
    updatevisibleScreenOnly = NO;
    [self clearButtonPressed];
  
  [((EnterDataView *)[dictionaryOfPages objectForKey:@"Page1"]).superview addSubview:bv];
    NSLog(@"Superview == %@", ((EnterDataView *)[dictionaryOfPages objectForKey:@"Page1"]).superview);
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
  [self resignAll];
  
  for (id v in [formCanvas subviews])
    if (![v isKindOfClass:[UILabel class]])
      [v setEnabled:NO];
  
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
- (void)doNotSubmitOrClear
{
  for (UIView *v in [self.superview subviews])
  {
    if ([v isKindOfClass:[BlurryView class]])
    {
      [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [v setFrame:CGRectMake(0, self.superview.frame.size.height, v.frame.size.width, v.frame.size.width)];
      } completion:^(BOOL finished){
        [v removeFromSuperview];
      }];
    }
  }
    for (id v in [formCanvas subviews])
        if (![v isKindOfClass:[UILabel class]])
            [v setEnabled:YES];
}
- (void)clearButtonPressed
{
    // New code for separating pages
    guidBeingUpdated = nil;
    newRecordGUID = CFBridgingRelease(CFUUIDCreateString(NULL, CFUUIDCreate(NULL)));
    for (id key in dictionaryOfPages)
    {
        if (updatevisibleScreenOnly && ![(NSString *)key isEqualToString:[NSString stringWithFormat:@"Page%d", pageToDisplay]])
            continue;
        EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
        if ([(NSString *)key isEqualToString:@"Page1"])
            [[self superview] addSubview:tempedv];
        else if (!populateInstructionCameFromLineList)
            [tempedv removeFromSuperview];
        for (UIView *v in [self.rootViewController.view subviews])
        {
            if ([[v backgroundColor] isEqual:[UIColor colorWithRed:221/255.0 green:85/225.0 blue:12/225.0 alpha:0.95]] && v == myOrangeBanner)
            {
                [self.rootViewController.view bringSubviewToFront:v];
                for (UIView *l in [v subviews])
                {
                    if ([l isKindOfClass:[UILabel class]])
                    {
                        [(UILabel *)l setText:[NSString stringWithFormat:@"%@, page 1 of %lu", formName, (unsigned long)[self pagesArray].count]];
                    }
                }
            }
        }
        
        for (id v in [[tempedv formCanvas] subviews])
        {
            if ([v isKindOfClass:[UITextField class]])
                [(UITextField *)v setText:nil];
            else if ([v isKindOfClass:[UITextView class]])
                [(UITextView *)v setText:nil];
            else if ([v isKindOfClass:[YesNo class]])
                [(YesNo *)v reset];
            else if ([v isKindOfClass:[LegalValues class]])
                [(LegalValues *)v reset];
            else if ([v isKindOfClass:[Checkbox class]])
                [(Checkbox *)v reset];
            [v setEnabled:YES];
        }
        [tempedv resignAll];
        [tempedv setContentOffset:CGPointZero animated:YES];
        [self doNotSubmitOrClear];
        //    [self.locationManager stopUpdatingLocation];
        //    [self getMyLocation];
        for (UIView *v in [tempedv subviews])
        {
            if ([v isKindOfClass:[UIButton class]])
            {
                if ([(UIButton *)v tag] == 8 && v.frame.size.width > 40)
                {
                    [(UIButton *)v setTag:1];
                    [(UIButton *)v setImage:[UIImage imageNamed:@"SubmitButton.png"] forState:UIControlStateNormal];
                }
                if ([(UIButton *)v tag] == 7 && v.frame.size.width > 40)
                {
                    [(UIButton *)v setHidden:YES];
                }
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

- (void)resignAll
{
  for (id v in [formCanvas subviews])
  {
    if ([v isKindOfClass:[UITextField class]] && [v isFirstResponder])
    {
      [(UITextField *)v resignFirstResponder];
      [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
      } completion:^(BOOL finished){
        hasAFirstResponder = NO;
      }];
    }
    else if ([v isKindOfClass:[UITextView class]] && [v isFirstResponder])
    {
      [(UITextView *)v resignFirstResponder];
      [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
      } completion:^(BOOL finished){
        hasAFirstResponder = NO;
      }];
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

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
  NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
  [nsnf setMaximumFractionDigits:6];
  
  dataText = [dataText stringByAppendingString:[NSString stringWithFormat:@"\n%@", elementName]];
  
  if (firstParse)
  {
    //        int pageNo = 0;
    if ([elementName isEqualToString:@"Page"])
    {
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
        NSString *checkCodeString = [attributeDict objectForKey:@"CheckCode"];
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
        while ((int)[checkCodeString rangeOfString:@"//"].location >= 0 && (int)[checkCodeString rangeOfString:@"//"].location < checkCodeString.length)
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
            if (endfieldrange.location > checkCodeString.length)
                break;
//          NSLog(@"\n%@", [[checkCodeString substringToIndex:endfieldrange.location] substringFromIndex:fieldrange.location + fieldrange.length]);
          NSArray *wordsArray = [[[[checkCodeString substringToIndex:endfieldrange.location] substringFromIndex:fieldrange.location + fieldrange.length] stringByReplacingOccurrencesOfString:@"\t" withString:@""] componentsSeparatedByString:@"\n"];
//          NSLog(@"%@", wordsArray);
          [self.dictionaryOfWordsArrays setObject:wordsArray forKey:(NSString *)[wordsArray objectAtIndex:0]];
          checkCodeString = [checkCodeString substringFromIndex:endfieldrange.location + endfieldrange.length];
        }
      }
    }
      // New code for separating pages
    if ([elementName isEqualToString:@"Page"])
    {
        NSString *pageNo = [attributeDict objectForKey:@"PageId"];
        int pageNumber = [pageNo intValue];
        NSLog(@"Page %d", pageNumber);
        isFirstPage = (pageToDisplay == 1);
        isLastPage = YES;
        if (pageNumber == pageToDisplay)
        {
            isCurrentPage = YES;
            NSLog(@"PageId attribute (%d) equals pageToDisplay(%d)", pageNumber, pageToDisplay);
        }
        else if (pageNumber == pageToDisplay + 1)
        {
            isCurrentPage = NO;
            isLastPage = NO;
            NSLog(@"PageId attribute (%d) is the next page", pageNumber);
        }
        else if (pageNumber == pageToDisplay - 1)
        {
            isCurrentPage = NO;
            NSLog(@"PageId attribute (%d) is the previous page", pageNumber);
        }
        else
        {
            isCurrentPage = NO;
            NSLog(@"PageId attribute (%d) is neither the next or the previous page", pageNumber);
        }
    }
      // New code for separating pages
    if ([elementName isEqualToString:@"Field"] && isCurrentPage)
    {
      if (beginColumList)
        commaOrParen = @",";
      else
        commaOrParen = @",";
      
      float elementLabelHeight = 40.0;
      
      UILabel *elementLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, contentSizeHeight, self.frame.size.width - 40, 40)];
      [elementLabel setText:[NSString stringWithFormat:@"%@", [attributeDict objectForKey:@"PromptText"]]];
      [elementLabel setTextAlignment:NSTextAlignmentLeft];
      [elementLabel setNumberOfLines:0];
      [elementLabel setLineBreakMode:NSLineBreakByWordWrapping];
      float fontsize = 14.0;
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        fontsize = 24.0;
      [elementLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontsize]];
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
        LegalValues *lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
          [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
        [formCanvas addSubview:lv];
        contentSizeHeight += 160;
        createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
        [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
        [lv setColumnName:[attributeDict objectForKey:@"Name"]];
        // Add the array of values to the root view controller's legal values dictionary
          if ([legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]])
          {
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
        LegalValues *lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 300, 180) AndListOfValues:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]]];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
          [lv setFrame:CGRectMake(20, lv.frame.origin.y, lv.frame.size.width, lv.frame.size.height)];
        [formCanvas addSubview:lv];
        contentSizeHeight += 160;
        createTableStatement = [createTableStatement stringByAppendingString:[NSString stringWithFormat:@"%@\n%@ text", commaOrParen, [attributeDict objectForKey:@"Name"]]];
        [alterTableElements setObject:@"text" forKey:[attributeDict objectForKey:@"Name"]];
        [lv setColumnName:[attributeDict objectForKey:@"Name"]];
          if ([legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]])
          {
              [legalValuesDictionaryForRVC setObject:[legalValuesDictionary objectForKey:[attributeDict objectForKey:@"SourceTableName"]] forKey:[lv.columnName lowercaseString]];
          }
        beginColumList = YES;
        [self.dictionaryOfFields setObject:lv forKey:[attributeDict objectForKey:@"Name"]];
      }
      else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"14"])
      {
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(10, contentSizeHeight + 40, 60, 60)];
        [iv setImage:[UIImage imageNamed:@"PhoneRH"]];
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
      else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"20"])
      {
          RelateButton *tf = [[RelateButton alloc] initWithFrame:CGRectMake(20, contentSizeHeight + 40, 240, 40)];
          [tf.layer setCornerRadius:4.0];
          [tf setTitle:[attributeDict objectForKey:@"PromptText"] forState:UIControlStateNormal];
          if ([attributeDict objectForKey:@"RelatedViewName"])
              [tf setRelatedViewName:[attributeDict objectForKey:@"RelatedViewName"]];
          else
              [tf setEnabled:NO];
          [tf setParentEDV:self];
          [formCanvas addSubview:tf];
          contentSizeHeight += 40.0;
          [elementLabel setHidden:YES];
      }
      else if ([[attributeDict objectForKey:@"FieldTypeId"] isEqualToString:@"21"])
      {
          contentSizeHeight -= 25.0;
      }
      else
      {
        //                                NSLog(@"%@", [attributeDict objectForKey:@"FieldTypeId"]);
          [elementLabel setHidden:YES];
      }
      contentSizeHeight += 60.0;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
    [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
  } completion:^(BOOL finished){
    hasAFirstResponder = NO;
  }];
  return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  if (hasAFirstResponder)
    return YES;
  
  [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height + 200.0)];
  hasAFirstResponder = YES;
  
  return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
  if (hasAFirstResponder)
    return YES;
  
  [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height + 200.0)];
  hasAFirstResponder = YES;
  
  return YES;
}

- (void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID
{
  updatevisibleScreenOnly = NO;
  if (guidBeingUpdated)
    updatevisibleScreenOnly = YES;
  [self clearButtonPressed];
  if (geocodingCheckbox)
    [geocodingCheckbox reset];
  
  queriedColumnsAndValues = [[NSMutableDictionary alloc] init];
  
  NSString *tableName = [tableNameAndGUID objectAtIndex:0];
  NSString *guid = [tableNameAndGUID objectAtIndex:1];
  guidBeingUpdated = guid;
    newRecordGUID = nil;
  tableBeingUpdated = tableName;
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
  
  // New code for separating pages
  for (id key in dictionaryOfPages)
  {
      if (updatevisibleScreenOnly && ![(NSString *)key isEqualToString:[NSString stringWithFormat:@"Page%d", pageToDisplay]])
          continue;
      
      EnterDataView *tempedv = (EnterDataView *)[dictionaryOfPages objectForKey:key];
      for (UIView *v in [[tempedv formCanvas] subviews])
      {
          if ([v isKindOfClass:[EpiInfoTextField class]])
              [(EpiInfoTextField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(EpiInfoTextField *)v columnName] lowercaseString]]];
          else if ([v isKindOfClass:[EpiInfoTextView class]])
              [(EpiInfoTextView *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(EpiInfoTextView *)v columnName] lowercaseString]]];
          else if ([v isKindOfClass:[Checkbox class]])
              [(Checkbox *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(Checkbox *)v columnName] lowercaseString]]];
          else if ([v isKindOfClass:[YesNo class]])
              [(YesNo *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(YesNo *)v columnName] lowercaseString]]];
          else if ([v isKindOfClass:[NumberField class]])
              [(NumberField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(NumberField *)v columnName] lowercaseString]]];
          else if ([v isKindOfClass:[PhoneNumberField class]])
              [(PhoneNumberField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(PhoneNumberField *)v columnName] lowercaseString]]];
          else if ([v isKindOfClass:[DateField class]])
              [(DateField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(DateField *)v columnName] lowercaseString]]];
          else if ([v isKindOfClass:[UppercaseTextField class]])
              [(UppercaseTextField *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(UppercaseTextField *)v columnName] lowercaseString]]];
          else if ([v isKindOfClass:[LegalValues class]])
          {
              [(LegalValues *)v setFormFieldValue:(NSString *)[queriedColumnsAndValues objectForKey:[[(LegalValues *)v columnName] lowercaseString]]];
              [(LegalValues *)v setPicked:(NSString *)[queriedColumnsAndValues objectForKey:[[(LegalValues *)v columnName] lowercaseString]]];
          }
          else
              continue;
      }
      for (UIView *v in [tempedv subviews])
      {
          if ([v isKindOfClass:[UIButton class]])
          {
              if ([(UIButton *)v tag] == 1 && v.frame.size.width > 40)
              {
                  [(UIButton *)v setTag:8];
                  [(UIButton *)v setImage:[UIImage imageNamed:@"UpdateButton.png"] forState:UIControlStateNormal];
              }
              if ([(UIButton *)v tag] == 7 && v.frame.size.width > 40)
              {
                  [(UIButton *)v setHidden:NO];
              }
          }
      }
  }
}

- (void)fieldBecameFirstResponder:(id)field
{
  if ([field isKindOfClass:[DateField class]])
  {
    [self resignAll];
    DateField *dateField = (DateField *)field;
    NSLog(@"%@ became first responder", [dateField columnName]);
  }
}

- (void)fieldResignedFirstResponder:(id)field
{
  if ([field isKindOfClass:[DateField class]])
  {
    DateField *dateField = (DateField *)field;
    NSLog(@"%@ resigned first responder", [dateField columnName]);
  }
}

- (void)checkboxChanged:(Checkbox *)checkbox
{
  NSLog(@"%@ changed", [checkbox columnName]);
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
