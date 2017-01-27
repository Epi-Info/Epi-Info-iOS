//
//  DataEntryViewController.m
//  EpiInfo
//
//  Created by John Copeland on 11/27/13.
//

//#import "QSEpiInfoService.h"
#import "DataEntryViewController.h"
#import "ConverterMethods.h"


#pragma mark * Private Interface


@interface DataEntryViewController ()

// Private properties
//@property (strong, nonatomic)   QSEpiInfoService   *epiinfoService;
@property (nonatomic)           BOOL            useRefreshControl;

@end


#pragma mark * Implementation


@implementation DataEntryViewController
//@synthesize epiinfoService = _epiinfoService;
@synthesize legalValuesDictionary = _legalValuesDictionary;
@synthesize fieldsAndStringValues = _fieldsAndStringValues;

- (NSMutableArray *)formNavigationItems
{
    return formNavigationItems;
}
- (NSMutableArray *)closeFormBarButtonItems
{
    return closeFormBarButtonItems;
}
- (NSMutableArray *)deleteRecordBarButtonItems
{
    return deleteRecordBarButtonItems;
}

- (void)setUpdateExistingRecord:(BOOL)uer
{
    updatingExistingRecord = uer;
}

- (UIButton *)openButton
{
    return openButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    updatingExistingRecord = NO;
    [self setTitle:@""];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"] withIntermediateDirectories:NO attributes:nil error:nil];
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        
        int tableAlreadyExists = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(name) as n from sqlite_master where name = '%@'", @"Sample_EColiFoodHistory"];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                {
                    tableAlreadyExists = sqlite3_column_int(statement, 0);
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (tableAlreadyExists == 0)
        {
            NSThread *createEcoliFoodHistorySampleTableThread = [[NSThread alloc] initWithTarget:self selector:@selector(createEColiFoodHistorySampleTable) object:nil];
            [createEcoliFoodHistorySampleTableThread start];
        }
    }
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Change the standard NavigationController "Back" button to an "X"
        customBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [customBackButton setImage:[UIImage imageNamed:@"StAndrewXButtonWhite.png"] forState:UIControlStateNormal];
        [customBackButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
        [customBackButton.layer setMasksToBounds:YES];
        [customBackButton.layer setCornerRadius:8.0];
        [customBackButton setTitle:@"Back to previous screen" forState:UIControlStateNormal];
//        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customBackButton]];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        backToMainMenu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(popCurrentViewController)];
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        fadingColorView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [fadingColorView setImage:[UIImage imageNamed:@"iPadBackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            NSLog(@"%@", [paths objectAtIndex:0]);
            UILabel *enterDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, self.view.frame.size.width - 40, 28)];
            [enterDataLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [enterDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [enterDataLabel setText:@"Epi Info Enter Data"];
            [enterDataLabel setBackgroundColor:[UIColor clearColor]];
            [enterDataLabel setTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:enterDataLabel];
            
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 28)];
            [pickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [pickerLabel setText:@"No forms found on this device."];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:pickerLabel];
            UILabel *altPickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 28)];
            [altPickerLabel setTextColor:[UIColor whiteColor]];
            [altPickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [altPickerLabel setText:@"No forms found on this device."];
            [altPickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:altPickerLabel];
            [altPickerLabel setAlpha:0.0];
            
            lvSelected = [[UITextField alloc] init];
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 40, 300, 180) AndListOfValues:[[NSMutableArray alloc] init] AndTextFieldToUpdate:lvSelected];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 207, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonOrange.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton setTag:1];
            [openButton addTarget:self action:@selector(openButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            [openButton setEnabled:NO];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 207, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Triple tap to manage." forState:UIControlStateNormal];
            [manageButton setImage:[UIImage imageNamed:@"ManageButtonOrange.png"] forState:UIControlStateNormal];
            [manageButton.layer setMasksToBounds:YES];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [manageButton.layer setBorderWidth:1.0];
            [manageButton addTarget:self action:@selector(manageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:manageButton];
            [manageButton setEnabled:NO];
           
            [self.view sendSubviewToBack:pickerLabel];
            [self.view sendSubviewToBack:lv];
            
            NSThread *noFormsThread = [[NSThread alloc] initWithTarget:self selector:@selector(noFormsFound:) object:altPickerLabel];
            [noFormsThread start];
        }
        else if ([[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] error:nil].count == 0)
        {
            NSLog(@"%@", [paths objectAtIndex:0]);
            UILabel *enterDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, self.view.frame.size.width - 40, 28)];
            [enterDataLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [enterDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [enterDataLabel setText:@"Epi Info Enter Data"];
            [enterDataLabel setBackgroundColor:[UIColor clearColor]];
            [enterDataLabel setTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:enterDataLabel];
            
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 28)];
            [pickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [pickerLabel setText:@"No forms found on this device."];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:pickerLabel];
            UILabel *altPickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 28)];
            [altPickerLabel setTextColor:[UIColor whiteColor]];
            [altPickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [altPickerLabel setText:@"No forms found on this device."];
            [altPickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:altPickerLabel];
            [altPickerLabel setAlpha:0.0];
            
            lvSelected = [[UITextField alloc] init];
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 40, 300, 180) AndListOfValues:[[NSMutableArray alloc] init] AndTextFieldToUpdate:lvSelected];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 207, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonOrange.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton setTag:1];
            [openButton addTarget:self action:@selector(openButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            [openButton setEnabled:NO];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 207, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Triple tap to manage." forState:UIControlStateNormal];
            [manageButton setImage:[UIImage imageNamed:@"ManageButtonOrange.png"] forState:UIControlStateNormal];
            [manageButton.layer setMasksToBounds:YES];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [manageButton.layer setBorderWidth:1.0];
            [manageButton addTarget:self action:@selector(manageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:manageButton];
            [manageButton setEnabled:NO];
            
            [self.view sendSubviewToBack:pickerLabel];
            [self.view sendSubviewToBack:lv];
            
            NSThread *noFormsThread = [[NSThread alloc] initWithTarget:self selector:@selector(noFormsFound:) object:altPickerLabel];
            [noFormsThread start];
        }
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
            UILabel *enterDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, self.view.frame.size.width - 40, 28)];
            [enterDataLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [enterDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
            [enterDataLabel setText:@"Epi Info Enter Data"];
            [enterDataLabel setBackgroundColor:[UIColor clearColor]];
            [enterDataLabel setTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:enterDataLabel];
            
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, 280, 28)];
            [pickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
            [pickerLabel setText:@"Select a form:"];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:pickerLabel];
            
            lvSelected = [[UITextField alloc] init];
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 40, 300, 180) AndListOfValues:pickerFiles AndTextFieldToUpdate:lvSelected];
            [lv.picker selectRow:selectedindex inComponent:0 animated:YES];
            [self.view addSubview:lv];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 207, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonWhite.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton setTag:1];
            [openButton addTarget:self action:@selector(openButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 207, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Triple tap to manage." forState:UIControlStateNormal];
            [manageButton setImage:[UIImage imageNamed:@"ManageButtonWhite.png"] forState:UIControlStateNormal];
            [manageButton.layer setMasksToBounds:YES];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [manageButton.layer setBorderWidth:1.0];
            [manageButton addTarget:self action:@selector(manageButtonPressed) forControlEvents:UIControlEventTouchDownRepeat];
            [self.view addSubview:manageButton];
            
            [self.view sendSubviewToBack:pickerLabel];
            [self.view sendSubviewToBack:lv];
        }
    }
    else
    {
        customBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [customBackButton setImage:[UIImage imageNamed:@"StAndrewXButtonWhite.png"] forState:UIControlStateNormal];
        [customBackButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
        [customBackButton.layer setMasksToBounds:YES];
        [customBackButton.layer setCornerRadius:8.0];
        [customBackButton setTitle:@"Back to previous screen" forState:UIControlStateNormal];
//        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customBackButton]];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        backToMainMenu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(popCurrentViewController)];
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];

        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        if (self.view.frame.size.height > 500)
        {
            [fadingColorView setFrame:CGRectMake(0, 0, 320, 504)];
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5BackgroundWhite.png"]];
            [fadingColorView setTag:5];
        }
        else
        {
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4BackgroundWhite.png"]];
            [fadingColorView setTag:4];
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            NSLog(@"%@", [paths objectAtIndex:0]);
            UILabel *enterDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 280, 28)];
            [enterDataLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [enterDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [enterDataLabel setText:@"Epi Info Enter Data"];
            [enterDataLabel setBackgroundColor:[UIColor clearColor]];
            [enterDataLabel setTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:enterDataLabel];
            
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + 20, 280, 28)];
            [pickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
            [pickerLabel setText:@"No forms found on this device."];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:pickerLabel];
            UILabel *altPickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + 20, 280, 28)];
            [altPickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [altPickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [altPickerLabel setText:@"No forms found on this device."];
            [altPickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:altPickerLabel];
            [altPickerLabel setAlpha:0.0];
            
            lvSelected = [[UITextField alloc] init];
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 15 + 20, 300, 180) AndListOfValues:[[NSMutableArray alloc] init] AndTextFieldToUpdate:lvSelected];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 182 + 20, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonWhite.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton setTag:1];
            [openButton addTarget:self action:@selector(openButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 182 + 20, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Triple tap to manage." forState:UIControlStateNormal];
            [manageButton setImage:[UIImage imageNamed:@"ManageButtonWhite.png"] forState:UIControlStateNormal];
            [manageButton.layer setMasksToBounds:YES];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [manageButton.layer setBorderWidth:1.0];
            [manageButton addTarget:self action:@selector(manageButtonPressed) forControlEvents:UIControlEventTouchDownRepeat];
            [self.view addSubview:manageButton];
            [manageButton setEnabled:NO];
            
            [self.view sendSubviewToBack:pickerLabel];
            [self.view sendSubviewToBack:lv];
            
            NSThread *noFormsThread = [[NSThread alloc] initWithTarget:self selector:@selector(noFormsFound:) object:altPickerLabel];
            [noFormsThread start];
        }
        else if ([[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] error:nil].count == 0)
        {
            NSLog(@"%@", [paths objectAtIndex:0]);
            UILabel *enterDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 280, 28)];
            [enterDataLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [enterDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [enterDataLabel setText:@"Epi Info Enter Data"];
            [enterDataLabel setBackgroundColor:[UIColor clearColor]];
            [enterDataLabel setTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:enterDataLabel];
            
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + 20, 280, 28)];
            [pickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
            [pickerLabel setText:@"No forms found on this device."];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:pickerLabel];
            UILabel *altPickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + 20, 280, 28)];
            [altPickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [altPickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [altPickerLabel setText:@"No forms found on this device."];
            [altPickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:altPickerLabel];
            [altPickerLabel setAlpha:0.0];
            
            lvSelected = [[UITextField alloc] init];
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 15 + 20, 300, 180) AndListOfValues:[[NSMutableArray alloc] init] AndTextFieldToUpdate:lvSelected];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 182 + 20, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonWhite.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton setTag:1];
            [openButton addTarget:self action:@selector(openButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 182 + 20, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Triple tap to manage." forState:UIControlStateNormal];
            [manageButton setImage:[UIImage imageNamed:@"ManageButtonWhite.png"] forState:UIControlStateNormal];
            [manageButton.layer setMasksToBounds:YES];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [manageButton.layer setBorderWidth:1.0];
            [manageButton addTarget:self action:@selector(manageButtonPressed) forControlEvents:UIControlEventTouchDownRepeat];
            [self.view addSubview:manageButton];
            [manageButton setEnabled:NO];
            
            [self.view sendSubviewToBack:pickerLabel];
            [self.view sendSubviewToBack:lv];
            
            NSThread *noFormsThread = [[NSThread alloc] initWithTarget:self selector:@selector(noFormsFound:) object:altPickerLabel];
            [noFormsThread start];
        }
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]] && [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"] error:nil].count > 0)
        {
            int selectedindex = 0;
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
            UILabel *enterDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 280, 28)];
            [enterDataLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [enterDataLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [enterDataLabel setText:@"Epi Info Enter Data"];
            [enterDataLabel setBackgroundColor:[UIColor clearColor]];
            [enterDataLabel setTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:enterDataLabel];
            
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + 20, 280, 28)];
            [pickerLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0]];
            [pickerLabel setText:@"Select a form:"];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [pickerLabel setTextAlignment:NSTextAlignmentCenter];
            [self.view addSubview:pickerLabel];
            
            lvSelected = [[UITextField alloc] init];
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 15 + 20, 300, 180) AndListOfValues:pickerFiles AndTextFieldToUpdate:lvSelected];
            [lv.picker selectRow:selectedindex inComponent:0 animated:YES];
            [self.view addSubview:lv];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 182 + 20, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonWhite.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton setTag:1];
            [openButton addTarget:self action:@selector(openButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 182 + 20, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Triple tap to manage." forState:UIControlStateNormal];
            [manageButton setImage:[UIImage imageNamed:@"ManageButtonWhite.png"] forState:UIControlStateNormal];
            [manageButton.layer setMasksToBounds:YES];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [manageButton.layer setBorderWidth:1.0];
            [manageButton addTarget:self action:@selector(manageButtonPressed) forControlEvents:UIControlEventTouchDownRepeat];
            [self.view addSubview:manageButton];
            
            [self.view sendSubviewToBack:pickerLabel];
            [self.view sendSubviewToBack:lv];
        }
    }
    mailComposerShown = NO;
}

- (void)noFormsFound:(UILabel *)newLabel
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [pickerLabel setAlpha:0.0];
        [newLabel setAlpha:1.0];
        [openButton setEnabled:NO];
        [manageButton setEnabled:NO];
    } completion:^(BOOL finished){
    }];
}
- (void)reshowPickerLabel
{
}

- (void)viewDidAppear:(BOOL)animated
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        } completion:^(BOOL finished){
        }];
        [self.view bringSubviewToFront:pickerLabel];
        [self.view bringSubviewToFront:lv];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        } completion:^(BOOL finished){
        }];
        [self.view bringSubviewToFront:pickerLabel];
        [self.view bringSubviewToFront:lv];
    }
//    Commented lines were used to create a screenshot image.
//    UIView *tmpV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//    
//    UIImageView *barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.navigationController.navigationBar.bounds.size.height)];
//    UIGraphicsBeginImageContext(self.navigationController.navigationBar.bounds.size);
//    [self.navigationController.navigationBar.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *bar = UIGraphicsGetImageFromCurrentImageContext();
//    [barView setImage:bar];
//    UIGraphicsEndImageContext();
//    
//    UIImageView *screenView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height + 40)];
//    UIGraphicsBeginImageContext(screenView.bounds.size);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screen = UIGraphicsGetImageFromCurrentImageContext();
//    [screenView setImage:screen];
//    UIGraphicsEndImageContext();
//    
//    [tmpV addSubview:barView];
//    [tmpV addSubview:screenView];
//    
//    UIGraphicsBeginImageContext(CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + self.navigationController.navigationBar.bounds.size.height));
//    [tmpV.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *imageToSave = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    NSData *imageData = UIImagePNGRepresentation(imageToSave);
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/EntryPad.png" atomically:YES];
//    To here
//
//     Example of how to email an attachment: (class must be <MFMailComposeViewControllerDelegate> for this to work)
//    if (!mailComposerShown)
//    {
//        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
//        [composer setMailComposeDelegate:self];
//        NSData *picData = UIImagePNGRepresentation(imageToSave);
//        [composer addAttachmentData:picData mimeType:@"image/png" fileName:@"Entry5.png"];
//        [composer setSubject:@"Screenshot"];
//        [composer setMessageBody:@"Screenshot of \"Enter Data\" screen." isHTML:NO];
//        [self presentViewController:composer animated:YES completion:^(void){
//            mailComposerShown = YES;
//        }];
//    }
}

// <MFMailComposeViewControllerDelegate> delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
//            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
//            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    mailComposerShown = NO;
}

- (void)manageButtonPressed
{
    if (lv.selectedIndex.intValue == 0)
        return;
    NSString *message = [NSString stringWithFormat:@"Delete table %@ and all of its data? (Double-tap \"Yes\" to delete.)", lvSelected.text];
    
    BlurryView *manageView = [[BlurryView alloc] initWithFrame:CGRectMake(0, -manageButton.frame.origin.y - manageButton.frame.size.height - 10.0, self.view.frame.size.width, manageButton.frame.origin.y + manageButton.frame.size.height + 10.0)];
    [manageView setBackgroundColor:[UIColor whiteColor]];
    [manageView setAlpha:0.96];
    [self.view addSubview:manageView];
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, manageView.frame.size.width - 20, 40.0)];
    [messageLabel setText:message];
    [messageLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [messageLabel setTextAlignment:NSTextAlignmentLeft];
    [messageLabel setNumberOfLines:0];
    [messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [manageView addSubview:messageLabel];
    
    UIButton *confirmDeleteForm = [[UIButton alloc] initWithFrame:CGRectMake(20, manageView.frame.size.height / 2.0, 120, 40)];
    [confirmDeleteForm setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [confirmDeleteForm.layer setCornerRadius:4.0];
    [confirmDeleteForm setTitle:@"Yes. Triple tap to confirm." forState:UIControlStateNormal];
    [confirmDeleteForm setImage:[UIImage imageNamed:@"YesButtonOrange.png"] forState:UIControlStateNormal];
    [confirmDeleteForm.layer setMasksToBounds:YES];
    [confirmDeleteForm.layer setCornerRadius:4.0];
    [confirmDeleteForm.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [confirmDeleteForm.layer setBorderWidth:1.0];
    [confirmDeleteForm addTarget:self action:@selector(confirmDeleteFormPressed:) forControlEvents:UIControlEventTouchDownRepeat];
    [confirmDeleteForm setTag:lv.selectedIndex.integerValue];
    [manageView addSubview:confirmDeleteForm];
    
    UIButton *cancleDeleteForm = [[UIButton alloc] initWithFrame:CGRectMake(160, manageView.frame.size.height / 2.0, 120, 40)];
    [cancleDeleteForm setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [cancleDeleteForm.layer setCornerRadius:4.0];
    [cancleDeleteForm setTitle:@"No" forState:UIControlStateNormal];
    [cancleDeleteForm setImage:[UIImage imageNamed:@"NoButtonOrange.png"] forState:UIControlStateNormal];
    [cancleDeleteForm.layer setMasksToBounds:YES];
    [cancleDeleteForm.layer setCornerRadius:4.0];
    [cancleDeleteForm.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [cancleDeleteForm.layer setBorderWidth:1.0];
    [cancleDeleteForm addTarget:self action:@selector(cancelDeleteFormPressed:) forControlEvents:UIControlEventTouchUpInside];
    [manageView addSubview:cancleDeleteForm];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [manageView setFrame:CGRectMake(0, 0, self.view.frame.size.width, manageButton.frame.origin.y + manageButton.frame.size.height + 10.0)];
    } completion:^(BOOL finished){
    }];
}

- (void)confirmDeleteFormPressed:(UIButton *)sender
{
    UIView *manageView = [sender superview];
    
    int deletedIndex = (int)[sender tag];
    NSMutableArray *newArrayOfForms = [NSMutableArray arrayWithArray:[lv listOfValues]];
    [newArrayOfForms removeObjectAtIndex:deletedIndex];
    [lv setListOfValues:newArrayOfForms];
    [lv.picker selectRow:0 inComponent:0 animated:NO];
    [lv setSelectedIndex:0];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fileToRemove = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms/"] stringByAppendingString:lvSelected.text] stringByAppendingString:@".xml"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileToRemove])
    {
        // Remove the template file
        NSFileManager *nsfm = [NSFileManager defaultManager];
        NSError *nse;
        [nsfm removeItemAtPath:fileToRemove error:&nse];
        
        // Drop the data table
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase"]])
        {
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
            
            //Convert the databasePath NSString to a char array
            const char *dbpath = [databasePath UTF8String];
            
            //Open sqlite3 analysisDB pointing to the databasePath
            if (sqlite3_open(dbpath, &epiinfoDB) == SQLITE_OK)
            {
                char *errMsg;
                //Build the DROP TABLE statement
                //Convert the sqlStmt to char array
                const char *sql_stmt = [[NSString stringWithFormat:@"drop table %@", lvSelected.text] UTF8String];
                
                //Execute the DROP TABLE statement
                if (sqlite3_exec(epiinfoDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
                {
                    NSLog(@"Failed to drop table: %s :::: %s", errMsg, sql_stmt);
                }
                else
                {
                    //                                        NSLog(@"Table dropped");
                }
                //Close the sqlite connection
                sqlite3_close(epiinfoDB);
            }
            else
            {
                NSLog(@"Failed to open/create database");
            }
        }
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [manageView setFrame:CGRectMake(0, -manageButton.frame.origin.y - manageButton.frame.size.height - 10.0, self.view.frame.size.width, manageButton.frame.origin.y + manageButton.frame.size.height + 10.0)];
    } completion:^(BOOL finished){
        [manageView removeFromSuperview];
    }];
}
- (void)cancelDeleteFormPressed:(UIButton *)sender
{
    UIView *manageView = [sender superview];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [manageView setFrame:CGRectMake(0, -manageButton.frame.origin.y - manageButton.frame.size.height - 10.0, self.view.frame.size.width, manageButton.frame.origin.y + manageButton.frame.size.height + 10.0)];
    } completion:^(BOOL finished){
        [manageView removeFromSuperview];
    }];
}

- (void)openButtonPressed:(UIButton *)sender
{
    if (lv.selectedIndex.intValue == 0)
        return;
    float viewWidth = self.view.frame.size.width;
    float viewHeight = self.view.frame.size.height;
    [[UIDevice currentDevice] playInputClick];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, -M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.view.layer setTransform:rotate];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            [pickerLabel setHidden:YES];
            [lv setHidden:YES];
            [openButton setHidden:YES];
            [manageButton setHidden:YES];

            orangeBannerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
            [orangeBannerBackground setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
            [self.view addSubview:orangeBannerBackground];
            
            NSString *path = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms/"] stringByAppendingString:lvSelected.text] stringByAppendingString:@".xml"];
            NSURL *url = [NSURL fileURLWithPath:path];
            self.fieldsAndStringValues = [[FieldsAndStringValues alloc] init];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                edv = [[EnterDataView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height) AndURL:url AndRootViewController:self AndNameOfTheForm:lvSelected.text AndPageToDisplay:(int)[sender tag]];
                orangeBanner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 36)];
            }
            else
            {
                edv = [[EnterDataView alloc] initWithFrame:CGRectMake(0, 0, 320, 506) AndURL:url AndRootViewController:self AndNameOfTheForm:lvSelected.text AndPageToDisplay:(int)[sender tag]];
                orangeBanner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
            }
            [edv setMyOrangeBanner:orangeBanner];
            [self.view addSubview:edv];
            [self.view bringSubviewToFront:edv];
            
            [orangeBanner setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:0.95]];
            [self.view addSubview:orangeBanner];
            
            UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, viewWidth - 120.0, 34)];
            [header setBackgroundColor:[UIColor clearColor]];
            [header setTextColor:[UIColor whiteColor]];
            [header setTextAlignment:NSTextAlignmentCenter];
            [orangeBanner addSubview:header];
            
            UIButton *xButton = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth - 32.0, 2, 30, 30)];
            [xButton setBackgroundColor:[UIColor clearColor]];
            [xButton setImage:[UIImage imageNamed:@"StAndrewXButton.png"] forState:UIControlStateNormal];
            [xButton setTitle:@"Close the form" forState:UIControlStateNormal];
            [xButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [xButton setAlpha:0.5];
            [xButton.layer setMasksToBounds:YES];
            [xButton.layer setCornerRadius:8.0];
//            [xButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
//            [xButton.layer setBorderWidth:1.0];
            [xButton addTarget:self action:@selector(confirmDismissal) forControlEvents:UIControlEventTouchUpInside];
//            [orangeBanner addSubview:xButton];
            
            UINavigationBar *formNavigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 8, orangeBanner.frame.size.width, orangeBanner.frame.size.height - 4)];
            [formNavigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            [formNavigationBar setShadowImage:[UIImage new]];
            [formNavigationBar setTranslucent:YES];
            formNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
            closeFormBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(confirmDismissal)];
            [closeFormBarButtonItem setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [formNavigationItem setRightBarButtonItem:closeFormBarButtonItem];
            deleteRecordBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(footerBarDelete)];
            [deleteRecordBarButtonItem setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [deleteRecordBarButtonItem setImageInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
            UIBarButtonItem *packageDataBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(confirmUploadAllRecords)];
            [packageDataBarButtonItem setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [packageDataBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
            UIBarButtonItem *recordLookupBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(lineListButtonPressed)];
            [recordLookupBarButtonItem setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
            [recordLookupBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
            [formNavigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:packageDataBarButtonItem, recordLookupBarButtonItem, nil]];
            [formNavigationBar setItems:[NSArray arrayWithObject:formNavigationItem]];
            [orangeBanner addSubview:formNavigationBar];
            formNavigationItems = [[NSMutableArray alloc] init];
            closeFormBarButtonItems = [[NSMutableArray alloc] init];
            deleteRecordBarButtonItems = [[NSMutableArray alloc] init];
            [formNavigationItems addObject:formNavigationItem];
            [closeFormBarButtonItems addObject:closeFormBarButtonItem];
            [deleteRecordBarButtonItems addObject:deleteRecordBarButtonItem];
            
            footerBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, viewHeight - 32.0, viewWidth, 32)];
//            [footerBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//            [footerBar setShadowImage:[UIImage new]];
//            [footerBar setTranslucent:YES];
            footerBarNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
            submitFooterBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(footerBarSubmit)];
            [submitFooterBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
            updateFooterBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(footerBarUpdate)];
            [updateFooterBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
            UIBarButtonItem *clearFooterBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(footerBarClear)];
            [clearFooterBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0] forKey:NSForegroundColorAttributeName] forState:UIControlStateNormal];
            [footerBarNavigationItem setRightBarButtonItem:submitFooterBarButtonItem];
            [footerBarNavigationItem setLeftBarButtonItem:clearFooterBarButtonItem];
            [footerBar setItems:[NSArray arrayWithObject:footerBarNavigationItem]];
            [self.view addSubview:footerBar];
            
//            [footerBarNavigationItem setTitle:@"Swipe to turn page."];
            pagedots = [[PageDots alloc] initWithNumberOfDots:(int)[edv pagesArray].count AndFooterFrame:footerBar.frame];
            [footerBar addSubview: pagedots];
            
            UIButton *uploadButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, 30, 30)];
            [uploadButton setBackgroundColor:[UIColor clearColor]];
            [uploadButton setImage:[UIImage imageNamed:@"UploadButton.png"] forState:UIControlStateNormal];
            [uploadButton setTitle:@"Upload data" forState:UIControlStateNormal];
            [uploadButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [uploadButton setAlpha:0.5];
            [uploadButton.layer setMasksToBounds:YES];
            [uploadButton.layer setCornerRadius:8.0];
//            [uploadButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
//            [uploadButton.layer setBorderWidth:1.0];
            [uploadButton addTarget:self action:@selector(confirmUploadAllRecords) forControlEvents:UIControlEventTouchUpInside];
//            [orangeBanner addSubview:uploadButton];
            
            UIButton *lineListButton = [[UIButton alloc] initWithFrame:CGRectMake(34, 2, 30, 30)];
            [lineListButton setBackgroundColor:[UIColor clearColor]];
            [lineListButton setImage:[UIImage imageNamed:@"LineList6060.png"] forState:UIControlStateNormal];
            [lineListButton setTitle:@"Show line listing" forState:UIControlStateNormal];
            [lineListButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [lineListButton setAlpha:0.5];
            [lineListButton.layer setMasksToBounds:YES];
            [lineListButton.layer setCornerRadius:8.0];
            [lineListButton addTarget:self action:@selector(lineListButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [orangeBanner addSubview:lineListButton];
            
            [edv setPageBeingDisplayed:[NSNumber numberWithInt:1]];
//            [header setText:[NSString stringWithFormat:@"%@, page %d of %lu", [edv formName], [edv pageBeingDisplayed].intValue, (unsigned long)[edv pagesArray].count]];
            [header setText:[NSString stringWithFormat:@"%@", [edv formName]]];
            float fontSize = 28.0;
            while ([header.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]}].width > 160)
                fontSize -= 0.1;
            [header setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]];
            
        }
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [customBackButton setAlpha:0.0];
            [backToMainMenu setEnabled:NO];
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
            [self.view.layer setTransform:rotate];
        } completion:^(BOOL finished){
            [edv getMyLocation];
        }];
    }];
}

- (void)lineListButtonPressed
{
    // Initialize a Line List View and move it into place
    EpiInfoLineListView *eillv = [[EpiInfoLineListView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - orangeBanner.frame.origin.y) andFormName:[edv formName]];
    [self.view addSubview:eillv];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [eillv setFrame:CGRectMake(0, orangeBanner.frame.origin.y, eillv.frame.size.width, eillv.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)confirmUploadAllRecords
{
    dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    BlurryView *dismissImageView = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, dismissView.frame.size.width, dismissView.frame.size.height)];
    [dismissImageView setBackgroundColor:[UIColor grayColor]];
    [dismissImageView setAlpha:0.8];
    [dismissView addSubview:dismissImageView];
    
    // The translucent white view on top of the blurred image.
    BlurryView *windowView = [[BlurryView alloc] initWithFrame:dismissImageView.frame];
    [windowView setBackgroundColor:[UIColor colorWithRed:.5 green:.5 blue:.5 alpha:0.6]];
//    [windowView setAlpha:0.6];
    [dismissView addSubview:windowView];
    
    // The smaller and less-transparent white view for the message and buttons.
    //    UIView *messageView = [[UIView alloc] initWithFrame:dismissImageView.frame];
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, openButton.frame.origin.y + openButton.frame.size.height + 90.0)];
    [messageView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7]];
