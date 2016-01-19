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
    
    [self setTitle:@"Epi Info Data Entry"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Change the standard NavigationController "Back" button to an "X"
        customBackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [customBackButton setImage:[UIImage imageNamed:@"StAndrewXButtonWhite.png"] forState:UIControlStateNormal];
        [customBackButton addTarget:self action:@selector(popCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
        [customBackButton.layer setMasksToBounds:YES];
        [customBackButton.layer setCornerRadius:8.0];
        [customBackButton setTitle:@"Back to previous screen" forState:UIControlStateNormal];
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customBackButton]];
        [self.navigationItem setHidesBackButton:YES animated:NO];
        
        fadingColorView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [fadingColorView setImage:[UIImage imageNamed:@"iPadBackground.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            NSLog(@"%@", [paths objectAtIndex:0]);
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 28)];
            [pickerLabel setTextColor:[UIColor whiteColor]];
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
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 20, 300, 180) AndListOfValues:[[NSMutableArray alloc] init] AndTextFieldToUpdate:lvSelected];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 187, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonOrange.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton addTarget:self action:@selector(openButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            [openButton setEnabled:NO];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 187, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Double tap to manage." forState:UIControlStateNormal];
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
            }
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 28)];
            [pickerLabel setTextColor:[UIColor whiteColor]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
            [pickerLabel setText:@"Choose form:"];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:pickerLabel];
            
            lvSelected = [[UITextField alloc] init];
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 20, 300, 180) AndListOfValues:pickerFiles AndTextFieldToUpdate:lvSelected];
            [lv.picker selectRow:selectedindex inComponent:0 animated:YES];
            [self.view addSubview:lv];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 187, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonOrange.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton addTarget:self action:@selector(openButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 187, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Double tap to manage." forState:UIControlStateNormal];
            [manageButton setImage:[UIImage imageNamed:@"ManageButtonOrange.png"] forState:UIControlStateNormal];
            [manageButton.layer setMasksToBounds:YES];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [manageButton.layer setBorderWidth:1.0];
            [manageButton addTarget:self action:@selector(manageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:customBackButton]];
        [self.navigationItem setHidesBackButton:YES animated:NO];

        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        if (self.view.frame.size.height > 500)
        {
            [fadingColorView setFrame:CGRectMake(0, 0, 320, 504)];
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5Background.png"]];
            [fadingColorView setTag:5];
        }
        else
        {
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4Background.png"]];
            [fadingColorView setTag:4];
        }
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (![[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            NSLog(@"%@", [paths objectAtIndex:0]);
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 28)];
            [pickerLabel setTextColor:[UIColor whiteColor]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
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
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 15, 300, 180) AndListOfValues:[[NSMutableArray alloc] init] AndTextFieldToUpdate:lvSelected];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 182, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonOrange.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton addTarget:self action:@selector(openButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 182, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Double tap to manage." forState:UIControlStateNormal];
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
            }
            pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 28)];
            [pickerLabel setTextColor:[UIColor whiteColor]];
            [pickerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
            [pickerLabel setText:@"Choose form:"];
            [pickerLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:pickerLabel];
            
            lvSelected = [[UITextField alloc] init];
            
            lv = [[LegalValues alloc] initWithFrame:CGRectMake(10, 15, 300, 180) AndListOfValues:pickerFiles AndTextFieldToUpdate:lvSelected];
            [lv.picker selectRow:selectedindex inComponent:0 animated:YES];
            [self.view addSubview:lv];
            
            openButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 182, 120, 40)];
            [openButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            [openButton.layer setCornerRadius:4.0];
            [openButton setTitle:@"Open" forState:UIControlStateNormal];
            [openButton setImage:[UIImage imageNamed:@"OpenButtonOrange.png"] forState:UIControlStateNormal];
            [openButton.layer setMasksToBounds:YES];
            [openButton.layer setCornerRadius:4.0];
            [openButton.layer setBorderColor:[[UIColor blackColor] CGColor]];
            [openButton.layer setBorderWidth:1.0];
            [openButton addTarget:self action:@selector(openButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:openButton];
            
            manageButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 182, 120, 40)];
            [manageButton setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
            [manageButton.layer setCornerRadius:4.0];
            [manageButton setTitle:@"Manage. Double tap to manage." forState:UIControlStateNormal];
            [manageButton setImage:[UIImage imageNamed:@"ManageButtonOrange.png"] forState:UIControlStateNormal];
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
    [confirmDeleteForm setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [confirmDeleteForm.layer setCornerRadius:4.0];
    [confirmDeleteForm setTitle:@"Yes" forState:UIControlStateNormal];
    [confirmDeleteForm setImage:[UIImage imageNamed:@"YesButtonOrange.png"] forState:UIControlStateNormal];
    [confirmDeleteForm.layer setMasksToBounds:YES];
    [confirmDeleteForm.layer setCornerRadius:4.0];
    [confirmDeleteForm.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [confirmDeleteForm.layer setBorderWidth:1.0];
    [confirmDeleteForm addTarget:self action:@selector(confirmDeleteFormPressed:) forControlEvents:UIControlEventTouchDownRepeat];
    [confirmDeleteForm setTag:lv.selectedIndex.integerValue];
    [manageView addSubview:confirmDeleteForm];
    
    UIButton *cancleDeleteForm = [[UIButton alloc] initWithFrame:CGRectMake(160, manageView.frame.size.height / 2.0, 120, 40)];
    [cancleDeleteForm setBackgroundColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
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

- (void)openButtonPressed
{
    if (lv.selectedIndex.intValue == 0)
        return;
    float viewWidth = self.view.frame.size.width;
    [[UIDevice currentDevice] playInputClick];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 0.5, 0.0, 1.0, 0.0);
        [self.view.layer setTransform:rotate];
    } completion:^(BOOL finished){
        CATransform3D rotate = CATransform3DIdentity;
        rotate.m34 = 1.0 / -2000;
        rotate = CATransform3DRotate(rotate, M_PI * 1.5, 0.0, 1.0, 0.0);
        [self.view.layer setTransform:rotate];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if ([[NSFileManager defaultManager] fileExistsAtPath:[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms"]])
        {
            [pickerLabel setHidden:YES];
            [lv setHidden:YES];
            [openButton setHidden:YES];
            [manageButton setHidden:YES];

            orangeBannerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
            [orangeBannerBackground setBackgroundColor:[UIColor colorWithRed:221/255.0 green:85/225.0 blue:12/225.0 alpha:1.0]];
            [self.view addSubview:orangeBannerBackground];
            
            NSString *path = [[[[paths objectAtIndex:0] stringByAppendingString:@"/EpiInfoForms/"] stringByAppendingString:lvSelected.text] stringByAppendingString:@".xml"];
            NSURL *url = [NSURL fileURLWithPath:path];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
                edv = [[EnterDataView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.view.frame.size.height) AndURL:url AndRootViewController:self AndNameOfTheForm:lvSelected.text];
                orangeBanner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 36)];
            }
            else
            {
                edv = [[EnterDataView alloc] initWithFrame:CGRectMake(0, 0, 320, 506) AndURL:url AndRootViewController:self AndNameOfTheForm:lvSelected.text];
                orangeBanner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
            }
            [self.view addSubview:edv];
            [self.view bringSubviewToFront:edv];
            
            [orangeBanner setBackgroundColor:[UIColor colorWithRed:221/255.0 green:85/225.0 blue:12/225.0 alpha:0.95]];
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
            [orangeBanner addSubview:xButton];
            
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
            [orangeBanner addSubview:uploadButton];
            
            UIButton *lineListButton = [[UIButton alloc] initWithFrame:CGRectMake(34, 2, 30, 30)];
            [lineListButton setBackgroundColor:[UIColor clearColor]];
            [lineListButton setImage:[UIImage imageNamed:@"LineList6060.png"] forState:UIControlStateNormal];
            [lineListButton setTitle:@"Show line listing" forState:UIControlStateNormal];
            [lineListButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
            [lineListButton setAlpha:0.5];
            [lineListButton.layer setMasksToBounds:YES];
            [lineListButton.layer setCornerRadius:8.0];
            [lineListButton addTarget:self action:@selector(lineListButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [orangeBanner addSubview:lineListButton];
            
            [header setText:[NSString stringWithFormat:@"%@", [edv formName]]];
            float fontSize = 32.0;
            while ([header.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]}].width > 180)
                fontSize -= 0.1;
            [header setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]];
            
        }
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [customBackButton setAlpha:0.0];
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
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [areYouSure setTextAlignment:NSTextAlignmentLeft];
    [areYouSure setLineBreakMode:NSLineBreakByWordWrapping];
    [areYouSure setNumberOfLines:0];
    [messageView addSubview:areYouSure];
    
    UIActivityIndicatorView *uiaiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(130, 80, 40, 40)];
    [uiaiv setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiaiv setHidden:YES];
    [messageView addSubview:uiaiv];
    
    UIButton *iTunesButton = [[UIButton alloc] initWithFrame:CGRectMake(1, openButton.frame.origin.y - openButton.frame.size.height, 298, 40)];
    [iTunesButton setImage:[UIImage imageNamed:@"PackageForiTunesButton.png"] forState:UIControlStateNormal];
    [iTunesButton setTitle:@"Package for I tunes upload." forState:UIControlStateNormal];
    [iTunesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [iTunesButton.layer setMasksToBounds:YES];
    [iTunesButton.layer setCornerRadius:4.0];
//    [iTunesButton addTarget:self action:@selector(packageDataForiTunes:) forControlEvents:UIControlEventTouchUpInside];
    [iTunesButton addTarget:self action:@selector(prePackageData:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:iTunesButton];
    
    UIButton *emailButton = [[UIButton alloc] initWithFrame:CGRectMake(1, openButton.frame.origin.y - openButton.frame.size.height + 42.0, 298, 40)];
    [emailButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
    [emailButton setTitle:@"Package and email" forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [emailButton.layer setMasksToBounds:YES];
    [emailButton.layer setCornerRadius:4.0];
//    [emailButton addTarget:self action:@selector(packageAndEmailData:) forControlEvents:UIControlEventTouchUpInside];
    [emailButton addTarget:self action:@selector(prePackageData:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:emailButton];
    
    //    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(1, openButton.frame.origin.y - openButton.frame.size.height + 84.0, 298, 40)];
    [yesButton setImage:[UIImage imageNamed:@"UploadDataToCloudButton.png"] forState:UIControlStateNormal];
    [yesButton setTitle:@"Upload to cloud" forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [yesButton.layer setMasksToBounds:YES];
    [yesButton.layer setCornerRadius:4.0];
    [yesButton addTarget:self action:@selector(uploadAllRecords:) forControlEvents:UIControlEventTouchUpInside];
    [messageView addSubview:yesButton];
    
    //    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(messageView.frame.size.width / 2.0 -  openButton.frame.size.width / 2.0, openButton.frame.origin.y + 88.0, openButton.frame.size.width, openButton.frame.size.height)];
    [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
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
            [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
        }
        else
        {
            [areYouSure setText:[NSString stringWithFormat:@"Local table contains no rows."]];
            [emailButton setEnabled:NO];
            [yesButton setEnabled:NO];
            [noButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
            return;
        }
    }
    else
    {
        [areYouSure setText:[NSString stringWithFormat:@"Local table does not yet exist for this form."]];
        [emailButton setEnabled:NO];
        [yesButton setEnabled:NO];
        [noButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
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
            [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
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
        [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
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
        [noButton setImage:[UIImage imageNamed:@"OKButton.png"] forState:UIControlStateNormal];
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

- (void)confirmDismissal
{
    // Create a confirmation view with frosted glass effect.
    // This requires capturing what was in view in an image, then blurring it and adding translucent white layer on top.
    
    // First, capture the screen
//    UIImageView *screenView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - self.navigationController.navigationBar.bounds.size.height + 40)];
//    UIGraphicsBeginImageContext(screenView.bounds.size);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *screen = UIGraphicsGetImageFromCurrentImageContext();
//    [screenView setImage:screen];
//    UIGraphicsEndImageContext();
    
    // Then blur the captured image.
//    CIImage *blurryScreen = [CIImage imageWithCGImage:[screen CGImage]];
//    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [gaussianBlurFilter setValue:blurryScreen forKey:@"inputImage"];
//    [gaussianBlurFilter setValue:[NSNumber numberWithFloat:5] forKey:@"inputRadius"];
//    CIImage *blurryResult = [gaussianBlurFilter valueForKey:@"outputImage"];
//    UIImage *endImage = [[UIImage alloc] initWithCIImage:blurryResult];

//    dismissView = [[UIView alloc] initWithFrame:CGRectMake(288, 2, 30, 30)];
    dismissView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    
    // Add the blurred image to an image view.
//    UIImageView *dismissImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [dismissImageView setImage:endImage];
//    [dismissView addSubview:dismissImageView];
//    BlurryView *dismissImageView = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    BlurryView *dismissImageView = [[BlurryView alloc] initWithFrame:CGRectMake(0, 0, dismissView.frame.size.width, dismissView.frame.size.height)];
    [dismissImageView setBackgroundColor:[UIColor grayColor]];
    [dismissImageView setAlpha:0.8];
    [dismissView addSubview:dismissImageView];
    
    // The translucent white view on top of the blurred image.
    BlurryView *windowView = [[BlurryView alloc] initWithFrame:dismissImageView.frame];
    [windowView setBackgroundColor:[UIColor grayColor]];
    [windowView setAlpha:0.6];
    [dismissView addSubview:windowView];
    
    // The smaller and less-transparent white view for the message and buttons.
//    UIView *messageView = [[UIView alloc] initWithFrame:dismissImageView.frame];
    UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, openButton.frame.origin.y + openButton.frame.size.height)];
    [messageView setBackgroundColor:[UIColor whiteColor]];
    [messageView setAlpha:0.7];
    [messageView.layer setCornerRadius:8.0];
    [dismissView addSubview:messageView];
    
//    UILabel *areYouSure = [[UILabel alloc] initWithFrame:dismissView.frame];
    UILabel *areYouSure = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 36)];
    [areYouSure setBackgroundColor:[UIColor clearColor]];
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [areYouSure setText:@"Dismiss Form?"];
    [areYouSure setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
    [areYouSure setTextAlignment:NSTextAlignmentCenter];
    [messageView addSubview:areYouSure];
    
//    UIButton *yesButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *yesButton = [[UIButton alloc] initWithFrame:openButton.frame];
    [yesButton setImage:[UIImage imageNamed:@"YesButton.png"] forState:UIControlStateNormal];
    [yesButton setTitle:@"Yes" forState:UIControlStateNormal];
    [yesButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [yesButton.layer setMasksToBounds:YES];
    [yesButton.layer setCornerRadius:4.0];
    [yesButton addTarget:self action:@selector(dismissForm) forControlEvents:UIControlEventTouchUpInside];
    [dismissView addSubview:yesButton];
    
//    UIButton *noButton = [[UIButton alloc] initWithFrame:dismissImageView.frame];
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(300 - openButton.frame.size.width, openButton.frame.origin.y, openButton.frame.size.width, openButton.frame.size.height)];
    [noButton setImage:[UIImage imageNamed:@"NoButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"No" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [noButton.layer setMasksToBounds:YES];
    [noButton.layer setCornerRadius:4.0];
    [noButton addTarget:self action:@selector(doNotDismiss) forControlEvents:UIControlEventTouchUpInside];
    [dismissView addSubview:noButton];
    
    [self.view addSubview:dismissView];
    [self.view bringSubviewToFront:dismissView];

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [dismissView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        [dismissImageView setFrame:CGRectMake(-20, -20, self.view.frame.size.width + 36, self.view.frame.size.height +36)];
//        [windowView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        [messageView setFrame:CGRectMake(10, 10, 300, openButton.frame.origin.y + openButton.frame.size.height)];
//        [areYouSure setFrame:CGRectMake(10, 10, 280, 36)];
//        [yesButton setFrame:openButton.frame];
//        [noButton setFrame:CGRectMake(300 - openButton.frame.size.width, openButton.frame.origin.y, openButton.frame.size.width, openButton.frame.size.height)];
    } completion:^(BOOL finished){
    }];
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
    [areYouSure setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
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
    [packageDataButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [packageDataButton.layer setMasksToBounds:YES];
    [packageDataButton.layer setCornerRadius:4.0];
    if ([sender.titleLabel.text isEqualToString:@"Package for I tunes upload."])
    {
        [packageDataButton setImage:[UIImage imageNamed:@"PackageForiTunesButton.png"] forState:UIControlStateNormal];
        [packageDataButton setTitle:@"Package for I tunes upload." forState:UIControlStateNormal];
        [packageDataButton addTarget:self action:@selector(packageDataForiTunes:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [packageDataButton setImage:[UIImage imageNamed:@"PackageAndEmailDataButton.png"] forState:UIControlStateNormal];
        [packageDataButton setTitle:@"Package and email" forState:UIControlStateNormal];
        [packageDataButton addTarget:self action:@selector(packageAndEmailData:) forControlEvents:UIControlEventTouchUpInside];
    }
    [messageView addSubview:packageDataButton];
    
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [noButton setImage:[UIImage imageNamed:@"CancelButton.png"] forState:UIControlStateNormal];
    [noButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [noButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
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
                        if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[edv.pagesArray objectAtIndex:0] objectAtIndex:0] lowercaseString]])
                        {
                            //                                xmlFileText = [[[xmlFileText stringByAppendingString:@"\n\t<Page PageId=\""] stringByAppendingString:[edv.pageIDs objectAtIndex:0]] stringByAppendingString:@"\">"];
                            [xmlFileText appendString:@"\n\t<Page PageId=\""];
                            [xmlFileText appendString:[edv.pageIDs objectAtIndex:0]];
                            [xmlFileText appendString:@"\">"];
                        }
                        for (int j = 1; j < edv.pagesArray.count; j++)
                        {
                            if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[edv.pagesArray objectAtIndex:j] objectAtIndex:0] lowercaseString]])
                            {
                                //                                    xmlFileText = [[[xmlFileText stringByAppendingString:@"\n\t</Page>\n\t<Page PageId=\""] stringByAppendingString:[edv.pageIDs objectAtIndex:j]] stringByAppendingString:@"\">"];
                                [xmlFileText appendString:@"\n\t</Page>\n\t<Page PageId=\""];
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
                            
                            NSNumber *testFloat = [NSNumber numberWithFloat:1.1];
                            NSString *testFloatString = [nsnf stringFromNumber:testFloat];
                            
                            if ([testFloatString characterAtIndex:1] == ',')
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
                            //                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
                            //                                                    stringByAppendingString:columnName]
                            //                                                   stringByAppendingString:@"\">"]
                            //                                                  stringByAppendingString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]]
                            //                                                 stringByAppendingString:@"</"]
                            //                                                stringByAppendingString:@"ResponseDetail"]
                            //                                               stringByAppendingString:@">"];
                            [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                            [xmlFileText appendString:columnName];
                            [xmlFileText appendString:@"\">"];
                            [xmlFileText appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
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

    xmlFileText = [[[xmlFileText stringByAppendingString:@"\n</"] stringByAppendingString:@"SurveyResponses"] stringByAppendingString:@">"];
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
    [uiavPackage setColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [uiavPackage startAnimating];
    [dismissView bringSubviewToFront:feedbackView];
    
    feedbackView.percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 280, 40)];
    [feedbackView.percentLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:24]];
    [feedbackView.percentLabel setTextColor:[UIColor colorWithRed:3/255.0 green:36/255.0 blue:77/255.0 alpha:1.0]];
    [feedbackView addSubview:feedbackView.percentLabel];
}
- (void)packageAndEmailData:(UIButton *)sender
{
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
                            if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[edv.pagesArray objectAtIndex:0] objectAtIndex:0] lowercaseString]])
                            {
//                                xmlFileText = [[[xmlFileText stringByAppendingString:@"\n\t<Page PageId=\""] stringByAppendingString:[edv.pageIDs objectAtIndex:0]] stringByAppendingString:@"\">"];
                                [xmlFileText appendString:@"\n\t<Page PageId=\""];
                                [xmlFileText appendString:[edv.pageIDs objectAtIndex:0]];
                                [xmlFileText appendString:@"\">"];
                            }
                            for (int j = 1; j < edv.pagesArray.count; j++)
                            {
                                if ([[columnName lowercaseString] isEqualToString:[[(NSMutableArray *)[edv.pagesArray objectAtIndex:j] objectAtIndex:0] lowercaseString]])
                                {
//                                    xmlFileText = [[[xmlFileText stringByAppendingString:@"\n\t</Page>\n\t<Page PageId=\""] stringByAppendingString:[edv.pageIDs objectAtIndex:j]] stringByAppendingString:@"\">"];
                                    [xmlFileText appendString:@"\n\t</Page>\n\t<Page PageId=\""];
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
                                
                                NSNumber *testFloat = [NSNumber numberWithFloat:1.1];
                                NSString *testFloatString = [nsnf stringFromNumber:testFloat];
                                
                                if ([testFloatString characterAtIndex:1] == ',')
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
//                                xmlFileText = [[[[[[[xmlFileText stringByAppendingString:@"\n\t\t<ResponseDetail QuestionName=\""]
//                                                    stringByAppendingString:columnName]
//                                                   stringByAppendingString:@"\">"]
//                                                  stringByAppendingString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]]
//                                                 stringByAppendingString:@"</"]
//                                                stringByAppendingString:@"ResponseDetail"]
//                                               stringByAppendingString:@">"];
                                [xmlFileText appendString:@"\n\t\t<ResponseDetail QuestionName=\""];
                                [xmlFileText appendString:columnName];
                                [xmlFileText appendString:@"\">"];
                                [xmlFileText appendString:[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)]];
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
        [orangeBannerBackground removeFromSuperview];
        [orangeBanner removeFromSuperview];
        orangeBanner = nil;
        
        for (UIView *v in [self.view subviews])
            if ([v isKindOfClass:[BlurryView class]])
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
    [edv populateFieldsWithRecord:tableNameAndGUID];
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

@end
