//
//  GrowthPercentilesViewController.m
//  EpiInfo
//
//  Created by John Copeland on 6/19/14.
//

#import "GrowthPercentilesViewController.h"
#import "EpiInfoScrollView.h"

@interface GrowthPercentilesViewController ()
@property (weak, nonatomic) IBOutlet EpiInfoScrollView *epiInfoScrollView;
@end

@implementation GrowthPercentilesViewController

-(void)setEpiInfoScrollView:(EpiInfoScrollView *)epiInfoScrollView
{
    _epiInfoScrollView = epiInfoScrollView;
    self.epiInfoScrollView.minimumZoomScale = 1.0;
    self.epiInfoScrollView.maximumZoomScale = 2.0;
    self.epiInfoScrollView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return zoomingView;
}

- (void)doubleTapAction
{
    if (self.epiInfoScrollView.zoomScale < 2.0)
        [self.epiInfoScrollView setZoomScale:2.0 animated:YES];
    else
        [self.epiInfoScrollView setZoomScale:1.0 animated:YES];
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
    // Create the GrowthPercentilesCompute object
    gpc = [[GrowthPercentilesCompute alloc] init];
    // Scroll View added in the storyboard. Not needed for this calulator.
    scrollViewFrame = CGRectMake(0, 43, 768,960);
    [self.epiInfoScrollView0 setScrollEnabled:NO];
    
    self.epiInfoScrollView.contentSize = CGSizeMake(320, self.view.frame.size.height - 80.0);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStylePlain target: nil action: nil];
    [self.navigationItem setBackBarButtonItem: backButton];
    
    // Set the title on the NavigationController
    self.title = @"";
    // Deprecation replacement
    CGRect frame = CGRectMake(0, 0, [self.title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0]}].width, 44);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    self.navigationItem.titleView = label;
    label.text = self.title;
    
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
        
        UIBarButtonItem *backToMainMenu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(popCurrentViewController)];
        [backToMainMenu setAccessibilityLabel:@"Close"];
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        fadingColorView = [[UIImageView alloc] initWithFrame:self.view.frame];
        [fadingColorView setImage:[UIImage imageNamed:@"iPadBackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        // Checking version of user's OS
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        {
            [self.epiInfoScrollView0 setFrame:CGRectMake(scrollViewFrame.origin.x, scrollViewFrame.origin.y, scrollViewFrame.size.width, scrollViewFrame.size.height + 500)];
        }
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 4, self.view.frame.size.width - 20.0, 70)];
        [headerView setClipsToBounds:YES];
        [headerView.layer setCornerRadius:10.0];
        [headerView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.view addSubview:headerView];
        
        UILabel *headerLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, headerView.frame.size.width, 40)];
        [headerLabel0 setBackgroundColor:[UIColor clearColor]];
        [headerLabel0 setTextColor:[UIColor whiteColor]];
        [headerLabel0 setTextAlignment:NSTextAlignmentCenter];
        [headerLabel0 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]];
        [headerLabel0 setText:@"Growth Percentiles"];
        [headerLabel0 setAccessibilityTraits:UIAccessibilityTraitHeader];
        [headerView addSubview:headerLabel0];
        
        UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, headerView.frame.size.width, 40)];
        [headerLabel1 setBackgroundColor:[UIColor clearColor]];
        [headerLabel1 setTextColor:[UIColor whiteColor]];
        [headerLabel1 setTextAlignment:NSTextAlignmentCenter];
        [headerLabel1 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0]];
        [headerLabel1 setText:@"For Children up to 240 Months"];
        [headerView addSubview:headerLabel1];
        
        maleFemaleView = [[UIView alloc] initWithFrame:CGRectMake(10, 88, self.view.frame.size.width - 20.0, 40)];
        [self.view addSubview:maleFemaleView];
        
        maleChecked = [[Checkbox alloc] initWithFrame:CGRectMake(38, 7, 30, 30)];
        [maleChecked setColumnName:@"MaleChecked"];
        [maleChecked setCheckboxAccessibilityLabel:@"Male Checked"];
        [maleFemaleView addSubview:maleChecked];
        [[maleChecked myButton] setTag:0];
        [[maleChecked myButton] addTarget:self action:@selector(maleOrFemalePressed:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(78, 15, 100, 14)];
        [maleLabel setBackgroundColor:[UIColor clearColor]];
        [maleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [maleLabel setTextAlignment:NSTextAlignmentLeft];
        [maleLabel setTextColor:[UIColor blackColor]];
        [maleLabel setText:@"Male"];
        [maleFemaleView addSubview:maleLabel];
        
        femaleChecked = [[Checkbox alloc] initWithFrame:CGRectMake(188, 7, 30, 30)];
        [femaleChecked setColumnName:@"FemaleChecked"];
        [femaleChecked setCheckboxAccessibilityLabel:@"Female Checked"];
        [maleFemaleView addSubview:femaleChecked];
        [[femaleChecked myButton] setTag:1];
        [[femaleChecked myButton] addTarget:self action:@selector(maleOrFemalePressed:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *femaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, 15, 100, 14)];
        [femaleLabel setBackgroundColor:[UIColor clearColor]];
        [femaleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [femaleLabel setTextAlignment:NSTextAlignmentLeft];
        [femaleLabel setTextColor:[UIColor blackColor]];
        [femaleLabel setText:@"Female"];
        [maleFemaleView addSubview:femaleLabel];
        
        ageView = [[UIView alloc] initWithFrame:CGRectMake(maleFemaleView.frame.size.width / 2.0 + 90, 0, maleFemaleView.frame.size.width / 2.0 - 180.0, 40)];
        [maleFemaleView addSubview:ageView];
        
        UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, 140, 22)];
        [ageLabel setBackgroundColor:[UIColor clearColor]];
        [ageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [ageLabel setTextAlignment:NSTextAlignmentLeft];
        [ageLabel setTextColor:[UIColor blackColor]];
        [ageLabel setText:@"Age in months"];
        [ageView addSubview:ageLabel];
        
        ageField = [[NumberField alloc] initWithFrame:CGRectMake(140, 0, 70, 40)];
        [ageField setBorderStyle:UITextBorderStyleRoundedRect];
        [ageField setDelegate:self];
        [ageField setReturnKeyType:UIReturnKeyDone];
        [ageField setColumnName:@"Age"];
        [ageField setAccessibilityLabel:@"Child's Age"];
        [ageField setNonNegative:YES];
        [ageField setHasMaximum:YES];
        [ageField setMaximum:240.0];
        [ageField addTarget:self action:@selector(doCompute) forControlEvents:UIControlEventEditingChanged];
        [ageView addSubview:ageField];
        
        lengthForAgeView = [[UIView alloc] initWithFrame:CGRectMake(30, 160, 300, 74)];
        [lengthForAgeView setClipsToBounds:YES];
        [lengthForAgeView.layer setCornerRadius:10.0];
        [lengthForAgeView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.view addSubview:lengthForAgeView];
        
        UILabel *lengthForAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 24)];
        [lengthForAgeLabel setBackgroundColor:[UIColor clearColor]];
        [lengthForAgeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [lengthForAgeLabel setTextAlignment:NSTextAlignmentCenter];
        [lengthForAgeLabel setTextColor:[UIColor whiteColor]];
        [lengthForAgeLabel setText:@"Length for Age"];
        [lengthForAgeView addSubview:lengthForAgeLabel];
        
        lengthField = [[NumberField alloc] initWithFrame:CGRectMake(2, 32, 80, 40)];
        [lengthField setBorderStyle:UITextBorderStyleRoundedRect];
        [lengthField.layer setCornerRadius:8.0];
        [lengthField setDelegate:self];
        [lengthField setReturnKeyType:UIReturnKeyDone];
        [lengthField setColumnName:@"Length"];
        [lengthField setAccessibilityLabel:@"Child's Length"];
        [lengthField setNonNegative:YES];
        [lengthField addTarget:self action:@selector(doCompute) forControlEvents:UIControlEventEditingChanged];
        [lengthForAgeView addSubview:lengthField];
        
        centimeters = NO;
        
        UIButton *lengthUnitsButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 32, 80, 40)];
        [lengthUnitsButton.layer setMasksToBounds:YES];
        [lengthUnitsButton.layer setCornerRadius:8.0];
        [lengthUnitsButton setTitle:@"Inches, press to change to centimeters" forState:UIControlStateNormal];
        [lengthUnitsButton setImage:[UIImage imageNamed:@"InchesButton.png"] forState:UIControlStateNormal];
        [lengthUnitsButton addTarget:self action:@selector(lengthUnitsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [lengthForAgeView addSubview:lengthUnitsButton];
        
        lengthForAgePercent = [[UILabel alloc] initWithFrame:CGRectMake(200, 32, 100, 40)];
        [lengthForAgePercent setBackgroundColor:[UIColor clearColor]];
        [lengthForAgePercent setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0]];
        [lengthForAgePercent setTextAlignment:NSTextAlignmentCenter];
        [lengthForAgePercent setTextColor:[UIColor whiteColor]];
        [lengthForAgePercent setText:@""];
        [lengthForAgeView addSubview:lengthForAgePercent];
        
        weightForAgeView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 330, 160, 300, 74)];
        [weightForAgeView setClipsToBounds:YES];
        [weightForAgeView.layer setCornerRadius:10.0];
        [weightForAgeView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.view addSubview:weightForAgeView];
        
        UILabel *weightForAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 24)];
        [weightForAgeLabel setBackgroundColor:[UIColor clearColor]];
        [weightForAgeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [weightForAgeLabel setTextAlignment:NSTextAlignmentCenter];
        [weightForAgeLabel setTextColor:[UIColor whiteColor]];
        [weightForAgeLabel setText:@"Weight for Age"];
        [weightForAgeView addSubview:weightForAgeLabel];
        
        weightField = [[NumberField alloc] initWithFrame:CGRectMake(2, 32, 80, 40)];
        [weightField setBorderStyle:UITextBorderStyleRoundedRect];
        [weightField.layer setCornerRadius:8.0];
        [weightField setDelegate:self];
        [weightField setReturnKeyType:UIReturnKeyDone];
        [weightField setColumnName:@"Weight"];
        [weightField setAccessibilityLabel:@"Child's Weight"];
        [weightField setNonNegative:YES];
        [weightField addTarget:self action:@selector(doCompute) forControlEvents:UIControlEventEditingChanged];
        [weightForAgeView addSubview:weightField];
        
        kilograms = NO;
        
        UIButton *weightUnitsButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 32, 80, 40)];
        [weightUnitsButton.layer setMasksToBounds:YES];
        [weightUnitsButton.layer setCornerRadius:8.0];
        [weightUnitsButton setTitle:@"Pounds, press to change to kilograms" forState:UIControlStateNormal];
        [weightUnitsButton setImage:[UIImage imageNamed:@"PoundsButton.png"] forState:UIControlStateNormal];
        [weightUnitsButton addTarget:self action:@selector(weightUnitsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [weightForAgeView addSubview:weightUnitsButton];
        
        weightForAgePercent = [[UILabel alloc] initWithFrame:CGRectMake(200, 32, 100, 40)];
        [weightForAgePercent setBackgroundColor:[UIColor clearColor]];
        [weightForAgePercent setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0]];
        [weightForAgePercent setTextAlignment:NSTextAlignmentCenter];
        [weightForAgePercent setTextColor:[UIColor whiteColor]];
        [weightForAgePercent setText:@""];
        [weightForAgeView addSubview:weightForAgePercent];
        
        circumferenceForAgeView = [[UIView alloc] initWithFrame:CGRectMake(30, 304, 300, 74)];
        [circumferenceForAgeView setClipsToBounds:YES];
        [circumferenceForAgeView.layer setCornerRadius:10.0];
        [circumferenceForAgeView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.view addSubview:circumferenceForAgeView];
        
        UILabel *circumferenceForAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 24)];
        [circumferenceForAgeLabel setBackgroundColor:[UIColor clearColor]];
        [circumferenceForAgeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [circumferenceForAgeLabel setTextAlignment:NSTextAlignmentCenter];
        [circumferenceForAgeLabel setTextColor:[UIColor whiteColor]];
        [circumferenceForAgeLabel setText:@"Head Circumference for Age"];
        [circumferenceForAgeView addSubview:circumferenceForAgeLabel];
        
        circumferenceField = [[NumberField alloc] initWithFrame:CGRectMake(2, 32, 80, 40)];
        [circumferenceField setBorderStyle:UITextBorderStyleRoundedRect];
        [circumferenceField.layer setCornerRadius:8.0];
        [circumferenceField setDelegate:self];
        [circumferenceField setReturnKeyType:UIReturnKeyDone];
        [circumferenceField setColumnName:@"Circumference"];
        [circumferenceField setAccessibilityLabel:@"Child's Head Circumference"];
        [circumferenceField setNonNegative:YES];
        [circumferenceField addTarget:self action:@selector(doCompute) forControlEvents:UIControlEventEditingChanged];
        [circumferenceForAgeView addSubview:circumferenceField];
        
        ccentimeters = NO;
        
        UIButton *circumferenceUnitsButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 32, 80, 40)];
        [circumferenceUnitsButton.layer setMasksToBounds:YES];
        [circumferenceUnitsButton.layer setCornerRadius:8.0];
        [circumferenceUnitsButton setTitle:@"Inches, press to change to centimeters" forState:UIControlStateNormal];
        [circumferenceUnitsButton setImage:[UIImage imageNamed:@"InchesButton.png"] forState:UIControlStateNormal];
        [circumferenceUnitsButton addTarget:self action:@selector(circumferenceUnitsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [circumferenceForAgeView addSubview:circumferenceUnitsButton];
        
        circumferenceForAgePercent = [[UILabel alloc] initWithFrame:CGRectMake(200, 32, 100, 40)];
        [circumferenceForAgePercent setBackgroundColor:[UIColor clearColor]];
        [circumferenceForAgePercent setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0]];
        [circumferenceForAgePercent setTextAlignment:NSTextAlignmentCenter];
        [circumferenceForAgePercent setTextColor:[UIColor whiteColor]];
        [circumferenceForAgePercent setText:@""];
        [circumferenceForAgeView addSubview:circumferenceForAgePercent];
    }
    else // Phone
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
        
        UIBarButtonItem *backToMainMenu = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(popCurrentViewController)];
        [backToMainMenu setAccessibilityLabel:@"Close"];
        [backToMainMenu setTintColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [backToMainMenu setTitle:@"Back to previous screen"];
        [self.navigationItem setRightBarButtonItem:backToMainMenu];
        
        // Set the background image
        fadingColorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [self.view frame].size.width, [self.view frame].size.height - self.navigationController.navigationBar.frame.size.height - [[UIApplication sharedApplication] statusBarFrame].size.height)];
        if (self.view.frame.size.height > 500)
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone5BackgroundWhite.png"]];
        else
            [fadingColorView setImage:[UIImage imageNamed:@"iPhone4BackgroundWhite.png"]];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
        
        //Set up the zoomingView
        zoomingView = [[ZoomView alloc] initWithFrame:CGRectMake(0, 0, self.epiInfoScrollView.frame.size.width, self.epiInfoScrollView.frame.size.height)];
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(10, 4, 300, 60)];
        [headerView setClipsToBounds:YES];
        [headerView.layer setCornerRadius:10.0];
        [headerView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.view addSubview:headerView];
        
        UILabel *headerLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
        [headerLabel0 setBackgroundColor:[UIColor clearColor]];
        [headerLabel0 setTextColor:[UIColor whiteColor]];
        [headerLabel0 setTextAlignment:NSTextAlignmentCenter];
        [headerLabel0 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [headerLabel0 setText:@"Growth Percentiles"];
        [headerLabel0 setAccessibilityTraits:UIAccessibilityTraitHeader];
        [headerView addSubview:headerLabel0];
        
        UILabel *headerLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, 300, 40)];
        [headerLabel1 setBackgroundColor:[UIColor clearColor]];
        [headerLabel1 setTextColor:[UIColor whiteColor]];
        [headerLabel1 setTextAlignment:NSTextAlignmentCenter];
        [headerLabel1 setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [headerLabel1 setText:@"For Children up to 240 Months"];
        [headerView addSubview:headerLabel1];
        
        maleFemaleView = [[UIView alloc] initWithFrame:CGRectMake(10, 68, 300, 30)];
        [self.view addSubview:maleFemaleView];
        
        maleChecked = [[Checkbox alloc] initWithFrame:CGRectMake(10, 0, 30, 30)];
        [maleChecked setColumnName:@"MaleChecked"];
        [maleChecked setCheckboxAccessibilityLabel:@"Male Checked"];
        [maleFemaleView addSubview:maleChecked];
        [[maleChecked myButton] setTag:0];
        [[maleChecked myButton] addTarget:self action:@selector(maleOrFemalePressed:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *maleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 8, 100, 14)];
        [maleLabel setBackgroundColor:[UIColor clearColor]];
        [maleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [maleLabel setTextAlignment:NSTextAlignmentLeft];
        [maleLabel setTextColor:[UIColor blackColor]];
        [maleLabel setText:@"Male"];
        [maleFemaleView addSubview:maleLabel];
        
        femaleChecked = [[Checkbox alloc] initWithFrame:CGRectMake(160, 0, 30, 30)];
        [femaleChecked setColumnName:@"FemaleChecked"];
        [femaleChecked setCheckboxAccessibilityLabel:@"Female Checked"];
        [maleFemaleView addSubview:femaleChecked];
        [[femaleChecked myButton] setTag:1];
        [[femaleChecked myButton] addTarget:self action:@selector(maleOrFemalePressed:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *femaleLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 8, 100, 14)];
        [femaleLabel setBackgroundColor:[UIColor clearColor]];
        [femaleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [femaleLabel setTextAlignment:NSTextAlignmentLeft];
        [femaleLabel setTextColor:[UIColor blackColor]];
        [femaleLabel setText:@"Female"];
        [maleFemaleView addSubview:femaleLabel];
        
        ageView = [[UIView alloc] initWithFrame:CGRectMake(20, 110, 280, 40)];
        [self.view addSubview:ageView];
        
        UILabel *ageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 11, 140, 18)];
        [ageLabel setBackgroundColor:[UIColor clearColor]];
        [ageLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [ageLabel setTextAlignment:NSTextAlignmentLeft];
        [ageLabel setTextColor:[UIColor blackColor]];
        [ageLabel setText:@"Age in months"];
        [ageView addSubview:ageLabel];
        
        ageField = [[NumberField alloc] initWithFrame:CGRectMake(140, 0, 70, 40)];
        [ageField setBorderStyle:UITextBorderStyleRoundedRect];
        [ageField setDelegate:self];
        [ageField setReturnKeyType:UIReturnKeyDone];
        [ageField setColumnName:@"Age"];
        [ageField setAccessibilityLabel:@"Child's Age"];
        [ageField setNonNegative:YES];
        [ageField setHasMaximum:YES];
        [ageField setMaximum:240.0];
        [ageField addTarget:self action:@selector(doCompute) forControlEvents:UIControlEventEditingChanged];
        [ageView addSubview:ageField];
        
        lengthForAgeView = [[UIView alloc] initWithFrame:CGRectMake(10, 160, 300, 64)];
        [lengthForAgeView setClipsToBounds:YES];
        [lengthForAgeView.layer setCornerRadius:10.0];
        [lengthForAgeView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.view addSubview:lengthForAgeView];
        
        UILabel *lengthForAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 18)];
        [lengthForAgeLabel setBackgroundColor:[UIColor clearColor]];
        [lengthForAgeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [lengthForAgeLabel setTextAlignment:NSTextAlignmentCenter];
        [lengthForAgeLabel setTextColor:[UIColor whiteColor]];
        [lengthForAgeLabel setText:@"Length for Age"];
        [lengthForAgeView addSubview:lengthForAgeLabel];
        
        lengthField = [[NumberField alloc] initWithFrame:CGRectMake(2, 22, 80, 40)];
        [lengthField setBorderStyle:UITextBorderStyleRoundedRect];
        [lengthField.layer setCornerRadius:8.0];
        [lengthField setDelegate:self];
        [lengthField setReturnKeyType:UIReturnKeyDone];
        [lengthField setColumnName:@"Length"];
        [lengthField setAccessibilityLabel:@"Child's Length"];
        [lengthField setNonNegative:YES];
        [lengthField addTarget:self action:@selector(doCompute) forControlEvents:UIControlEventEditingChanged];
        [lengthForAgeView addSubview:lengthField];
        
        centimeters = NO;
        
        UIButton *lengthUnitsButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 22, 80, 40)];
        [lengthUnitsButton.layer setMasksToBounds:YES];
        [lengthUnitsButton.layer setCornerRadius:8.0];
        [lengthUnitsButton setTitle:@"Inches, press to change to centimeters" forState:UIControlStateNormal];
        [lengthUnitsButton setImage:[UIImage imageNamed:@"InchesButton.png"] forState:UIControlStateNormal];
        [lengthUnitsButton addTarget:self action:@selector(lengthUnitsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [lengthForAgeView addSubview:lengthUnitsButton];
        
        lengthForAgePercent = [[UILabel alloc] initWithFrame:CGRectMake(200, 22, 100, 40)];
        [lengthForAgePercent setBackgroundColor:[UIColor clearColor]];
        [lengthForAgePercent setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0]];
        [lengthForAgePercent setTextAlignment:NSTextAlignmentCenter];
        [lengthForAgePercent setTextColor:[UIColor whiteColor]];
        [lengthForAgePercent setText:@""];
        [lengthForAgeView addSubview:lengthForAgePercent];
        
        weightForAgeView = [[UIView alloc] initWithFrame:CGRectMake(10, 232, 300, 64)];
        [weightForAgeView setClipsToBounds:YES];
        [weightForAgeView.layer setCornerRadius:10.0];
        [weightForAgeView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.view addSubview:weightForAgeView];
        
        UILabel *weightForAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 18)];
        [weightForAgeLabel setBackgroundColor:[UIColor clearColor]];
        [weightForAgeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [weightForAgeLabel setTextAlignment:NSTextAlignmentCenter];
        [weightForAgeLabel setTextColor:[UIColor whiteColor]];
        [weightForAgeLabel setText:@"Weight for Age"];
        [weightForAgeView addSubview:weightForAgeLabel];
        
        weightField = [[NumberField alloc] initWithFrame:CGRectMake(2, 22, 80, 40)];
        [weightField setBorderStyle:UITextBorderStyleRoundedRect];
        [weightField.layer setCornerRadius:8.0];
        [weightField setDelegate:self];
        [weightField setReturnKeyType:UIReturnKeyDone];
        [weightField setColumnName:@"Weight"];
        [weightField setAccessibilityLabel:@"Child's Weight"];
        [weightField setNonNegative:YES];
        [weightField addTarget:self action:@selector(doCompute) forControlEvents:UIControlEventEditingChanged];
        [weightForAgeView addSubview:weightField];
        
        kilograms = NO;
        
        UIButton *weightUnitsButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 22, 80, 40)];
        [weightUnitsButton.layer setMasksToBounds:YES];
        [weightUnitsButton.layer setCornerRadius:8.0];
        [weightUnitsButton setTitle:@"Pounds, press to change to kilograms" forState:UIControlStateNormal];
        [weightUnitsButton setImage:[UIImage imageNamed:@"PoundsButton.png"] forState:UIControlStateNormal];
        [weightUnitsButton addTarget:self action:@selector(weightUnitsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [weightForAgeView addSubview:weightUnitsButton];
        
        weightForAgePercent = [[UILabel alloc] initWithFrame:CGRectMake(200, 22, 100, 40)];
        [weightForAgePercent setBackgroundColor:[UIColor clearColor]];
        [weightForAgePercent setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0]];
        [weightForAgePercent setTextAlignment:NSTextAlignmentCenter];
        [weightForAgePercent setTextColor:[UIColor whiteColor]];
        [weightForAgePercent setText:@""];
        [weightForAgeView addSubview:weightForAgePercent];
        
        circumferenceForAgeView = [[UIView alloc] initWithFrame:CGRectMake(10, 304, 300, 64)];
        [circumferenceForAgeView setClipsToBounds:YES];
        [circumferenceForAgeView.layer setCornerRadius:10.0];
        [circumferenceForAgeView setBackgroundColor:[UIColor colorWithRed:29/255.0 green:96/255.0 blue:172/255.0 alpha:1.0]];
        [self.view addSubview:circumferenceForAgeView];
        
        UILabel *circumferenceForAgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, 300, 18)];
        [circumferenceForAgeLabel setBackgroundColor:[UIColor clearColor]];
        [circumferenceForAgeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [circumferenceForAgeLabel setTextAlignment:NSTextAlignmentCenter];
        [circumferenceForAgeLabel setTextColor:[UIColor whiteColor]];
        [circumferenceForAgeLabel setText:@"Head Circumference for Age"];
        [circumferenceForAgeView addSubview:circumferenceForAgeLabel];
        
        circumferenceField = [[NumberField alloc] initWithFrame:CGRectMake(2, 22, 80, 40)];
        [circumferenceField setBorderStyle:UITextBorderStyleRoundedRect];
        [circumferenceField.layer setCornerRadius:8.0];
        [circumferenceField setDelegate:self];
        [circumferenceField setReturnKeyType:UIReturnKeyDone];
        [circumferenceField setColumnName:@"Circumference"];
        [circumferenceField setAccessibilityLabel:@"Child's Head Circumference"];
        [circumferenceField setNonNegative:YES];
        [circumferenceField addTarget:self action:@selector(doCompute) forControlEvents:UIControlEventEditingChanged];
        [circumferenceForAgeView addSubview:circumferenceField];
        
        ccentimeters = NO;
        
        UIButton *circumferenceUnitsButton = [[UIButton alloc] initWithFrame:CGRectMake(110, 22, 80, 40)];
        [circumferenceUnitsButton.layer setMasksToBounds:YES];
        [circumferenceUnitsButton.layer setCornerRadius:8.0];
        [circumferenceUnitsButton setTitle:@"Inches, press to change to centimeters" forState:UIControlStateNormal];
        [circumferenceUnitsButton setImage:[UIImage imageNamed:@"InchesButton.png"] forState:UIControlStateNormal];
        [circumferenceUnitsButton addTarget:self action:@selector(circumferenceUnitsButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [circumferenceForAgeView addSubview:circumferenceUnitsButton];
        
        circumferenceForAgePercent = [[UILabel alloc] initWithFrame:CGRectMake(200, 22, 100, 40)];
        [circumferenceForAgePercent setBackgroundColor:[UIColor clearColor]];
        [circumferenceForAgePercent setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:24.0]];
        [circumferenceForAgePercent setTextAlignment:NSTextAlignmentCenter];
        [circumferenceForAgePercent setTextColor:[UIColor whiteColor]];
        [circumferenceForAgePercent setText:@""];
        [circumferenceForAgeView addSubview:circumferenceForAgePercent];
        
        //Add everything to the zoomingView
        for (UIView *view in self.view.subviews)
        {
            if (![view isKindOfClass:[UIScrollView class]])
            {
                [zoomingView addSubview:view];
                //Remove all struts and springs
                [view setAutoresizingMask:UIViewAutoresizingNone];
            }
        }
        [self.epiInfoScrollView addSubview:zoomingView];
        [self.epiInfoScrollView setShowsVerticalScrollIndicator:YES];
        [self.epiInfoScrollView setShowsHorizontalScrollIndicator:YES];
        
        [fadingColorView removeFromSuperview];
        [self.view addSubview:fadingColorView];
        [self.view sendSubviewToBack:fadingColorView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
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
//    [imageData writeToFile:@"/Users/zfj4/CodePlex/temp/GrowthPercentileScreenPad.png" atomically:YES];
//    To here
}

- (void)maleOrFemalePressed:(UIButton *)checkboxPressed
{
    if (checkboxPressed.tag == 0)
        [femaleChecked reset];
    else
        [maleChecked reset];
    
    [self doCompute];
}

- (void)lengthUnitsButtonPressed:(UIButton *)lengthUnitsButton
{
    if (centimeters)
    {
        centimeters = NO;
        [lengthUnitsButton setImage:[UIImage imageNamed:@"InchesButton.png"] forState:UIControlStateNormal];
        [lengthUnitsButton setTitle:@"Inches, press to change to centimeters" forState:UIControlStateNormal];
    }
    else
    {
        centimeters = YES;
        [lengthUnitsButton setImage:[UIImage imageNamed:@"CentimetersButton.png"] forState:UIControlStateNormal];
        [lengthUnitsButton setTitle:@"Centimeters, press to change to inches" forState:UIControlStateNormal];
    }
    [self doCompute];
}

- (void)weightUnitsButtonPressed:(UIButton *)weightUnitsButton
{
    if (kilograms)
    {
        kilograms = NO;
        [weightUnitsButton setImage:[UIImage imageNamed:@"PoundsButton.png"] forState:UIControlStateNormal];
        [weightUnitsButton setTitle:@"Pounds, press to change to kilograms" forState:UIControlStateNormal];
    }
    else
    {
        kilograms = YES;
        [weightUnitsButton setImage:[UIImage imageNamed:@"KilogramsButton.png"] forState:UIControlStateNormal];
        [weightUnitsButton setTitle:@"Kilograms, press to change to pounds" forState:UIControlStateNormal];
    }
    [self doCompute];
}

- (void)circumferenceUnitsButtonPressed:(UIButton *)circumferenceUnitsButton
{
    if (ccentimeters)
    {
        ccentimeters = NO;
        [circumferenceUnitsButton setImage:[UIImage imageNamed:@"InchesButton.png"] forState:UIControlStateNormal];
        [circumferenceUnitsButton setTitle:@"Inches, press to change to centimeters" forState:UIControlStateNormal];
    }
    else
    {
        ccentimeters = YES;
        [circumferenceUnitsButton setImage:[UIImage imageNamed:@"CentimetersButton.png"] forState:UIControlStateNormal];
        [circumferenceUnitsButton setTitle:@"Centimeters, press to change to inches" forState:UIControlStateNormal];
    }
    [self doCompute];
}

- (void)doCompute
{
    if (!maleChecked.value && !femaleChecked.value)
    {
        [lengthForAgePercent setText:@""];
        [weightForAgePercent setText:@""];
        [circumferenceForAgePercent setText:@""];
        return;
    }
    if ([ageField.text length] == 0)
    {
        [lengthForAgePercent setText:@""];
        [weightForAgePercent setText:@""];
        [circumferenceForAgePercent setText:@""];
        return;
    }
    
    if ([lengthField.text length] == 0)
        [lengthForAgePercent setText:@""];
    else
    {
        float centimeterValue = [lengthField.text floatValue] * 2.54;
        if (centimeters)
            centimeterValue = [lengthField.text floatValue];
        
        float percent = [gpc computePercentileOnLength:centimeterValue forAge:[ageField.text floatValue] inMonths:YES forMale:[maleChecked value]];
        [lengthForAgePercent setText:[NSString stringWithFormat:@"%.0f%%", percent]];
    }
    
    if ([weightField.text length] == 0)
        [weightForAgePercent setText:@""];
    else
    {
        float kilogramValue = [weightField.text floatValue] / 2.2;
        if (kilograms)
            kilogramValue = [weightField.text floatValue];
        
        float percent = [gpc computePercentileOnWeight:kilogramValue forAge:[ageField.text floatValue] inMonths:YES forMale:[maleChecked value]];
        [weightForAgePercent setText:[NSString stringWithFormat:@"%.0f%%", percent]];
    }
    
    if ([circumferenceField.text length] == 0 || [ageField.text floatValue] > 36.0)
        [circumferenceForAgePercent setText:@""];
    else
    {
        float centimeterValue = [circumferenceField.text floatValue] * 2.54;
        if (ccentimeters)
            centimeterValue = [circumferenceField.text floatValue];
        
        float percent = [gpc computePercentileOnCircumference:centimeterValue forAge:[ageField.text floatValue] inMonths:YES forMale:[maleChecked value]];
        [circumferenceForAgePercent setText:[NSString stringWithFormat:@"%.0f%%", percent]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.epiInfoScrollView setContentSize:CGSizeMake(self.epiInfoScrollView.contentSize.width, self.epiInfoScrollView.contentSize.height - 200.0)];
    } completion:^(BOOL finished){
        hasAFirstResponder = NO;
    }];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (hasAFirstResponder)
        return YES;
    
    [self.epiInfoScrollView setContentSize:CGSizeMake(self.epiInfoScrollView.contentSize.width, self.epiInfoScrollView.contentSize.height + 200.0)];
    hasAFirstResponder = YES;
    
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)popCurrentViewController
{
    //Method for the custom "Back" button on the NavigationController
    [self.navigationController popViewControllerAnimated:YES];
}
@end