//    [messageView setAlpha:0.7];
    [messageView.layer setCornerRadius:8.0];
    [dismissView addSubview:messageView];
    
    //    UILabel *areYouSure = [[UILabel alloc] initWithFrame:dismissView.frame];
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 96)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setNumberOfLines:0];
    [messageView addSubview:areYouSure];
    
    UILabel *decimalSeparatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 104, 142, 40)];
    [decimalSeparatorLabel setBackgroundColor:[UIColor clearColor]];
    [decimalSeparatorLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [decimalSeparatorLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [decimalSeparatorLabel setTextAlignment:NSTextAlignmentLeft];
    [decimalSeparatorLabel setText:@"Decimal separator:"];
    [messageView addSubview:decimalSeparatorLabel];
    
    useDotForDecimal = YES;
    
    dotDecimalSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(150, 106, 34, 34)];
    [dotDecimalSeparatorView setBackgroundColor:[UIColor colorWithRed:243/255.0 green:124/255.0 blue:96/255.0 alpha:1.0]];
    [dotDecimalSeparatorView.layer setCornerRadius:10.0];
    [messageView addSubview:dotDecimalSeparatorView];
    
    UIButton *dotDecimalSeparatorButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, 26, 26)];
//    [dotDecimalSeparatorButton setBackgroundColor:[UIColor whiteColor]];
    [dotDecimalSeparatorButton.layer setMasksToBounds:YES];
    [dotDecimalSeparatorButton setTitle:@"." forState:UIControlStateNormal];
    [dotDecimalSeparatorButton setAccessibilityLabel:@"Use dot for decimal separator"];
    [dotDecimalSeparatorButton setImage:[UIImage imageNamed:@"Dot.png"] forState:UIControlStateNormal];
    [dotDecimalSeparatorButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [dotDecimalSeparatorButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [dotDecimalSeparatorButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0]];
    [dotDecimalSeparatorButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [dotDecimalSeparatorButton.layer setCornerRadius:8.0];
    [dotDecimalSeparatorButton addTarget:self action:@selector(chooseDecimalSeparator:) forControlEvents:UIControlEventTouchUpInside];
    [dotDecimalSeparatorView addSubview:dotDecimalSeparatorButton];
    
    commaDecimalSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(186, 106, 34, 34)];
    [commaDecimalSeparatorView setBackgroundColor:[UIColor clearColor]];
    [commaDecimalSeparatorView.layer setCornerRadius:10.0];
    [messageView addSubview:commaDecimalSeparatorView];
    
    UIButton *commaDecimalSeparatorButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 4, 26, 26)];
//    [commaDecimalSeparatorButton setBackgroundColor:[UIColor whiteColor]];
    [commaDecimalSeparatorButton.layer setMasksToBounds:YES];
    [commaDecimalSeparatorButton setTitle:@"," forState:UIControlStateNormal];
    [commaDecimalSeparatorButton setAccessibilityLabel:@"Use comma for decimal separator"];
    [commaDecimalSeparatorButton setImage:[UIImage imageNamed:@"Comma.png"] forState:UIControlStateNormal];
    [commaDecimalSeparatorButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [commaDecimalSeparatorButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [commaDecimalSeparatorButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:32.0]];
    [commaDecimalSeparatorButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [commaDecimalSeparatorButton.layer setCornerRadius:8.0];
    [commaDecimalSeparatorButton addTarget:self action:@selector(chooseDecimalSeparator:) forControlEvents:UIControlEventTouchUpInside];
    [commaDecimalSeparatorView addSubview:commaDecimalSeparatorButton];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 80, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [messageView addSubview:uiaiv];
    
    UIButton *iTunesButton = [[UIButton alloc] initWithFrame:CGRectMake(1, openButton.frame.origin.y - openButton.frame.size.height, 298, 40)];
//    [iTunesButton setImage:[UIImage imageNamed:@"PackageForiTunesButton.png"] forState:UIControlStateNormal];
    [iTunesButton setTitle:@"Package Data for Upload to iTunes" forState:UIControlStateNormal];
    [iTunesButton setAccessibilityLabel:@"Package for I tunes upload."];
    [iTunesButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [iTunesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [iTunesButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [iTunesButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [iTunesButton.layer setMasksToBounds:YES];
    [iTunesButton.layer setCornerRadius:4.0];
//    [iTunesButton addTarget:self action:@selector(packageDataForiTunes:) forControlEvents:UIControlEventTouchUpInside];
    [iTunesButton addTarget:self action:@selector(prePackageData:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:iTunesButton];
    
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(1, openButton.frame.origin.y - openButton.frame.size.height + 42.0, 298, 40)];
//    [emailButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
    [emailButton setTitle:@"Package and Email Data" forState:UIControlStateNormal];
    [emailButton setAccessibilityLabel:@"Package and email"];
    [emailButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [emailButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [emailButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [emailButton.layer setMasksToBounds:YES];
    [emailButton.layer setCornerRadius:4.0];
//    [emailButton addTarget:self action:@selector(packageAndEmailData:) forControlEvents:UIControlEventTouchUpInside];
    [emailButton addTarget:self action:@selector(prePackageData:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:emailButton];
    
    //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(1, openButton.frame.origin.y - openButton.frame.size.height + 84.0, 298, 40)];
//    [yesButton setImage:[UIImage imageNamed:@"UploadDataToCloudButton.png"] forState:UIControlStateNormal];
    [yesButton setTitle:@"Upload Data to Cloud" forState:UIControlStateNormal];
    [yesButton setAccessibilityLabel:@"Upload to cloud"];
    [yesButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [yesButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [yesButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [yesButton.layer setMasksToBounds:YES];
    [yesButton.layer setCornerRadius:4.0];
    [yesButton addTarget:self action:@selector(uploadAllRecords:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:yesButton];
    
    //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(messageView.frame.size.width / 2.0 -  openButton.frame.size.width / 2.0, openButton.frame.origin.y + 88.0, openButton.frame.size.width, openButton.frame.size.height)];
//    [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [noButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [noButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [noButton.layer setMasksToBounds:YES];
    [noButton.layer setCornerRadius:4.0];
    [noButton addTarget:self action:@selector(doNotDismiss) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:noButton];
    
    [self.view addSubview:dismissView];
    [self.view bringSubviewToFront:dismissView];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        int numberOfRecordsToUpload = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(*) as n from %@", edv.formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    numberOfRecordsToUpload = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
      recordsToBeWrittenToPackageFile = numberOfRecordsToUpload;
        if (numberOfRecordsToUpload > 0)
        {
            [areYouSure setText:[NSString stringWithFormat:@"Local table contains %d records.", numberOfRecordsToUpload]];
            [emailButton setEnabled:YES];
            [yesButton setEnabled:YES];
            [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
//            [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
        }
        else
        {
            [areYouSure setText:[NSString stringWithFormat:@"Local table contains no rows."]];
            [emailButton setEnabled:NO];
            [yesButton setEnabled:NO];
            [noButton setTitle:@"OK" forState:UIControlStateNormal];
//            [noButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
            return;
        }
    }
    else
    {
        [areYouSure setText:[NSString stringWithFormat:@"Local table does not yet exist for this form."]];
        [emailButton setEnabled:NO];
        [yesButton setEnabled:NO];
        [noButton setTitle:@"OK" forState:UIControlStateNormal];
//        [noButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
        return;
    }

    // Check whether credentials exist for this form
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/CloudDatabasesDatabase/Clouds.db"];
        int credentialsExistForThisForm = 0;
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select count(*) as n from Clouds where FormName = '%@'", edv.formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                if (sqlite3_step(statement) == SQLITE_ROW)
                    credentialsExistForThisForm = sqlite3_column_int(statement, 0);
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
        if (credentialsExistForThisForm > 0)
        {
            // Create the todoService - this creates the Mobile Service client inside the wrapped service
//            [self setEpiinfoService:[QSEpiInfoService defaultService]];
            
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = [NSString stringWithFormat:@"select * from Clouds where FormName = '%@'", edv.formName];
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                    if (sqlite3_step(statement) == SQLITE_ROW)
                    {
                        if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 1)] isEqualToString:@"MSAzure"])
                        {
//                            [self.epiinfoService setApplicationURL:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]];
//                            [self.epiinfoService setApplicationKey:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]];
//                            self.epiinfoService = [[QSEpiInfoService alloc] initWithURL:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)] AndKey:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]];
//                            [self.epiinfoService setTableName:edv.formName];
//                            [self.epiinfoService setApplicationURL:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 2)]];
//                            [self.epiinfoService setApplicationKey:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, 3)]];
                        }
                    }
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
//            if (self.epiinfoService.applicationURL.length < 2)
//            {
//                [areYouSure setText:[areYouSure.text stringByAppendingString:@"\nNo cloud connection credentials found for this table."]];
//                [yesButton setEnabled:NO];
//                [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
////                [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
////                    [dismissView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
////                } completion:^(BOOL finished){
////                }];
////                return;
//            }
        }
        else
        {
            [areYouSure setText:[areYouSure.text stringByAppendingString:@"\nNo cloud connection credentials found for this table."]];
            [yesButton setEnabled:NO];
            [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
//            [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
//            [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//                [dismissView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//            } completion:^(BOOL finished){
//            }];
//            return;
        }
    }
    else
    {
        [areYouSure setText:[areYouSure.text stringByAppendingString:@"\nNo cloud connection credentials found for this table."]];
        [yesButton setEnabled:NO];
        [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
//        [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
//        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//            [dismissView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        } completion:^(BOOL finished){
//        }];
//        return;
    }
    
    // Check for internet connectivity
    Reachability *reachability;
    @try {
//        reachability = [Reachability reachabilityWithHostName:[NSString stringWithFormat:@"%@", [[self.epiinfoService.applicationURL substringToIndex:self.epiinfoService.applicationURL.length - 1] substringFromIndex:8]]];
    }
    @catch (NSException *exception) {
        reachability = [Reachability reachabilityWithHostName:@"www.cdc.gov"];
    }
    @finally {
    }
//    if (!self.epiinfoService.applicationURL)
    reachability = [Reachability reachabilityWithHostName:@"www.cdc.gov"];
//    else if ([reachability currentReachabilityStatus] == NotReachable)
//    {
//        [areYouSure setText:[areYouSure.text stringByAppendingString:@"\nCloud not reachable at this time or with supplied credentials."]];
//        [yesButton setEnabled:NO];
//        reachability = [Reachability reachabilityWithHostName:@"www.cdc.gov"];
//    }
    NetworkStatus *remoteHostStatus = [reachability currentReachabilityStatus];
    if (remoteHostStatus == NotReachable)
    {
//        NSLog(@"%@", [[self.epiinfoService.applicationURL substringToIndex:self.epiinfoService.applicationURL.length - 1] substringFromIndex:8]);
        [areYouSure setText:[areYouSure.text stringByAppendingString:@"\nNo internet connection. Cannot upload or email records at this time."]];
        [emailButton setEnabled:NO];
        [yesButton setEnabled:NO];
        [noButton setTitle:@"OK" forState:UIControlStateNormal];
//        [noButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [dismissView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        } completion:^(BOOL finished){
        }];
        return;
    }
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [dismissView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)chooseDecimalSeparator:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"."])
    {
        useDotForDecimal = YES;
        [dotDecimalSeparatorView setBackgroundColor:[UIColor colorWithRed:243/255.0 green:124/255.0 blue:96/255.0 alpha:1.0]];
        [commaDecimalSeparatorView setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        useDotForDecimal = NO;
        [dotDecimalSeparatorView setBackgroundColor:[UIColor clearColor]];
        [commaDecimalSeparatorView setBackgroundColor:[UIColor colorWithRed:243/255.0 green:124/255.0 blue:96/255.0 alpha:1.0]];
    }
}

- (void)confirmDismissal
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dismiss Form" message:@"Dismiss this form?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
//    // Create a confirmation view with frosted glass effect.
//    // This requires capturing what was in view in an image, then blurring it and adding translucent white layer on top.
//    
//    // First, capture the screen
////    UIImageView *screenView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height + 40)];
////    UIGraphicsBeginImageContext(screenView.bounds.size);
////    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
////    UIImage *screen = UIGraphicsGetImageFromCurrentImageContext();
////    [screenView setImage:screen];
////    UIGraphicsEndImageContext();
//    
//    // Then blur the captured image.
////    CIImage *blurryScreen = [CIImage imageWithCGImage:[screen CGImage]];
////    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
////    [gaussianBlurFilter setValue:blurryScreen forKey:@"inputImage"];
////    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:5] forKey:@"inputRadius"];
////    CIImage *blurryResult = [gaussianBlurFilter valueForKey:@"outputImage"];
////    UIImage *endImage = [[UIImage alloc] initWithCIImage:blurryResult];
//
////    dismissView = [[UIView alloc] initWithFrame:CGRectMake(288, 2, 30, 30)];
//    dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
//    
//    // Add the blurred image to an image view.
////    UIImageView *dismissImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
////    [dismissImageView setImage:endImage];
////    [dismissView addSubview:dismissImageView];
////    BlurryView *dismissImageView = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    BlurryView *dismissImageView = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, dismissView.frame.size.width, dismissView.frame.size.height)];
//    [dismissImageView setBackgroundColor:[UIColor grayColor]];
//    [dismissImageView setAlpha:0.8];
//    [dismissView addSubview:dismissImageView];
//    
//    // The translucent white view on top of the blurred image.
//    BlurryView *windowView = [[BlurryView alloc] initWithFrame:dismissImageView.frame];
//    [windowView setBackgroundColor:[UIColor grayColor]];
//    [windowView setAlpha:0.6];
//    [dismissView addSubview:windowView];
//    
//    // The smaller and less-transparent white view for the message and buttons.
////    UIView *messageView = [[UIView alloc] initWithFrame:dismissImageView.frame];
//    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, openButton.frame.origin.y + openButton.frame.size.height)];
//    [messageView setBackgroundColor:[UIColor whiteColor]];
//    [messageView setAlpha:0.7];
//    [messageView.layer setCornerRadius:8.0];
//    [dismissView addSubview:messageView];
//    
////    UILabel *areYouSure = [[UILabel alloc] initWithFrame:dismissView.frame];
//    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 36)];
//    [areYouSure setBackgroundColor:[UIColor clearColor]];
//    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
//    [areYouSure setText:@"Dismiss Form?"];
//    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
//    [areYouSure setTextAlignment:NSTextAlignmentCenter];
//    [messageView addSubview:areYouSure];
//    
////    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
//    UIButton *yesButton = [[UIButton alloc] initWithFrame:openButton.frame];
//    [yesButton setImage:[UIImage imageNamed:@"YesButton.png"] forState:UIControlStateNormal];
//    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
//    [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    [yesButton.layer setMasksToBounds:YES];
//    [yesButton.layer setCornerRadius:4.0];
//    [yesButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
//    [dismissView addSubview:yesButton];
//    
////    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
//    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(300 - openButton.frame.size.width, openButton.frame.origin.y, openButton.frame.size.width, openButton.frame.size.height)];
//    [noButton setImage:[UIImage imageNamed:@"NoButton.png"] forState:UIControlStateNormal];
//    [noButton setTitle:@"No" forState:UIControlStateNormal];
//    [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
//    [noButton.layer setMasksToBounds:YES];
//    [noButton.layer setCornerRadius:4.0];
//    [noButton addTarget:self action:@selector(doNotDismiss) forControlEvents:UIControlEventTouchUpInside];
//    [dismissView addSubview:noButton];
//    
//    [self.view addSubview:dismissView];
//    [self.view bringSubviewToFront:dismissView];
//
//    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        [dismissView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
////        [dismissImageView setFrame:CGRectMake(-20, -20, self.view.frame.size.width + 36, self.view.frame.size.height +36)];
////        [windowView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
////        [messageView setFrame:CGRectMake(10, 10, 300, openButton.frame.origin.y + openButton.frame.size.height)];
////        [areYouSure setFrame:CGRectMake(10, 10, 280, 36)];
////        [yesButton setFrame:openButton.frame];
////        [noButton setFrame:CGRectMake(300 - openButton.frame.size.width, openButton.frame.origin.y, openButton.frame.size.width, openButton.frame.size.height)];
//    } completion:^(BOOL finished){
//    }];
}

- (void)doNotDismiss
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        [dismissView setFrame:CGRectMake(288, 2, 30, 30)];
        [dismissView setFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
//        for (UIView *v in [dismissView subviews])
//            [v setFrame:CGRectMake(0, 0, 30, 30)];
    } completion:^(BOOL finished){
        [dismissView removeFromSuperview];
        dismissView = nil;
        mailComposerShown = NO;
    }];
}

- (void)dismissPrePackageDataView:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[sender superview] setFrame:CGRectMake([sender superview].frame.origin.x, -[sender superview].frame.size.height, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
        [[sender superview] removeFromSuperview];
    }];
}

- (void)prePackageData:(UIButton *)sender
{
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(sender.frame.origin.x + sender.frame.size.width / 2.0, sender.frame.origin.y + sender.frame.size.height / 2.0, 0, 0)];
    [messageView setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [messageView.layer setCornerRadius:8.0];
    [dismissView addSubview:messageView];
    
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setNumberOfLines:0];
    [areYouSure setText:@"Specify a password for encrypted data file:"];
    [messageView addSubview:areYouSure];
    
    EpiInfoTextField *eitf = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [eitf setBorderStyle:UITextBorderStyleRoundedRect];
    [eitf setDelegate:self];
    [eitf setReturnKeyType:UIReturnKeyDone];
    [eitf setColumnName:@"None"];
    [eitf setSecureTextEntry:YES];
    [messageView addSubview:eitf];
    
    UIButton *packageDataButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [packageDataButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [packageDataButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [packageDataButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [packageDataButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [packageDataButton.layer setMasksToBounds:YES];
    [packageDataButton.layer setCornerRadius:4.0];
    if ([sender.titleLabel.text isEqualToString:@"Package Data for Upload to iTunes"])
    {
//        [packageDataButton setImage:[UIImage imageNamed:@"PackageForiTunesButton.png"] forState:UIControlStateNormal];
        [packageDataButton setTitle:@"Package Data for Upload to iTunes" forState:UIControlStateNormal];
        [packageDataButton setAccessibilityLabel:@"Package for I tunes upload."];
        [packageDataButton addTarget:self action:@selector(packageDataForiTunes:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
//        [packageDataButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
        [packageDataButton setTitle:@"Package and Email Data" forState:UIControlStateNormal];
        [packageDataButton setAccessibilityLabel:@"Package and email"];
        [packageDataButton addTarget:self action:@selector(packageAndEmailData:) forControlEvents:UIControlEventTouchUpInside];
    }
    [messageView addSubview:packageDataButton];
    
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [noButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [noButton setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [noButton.layer setMasksToBounds:YES];
    [noButton.layer setCornerRadius:4.0];
    [noButton addTarget:self action:@selector(dismissPrePackageDataView:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:noButton];

    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [messageView setFrame:CGRectMake(10, 10, 300, openButton.frame.origin.y + openButton.frame.size.height + 90.0)];
        [areYouSure setFrame:CGRectMake(10, 10, 280, 96)];
        [eitf setFrame:CGRectMake(2, 96, 296, 40)];
        [packageDataButton setFrame:CGRectMake(1, openButton.frame.origin.y + 42.0 - openButton.frame.size.height, 298, 40)];
        [noButton setFrame:CGRectMake(messageView.frame.size.width / 2.0 -  openButton.frame.size.width / 2.0, openButton.frame.origin.y + 46.0, openButton.frame.size.width, openButton.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)packageDataForiTunes:(UIButton *)sender
{
    NSDate *dateObject = [NSDate date];
    BOOL dmy = ([[[dateObject descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[dateObject descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
    
    NSString *userPassword;
    for (UIView *v in [[sender superview] subviews])
        if ([v isKindOfClass:[UITextField class]])
            userPassword = [(UITextField *)v text];
    if ([userPassword length] == 0)
        return;

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    NSString *docFile = [path stringByAppendingPathComponent:[edv.formName stringByAppendingString:@".epi7"]];
    NSString *tmpPath = NSTemporaryDirectory();
    NSString *tmpFile = [tmpPath stringByAppendingPathComponent:[edv.formName stringByAppendingString:@".xml"]];
    
    // Connect to sqlite and assemble XML
    //        NSString *xmlFileText = [[@"<" stringByAppendingString:@"SurveyResponses"] stringByAppendingString:@">"];
    // Switched to NSMutableString from NSString for *much* faster appends.
    NSMutableString *xmlFileText = [NSMutableString stringWithString:@"<SurveyResponses>"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = @"select GlobalRecordID";
            for (int k = 0; k < edv.pagesArray.count; k++)
                for (int l = 0; l < [(NSMutableArray *)[edv.pagesArray objectAtIndex:k] count]; l++)
                    selStmt = [[selStmt stringByAppendingString:@", "] stringByAppendingString:[(NSMutableArray *)[edv.pagesArray objectAtIndex:k] objectAtIndex:l]];
            selStmt = [NSString stringWithFormat:@"%@ from %@", selStmt, edv.formName];
            
//            selStmt = [NSString stringWithFormat:@"select * from %@", edv.formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                // Give user feedback that package is building.
                FeedbackView *feedbackView = [[FeedbackView alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
                [feedbackView setTotalRecords:recordsToBeWrittenToPackageFile];
                NSThread *activityIndicatorThread = [[NSThread alloc] initWithTarget:self selector:@selector(showActivityIndicatorWhileCreatingPackageFile:) object:feedbackView];
                [activityIndicatorThread start];
                int recordTracker = 0;
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    [feedbackView setTag:++recordTracker];
                    //                        xmlFileText = [xmlFileText stringByAppendingString:@"\n\t<SurveyResponse SurveyResponseID=\""];
                    [xmlFileText appendString:@"\n\t<SurveyResponse SurveyResponseID=\""];
                    
                    int i = 0;
                    BOOL idAlreadyAdded = NO;
                    
                    while (sqlite3_column_name(statement, i))
                    {
                        NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                        if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                        {
                            if (!idAlreadyAdded)
                            {
                                //                                    xmlFileText = [[[xmlFileText stringByAppendingString:@""] stringByAppendingString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]] stringByAppendingString:@"\">"];
                                [xmlFileText appendString:@""];
                                [xmlFileText appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                                [xmlFileText appendString:@"\">"];
                            }
                            idAlreadyAdded = YES;
                        }
                        i++;
                    }
                    
                    i = 0;
                    
                    while (sqlite3_column_name(statement, i))
                    {
                        NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                        if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                        {
                            i++;
                            continue;
                        }
                        // Find the first page with data-containing controls
                        int firstPage = 0;
                        while ((int)[(NSMutableArray *)[edv.pagesArray objectAtIndex:firstPage] count] < 1)
                            firstPage++;
                        if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[edv.pagesArray objectAtIndex:firstPage] objectAtIndex:0] lowercaseString]])
                        {
                            //                                xmlFileText = [[[xmlFileText stringByAppendingString:@"\n\t<Page PageId=\""] stringByAppendingString:[edv.pageIDs objectAtIndex:0]] stringByAppendingString:@"\">"];
                            if (firstPage == 0)
                            {
                                [xmlFileText appendString:@"\n\t<Page PageId=\""];
                                [xmlFileText appendString:[edv.pageIDs objectAtIndex:firstPage]];
                                [xmlFileText appendString:@"\">"];
                            }
                        }
                        for (int j = 1; j < edv.pagesArray.count; j++)
                        {
                            // A page can have zero data-containing controls. Don't let that throw an un-caught exception.
                            NSMutableArray *iterationNSMA = (NSMutableArray *)[edv.pagesArray objectAtIndex:j];
                            if ([iterationNSMA count] < 1)
                                continue;
                            if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[edv.pagesArray objectAtIndex:j] objectAtIndex:0] lowercaseString]])
                            {
                                //                                    xmlFileText = [[[xmlFileText stringByAppendingString:@"\n\t</Page>\n\t<Page PageId=\""] stringByAppendingString:[edv.pageIDs objectAtIndex:j]] stringByAppendingString:@"\">"];
                                //new test comment
                                if (firstPage == 0 || firstPage < j)
                                    [xmlFileText appendString:@"\n\t</Page>\n\t<Page PageId=\""];
                                else
                                    [xmlFileText appendString:@"\n\t<Page PageId=\""];
                                [xmlFileText appendString:[edv.pageIDs objectAtIndex:j]];
                                [xmlFileText appendString:@"\">"];
                            }
                        }
                        
                        if ([edv.checkboxes objectForKey:columnName])
                        {
                            switch (sqlite3_column_int(statement, i))
                            {
                                case (1):
                                {
                                    //                                        xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
                                    //                                                            stringByAppendingString:columnName]
                                    //                                                           stringByAppendingString:@"\">"]
                                    //                                                          stringByAppendingString:@"true"]
                                    //                                                         stringByAppendingString:@"</"]
                                    //                                                        stringByAppendingString:@"ResponseDetail"]
                                    //                                                       stringByAppendingString:@">"];
                                    [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                    [xmlFileText appendString:columnName];
                                    [xmlFileText appendString:@"\">"];
                                    [xmlFileText appendString:@"true"];
                                    [xmlFileText appendString:@"</"];
                                    [xmlFileText appendString:@"ResponseDetail"];
                                    [xmlFileText appendString:@">"];
                                    break;
                                }
                                default:
                                {
                                    //                                        xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
                                    //                                                            stringByAppendingString:columnName]
                                    //                                                           stringByAppendingString:@"\">"]
                                    //                                                          stringByAppendingString:@"false"]
                                    //                                                         stringByAppendingString:@"</"]
                                    //                                                        stringByAppendingString:@"ResponseDetail"]
                                    //                                                       stringByAppendingString:@">"];
                                    [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                    [xmlFileText appendString:columnName];
                                    [xmlFileText appendString:@"\">"];
                                    [xmlFileText appendString:@"false"];
                                    [xmlFileText appendString:@"</"];
                                    [xmlFileText appendString:@"ResponseDetail"];
                                    [xmlFileText appendString:@">"];
                                    break;
                                }
                            }
                        }
                        else if ([[edv.dictionaryOfCommentLegals objectForKey:columnName] isKindOfClass:[CommentLegal class]])
                        {
                            NSString *dataValue = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                            if ([dataValue isEqualToString:@"(null)"])
                            {
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:@""];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else if ([dataValue containsString:@"-"])
                            {
                                int dashPos = (int)[dataValue rangeOfString:@"-"].location;
                                NSString *clValue = [dataValue substringToIndex:dashPos];
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:clValue];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else
                            {
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:dataValue];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                        }
                        else if (sqlite3_column_type(statement, i) == 1)
                        {
                            //                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
                            //                                                    stringByAppendingString:columnName]
                            //                                                   stringByAppendingString:@"\">"]
                            //                                                  stringByAppendingString:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)]]
                            //                                                 stringByAppendingString:@"</"]
                            //                                                stringByAppendingString:@"ResponseDetail"]
                            //                                               stringByAppendingString:@">"];
                            [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                            [xmlFileText appendString:columnName];
                            [xmlFileText appendString:@"\">"];
                            [xmlFileText appendString:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)]];
                            [xmlFileText appendString:@"</"];
                            [xmlFileText appendString:@"ResponseDetail"];
                            [xmlFileText appendString:@">"];
                        }
                        else if (sqlite3_column_type(statement, i) == 2)
                        {
                            NSString *value = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                            
                            NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
                            [nsnf setMaximumFractionDigits:6];
                            
//                            NSNumber *testFloat = [NSNumber numberWithFloat:1.1];
//                            NSString *testFloatString = [nsnf stringFromNumber:testFloat];
                            
                            if (!useDotForDecimal)
                                value = [value stringByReplacingOccurrencesOfString:@"." withString:@","];
                            
                            //                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
                            //                                                    stringByAppendingString:columnName]
                            //                                                   stringByAppendingString:@"\">"]
                            //                                                  stringByAppendingString:value]
                            //                                                 stringByAppendingString:@"</"]
                            //                                                stringByAppendingString:@"ResponseDetail"]
                            //                                               stringByAppendingString:@">"];
                            [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                            [xmlFileText appendString:columnName];
                            [xmlFileText appendString:@"\">"];
                            [xmlFileText appendString:value];
                            [xmlFileText appendString:@"</"];
                            [xmlFileText appendString:@"ResponseDetail"];
                            [xmlFileText appendString:@">"];
                        }
                        else if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] isEqualToString:@"(null)"])
                        {
                            //                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
                            //                                                    stringByAppendingString:columnName]
                            //                                                   stringByAppendingString:@"\">"]
                            //                                                  stringByAppendingString:@""]
                            //                                                 stringByAppendingString:@"</"]
                            //                                                stringByAppendingString:@"ResponseDetail"]
                            //                                               stringByAppendingString:@">"];
                            [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                            [xmlFileText appendString:columnName];
                            [xmlFileText appendString:@"\">"];
                            [xmlFileText appendString:@""];
                            [xmlFileText appendString:@"</"];
                            [xmlFileText appendString:@"ResponseDetail"];
                            [xmlFileText appendString:@">"];
                        }
                        else
                        {
                            NSString *stringValue = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                            @try {
                                NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
                                if (dmy)
                                {
                                    [nsdf setDateFormat:@"dd/MM/yyyy"];
                                }
                                else
                                {
                                    [nsdf setDateFormat:@"MM/dd/yyyy"];
                                }
                                NSDate *dt = [nsdf dateFromString:stringValue];
                                if (dt)
                                {
                                    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                                    NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dt];
                                    stringValue = [NSString stringWithFormat:@"%d-%d-%d", [components year], [components month], [components day]];
                                }
                                NSLog(@"%@", stringValue);
                            }
                            @catch (NSException *exception) {
                                NSLog(@"%@", exception);
                            }
                            @finally {
                                //
                            }
                            //                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
                            //                                                    stringByAppendingString:columnName]
                            //                                                   stringByAppendingString:@"\">"]
                            //                                                  stringByAppendingString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]]
                            //                                                 stringByAppendingString:@"</"]
                            //                                                stringByAppendingString:@"ResponseDetail"]
                            //                                               stringByAppendingString:@">"];
                            stringValue = [stringValue stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
                            stringValue = [stringValue stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
                            stringValue = [stringValue stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
                            stringValue = [stringValue stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
                            [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                            [xmlFileText appendString:columnName];
                            [xmlFileText appendString:@"\">"];
                            [xmlFileText appendString:stringValue];
                            [xmlFileText appendString:@"</"];
                            [xmlFileText appendString:@"ResponseDetail"];
                            [xmlFileText appendString:@">"];
                        }
                        i++;
                    }
                    //                        xmlFileText = [xmlFileText stringByAppendingString:@"\n\t</Page>\n\t</SurveyResponse>"];
                    [xmlFileText appendString:@"\n\t</Page>\n\t</SurveyResponse>"];
                }
                [feedbackView removeFromSuperview];
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
    }

//    xmlFileText = [[[xmlFileText stringByAppendingString:@"\n</"] stringByAppendingString:@"SurveyResponses"] stringByAppendingString:@">"];
    [xmlFileText appendString:@"</SurveyResponses>"];
//    NSLog(@"%@", xmlFileText);
    
    [xmlFileText writeToFile:tmpFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
    
    CCCryptorRef thisEncipher = NULL;
    
//    const unsigned char bytes[] = {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610};
//    NSData *iv = [NSData dataWithBytes:bytes length:16];
//    NSLog(@"%@:%s", iv, (const void *)iv.bytes);

    NSString *password = userPassword;
    float passwordLength = (float)password.length;
    float sixteens = 16.0 / passwordLength;
    if (sixteens > 1.0)
        for (int i = 0; i < (int)sixteens; i++)
            password = [password stringByAppendingString:password];
    password = [password substringToIndex:16];
     NSLog(@"%@", [ConverterMethods hexArrayToDecArray:[@"0000000000000000" dataUsingEncoding:NSUTF8StringEncoding]]);
    CCCryptorStatus result = CCCryptorCreate(kCCEncrypt,
                                             kCCAlgorithmAES128,
                                             kCCOptionPKCS7Padding, // 0x0000 or kCCOptionPKCS7Padding
                                             (const void *)[password dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                             [password dataUsingEncoding:NSUTF8StringEncoding].length,
                                             (const void *)[@"0000000000000000" dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                             &thisEncipher
                                             );
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t remainingBytes = 0;
    size_t movedBytes = 0;
    size_t plainTextBufferSize = 0;
    size_t totalBytesWritten = 0;
    uint8_t *ptr;
    
    NSData *plainText = [xmlFileText dataUsingEncoding:NSASCIIStringEncoding];

    plainTextBufferSize = [plainText length];
    bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    ptr = bufferPtr;
    remainingBytes = bufferPtrSize;

    result = CCCryptorUpdate(thisEncipher,
                             (const void *)[plainText bytes],
                             plainTextBufferSize,
                             ptr,
                             remainingBytes,
                             &movedBytes
                             );
    
    ptr += movedBytes;
    remainingBytes -= movedBytes;
    totalBytesWritten += movedBytes;
    
    result = CCCryptorFinal(thisEncipher,
                            ptr,
                            remainingBytes,
                            &movedBytes
                            );
    
    totalBytesWritten += movedBytes;
    
    if (thisEncipher)
    {
        (void) CCCryptorRelease(thisEncipher);
        thisEncipher = NULL;
    }

    if (result == kCCSuccess)
    {
        NSData *encryptedData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
        [[@"APPLE" stringByAppendingString:[encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]] writeToFile:docFile atomically:NO encoding:NSUTF8StringEncoding error:nil];

        if (bufferPtr)
            free(bufferPtr);
        [self dismissPrePackageDataView:sender];
        return;
    }
}
-(NSData*) hexToBytes:(NSString *)hexString {
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= hexString.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [hexString substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

- (NSData *)randomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    
    return data;
}
- (NSData *)AESKeyForPassword:(NSString *)password
                         salt:(NSData *)salt {
    NSMutableData *derivedKey = [NSMutableData dataWithLength:kCCKeySizeAES128];
    
    int
    result = CCKeyDerivationPBKDF(kCCPBKDF2,            // algorithm
                                  password.UTF8String,  // password
                                  [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding],  // passwordLength
                                  salt.bytes,           // salt
                                  salt.length,          // saltLen
                                  kCCPRFHmacAlgSHA1,    // PRF
                                  1000,         // rounds
                                  derivedKey.mutableBytes, // derivedKey
                                  derivedKey.length); // derivedKeyLen
    
    // Do not log password here
    NSAssert(result == kCCSuccess,
             @"Unable to create AES key for password: %d", result);
    
    return derivedKey;
}
- (void)showActivityIndicatorWhileCreatingPackageFile:(FeedbackView *)feedbackView
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [feedbackView setFrame:CGRectMake(10, 10, 300, 314)];
    } completion:^(BOOL finished){
    }];
    [feedbackView setBackgroundColor:[UIColor clearColor]];
    [feedbackView setBlurTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
    [feedbackView.layer setCornerRadius:10.0];
    [dismissView addSubview:feedbackView];
    UIActivityIndicatorView *uiavPackage = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 280, 20, 20)];
    [feedbackView addSubview:uiavPackage];
    [uiavPackage setColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [uiavPackage startAnimating];
    [dismissView bringSubviewToFront:feedbackView];
    
    feedbackView.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 40)];
    [feedbackView.percentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [feedbackView.percentLabel setTextColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
    [feedbackView addSubview:feedbackView.percentLabel];
}
- (void)packageAndEmailData:(UIButton *)sender
{
    NSDate *dateObject = [NSDate date];
    BOOL dmy = ([[[dateObject descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[dateObject descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
    
    if (!mailComposerShown)
    {
        NSString *userPassword;
        for (UIView *v in [[sender superview] subviews])
            if ([v isKindOfClass:[UITextField class]])
                userPassword = [(UITextField *)v text];
        if ([userPassword length] == 0)
            return;
        
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *docFile = [path stringByAppendingPathComponent:[edv.formName stringByAppendingString:@".epi7"]];
        NSString *tmpPath = NSTemporaryDirectory();
        NSString *tmpFile = [tmpPath stringByAppendingPathComponent:[edv.formName stringByAppendingString:@".xml"]];
        
        // Connect to sqlite and assemble XML
//        NSString *xmlFileText = [[@"<" stringByAppendingString:@"SurveyResponses"] stringByAppendingString:@">"];
        // Switched to NSMutableString from NSString for *much* faster appends.
        NSMutableString *xmlFileText = [NSMutableString stringWithString:@"<SurveyResponses>"];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
        {
            NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
            if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
            {
                NSString *selStmt = @"select GlobalRecordID";
                for (int k = 0; k < edv.pagesArray.count; k++)
                    for (int l = 0; l < [(NSMutableArray *)[edv.pagesArray objectAtIndex:k] count]; l++)
                        selStmt = [[selStmt stringByAppendingString:@", "] stringByAppendingString:[(NSMutableArray *)[edv.pagesArray objectAtIndex:k] objectAtIndex:l]];
                selStmt = [NSString stringWithFormat:@"%@ from %@", selStmt, edv.formName];
                
                //            selStmt = [NSString stringWithFormat:@"select * from %@", edv.formName];
                const char *query_stmt = [selStmt UTF8String];
                sqlite3_stmt *statement;
                if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
                {
                  // Give user feedback that package is building.
                  FeedbackView *feedbackView = [[FeedbackView alloc] initWithFrame:CGRectMake(10, 0, 300, 0)];
                  [feedbackView setTotalRecords:recordsToBeWrittenToPackageFile];
                  NSThread *activityIndicatorThread = [[NSThread alloc] initWithTarget:self selector:@selector(showActivityIndicatorWhileCreatingPackageFile:) object:feedbackView];
                  [activityIndicatorThread start];
                  int recordTracker = 0;
                    while (sqlite3_step(statement) == SQLITE_ROW)
                    {
                      [feedbackView setTag:++recordTracker];
//                        xmlFileText = [xmlFileText stringByAppendingString:@"\n\t<SurveyResponse SurveyResponseID=\""];
                        [xmlFileText appendString:@"\n\t<SurveyResponse SurveyResponseID=\""];
                        
                        int i = 0;
                        BOOL idAlreadyAdded = NO;
                        
                        while (sqlite3_column_name(statement, i))
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                            {
                                if (!idAlreadyAdded)
                                {
//                                    xmlFileText = [[[xmlFileText stringByAppendingString:@""] stringByAppendingString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]] stringByAppendingString:@"\">"];
                                    [xmlFileText appendString:@""];
                                    [xmlFileText appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
                                    [xmlFileText appendString:@"\">"];
                                }
                                idAlreadyAdded = YES;
                            }
                            i++;
                        }
                        
                        i = 0;
                        
                        while (sqlite3_column_name(statement, i))
                        {
                            NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                            if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                            {
                                i++;
                                continue;
                            }
                            // Find the first page with data-containing controls
                            int firstPage = 0;
                            while ((int)[(NSMutableArray *)[edv.pagesArray objectAtIndex:firstPage] count] < 1)
                                firstPage++;
                            if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[edv.pagesArray objectAtIndex:firstPage] objectAtIndex:0] lowercaseString]])
                            {
//                                xmlFileText = [[[xmlFileText stringByAppendingString:@"\n\t<Page PageId=\""] stringByAppendingString:[edv.pageIDs objectAtIndex:0]] stringByAppendingString:@"\">"];
                                if (firstPage == 0)
                                {
                                    [xmlFileText appendString:@"\n\t<Page PageId=\""];
                                    [xmlFileText appendString:[edv.pageIDs objectAtIndex:firstPage]];
                                    [xmlFileText appendString:@"\">"];
                                }
                            }
                            for (int j = 1; j < edv.pagesArray.count; j++)
                            {
                                // A page can have zero data-containing controls. Don't let that throw an un-caught exception.
                                NSMutableArray *iterationNSMA = (NSMutableArray *)[edv.pagesArray objectAtIndex:j];
                                if ([iterationNSMA count] < 1)
                                    continue;
                                if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[edv.pagesArray objectAtIndex:j] objectAtIndex:0] lowercaseString]])
                                {
//                                    xmlFileText = [[[xmlFileText stringByAppendingString:@"\n\t</Page>\n\t<Page PageId=\""] stringByAppendingString:[edv.pageIDs objectAtIndex:j]] stringByAppendingString:@"\">"];
                                    if (firstPage == 0 || firstPage < j)
                                        [xmlFileText appendString:@"\n\t</Page>\n\t<Page PageId=\""];
                                    else
                                        [xmlFileText appendString:@"\n\t<Page PageId=\""];
                                    [xmlFileText appendString:[edv.pageIDs objectAtIndex:j]];
                                    [xmlFileText appendString:@"\">"];
                                }
                            }
                            if ([edv.checkboxes objectForKey:columnName])
                            {
                                switch (sqlite3_column_int(statement, i))
                                {
                                    case (1):
                                    {
//                                        xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
//                                                            stringByAppendingString:columnName]
//                                                           stringByAppendingString:@"\">"]
//                                                          stringByAppendingString:@"true"]
//                                                         stringByAppendingString:@"</"]
//                                                        stringByAppendingString:@"ResponseDetail"]
//                                                       stringByAppendingString:@">"];
                                        [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                        [xmlFileText appendString:columnName];
                                        [xmlFileText appendString:@"\">"];
                                        [xmlFileText appendString:@"true"];
                                        [xmlFileText appendString:@"</"];
                                        [xmlFileText appendString:@"ResponseDetail"];
                                        [xmlFileText appendString:@">"];
                                        break;
                                    }
                                    default:
                                    {
//                                        xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
//                                                            stringByAppendingString:columnName]
//                                                           stringByAppendingString:@"\">"]
//                                                          stringByAppendingString:@"false"]
//                                                         stringByAppendingString:@"</"]
//                                                        stringByAppendingString:@"ResponseDetail"]
//                                                       stringByAppendingString:@">"];
                                        [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                        [xmlFileText appendString:columnName];
                                        [xmlFileText appendString:@"\">"];
                                        [xmlFileText appendString:@"false"];
                                        [xmlFileText appendString:@"</"];
                                        [xmlFileText appendString:@"ResponseDetail"];
                                        [xmlFileText appendString:@">"];
                                        break;
                                    }
                                }
                            }
                            else if ([[edv.dictionaryOfCommentLegals objectForKey:columnName] isKindOfClass:[CommentLegal class]])
                            {
                                NSString *dataValue = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                                if ([dataValue isEqualToString:@"(null)"])
                                {
                                    [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                    [xmlFileText appendString:columnName];
                                    [xmlFileText appendString:@"\">"];
                                    [xmlFileText appendString:@""];
                                    [xmlFileText appendString:@"</"];
                                    [xmlFileText appendString:@"ResponseDetail"];
                                    [xmlFileText appendString:@">"];
                                }
                                else if ([dataValue containsString:@"-"])
                                {
                                    int dashPos = (int)[dataValue rangeOfString:@"-"].location;
                                    NSString *clValue = [dataValue substringToIndex:dashPos];
                                    [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                    [xmlFileText appendString:columnName];
                                    [xmlFileText appendString:@"\">"];
                                    [xmlFileText appendString:clValue];
                                    [xmlFileText appendString:@"</"];
                                    [xmlFileText appendString:@"ResponseDetail"];
                                    [xmlFileText appendString:@">"];
                                }
                                else
                                {
                                    [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                    [xmlFileText appendString:columnName];
                                    [xmlFileText appendString:@"\">"];
                                    [xmlFileText appendString:dataValue];
                                    [xmlFileText appendString:@"</"];
                                    [xmlFileText appendString:@"ResponseDetail"];
                                    [xmlFileText appendString:@">"];
                                }
                            }
                            else if (sqlite3_column_type(statement, i) == 1)
                            {
//                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
//                                                    stringByAppendingString:columnName]
//                                                   stringByAppendingString:@"\">"]
//                                                  stringByAppendingString:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)]]
//                                                 stringByAppendingString:@"</"]
//                                                stringByAppendingString:@"ResponseDetail"]
//                                               stringByAppendingString:@">"];
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:[NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)]];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else if (sqlite3_column_type(statement, i) == 2)
                            {
                                NSString *value = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                                
                                NSNumberFormatter *nsnf = [[NSNumberFormatter alloc] init];
                                [nsnf setMaximumFractionDigits:6];
                                
//                                NSNumber *testFloat = [NSNumber numberWithFloat:1.1];
//                                NSString *testFloatString = [nsnf stringFromNumber:testFloat];
                                
                                if (!useDotForDecimal)
                                    value = [value stringByReplacingOccurrencesOfString:@"." withString:@","];
                                
//                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
//                                                    stringByAppendingString:columnName]
//                                                   stringByAppendingString:@"\">"]
//                                                  stringByAppendingString:value]
//                                                 stringByAppendingString:@"</"]
//                                                stringByAppendingString:@"ResponseDetail"]
//                                               stringByAppendingString:@">"];
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:value];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] isEqualToString:@"(null)"])
                            {
//                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
//                                                    stringByAppendingString:columnName]
//                                                   stringByAppendingString:@"\">"]
//                                                  stringByAppendingString:@""]
//                                                 stringByAppendingString:@"</"]
//                                                stringByAppendingString:@"ResponseDetail"]
//                                               stringByAppendingString:@">"];
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:@""];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            else
                            {
                                NSString *stringValue = [NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)];
                                @try {
                                    NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
                                    if (dmy)
                                    {
                                        [nsdf setDateFormat:@"dd/MM/yyyy"];
                                    }
                                    else
                                    {
                                        [nsdf setDateFormat:@"MM/dd/yyyy"];
                                    }
                                    NSDate *dt = [nsdf dateFromString:stringValue];
                                    if (dt)
                                    {
                                        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                                        NSDateComponents *components = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:dt];
                                        stringValue = [NSString stringWithFormat:@"%d-%d-%d", (int)[components year], (int)[components month], (int)[components day]];
                                    }
                                    NSLog(@"%@", stringValue);
                                }
                                @catch (NSException *exception) {
                                    NSLog(@"%@", exception);
                                }
                                @finally {
                                    //
                                }
//                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
//                                                    stringByAppendingString:columnName]
//                                                   stringByAppendingString:@"\">"]
//                                                  stringByAppendingString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]]
//                                                 stringByAppendingString:@"</"]
//                                                stringByAppendingString:@"ResponseDetail"]
//                                               stringByAppendingString:@">"];
                                stringValue = [stringValue stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"];
                                stringValue = [stringValue stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"];
                                stringValue = [stringValue stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
                                stringValue = [stringValue stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"];
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:stringValue];
                                [xmlFileText appendString:@"</"];
                                [xmlFileText appendString:@"ResponseDetail"];
                                [xmlFileText appendString:@">"];
                            }
                            i++;
                        }
//                        xmlFileText = [xmlFileText stringByAppendingString:@"\n\t</Page>\n\t</SurveyResponse>"];
                        [xmlFileText appendString:@"\n\t</Page>\n\t</SurveyResponse>"];
                    }
                  [feedbackView removeFromSuperview];
                }
                sqlite3_finalize(statement);
            }
            sqlite3_close(epiinfoDB);
        }
        
//        xmlFileText = [[[xmlFileText stringByAppendingString:@"\n</"] stringByAppendingString:@"SurveyResponses"] stringByAppendingString:@">"];
        [xmlFileText appendString:@"</SurveyResponses>"];
//        NSLog(@"%@", xmlFileText);
        
        [xmlFileText writeToFile:tmpFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
        
        CCCryptorRef thisEncipher = NULL;
        
        //    const unsigned char bytes[] = {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610};
        //    NSData *iv = [NSData dataWithBytes:bytes length:16];
        //    NSLog(@"%@:%s", iv, (const void *)iv.bytes);
        
        NSString *password = userPassword;
        float passwordLength = (float)password.length;
        float sixteens = 16.0 / passwordLength;
        if (sixteens > 1.0)
            for (int i = 0; i < (int)sixteens; i++)
                password = [password stringByAppendingString:password];
        password = [password substringToIndex:16];
        //    NSLog(@"%@", [password dataUsingEncoding:NSUTF8StringEncoding]);
        NSLog(@"%@", [ConverterMethods hexArrayToDecArray:[@"0000000000000000" dataUsingEncoding:NSUTF8StringEncoding]]);
        CCCryptorStatus result = CCCryptorCreate(kCCEncrypt,
                                                 kCCAlgorithmAES128,
                                                 kCCOptionPKCS7Padding, // 0x0000 or kCCOptionPKCS7Padding
                                                 (const void *)[password dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                                 [password dataUsingEncoding:NSUTF8StringEncoding].length,
                                                 (const void *)[@"0000000000000000" dataUsingEncoding:NSUTF8StringEncoding].bytes,
                                                 &thisEncipher
                                                 );
        
        uint8_t *bufferPtr = NULL;
        size_t bufferPtrSize = 0;
        size_t remainingBytes = 0;
        size_t movedBytes = 0;
        size_t plainTextBufferSize = 0;
        size_t totalBytesWritten = 0;
        uint8_t *ptr;
        
        NSData *plainText = [xmlFileText dataUsingEncoding:NSASCIIStringEncoding];
        
        plainTextBufferSize = [plainText length];
        bufferPtrSize = CCCryptorGetOutputLength(thisEncipher, plainTextBufferSize, true);
        bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
        memset((void *)bufferPtr, 0x0, bufferPtrSize);
        ptr = bufferPtr;
        remainingBytes = bufferPtrSize;
        
        result = CCCryptorUpdate(thisEncipher,
                                 (const void *)[plainText bytes],
                                 plainTextBufferSize,
                                 ptr,
                                 remainingBytes,
                                 &movedBytes
                                 );
        
        ptr += movedBytes;
        remainingBytes -= movedBytes;
        totalBytesWritten += movedBytes;
        
        result = CCCryptorFinal(thisEncipher,
                                ptr,
                                remainingBytes,
                                &movedBytes
                                );
        
        totalBytesWritten += movedBytes;
        
        if (thisEncipher)
        {
            (void) CCCryptorRelease(thisEncipher);
            thisEncipher = NULL;
        }

        if (result == kCCSuccess)
        {
            MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
            [composer setMailComposeDelegate:self];
//            NSData *encryptedData = [NSData dataWithBytes:thisEncipher length:numBytesEncrypted];
            NSData *encryptedData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
            [[@"APPLE" stringByAppendingString:[encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]] writeToFile:docFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
            
            if (bufferPtr)
                free(bufferPtr);
            [composer addAttachmentData:[NSData dataWithContentsOfFile:docFile] mimeType:@"text/plain" fileName:[edv.formName stringByAppendingString:@".epi7"]];
            [composer setSubject:@"Epi Info Data"];
            [composer setMessageBody:@"Here is some Epi Info data." isHTML:NO];
            [self presentViewController:composer animated:YES completion:^(void){
                mailComposerShown = YES;
            }];
//            free(buffer);
            [self dismissPrePackageDataView:sender];
            return;
        }

        
        if (result == kCCSuccess)
        {
            NSData *encryptedData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)totalBytesWritten];
            [[@"APPLE" stringByAppendingString:[encryptedData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn]] writeToFile:docFile atomically:NO encoding:NSUTF8StringEncoding error:nil];
            return;
        }
        MFMailComposeViewController *composer = [[MFMailComposeViewController alloc] init];
        [composer setMailComposeDelegate:self];
        [composer addAttachmentData:[NSData dataWithContentsOfFile:docFile] mimeType:@"text/plain" fileName:[edv.formName stringByAppendingString:@".epi7"]];
        [composer setSubject:@"Epi Info Data"];
        [composer setMessageBody:@"Here is some Epi Info data." isHTML:NO];
        [self presentViewController:composer animated:YES completion:^(void){
            mailComposerShown = YES;
        }];
    }
}

- (void)uploadAllRecords:(UIButton *)sender
{
    NSMutableArray *arrayOfAzureDictionaries = [[NSMutableArray alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"]])
    {
        NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
        if (sqlite3_open([databasePath UTF8String], &epiinfoDB) == SQLITE_OK)
        {
            NSString *selStmt = [NSString stringWithFormat:@"select * from %@", edv.formName];
            const char *query_stmt = [selStmt UTF8String];
            sqlite3_stmt *statement;
            if (sqlite3_prepare_v2(epiinfoDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSMutableDictionary *azureDictionary = [[NSMutableDictionary alloc] init];
                    
                    int i = 0;
                    BOOL idAlreadyAdded = NO;
                    
                    while (sqlite3_column_name(statement, i))
                    {
//                        NSLog(@"%s (%d):  %s", sqlite3_column_name(statement, i), sqlite3_column_type(statement, i), sqlite3_column_text(statement, i));
                        NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                        if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                        {
                            if (!idAlreadyAdded)
                                [azureDictionary setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] forKey:@"id"];
                            idAlreadyAdded = YES;
                        }
                        i++;
                    }
                    
                    i = 0;
                    
                    while (sqlite3_column_name(statement, i))
                    {
//                        NSLog(@"%s (%d):  %s", sqlite3_column_name(statement, i), sqlite3_column_type(statement, i), sqlite3_column_text(statement, i));
                        NSString *columnName = [[NSString alloc] initWithUTF8String:sqlite3_column_name(statement, i)];
                        if ([[columnName lowercaseString] isEqualToString:@"globalrecordid"])
                        {
                            i++;
                            continue;
                        }
                        if (sqlite3_column_type(statement, i) == 1)
                        {
                            [azureDictionary setObject:[NSNumber numberWithInt:sqlite3_column_int(statement, i)] forKey:columnName];
                        }
                        else if (sqlite3_column_type(statement, i) == 2)
                        {
                            [azureDictionary setObject:[NSNumber numberWithFloat:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] floatValue]] forKey:columnName];
                        }
                        else
                        {
                            if ([[self legalValuesDictionary] objectForKey:columnName.lowercaseString])
                            {
                                NSMutableArray *nsma = (NSMutableArray *)[[self legalValuesDictionary] objectForKey:columnName.lowercaseString];
                                int index = 0;
                                for (int j = 0; j < nsma.count; j++)
                                {
                                    if ([[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] isEqualToString:(NSString *)[nsma objectAtIndex:j]])
                                        index = j;
                                }
                                [azureDictionary setObject:[NSString stringWithFormat:@"%d", index] forKey:columnName];
                            }
                            else
                                [azureDictionary setObject:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] forKey:columnName];
                            if ([(NSString *)[azureDictionary objectForKey:columnName] isEqualToString:@"(null)"])
                                [azureDictionary removeObjectForKey:columnName];
                        }
                        i++;
                    }
                    
                    [arrayOfAzureDictionaries addObject:azureDictionary];
                }
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(epiinfoDB);
    }
    
    for (UIView *v in [[sender superview] subviews])
    {
        if ([v isKindOfClass:[UIButton class]])
            [(UIButton *)v setEnabled:NO];
        else if ([v isKindOfClass:[UIActivityIndicatorView class]])
        {
            [(UIActivityIndicatorView *)v setHidden:NO];
            [(UIActivityIndicatorView *)v startAnimating];
        }
    }
    
    NSMutableArray *uploads = [[NSMutableArray alloc] init];

    for (int i = 0; i < arrayOfAzureDictionaries.count; i++)
    {
//        [self.epiinfoService addItem:[NSDictionary dictionaryWithDictionary:(NSMutableDictionary *)[arrayOfAzureDictionaries objectAtIndex:i]] completion:^(NSUInteger index)
//         {
//             if ((int)index < 0)
//                 [uploads addObject:[NSNumber numberWithBool:NO]];
//             else
//                 [uploads addObject:[NSNumber numberWithBool:YES]];
//             
//             if (uploads.count == arrayOfAzureDictionaries.count)
//             {
//                 for (UIView *v in [[sender superview] subviews])
//                 {
//                     if ([v isKindOfClass:[UIButton class]])
//                     {
//                         if ([[(UIButton *)v titleLabel].text isEqualToString:@"Yes"])
//                         {
//                             [(UIButton *)v setHidden:YES];
//                         }
//                         else if ([[(UIButton *)v titleLabel].text isEqualToString:@"Cancel"])
//                         {
//                             [(UIButton *)v setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
//                             [(UIButton *)v setEnabled:YES];
//                         }
//                     }
//                     else if ([v isKindOfClass:[UILabel class]])
//                     {
//                         int numberOfRecordsUploaded = 0;
//                         for (id num in uploads)
//                             if ([(NSNumber *)num boolValue])
//                                 numberOfRecordsUploaded++;
//                         if (numberOfRecordsUploaded != 1)
//                             [(UILabel *)v setText:[NSString stringWithFormat:@"%d records sent to cloud table.", numberOfRecordsUploaded]];
//                         else
//                             [(UILabel *)v setText:[NSString stringWithFormat:@"%d record sent to cloud table.", numberOfRecordsUploaded]];
//                     }
//                     else if ([v isKindOfClass:[UIActivityIndicatorView class]])
//                     {
//                         [(UIActivityIndicatorView *)v stopAnimating];
//                         [(UIActivityIndicatorView *)v setHidden:YES];
//                     }
//                 }
//             }
//         }];
    }

//    [self doNotDismiss];
}

- (void)dismissForm;
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        [pickerLabel setHidden:NO];
        [lv setHidden:NO];
        [openButton setHidden:NO];
        [manageButton setHidden:NO];
        
        for (UIView *v in [dismissView subviews])
        {
            if ([v isKindOfClass:[UIImageView class]])
                [(UIImageView *)v setImage:nil];
            [v removeFromSuperview];
        }
        [dismissView removeFromSuperview];
        dismissView = nil;
        if ([edv.updateLocationThread isExecuting])
            [edv.updateLocationThread cancel];
        [edv removeFromSuperview];
        edv = nil;
        self.fieldsAndStringValues.nsmd = nil;
        [orangeBannerBackground removeFromSuperview];
        [orangeBanner removeFromSuperview];
        [footerBar removeFromSuperview];
        footerBar = nil;
        orangeBanner = nil;
        
        for (UIView *v in [self.view subviews])
            if ([v isKindOfClass:[BlurryView class]] || [v isKindOfClass:[EnterDataView class]])
                [v removeFromSuperview];
        // Return the Back button to the nav controller
//        [self.navigationItem setHidesBackButton:NO animated:YES];
        [self.navigationItem.leftBarButtonItem setEnabled:YES];
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [self.view.layer setTransform:rotate];
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [customBackButton setAlpha:1.0];
            [backToMainMenu setEnabled:YES];
            CATransform3D rotate = CATransform3DIdentity;
            rotate.m34 = 1.0 / -2000;
            rotate = CATransform3DRotate(rotate, M_PI * 0.0, 0.0, 1.0, 0.0);
            [self.view.layer setTransform:rotate];
        } completion:^(BOOL finished){
        }];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)popCurrentViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID
{
    [edv setGuidBeingUpdated:nil];
    [edv setPopulateInstructionCameFromLineList:YES];
    [edv populateFieldsWithRecord:tableNameAndGUID];
    [edv setPopulateInstructionCameFromLineList:NO];
    [footerBarNavigationItem setRightBarButtonItem:updateFooterBarButtonItem];
    updatingExistingRecord = YES;
}

- (void)populateFieldsWithRecord:(NSArray *)tableNameAndGUID OnEnterDataView:(UIView *)onEdv
{
    [(EnterDataView *)onEdv setGuidBeingUpdated:nil];
    [(EnterDataView *)onEdv setPopulateInstructionCameFromLineList:YES];
    [(EnterDataView *)onEdv populateFieldsWithRecord:tableNameAndGUID];
    [(EnterDataView *)onEdv setPopulateInstructionCameFromLineList:NO];
}

- (void)footerBarClear
{
    for (int i = (int)[self.view subviews].count - 1; i >= 0; i--)
    {
        id v = [[self.view subviews] objectAtIndex:i];
        if ([v isKindOfClass:[EnterDataView class]])
        {
            UIButton *button = [[UIButton alloc] init];
            [button setTag:9];
            [(EnterDataView *)v confirmSubmitOrClear:button];
            break;
        }
    }
}
- (void)footerBarSubmit
{
    for (int i = (int)[self.view subviews].count - 1; i >= 0; i--)
    {
        id v = [[self.view subviews] objectAtIndex:i];
        if ([v isKindOfClass:[EnterDataView class]])
        {
            UIButton *button = [[UIButton alloc] init];
            [(EnterDataView *)v confirmSubmitOrClear:button];
            break;
        }
    }
}
- (void)footerBarUpdate
{
    for (int i = (int)[self.view subviews].count - 1; i >= 0; i--)
    {
        id v = [[self.view subviews] objectAtIndex:i];
        if ([v isKindOfClass:[EnterDataView class]])
        {
            UIButton *button = [[UIButton alloc] init];
            [button setTag:8];
            [(EnterDataView *)v confirmSubmitOrClear:button];
            break;
        }
    }
}
- (void)footerBarDelete
{
    for (int i = (int)[self.view subviews].count - 1; i >= 0; i--)
    {
        id v = [[self.view subviews] objectAtIndex:i];
        if ([v isKindOfClass:[EnterDataView class]])
        {
            UIButton *button = [[UIButton alloc] init];
            [button setTag:7];
            [(EnterDataView *)v confirmSubmitOrClear:button];
            break;
        }
    }
}
- (void)resetHeaderAndFooterBars
{
    [(UINavigationItem *)[formNavigationItems lastObject] setRightBarButtonItems:@[[closeFormBarButtonItems lastObject]]];
    [footerBarNavigationItem setRightBarButtonItem:submitFooterBarButtonItem];
}
- (void)setFooterBarToUpdate
{
    [(UINavigationItem *)[formNavigationItems lastObject] setRightBarButtonItems:@[[closeFormBarButtonItems lastObject], [deleteRecordBarButtonItems lastObject]]];
    [footerBarNavigationItem setRightBarButtonItem:updateFooterBarButtonItem];
}
- (void)childFormDismissed
{
    if (updatingExistingRecord)
        [self setFooterBarToUpdate];
    else
        [self resetHeaderAndFooterBars];
}
-(BOOL)alreadyHasFooter
{
    if (footerBar)
        return YES;
    else
        return NO;
}
- (void)setFooterBarNavigationItemTitle:(NSString *)footerBarNavigationItemTitle
{
    footerBarNavigationItem.title = footerBarNavigationItemTitle;
}

- (void)createEColiFoodHistorySampleTable
{
    NSString *createTableStatement = @"create table Sample_EColiFoodHistory(GlobalRecordId text, CaseID integer, DateofInterview text, FirstName text, LastName text, Sex text, DOB text, Age integer, EthnicityGroup integer, White integer, NativeHawaiianOtherPacificIslander integer, UnknownOther integer, Black integer, AmericanIndianAlaskanNative integer, Asian integer, Multiracial integer, PatientAddress integer, State text, Latitude real, Longitude real, Occupation text, EmailAddress integer, HomePhone text, ILL integer, OnsetDate text, SymptomDuration integer, Headache integer, Fever integer, Vomiting integer, BloodyDiarrhea integer, NonBloodyDiarrhea integer, PoorFeeding integer, Chills integer, Irritable integer, Nausea integer, Abdominalcramps integer, LooseStoolsPerDay text, DoctorVisit integer, DoctorVisitDate text, Hospitalized integer, HospitalAdmissionDate text, Antibiotics integer, Died integer, DateOfDeath text, FeverTemp real, OnsetWeek integer, Freshcelery integer, Grapes integer, Blueberries integer, Breastmilk integer, Skimmilk integer, Cheddarcheese integer, Peaches integer, Americancheese integer, Strawberries integer, Orangejuice integer, Applejuice integer, Freshtomatoes integer, Beefjerkey integer, Sourcream integer, Viennasausages integer, N2milk integer, Icecream integer, Turkey integer, Wholemilk integer, Rawcarrots integer, Beansprouts integer, Butter integer, Cookedbacon integer, BuyLastTenDays integer, StoolSubmitted integer, O157H7isolated integer, StoolCollectionDate integer, Lab integer, LabResults integer)";
    
    NSArray *arrayOfInsertStatements = @[@"insert into Sample_EColiFoodHistory values('0051f8fb-e983-4223-a853-26f6c8f34a75',247,'5/11/2011',NULL,'Jackson','M-Male','1/1/1986',25,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59400177,-83.47499847,'Software developer',NULL,NULL,1,'5/4/2011',NULL,1,1,0,0,1,0,1,1,1,1,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.5,14,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('00a495c9-0f1f-402c-a0a9-35c9674a1b0d',277,'5/13/2011',NULL,'White','F-Female','10/4/1980',30,NULL,0,0,0,0,0,0,1,NULL,'GA',33.6269989,-83.61000061,'Manufacturing',NULL,NULL,1,'5/6/2011',NULL,1,1,1,0,1,1,0,0,0,1,'1-3 per day',1,'4/17/2011',NULL,NULL,NULL,0,NULL,101.6999969,15,0,1,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('00f66a66-f845-43d5-af74-e417bec77690',61,'5/18/2011',NULL,'Johnson','F-Female','3/11/1963',48,NULL,0,0,1,0,0,0,0,NULL,'GA',33.58499908,-83.17500305,'Unemployed',NULL,NULL,0,'5/11/2011',NULL,1,1,1,0,1,0,0,0,0,0,'1-3 per day',0,NULL,1,'6/3/2011',NULL,0,NULL,100.5,22,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('032f809d-6b3f-4bb4-b964-14d3ba4be397',258,'5/12/2011',NULL,'Williams','F-Female','4/19/1991',20,NULL,0,0,0,0,1,0,0,NULL,'GA',33.60300064,-83.62999725,'Police officer',NULL,NULL,1,'5/5/2011',NULL,1,1,1,1,0,0,1,1,0,0,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,14,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('04206aeb-c13d-4777-b061-445468205269',127,'5/24/2011',NULL,'Smith','F-Female','3/20/1987',24,NULL,1,0,0,0,0,0,0,NULL,'GA',33.57500076,-83.18499756,'Sales',NULL,NULL,1,'5/17/2011',NULL,1,1,1,1,0,0,0,0,1,0,'1-3 per day',1,'5/12/2011',1,'5/13/2011',1,0,NULL,101.9000015,19,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0,1,1,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('054a8247-065f-4d97-b987-f237b04bf994',323,'5/14/2011',NULL,'Brown','F-Female','2/4/1959',52,NULL,0,0,0,1,0,0,0,NULL,'GA',33.60300064,-83.47200012,'Lawyer',NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,1,1,'4-6 per day',0,NULL,1,'4/10/2011',1,0,NULL,102.5999985,14,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('055f18b4-42eb-4dad-be93-3f9075975674',152,'5/11/2011',NULL,'Davis','M-Male','9/16/1951',59,NULL,0,0,0,0,1,0,0,NULL,'GA',33.5870018,-83.44999695,'Scientist',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,0,0,0,0,1,0,'1-3 per day',1,'5/17/2011',0,NULL,1,0,NULL,NULL,20,0,0,0,0,1,0,1,1,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('069db84c-4bd7-48d9-b22e-4d082633c4ea',66,'5/7/2011',NULL,'Miller','M-Male','1/1/1990',21,NULL,0,0,0,0,1,0,0,NULL,'GA',33.6269989,-83.61000061,'Student',NULL,NULL,0,'4/30/2011',NULL,1,0,1,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,0,0,NULL,NULL,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('06c548b2-7432-43a8-80c5-68b44029f6ec',70,'5/12/2011',NULL,'Wilson','M-Male','1/1/1980',31,NULL,1,0,0,0,0,0,0,NULL,'GA',33.5870018,-83.46900177,'Sales',NULL,NULL,0,'5/5/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('08898b49-f28f-4995-9d6e-00270aa61579',233,'5/10/2011',NULL,'Moore','M-Male','10/10/1967',43,NULL,0,1,0,0,0,0,0,NULL,'GA',33.56600189,-83.49500275,'Food service worker',NULL,NULL,1,'5/3/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',NULL,NULL,NULL,NULL,NULL,0,NULL,100.1999969,14,0,1,0,0,1,1,0,0,0,0,1,1,0,1,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('090f4bf5-a8f9-4048-85be-b167a4635e92',275,'5/13/2011',NULL,'Taylor','F-Female','9/2/1958',52,NULL,0,0,0,0,0,0,1,NULL,'GA',33.58800125,-83.48000336,'Researcher',NULL,NULL,1,'5/6/2011',NULL,1,1,1,0,1,1,1,0,0,1,'4-6 per day',1,'4/17/2011',0,NULL,0,0,NULL,101.6999969,15,1,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0b0f3e3f-2bb4-4b1a-ab39-e695c9ca5ec7',224,'5/3/2011',NULL,'Anderson','F-Female','9/3/1992',18,NULL,0,0,0,0,0,0,1,NULL,'GA',33.59000015,-83.47000122,'Clerk',NULL,NULL,1,'4/26/2011',NULL,0,1,1,1,0,1,0,1,0,0,'4-6 per day',1,'4/25/2011',1,'4/27/2011',1,0,NULL,102,17,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0b5da598-6212-401b-914f-844ede50b675',116,'5/18/2011',NULL,'Thomas','M-Male','6/6/1950',60,NULL,1,0,0,0,0,0,0,NULL,'GA',33.58800125,-83.47399902,'Civil engineer',NULL,NULL,0,'5/11/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,1,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0b88e147-a9da-4f8f-85e9-18d4f76f6d07',312,'5/14/2011',NULL,'Jackson','M-Male','2/28/1982',29,NULL,0,0,1,0,0,0,0,NULL,'GA',33.56000137,-83.47899628,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,1,1,'4-6 per day',0,NULL,1,'4/24/2011',NULL,0,NULL,104.0999985,16,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0becdc74-5d53-4132-b59e-8cb56f21e355',300,'5/13/2011',NULL,'White','M-Male','1/1/1989',22,NULL,0,1,0,0,0,0,0,NULL,'GA',33.51399994,-83.69599915,NULL,NULL,NULL,1,'5/6/2011',NULL,0,1,0,1,0,0,1,1,1,1,'1-3 per day',0,NULL,1,'4/20/2011',0,0,NULL,NULL,15,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0c3a4209-e3d3-41df-ba55-0803bf01f312',156,'5/15/2011',NULL,'Harris','M-Male','4/11/1982',29,NULL,0,1,0,0,0,0,0,NULL,'GA',33.39300156,-83.59100342,'Researcher',NULL,NULL,1,'5/8/2011',NULL,1,1,0,1,0,0,0,0,1,0,'1-3 per day',0,NULL,0,NULL,1,0,NULL,NULL,20,0,0,0,0,1,0,1,1,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0c999ce8-ed9f-4a3b-bbe7-d524aa01d3b3',125,'5/19/2011',NULL,'Martin','F-Female','8/17/1963',47,NULL,0,0,0,0,0,1,0,NULL,'GA',33.6570015,-83.71600342,'Service worker',NULL,NULL,1,'5/12/2011',NULL,1,1,1,0,0,0,0,1,0,0,NULL,0,NULL,0,NULL,0,0,NULL,100.6999969,19,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0,1,1,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0c9df877-6df1-4e58-818d-a59fef41b84a',30,'5/17/2011',NULL,'Thompson','F-Female','3/1/1959',52,NULL,1,0,0,0,0,0,0,NULL,'GA',33.61299896,-83.5039978,'Food service worker',NULL,NULL,0,'5/10/2011',NULL,1,1,1,0,1,0,1,0,0,0,'4-6 per day',1,'4/28/2011',1,'4/29/2011',1,0,NULL,NULL,17,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0dae6841-c272-4459-8da1-d344f08c9edc',207,'5/11/2011',NULL,'Garcia','F-Female','8/18/1979',31,NULL,0,0,0,1,0,0,0,NULL,'GA',33.5909996,-83.46900177,'Food service worker',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,1,1,1,0,1,0,'7-10 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.5,14,0,1,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0eb0946f-5c50-43ac-9612-d145ed381302',246,'5/10/2011',NULL,'Martinez','F-Female','1/1/1982',29,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59400177,-83.47200012,'Sales',NULL,NULL,1,'5/3/2011',NULL,1,1,1,0,1,1,1,1,0,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.6999969,13,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0f5627fd-3a7d-4ac3-8d38-08f3cf4d4615',45,'5/16/2011',NULL,'Robinson','F-Female','5/30/1987',23,NULL,0,1,0,0,0,0,0,NULL,'GA',33.60100174,-83.45899963,'Teacher',NULL,NULL,0,'5/9/2011',NULL,1,1,1,1,1,1,1,1,0,1,'10+ per day',1,'5/3/2011',1,'5/4/2011',1,0,NULL,104.9000015,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0f75ae96-c68b-4f91-af63-38422b71b456',83,'5/8/2011',NULL,'Clark','M-Male','1/1/1972',39,NULL,0,0,0,0,0,0,1,NULL,'GA',33.57699966,-83.18199921,'Government',NULL,NULL,0,'5/1/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('0fdc8da1-dd50-4ce8-9176-2d5bf9cf2039',151,'5/9/2011',NULL,'Rodriguez','F-Female','3/1/1990',21,NULL,0,0,0,1,0,0,0,NULL,'GA',33.59999847,-83.45700073,'Student',NULL,NULL,1,'5/2/2011',NULL,1,1,1,1,0,0,0,0,1,0,'1-3 per day',1,'5/19/2011',1,'5/19/2011',1,0,NULL,NULL,20,0,0,0,0,1,0,1,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('11b7242f-b1eb-48a2-a5d7-ef4fd4ad7f65',41,'5/9/2011',NULL,'Lewis','M-Male','3/22/1977',34,NULL,0,0,0,0,1,0,0,NULL,'GA',33.58499908,-83.5039978,'Service worker',NULL,NULL,0,'5/2/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('12349177-a6aa-4e99-8bed-2cc08e1f0e4f',16,'5/15/2011',NULL,'Lee','F-Female','1/1/1982',29,NULL,0,0,0,0,0,1,0,NULL,'GA',33.79000092,-83.72299957,'Writer',NULL,NULL,1,'5/8/2011',NULL,1,1,1,1,0,0,0,1,0,0,'10+ per day',0,NULL,1,'4/9/2011',1,0,NULL,104.8000031,14,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,0,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('130002ca-d80f-4cf5-b42f-fe1386cae4dd',136,'5/8/2011',NULL,'Walker','F-Female','1/26/1999',12,NULL,0,0,1,0,0,0,0,NULL,'GA',33.51599884,-83.69499969,'Student',NULL,NULL,1,'5/1/2011',NULL,1,1,1,0,1,1,1,1,1,1,'7-10 per day',1,'5/15/2011',1,'5/15/2011',1,0,NULL,NULL,20,0,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('13e3934f-809a-4d9d-ab4a-90465ed8f5ba',358,'5/17/2011',NULL,'Hall','M-Male','11/11/1972',38,NULL,0,1,0,0,0,0,0,NULL,'GA',33.59000015,-83.47399902,'Service worker',NULL,NULL,1,'5/10/2011',NULL,1,1,0,1,1,1,1,1,1,0,'1-3 per day',1,NULL,0,NULL,0,0,NULL,101,15,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('156e2727-2856-4955-8761-1968655e4e39',77,'5/8/2011',NULL,'Allen','M-Male','1/15/1949',62,NULL,0,0,0,0,0,0,1,NULL,'GA',33.78699875,-83.60900116,'Mortician',NULL,NULL,0,'5/1/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('1609121c-ecc9-4802-a165-14842524b92c',165,'5/9/2011',NULL,'Young','F-Female','1/1/1920',91,NULL,0,0,0,1,0,0,0,NULL,'GA',33.60200119,-83.46800232,NULL,NULL,NULL,1,'5/2/2011',NULL,1,1,1,1,1,1,1,1,1,1,'7-10 per day',1,'4/30/2011',1,'4/30/2011',1,0,NULL,100.3000031,17,0,0,0,0,1,0,1,1,1,1,1,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('16283678-6cc7-4edf-829d-300ccd954150',313,'5/14/2011',NULL,'Hernandez','M-Male','8/30/1973',37,NULL,0,0,1,1,0,0,0,NULL,'GA',33.56399918,-83.36100006,'Transportation',NULL,NULL,1,'5/7/2011',NULL,1,1,0,1,1,0,1,1,0,1,'4-6 per day',0,NULL,1,'4/21/2011',NULL,0,NULL,104.6999969,16,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('164cf39d-9440-4918-94bd-66631f55dfdf',191,'5/17/2011',NULL,'King','F-Female','8/2/1978',32,NULL,0,1,0,0,0,0,0,NULL,'GA',33.56999969,-83.16500092,'Mechanical engineer',NULL,NULL,1,'5/10/2011',NULL,1,1,1,1,0,1,0,0,0,1,'1-3 per day',0,NULL,0,NULL,0,0,NULL,100.3000031,16,0,0,1,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('187192f9-47ef-4d9c-b036-d49648cfca73',67,'5/10/2011',NULL,'Wright','F-Female','1/1/1981',30,NULL,0,0,0,0,1,0,0,NULL,'GA',33.62099838,-83.68099976,'Lawyer',NULL,NULL,0,'5/3/2011',NULL,0,1,0,0,0,0,0,0,0,0,NULL,1,'6/3/2011',0,NULL,NULL,0,NULL,100.3000031,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('192d8a62-5c31-4697-9322-bb42d62d9de1',220,'5/3/2011',NULL,'Lopez','F-Female','1/1/1993',18,NULL,0,0,1,0,0,0,0,NULL,'GA',33.58300018,-83.36199951,'Farmer',NULL,NULL,1,'4/26/2011',NULL,1,1,1,1,0,1,1,1,1,0,'1-3 per day',1,NULL,NULL,NULL,NULL,0,NULL,NULL,13,1,1,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('19959149-1e26-4f80-91ca-ae04b8a89153',217,'4/29/2011',NULL,'Hill','F-Female','8/28/1962',48,NULL,0,0,0,0,0,0,1,NULL,'GA',33.40100098,-83.58699799,'Manufacturing',NULL,NULL,1,'4/22/2011',NULL,0,1,1,1,1,0,1,1,0,0,'7-10 per day',1,'4/26/2011',1,'4/26/2011',NULL,0,NULL,104.5,16,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('199cc95e-6f5c-4083-b79e-62f6616823f3',356,'5/17/2011',NULL,'Scott','F-Female','2/8/1952',59,NULL,1,0,0,0,0,0,0,NULL,'GA',33.62900162,-83.61199951,NULL,NULL,NULL,1,'5/10/2011',NULL,1,1,1,0,1,1,0,1,1,0,'1-3 per day',1,NULL,1,'4/21/2011',1,0,NULL,103.8000031,16,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('1a8244a3-43dc-4d22-8b32-7bbb7e738f94',261,'5/12/2011',NULL,'Green','F-Female','1/1/1983',28,NULL,0,0,0,0,1,0,0,NULL,'GA',33.59899902,-83.45700073,'Service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,1,0,0,0,1,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,16,0,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('1b07b448-0491-41ec-b683-a77cee73dae0',9,'5/12/2011',NULL,'Adams','M-Male','10/10/1985',25,NULL,1,0,0,0,0,0,0,NULL,'GA',33.52500153,-83.22799683,'Soldier',NULL,NULL,0,'5/5/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('1d27d889-ed54-4e17-9a59-b4bfebef3ee2',342,'5/10/2011',NULL,'Baker','M-Male','2/17/1983',28,NULL,0,0,0,0,0,0,1,NULL,'GA',33.5909996,-83.47599792,NULL,NULL,NULL,1,'5/3/2011',NULL,1,1,1,0,1,1,1,1,1,1,'1-3 per day',1,NULL,0,NULL,1,0,NULL,NULL,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('1d2c653e-1b7b-4bed-9416-a41ef7813d4e',64,'5/30/2011',NULL,'Gonzalez','M-Male','1/1/1986',25,NULL,0,0,0,0,1,0,0,NULL,'GA',33.74000168,-83.3030014,'Service worker',NULL,NULL,0,'5/23/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('1d74cc18-4501-49ab-812f-326bbac16302',239,'5/10/2011',NULL,'Nelson','F-Female','7/27/1954',56,NULL,0,1,0,0,0,0,0,NULL,'GA',33.5890007,-83.47399902,'Food service worker',NULL,NULL,1,'5/3/2011',NULL,1,1,0,1,1,0,1,0,1,1,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,102.0999985,17,0,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('1e0e653b-09a0-4830-a896-eaacb04120a1',337,'5/15/2011',NULL,'Carter','M-Male','9/25/1943',67,NULL,0,0,0,0,0,1,0,NULL,'GA',33.30500031,-83.2009964,NULL,NULL,NULL,1,'5/8/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',0,NULL,1,'4/4/2011',1,0,NULL,103.0999985,14,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,0,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('1e983862-ca09-476b-bd26-1bd03609ab80',330,'5/14/2011',NULL,'Mitchell','M-Male','10/23/1971',39,NULL,0,0,0,0,1,0,0,NULL,'GA',33.5909996,-83.47599792,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,0,1,1,1,1,0,1,1,'10+ per day',0,NULL,1,'4/20/2011',1,0,NULL,104.0999985,16,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('1eabbb32-253c-4fcf-9978-d6776c063bf6',174,'5/15/2011',NULL,'Perez','M-Male','4/16/1981',30,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59899902,-83.45700073,'Researcher',NULL,NULL,1,'5/8/2011',NULL,1,1,1,1,1,1,1,0,1,1,'7-10 per day',1,'4/21/2011',1,'4/22/2011',0,0,NULL,105.5999985,16,0,1,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('200fd960-fde8-46de-a46a-d5dcfea0b7d3',282,'5/13/2011',NULL,'Roberts','M-Male','9/29/1969',41,NULL,0,0,0,0,0,0,1,NULL,'GA',33.54899979,-83.5039978,'Janitor',NULL,NULL,1,'5/6/2011',NULL,1,1,0,1,1,1,0,1,1,1,'4-6 per day',1,'4/29/2011',1,'4/30/2011',0,0,NULL,103.5,17,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('201551ef-53f8-4072-99da-d4aa85796da1',208,'5/17/2011',NULL,'Turner','F-Female','12/25/1975',35,NULL,0,0,0,0,1,0,0,NULL,'GA',33.5,-83.3769989,'Food service worker',NULL,NULL,1,'5/10/2011',NULL,1,1,1,0,1,1,1,0,1,0,'7-10 per day',NULL,NULL,NULL,NULL,NULL,1,'4/29/2011',103.4000015,16,0,1,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('23940986-311c-4ade-a29e-d3db0d5516d4',212,'5/5/2011',NULL,'Phillips','F-Female','5/22/1979',31,NULL,0,1,0,0,0,0,0,NULL,'GA',33.57899857,-83.48100281,'Nurse',NULL,NULL,1,'4/28/2011',NULL,1,1,1,1,0,0,1,1,1,0,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,103.4000015,15,0,0,0,0,1,1,0,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2394365b-0403-4eb4-afc7-a7f8def003dc',37,'5/16/2011',NULL,'Campbell','M-Male','4/8/1954',57,NULL,0,1,0,0,0,0,0,NULL,'GA',33.58499908,-83.47299957,'Actor',NULL,NULL,0,'5/9/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('23c58fea-1272-4570-bafd-511f1cfb4e91',141,'5/10/2011',NULL,'Parker','F-Female','5/24/1952',58,NULL,1,0,0,0,0,0,0,NULL,'GA',33.56999969,-83.18199921,'Service worker',NULL,NULL,1,'5/3/2011',NULL,1,1,0,0,0,0,1,1,1,0,NULL,1,NULL,1,NULL,0,0,NULL,NULL,20,1,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('240ca8c2-2504-4f8a-b0cf-9ade00287f0e',92,'5/1/2011',NULL,'Evans','F-Female','6/14/1961',49,NULL,1,0,0,0,0,0,0,NULL,'GA',33.59799957,-83.46800232,'Civil engineer',NULL,NULL,1,'4/24/2011',NULL,1,1,0,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,0,0,NULL,104.0999985,15,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2435d354-4be0-4b74-bb4d-50fae883fb46',173,'5/16/2011',NULL,'Edwards','M-Male','9/14/1961',49,NULL,0,0,0,0,1,0,0,NULL,'GA',33.46900177,-83.31700134,'Manufacturing',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',1,'4/18/2011',1,'4/19/2011',1,0,NULL,NULL,15,0,1,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('25b06d02-534a-4e4b-b902-234875b87002',254,'5/11/2011',NULL,'Collins','F-Female','1/1/1940',NULL,NULL,0,0,0,1,0,0,0,NULL,'GA',33.58599854,-83.16600037,NULL,NULL,NULL,1,'5/4/2011',NULL,1,1,1,0,0,1,1,1,0,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,15,0,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('25f5ecb7-31da-4021-839f-205f6e837e49',132,'5/16/2011',NULL,'Stewart','M-Male','10/2/1982',28,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59000015,-83.47200012,'Equipment technician',NULL,NULL,1,'5/9/2011',NULL,1,1,0,1,1,0,0,0,1,0,'7-10 per day',1,'5/18/2011',1,'5/19/2011',1,0,NULL,102.5999985,20,0,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,0,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('26257819-c14c-4d99-9473-96693b7e0a18',184,'5/12/2011',NULL,'Sanchez','M-Male','11/7/1978',32,NULL,0,1,0,0,0,0,0,NULL,'GA',33.58599854,-83.47299957,'Professional althlete',NULL,NULL,1,'5/5/2011',NULL,1,1,1,1,1,1,0,0,1,0,'4-6 per day',1,'4/15/2011',1,'4/16/2011',0,0,NULL,100.3000031,15,0,1,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('26571dac-6baf-486a-9548-5439c9519ae7',257,'5/11/2011',NULL,'Morris','M-Male','3/21/1984',27,NULL,0,0,0,1,0,0,0,NULL,'GA',33.7859993,-83.61000061,'Service worker',NULL,NULL,1,'5/4/2011',NULL,1,1,1,0,0,1,1,1,0,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,17,0,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('26a98f82-3768-41b2-a57d-644e078fa77d',185,'5/17/2011',NULL,'Rogers','F-Female','12/16/1980',30,NULL,0,0,1,0,0,0,0,NULL,'GA',33.47200012,-83.31500244,'Dancer',NULL,NULL,1,'5/10/2011',NULL,1,1,1,1,0,1,0,0,0,0,'1-3 per day',1,'4/16/2011',1,'4/16/2011',0,0,NULL,102.0999985,15,0,1,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('26cd7eaa-9c6b-40ff-9d47-75a335165f40',315,'5/14/2011',NULL,'Reed','M-Male','10/5/1976',34,NULL,0,0,1,0,0,0,0,NULL,'GA',33.5870018,-83.47799683,'Service worker',NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,1,1,'1-3 per day',0,NULL,1,'4/20/2011',NULL,0,NULL,106,15,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('26d33e63-6d18-4443-a273-048c656dcc14',194,'5/20/2011',NULL,'Cook','F-Female','5/12/1977',34,NULL,0,0,0,0,1,0,0,NULL,'GA',33.7859993,-83.6309967,'Service worker',NULL,NULL,1,'5/13/2011',NULL,1,1,1,1,1,1,0,0,1,0,'7-10 per day',1,'4/2/2011',1,'4/2/2011',0,0,NULL,100.5,13,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('288d11da-3dc4-4dc5-8788-2bf3bf82a50a',283,'5/13/2011',NULL,'Morgan','F-Female','2/20/1961',50,NULL,0,0,0,0,0,0,1,NULL,'GA',33.59000015,-83.41999817,'Manufacturing',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',1,'4/30/2011',0,'4/30/2011',1,0,NULL,101,17,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('28ccb7c0-e45f-4df9-a90a-0cd2a712fe23',200,'5/26/2011',NULL,'Bell','F-Female','5/7/1997',14,NULL,0,0,0,1,0,0,0,NULL,'GA',33.58800125,-83.50900269,'Student',NULL,NULL,1,'5/19/2011',NULL,0,1,0,1,1,0,1,0,1,1,'4-6 per day',1,'4/23/2011',1,'4/24/2011',0,0,NULL,103,16,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('29d87f48-2af5-4955-8425-06e27d426cdc',31,'5/17/2011',NULL,'Murphy','F-Female','1/22/1986',25,NULL,0,1,0,0,0,0,0,NULL,'GA',33.60699844,-83.47299957,'Unemployed',NULL,NULL,0,'5/10/2011',NULL,1,1,1,0,1,0,1,0,1,1,'10+ per day',1,NULL,0,NULL,0,0,NULL,NULL,16,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2ad8d354-0069-4d22-9bc3-cb5472e88a8e',17,'5/15/2011',NULL,'Bailey','M-Male','1/1/1968',43,NULL,0,0,0,0,0,0,1,NULL,'GA',33.53499985,-83.31199646,'Government',NULL,NULL,0,'5/8/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2b2ad301-909d-4db7-86ea-73c12182ac0a',101,'5/17/2011',NULL,'Rivera','F-Female','1/15/1978',33,NULL,0,0,0,0,0,1,0,NULL,'GA',33.61800003,-83.32099915,'Food service worker',NULL,NULL,0,'5/9/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2bd26944-aa96-431d-9c2a-e7198388c283',219,'5/2/2011',NULL,'Cooper','F-Female','7/28/1997',13,NULL,0,1,0,0,0,0,0,NULL,'GA',33.59600067,-83.46399689,'Student',NULL,NULL,1,'4/25/2011',NULL,0,1,1,1,1,1,1,1,0,0,'7-10 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,14,0,1,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2bdb4237-9164-4545-a33f-941d3903ee15',47,'5/17/2011',NULL,'Richardson','M-Male','1/1/1940',71,NULL,0,0,0,1,0,0,0,NULL,'GA',33.54899979,-83.47399902,NULL,NULL,NULL,0,'5/10/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2c53f550-c75e-408e-98d1-194032ce98cb',271,'5/12/2011',NULL,'Cox','F-Female','1/1/1972',39,NULL,0,0,0,0,0,1,0,NULL,'GA',33.5870018,-83.46900177,'Teacher',NULL,NULL,1,'5/5/2011',NULL,0,1,0,1,1,1,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,14,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2c6a80a3-5c67-4b02-84b8-8e929187d1a6',308,'5/14/2011',NULL,'Howard','F-Female','1/1/1980',31,NULL,0,0,1,0,0,0,0,NULL,'GA',33.55699921,-83.5,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,1,1,'1-3 per day',1,'4/29/2011',1,'5/1/2011',0,0,NULL,103.4000015,17,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2d80eb81-9594-4695-beb6-2fa7be2bdefe',4,'5/12/2011',NULL,'Ward','M-Male','1/30/1968',43,NULL,0,0,0,1,0,0,0,NULL,'GA',33.57899857,-83.48000336,'Food service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,0,1,0,0,0,0,0,0,'1-3 per day',0,NULL,0,NULL,0,0,NULL,102.6999969,14,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2e02069d-4017-4edf-8e19-912c6940eba2',226,'5/7/2011',NULL,'Torres','F-Female','8/10/1998',12,NULL,1,0,0,0,0,0,0,NULL,'GA',33.61100006,-83.08000183,'Student',NULL,NULL,1,'4/30/2011',NULL,1,1,1,1,1,0,0,1,1,0,'1-3 per day',1,'4/22/2011',1,'4/22/2011',1,0,NULL,100.5999985,16,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2e2a0e0a-86ec-4f44-8d02-6eedf8eddcb4',343,'5/6/2011',NULL,'Peterson','M-Male','2/18/1986',25,NULL,0,0,0,0,0,0,1,NULL,'GA',33.59600067,-83.46399689,NULL,NULL,NULL,1,'4/29/2011',NULL,0,1,1,1,1,1,1,1,1,1,'4-6 per day',1,NULL,0,NULL,1,0,NULL,NULL,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('2eadcd64-c61c-45f4-84a1-dd010b3d6329',189,'5/17/2011',NULL,'Gray','M-Male','7/15/1974',36,NULL,0,0,0,0,0,0,1,NULL,'GA',33.63800049,-83.32800293,'Mechanical engineer',NULL,NULL,1,'5/9/2011',NULL,1,1,0,1,0,1,1,1,0,0,'1-3 per day',1,NULL,1,NULL,1,0,NULL,103.5999985,16,0,1,1,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('302f750f-1fb4-4496-a715-cbd624e36fc6',65,'5/27/2011',NULL,'Ramirez','F-Female','2/26/1993',18,NULL,0,0,0,0,1,0,0,NULL,'GA',33.56399918,-83.17500305,'Student',NULL,NULL,0,'5/20/2011',NULL,1,1,0,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,NULL,0,NULL,NULL,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('3119b0ee-9acd-4ba2-ba0d-474194d36c34',144,'5/13/2011',NULL,'James','F-Female','8/8/1982',28,NULL,0,0,0,1,0,0,0,NULL,'GA',33.65499878,-83.71800232,'Nurse',NULL,NULL,1,'5/6/2011',NULL,1,1,1,0,0,0,1,1,1,0,NULL,1,NULL,1,NULL,0,0,NULL,NULL,20,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('3420f00e-d009-4788-b868-482b8bd7819b',29,'5/15/2011',NULL,'Watson','M-Male','2/9/1994',17,NULL,1,0,0,0,0,0,0,NULL,'GA',33.5929985,-83.47299957,'Police officer',NULL,NULL,0,'5/8/2011',NULL,1,1,1,1,1,0,1,1,1,0,'7-10 per day',1,'5/1/2011',1,'5/2/2011',1,0,NULL,NULL,17,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('36a0d1dd-08f7-47df-8052-a59f3b615078',35,'5/13/2011',NULL,'Brooks','M-Male','12/9/1983',27,NULL,0,0,0,0,0,1,0,NULL,'GA',33.70199966,-83.60199738,'Transportation',NULL,NULL,0,'5/6/2011',NULL,1,1,0,0,1,0,1,0,0,1,'1-3 per day',0,NULL,0,NULL,0,0,NULL,NULL,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('38b22794-cba9-4631-9b98-ed1421b322ce',328,'5/14/2011',NULL,'Kelley','M-Male','12/11/1971',39,NULL,0,0,0,0,1,0,0,NULL,'GA',33.46500015,-83.30000305,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,1,1,'1-3 per day',1,'4/26/2011',0,NULL,0,0,NULL,102.1999969,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('38dfd4af-5046-44cc-8bd7-6b10cd9ed539',269,'5/12/2011',NULL,'Sanders','M-Male','3/3/1983',28,NULL,0,0,0,0,0,1,0,NULL,'GA',33.5929985,-83.46600342,'Service worker',NULL,NULL,1,'5/5/2011',NULL,0,1,0,1,1,0,1,1,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,16,1,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('3b3d447f-a6b7-4cf5-a6fa-fa52091c5286',340,'5/11/2011',NULL,'Price','F-Female','3/24/1999',12,NULL,0,0,0,0,0,1,0,NULL,'GA',33.5929985,-83.47299957,NULL,NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,1,1,1,1,0,1,'4-6 per day',1,'4/15/2011',0,NULL,1,0,NULL,103.1999969,15,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('3d71cc63-52dc-446a-8780-9ea4ec6aa542',260,'5/12/2011',NULL,'Bennet','M-Male','1/1/1965',46,NULL,0,0,0,0,1,0,0,NULL,'GA',33.56999969,-83.36399841,'Service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,0,1,0,1,0,1,1,0,'4-6 per day',1,'4/22/2011',1,'4/24/2011',1,0,NULL,NULL,16,1,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('3e5685e4-ccd2-4b83-bfc2-682eec9fd50d',349,'5/23/2011',NULL,'Wood','M-Male','1/1/1982',29,NULL,0,0,0,0,0,0,0,NULL,'GA',33.62799835,-83.61499786,'Service worker',NULL,NULL,1,'5/16/2011',NULL,1,1,1,1,0,1,1,1,0,0,'1-3 per day',1,'4/8/2011',0,NULL,1,0,NULL,NULL,14,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('3f397167-0c5f-46a9-89a7-d9d7e97ee3f2',177,'5/16/2011',NULL,'Barnes','M-Male','12/6/1978',32,NULL,0,1,0,0,0,0,0,NULL,'GA',33.63299942,-83.62999725,'Consultant',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,1,0,1,1,1,0,'1-3 per day',1,'4/15/2011',1,'4/15/2011',0,0,NULL,101.0999985,15,0,0,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('409f7d70-3dd0-4ba3-a174-99fab814c236',102,'5/15/2011',NULL,'Ross','F-Female','8/1/1996',14,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59199905,-83.46299744,'Student',NULL,NULL,0,'5/8/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('411b21d6-d6d3-4e8e-bb50-733751086f3d',122,'5/19/2011',NULL,'Henderson','F-Female','6/27/1965',45,NULL,0,0,1,0,0,0,0,NULL,'GA',33.58399963,-83.46099854,'Electrical engineer',NULL,NULL,1,'5/12/2011',NULL,1,1,0,1,0,0,0,0,1,0,'1-3 per day',1,'5/16/2011',1,'5/16/2011',0,0,NULL,100,20,1,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,NULL,1,0,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('42cb1a8b-a309-4364-b663-1ca0cdd2171e',57,'5/24/2011',NULL,'Coleman','M-Male','8/7/1941',69,NULL,0,0,0,0,0,1,0,NULL,'GA',33.5890007,-83.4960022,NULL,NULL,NULL,0,'5/17/2011',NULL,1,1,1,0,1,0,0,0,0,0,'4-6 per day',1,'6/1/2011',NULL,NULL,NULL,0,NULL,103.0999985,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('4409a759-c61a-48ac-926a-d315694593ef',240,'5/10/2011',NULL,'Jackson','M-Male','1/1/1960',51,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59000015,-83.47399902,'Manufacturing',NULL,NULL,1,'5/3/2011',NULL,1,1,1,1,1,1,1,1,1,1,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,102.3000031,17,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('445800ed-54c0-4d60-9fdd-d516025a49e5',93,'5/6/2011',NULL,'White','F-Female','6/22/1961',49,NULL,0,1,0,0,0,0,0,NULL,'GA',33.3219986,-83.39499664,'Teacher',NULL,NULL,1,'4/29/2011',NULL,1,1,0,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,0,0,NULL,103.8000031,17,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('45416581-bc8d-4cb5-ae6c-1cd1fea7a304',280,'5/13/2011',NULL,'Johnson','F-Female','11/4/1996',14,NULL,0,0,0,0,0,0,1,NULL,'GA',33.77500153,-83.61399841,'Student',NULL,NULL,1,'5/6/2011',NULL,1,1,0,0,1,1,0,1,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101,15,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('45937814-856f-481e-ada3-90d5c8531355',336,'5/15/2011',NULL,'Williams','F-Female','1/1/1990',21,NULL,0,0,0,0,0,1,0,NULL,'GA',33.60300064,-83.45400238,NULL,NULL,NULL,1,'5/8/2011',NULL,0,1,1,1,1,1,1,0,1,1,'4-6 per day',0,NULL,0,NULL,1,0,NULL,102.5,14,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('460e683d-f4fe-4d55-92c2-c921fc7956e4',74,'5/12/2011',NULL,'Smith','F-Female','2/21/1996',15,NULL,0,0,0,0,1,0,0,NULL,'GA',33.57400131,-83.47599792,'Student',NULL,NULL,0,'5/5/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,100.9000015,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('461329a9-09a9-440e-8842-65faf838bd3a',317,'5/14/2011',NULL,'Brown','M-Male','1/1/1963',48,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59199905,-83.47000122,'Government',NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,0,1,'4-6 per day',1,'4/27/2011',0,NULL,0,0,NULL,103.6999969,17,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('46562bf8-9079-430d-b529-8cf403b74421',59,'5/22/2011',NULL,'Davis','M-Male','4/8/1961',50,NULL,1,0,0,0,0,0,0,NULL,'GA',33.58200073,-83.49099731,'Doctor',NULL,NULL,0,'5/15/2011',NULL,1,1,1,1,1,0,0,0,0,0,'1-3 per day',1,'5/27/2011',NULL,NULL,NULL,0,NULL,102.5999985,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('475603bd-1640-4116-89cc-1e607dd6a536',80,'5/9/2011',NULL,'Miller','F-Female','11/18/1987',23,NULL,0,0,0,0,0,0,1,NULL,'GA',33.625,-83.68699646,'Mortician',NULL,NULL,1,'5/2/2011',NULL,1,1,1,0,1,0,0,0,0,0,'1-3 per day',0,NULL,0,NULL,0,0,NULL,100.5999985,17,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('48d92517-a2c8-4f51-9c1b-23ec8c3d93c8',97,'5/17/2011',NULL,'Wilson','F-Female','12/13/1990',20,NULL,0,0,0,0,0,1,0,NULL,'GA',33.57500076,-83.51300049,'Student',NULL,NULL,1,'5/10/2011',NULL,1,1,1,0,1,0,0,0,0,1,'1-3 per day',0,NULL,0,NULL,0,0,NULL,101.3000031,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('4acaacc8-0426-4404-b876-9fb7569ecc82',1,'5/9/2011','Anna','Moore','F-Female','1/12/1982',NULL,NULL,1,0,0,0,0,0,0,NULL,'GA',33.5870018,-83.46600342,'Business executive',NULL,NULL,1,'5/2/2011',NULL,1,1,1,1,1,1,1,1,1,1,'4-6 per day',1,'4/3/2011',1,'4/4/2011',1,1,'4/7/2011',104.5,13,1,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,1,0,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('4c0434b1-6273-4f3e-962e-be9faf0d2abd',193,'5/20/2011',NULL,'Taylor','M-Male','8/19/1998',12,NULL,0,0,0,1,0,0,0,NULL,'GA',33.56100082,-83.17700195,'Student',NULL,NULL,1,'5/13/2011',NULL,1,1,1,1,1,1,0,0,1,0,'1-3 per day',1,'4/7/2011',1,'4/7/2011',NULL,0,NULL,99.19999695,14,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('4c24aacc-8a82-42bb-b19f-cc48b498797b',34,'5/15/2011',NULL,'Anderson','F-Female','5/18/1960',50,NULL,0,0,0,0,1,0,0,NULL,'GA',33.61399841,-83.43900299,'Printer',NULL,NULL,0,'5/8/2011',NULL,1,0,0,0,1,0,0,0,0,0,'1-3 per day',0,NULL,0,NULL,1,0,NULL,NULL,14,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('501f841c-4c2c-46f7-b70d-b3416664f427',88,'5/5/2011',NULL,'Thomas','F-Female','9/27/1988',22,NULL,0,0,0,0,0,0,1,NULL,'GA',33.59600067,-83.52500153,'Student',NULL,NULL,1,'4/28/2011',NULL,1,1,1,0,1,0,0,0,0,0,'1-3 per day',0,NULL,0,NULL,0,0,NULL,102.1999969,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('506166f6-3522-4dd6-80ca-e028ada9880a',329,'5/14/2011',NULL,'Jackson','F-Female','8/1/1959',51,NULL,0,0,0,0,1,0,0,NULL,'GA',33.58499908,-83.47200012,'Accountant',NULL,NULL,1,'5/7/2011',NULL,0,1,0,1,1,0,1,1,1,1,'1-3 per day',1,'4/16/2011',0,NULL,1,0,NULL,100.4000015,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('526f517f-3eb3-47b9-bfad-8c5cc9ed2c93',99,'5/15/2011',NULL,'White','M-Male','3/10/1940',71,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59000015,-83.47000122,'Teacher',NULL,NULL,1,'5/8/2011',NULL,1,1,1,1,1,0,1,0,0,1,'7-10 per day',1,'5/13/2011',1,'5/13/2011',1,0,NULL,99.80000305,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('52a3e8e2-d4e5-4c48-bd61-b98d7276af72',115,'5/16/2011',NULL,'Harris','M-Male','12/8/1986',24,NULL,1,0,0,0,0,0,0,NULL,'GA',33.59000015,-83.46900177,'Actor',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,1,0,0,0,1,0,'1-3 per day',1,'5/5/2011',0,NULL,0,0,NULL,103.4000015,18,0,1,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,1,1,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('52eac11a-a050-4545-a683-59c8b41730e9',188,'5/16/2011',NULL,'Martin','M-Male','5/12/1954',57,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59899902,-83.46199799,'Business executive',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,0,1,0,0,0,1,'4-6 per day',0,NULL,0,NULL,0,0,NULL,103.1999969,17,0,1,1,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('5347d433-4a12-43c6-b7d7-c4c8813d1218',52,'5/18/2011',NULL,'Thompson','M-Male','1/9/1962',49,NULL,0,0,0,1,0,0,0,NULL,'GA',33.58499908,-83.47200012,'Manufacturing',NULL,NULL,0,'5/11/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('537b83c9-12df-4763-a28b-3e0611bab4cb',137,'5/11/2011',NULL,'Garcia','M-Male','7/22/1973',37,NULL,0,0,0,1,0,0,0,NULL,'GA',33.51900101,-83.69300079,'Janitor',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,0,0,1,1,1,1,'4-6 per day',1,'5/16/2011',0,NULL,0,0,NULL,NULL,20,0,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('554c017e-544b-4151-bb73-b6210ba418a8',50,'5/17/2011',NULL,'Martinez','F-Female','1/1/1955',56,NULL,0,0,0,1,0,0,0,NULL,'GA',33.59600067,-83.46399689,'Clerk',NULL,NULL,0,'5/9/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,103.0999985,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('5654b772-0131-4375-b1c3-f1e0f1c4e91f',250,'5/11/2011',NULL,'Robinson','F-Female','2/25/1957',54,NULL,0,0,0,1,0,0,0,NULL,'GA',33.40100098,-83.58699799,'Security guard',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,1,0,0,1,1,1,'1-3 per day',1,NULL,NULL,NULL,NULL,0,NULL,101,17,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('56f39abe-f737-4659-a67d-906cd3a5b750',134,'5/30/2011',NULL,'Clark','M-Male','1/2/1968',43,NULL,1,0,0,0,0,0,0,NULL,'GA',33.5929985,-83.46600342,'Manager',NULL,NULL,1,'5/23/2011',NULL,1,1,1,1,0,1,1,0,1,1,'7-10 per day',1,'5/17/2011',0,NULL,0,0,NULL,103.4000015,20,0,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,0,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('571085e8-e43a-44df-8d2d-69d04921a572',106,'5/12/2011',NULL,'Rodriguez','M-Male','10/16/1958',52,NULL,0,0,0,0,0,1,0,NULL,'GA',33.5909996,-83.46900177,'Police officer',NULL,NULL,1,'5/5/2011',NULL,1,0,0,1,1,0,0,0,0,1,'10+ per day',0,NULL,1,'5/5/2011',1,1,'5/8/2011',105.0999985,18,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('571bc7bd-1a01-4532-86ef-97a5ebf3c7e3',109,'5/15/2011',NULL,'Lewis','F-Female','7/19/1974',36,NULL,0,1,0,0,0,0,0,NULL,'GA',33.59899902,-83.46099854,'Civil engineer',NULL,NULL,1,'5/8/2011',NULL,1,0,0,1,0,0,0,0,1,1,'4-6 per day',1,'5/13/2011',0,NULL,0,0,NULL,NULL,19,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,1,0,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('57746d1c-5b44-4c48-b305-c9af422048ae',199,'5/23/2011',NULL,'Lee','M-Male','2/15/1993',18,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59999847,-83.46299744,'Student',NULL,NULL,1,'5/16/2011',NULL,0,1,1,1,0,0,1,1,1,0,'4-6 per day',0,NULL,1,'4/19/2011',NULL,0,NULL,101.1999969,15,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('59a152ea-6509-4cbb-9ca8-024778d618f6',290,'5/13/2011',NULL,'Walker','F-Female','1/1/1943',68,NULL,1,0,0,0,0,0,0,NULL,'GA',33.60200119,-83.45999908,NULL,NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',1,NULL,1,NULL,1,0,NULL,NULL,15,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('5a178600-37ca-4b3d-bfe1-1312423572de',82,'5/10/2011',NULL,'Hall','M-Male','8/12/1953',57,NULL,0,0,0,0,0,0,1,NULL,'GA',33.5890007,-83.31700134,'Police officer',NULL,NULL,1,'5/3/2011',NULL,1,1,1,1,0,0,0,0,0,0,'1-3 per day',1,'4/26/2011',0,NULL,0,0,NULL,103.1999969,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('5d46df47-0aaf-451e-bf73-dc7e30980541',113,'5/15/2011',NULL,'Allen','M-Male','10/23/1983',27,NULL,0,0,0,0,0,1,0,NULL,'GA',33.57300186,-83.19499969,'Artist',NULL,NULL,0,'5/8/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,1,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,1,1,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('5dac08c6-c9ce-4ee5-b01e-e0ce9ecd2f00',318,'5/14/2011',NULL,'Young','F-Female','3/3/1965',46,NULL,0,0,1,0,0,0,0,NULL,'GA',33.58300018,-83.48500061,'Service worker',NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,0,0,'1-3 per day',0,NULL,1,'4/29/2011',NULL,0,NULL,105.5999985,17,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('5e134582-7ab1-40a8-a15c-c44de58c0afe',12,'5/10/2011',NULL,'Hernandez','F-Female','2/26/1926',85,NULL,0,1,0,0,0,0,0,NULL,'GA',33.60400009,-83.46399689,NULL,NULL,NULL,1,'5/3/2011',NULL,1,1,0,0,1,0,1,0,0,1,'4-6 per day',0,NULL,0,NULL,0,0,NULL,101.5,14,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('5ee71ee4-a955-4b8c-a44c-129682aeb2fb',327,'5/14/2011',NULL,'King','F-Female','12/13/1962',48,NULL,0,0,0,0,1,0,0,NULL,'GA',33.5909996,-83.50700378,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,0,1,'1-3 per day',1,'4/16/2011',0,NULL,1,0,NULL,103,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('60a154c3-458d-433b-bab4-c7098da90db4',98,'5/16/2011',NULL,'Wright','F-Female','3/1/1993',18,NULL,0,0,0,0,0,1,0,NULL,'GA',33.58200073,-83.49099731,'Student',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,1,0,0,1,1,1,'7-10 per day',1,'5/13/2011',1,'5/13/2011',1,0,NULL,100.9000015,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('61cab31b-6482-48cb-bd8d-31cd2199b865',79,'5/12/2011',NULL,'Lopez','M-Male','9/11/1986',24,NULL,0,0,0,0,0,0,1,NULL,'GA',33.5909996,-83.51799774,'Fisher',NULL,NULL,0,'5/5/2011',NULL,1,1,1,1,1,0,0,0,0,0,'1-3 per day',0,NULL,0,NULL,0,0,NULL,102.0999985,18,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('62af8e59-f005-4549-9ed9-5c80c1d53423',306,'5/14/2011',NULL,'Hill','M-Male','1/1/1986',25,NULL,0,1,0,0,0,0,0,NULL,'GA',33.61999893,-83.07800293,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,1,1,'1-3 per day',0,NULL,1,'4/14/2011',NULL,0,NULL,103.0999985,15,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6364488a-c973-46f5-a227-81a42ed65591',272,'5/12/2011',NULL,'Scott','M-Male','1/1/1984',27,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59999847,-83.53299713,'Service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,0,1,1,0,1,1,0,0,'7-10 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,13,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('63e286e6-1ff2-4ea4-b2f6-794b88293887',162,'5/1/2011',NULL,'Green','M-Male','11/10/1975',35,NULL,1,0,0,0,0,0,0,NULL,'GA',33.52000046,-83.59300232,'Transportation',NULL,NULL,1,'4/24/2011',NULL,0,1,1,0,1,1,1,0,1,1,'1-3 per day',1,'4/17/2011',1,'4/17/2011',1,0,NULL,NULL,15,1,0,0,0,1,0,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('644f23b4-c0d6-4967-b934-83ed40c2c519',357,'5/17/2011',NULL,'Adams','F-Female','7/18/1949',61,NULL,0,1,0,0,0,0,0,NULL,'GA',33.62799835,-83.61399841,'Teacher',NULL,NULL,1,'5/10/2011',NULL,1,1,0,0,1,0,0,1,1,0,'1-3 per day',0,NULL,0,NULL,0,0,NULL,100,13,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('647be944-ddca-4d10-837a-b27e25119dd0',46,'5/18/2011',NULL,'Baker','M-Male','12/20/1982',28,NULL,0,0,1,0,0,0,0,NULL,'GA',33.57500076,-83.18099976,'Transportation',NULL,NULL,0,'5/11/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('649a8921-ac60-471c-abd7-372a038fb1e4',259,'5/12/2011',NULL,'Gonzalez','F-Female','8/18/1991',19,NULL,0,0,0,0,1,0,0,NULL,'GA',33.74200058,-83.66300201,'Janitor',NULL,NULL,1,'5/5/2011',NULL,1,1,0,1,0,0,0,1,1,1,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,14,1,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('64f6d7a1-e643-4c36-901d-feba9f66a787',179,'5/15/2011',NULL,'Nelson','M-Male','1/7/1983',28,NULL,0,0,0,1,0,0,0,NULL,'GA',33.54800034,-83.36199951,'Journalist',NULL,NULL,1,'5/8/2011',NULL,0,1,1,1,1,0,0,0,1,1,'10+ per day',1,'4/28/2011',1,'4/28/2011',1,0,NULL,100.9000015,17,0,0,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6562657f-16f3-4ab2-be6e-77ae6d9c5b77',237,'5/10/2011',NULL,'Carter','M-Male','8/13/1986',24,NULL,0,1,0,0,0,0,0,NULL,'GA',33.58499908,-83.16400146,'Unemployed',NULL,NULL,1,'5/3/2011',NULL,1,1,0,1,1,1,1,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,15,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('65cef2d0-3642-4b3f-b568-62d3251da7fa',319,'5/14/2011',NULL,'Mitchell','F-Female','10/1/1985',25,NULL,0,0,1,0,0,0,0,NULL,'GA',33.58800125,-83.46700287,'Soldier',NULL,NULL,1,'5/7/2011',NULL,1,1,0,1,1,0,1,1,0,1,'1-3 per day',0,NULL,1,'4/21/2011',1,0,NULL,105.6999969,16,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6622348d-7876-4e66-a116-4fd0642f3dff',43,'5/15/2011',NULL,'Perez','M-Male','3/2/1999',12,NULL,0,0,0,0,0,0,1,NULL,'GA',33.60300064,-83.47399902,'Student',NULL,NULL,0,'5/8/2011',NULL,1,1,1,1,1,1,1,1,0,1,'10+ per day',1,'5/4/2011',1,'5/5/2011',1,0,NULL,103.8000031,18,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6748c095-c67a-4bd7-b6c8-62a646fd04ec',108,'5/16/2011',NULL,'Roberts','F-Female','8/22/1995',15,NULL,1,0,0,0,0,0,0,NULL,'GA',33.56299973,-83.62000275,'Student',NULL,NULL,1,'5/9/2011',NULL,1,0,0,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,0,0,NULL,NULL,19,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,1,0,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('68494db5-0572-471e-9fcd-0346caf7e738',2,'5/7/2011',NULL,'Turner','M-Male','12/4/1936',74,NULL,0,1,0,0,0,0,0,NULL,'GA',33.59400177,-83.46600342,NULL,NULL,NULL,1,'4/30/2011',NULL,1,1,0,1,0,0,1,1,1,1,'1-3 per day',1,'4/4/2011',1,'4/5/2011',1,0,NULL,101.1999969,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('68ae1d15-0701-42e2-9b26-8e1173f50e5b',286,'5/13/2011',NULL,'Phillips','F-Female','1/1/1982',29,NULL,0,0,0,0,0,0,1,NULL,'GA',33.47700119,-83.3219986,'Manufacturing',NULL,NULL,1,'5/6/2011',NULL,1,1,0,1,1,1,1,0,1,1,'4-6 per day',1,'4/25/2011',1,NULL,1,0,NULL,102.9000015,16,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6982a307-b62f-4430-bf72-ef8c4e99118b',310,'5/14/2011',NULL,'Campbell','F-Female','1/1/1987',24,NULL,0,0,1,0,0,0,0,NULL,'GA',33.79399872,-83.71299744,NULL,NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,0,1,0,1,'7-10 per day',1,'4/11/2011',1,'4/13/2011',1,0,NULL,103.0999985,14,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('69c1dfd7-19e0-4a85-993f-75ba86b75cab',350,'5/23/2011',NULL,'Parker','F-Female','1/1/1942',69,NULL,0,0,0,0,0,0,0,NULL,'GA',33.58399963,-83.45700073,NULL,NULL,NULL,1,'5/16/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',1,NULL,1,NULL,1,0,NULL,NULL,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6a341df7-4834-4122-849d-96640bace37b',161,'4/28/2011',NULL,'Evans','F-Female','12/29/1976',34,NULL,0,0,0,0,0,0,1,NULL,'GA',33.5909996,-83.45300293,'Transportation',NULL,NULL,0,'4/21/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,1,0,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6ac6be5e-b614-492d-87f7-bd702043b804',316,'5/14/2011',NULL,'Edwards','M-Male','5/20/1967',43,NULL,0,0,1,0,0,0,0,NULL,'GA',33.58499908,-83.47100067,NULL,NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,0,0,'4-6 per day',0,NULL,1,'4/16/2011',NULL,0,NULL,105.1999969,15,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6afdb2fd-2357-4b45-8d4f-fb15d9ccd632',15,'5/13/2011',NULL,'Collins','F-Female','1/1/1976',35,NULL,0,0,0,0,1,0,0,NULL,'GA',33.70899963,-83.66100311,'Business executive',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,0,0,1,1,1,1,'7-10 per day',0,NULL,1,'4/8/2011',1,0,NULL,100.9000015,14,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6b47179f-fa5f-4476-9e08-3f03b2ca37a9',353,'5/16/2011',NULL,'Stewart','M-Male','1/1/1999',12,NULL,1,0,0,0,0,0,0,NULL,'GA',33.39199829,-83.59500122,NULL,NULL,NULL,1,'5/9/2011',NULL,1,1,1,0,0,1,0,1,1,1,'1-3 per day',1,NULL,0,NULL,0,0,NULL,NULL,15,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6bb58e27-e316-47c9-a959-ace969a9e528',76,'5/11/2011',NULL,'Sanchez','M-Male','6/6/1958',52,NULL,0,0,0,0,0,0,1,NULL,'GA',33.58200073,-83.45800018,'Farmer',NULL,NULL,0,'5/4/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,1,'5/3/2011',1,'5/4/2011',1,0,NULL,102.6999969,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6e4a7759-f6da-4a6a-b339-830428312c18',227,'4/30/2011',NULL,'Morris','F-Female','1/20/1944',67,NULL,1,0,0,0,0,0,0,NULL,'GA',33.59700012,-83.61599731,NULL,NULL,NULL,1,'4/23/2011',NULL,1,1,1,1,1,1,0,1,1,0,'4-6 per day',1,'4/4/2011',1,'4/6/2011',0,0,NULL,100.1999969,13,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6e857e2b-bbc9-4d2a-a4a1-48808eec352a',305,'5/14/2011',NULL,'Rogers','F-Female','12/31/1977',33,NULL,0,1,0,0,0,0,0,NULL,'GA',33.59400177,-83.46900177,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,1,1,'7-10 per day',1,'4/9/2011',1,'4/9/2011',0,0,NULL,104.1999969,13,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6e9be3c1-7300-47b0-99ee-37d1664f3661',104,'5/15/2011',NULL,'Reed','M-Male','3/15/1976',35,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59799957,-83.53900146,'Government',NULL,NULL,1,'5/8/2011',NULL,1,1,1,1,1,0,0,0,1,1,'4-6 per day',1,'5/13/2011',1,'5/15/2011',1,0,NULL,NULL,19,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6f20b4c2-7a5b-40c3-afee-42e0b9ec2ea4',276,'5/13/2011',NULL,'Cook','F-Female','8/9/1979',31,NULL,0,0,0,0,0,0,1,NULL,'GA',33.58599854,-83.49500275,'Writer',NULL,NULL,1,'5/6/2011',NULL,1,1,1,0,1,1,1,1,1,1,'4-6 per day',1,'4/25/2011',0,NULL,NULL,0,NULL,103.8000031,17,0,1,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('6f8d6790-95c0-4a54-9c98-f0f3cc24168a',69,'5/17/2011',NULL,'Morgan','F-Female','1/1/1982',29,NULL,0,0,0,0,0,0,1,NULL,'GA',33.56999969,-83.1989975,'Business executive',NULL,NULL,0,'5/10/2011',NULL,0,1,1,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,0,0,NULL,100.4000015,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('71c5f473-c980-4a5a-914f-23d8c22bc14e',335,'5/15/2011',NULL,'Bell','M-Male','1/1/1976',35,NULL,0,0,0,0,0,1,0,NULL,'GA',33.5890007,-83.46299744,NULL,NULL,NULL,1,'5/8/2011',NULL,1,1,0,1,1,1,1,0,1,1,'7-10 per day',1,NULL,1,'4/30/2011',1,0,NULL,104.5999985,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('754d47c2-7e6a-478c-a6f0-ccf9d3af3598',289,'5/13/2011',NULL,'Murphy','M-Male','1/1/1983',28,NULL,1,0,0,0,0,0,0,NULL,'GA',33.79899979,-83.71600342,'Clerk',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,1,1,1,1,1,'7-10 per day',1,NULL,1,NULL,1,0,NULL,NULL,15,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('75955e23-b8dc-4817-873b-ed8b94703e0c',178,'5/16/2011',NULL,'Bailey','M-Male','7/24/1974',36,NULL,0,0,1,0,0,0,0,NULL,'GA',33.58599854,-83.47100067,'Sales',NULL,NULL,1,'5/9/2011',NULL,0,1,1,0,1,0,0,1,0,0,'4-6 per day',0,NULL,0,NULL,0,0,NULL,102,17,0,0,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('766ec6e6-bc65-4cee-b83d-a798e1b5dadc',175,'5/13/2011',NULL,'Rivera','M-Male','2/19/1992',19,NULL,0,0,0,0,0,0,1,NULL,'GA',33.45000076,-83.37000275,NULL,NULL,'Student',1,'5/6/2011',NULL,0,1,1,0,1,1,1,1,1,0,'1-3 per day',1,'4/3/2011',0,NULL,0,0,NULL,102.5,13,1,0,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('76705f8e-20ad-42a3-b279-c49e52932c7c',354,'5/16/2011',NULL,'Cooper','M-Male','12/17/1974',36,NULL,1,0,0,0,0,0,0,NULL,'GA',33.61700058,-83.4489975,NULL,NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,1,0,1,1,1,1,'4-6 per day',0,NULL,1,'4/25/2011',1,0,NULL,103.5,17,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('76ac7e4f-0acc-4003-a0d3-d503f01e3aef',24,'5/7/2011',NULL,'Richardson','F-Female','8/19/1953',57,NULL,1,0,0,0,0,0,0,NULL,'GA',33.65299988,-83.7480011,'Artist',NULL,NULL,0,'4/30/2011',NULL,1,1,0,0,0,0,1,1,0,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,16,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('77482579-201c-43a9-bad5-b52260801b5d',167,'5/17/2011',NULL,'Cox','M-Male','8/24/1988',22,NULL,0,0,0,0,0,1,0,NULL,'GA',33.60900116,-83.51100159,'Soldier',NULL,NULL,1,'5/10/2011',NULL,1,1,1,1,1,0,1,1,1,1,'7-10 per day',1,'5/6/2011',1,'5/7/2011',1,1,'5/9/2011',104.1999969,18,0,0,0,0,1,0,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('78d27885-2736-40f2-8a15-15fe08168026',320,'5/14/2011',NULL,'Howard','M-Male','5/1/1970',41,NULL,0,0,1,0,0,0,0,NULL,'GA',33.57699966,-83.18099976,'Food service worker',NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,1,1,'7-10 per day',1,'4/29/2011',1,'4/30/2011',NULL,0,NULL,104.3000031,17,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('79e13a57-bf80-49d3-a1aa-b8aa3561a271',229,'5/8/2011',NULL,'Ward','F-Female','9/17/1984',26,NULL,1,0,0,0,0,0,0,NULL,'GA',33.78499985,-83.60800171,'Scientist',NULL,NULL,1,'5/1/2011',NULL,1,1,1,1,1,1,0,1,1,0,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,100.4000015,15,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('7a7888f7-a3bc-4195-b17f-26b0dd7c3d35',255,'5/11/2011',NULL,'Torres','F-Female','4/24/1953',58,NULL,0,0,0,1,0,0,0,NULL,'GA',33.58300018,-83.46800232,'Service worker',NULL,NULL,1,'5/4/2011',NULL,1,1,1,0,0,1,1,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,15,0,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('7aa896a1-7738-4099-aab4-7a98dcae7497',248,'5/11/2011',NULL,'Peterson','M-Male','1/1/1981',30,NULL,0,0,1,0,0,0,0,NULL,'GA',33.56000137,-83.52799988,'Manufacturing',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,1,0,1,1,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.5999985,15,0,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('7c2e06cd-b4e9-4a17-a7d3-07fcdaef170f',359,'5/17/2011',NULL,'Gray','M-Male','10/13/1964',46,NULL,0,0,1,0,0,0,0,NULL,'GA',33.4620018,-83.30899811,'Police officer',NULL,NULL,1,'5/10/2011',NULL,1,1,1,1,1,0,1,0,0,1,'10+ per day',1,'4/15/2011',1,'4/16/2011',1,0,NULL,103.6999969,15,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('7c59e48b-8a47-4148-a015-5e60d50dff2a',135,'5/27/2011',NULL,'Ramirez','F-Female','4/12/1992',19,NULL,0,1,0,0,0,0,0,NULL,'GA',33.5929985,-83.47000122,'Student',NULL,NULL,1,'5/20/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',1,'5/16/2011',1,'5/16/2011',1,0,NULL,NULL,20,0,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,0,1,0,1,1,1,1,NULL,1,0,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('7d11492c-2cc7-4883-b419-1360c1753d17',118,'5/16/2011',NULL,'James','F-Female','1/1/1955',56,NULL,1,0,0,0,0,0,0,NULL,'GA',33.5909996,-83.46499634,'Consultant',NULL,NULL,1,'5/9/2011',NULL,1,1,1,0,1,0,0,0,0,1,'1-3 per day',0,NULL,0,NULL,0,0,NULL,100.9000015,19,0,1,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('7d75c8ba-4f5f-4c98-a7f3-9d3fd52144d1',54,'5/18/2011',NULL,'Watson','F-Female','8/5/1961',49,NULL,0,0,0,1,0,0,0,NULL,'GA',33.54800034,-83.49299622,'Lawyer',NULL,NULL,0,'5/11/2011',NULL,1,1,1,0,1,0,0,0,0,0,'4-6 per day',1,'5/16/2011',0,'5/17/2011',0,0,NULL,NULL,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('7ebfeda4-bfef-4f57-9a45-a4648e9bbed3',3,'5/11/2011',NULL,'Brooks','F-Female','1/29/1957',54,NULL,0,0,1,0,0,0,0,NULL,'GA',33.5870018,-83.49299622,'Teacher',NULL,NULL,1,'5/4/2011',NULL,1,1,1,0,1,0,1,1,1,1,'1-3 per day',1,'4/5/2011',0,NULL,1,0,NULL,100.9000015,14,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('7f3e68f3-a204-4eea-bc73-907f4aa6e5a5',140,'5/12/2011',NULL,'Kelley','F-Female','9/9/1973',37,NULL,0,0,0,0,0,0,1,NULL,'GA',33.57899857,-83.48000336,'Actor',NULL,NULL,1,'5/5/2011',NULL,1,1,0,1,0,0,0,0,1,0,'1-3 per day',0,NULL,0,NULL,0,0,NULL,NULL,20,1,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('7fe4f508-a356-4010-a1e7-3109e49ba307',146,'5/11/2011',NULL,'Sanders','M-Male','5/20/1970',40,NULL,0,0,0,0,0,0,1,NULL,'GA',33.57699966,-83.18199921,'Janitor',NULL,NULL,1,'5/4/2011',NULL,1,1,0,1,1,0,1,1,1,0,'4-6 per day',1,'5/17/2011',1,'5/18/2011',0,0,NULL,NULL,20,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('80bcf796-ee8f-45a9-ade5-5495fd8e5f7d',192,'5/20/2011',NULL,'Price','F-Female','11/22/1996',14,NULL,0,0,1,0,0,0,0,NULL,'GA',33.5929985,-83.46600342,'Student',NULL,NULL,1,'5/13/2011',NULL,1,1,1,1,1,1,0,0,1,0,'1-3 per day',0,NULL,1,NULL,0,0,NULL,101.5999985,15,0,0,1,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('80ff0e58-fe8b-435a-84d9-8d79599a360e',215,'4/28/2011',NULL,'Bennet','F-Female','2/20/1984',27,NULL,0,0,0,0,1,0,0,NULL,'GA',33.60400009,-83.46700287,'Manufacturing',NULL,NULL,1,'4/21/2011',NULL,0,1,1,1,1,0,1,1,1,1,'10+ per day',1,'4/22/2011',1,'4/24/2011',1,1,'4/27/2011',105.0999985,16,0,0,0,0,1,1,0,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('810f5315-2a9f-4f57-9af2-d5af767a3181',110,'5/6/2011',NULL,'Wood','F-Female','7/17/1961',49,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59199905,-83.51699829,'Researcher',NULL,NULL,1,'4/29/2011',NULL,0,1,1,1,1,0,1,0,1,1,'10+ per day',0,NULL,1,'4/27/2011',0,0,NULL,NULL,17,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,1,0,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8119f4b2-0c6a-4a35-8fa4-e08337992a00',63,'5/21/2011',NULL,'Barnes','F-Female','1/1/1968',43,NULL,0,0,0,0,1,0,0,NULL,'GA',33.61600113,-83.0739975,'Government',NULL,NULL,0,'5/14/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('81870a99-e01a-4489-ba4d-f9ce201a3964',28,'5/16/2011',NULL,'Ross','M-Male','10/2/1992',18,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59799957,-83.46800232,'Government',NULL,NULL,0,'5/9/2011',NULL,1,1,0,1,1,0,1,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,18,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('81b296f0-9c06-4dca-a690-ababbdea1234',10,'5/9/2011',NULL,'Henderson','F-Female','4/26/1944',67,NULL,1,0,0,0,0,0,0,NULL,'GA',33.58599854,-83.4940033,NULL,NULL,NULL,1,'5/2/2011',NULL,1,1,0,1,1,0,0,1,1,1,'1-3 per day',0,NULL,0,NULL,0,0,NULL,NULL,13,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('81b98144-4e4c-4d98-85f7-58324d5cf746',238,'5/10/2011',NULL,'Coleman','F-Female','8/9/1944',66,NULL,0,1,0,0,0,0,0,NULL,'GA',33.5909996,-83.50700378,'Doctor',NULL,NULL,1,'5/3/2011',NULL,1,1,0,1,0,0,0,1,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,100.3000031,15,0,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('81cc9256-b2a8-4e7f-8638-3262513369b1',169,'5/15/2011',NULL,'Smith','M-Male','8/2/1955',55,NULL,1,0,0,0,0,0,0,NULL,'GA',33.47499847,-83.31999969,'Doctor',NULL,NULL,1,'5/8/2011',NULL,0,1,1,1,1,0,0,0,1,0,'1-3 per day',1,'4/7/2011',NULL,NULL,1,0,NULL,NULL,14,0,1,0,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('82593eb3-e135-4cc6-8c44-3fb7d86eba7f',5,'5/10/2011',NULL,'Smith','M-Male','3/31/1975',36,NULL,0,0,0,0,1,0,0,NULL,'GA',33.59500122,-83.46199799,'Pilot',NULL,NULL,1,'5/3/2011',NULL,1,1,0,1,1,0,0,1,1,0,'1-3 per day',1,'4/7/2011',0,NULL,0,0,NULL,100,14,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8287f093-f524-4430-bf18-9c0a4a40defb',268,'5/12/2011',NULL,'Smith','M-Male','6/6/1980',30,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59999847,-83.45999908,'Service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,0,0,1,0,1,1,0,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,17,0,1,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('829edf1b-6560-48d9-bf97-1f2b7d13afb4',266,'5/12/2011',NULL,'Smith','M-Male','3/21/1966',45,NULL,0,0,0,0,1,0,0,NULL,'GA',33.59199905,-83.44000244,'Service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,1,0,0,1,1,0,0,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,17,0,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('82ee1275-7084-4c8b-89b1-0e7cf32d61f4',180,'5/7/2011',NULL,'Smith','F-Female','11/26/1981',29,NULL,0,0,0,0,1,0,0,NULL,'GA',33.59000015,-83.4509964,'Writer',NULL,NULL,1,'4/30/2011',NULL,1,1,0,1,1,0,1,1,1,1,'4-6 per day',1,'4/9/2011',1,'4/9/2011',0,0,NULL,103.5999985,14,0,0,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('83562acf-62dd-47ed-872e-97aa17d36cea',68,'5/16/2011',NULL,'Smith','M-Male','1/1/1984',27,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59700012,-83.62999725,'Manufacturing',NULL,NULL,0,'5/9/2011',NULL,1,1,1,1,1,0,0,0,0,0,'4-6 per day',1,'6/4/2011',1,'6/5/2011',1,0,NULL,100.3000031,22,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('84fdf67e-a84d-460e-ba9f-c3e55c2b95f4',288,'5/13/2011',NULL,'Johnson','M-Male','1/1/1979',32,NULL,1,0,0,0,0,0,0,NULL,'GA',33.5870018,-83.5059967,'Clerk',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,1,1,0,1,1,'7-10 per day',1,NULL,0,NULL,0,0,NULL,NULL,15,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8513eb50-909b-4972-93c4-bdc229bb5d90',281,'5/13/2011',NULL,'Johnson','F-Female','4/1/1971',40,NULL,0,0,0,0,0,0,1,NULL,'GA',33.59000015,-83.45899963,'Manufacturing',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',1,'4/16/2011',1,'4/16/2011',1,0,NULL,NULL,15,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8579f712-7fe1-4cdd-854c-7b61a73a5eac',304,'5/14/2011',NULL,'Johnson','F-Female','1/1/1979',32,NULL,0,1,0,0,0,0,0,NULL,'GA',33.58499908,-83.46900177,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,1,1,'4-6 per day',1,'4/22/2011',NULL,NULL,NULL,0,NULL,100.1999969,16,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('85f1fb72-1faa-4141-9877-a1aa0d682754',48,'5/16/2011',NULL,'Johnson','M-Male','12/2/1951',59,NULL,0,0,0,1,0,0,0,NULL,'GA',33.56100082,-83.48999786,'Service worker',NULL,NULL,0,'5/9/2011',NULL,1,1,1,0,1,0,0,0,0,0,'4-6 per day',1,'5/4/2011',1,'5/5/2011',1,0,NULL,102.6999969,18,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('86a59296-d15d-4320-b239-7624877e9371',294,'5/13/2011',NULL,'Williams','M-Male','4/13/1983',28,NULL,1,0,0,0,0,0,0,NULL,'GA',33.73300171,-83.5719986,NULL,NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,0,1,1,1,0,'4-6 per day',1,'4/30/2011',0,NULL,0,0,NULL,NULL,17,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('86a9be64-9a66-4a25-8687-e96ac96e5f58',325,'5/14/2011',NULL,'Williams','M-Male','8/17/1982',28,NULL,0,0,0,1,0,0,0,NULL,'GA',33.60200119,-83.46800232,'Consultant',NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,1,1,'7-10 per day',1,'4/7/2011',0,NULL,1,0,NULL,103.9000015,14,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('87397806-02bd-447a-88eb-1587fbc9ad72',91,'4/27/2011',NULL,'Williams','M-Male','1/14/1993',18,NULL,0,0,0,0,0,0,1,NULL,'GA',33.75799942,-83.54299927,'Student',NULL,NULL,1,'4/20/2011',NULL,1,0,1,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,0,0,NULL,NULL,15,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('877dee5c-d411-48a5-bd58-532013c6215e',121,'5/17/2011',NULL,'Jones','F-Female','5/5/1963',48,NULL,0,1,0,0,0,0,0,NULL,'GA',33.60200119,-83.45999908,'Scientist',NULL,NULL,1,'5/10/2011',NULL,1,1,0,0,0,0,0,1,1,1,NULL,0,NULL,1,'5/21/2011',0,0,NULL,102.4000015,20,1,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,NULL,1,0,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('87a25c70-20e8-4d49-8069-a1f8a05bea0b',26,'5/16/2011',NULL,'Brown','F-Female','12/28/1959',51,NULL,1,0,0,0,0,0,0,NULL,'GA',33.79399872,-83.70899963,'Teacher',NULL,NULL,0,'5/9/2011',NULL,1,1,1,1,1,0,1,0,0,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,18,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('87dbb531-a61f-4c1c-a7ce-23ac82f49bf9',149,'5/13/2011',NULL,'Davis','F-Female','5/8/1991',20,NULL,0,1,0,0,0,0,0,NULL,'GA',33.39699936,-83.59100342,'Student',NULL,NULL,0,'5/6/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,1,0,1,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8881008f-ad40-4854-b6ec-5642553c6b92',331,'5/14/2011',NULL,'Davis','M-Male','4/17/1997',14,NULL,0,0,0,0,1,0,0,NULL,'GA',33.60300064,-83.47299957,'Musician',NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,1,1,0,1,1,'1-3 per day',0,NULL,1,'4/3/2011',NULL,0,NULL,104,13,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('894f7c06-658a-41f0-9542-9766ae796d3e',100,'5/17/2011',NULL,'Davis','M-Male','10/10/1940',70,NULL,0,0,0,0,0,1,0,NULL,'GA',33.57600021,-83.18199921,'Business executive',NULL,NULL,1,'5/10/2011',NULL,1,1,1,0,1,0,1,0,0,0,'1-3 per day',1,'5/17/2011',1,'5/18/2011',1,0,NULL,101.5999985,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('898a32ba-473a-4c8f-96b0-3a8102b54b9d',222,'5/3/2011',NULL,'Miller','F-Female','5/9/2003',7,NULL,0,0,0,0,1,0,0,NULL,'GA',33.78300095,-83.70600128,'Student',NULL,NULL,1,'4/26/2011',NULL,0,1,1,0,1,0,0,1,0,1,'4-6 per day',1,'4/16/2011',0,NULL,0,0,NULL,103.8000031,15,1,1,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8a0e4742-6eec-4e3b-bdf3-02bc2c11d349',123,'5/19/2011',NULL,'Miller','F-Female','8/20/1969',41,NULL,0,0,0,1,0,0,0,NULL,'GA',33.58399963,-83.45700073,'Construction worker',NULL,NULL,1,'5/12/2011',NULL,1,1,0,1,1,0,0,0,1,1,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.1999969,20,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8a4f5544-d39f-4ea7-813d-5068923105a5',231,'5/9/2011',NULL,'Wilson','M-Male','12/13/1984',26,NULL,1,0,0,0,0,0,0,NULL,'GA',33.82300186,-83.73000336,'Food service worker',NULL,NULL,1,'5/2/2011',NULL,1,1,0,1,0,1,1,1,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.5999985,17,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8ba6c08e-9bef-499a-874b-c9ce3a22a1a7',38,'5/16/2011',NULL,'Moore','M-Male','4/18/1979',32,NULL,0,1,0,0,0,0,0,NULL,'GA',33.59000015,-83.47000122,'Government',NULL,NULL,0,'5/9/2011',NULL,1,0,0,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,0,0,NULL,NULL,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8c1a6f51-7b4c-48b9-9fd8-f46f167ae3c6',273,'5/12/2011',NULL,'Anderson','F-Female','2/17/1961',50,NULL,0,0,0,0,0,1,0,NULL,'GA',33.60200119,-83.47299957,'Service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,1,1,1,1,0,1,1,1,'7-10 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,103.6999969,14,1,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8c6e8d38-782e-478f-b048-19c60595e5c0',128,'5/21/2011',NULL,'Anderson','F-Female','5/12/1989',22,NULL,0,1,0,0,0,0,0,NULL,'GA',33.5870018,-83.47399902,'Clerk',NULL,NULL,1,'5/14/2011',NULL,1,1,1,1,1,0,0,0,0,1,'1-3 per day',1,'5/12/2011',0,NULL,NULL,0,NULL,102.8000031,19,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8d292a95-a34f-40c9-a079-e3312adae15f',153,'5/8/2011',NULL,'Anderson','M-Male','12/25/1978',32,NULL,0,0,0,0,0,1,0,NULL,'GA',33.60499954,-83.46800232,'Researcher',NULL,NULL,1,'5/1/2011',NULL,1,1,1,1,0,0,0,0,1,0,'1-3 per day',NULL,NULL,0,NULL,0,0,NULL,NULL,20,0,0,0,0,1,0,1,1,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8e120c52-0b70-41b4-a4a5-c6029a53755d',107,'5/16/2011',NULL,'Martin','M-Male','8/9/1993',17,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59000015,-83.47299957,'Student',NULL,NULL,1,'5/9/2011',NULL,1,0,1,1,1,0,0,0,1,1,'7-10 per day',0,NULL,1,'5/23/2011',1,0,NULL,NULL,20,0,1,0,0,0,0,0,0,1,0,0,0,1,0,0,0,0,1,1,1,0,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('8fff0d4c-2ab4-45cc-bc3a-a413e26a67b7',78,'5/9/2011',NULL,'Martin','M-Male','2/6/1949',62,NULL,0,0,0,0,0,0,1,NULL,'GA',33.40000153,-83.58899689,NULL,NULL,NULL,0,'5/2/2011',NULL,1,1,1,0,1,0,0,0,0,0,'1-3 per day',1,'5/4/2011',0,NULL,0,0,NULL,100.9000015,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('9172c633-9ccf-4a19-ba13-745e0ead03e5',295,'5/13/2011',NULL,'Martin','F-Female','6/27/1943',67,NULL,1,0,0,0,0,0,0,NULL,'GA',33.40100098,-83.58699799,NULL,NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,0,0,1,0,1,1,'4-6 per day',1,'4/26/2011',0,NULL,1,0,NULL,NULL,16,1,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('91f2ed46-d4bf-4cc6-9846-1a222efa59b8',244,'5/10/2011',NULL,'Garcia','M-Male','1/1/1984',27,NULL,0,0,1,0,0,0,0,NULL,'GA',33.77299881,-83.43000031,'Manufacturing',NULL,NULL,1,'5/3/2011',NULL,1,1,1,0,1,0,1,0,1,1,'10+ per day',1,'4/19/2011',1,'4/21/2011',1,1,'4/26/2011',103.8000031,15,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('91feddc4-209c-4246-b3c5-20216ab4e1ac',348,'5/22/2011',NULL,'Garcia','M-Male','9/26/1964',46,NULL,0,0,0,0,0,0,1,NULL,'GA',33.58800125,-83.45200348,NULL,NULL,NULL,1,'5/15/2011',NULL,1,1,1,0,1,1,1,1,0,1,'4-6 per day',1,NULL,0,NULL,1,0,NULL,NULL,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('92ec3e47-d20b-4f87-9355-1e5825e61254',155,'5/13/2011',NULL,'Garcia','F-Female','4/9/1994',17,NULL,1,0,0,0,0,0,0,NULL,'GA',33.5890007,-83.47200012,'Student',NULL,NULL,0,'5/6/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,1,0,0,1,0,1,1,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('93b42fb8-20c7-42cd-a4c4-440971376fb8',309,'5/14/2011',NULL,'Garcia','M-Male','1/1/1984',27,NULL,0,0,1,0,0,0,0,NULL,'GA',33.60200119,-83.47499847,NULL,NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,0,1,'4-6 per day',1,'4/29/2011',1,'4/30/2011',0,0,NULL,103.8000031,17,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('93d32d2e-cc7a-4700-a4cf-047283627669',90,'5/2/2011',NULL,'Clark','M-Male','5/8/1960',50,NULL,0,0,0,0,0,0,1,NULL,'GA',33.57400131,-83.48100281,'Railway operator',NULL,NULL,1,'4/25/2011',NULL,1,0,1,0,1,0,0,0,0,0,'1-3 per day',1,'4/20/2011',0,NULL,1,0,NULL,104.4000015,16,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('95ad937d-3c7c-4459-87f9-adeec925adb9',299,'5/13/2011',NULL,'Rodriguez','M-Male','2/6/1969',42,NULL,0,1,0,0,0,0,0,NULL,'GA',33.59999847,-83.45800018,NULL,NULL,NULL,1,'5/6/2011',NULL,0,1,1,1,0,0,1,0,1,1,'1-3 per day',0,NULL,1,'4/12/2011',1,0,NULL,NULL,14,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('960874bd-4c58-4191-aae1-e3648057a17a',311,'5/14/2011',NULL,'Lewis','F-Female','1/5/1968',43,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59999847,-83.46099854,'Teacher',NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,1,1,0,0,'7-10 per day',1,'4/5/2011',0,'4/6/2011',1,0,NULL,103.6999969,14,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('963f99d6-a74c-459e-a1ad-899392547f9e',36,'5/12/2011',NULL,'Lee','M-Male','8/29/1998',12,NULL,0,1,0,0,0,0,1,NULL,'GA',33.32300186,-83.08499908,'Student',NULL,NULL,0,'5/5/2011',NULL,1,1,0,0,0,0,0,1,0,0,NULL,1,'4/5/2011',NULL,NULL,NULL,0,NULL,NULL,14,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('983f5f74-7f7e-4309-803c-ca69d56e0c3b',166,'5/16/2011',NULL,'Walker','F-Female','2/15/1975',36,NULL,0,0,0,0,1,0,0,NULL,'GA',33.59899902,-83.45999908,'Manufacturing',NULL,NULL,1,'5/9/2011',NULL,0,1,1,1,1,0,0,0,1,1,'1-3 per day',0,NULL,1,'5/2/2011',0,0,NULL,99.69999695,18,0,0,0,0,1,0,1,1,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('9857377a-33df-4193-9986-49e231a6ce43',147,'5/9/2011',NULL,'King','F-Female','6/8/1991',19,NULL,0,0,0,0,0,1,0,NULL,'GA',33.6269989,-83.61599731,'Student',NULL,NULL,1,'5/2/2011',NULL,1,1,0,1,1,0,0,1,1,1,'4-6 per day',1,'5/18/2011',0,NULL,0,0,NULL,NULL,20,0,1,0,0,1,0,1,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('9866d835-e8eb-4b87-b6d4-bedc7a65828d',133,'5/21/2011',NULL,'King','M-Male','11/13/1972',38,NULL,0,0,0,0,0,0,1,NULL,'GA',33.59000015,-83.47799683,'Accountant',NULL,NULL,1,'5/14/2011',NULL,0,1,1,1,1,0,0,0,1,1,'1-3 per day',1,'5/15/2011',1,'5/15/2011',0,0,NULL,103.5,20,0,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,0,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('9956da98-e404-48ed-8391-c5572e6678f3',138,'5/16/2011',NULL,'King','M-Male','7/8/1965',45,NULL,0,0,0,0,1,0,0,NULL,'GA',33.43600082,-83.39199829,'Archaeologist',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,1,0,1,1,1,1,'7-10 per day',1,'5/15/2011',1,'5/15/2011',1,0,NULL,NULL,20,0,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('997acb14-25b4-4938-ae54-4f36ae576b5f',296,'5/13/2011',NULL,'King','F-Female','3/15/1952',59,NULL,1,0,0,0,0,0,0,NULL,'GA',33.41799927,-83.35299683,NULL,NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,0,1,1,1,0,'7-10 per day',1,'4/19/2011',NULL,NULL,NULL,0,NULL,NULL,15,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('999c1a78-16ca-4a2a-836d-4e736dce33f0',183,'5/15/2011',NULL,'Wright','M-Male','5/18/1974',36,NULL,1,0,0,0,0,0,0,NULL,'GA',33.79399872,-83.70899963,'Teacher',NULL,NULL,1,'5/8/2011',NULL,1,1,0,1,1,0,0,0,1,1,'1-3 per day',1,NULL,0,NULL,0,0,NULL,101.9000015,16,0,0,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('9a01dd60-f02a-438f-9c32-22c3e38bc48d',103,'5/16/2011',NULL,'Wright','F-Female','9/17/1998',12,NULL,0,0,0,0,0,1,0,NULL,'GA',33.79399872,-83.71299744,'Student',NULL,NULL,0,'5/9/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('9a9b87c9-3964-435e-a0b0-95a4e735f452',18,'5/5/2011',NULL,'Wright','M-Male','1/1/1964',47,NULL,1,0,0,0,0,0,0,NULL,'GA',33.60599899,-83.49700165,'Writer',NULL,NULL,0,'4/28/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('9d5ee554-5bd7-4d7f-bd20-e021860c8c4d',202,'5/16/2011',NULL,'Hill','M-Male','2/29/1960',51,NULL,0,0,0,0,0,1,0,NULL,'GA',33.5929985,-83.46600342,'Sales',NULL,NULL,1,'5/9/2011',NULL,1,1,0,1,1,1,1,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,101.1999969,15,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('9e7348be-8f43-4b1b-b5fa-d42294595644',197,'5/24/2011',NULL,'Scott','F-Female','8/8/1971',39,NULL,1,0,0,0,0,0,0,NULL,'GA',33.59400177,-83.45300293,'Pilot',NULL,NULL,1,'5/17/2011',NULL,1,1,1,1,1,1,1,0,1,0,'4-6 per day',1,'4/18/2011',0,NULL,0,0,NULL,100.6999969,15,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('9f8c9550-1e79-444c-9a02-ed25c28bcdea',256,'5/11/2011',NULL,'Nelson','F-Female','1/1/1952',59,NULL,0,0,0,1,0,0,0,NULL,'GA',33.58499908,-83.46900177,'Accountant',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,0,1,1,1,1,0,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,17,0,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a0da288b-ac3e-43ae-8b4a-17d2ca81630f',251,'5/11/2011',NULL,'Fisher','F-Female','1/1/1960',51,NULL,0,0,0,1,0,0,0,NULL,'GA',33.60900116,-83.51100159,'Unemployed',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,1,0,0,1,1,1,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,100.3000031,15,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a2199a80-9860-4a72-9ae9-91533a829db3',241,'5/10/2011',NULL,'Ellis','M-Male','1/1/1961',50,NULL,0,0,1,0,0,0,0,NULL,'GA',33.56900024,-83.51200104,'Manufacturing',NULL,NULL,1,'5/3/2011',NULL,1,1,1,1,0,1,1,0,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,102.0999985,16,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a2643845-1c13-4f8e-920b-787254b11ee7',129,'5/22/2011',NULL,'Harrison','M-Male','4/16/1997',14,NULL,0,0,1,0,0,0,0,NULL,'GA',33.46900177,-83.63899994,'Student',NULL,NULL,1,'5/15/2011',NULL,1,1,1,0,0,0,1,1,1,0,NULL,1,NULL,1,NULL,NULL,0,NULL,102.5999985,20,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a31fb8c1-84c9-4ee5-8365-a0a30d7a9201',341,'5/10/2011',NULL,'Gibson','M-Male','4/8/1960',51,NULL,0,0,0,0,0,0,1,NULL,'GA',33.60300064,-83.46900177,NULL,NULL,NULL,1,'5/3/2011',NULL,1,1,1,0,1,1,1,1,1,1,'1-3 per day',1,'4/17/2011',0,NULL,1,0,NULL,102,15,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a47434d7-1d4e-45af-aa9d-95468df9b4ca',117,'5/18/2011',NULL,'McDonald','F-Female','2/12/1960',51,NULL,1,0,0,0,0,0,0,NULL,'GA',33.59400177,-83.47499847,'Consultant',NULL,NULL,0,'5/11/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,1,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a48ae50f-9914-401e-8d88-f3e3fe7fe09c',53,'5/18/2011',NULL,'Cruz','F-Female','5/3/1996',15,NULL,0,0,0,1,0,0,0,NULL,'GA',33.59000015,-83.47200012,'Student',NULL,NULL,0,'5/11/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a57ffe3b-e2e5-4653-a941-c594bf4b9ee9',158,'5/5/2011',NULL,'Cruz','F-Female','2/28/1986',25,NULL,0,0,0,1,0,0,0,NULL,'GA',33.56800079,-83.18399811,'Clerk',NULL,NULL,1,'4/28/2011',NULL,0,1,1,0,1,0,1,0,0,0,'4-6 per day',1,'4/15/2011',0,NULL,0,0,NULL,NULL,15,0,1,0,0,1,0,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a5c5edd4-a5aa-4557-958e-15a842104c87',205,'5/29/2011',NULL,'Cruz','F-Female','6/18/1977',33,NULL,0,1,0,0,0,0,0,NULL,'GA',33.5929985,-83.46600342,'Government',NULL,NULL,1,'5/22/2011',NULL,1,1,0,0,1,1,1,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,99.69999695,17,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a75da75f-08a3-4aea-aa4c-2340c84ebd4b',25,'5/9/2011',NULL,'Cruz','M-Male','1/6/1948',63,NULL,1,0,0,0,0,0,0,NULL,'GA',33.57400131,-83.45400238,'Doctor',NULL,NULL,0,'5/2/2011',NULL,1,1,0,1,1,0,1,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,18,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('a986788a-79a2-4512-9241-4f40780b66de',332,'5/14/2011',NULL,'Cruz','F-Female','1/1/1988',23,NULL,0,0,0,0,1,0,0,NULL,'GA',33.79399872,-83.71299744,NULL,NULL,NULL,1,'5/7/2011',NULL,0,1,1,0,1,1,0,1,1,1,'4-6 per day',1,'4/14/2011',1,'4/15/2011',1,0,NULL,104,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('aae689c7-414b-4bfd-83d3-c514a34ca5f8',236,'5/10/2011',NULL,'Marshall','F-Female','10/29/1990',20,NULL,0,1,0,0,0,0,0,NULL,'GA',33.77199936,-83.42299652,'Unemployed',NULL,NULL,1,'5/3/2011',NULL,1,1,0,1,1,1,1,0,1,1,'7-10 per day',1,'4/13/2011',1,'4/16/2011',1,0,NULL,103.0999985,15,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ab9a74c0-13b4-4605-9e60-530faf19303c',346,'5/26/2011',NULL,'Marshall','M-Male','8/18/1962',48,NULL,0,0,0,0,0,0,1,NULL,'GA',33.78699875,-83.72599792,NULL,NULL,NULL,1,'5/19/2011',NULL,1,1,1,0,1,1,1,1,1,1,'1-3 per day',1,NULL,0,NULL,1,0,NULL,NULL,17,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('abf16f5e-1fe6-4cc2-a2cf-934686275242',126,'5/19/2011',NULL,'Marshall','F-Female','6/8/1967',43,NULL,0,0,0,0,0,0,1,NULL,'GA',33.60300064,-83.47399902,'Manufacturing',NULL,NULL,1,'5/12/2011',NULL,1,1,1,0,1,0,0,0,0,1,'4-6 per day',1,'5/14/2011',1,'5/14/2011',0,0,NULL,103.5999985,19,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0,1,1,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ac908038-4e10-4844-b24d-50f8bae8fdd9',87,'5/15/2011',NULL,'Ortiz','F-Female','9/20/1992',18,NULL,0,0,0,0,0,0,1,NULL,'GA',33.78300095,-83.70899963,'Student',NULL,NULL,0,'5/8/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ad3172dd-cf17-4ebf-862d-e11f03ebddb0',270,'5/12/2011',NULL,'Gomez','M-Male','1/5/1981',30,NULL,0,0,0,0,0,1,0,NULL,'GA',33.86299896,-83.72399902,'Food service worker',NULL,NULL,1,'5/5/2011',NULL,0,1,1,1,1,0,0,1,1,1,'10+ per day',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,15,0,0,1,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ae055261-b55b-422b-abff-c105eddedcd3',22,'4/27/2011',NULL,'Murray','F-Female','4/23/1989',22,NULL,0,0,1,0,0,0,0,NULL,'GA',33.60800171,-83.47699738,'Food service worker',NULL,NULL,0,'4/20/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('aee484e0-01fd-4318-9ba4-6472e83ccbe2',142,'5/8/2011',NULL,'Freeman','M-Male','3/12/1990',21,NULL,0,1,0,0,0,0,0,NULL,'GA',33.45800018,-83.39600372,'Student',NULL,NULL,1,'5/1/2011',NULL,1,1,1,0,0,1,1,1,0,0,NULL,1,NULL,0,NULL,0,0,NULL,NULL,20,1,0,0,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('af1e871d-0f84-4309-9f09-bd98cb4e1da6',94,'5/7/2011',NULL,'Freeman','M-Male','9/25/1996',14,NULL,0,0,1,0,0,0,0,NULL,'GA',33.44200134,-83.09300232,'Student',NULL,NULL,1,'4/30/2011',NULL,1,1,1,1,1,0,0,0,0,1,'10+ per day',1,'4/30/2011',1,'5/1/2011',1,0,NULL,102,17,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('af4ff2f3-6201-466f-8acf-5f189678a986',198,'5/22/2011',NULL,'Freeman','F-Female','2/15/1993',18,NULL,0,1,0,0,0,0,0,NULL,'GA',33.56299973,-83.44000244,'Student',NULL,NULL,1,'5/15/2011',NULL,1,1,0,1,1,1,1,0,1,0,'1-3 per day',0,NULL,1,'4/27/2011',NULL,0,NULL,100.1999969,17,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('af6785b9-dcb6-4263-b9c6-63daa7e64e28',160,'5/2/2011',NULL,'Freeman','F-Female','5/7/1982',28,NULL,0,0,0,0,0,1,0,NULL,'GA',33.5719986,-83.19499969,'Software developer',NULL,NULL,1,'4/25/2011',NULL,0,1,0,1,1,0,0,0,1,1,'1-3 per day',0,NULL,1,'4/16/2011',0,0,NULL,NULL,15,0,0,0,0,1,0,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('afc15dc2-2962-45a8-a4d3-5ffdd6ddda53',111,'5/9/2011',NULL,'Freeman','F-Female','1/30/1997',14,NULL,0,0,0,1,0,0,0,NULL,'GA',33.5890007,-83.50700378,'Student',NULL,NULL,1,'5/2/2011',NULL,1,1,0,0,0,0,1,1,0,0,NULL,0,NULL,0,NULL,0,0,NULL,102,18,0,1,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,1,1,1,0,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b030f554-3869-4e31-bcd4-b0931ab8a05d',321,'5/14/2011',NULL,'Wells','M-Male','10/1/1956',54,NULL,0,0,0,1,0,0,0,NULL,'GA',33.5870018,-83.46399689,'Service worker',NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,1,1,'1-3 per day',1,'4/23/2011',1,'4/25/2011',0,0,NULL,105,16,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b1dbab40-9df0-40e3-9e6b-4f2dec43c6c2',13,'5/7/2011',NULL,'Webb','M-Male','8/10/1970',40,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59000015,-83.47399902,'Construction worker',NULL,NULL,1,'4/30/2011',NULL,1,1,0,0,1,0,1,0,0,1,'4-6 per day',1,'4/6/2011',1,'4/6/2011',1,0,NULL,100.6999969,14,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b203ef82-1951-4cdf-b008-c8335ad09743',105,'5/13/2011',NULL,'Simpson','M-Male','1/4/1946',65,NULL,0,0,0,0,0,1,0,NULL,'GA',33.59000015,-83.46900177,'Government',NULL,NULL,1,'5/6/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,0,0,NULL,NULL,19,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1,1,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b42a19fb-3c48-49a1-82fb-b9b4f4985abc',293,'5/13/2011',NULL,'Stevens','F-Female','3/11/1958',53,NULL,1,0,0,0,0,0,0,NULL,'GA',33.40000153,-83.59300232,'Software developer',NULL,NULL,1,'5/6/2011',NULL,1,1,0,1,0,0,1,1,1,0,'4-6 per day',0,NULL,0,NULL,0,0,NULL,NULL,16,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b50a2874-ad67-4814-a107-1eb23db98cad',32,'5/15/2011',NULL,'Tucker','F-Female','11/28/1955',55,NULL,0,0,1,0,0,0,0,NULL,'GA',33.58200073,-83.49099731,NULL,NULL,NULL,0,'5/8/2011',NULL,1,1,1,1,1,0,1,1,1,0,'7-10 per day',1,'4/24/2011',1,'4/24/2011',1,0,NULL,NULL,16,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b5526e36-6440-4105-bca1-6f699b835804',159,'5/5/2011',NULL,'Porter','F-Female','5/22/1970',40,NULL,0,0,0,0,1,0,0,NULL,'GA',33.59500122,-83.47200012,'Doctor',NULL,NULL,1,'4/28/2011',NULL,0,1,1,1,1,1,0,0,1,0,'1-3 per day',1,'4/15/2011',0,NULL,0,0,NULL,NULL,15,0,0,0,0,1,0,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b57fe70f-c288-44cb-91c6-6dedc8976c2b',351,'5/16/2011',NULL,'Hunter','M-Male','1/1/1981',30,NULL,1,0,0,0,0,0,0,NULL,'GA',33.58399963,-83.47200012,NULL,NULL,NULL,1,'5/9/2011',NULL,1,1,0,0,0,1,1,1,0,1,'4-6 per day',0,NULL,1,NULL,1,0,NULL,NULL,14,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b5dc2a58-b588-4382-80b4-66ce8b2d0576',242,'5/10/2011',NULL,'Hicks','M-Male','1/1/1994',17,NULL,0,0,1,0,0,0,0,NULL,'GA',33.60200119,-83.45600128,'Student',NULL,NULL,1,'5/3/2011',NULL,1,1,1,1,1,1,1,0,1,1,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101,17,0,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b65f5d1d-3304-434e-b163-cd1f1f3c3862',287,'5/13/2011',NULL,'Crawford','F-Female','1/1/1980',31,NULL,0,0,0,0,0,0,1,NULL,'GA',33.56200027,-83.36299896,'Manufacturing',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',1,'4/17/2011',1,'4/17/2011',1,0,NULL,NULL,16,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b66a9ae3-8aed-4e60-91d9-64d2f4dabe14',186,'5/19/2011',NULL,'Henry','F-Female','8/1/1972',38,NULL,0,0,0,1,0,0,0,NULL,'GA',33.59400177,-83.45300293,'Manufacturing',NULL,NULL,1,'5/12/2011',NULL,1,1,1,1,1,1,0,0,0,0,'1-3 per day',1,'4/15/2011',0,NULL,0,0,NULL,98.90000153,15,0,1,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b7418aa8-5e11-4023-83e6-6e7e9c8989fd',55,'5/18/2011',NULL,'Boyd','F-Female','12/20/1943',67,NULL,0,0,0,1,0,0,0,NULL,'GA',33.79600143,-83.71199799,'Accountant',NULL,NULL,0,'5/11/2011',NULL,1,1,1,0,1,0,0,0,0,0,'4-6 per day',0,NULL,0,NULL,NULL,0,NULL,103.0999985,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('b9cda82a-9a96-418a-9dfc-b96c46a1853c',73,'5/11/2011',NULL,'Mason','M-Male','1/4/1996',NULL,NULL,0,0,0,1,0,0,0,NULL,'GA',33.60300064,-83.47399902,'Student',NULL,NULL,0,'5/4/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ba14d3b6-1ddd-4125-937e-cd20335e121a',213,'5/7/2011',NULL,'Morales','F-Female','11/23/1964',46,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59799957,-83.46399689,'Manufacturing',NULL,NULL,1,'4/30/2011',NULL,1,1,1,0,1,1,1,1,1,0,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,102.0999985,17,0,0,0,0,1,1,0,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('baa113af-2f0b-4283-abbf-4b29323c5646',154,'5/8/2011',NULL,'Kennedy','M-Male','7/2/1973',37,NULL,0,0,0,0,0,0,1,NULL,'GA',33.46500015,-83.30500031,'Unemployed',NULL,NULL,0,'5/1/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,1,0,1,1,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('bc6e246a-4e56-4860-a4d1-05b8d6bda76d',171,'5/17/2011',NULL,'Kennedy','M-Male','7/20/1967',43,NULL,0,0,1,0,0,0,0,NULL,'GA',33.47999954,-83.3730011,'Food service worker',NULL,NULL,1,'5/9/2011',NULL,0,1,1,1,1,0,1,1,1,1,'4-6 per day',1,'4/17/2011',1,'4/17/2011',1,1,'4/18/2011',106.6999969,15,0,1,0,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('be3638bb-b87a-446d-9354-c34f3900c356',187,'5/18/2011',NULL,'Warren','M-Male','10/1/1954',56,NULL,0,0,0,0,1,0,0,NULL,'GA',33.42900085,-83.55200195,'Manager',NULL,NULL,1,'5/11/2011',NULL,1,1,0,1,0,1,0,1,0,0,'1-3 per day',1,'4/27/2011',1,'4/28/2011',0,0,NULL,100.0999985,17,0,1,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('be574cce-87a4-40b3-8ad0-62f53196551d',58,'5/20/2011',NULL,'Dixon','F-Female','4/22/1988',23,NULL,0,0,0,0,0,0,1,NULL,'GA',33.59400177,-83.46199799,'Accountant',NULL,NULL,0,'5/13/2011',NULL,1,1,1,0,1,0,0,0,0,0,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.8000031,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('be7b8083-53bc-4b51-8869-e0dbc2dc6c18',284,'5/13/2011',NULL,'Dixon','M-Male','10/10/1978',32,NULL,0,0,0,0,0,0,1,NULL,'GA',33.7840004,-83.13899994,'Consultant',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,1,0,1,1,0,'7-10 per day',1,'4/10/2011',1,'4/11/2011',1,0,NULL,102,14,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('bf8714b5-ce9f-4966-ae28-9b49ada063b8',56,'5/18/2011',NULL,'Ramos','M-Male','9/24/1967',43,NULL,0,0,0,0,1,0,0,NULL,'GA',33.65499878,-83.74299622,'Manager',NULL,NULL,0,'5/11/2011',NULL,1,1,1,0,1,0,0,0,0,0,'1-3 per day',1,'5/29/2011',NULL,NULL,NULL,0,NULL,104.0999985,21,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('bfdc73bf-49d6-47e9-9c11-2ae6d32b03af',297,'5/13/2011',NULL,'Ramos','F-Female','1/1/1960',51,NULL,1,0,0,0,0,0,0,NULL,'GA',33.61299896,-83.20700073,NULL,NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,0,0,1,0,1,0,'4-6 per day',1,'4/9/2011',0,NULL,1,0,NULL,NULL,14,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c1df5a10-9d33-41cd-b60e-b42a5f761db1',86,'5/15/2011',NULL,'Ramos','M-Male','1/23/1998',13,NULL,0,0,0,0,0,0,1,NULL,'GA',33.56299973,-83.61499786,'Student',NULL,NULL,0,'5/8/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c214d7d0-c60a-44a6-bf69-36e1cfd642d1',148,'5/10/2011',NULL,'Reyes','M-Male','1/7/1967',44,NULL,1,0,0,0,0,0,0,NULL,'GA',33.5890007,-83.47200012,'Equipment technician',NULL,NULL,0,'5/3/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,1,0,1,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c220c356-84c4-45b7-934c-0401dcf2e515',347,'5/20/2011',NULL,'Reyes','M-Male','8/11/1989',21,NULL,0,0,0,0,0,0,1,NULL,'GA',33.77399826,-83.73899841,NULL,NULL,NULL,1,'5/13/2011',NULL,1,1,1,0,0,1,1,0,1,1,'4-6 per day',1,NULL,0,NULL,0,0,NULL,NULL,16,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c273a8e6-4b45-4d5c-b361-1993a99c8c4e',274,'5/13/2011',NULL,'Reyes','F-Female','1/29/1962',49,NULL,0,0,0,0,0,1,0,NULL,'GA',33.5929985,-83.47799683,'Service worker',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,1,1,0,1,1,'10+ per day',1,'4/15/2011',1,'4/15/2011',1,0,NULL,104.3000031,15,1,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c291806c-1987-4c76-acec-44698d8293e7',245,'5/10/2011',NULL,'Reyes','F-Female','1/1/1991',20,NULL,0,0,1,0,0,0,0,NULL,'GA',33.59199905,-83.46199799,'Clerk',NULL,NULL,1,'5/3/2011',NULL,1,1,1,1,0,1,1,0,0,1,'7-10 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.1999969,14,0,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c4b07bb7-fe75-4bc5-bccd-77f69a62451d',214,'4/28/2011',NULL,'Burns','F-Female','7/13/1955',55,NULL,0,0,0,1,0,0,0,NULL,'GA',33.58800125,-83.5019989,'Manufacturing',NULL,NULL,1,'4/21/2011',NULL,1,1,1,0,1,0,1,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,103,17,0,0,0,0,1,1,0,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c4b25e6f-c80c-4fea-8597-8ae4c18d45e1',60,'5/25/2011',NULL,'Burns','M-Male','4/22/1988',23,NULL,0,1,0,0,0,0,0,NULL,'GA',33.58599854,-83.4940033,'Soldier',NULL,NULL,0,'5/18/2011',NULL,1,1,1,0,1,0,0,0,0,0,'1-3 per day',1,'5/7/2011',NULL,NULL,NULL,0,NULL,102.6999969,18,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c4e56d4d-edd3-4a4c-b0f3-4468d0154716',196,'5/20/2011',NULL,'Burns','F-Female','5/12/1957',54,NULL,0,0,0,0,0,0,1,NULL,'GA',33.42599869,-83.21800232,'Janitor',NULL,NULL,1,'5/13/2011',NULL,0,1,1,1,1,0,0,1,1,0,'10+ per day',1,'4/16/2011',1,'4/16/2011',1,0,NULL,100.9000015,15,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c59ec209-d29a-4997-826f-9ced0fa83008',223,'5/3/2011',NULL,'Burns','F-Female','7/19/1996',14,NULL,0,0,0,0,0,1,0,NULL,'GA',33.58599854,-83.47200012,'Student',NULL,NULL,1,'4/26/2011',NULL,1,1,1,1,0,1,1,1,0,0,'7-10 per day',1,'4/15/2011',1,'4/15/2011',1,1,'4/17/2011',104,15,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c5cfbbd3-da48-464b-bfba-77e763d5ebd2',96,'5/16/2011',NULL,'Burns','F-Female','7/1/1956',54,NULL,0,0,0,0,1,0,0,NULL,'SC',34.18999863,-82.17099762,'Lawyer',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,0,0,0,0,0,0,'4-6 per day',1,'5/14/2011',0,NULL,0,0,NULL,103.1999969,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c89c6d6f-a914-4321-8be6-f8e7cf388455',33,'5/16/2011',NULL,'Gordon','F-Female','1/24/1985',26,NULL,0,0,0,1,0,0,0,NULL,'SC',34.19499969,-82.17299652,NULL,NULL,NULL,0,'5/9/2011',NULL,1,0,0,1,1,0,1,1,0,0,'1-3 per day',0,NULL,0,NULL,0,0,NULL,NULL,16,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('c96ef62d-1333-4a71-a288-210b80ca2176',51,'5/17/2011',NULL,'Gordon','M-Male','6/30/1986',24,NULL,0,0,0,1,0,0,0,NULL,'SC',34.19800186,-82.16699982,'Sales',NULL,NULL,0,'5/10/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ca4d6cb2-87c9-4894-80ea-537d946097c1',81,'5/9/2011',NULL,'Gordon','F-Female','5/6/1949',62,NULL,0,0,0,0,0,0,1,NULL,'SC',34.19800186,-82.16699982,'Teacher',NULL,NULL,0,'5/2/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,16,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('caac15a6-8669-4de1-96a6-2eb58415c4a9',84,'5/8/2011',NULL,'Gordon','M-Male','1/12/1967',44,NULL,0,0,0,0,0,0,1,NULL,'SC',34.19800186,-82.16699982,'Civil engineer',NULL,NULL,1,'5/1/2011',NULL,1,1,1,0,1,0,0,0,0,0,'1-3 per day',1,'4/17/2011',0,NULL,1,0,NULL,103.3000031,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d3a537ff-a662-4eff-8da3-4729d7ac24e4',307,'5/14/2011',NULL,'Berry','F-Female','1/1/1983',28,NULL,0,0,1,0,0,0,0,NULL,'SC',34.22200012,-82.19599915,NULL,NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,0,1,1,'10+ per day',1,'4/16/2011',1,'4/17/2011',0,0,NULL,101.3000031,15,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d4345493-9105-4116-b15f-df66a9989556',291,'5/13/2011',NULL,'Matthews','F-Female','1/7/1989',22,NULL,1,0,0,0,0,0,0,NULL,'SC',34.22700119,-82.17099762,'Professional athlete',NULL,NULL,1,'5/6/2011',NULL,1,1,0,1,1,1,1,1,1,1,'7-10 per day',1,NULL,1,NULL,1,0,NULL,NULL,17,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d47cd15f-c3be-4b80-a2fb-ae1d091d42a1',262,'5/12/2011',NULL,'Arnold','F-Female','1/1/1973',38,NULL,0,0,0,0,1,0,0,NULL,'SC',34.14199829,-82.08599854,'Service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,1,1,0,1,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,15,0,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d4cac655-7d9b-409c-a422-316382347379',338,'5/15/2011',NULL,'Wagner','F-Female','1/22/1977',34,NULL,0,0,0,0,0,1,1,NULL,'SC',34.21300125,-82.03900146,NULL,NULL,NULL,1,'5/8/2011',NULL,1,1,1,1,1,1,1,0,1,1,'4-6 per day',1,'4/23/2011',0,NULL,0,0,NULL,101.5999985,16,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d6189c1d-3446-41e5-a792-34eae3cd61cb',40,'5/6/2011',NULL,'Willis','F-Female','8/5/1970',40,NULL,0,0,0,1,0,0,0,NULL,'SC',34.25500107,-82.23300171,'Farmer',NULL,NULL,0,'4/29/2011',NULL,1,0,0,0,0,0,0,0,0,0,NULL,0,NULL,0,NULL,0,0,NULL,NULL,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d6af7f58-26bd-47ac-ad02-3b377a86d181',203,'5/22/2011',NULL,'Ray','M-Male','12/28/1992',18,NULL,0,0,0,0,0,0,1,NULL,'SC',34.06100082,-82.15899658,'Accountant',NULL,NULL,1,'5/15/2011',NULL,1,1,0,1,1,1,1,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,100.9000015,15,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d791db42-0774-4510-abfa-d6cc3a2f5e7e',345,'5/3/2011',NULL,'Watkins','M-Male','9/17/1986',24,NULL,0,0,0,0,0,0,1,NULL,'SC',34.04999924,-82.14600372,NULL,NULL,NULL,1,'4/26/2011',NULL,0,1,1,0,0,1,0,1,1,1,'4-6 per day',1,NULL,0,NULL,1,0,NULL,NULL,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d7bbb98a-a2ca-4e8e-a9f1-b527e9174806',39,'5/15/2011',NULL,'Olson','F-Female','8/16/1998',12,NULL,0,0,1,0,0,0,0,NULL,'SC',34.06399918,-82.13500214,'Student',NULL,NULL,0,'5/8/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d8440b60-05bb-4d2e-9ab1-21421238451c',263,'5/12/2011',NULL,'Carroll','F-Female','8/26/1994',16,NULL,0,0,0,0,1,0,0,NULL,'SC',34.0929985,-82.04499817,'Student',NULL,NULL,1,'5/5/2011',NULL,1,1,1,1,0,1,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,15,0,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d9afeb15-462a-470c-ab9a-c64662630c17',20,'5/1/2011',NULL,'Duncan','F-Female','10/22/1978',32,NULL,1,0,0,0,0,0,0,NULL,'SC',34.15499878,-81.93000031,'Food service worker',NULL,NULL,0,'4/24/2011',NULL,1,1,1,0,1,0,1,0,0,1,'1-3 per day',0,NULL,0,NULL,0,0,NULL,100.3000031,15,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d9b598e3-5cca-46f0-98f8-41d012adaf40',139,'5/17/2011',NULL,'Snyder','F-Female','1/13/1975',36,NULL,0,0,0,0,0,1,0,NULL,'SC',34.2879982,-82.24500275,'Dancer',NULL,NULL,1,'5/10/2011',NULL,1,1,1,0,0,0,0,1,1,0,NULL,1,'5/16/2011',0,NULL,1,0,NULL,NULL,20,0,0,1,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('da32a0d7-ec88-4e13-9848-b692a3298eaf',170,'5/17/2011',NULL,'Hart','F-Female','8/12/1987',23,NULL,0,1,0,0,0,0,0,NULL,'SC',34.17499924,-82.39600372,'Construction worker',NULL,NULL,1,'5/10/2011',NULL,0,1,1,0,1,0,0,0,1,1,'1-3 per day',1,'4/16/2011',1,'4/16/2011',1,0,NULL,NULL,15,0,1,0,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('da3c0684-584f-4692-b681-707a0394bcad',285,'5/13/2011',NULL,'Cunningham','F-Female','1/1/1981',30,NULL,0,0,0,0,0,0,1,NULL,'SC',34.18899918,-82.375,'Police officer',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,1,1,1,0,1,0,'7-10 per day',1,'4/6/2011',1,NULL,1,0,NULL,104,14,0,1,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('da5ae6cd-c9e9-497f-b3e8-6ede6dcf1b7d',278,'5/13/2011',NULL,'Bradley','M-Male','1/30/1947',64,NULL,0,0,0,0,0,0,1,NULL,'SC',34.16999817,-82.36499786,'Manufacturing',NULL,NULL,1,'5/6/2011',NULL,1,1,1,0,1,1,1,0,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.5999985,16,0,1,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e358c6b6-6597-4ef3-8fcd-dd33402a78cd',265,'5/12/2011',NULL,'Austin','F-Female','12/13/1990',20,NULL,0,0,0,0,1,0,0,NULL,'NC',35.58800125,-82.53199768,'Clerk',NULL,NULL,1,'5/5/2011',NULL,1,1,1,1,0,0,1,0,0,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,17,0,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e61456f9-01e8-4f76-8978-9ead26c9b9e8',130,'5/26/2011',NULL,'Peters','M-Male','4/18/1972',39,NULL,0,0,0,1,0,0,0,NULL,'NC',35.54399872,-82.52799988,'Nurse',NULL,NULL,1,'5/19/2011',NULL,1,1,1,0,0,1,1,0,0,0,NULL,1,'5/17/2011',NULL,NULL,NULL,0,NULL,102.8000031,20,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,0,0,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e638a9ed-83fd-4777-8bfe-79120cad1950',225,'5/7/2011',NULL,'Kelley','F-Female','5/23/1968',42,NULL,1,0,0,0,0,0,0,NULL,'NC',35.52199936,-82.53800201,'Sales',NULL,NULL,1,'4/30/2011',NULL,0,1,1,1,1,1,1,1,0,1,'4-6 per day',1,'4/15/2011',1,'4/18/2011',1,0,NULL,99.69999695,15,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e66e031c-2883-4248-a1a9-b6576796260f',62,'5/16/2011',NULL,'Franklin','M-Male','1/1/1988',23,NULL,0,0,0,1,0,0,0,NULL,'NC',35.55099869,-82.50900269,'Food service worker',NULL,NULL,0,'5/9/2011',NULL,1,0,1,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,22,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e704ffd7-55cf-4027-9586-89e6da7b22c5',131,'5/19/2011',NULL,'Lawson','M-Male','9/27/1965',45,NULL,0,0,0,0,1,0,0,NULL,'NC',35.56399918,-82.50700378,'Equipment technician',NULL,NULL,1,'5/12/2011',NULL,1,1,0,0,1,0,0,0,0,0,'7-10 per day',1,'5/17/2011',0,NULL,NULL,0,NULL,102.5,20,0,0,0,0,0,0,0,0,1,0,0,1,0,1,1,1,0,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e7fd8c40-e736-4892-afda-fc6a4d921a2b',279,'5/13/2011',NULL,'Fields','M-Male','2/25/1964',47,NULL,0,0,0,0,0,0,1,NULL,'NC',35.59199905,-82.51200104,'Manufacturing',NULL,NULL,1,'5/6/2011',NULL,1,1,0,1,1,1,1,1,1,1,'10+ per day',1,'4/1/2011',1,'4/1/2011',0,0,NULL,104.0999985,13,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e7ff6236-8410-466a-8d6a-d7cf8918e30a',168,'5/16/2011',NULL,'Guiterrez','F-Female','12/22/1995',15,NULL,0,0,0,0,0,0,1,NULL,'NC',35.60800171,-82.54000092,'Student',NULL,NULL,1,'5/9/2011',NULL,0,1,1,1,1,0,0,0,1,0,'1-3 per day',1,'4/11/2011',1,'4/11/2011',1,0,NULL,NULL,14,0,1,0,0,1,0,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e836beee-af88-4ee9-a941-20b0fa2d554c',267,'5/12/2011',NULL,'Ryan','M-Male','1/1/1963',48,NULL,0,0,0,0,0,1,0,NULL,'NC',35.60800171,-82.54000092,'Service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,1,1,0,1,1,1,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,16,1,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e8421ed0-5f28-4d10-9477-0f1900d71652',120,'5/16/2011',NULL,'Schmidt','F-Female','1/1/1986',25,NULL,1,0,0,0,0,0,0,NULL,'NC',35.60300064,-82.54799652,'Accountant',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,0,0,0,0,1,0,'1-3 per day',1,'5/15/2011',1,'5/15/2011',1,0,NULL,103,19,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,NULL,1,0,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e91edce9-de99-439a-abab-ecfe7fe2be8e',181,'5/9/2011',NULL,'Carr','F-Female','7/3/1985',25,NULL,0,0,0,0,0,1,0,NULL,'NC',35.60300064,-82.54799652,'Musician',NULL,NULL,1,'5/2/2011',NULL,1,1,1,1,1,1,0,1,1,0,'4-6 per day',1,'4/5/2011',0,NULL,0,0,NULL,101.5999985,14,0,0,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e9dee26c-fa5b-4cfb-b480-1aff7d6c569f',119,'5/17/2011',NULL,'Vasquez','M-Male','1/1/2000',11,NULL,1,0,0,0,0,0,0,NULL,'NC',35.60499954,-82.55599976,'Student',NULL,NULL,0,'5/9/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,1,0,0,1,1,1,0,0,0,1,1,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('eb313b40-c644-4e7c-99df-606191358357',218,'5/7/2011',NULL,'Castillo','F-Female','9/20/1981',29,NULL,1,0,0,0,0,0,0,NULL,'NC',35.60499954,-82.55599976,'Manufacturing',NULL,NULL,1,'4/30/2011',NULL,0,1,1,1,1,0,1,1,1,0,'1-3 per day',0,NULL,1,'4/17/2011',1,0,NULL,103.1999969,15,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('eb32542d-d67b-4176-b147-6ecd6df9fa96',209,'5/17/2011',NULL,'Wheeler','F-Female','5/3/1966',45,NULL,0,0,0,0,0,1,0,NULL,'NC',35.62099838,-82.55799866,'Food service worker',NULL,NULL,1,'5/10/2011',NULL,1,1,1,1,1,0,1,0,1,0,'7-10 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,100,16,0,1,0,0,1,1,1,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('eb3c1712-e49b-4ef4-a1f6-3b9a814f8a4c',201,'5/20/2011',NULL,'Chapman','M-Male','9/28/1967',43,NULL,0,0,0,0,1,0,0,NULL,'NC',35.62099838,-82.55799866,'Service worker',NULL,NULL,1,'5/13/2011',NULL,0,1,1,1,1,0,1,1,1,1,'10+ per day',1,'4/5/2011',1,'4/6/2011',1,1,'4/9/2011',104.0999985,13,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('cb5f6d93-2989-4622-a03d-6fe241c0130b',324,'5/14/2011',NULL,'Gordon','F-Female','12/30/1963',47,NULL,0,0,0,1,0,0,0,NULL,'SC',34.19599915,-82.15699768,'Sales',NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,0,0,1,1,1,'4-6 per day',1,'4/3/2011',0,NULL,1,0,NULL,104.5,13,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('cb9a4bc7-38f5-41d9-b400-08ad12397f0a',124,'5/19/2011',NULL,'Gordon','F-Female','9/25/1972',38,NULL,0,0,0,0,1,0,0,NULL,'SC',34.20500183,-82.16100311,'Clerk',NULL,NULL,1,'5/12/2011',NULL,1,1,1,0,0,0,1,1,1,0,NULL,1,'5/16/2011',0,NULL,0,0,NULL,102.8000031,20,0,0,0,0,0,0,0,0,1,0,0,1,1,1,1,0,0,1,1,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('cb9dffa2-9621-434e-ba04-2fc51df37310',228,'5/7/2011',NULL,'Shaw','F-Female','1/1/1948',63,NULL,1,0,0,0,0,0,0,NULL,'SC',34.21099854,-82.16000366,'Lawyer',NULL,NULL,1,'4/30/2011',NULL,1,1,1,1,1,1,0,1,1,0,'1-3 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,100,15,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('cbf40e1d-7f5b-407f-a1fc-03dd56486999',249,'5/11/2011',NULL,'Holmes','F-Female','5/24/1985',25,NULL,0,0,0,1,0,0,0,NULL,'SC',34.20000076,-82.14399719,'Teacher',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,1,1,1,1,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,101.3000031,15,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('cc33745d-c616-4f24-9203-d8063edbdc00',71,'5/9/2011',NULL,'Rice','M-Male','1/10/1967',44,NULL,0,1,0,0,0,0,0,NULL,'SC',34.18700027,-82.15000153,'Manager',NULL,NULL,0,'5/2/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('cc71d4c3-c4e4-42e7-a014-56a7965a83eb',221,'5/3/2011',NULL,'Roberston','F-Female','3/3/1991',20,NULL,0,0,0,1,0,0,0,NULL,'SC',34.1780014,-82.15899658,'Soldier',NULL,NULL,1,'4/26/2011',NULL,1,1,1,1,0,1,0,1,0,0,'1-3 per day',1,NULL,1,NULL,1,0,NULL,NULL,14,0,1,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('cf93b4fe-2d4f-4d4d-a142-85c4d85bb706',234,'5/10/2011',NULL,'Hunt','M-Male','5/10/1981',30,NULL,0,1,0,0,0,0,0,NULL,'SC',34.16600037,-82.13800049,'Food service worker',NULL,NULL,1,'5/3/2011',NULL,1,1,1,0,0,1,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,102,16,0,1,0,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d038ee36-236e-4841-b279-f33ee3097793',210,'5/12/2011',NULL,'Black','F-Female','3/1/1970',41,NULL,0,0,0,0,0,0,1,NULL,'SC',34.16600037,-82.11799622,'Food service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,1,0,1,0,1,0,1,0,'10+ per day',1,'4/13/2011',1,'4/13/2011',1,0,NULL,100.5999985,15,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d0c3299f-af94-405d-b412-80db7c40476f',182,'5/16/2011',NULL,'Spencer','M-Male','6/10/1976',34,NULL,0,0,0,0,0,0,1,NULL,'SC',34.18600082,-82.11399841,'Government',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,0,0,0,1,1,0,'1-3 per day',1,'4/25/2011',1,'4/25/2011',1,0,NULL,100.5999985,16,0,0,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d13364d0-dc41-4663-87a8-4d4e07a8ee7b',163,'5/6/2011',NULL,'Gardner','M-Male','5/23/1974',36,NULL,0,1,0,0,0,0,0,NULL,'SC',34.19100189,-82.1989975,'Pilot',NULL,NULL,1,'4/29/2011',NULL,0,1,1,1,1,0,0,0,1,1,'4-6 per day',1,'4/21/2011',0,NULL,0,0,NULL,103.1999969,16,1,0,0,0,1,0,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d191eddc-08e8-4d12-b59a-a3046c908fca',303,'5/14/2011',NULL,'Stephens','F-Female','1/1/1985',26,NULL,0,1,0,0,0,0,0,NULL,'SC',34.19499969,-82.1969986,NULL,NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,1,1,'7-10 per day',1,'4/17/2011',1,'4/21/2011',1,0,NULL,100.0999985,15,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d27313c7-2897-492f-b0c6-e63da0b6c866',85,'5/13/2011',NULL,'Payne','M-Male','9/6/1995',15,NULL,0,0,0,0,0,0,1,NULL,'SC',34.20399857,-82.20500183,'Student',NULL,NULL,0,'5/6/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d273e721-7a80-4cfd-9550-d579cd05340b',298,'5/13/2011',NULL,'Payne','M-Male','1/1/1968',43,NULL,1,0,0,0,0,0,0,NULL,'SC',34.20399857,-82.20500183,NULL,NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,0,0,1,1,1,1,'4-6 per day',0,NULL,1,'4/1/2011',1,0,NULL,NULL,13,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('d28e7c60-ae6e-4067-9fce-c4b02adc2f40',243,'5/10/2011',NULL,'Pierce','M-Male','8/17/1996',14,NULL,0,0,1,0,0,0,0,NULL,'SC',34.20800018,-82.2009964,'Student',NULL,NULL,1,'5/3/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',1,'4/26/2011',1,'4/27/2011',1,1,'4/1/2011',104.5999985,16,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('dc5d7caa-a678-4630-92e8-b536de8b0753',8,'5/9/2011',NULL,'Lane','F-Female','1/10/1985',26,NULL,1,0,0,0,0,0,0,NULL,'SC',34.16400146,-82.38999939,'Software developer',NULL,NULL,0,'5/2/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('dcbee615-a42a-4758-85f7-796e8c64bb9c',322,'5/14/2011',NULL,'Andrews','M-Male','5/24/1992',18,NULL,0,0,0,1,0,0,0,NULL,'SC',34.16400146,-82.38999939,'Clerk',NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,1,1,'1-3 per day',0,NULL,1,'4/21/2011',1,0,NULL,103.0999985,15,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('dceddc6f-040a-48ec-a93b-2192c49d8711',235,'5/10/2011',NULL,'Ruiz','F-Female','11/14/1958',52,NULL,0,1,0,0,0,0,0,NULL,'NC',35.57300186,-82.60900116,'Food service worker',NULL,NULL,1,'5/3/2011',NULL,1,1,0,0,1,1,1,1,1,1,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,103.8000031,16,0,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('dd0643bd-d05f-4a0a-84af-e9bcdfc703e2',355,'5/17/2011',NULL,'Harper','F-Female','11/20/1980',30,NULL,1,0,0,0,0,0,0,NULL,'NC',35.57300186,-82.60900116,NULL,NULL,NULL,1,'5/10/2011',NULL,1,1,1,0,1,0,1,1,1,0,'4-6 per day',1,'4/16/2011',1,'4/17/2011',1,0,NULL,103.6999969,15,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('dd9b8fcb-f305-4880-89be-199daa0b1ffa',172,'5/15/2011',NULL,'Fox','F-Female','5/5/1985',26,NULL,0,0,0,1,0,0,0,NULL,'NC',35.57300186,-82.60900116,'Accountant',NULL,NULL,1,'5/8/2011',NULL,1,1,1,1,1,1,1,1,1,1,'10+ per day',1,'4/29/2011',1,'4/29/2011',1,0,NULL,NULL,17,0,1,0,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('dec8a876-c2d4-4cd8-a687-8fba1fbc4194',230,'5/9/2011',NULL,'Riley','M-Male','6/8/1983',27,NULL,1,0,0,0,0,0,0,NULL,'NC',35.58399963,-82.59300232,'Food service worker',NULL,NULL,1,'5/2/2011',NULL,1,1,0,1,1,1,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,101.8000031,17,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('df7e7c95-99a5-4657-ac1e-427a98253bfa',112,'5/16/2011',NULL,'Armstrong','M-Male','6/5/1962',48,NULL,0,0,0,0,1,0,0,NULL,'NC',35.58000183,-82.61799622,'Writer',NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,1,1,0,1,1,1,'4-6 per day',1,'5/3/2011',1,'5/3/2011',0,0,NULL,101.0999985,18,0,1,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,1,1,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('dfee2e90-9160-49ad-9c6b-c84ea698baae',206,'5/8/2011',NULL,'Carpenter','F-Female','7/24/1998',12,NULL,0,0,1,0,0,0,0,NULL,'NC',35.56600189,-82.64900208,'Student',NULL,NULL,1,'5/1/2011',NULL,1,1,1,0,1,1,1,0,1,0,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,102.3000031,14,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('dff30ebf-c25c-48f9-ac30-e90ddfd67de2',326,'5/14/2011',NULL,'Weaver','M-Male','5/3/1985',26,NULL,0,0,0,1,0,0,0,NULL,'NC',35.60300064,-82.58399963,NULL,NULL,NULL,1,'5/7/2011',NULL,0,1,1,1,1,0,1,1,1,1,'1-3 per day',1,'4/16/2011',0,NULL,0,0,NULL,101.8000031,15,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('dffca30c-768e-47bc-9e43-93131839a41f',44,'5/12/2011',NULL,'Greene','F-Female','10/24/1985',25,NULL,1,0,0,0,0,0,0,NULL,'NC',35.58599854,-82.57499695,'Soldier',NULL,NULL,0,'5/5/2011',NULL,1,1,1,1,1,1,1,0,1,0,'1-3 per day',0,NULL,0,NULL,0,0,NULL,101.1999969,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e078868c-b488-4c87-a759-c497d4522b51',252,'5/11/2011',NULL,'Lawrence','M-Male','5/5/1968',43,NULL,0,0,0,1,0,0,0,NULL,'NC',35.58000183,-82.57900238,'Doctor',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,0,1,1,1,1,1,'7-10 per day',1,'4/21/2011',NULL,NULL,NULL,0,NULL,100.5,16,1,0,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e198d25e-7efa-4710-b43f-6324d1231991',232,'5/9/2011',NULL,'Elliot','M-Male','9/19/1997',13,NULL,0,1,0,0,0,0,0,NULL,'NC',35.57300186,-82.5719986,'Student',NULL,NULL,1,'5/2/2011',NULL,1,1,1,1,0,1,1,1,1,1,'10+ per day',NULL,NULL,NULL,NULL,NULL,0,NULL,100.6999969,14,0,1,0,0,1,1,0,0,0,0,1,1,0,1,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e240c63f-c090-4249-a4de-ec817a7ed1f0',164,'5/7/2011',NULL,'Chavez','F-Female','10/12/1976',34,NULL,0,0,1,0,0,0,0,NULL,'NC',35.5929985,-82.54299927,'Government',NULL,NULL,1,'4/30/2011',NULL,0,1,1,1,1,1,0,0,1,0,'7-10 per day',1,'4/15/2011',1,'4/15/2011',1,0,NULL,101.3000031,15,1,0,0,0,1,0,1,1,1,0,1,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('e3583711-7570-4eaa-9f54-ec4e8ebc79ce',150,'5/9/2011',NULL,'Sims','M-Male','4/4/1964',47,NULL,0,0,1,0,0,0,0,NULL,'NC',35.58800125,-82.53199768,'Farmer',NULL,NULL,1,'5/2/2011',NULL,1,1,1,1,1,0,0,1,1,1,'1-3 per day',1,'5/17/2011',1,'5/19/2011',0,0,NULL,NULL,20,0,0,0,0,1,0,1,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('eb6ea904-5126-44fc-90f4-dc2add348224',114,'5/12/2011',NULL,'Oliver','M-Male','3/1/1961',50,NULL,0,0,0,0,0,0,1,NULL,'NC',35.62099838,-82.55799866,'Teacher',NULL,NULL,0,'5/5/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,1,0,0,0,0,0,0,1,0,0,1,1,0,0,0,0,1,1,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ed2891ee-0585-4b08-8352-af417c2e49ca',333,'5/14/2011',NULL,'Montgomery','F-Female','1/1/1978',33,NULL,0,0,0,0,1,0,0,NULL,'NC',35.62099838,-82.60500336,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,1,1,1,1,1,0,1,1,'1-3 per day',1,'4/16/2011',0,NULL,0,0,NULL,103.0999985,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('eda72eda-1738-4dfe-8297-670036eaa825',157,'5/15/2011',NULL,'Richards','F-Female','1/5/1987',24,NULL,0,0,1,0,0,0,0,NULL,'TN',35.63199997,-82.57299805,'Clerk',NULL,NULL,1,'5/8/2011',NULL,0,1,1,1,0,0,0,0,1,0,'1-3 per day',1,'4/18/2011',1,'4/19/2011',0,0,NULL,NULL,15,0,0,0,0,1,0,1,1,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ee3afb42-a890-4193-8c7c-2c89564e0d2b',42,'5/16/2011',NULL,'Williamson','F-Female','12/31/1978',32,NULL,0,0,0,0,0,1,0,NULL,'TN',35.49499893,-86.09700012,'Researcher',NULL,NULL,0,'5/9/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ee587415-6856-46be-b1d2-93b0bc646858',339,'5/15/2011',NULL,'Grant','F-Female','3/20/1968',43,NULL,0,0,0,0,0,1,0,NULL,'TN',35.48099899,-86.11499786,NULL,NULL,NULL,1,'5/8/2011',NULL,1,1,1,1,1,1,1,1,1,1,'7-10 per day',0,NULL,1,'4/18/2011',1,0,NULL,104.0999985,16,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('eef662c7-8f49-4e02-a235-f9285bda29e3',11,'5/9/2011',NULL,'Knight','F-Female','11/28/1998',12,NULL,1,0,0,0,0,0,0,NULL,'TN',35.47800064,-86.13899994,'Student',NULL,NULL,1,'5/2/2011',NULL,1,1,0,1,0,0,0,1,0,0,'1-3 per day',1,NULL,0,NULL,0,0,NULL,102.0999985,14,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ef9b2705-521d-4d1e-a42e-7b0653f9c5ef',7,'5/8/2011',NULL,'Ferguson','F-Female','8/15/1959',51,NULL,0,0,0,0,0,0,1,NULL,'TN',35.45100021,-86.09100342,'Government',NULL,NULL,1,'5/1/2011',NULL,1,1,0,1,1,0,1,1,1,1,'7-10 per day',1,'4/11/2011',1,'4/13/2011',0,0,NULL,102.9000015,14,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('efd8c979-2ee7-4f0d-900b-e8104d228129',292,'5/13/2011',NULL,'Rose','F-Female','3/18/1964',47,NULL,1,0,0,0,0,0,0,NULL,'TN',35.45299911,-86.07099915,'Sales',NULL,NULL,1,'5/6/2011',NULL,1,1,1,1,0,0,1,0,1,1,'7-10 per day',1,NULL,1,NULL,1,0,NULL,NULL,17,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f0b87048-e216-4293-96e6-08ca44235c10',23,'5/6/2011',NULL,'Stone','M-Male','9/23/1953',57,NULL,0,0,0,1,0,0,0,NULL,'TN',35.47399902,-86.05000305,'Clerk',NULL,NULL,0,'4/29/2011',NULL,1,1,0,1,0,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,15,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f1a5fb1f-32e1-4cd0-9202-603dba51f770',344,'5/6/2011',NULL,'Hawkins','M-Male','7/20/1955',55,NULL,0,0,0,0,0,0,1,NULL,'TN',35.47399902,-86.05000305,NULL,NULL,NULL,1,'4/29/2011',NULL,1,1,1,0,0,1,0,1,1,1,'1-3 per day',1,NULL,0,NULL,1,0,NULL,NULL,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f2665c54-abbc-4b6b-8f2f-943999d562c4',89,'5/5/2011',NULL,'Dunn','M-Male','1/25/1969',42,NULL,0,0,0,0,0,0,1,NULL,'TN',35.49399948,-86.04299927,'Scientist',NULL,NULL,1,'4/28/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,101,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f29fcdd6-cf59-4aac-9c86-6b4358c46daa',143,'5/11/2011',NULL,'Perkins','M-Male','1/21/1961',50,NULL,0,0,1,0,0,0,0,NULL,'TN',35.51300049,-86.03199768,'Food service worker',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,0,0,0,0,0,0,'1-3 per day',0,NULL,0,NULL,0,0,NULL,NULL,20,1,0,0,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f2b7f274-44d5-405d-982f-e93a21f0d583',352,'5/16/2011',NULL,'Hudson','M-Male','1/1/1979',32,NULL,1,0,0,0,0,0,0,NULL,'TN',35.5379982,-86.0719986,NULL,NULL,NULL,1,'5/9/2011',NULL,1,1,1,1,0,1,1,1,0,0,'4-6 per day',0,NULL,0,NULL,0,0,NULL,NULL,15,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f456752a-ed07-40d1-82e5-5b9bcb5b4de6',21,'5/1/2011',NULL,'Palmer','F-Female','12/20/1981',29,NULL,0,1,0,0,0,0,0,NULL,'TN',35.5379982,-86.0719986,'Service worker',NULL,NULL,0,'4/24/2011',NULL,1,1,1,1,0,0,1,1,1,0,'4-6 per day',1,'4/24/2011',0,NULL,0,0,NULL,103.4000015,16,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f49dcf7c-0621-43ee-b62c-8437064216ec',14,'5/7/2011',NULL,'Palmer','F-Female','1/1/1985',26,NULL,0,0,0,1,0,0,0,NULL,'TN',35.53499985,-86.02899933,'Manager',NULL,NULL,1,'4/30/2011',NULL,1,1,1,0,1,0,1,0,0,1,'1-3 per day',1,'4/7/2011',1,'4/7/2011',1,0,NULL,103.0999985,14,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f551b0ca-5670-4b24-b175-5026ae3b1c45',49,'5/17/2011',NULL,'Palmer','M-Male','12/29/1957',53,NULL,0,0,0,1,0,0,0,NULL,'TN',35.44100189,-85.96800232,'Security guard',NULL,NULL,0,'5/9/2011',NULL,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f5c8361e-ec3d-4948-8de1-797fc324b706',72,'5/7/2011',NULL,'Mills','F-Female','2/18/1958',53,NULL,0,0,1,0,0,0,0,NULL,'TN',35.42300034,-86.14700317,'Software developer',NULL,NULL,0,'4/30/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f5e70692-61d2-40f6-b4cf-d248d489389f',195,'5/20/2011',NULL,'Mills','M-Male','9/15/1951',59,NULL,0,0,0,0,0,1,0,NULL,'TN',35.37900162,-86.18800354,'Service worker',NULL,NULL,1,'5/13/2011',NULL,1,1,1,1,1,1,0,0,1,1,'10+ per day',1,'4/9/2011',1,'4/9/2011',1,0,NULL,100.3000031,14,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f6fd9ae5-5fef-4035-848f-e44c1a6bdb76',253,'5/11/2011',NULL,'Nichols','M-Male','5/21/1979',31,NULL,0,0,0,1,0,0,0,NULL,'TN',35.55199814,-85.85800171,'Service worker',NULL,NULL,1,'5/4/2011',NULL,1,1,1,1,0,1,1,0,1,1,'7-10 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,100.4000015,13,1,1,1,0,1,1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f710229a-f882-4504-8c71-93cf0a695a2b',334,'5/14/2011',NULL,'Nichols','F-Female','1/1/1992',19,NULL,0,0,0,0,1,0,0,NULL,'TN',35.59999847,-85.98000336,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,0,1,1,1,1,1,1,1,'4-6 per day',0,NULL,1,'4/30/2011',0,0,NULL,104.6999969,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f80f9cee-1d04-487c-93d9-a64b0823ccd9',75,'5/10/2011',NULL,'Nichols','F-Female','2/10/1963',48,NULL,0,0,0,0,0,1,0,NULL,'TN',35.59600067,-86.15000153,'Architect',NULL,NULL,0,'5/3/2011',NULL,1,1,1,0,0,0,0,0,0,0,NULL,1,'5/5/2011',1,'5/5/2011',1,0,NULL,103.4000015,18,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f8ea9adf-f5ea-4d44-b48f-a97ae4690a31',6,'5/11/2011',NULL,'Banks','M-Male','6/1/1923',87,NULL,0,0,0,0,0,1,0,NULL,'AL',33.63100052,-85.79699707,NULL,NULL,NULL,1,'5/4/2011',NULL,1,1,0,0,1,0,1,1,1,1,'7-10 per day',1,'4/7/2011',0,NULL,0,1,'4/11/2011',103.4000015,14,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f99dc9bd-aded-4906-aa43-a737a1480f28',145,'5/10/2011',NULL,'Meyer','F-Female','12/12/1967',43,NULL,0,0,0,0,1,0,0,NULL,'AL',33.63700104,-85.77700043,'Business executive',NULL,NULL,1,'5/3/2011',NULL,1,1,1,1,1,1,1,1,1,1,'4-6 per day',1,'5/16/2011',1,'5/16/2011',0,0,NULL,NULL,20,0,0,0,0,1,0,0,0,1,0,0,1,0,1,1,1,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('f9c229c8-c362-457f-9a91-6a3966c3f7ef',301,'5/13/2011',NULL,'Bishop','M-Male','1/1/1981',30,NULL,0,1,0,0,0,0,0,NULL,'AL',33.65000153,-85.82299805,NULL,NULL,NULL,1,'5/6/2011',NULL,1,1,0,1,0,0,1,1,1,1,'1-3 per day',1,'4/16/2011',0,NULL,0,0,NULL,102.1999969,15,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('fa55139a-bc7b-4a76-9e40-be1f76795705',211,'5/6/2011',NULL,'McCoy','F-Female','4/5/1968',43,NULL,1,0,0,0,0,0,0,NULL,'AL',33.66400146,-85.84300232,'Service worker',NULL,NULL,1,'4/29/2011',NULL,1,1,1,1,1,1,1,0,1,0,'7-10 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,100.9000015,15,0,0,0,0,1,1,0,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('fa5b36f1-eb54-47ac-8231-4f437eaede05',190,'5/16/2011',NULL,'Howell','M-Male','11/4/1976',34,NULL,1,0,0,0,0,0,0,NULL,'AL',33.66600037,-85.82499695,'Journalist',NULL,NULL,1,'5/9/2011',NULL,0,1,1,1,0,1,0,0,0,0,'1-3 per day',0,NULL,1,'4/30/2011',0,0,NULL,104.0999985,17,0,0,1,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('fa9806f8-7c63-4463-8f5c-9f74cbe5d63b',264,'5/12/2011',NULL,'Alvarez','F-Female','4/13/1969',42,NULL,0,0,0,0,1,0,0,NULL,'AL',33.66600037,-85.82499695,'Service worker',NULL,NULL,1,'5/5/2011',NULL,1,1,1,0,0,1,1,1,1,0,NULL,1,'4/17/2011',1,'4/17/2011',1,0,NULL,NULL,15,0,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('fad70faa-857b-4c28-afab-f54924a9015b',27,'5/17/2011',NULL,'Morrison','F-Female','5/2/1964',47,NULL,0,1,0,0,0,0,0,NULL,'AL',33.61700058,-85.83899689,'Construction worker',NULL,NULL,0,'5/10/2011',NULL,1,1,0,1,1,0,1,1,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,18,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('fbbf2deb-7296-43df-8c02-058608d54c3b',302,'5/13/2011',NULL,'Hansen','M-Male','1/1/1978',33,NULL,0,1,0,0,0,0,0,NULL,'FL',30.68899918,-81.9260025,NULL,NULL,NULL,1,'5/6/2011',NULL,1,1,0,1,1,0,1,1,1,1,'1-3 per day',0,NULL,0,NULL,1,0,NULL,102.8000031,17,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,0,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('fbdb11e5-5534-4db0-9ab6-5b68c9ba2a19',204,'5/31/2011',NULL,'Ferdandez','M-Male','12/17/1953',57,NULL,1,0,0,0,0,0,0,NULL,'FL',30.69400024,-81.91699982,'Manufacturing',NULL,NULL,1,'5/24/2011',NULL,1,1,0,1,1,1,1,0,1,0,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,100.8000031,17,0,0,0,0,1,1,1,0,1,1,1,1,0,1,0,0,1,1,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('fcfc87af-03aa-43c7-b9d1-4e5d931bd5f8',314,'5/14/2011',NULL,'Garza','M-Male','12/13/1958',52,NULL,0,0,1,0,0,0,0,NULL,'FL',30.6760006,-81.93599701,NULL,NULL,NULL,1,'5/7/2011',NULL,1,1,0,1,1,0,1,1,1,1,'1-3 per day',0,NULL,1,'4/16/2011',NULL,0,NULL,100.8000031,15,0,1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,NULL,1,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('fdb6aea3-57d2-486e-b51e-1043a6955772',95,'5/9/2011',NULL,'Harvey','M-Male','7/1/1930',80,NULL,0,0,0,1,0,0,0,NULL,NULL,NULL,NULL,NULL,NULL,NULL,1,'5/2/2011',NULL,1,1,1,1,1,0,1,1,1,1,'10+ per day',1,'5/4/2011',1,'5/5/2011',1,0,NULL,101.3000031,18,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,NULL,1,1,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('fde33ff2-d402-4089-8de7-eafbcc199511',19,'5/4/2011',NULL,'Little','M-Male','2/12/1995',16,NULL,1,0,0,0,0,0,0,NULL,NULL,NULL,NULL,'Student',NULL,NULL,0,'4/27/2011',NULL,1,1,1,0,1,0,1,0,0,1,'1-3 per day',1,'4/17/2011',0,NULL,0,0,NULL,102.4000015,15,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ff9ff40b-4349-4399-8796-ed879742f7f6',216,'4/28/2011',NULL,'Burton','F-Female','5/1/1982',28,NULL,0,0,0,0,0,1,0,NULL,NULL,NULL,NULL,'Manufacturing',NULL,NULL,1,'4/21/2011',NULL,1,1,1,1,1,0,1,1,0,0,'4-6 per day',NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,17,0,0,0,0,1,1,0,0,1,0,1,1,0,1,0,0,0,0,0,1,1,1,1,NULL,NULL,NULL,NULL,NULL,NULL)", @"insert into Sample_EColiFoodHistory values('ffc42307-15ea-4c1e-9bc3-7a6937fb0255',176,'5/12/2011',NULL,'Stanley','M-Male','7/4/1995',15,NULL,1,0,0,0,0,0,0,NULL,NULL,NULL,NULL,'Student',NULL,NULL,1,'5/5/2011',NULL,0,1,1,1,1,0,0,0,0,0,'4-6 per day',1,'4/15/2011',1,'4/15/2011',1,0,NULL,100,15,0,0,1,0,1,1,1,0,1,1,1,1,0,1,1,0,1,1,0,1,1,1,1,NULL,1,1,NULL,NULL,NULL)"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *databasePath = [[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoDatabase/EpiInfo.db"];
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
            [self dismissForm];
            return;
        }
        else
        {
            //                                    NSLog(@"Table created");
        }
        //Close the sqlite connection
        sqlite3_close(epiinfoDB);
    }
    else
    {
        NSLog(@"Failed to open/create database");
        return;
    }
    
    for (int i = 0; i < [arrayOfInsertStatements count]; i++)
    {
        NSString *insertStatement = [arrayOfInsertStatements objectAtIndex:i];
        
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
                NSLog(@"Failed to insert row into table: %s :::: %@", errMsg, insertStatement);
            }
            else
            {
                //                    NSLog(@"Row(s) inserted");
            }
            //Close the sqlite connection
            sqlite3_close(epiinfoDB);
        }
        else
        {
            NSLog(@"Failed to open database or insert record");
        }
    }
    NSLog(@"End of loop");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImageView *)backgroundImage
{
    return fadingColorView;
}

- (void)advancePagedots
{
    [pagedots advancePage];
}
- (void)retreatPagedots
{
    [pagedots retreatPage];
}
- (void)resetPagedots
{
    [pagedots resetToFirstPage];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
            
        case 1:
            [self dismissForm];
            break;
    }
}

@end
