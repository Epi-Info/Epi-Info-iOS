//
//  TablesView.m
//  EpiInfo
//
//  Created by John Copeland on 7/10/13.
//

#import "TablesView.h"
#import "AnalysisViewController.h"
#import "Twox2Compute.h"
#import "Twox2StrataData.h"
#import "Twox2SummaryData.h"
#import "SharedResources.h"
#import "FEXACT.h"

@implementation TablesView
{
    AnalysisViewController *avc;
    
    UIActivityIndicatorView *spinner;
}

- (VariableValueMapper *)outcomeValueMapper
{
    return outcomeValueMapper;
}
- (VariableValueMapper *)exposureValueMapper
{
    return exposureValueMapper;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        epiInfoLightBlue = [UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            //Add the output view
            outputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [outputView setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:outputView];
            
            //Add the input view
            inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 204)];
            [inputView setBackgroundColor:epiInfoLightBlue];
            [inputView.layer setCornerRadius:10.0];
            
            //Add Outcome Variable button and picker
            chosenOutcomeVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 8, frame.size.width - 40, 44)];
            [chosenOutcomeVariable setBackgroundColor:epiInfoLightBlue];
            [chosenOutcomeVariable.layer setCornerRadius:10.0];
            [chosenOutcomeVariable setTitle:@"Select Outcome Variable" forState:UIControlStateNormal];
            [chosenOutcomeVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenOutcomeVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenOutcomeVariable addTarget:self action:@selector(chosenOutcomeVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenOutcomeVariable];
            chooseOutcomeVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseOutcomeVariable.layer setCornerRadius:10.0];
            [chooseOutcomeVariable setTag:0];
            selectedOutcomeVariableNumber = 0;
            outcomeVariableChosen = NO;
            [chooseOutcomeVariable setDelegate:self];
            [chooseOutcomeVariable setDataSource:self];
            [chooseOutcomeVariable setShowsSelectionIndicator:YES];
            [chooseOutcomeVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOutcomeVariableTapped:)]];
            
            //Add Exposure Variable button and picker
            chosenExposureVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 56, frame.size.width - 40, 44)];
            [chosenExposureVariable setBackgroundColor:epiInfoLightBlue];
            [chosenExposureVariable.layer setCornerRadius:10.0];
            [chosenExposureVariable setTitle:@"Select Exposure Variable" forState:UIControlStateNormal];
            [chosenExposureVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenExposureVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenExposureVariable addTarget:self action:@selector(chosenExposureVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenExposureVariable];
            chooseExposureVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseExposureVariable setTag:1];
            exposureVariableChosen = NO;
            selectedExposureVariableNumber = 0;
            [chooseExposureVariable setDelegate:self];
            [chooseExposureVariable setDataSource:self];
            [chooseExposureVariable setShowsSelectionIndicator:YES];
            [chooseExposureVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseExposureVariableTapped:)]];
            
            //Add Inclued Missing box and label
            includeMissing = NO;
            includeMissingButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 104, 22, 22)];
            [includeMissingButton.layer setCornerRadius:6];
            [includeMissingButton.layer setBorderColor:epiInfoLightBlue.CGColor];
            [includeMissingButton.layer setBorderWidth:2.0];
            [includeMissingButton addTarget:self action:@selector(includeMissingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [inputView addSubview:includeMissingButton];
            [inputView sendSubviewToBack:includeMissingButton];
            includeMissingLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(20, 104, frame.size.width / 2.0 - 22, 22)];
            [includeMissingLabel setTextAlignment:NSTextAlignmentLeft];
            [includeMissingLabel setTextColor:epiInfoLightBlue];
            [includeMissingLabel setText:@"Include missing"];
            [includeMissingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [inputView addSubview:includeMissingLabel];
            [inputView sendSubviewToBack:includeMissingLabel];
            
            //Add Stratification Variable button and picker
            chosenStratificationVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 135, frame.size.width - 40, 44)];
            [chosenStratificationVariable setBackgroundColor:epiInfoLightBlue];
            [chosenStratificationVariable.layer setCornerRadius:10.0];
            [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
            [chosenStratificationVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenStratificationVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenStratificationVariable addTarget:self action:@selector(chosenStratificationVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenStratificationVariable];
//            [inputView bringSubviewToFront:chooseOutcomeVariable];
//            [inputView bringSubviewToFront:chooseExposureVariable];
            chooseStratificationVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseStratificationVariable setTag:2];
            stratificationVariableChosen = NO;
            selectedStratificationVariableNumber = 0;
            [chooseStratificationVariable setDelegate:self];
            [chooseStratificationVariable setDataSource:self];
            [chooseStratificationVariable setShowsSelectionIndicator:YES];
            [chooseStratificationVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseStratificationVariableTapped:)]];
//            [inputView addSubview:chooseOutcomeVariable];
//            [inputView addSubview:chooseExposureVariable];
//            [inputView addSubview:chooseStratificationVariable];
            
            //Add the white box
            inputViewWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
            [inputViewWhiteBox setBackgroundColor:[UIColor whiteColor]];
            [inputViewWhiteBox.layer setCornerRadius:8.0];
            [inputView addSubview:inputViewWhiteBox];
            [inputView sendSubviewToBack:inputViewWhiteBox];
            [self addSubview:inputView];
            
            //Add title bar
            titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, -114, frame.size.width, 162)];
            [titleBar setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:titleBar];
            
            //Add the gadget title
            gadgetTitle = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
            [gadgetTitle setText:@"Tables (2x2, MxN)"];
            [gadgetTitle setTextColor:epiInfoLightBlue];
            [gadgetTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [titleBar addSubview:gadgetTitle];
            
            //Add the quit button
            xButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 44, 0, 44, 44)];
            [xButton setBackgroundColor:[UIColor whiteColor]];
            [xButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
            [xButton.layer setCornerRadius:10.0];
            [xButton.layer setBorderColor:epiInfoLightBlue.CGColor];
            [xButton.layer setBorderWidth:2.0];
            [xButton addTarget:self action:@selector(xButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [titleBar addSubview:xButton];
            
            //Add the gear button
            gearButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 88, 0, 44, 44)];
            [gearButton setBackgroundColor:[UIColor whiteColor]];
            [gearButton setImage:[UIImage imageNamed:@"gear-button.png"] forState:UIControlStateNormal];
            [gearButton.layer setCornerRadius:10.0];
            [gearButton.layer setBorderColor:epiInfoLightBlue.CGColor];
            [gearButton.layer setBorderWidth:2.0];
            [gearButton addTarget:self action:@selector(gearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [titleBar addSubview:gearButton];

            //Initialize the ActivityIndicator
            spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(titleBar.frame.size.width / 2.0 - 20, 0, 40, 40)];
            [spinner setHidden:YES];
            [spinner setColor:[UIColor blackColor]];
            [titleBar addSubview:spinner];

            inputViewDisplayed = YES;
            outputViewDisplayed = NO;
            twoByTwoDisplayed = NO;
            stratum = 0;
        }
        else
        {
            //Add the output view
            outputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [outputView setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:outputView];
            secondOutputViewForIPad = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [secondOutputViewForIPad setBackgroundColor:[UIColor clearColor]];
            [outputView addSubview:secondOutputViewForIPad];

            //Add the input view
            inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 204)];
            [inputView setBackgroundColor:epiInfoLightBlue];
            [inputView.layer setCornerRadius:10.0];
            
            //Add Outcome Variable button and picker
            chosenOutcomeVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 8, frame.size.width - 40, 44)];
            [chosenOutcomeVariable setBackgroundColor:epiInfoLightBlue];
            [chosenOutcomeVariable.layer setCornerRadius:10.0];
            [chosenOutcomeVariable setTitle:@"Select Outcome Variable" forState:UIControlStateNormal];
            [chosenOutcomeVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenOutcomeVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenOutcomeVariable addTarget:self action:@selector(chosenOutcomeVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenOutcomeVariable];
            chooseOutcomeVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseOutcomeVariable.layer setCornerRadius:10.0];
            [chooseOutcomeVariable setTag:0];
            selectedOutcomeVariableNumber = 0;
            outcomeVariableChosen = NO;
            [chooseOutcomeVariable setDelegate:self];
            [chooseOutcomeVariable setDataSource:self];
            [chooseOutcomeVariable setShowsSelectionIndicator:YES];
            [chooseOutcomeVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseOutcomeVariableTapped:)]];
            
            //Add Exposure Variable button and picker
            chosenExposureVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(306, 8, frame.size.width - 40, 44)];
            [chosenExposureVariable setBackgroundColor:epiInfoLightBlue];
            [chosenExposureVariable.layer setCornerRadius:10.0];
            [chosenExposureVariable setTitle:@"Select Exposure Variable" forState:UIControlStateNormal];
            [chosenExposureVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenExposureVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenExposureVariable addTarget:self action:@selector(chosenExposureVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenExposureVariable];
            chooseExposureVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseExposureVariable setTag:1];
            exposureVariableChosen = NO;
            selectedExposureVariableNumber = 0;
            [chooseExposureVariable setDelegate:self];
            [chooseExposureVariable setDataSource:self];
            [chooseExposureVariable setShowsSelectionIndicator:YES];
            [chooseExposureVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseExposureVariableTapped:)]];
            
            //Add Inclued Missing box and label
            includeMissing = NO;
            includeMissingButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 104, 22, 22)];
            [includeMissingButton.layer setCornerRadius:6];
            [includeMissingButton.layer setBorderColor:epiInfoLightBlue.CGColor];
            [includeMissingButton.layer setBorderWidth:2.0];
            [includeMissingButton addTarget:self action:@selector(includeMissingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [inputView addSubview:includeMissingButton];
            [inputView sendSubviewToBack:includeMissingButton];
            includeMissingLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(20, 104, frame.size.width / 2.0 - 22, 22)];
            [includeMissingLabel setTextAlignment:NSTextAlignmentLeft];
            [includeMissingLabel setTextColor:epiInfoLightBlue];
            [includeMissingLabel setText:@"Include missing"];
            [includeMissingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [inputView addSubview:includeMissingLabel];
            [inputView sendSubviewToBack:includeMissingLabel];
            
            //Add Stratification Variable button and picker
            chosenStratificationVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 135, frame.size.width - 40, 44)];
            [chosenStratificationVariable setBackgroundColor:epiInfoLightBlue];
            [chosenStratificationVariable.layer setCornerRadius:10.0];
            [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
            [chosenStratificationVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenStratificationVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenStratificationVariable addTarget:self action:@selector(chosenStratificationVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenStratificationVariable];
//            [inputView bringSubviewToFront:chooseOutcomeVariable];
//            [inputView bringSubviewToFront:chooseExposureVariable];
            chooseStratificationVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseStratificationVariable setTag:2];
            stratificationVariableChosen = NO;
            selectedStratificationVariableNumber = 0;
            [chooseStratificationVariable setDelegate:self];
            [chooseStratificationVariable setDataSource:self];
            [chooseStratificationVariable setShowsSelectionIndicator:YES];
            [chooseStratificationVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseStratificationVariableTapped:)]];
//            [inputView addSubview:chooseOutcomeVariable];
//            [inputView addSubview:chooseExposureVariable];
//            [inputView addSubview:chooseStratificationVariable];
            
            //Add the white box
            inputViewWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
            [inputViewWhiteBox setBackgroundColor:[UIColor whiteColor]];
            [inputViewWhiteBox.layer setCornerRadius:8.0];
            [inputView addSubview:inputViewWhiteBox];
            [inputView sendSubviewToBack:inputViewWhiteBox];
            [self addSubview:inputView];
            
            //Add title bar
            titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, -114, frame.size.width, 162)];
            [titleBar setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:titleBar];
            
            //Add the gadget title
            gadgetTitle = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
            [gadgetTitle setText:@"Tables (2x2, MxN)"];
            [gadgetTitle setTextColor:epiInfoLightBlue];
            [gadgetTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [titleBar addSubview:gadgetTitle];
            
            //Add the quit button
            xButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 44, 0, 44, 44)];
            [xButton setBackgroundColor:[UIColor whiteColor]];
            [xButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
            [xButton.layer setCornerRadius:10.0];
            [xButton.layer setBorderColor:epiInfoLightBlue.CGColor];
            [xButton.layer setBorderWidth:2.0];
            [xButton addTarget:self action:@selector(xButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [titleBar addSubview:xButton];
            
            //Add the gear button
            gearButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 88, 0, 44, 44)];
            [gearButton setBackgroundColor:[UIColor whiteColor]];
            [gearButton setImage:[UIImage imageNamed:@"gear-button.png"] forState:UIControlStateNormal];
            [gearButton.layer setCornerRadius:10.0];
            [gearButton.layer setBorderColor:epiInfoLightBlue.CGColor];
            [gearButton.layer setBorderWidth:2.0];
            [gearButton addTarget:self action:@selector(gearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [titleBar addSubview:gearButton];
            
            //Initialize the ActivityIndicator
            spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(titleBar.frame.size.width / 2.0 - 20, 0, 40, 40)];
            [spinner setHidden:YES];
            [spinner setColor:[UIColor blackColor]];
            [titleBar addSubview:spinner];
            
            inputViewDisplayed = YES;
            outputViewDisplayed = NO;
            twoByTwoDisplayed = NO;
            stratum = 0;
        }
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndDataSource:(AnalysisDataObject *)dataSource AndViewController:(UIViewController *)vc
{
    self = [self initWithFrame:frame];
    dataObject = dataSource;
    avc = (AnalysisViewController *)vc;
    return self;
}

- (id)initWithFrame:(CGRect)frame AndSQLiteData:(SQLiteData *)dataSource AndViewController:(UIViewController *)vc
{
    self = [self initWithFrame:frame];
    sqliteData = dataSource;
    outcomeVariableLabel = [[UILabel alloc] initWithFrame:chosenOutcomeVariable.frame];
    [outcomeVariableLabel setBackgroundColor:[UIColor whiteColor]];
    [outcomeVariableLabel setTextColor:epiInfoLightBlue];
    [outcomeVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [outcomeVariableLabel setText:@"Outcome Variable"];
    outcomeVariableString = [[UITextField alloc] init];
    exposureVariableLabel = [[UILabel alloc] initWithFrame:chosenExposureVariable.frame];
    [exposureVariableLabel setBackgroundColor:[UIColor whiteColor]];
    [exposureVariableLabel setTextColor:epiInfoLightBlue];
    [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [exposureVariableLabel setText:@"Exposure Variable(s)"];
    exposureVariableString = [[EpiInfoTextField alloc] init];
    stratificationVariableLabel = [[UILabel alloc] initWithFrame:chosenStratificationVariable.frame];
    [stratificationVariableLabel setBackgroundColor:[UIColor whiteColor]];
    [stratificationVariableLabel setTextColor:epiInfoLightBlue];
    [stratificationVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [stratificationVariableLabel setText:@"Stratification Variable"];
    stratificationVariableString = [[UITextField alloc] init];
    NSMutableArray *outcomeNSMA = [[NSMutableArray alloc] init];
    [outcomeNSMA addObject:@""];
    for (NSString *variable in sqliteData.columnNamesWorking)
    {
        [outcomeNSMA addObject:variable];
    }
    [outcomeNSMA sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    availableOutcomeVariables = [NSMutableArray arrayWithArray:outcomeNSMA];
    outcomeLVE = [[LegalValuesEnter alloc] initWithFrame:chosenOutcomeVariable.frame AndListOfValues:outcomeNSMA AndTextFieldToUpdate:outcomeVariableString];
    [outcomeLVE.picker selectRow:0 inComponent:0 animated:YES];
    [outcomeLVE analysisStyle];
    [outcomeLVE setTag:0x0F1514];
    [inputView addSubview:outcomeLVE];
    NSMutableArray *exposureNSMA = [NSMutableArray arrayWithArray:outcomeNSMA];
    NSArray *groupArray = [sqliteData groups];
    for (int groupindex = 0; groupindex < [groupArray count]; groupindex ++)
        [exposureNSMA addObject:[groupArray objectAtIndex:groupindex]];
    availableExposureVariables = [NSMutableArray arrayWithArray:exposureNSMA];
    exposureLVE = [[LegalValuesEnter alloc] initWithFrame:chosenExposureVariable.frame AndListOfValues:exposureNSMA AndTextFieldToUpdate:exposureVariableString];
    [exposureLVE setTag:0x051810];
    [exposureLVE.picker selectRow:0 inComponent:0 animated:YES];
    [exposureLVE analysisStyle];
    stratificationLVE = [[LegalValuesEnter alloc] initWithFrame:chosenStratificationVariable.frame AndListOfValues:outcomeNSMA AndTextFieldToUpdate:stratificationVariableString];
    [stratificationLVE.picker selectRow:0 inComponent:0 animated:YES];
    [stratificationLVE analysisStyle];
    [stratificationLVE setTag:1957];
    [inputView addSubview:exposureLVE];
    [inputView addSubview:stratificationLVE];
    [chosenOutcomeVariable setTitle:[outcomeVariableString text] forState:UIControlStateNormal];
    [inputView addSubview:outcomeVariableLabel];
    [inputView addSubview:exposureVariableLabel];
    [inputView addSubview:stratificationVariableLabel];
    mapOutcomeValuesButton = [[UIButton alloc] initWithFrame:CGRectMake(8.0, stratificationLVE.frame.origin.y + stratificationLVE.frame.size.height + 4.0, stratificationLVE.frame.size.width - 4.0, 40.0)];
    [mapOutcomeValuesButton setBackgroundColor:epiInfoLightBlue];
    [mapOutcomeValuesButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [mapOutcomeValuesButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1] forState:UIControlStateHighlighted];
    [mapOutcomeValuesButton setTitle:@"Map Outcome Variable Values" forState:UIControlStateNormal];
    [mapOutcomeValuesButton addTarget:self action:@selector(mapOutcomeValuesButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapOutcomeValuesButton setEnabled:NO];
    [mapOutcomeValuesButton setAlpha:0.4];
    [inputView addSubview:mapOutcomeValuesButton];
    mapExposureValuesButton = [[UIButton alloc] initWithFrame:CGRectMake(mapOutcomeValuesButton.frame.origin.x, mapOutcomeValuesButton.frame.origin.y + mapOutcomeValuesButton.frame.size.height + 2.0, mapOutcomeValuesButton.frame.size.width, 40.0)];
    [mapExposureValuesButton setBackgroundColor:epiInfoLightBlue];
    [mapExposureValuesButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [mapExposureValuesButton setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1] forState:UIControlStateHighlighted];
    [mapExposureValuesButton setTitle:@"Map Exposure Variable Values" forState:UIControlStateNormal];
    [mapExposureValuesButton addTarget:self action:@selector(mapExposureValuesButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [mapExposureValuesButton setEnabled:NO];
    [mapExposureValuesButton setAlpha:0.4];
    [inputView addSubview:mapExposureValuesButton];
    avc = (AnalysisViewController *)vc;
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 10.0 * frame.size.height)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (frame.size.width > 0.0 && frame.size.height > 0.0)
        {
            [titleBar setFrame:CGRectMake(0, -114, 317, 162)];
            [gadgetTitle setFrame:CGRectMake(2, 116, 316 - 96, 44)];
            [xButton setFrame:CGRectMake(316 - 46, 116, 44, 44)];
            [gearButton setFrame:CGRectMake(316 - 92, 116, 44, 44)];
            [outputView setFrame:CGRectMake(0, 46, frame.size.width, 10.0 * frame.size.height - 46)];
            if (inputViewDisplayed)
            {
                if ([avc portraitOrientation])
                {
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, [avc getZoomingViewFrame].size.height - 100)];
                    [chosenOutcomeVariable setFrame:CGRectMake(20, 8, 276, 44)];
                    [outcomeVariableLabel setFrame:CGRectMake(16, 8, 284, 20)];
                    [outcomeLVE setFrame:CGRectMake(10, 28, 300, 44)];
                    [chosenExposureVariable setFrame:CGRectMake(20, 56, 276, 44)];
                    [exposureVariableLabel setFrame:CGRectMake(16, 92, 284, 20)];
                    [exposureLVE setFrame:CGRectMake(10, 112, 300, 44)];
                    [includeMissingButton setFrame:CGRectMake(170, exposureLVE.frame.origin.y + exposureLVE.frame.size.height + 40, 22, 22)];
                    [includeMissingLabel setFrame:CGRectMake(20, includeMissingButton.frame.origin.y, 140, 22)];
                    [stratificationVariableLabel setFrame:CGRectMake(16, includeMissingLabel.frame.origin.y + includeMissingLabel.frame.size.height + 16, 284, 20)];
                    [stratificationLVE setFrame:CGRectMake(10, stratificationVariableLabel.frame.origin.y + stratificationVariableLabel.frame.size.height, 300, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 135, 276, 44)];
                    [chooseOutcomeVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseExposureVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseStratificationVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                    [spinner setFrame:CGRectMake(frame.size.width / 2.0 - 20, 118, 40, 40)];
                }
                else
                {
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, frame.size.height - 100)];
                    [chosenOutcomeVariable setFrame:CGRectMake(20, 8, (inputView.frame.size.width - 60) / 2.0, 44)];
                    [chosenExposureVariable setFrame:CGRectMake(inputView.frame.size.width / 2.0 + 10, 8, (inputView.frame.size.width - 60) / 2.0, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 87, 276, 44)];
                    [chooseOutcomeVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseExposureVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseStratificationVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                    [includeMissingLabel setFrame:CGRectMake(20, 56, 140, 22)];
                    [includeMissingButton setFrame:CGRectMake(170, 56, 22, 22)];
                }
                [avc resetContentSize];
            }
            else if (outputViewDisplayed)
            {
                if (twoByTwoDisplayed)
                {
                    if ([avc portraitOrientation])
                    {
                    }
                    else
                    {
                        [outputTableView setFrame:CGRectMake(2, 2, 313, 168)];
                        [oddsBasedParametersView setFrame:CGRectMake(317, -42, 313, 110)];
                        [riskBasedParametersView setFrame:CGRectMake(317, 70, 313, 88)];
                        [statisticalTestsView setFrame:CGRectMake(632, -42, 313, 176)];
                        [avc setContentSize:CGSizeMake(950, frame.size.height)];
                    }
                }
                else
                {
//                    [avc setContentSize:CGSizeMake(MAX(self.frame.size.width, outputTableViewWidth + 4.0), MAX(self.frame.size.height, outputTableViewHeight + 100.0))];
                    if ([avc portraitOrientation])
                    {
                    }
                    else
                    {
                    }
                }
            }
        }
    }
    else
    {
        if (frame.size.width > 0.0 && frame.size.height > 0.0)
        {
            [titleBar setFrame:CGRectMake(0, -114, frame.size.width - 4.0, 162)];
            [gadgetTitle setFrame:CGRectMake(2, 116, frame.size.width - 4.0 - 96, 44)];
            [xButton setFrame:CGRectMake(frame.size.width - 4.0 - 46, 116, 44, 44)];
            [gearButton setFrame:CGRectMake(frame.size.width - 4.0 - 92, 116, 44, 44)];
            [outputView setFrame:CGRectMake(0, 46, frame.size.width, 10.0 * frame.size.height - 46)];
            [secondOutputViewForIPad setFrame:CGRectMake(outputView.frame.size.width / 2.0, 0, outputView.frame.size.width / 2.0, outputView.frame.size.height)];
            if (inputViewDisplayed)
            {
                if ([avc portraitOrientation])
                {
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, 432)];
                    [chosenOutcomeVariable setFrame:CGRectMake(20, 8, 276, 44)];
                    [chosenExposureVariable setFrame:CGRectMake(frame.size.width - 296.0, 8, 276, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 220, 276, 44)];
                    [chooseOutcomeVariable setFrame:CGRectMake(10, 54, 296, 162)];
                    [chooseExposureVariable setFrame:CGRectMake(chosenExposureVariable.frame.origin.x - 10.0, 54, 296, 162)];
                    [chooseStratificationVariable setFrame:CGRectMake(10, 266, 296, 162)];
                    [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                    [includeMissingLabel setFrame:CGRectMake(chosenExposureVariable.frame.origin.x, 231, 140, 22)];
                    [includeMissingButton setFrame:CGRectMake(includeMissingLabel.frame.origin.x + 150, 231, 22, 22)];
                    [outcomeVariableLabel setFrame:CGRectMake(chosenOutcomeVariable.frame.origin.x, chosenOutcomeVariable.frame.origin.y, 284, 20)];
                    [outcomeLVE setFrame:CGRectMake(outcomeVariableLabel.frame.origin.x -6 , outcomeVariableLabel.frame.origin.y + 20, 276, 44)];
                    [exposureVariableLabel setFrame:CGRectMake(chosenExposureVariable.frame.origin.x - 8.0, chosenExposureVariable.frame.origin.y, 284, 20)];
                    [exposureLVE setFrame:CGRectMake(exposureVariableLabel.frame.origin.x - 6, exposureVariableLabel.frame.origin.y + 20, 276, 44)];
                    [stratificationVariableLabel setFrame:CGRectMake(chosenStratificationVariable.frame.origin.x, chosenStratificationVariable.frame.origin.y, 284, 20)];
                    [stratificationLVE setFrame:CGRectMake(stratificationVariableLabel.frame.origin.x - 6, stratificationVariableLabel.frame.origin.y + 20, 276, 44)];
                    [spinner setFrame:CGRectMake(frame.size.width / 2.0 - 20, 118, 40, 40)];
                }
                else
                {
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, frame.size.height - 100)];
                    [chosenOutcomeVariable setFrame:CGRectMake(20, 8, (inputView.frame.size.width - 60) / 2.0, 44)];
                    [chosenExposureVariable setFrame:CGRectMake(inputView.frame.size.width / 2.0 + 10, 8, (inputView.frame.size.width - 60) / 2.0, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 87, 276, 44)];
                    [chooseOutcomeVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseExposureVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseStratificationVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                    [includeMissingLabel setFrame:CGRectMake(20, 56, 140, 22)];
                    [includeMissingButton setFrame:CGRectMake(170, 56, 22, 22)];
                }
                [avc resetContentSize];
            }
            else if (outputViewDisplayed)
            {
                if (twoByTwoDisplayed)
                {
                    if ([avc portraitOrientation])
                    {
                    }
                    else
                    {
                        [outputTableView setFrame:CGRectMake(2, 2, 313, 168)];
                        [oddsBasedParametersView setFrame:CGRectMake(317, -42, 313, 110)];
                        [riskBasedParametersView setFrame:CGRectMake(317, 70, 313, 88)];
                        [statisticalTestsView setFrame:CGRectMake(632, -42, 313, 176)];
                        [avc setContentSize:CGSizeMake(950, frame.size.height)];
                    }
                }
                else
                {
                    //                    [avc setContentSize:CGSizeMake(MAX(self.frame.size.width, outputTableViewWidth + 4.0), MAX(self.frame.size.height, outputTableViewHeight + 100.0))];
                    if ([avc portraitOrientation])
                    {
                    }
                    else
                    {
                    }
                }
            }
        }
    }
    [mapOutcomeValuesButton setFrame:CGRectMake(stratificationLVE.frame.origin.x + 8.0, stratificationLVE.frame.origin.y + stratificationLVE.frame.size.height + 16.0, stratificationLVE.frame.size.width - 16.0, 40.0)];
    [mapExposureValuesButton setFrame:CGRectMake(mapOutcomeValuesButton.frame.origin.x, mapOutcomeValuesButton.frame.origin.y + mapOutcomeValuesButton.frame.size.height + 2.0, mapOutcomeValuesButton.frame.size.width, mapOutcomeValuesButton.frame.size.height)];
}

- (void)fieldResignedFirstResponder:(id)field
{
    if ([field tag] == 0x051810)
    {
        if ([[(LegalValuesEnter *)field epiInfoControlValue] containsString:@" = GROUP("])
        {
            [stratificationLVE reset];
            [stratificationLVE setIsEnabled:NO];
        }
        else
        {
            [stratificationLVE setIsEnabled:YES];
        }
        int selInd = [[(LegalValuesEnter *)field selectedIndex] intValue];
        if (selInd > 0)
        {
            [mapExposureValuesButton setEnabled:YES];
            [mapExposureValuesButton setAlpha:1.0];
        }
        else
        {
            [mapExposureValuesButton setEnabled:NO];
            [mapExposureValuesButton setAlpha:0.4];
        }
    }
    else if ([field tag] == 0x0F1514)
    {
        int selInd = [[(LegalValuesEnter *)field selectedIndex] intValue];
        if (selInd > 0)
        {
            [mapOutcomeValuesButton setEnabled:YES];
            [mapOutcomeValuesButton setAlpha:1.0];
        }
        else
        {
            [mapOutcomeValuesButton setEnabled:NO];
            [mapOutcomeValuesButton setAlpha:0.4];
        }
    }
}

- (void)chosenOutcomeVariableButtonPressed
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    outcomeVariableChosen = YES;
    [UIView animateWithDuration:0.6 animations:^{
        [chooseOutcomeVariable setFrame:CGRectMake(10, 6, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)chosenExposureVariableButtonPressed
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    exposureVariableChosen = YES;
    [UIView animateWithDuration:0.6 animations:^{
        [chooseExposureVariable setFrame:CGRectMake(10, 6, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)chosenStratificationVariableButtonPressed
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
//    stratificationVariableChosen = YES;
    [UIView animateWithDuration:0.6 animations:^{
        [chooseStratificationVariable setFrame:CGRectMake(10, 6, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)chooseOutcomeVariableTapped:(UITapGestureRecognizer *)tap
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    [UIView animateWithDuration:0.9 animations:^{
        [chosenOutcomeVariable setTitle:[NSString stringWithFormat:@"Outcome:  %@", [availableOutcomeVariables objectAtIndex:selectedOutcomeVariableNumber.integerValue]] forState:UIControlStateNormal];
        [chooseOutcomeVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)chooseExposureVariableTapped:(UITapGestureRecognizer *)tap
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    [UIView animateWithDuration:0.9 animations:^{
        [chosenExposureVariable setTitle:[NSString stringWithFormat:@"Exposure:  %@", [availableOutcomeVariables objectAtIndex:selectedExposureVariableNumber.integerValue]] forState:UIControlStateNormal];
        [chooseExposureVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)chooseStratificationVariableTapped:(UITapGestureRecognizer *)tap
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    [UIView animateWithDuration:0.9 animations:^{
        if (stratificationVariableChosen)
            [chosenStratificationVariable setTitle:[NSString stringWithFormat:@"Stratify By:  %@", [availableOutcomeVariables objectAtIndex:selectedStratificationVariableNumber.integerValue]] forState:UIControlStateNormal];
        else
            [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
        [chooseStratificationVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)xButtonPressed
{
    [UIView animateWithDuration:0.3 animations:^{
        for (UIView *v in [self subviews])
        {
            for (UIView *sv in [v subviews])
            {
                if ([sv isKindOfClass:[UIPickerView class]])
                    [sv removeFromSuperview];
                else
                {
                    for (UIView *ssv in [sv subviews])
                    {
                        for (UIView *sssv in [ssv subviews])
                            [sssv setFrame:CGRectMake(0, 0, 0, 0)];
                        [ssv setFrame:CGRectMake(0, 0, 0, 0)];
                    }
                    [sv setFrame:CGRectMake(0, 0, 0, 0)];
                }
            }
            [v setFrame:CGRectMake(0, 0, 0, 0)];
        }
//            [v removeFromSuperview];
        [self setFrame:CGRectMake(self.frame.size.width / 2, self.frame.size.height / 2.0, 0, 0)];
    }];
    [avc replaceChooseAnalysis];
    [avc resetContentSize];
    [avc putViewOnEpiInfoScrollView:self];
}

- (void)mapOutcomeValuesButtonPressed:(UIButton *)sender
{
    if (!([[outcomeLVE selectedIndex] intValue] > 0))
        return;
    UIView *topmostView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    float senderY = sender.frame.origin.y;
    float sendersuperW = [[sender superview] superview].frame.size.width;
    float sendersuperH = topmostView.frame.size.height;
    BOOL outcomeVariableChanged = YES;
    if (previousOutcomeVariableValue)
    {
        if ([previousOutcomeVariableValue isEqualToString:[outcomeLVE epiInfoControlValue]])
        {
            outcomeVariableChanged = NO;
        }
    }
    if (outcomeVariableChanged)
    {
        previousOutcomeVariableValue = [NSString stringWithString:[outcomeLVE epiInfoControlValue]];
        FrequencyObject *freqObj = [[FrequencyObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndVariable:previousOutcomeVariableValue AndIncludeMissing:YES];
        NSArray *variableValuesNSA = [freqObj variableValues];
        outcomeValueMapper = [[VariableValueMapper alloc] initWithFrame:CGRectMake(0, senderY, sendersuperW, sendersuperH)];
        [outcomeValueMapper setWhiteY:gearButton.frame.origin.y - 2.0 andValueList:variableValuesNSA];
    }
    [topmostView addSubview:outcomeValueMapper];
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [outcomeValueMapper setFrame:CGRectMake(0, 0, sendersuperW, sendersuperH)];
    }completion:nil];
}

- (void)mapExposureValuesButtonPressed:(UIButton *)sender
{
    if (!([[exposureLVE selectedIndex] intValue] > 0))
        return;
    UIView *topmostView = [[[[UIApplication sharedApplication] keyWindow] rootViewController] view];
    float senderY = sender.frame.origin.y;
    float sendersuperW = [[sender superview] superview].frame.size.width;
    float sendersuperH = topmostView.frame.size.height;
    BOOL exposureVariableChanged = YES;
    if (previousExposureVariableValue)
    {
        if ([previousExposureVariableValue isEqualToString:[exposureLVE epiInfoControlValue]])
        {
            exposureVariableChanged = NO;
        }
    }
    if (exposureVariableChanged)
    {
        previousExposureVariableValue = [NSString stringWithString:[exposureLVE epiInfoControlValue]];
        if ([previousExposureVariableValue containsString:@" = GROUP("])
        {
            NSMutableArray *variableValuesNSMA = [[NSMutableArray alloc] init];
            
            NSRange GROUPrange = [previousExposureVariableValue rangeOfString:@" = GROUP("];
            int lastPosition = (int)[previousExposureVariableValue length] - 1;
            NSString *commaSeparatedListOfVariables = [[previousExposureVariableValue substringToIndex:lastPosition] substringFromIndex:GROUPrange.location + GROUPrange.length];
            NSArray *exposureVariablesNSA = [commaSeparatedListOfVariables componentsSeparatedByString:@", "];
            for (NSString *nst in exposureVariablesNSA)
            {
                FrequencyObject *freqObj = [[FrequencyObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndVariable:nst AndIncludeMissing:YES];
                NSArray *variableValuesNSA = [freqObj variableValues];
                for (NSString *nstt in variableValuesNSA)
                {
                    if (![variableValuesNSMA containsObject:nstt])
                    {
                        [variableValuesNSMA addObject:nstt];
                    }
                }
            }
            
            NSArray *variableValuesNSA = [NSArray arrayWithArray:variableValuesNSMA];
            exposureValueMapper = [[VariableValueMapper alloc] initWithFrame:CGRectMake(0, senderY, sendersuperW, sendersuperH)];
            [exposureValueMapper setWhiteY:gearButton.frame.origin.y - 2.0 andValueList:variableValuesNSA];
        }
        else
        {
            FrequencyObject *freqObj = [[FrequencyObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndVariable:previousExposureVariableValue AndIncludeMissing:YES];
            NSArray *variableValuesNSA = [freqObj variableValues];
            exposureValueMapper = [[VariableValueMapper alloc] initWithFrame:CGRectMake(0, senderY, sendersuperW, sendersuperH)];
            [exposureValueMapper setWhiteY:gearButton.frame.origin.y - 2.0 andValueList:variableValuesNSA];
        }
    }
    [topmostView addSubview:exposureValueMapper];
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [exposureValueMapper setFrame:CGRectMake(0, 0, sendersuperW, sendersuperH)];
    }completion:nil];
}

- (void)gearButtonPressed
{
    [avc putViewOnZoomingView:self];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [gearButton setEnabled:NO];
        [xButton setEnabled:NO];
        [avc setDataSourceEnabled:NO];
        if (inputView.frame.size.height > 0)
        {
            inputViewDisplayed = NO;
            [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
                [chosenOutcomeVariable setFrame:CGRectMake(20, chosenOutcomeVariable.frame.origin.y - 170, chosenOutcomeVariable.frame.size.width, 44)];
                [chosenExposureVariable setFrame:CGRectMake(20, chosenExposureVariable.frame.origin.y - 170, chosenExposureVariable.frame.size.width, 44)];
                [chosenStratificationVariable setFrame:CGRectMake(20, chosenExposureVariable.frame.origin.y - 170, chosenExposureVariable.frame.size.width, 44)];
                [outcomeLVE setFrame:CGRectMake(10, chosenOutcomeVariable.frame.origin.y, chosenOutcomeVariable.frame.size.width, 44)];
                [exposureLVE setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y, chosenExposureVariable.frame.size.width, 44)];
                [stratificationLVE setFrame:CGRectMake(10, chosenStratificationVariable.frame.origin.y, chosenExposureVariable.frame.size.width, 44)];
                [outcomeVariableLabel setFrame:CGRectMake(10, chosenOutcomeVariable.frame.origin.y - 20, chosenOutcomeVariable.frame.size.width, 44)];
                [exposureVariableLabel setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 20, chosenExposureVariable.frame.size.width, 44)];
                [stratificationVariableLabel setFrame:CGRectMake(10, chosenStratificationVariable.frame.origin.y - 20, chosenExposureVariable.frame.size.width, 44)];
                //Move the pickers up if they are in view, otherwise they need to be hidden in case the
                //ContentSize increases to >1000
                if (chooseOutcomeVariable.frame.origin.y < 500)
                {
                    [chosenOutcomeVariable setTitle:[NSString stringWithFormat:@"Outcome:  %@", [availableOutcomeVariables objectAtIndex:selectedOutcomeVariableNumber.integerValue]] forState:UIControlStateNormal];
                    [chooseOutcomeVariable setFrame:CGRectMake(0, -162, 314, 162)];
                }
                else
                    [chooseOutcomeVariable setHidden:YES];
                if (chooseExposureVariable.frame.origin.y < 500)
                {
                    [chosenExposureVariable setTitle:[NSString stringWithFormat:@"Exposure:  %@", [availableOutcomeVariables objectAtIndex:selectedExposureVariableNumber.integerValue]] forState:UIControlStateNormal];
                    [chooseExposureVariable setFrame:CGRectMake(0, -162, 314, 162)];
                }
                else
                    [chooseExposureVariable setHidden:YES];
                if (chooseStratificationVariable.frame.origin.y < 500)
                {
                    if (stratificationVariableChosen)
                        [chosenStratificationVariable setTitle:[NSString stringWithFormat:@"Stratify By:  %@", [availableOutcomeVariables objectAtIndex:selectedStratificationVariableNumber.integerValue]] forState:UIControlStateNormal];
                    else
                        [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
                    [chooseStratificationVariable setFrame:CGRectMake(0, -162, 314, 162)];
                }
                else
                    [chooseStratificationVariable setHidden:YES];
                [inputView setFrame:CGRectMake(2, 48, self.frame.size.width - 4, 0)];
                [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, 0)];
                [includeMissingButton setFrame:CGRectMake(includeMissingButton.frame.origin.x, -22, 22, 22)];
                [includeMissingLabel setFrame:CGRectMake(includeMissingLabel.frame.origin.x, -22, includeMissingLabel.frame.size.width, 22)];
                //    }completion:^(BOOL finished){[self stopTheSpinner];}];
            }completion:nil];
            [spinner startAnimating];
            [spinner setHidden:NO];
            NSThread *tablesThread = [[NSThread alloc] initWithTarget:self selector:@selector(doInBackground) object:nil];
            [tablesThread start];
        }
        else
        {
            [chooseOutcomeVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
            [chooseExposureVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
            [chooseStratificationVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
            [chooseOutcomeVariable setHidden:NO];
            [chooseExposureVariable setHidden:NO];
            [chooseStratificationVariable setHidden:NO];

            inputViewDisplayed = YES;
            outputViewDisplayed = NO;
            twoByTwoDisplayed = NO;
            for (UIView *v in [outputView subviews])
            {
                for (UIView *v2 in [v subviews])
                {
                    for (UIView *v3 in [v2 subviews])
                    {
                        for (UIView *v4 in [v3 subviews])
                        {
                            [v4 removeFromSuperview];
                        }
                        [v3 removeFromSuperview];
                    }
                    [v2 removeFromSuperview];
                }
                [v removeFromSuperview];
            }
            for (UIView *v in [self subviews])
            {
                if (v.frame.origin.y > outputView.frame.origin.x && v != inputView && v != outputView)
                {
                    for (UIView *v2 in [v subviews])
                    {
                        for (UIView *v3 in [v2 subviews])
                        {
                            for (UIView *v4 in [v3 subviews])
                            {
                                [v4 removeFromSuperview];
                            }
                            [v3 removeFromSuperview];
                        }
                        [v2 removeFromSuperview];
                    }
                    [v removeFromSuperview];
                }
            }
            [avc resetContentSize];
            [gearButton setEnabled:YES];
            [xButton setEnabled:YES];
            [avc setDataSourceEnabled:YES];
            
            [avc putViewOnEpiInfoScrollView:self];
        }
        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:CGRectMake(0, 50, avc.view.frame.size.width, avc.view.frame.size.height)];
        }completion:nil];
    }
    else
    {
        [gearButton setEnabled:NO];
        [xButton setEnabled:NO];
        [avc setDataSourceEnabled:NO];
        if (inputView.frame.size.height > 0)
        {
            inputViewDisplayed = NO;
            [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
                [chosenOutcomeVariable setFrame:CGRectMake(20, chosenOutcomeVariable.frame.origin.y - 220, chosenOutcomeVariable.frame.size.width, 44)];
                [chosenExposureVariable setFrame:CGRectMake(chosenExposureVariable.frame.origin.x, chosenExposureVariable.frame.origin.y - 220, chosenExposureVariable.frame.size.width, 44)];
                [chosenStratificationVariable setFrame:CGRectMake(20, chosenExposureVariable.frame.origin.y - 220, chosenExposureVariable.frame.size.width, 44)];
                //Move the pickers up if they are in view, otherwise they need to be hidden in case the
                //ContentSize increases to >1000
                if (chooseOutcomeVariable.frame.origin.y < 500)
                {
                    [chosenOutcomeVariable setTitle:[NSString stringWithFormat:@"Outcome:  %@", [availableOutcomeVariables objectAtIndex:selectedOutcomeVariableNumber.integerValue]] forState:UIControlStateNormal];
                    [chooseOutcomeVariable setFrame:CGRectMake(0, -212, 314, 162)];
                }
                else
                    [chooseOutcomeVariable setHidden:YES];
                if (chooseExposureVariable.frame.origin.y < 500)
                {
                    [chosenExposureVariable setTitle:[NSString stringWithFormat:@"Exposure:  %@", [availableOutcomeVariables objectAtIndex:selectedExposureVariableNumber.integerValue]] forState:UIControlStateNormal];
                    [chooseExposureVariable setFrame:CGRectMake(chooseExposureVariable.frame.origin.x, -212, 314, 162)];
                }
                else
                    [chooseExposureVariable setHidden:YES];
                if (chooseStratificationVariable.frame.origin.y < 500)
                {
                    [chooseStratificationVariable setFrame:CGRectMake(0, -212, 314, 162)];
                }
                else
                    [chooseStratificationVariable setHidden:YES];
                [inputView setFrame:CGRectMake(2, -948, self.frame.size.width - 4, 0)];
                [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, 0)];
                [includeMissingButton setFrame:CGRectMake(includeMissingButton.frame.origin.x, -72, 22, 22)];
                [includeMissingLabel setFrame:CGRectMake(includeMissingLabel.frame.origin.x, -72, includeMissingLabel.frame.size.width, 22)];
                //    }completion:^(BOOL finished){[self stopTheSpinner];}];
            }completion:nil];
            [spinner startAnimating];
            [spinner setHidden:NO];
            NSThread *tablesThread = [[NSThread alloc] initWithTarget:self selector:@selector(doInBackground) object:nil];
            [tablesThread start];
        }
        else
        {
            [chooseOutcomeVariable setHidden:NO];
            [chooseExposureVariable setHidden:NO];
            [chooseStratificationVariable setHidden:NO];
            
            inputViewDisplayed = YES;
            outputViewDisplayed = NO;
            twoByTwoDisplayed = NO;
            for (UIView *v in [outputView subviews])
            {
                for (UIView *v2 in [v subviews])
                {
                    for (UIView *v3 in [v2 subviews])
                    {
                        for (UIView *v4 in [v3 subviews])
                        {
                            [v4 removeFromSuperview];
                        }
                        [v3 removeFromSuperview];
                    }
                    [v2 removeFromSuperview];
                }
                [v removeFromSuperview];
            }
            for (UIView *v in [self subviews])
            {
                if (v.frame.origin.y > outputView.frame.origin.x && v != inputView && v != outputView && v != secondOutputViewForIPad)
                {
                    for (UIView *v2 in [v subviews])
                    {
                        for (UIView *v3 in [v2 subviews])
                        {
                            for (UIView *v4 in [v3 subviews])
                            {
                                [v4 removeFromSuperview];
                            }
                            [v3 removeFromSuperview];
                        }
                        [v2 removeFromSuperview];
                    }
                    [v removeFromSuperview];
                }
            }
            [avc resetContentSize];
            [gearButton setEnabled:YES];
            [xButton setEnabled:YES];
            [avc setDataSourceEnabled:YES];
            
            [avc putViewOnEpiInfoScrollView:self];
        }
        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:CGRectMake(0, 50, avc.view.frame.size.width, avc.view.frame.size.height)];
        }completion:nil];
    }
}

- (void)doInBackground
{
    leftSide = 1.0;
    float rightSide = 0.0;

    if ([[outcomeLVE selectedIndex] intValue] > 0 && [[exposureLVE selectedIndex] intValue] > 0 && [[stratificationLVE selectedIndex] intValue] == 0)
    {
        outputViewDisplayed = YES;
        stratum = 0;
        NSString *exposureVariableString = [availableExposureVariables objectAtIndex:[exposureLVE selectedIndex].intValue];
        NSArray *exposureVariablesNSA = [[NSArray alloc] init];
        if ([exposureVariableString containsString:@" = GROUP("])
        {
            NSRange GROUPrange = [exposureVariableString rangeOfString:@" = GROUP("];
            int lastPosition = (int)[exposureVariableString length] - 1;
            NSString *stringWithVariablesAndCommas = [[exposureVariableString substringToIndex:lastPosition] substringFromIndex:GROUPrange.location + GROUPrange.length];
            exposureVariablesNSA = [stringWithVariablesAndCommas componentsSeparatedByString:@", "];
        }
        else
            exposureVariablesNSA = @[exposureVariableString];
        NSMutableArray *toNSMA = [[NSMutableArray alloc] init];
        for (int exposuresindex = 0; exposuresindex < [exposureVariablesNSA count]; exposuresindex++)
        {
            if (![availableExposureVariables containsObject:[exposureVariablesNSA objectAtIndex:exposuresindex]])
                continue;
            [toNSMA addObject:[[TablesObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndOutcomeVariable:[availableOutcomeVariables objectAtIndex:[outcomeLVE selectedIndex].intValue] AndExposureVariable:[exposureVariablesNSA objectAtIndex:exposuresindex] AndIncludeMissing:includeMissing ForTablesView:self]];
        }
        numberOfExposures = (int)[toNSMA count];
        summaryTable = [[NSMutableArray alloc] init];
//        TablesObject *to = [[TablesObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndOutcomeVariable:[availableOutcomeVariables objectAtIndex:[outcomeLVE selectedIndex].intValue] AndExposureVariable:[availableExposureVariables objectAtIndex:[exposureLVE selectedIndex].intValue] AndIncludeMissing:includeMissing];
        contentSizeHeight = 22;
        for (int tos = 0; tos < [toNSMA count]; tos++)
        {
            TablesObject *to = (TablesObject *)[toNSMA objectAtIndex:tos];
            if (to.exposureValues.count == 2 && to.outcomeValues.count == 2)
                contentSizeHeight += 20;
        }
        if (contentSizeHeight < 40)
            contentSizeHeight = 0;
        float valueToAddToContentSizeHeight = 0.0;
        for (int tos = 0; tos < [toNSMA count]; tos++)
        {
            workingExposure = tos;
            TablesObject *to = (TablesObject *)[toNSMA objectAtIndex:tos];
            
            if (to.exposureValues.count == 2 && to.outcomeValues.count == 2)
            {
                [summaryTable addObject:[[NSMutableArray alloc] init]];
                UIView *useThisOutputView = outputView;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && tos % 2 > 0)
                    useThisOutputView = secondOutputViewForIPad;
                [self doTwoByTwo:to OnOutputView:useThisOutputView StratificationVariable:nil StratificationValue:nil];
                if (tos > 0)
                    contentSizeHeight += 550;
                else
                    contentSizeHeight += 550;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && tos % 2 == 0 && (tos + 1) < [toNSMA count])
                {
                    contentSizeHeight -= 550;
                    valueToAddToContentSizeHeight = 550;
                }
                else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    contentSizeHeight -= 550;
                    contentSizeHeight += MAX(550.0, valueToAddToContentSizeHeight);
                }
                CGSize avcContentSize = CGSizeMake(self.frame.size.width, contentSizeHeight + 100);
                [avc setContentSize:avcContentSize];
//                [avc setContentSize:CGSizeMake(self.frame.size.width, 650 + 550 * (numberOfExposures - 1) + 20.0 * (numberOfExposures + 1) + 2)];
            }
            else
            {
                UIView *useThisOutputView = outputView;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && tos % 2 > 0)
                    useThisOutputView = secondOutputViewForIPad;
                float contentSizeHeightPlus = [self doMxN:to OnOutputView:useThisOutputView StratificationVariable:nil StratificationValue:nil].height;
                contentSizeHeight += contentSizeHeightPlus;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && tos % 2 == 0 && (tos + 1) < [toNSMA count])
                {
                    contentSizeHeight -= contentSizeHeightPlus;
                    valueToAddToContentSizeHeight = contentSizeHeightPlus;
                }
                else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                {
                    contentSizeHeight -= contentSizeHeightPlus;
                    contentSizeHeight += MAX(contentSizeHeightPlus, valueToAddToContentSizeHeight);
                }
                CGSize avcContentSize = CGSizeMake(MAX(self.frame.size.width, outputView.frame.size.width + 2.0), contentSizeHeight + 100);
                [avc setContentSize:avcContentSize];
//                [avc setContentSize:[self doMxN:to OnOutputView:outputView StratificationVariable:nil StratificationValue:nil]];
            }
            to = nil;
        }
        [self doGroupVariableSummaries:summaryTable OnOutputView:outputView];
        [outputView addSubview:secondOutputViewForIPad];
    }
    if ([[outcomeLVE selectedIndex] intValue] > 0 && [[exposureLVE selectedIndex] intValue] > 0 && [[stratificationLVE selectedIndex] intValue] > 0)
    {
        NSString *stratificationVariableName = [availableOutcomeVariables objectAtIndex:[[stratificationLVE selectedIndex] intValue]];
        NSString *outcomeVariableName = [availableOutcomeVariables objectAtIndex:[outcomeLVE selectedIndex].integerValue];
        NSString *exposureVariableName = [availableOutcomeVariables objectAtIndex:[exposureLVE selectedIndex].integerValue];
        FrequencyObject *fo = [[FrequencyObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndVariable:stratificationVariableName AndIncludeMissing:includeMissing];
        
        outputViewDisplayed = YES;
        BOOL allTwoByTwo = YES;
        NSMutableArray *twoByTwoStrata = [[NSMutableArray alloc] initWithCapacity:fo.variableValues.count];
        
        float contentSizeHeight = 650.0;
        float contentSizeWidth = self.frame.size.width;
        float amountToSubtract = 0.0;
        for (int i=0; i < fo.variableValues.count; i++)
        {
            leftSide = 1.0;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && i % 2 > 0)
                leftSide = 0.0;
            rightSide = 1.0 - leftSide;
            stratum = i;
            NSString *whereClause;
            if ([(NSNumber *)[sqliteData.dataTypesWorking objectAtIndex:[sqliteData.columnNamesWorking indexOfObject:stratificationVariableName]] intValue] == 2)
            {
                if ([[fo.variableValues objectAtIndex:i] isKindOfClass:[NSNull class]] || [[fo.variableValues objectAtIndex:i] isEqualToString:@"(null)"])
                    whereClause = [NSString stringWithFormat:@"WHERE %@ = '(null)'", stratificationVariableName];
                else
                    whereClause = [NSString stringWithFormat:@"WHERE %@ = '%@'", stratificationVariableName, [fo.variableValues objectAtIndex:i]];
            }
            else
                whereClause = [NSString stringWithFormat:@"WHERE %@ = %@", stratificationVariableName, [fo.variableValues objectAtIndex:i]];
            
            TablesObject *to = [[TablesObject alloc] initWithSQLiteData:sqliteData AndWhereClause:whereClause AndOutcomeVariable:outcomeVariableName AndExposureVariable:exposureVariableName AndIncludeMissing:includeMissing ForTablesView:self];
            
            if (to.exposureValues.count == 2 && to.outcomeValues.count == 2)
            {
                [twoByTwoStrata addObject:to.cellCounts];
                
                if (stratum == 0)
                    [self doTwoByTwo:to OnOutputView:outputView StratificationVariable:stratificationVariableName StratificationValue:[fo.variableValues objectAtIndex:i]];
                else
                {
                    //Add another output view
                    UIView *outputView2 = [[UIView alloc] initWithFrame:CGRectMake(0 + 420.0 * rightSide, contentSizeHeight - amountToSubtract * rightSide, outputView.frame.size.width, 10 * outputView.frame.size.height)];
                    [outputView2 setBackgroundColor:[UIColor whiteColor]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                      [self addSubview:outputView2];
                    });
                    [self doTwoByTwo:to OnOutputView:outputView2 StratificationVariable:stratificationVariableName StratificationValue:[fo.variableValues objectAtIndex:i]];
                }
                if (stratum > 0)
                    contentSizeHeight += 652.0 * leftSide;
                amountToSubtract = 604.0;
            }
            else
            {
                allTwoByTwo = NO;
                rightSide = 0;
                leftSide = 1.0;
                CGSize rSize;
                if (stratum == 0)
                {
                    rSize = [self doMxN:to OnOutputView:outputView StratificationVariable:stratificationVariableName StratificationValue:[fo.variableValues objectAtIndex:i]];
                    NSLog(@"%@", outputView);
                    contentSizeHeight = rSize.height;
                }
                else
                {
                    //Add another output view
                    UIView *outputView2 = [[UIView alloc] initWithFrame:CGRectMake(0, contentSizeHeight - amountToSubtract * rightSide, outputView.frame.size.width, outputView.frame.size.height)];
                    [outputView2 setBackgroundColor:[UIColor whiteColor]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                      [self addSubview:outputView2];
                    });
                    rSize = [self doMxN:to OnOutputView:outputView2 StratificationVariable:stratificationVariableName StratificationValue:[fo.variableValues objectAtIndex:i]];
                    NSLog(@"%@", outputView2);
                    contentSizeHeight += rSize.height * leftSide;
                }
                amountToSubtract = rSize.height - 48.0;
                contentSizeWidth = MAX(contentSizeWidth, rSize.width);
            }
        }
        if (allTwoByTwo && twoByTwoStrata.count > 1)
        {
            NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:twoByTwoStrata.count];
            for (int i = 0; i < twoByTwoStrata.count; i++)
            {
                Twox2StrataData *stratumdata = [[Twox2StrataData alloc] init];
                [stratumdata setHasData:YES];
                [stratumdata setHasStatistics:YES];
                [stratumdata setYy:[(NSNumber *)[(NSArray *)[twoByTwoStrata objectAtIndex:i] objectAtIndex:0] intValue]];
                [stratumdata setYyHasValue:YES];
                [stratumdata setYn:[(NSNumber *)[(NSArray *)[twoByTwoStrata objectAtIndex:i] objectAtIndex:1] intValue]];
                [stratumdata setYnHasValue:YES];
                [stratumdata setNy:[(NSNumber *)[(NSArray *)[twoByTwoStrata objectAtIndex:i] objectAtIndex:2] intValue]];
                [stratumdata setNyHasValue:YES];
                [stratumdata setNn:[(NSNumber *)[(NSArray *)[twoByTwoStrata objectAtIndex:i] objectAtIndex:3] intValue]];
                [stratumdata setNnHasValue:YES];
                [tempArray addObject:stratumdata];
            }
            NSArray *strataData = [[NSArray alloc] initWithArray:tempArray];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                contentSizeHeight += 20.0;
            UIView *outputView2 = [[UIView alloc] initWithFrame:CGRectMake(0 + 420.0 * leftSide * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad), contentSizeHeight - 30 - 642.0 * leftSide * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad), outputView.frame.size.width, outputView.frame.size.height)];
            [outputView2 setBackgroundColor:[UIColor whiteColor]];
            dispatch_async(dispatch_get_main_queue(), ^{
              [self addSubview:outputView2];
            });
            TablesObject *to = [[TablesObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndOutcomeVariable:outcomeVariableName AndExposureVariable:exposureVariableName AndIncludeMissing:includeMissing ForTablesView:self];
            [self doSummary:strataData OutputView:outputView2 TablesObject:to];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || rightSide)
                contentSizeHeight += 680;
            else
                contentSizeHeight += 40.0;
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [self bringSubviewToFront:inputView];
        [avc setContentSize:CGSizeMake(contentSizeWidth, contentSizeHeight)];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinner setHidden:YES];
        [spinner stopAnimating];
        [gearButton setEnabled:YES];
        [xButton setEnabled:YES];
        [avc setDataSourceEnabled:YES];
    });
}

- (BOOL)stopTheSpinner
{
    [gearButton setEnabled:YES];
    [xButton setEnabled:YES];
    [avc setDataSourceEnabled:YES];
    return YES;
}

- (void)gearButtonPressedStartTheSpinner
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)doOtherGearStuff
{
}

- (void)includeMissingButtonPressed
{
    if (includeMissing)
    {
        includeMissing = NO;
        [includeMissingButton setBackgroundColor:[UIColor whiteColor]];
        [includeMissingButton.layer setBorderColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0].CGColor];
    }
    else
    {
        includeMissing = YES;
        [includeMissingButton setBackgroundColor:[UIColor blackColor]];
        [includeMissingButton.layer setBorderColor:[UIColor blackColor].CGColor];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([pickerView tag] == 2)
        return sqliteData.columnNamesWorking.count + 1;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return sqliteData.columnNamesWorking.count + 1;
    
    return sqliteData.columnNamesWorking.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *variableForRow;
    if ([pickerView tag] == 0)
    {
        availableOutcomeVariables = [[NSMutableArray alloc] init];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [availableOutcomeVariables addObject:@""];
        for (NSString *variable in sqliteData.columnNamesWorking)
        {
            [availableOutcomeVariables addObject:variable];
        }
        [availableOutcomeVariables sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        variableForRow = [availableOutcomeVariables objectAtIndex:row];
    }
    else if ([pickerView tag] == 1)
    {
        availableExposureVariables = [[NSMutableArray alloc] init];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [availableExposureVariables addObject:@""];
        for (NSString *variable in sqliteData.columnNamesWorking)
          {
            [availableExposureVariables addObject:variable];
        }
        [availableExposureVariables sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        variableForRow = [availableExposureVariables objectAtIndex:row];
    }
    else if ([pickerView tag] == 2)
    {
        availableStratificationVariables = [[NSMutableArray alloc] init];
        [availableStratificationVariables addObject:@""];
        for (NSString *variable in sqliteData.columnNamesWorking)
        {
            [availableStratificationVariables addObject:variable];
        }
        [availableStratificationVariables sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        variableForRow = [availableStratificationVariables objectAtIndex:row];
    }
    return variableForRow;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView tag] == 0)
    {
        selectedOutcomeVariableNumber = [NSNumber numberWithInteger:row];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (selectedOutcomeVariableNumber.intValue == 0)
                {
                    outcomeVariableChosen = NO;
                    [chosenOutcomeVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                    [chosenOutcomeVariable setTitle:@"Select Outcome Variable" forState:UIControlStateNormal];
                    return;
                }
                if (chooseOutcomeVariable.frame.origin.y < 500)
                {
                    float fontSize = 18.0;
                    while ([[NSString stringWithFormat:@"Outcome Variable: %@", [availableOutcomeVariables objectAtIndex:selectedOutcomeVariableNumber.integerValue]] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > chosenOutcomeVariable.frame.size.width - 10.0)
                        fontSize -= 0.1;
                    outcomeVariableChosen = YES;
                    [chosenOutcomeVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
                    [chosenOutcomeVariable setTitle:[NSString stringWithFormat:@"Outcome Variable: %@", [availableOutcomeVariables objectAtIndex:selectedOutcomeVariableNumber.integerValue]] forState:UIControlStateNormal];
                }
            }];
        }
    }
    else if ([pickerView tag] == 1)
    {
        selectedExposureVariableNumber = [NSNumber numberWithInteger:row];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (selectedExposureVariableNumber.intValue == 0)
                {
                    exposureVariableChosen = NO;
                    [chosenExposureVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                    [chosenExposureVariable setTitle:@"Select Exposure Variable" forState:UIControlStateNormal];
                    return;
                }
                if (chooseExposureVariable.frame.origin.y < 500)
                {
                    float fontSize = 18.0;
                    while ([[NSString stringWithFormat:@"Exposure Variable: %@", [availableExposureVariables objectAtIndex:selectedExposureVariableNumber.integerValue]] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > chosenExposureVariable.frame.size.width - 10.0)
                        fontSize -= 0.1;
                    exposureVariableChosen = YES;
                    [chosenExposureVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
                    [chosenExposureVariable setTitle:[NSString stringWithFormat:@"Exposure Variable: %@", [availableExposureVariables objectAtIndex:selectedExposureVariableNumber.integerValue]] forState:UIControlStateNormal];
                }
            }];
        }
    }
    else if ([pickerView tag] == 2)
    {
        selectedStratificationVariableNumber = [NSNumber numberWithInteger:row - 1];
        if (row == 0)
            stratificationVariableChosen = NO;
        else
            stratificationVariableChosen = YES;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (selectedStratificationVariableNumber.intValue < 0)
                {
                    [chosenStratificationVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                    [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
                    return;
                }
                if (chooseStratificationVariable.frame.origin.y < 500)
                {
                    float fontSize = 18.0;
                    while ([[NSString stringWithFormat:@"Stratification Variable: %@", [availableStratificationVariables objectAtIndex:selectedStratificationVariableNumber.integerValue + 1]] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > chosenStratificationVariable.frame.size.width - 10.0)
                        fontSize -= 0.1;
                    [chosenStratificationVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
                    [chosenStratificationVariable setTitle:[NSString stringWithFormat:@"Stratification Variable: %@", [availableStratificationVariables objectAtIndex:selectedStratificationVariableNumber.integerValue + 1]] forState:UIControlStateNormal];
                }
            }];
        }
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return oddsAndRiskTableView;
}

- (void)doGroupVariableSummaries:(NSArray *)oddsAndRisk OnOutputView:(UIView *)outputV
{
    if ([oddsAndRisk count] == 0)
        return;
    oddsAndRisk = [SharedResources sortArrayOfArrays:oddsAndRisk onIndex:5];
    float cellWidth = 79.0;
    oddsAndRiskTableView = [[UIScrollView alloc] initWithFrame:CGRectMake(2, 2, MIN(7.0 * (cellWidth + 1.0), outputV.frame.size.width - 4.0), 20.0 * ([oddsAndRisk count] + 1))];
    [oddsAndRiskTableView setBackgroundColor:epiInfoLightBlue];
    [oddsAndRiskTableView setContentSize:CGSizeMake(7 * (cellWidth + 1.0), 20.0 * ([oddsAndRisk count] + 1))];
    
    UIView *underTheFirstColumnView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, cellWidth + 1, 20.0 * ([oddsAndRisk count] + 1))];
    [underTheFirstColumnView setBackgroundColor:epiInfoLightBlue];
    
    UIView *rightBorderView = [[UIView alloc] initWithFrame:CGRectMake(outputV.frame.size.width - 3.0, 2, 1, 20.0 * ([oddsAndRisk count] + 1))];
    [rightBorderView setBackgroundColor:epiInfoLightBlue];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [rightBorderView setBackgroundColor:[UIColor clearColor]];

    UIView *rightOfTheTableView = [[UIView alloc] initWithFrame:CGRectMake(outputV.frame.size.width - 2.0, 2, 2, 20.0 * ([oddsAndRisk count] + 1))];
    [rightOfTheTableView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *columnHeader = [[UILabel alloc] initWithFrame:CGRectMake(0 * cellWidth + 1, 1, cellWidth - 1, 18)];
    [columnHeader setBackgroundColor:[UIColor whiteColor]];
    [columnHeader setTextColor:[UIColor blackColor]];
    [columnHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
    [columnHeader setTextAlignment:NSTextAlignmentCenter];
    [columnHeader setText:@"Variable"];
    [underTheFirstColumnView addSubview:columnHeader];
    
    float cellPositionAdjustment = 1.0;
    columnHeader = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, 1, cellWidth, 18)];
    [columnHeader setBackgroundColor:[UIColor whiteColor]];
    [columnHeader setTextColor:[UIColor blackColor]];
    [columnHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
    [columnHeader setTextAlignment:NSTextAlignmentCenter];
    [columnHeader setText:@"Odds Ratio"];
    [oddsAndRiskTableView addSubview:columnHeader];
    
    cellPositionAdjustment = 2.0;
    columnHeader = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, 1, cellWidth, 18)];
    [columnHeader setBackgroundColor:[UIColor whiteColor]];
    [columnHeader setTextColor:[UIColor blackColor]];
    [columnHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
    [columnHeader setTextAlignment:NSTextAlignmentCenter];
    [columnHeader setText:@"OR LL"];
    [oddsAndRiskTableView addSubview:columnHeader];
    
    cellPositionAdjustment = 3.0;
    columnHeader = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, 1, cellWidth, 18)];
    [columnHeader setBackgroundColor:[UIColor whiteColor]];
    [columnHeader setTextColor:[UIColor blackColor]];
    [columnHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
    [columnHeader setTextAlignment:NSTextAlignmentCenter];
    [columnHeader setText:@"OR UL"];
    [oddsAndRiskTableView addSubview:columnHeader];
    
    cellPositionAdjustment = 4.0;
    columnHeader = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, 1, cellWidth, 18)];
    [columnHeader setBackgroundColor:[UIColor whiteColor]];
    [columnHeader setTextColor:[UIColor blackColor]];
    [columnHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
    [columnHeader setTextAlignment:NSTextAlignmentCenter];
    [columnHeader setText:@"Relative Risk"];
    [oddsAndRiskTableView addSubview:columnHeader];
    
    cellPositionAdjustment = 5.0;
    columnHeader = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, 1, cellWidth, 18)];
    [columnHeader setBackgroundColor:[UIColor whiteColor]];
    [columnHeader setTextColor:[UIColor blackColor]];
    [columnHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
    [columnHeader setTextAlignment:NSTextAlignmentCenter];
    [columnHeader setText:@"RR LL"];
    [oddsAndRiskTableView addSubview:columnHeader];
    
    cellPositionAdjustment = 6.0;
    columnHeader = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, 1, cellWidth, 18)];
    [columnHeader setBackgroundColor:[UIColor whiteColor]];
    [columnHeader setTextColor:[UIColor blackColor]];
    [columnHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
    [columnHeader setTextAlignment:NSTextAlignmentCenter];
    [columnHeader setText:@"RR UL"];
    [oddsAndRiskTableView addSubview:columnHeader];
    
    for (int orindex = 0; orindex < [oddsAndRisk count]; orindex++)
    {
        float yPos = 20.0 + orindex * 20.0;
        
        UILabel *rowHeader = [[UILabel alloc] initWithFrame:CGRectMake(0 * cellWidth + 1, yPos, cellWidth - 1, 19)];
        [rowHeader setBackgroundColor:[UIColor whiteColor]];
        [rowHeader setTextColor:[UIColor blackColor]];
        NSString *variableName = [[oddsAndRisk objectAtIndex:orindex] objectAtIndex:0];
        float fontSize = 14.0;
        while ([variableName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]}].width > rowHeader.frame.size.width - 0.0)
            fontSize -= 0.1;
        [rowHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]];
        [rowHeader setTextAlignment:NSTextAlignmentLeft];
        [rowHeader setText:variableName];
        [underTheFirstColumnView addSubview:rowHeader];
        
        cellPositionAdjustment = 1.0;
        UILabel *statValue = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, yPos, cellWidth, 19)];
        [statValue setBackgroundColor:[UIColor whiteColor]];
        [statValue setTextColor:[UIColor blackColor]];
        [statValue setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [statValue setTextAlignment:NSTextAlignmentCenter];
        [statValue setText:[NSString stringWithFormat:@"%.2f", [[[oddsAndRisk objectAtIndex:orindex] objectAtIndex:1] floatValue]]];
        [oddsAndRiskTableView addSubview:statValue];
        
        cellPositionAdjustment = 2.0;
        statValue = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, yPos, cellWidth, 19)];
        [statValue setBackgroundColor:[UIColor whiteColor]];
        [statValue setTextColor:[UIColor blackColor]];
        [statValue setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [statValue setTextAlignment:NSTextAlignmentCenter];
        [statValue setText:[NSString stringWithFormat:@"%.2f", [[[oddsAndRisk objectAtIndex:orindex] objectAtIndex:2] floatValue]]];
        [oddsAndRiskTableView addSubview:statValue];
        
        cellPositionAdjustment = 3.0;
        statValue = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, yPos, cellWidth, 19)];
        [statValue setBackgroundColor:[UIColor whiteColor]];
        [statValue setTextColor:[UIColor blackColor]];
        [statValue setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [statValue setTextAlignment:NSTextAlignmentCenter];
        [statValue setText:[NSString stringWithFormat:@"%.2f", [[[oddsAndRisk objectAtIndex:orindex] objectAtIndex:3] floatValue]]];
        [oddsAndRiskTableView addSubview:statValue];
        
        cellPositionAdjustment = 4.0;
        statValue = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, yPos, cellWidth, 19)];
        [statValue setBackgroundColor:[UIColor whiteColor]];
        [statValue setTextColor:[UIColor blackColor]];
        [statValue setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [statValue setTextAlignment:NSTextAlignmentCenter];
        [statValue setText:[NSString stringWithFormat:@"%.2f", [[[oddsAndRisk objectAtIndex:orindex] objectAtIndex:4] floatValue]]];
        [oddsAndRiskTableView addSubview:statValue];
        
        cellPositionAdjustment = 5.0;
        statValue = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, yPos, cellWidth, 19)];
        [statValue setBackgroundColor:[UIColor whiteColor]];
        [statValue setTextColor:[UIColor blackColor]];
        [statValue setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [statValue setTextAlignment:NSTextAlignmentCenter];
        [statValue setText:[NSString stringWithFormat:@"%.2f", [[[oddsAndRisk objectAtIndex:orindex] objectAtIndex:5] floatValue]]];
        [oddsAndRiskTableView addSubview:statValue];
        
        cellPositionAdjustment = 6.0;
        statValue = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, yPos, cellWidth, 19)];
        [statValue setBackgroundColor:[UIColor whiteColor]];
        [statValue setTextColor:[UIColor blackColor]];
        [statValue setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [statValue setTextAlignment:NSTextAlignmentCenter];
        [statValue setText:[NSString stringWithFormat:@"%.2f", [[[oddsAndRisk objectAtIndex:orindex] objectAtIndex:6] floatValue]]];
        [oddsAndRiskTableView addSubview:statValue];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [outputV addSubview:oddsAndRiskTableView];
        [outputV addSubview:underTheFirstColumnView];
        [outputV addSubview:rightBorderView];
        [outputV addSubview:rightOfTheTableView];
    });
}

- (CGSize)doMxN:(TablesObject *)to OnOutputView:(UIView *)outputV StratificationVariable:(NSString *)stratVar StratificationValue:(NSString *)stratValue
{
    
    //Offset for stratum labels if stratified
    float stratificationOffset = 0.0;
    if (stratVar)
    {
        stratificationOffset = 40.0;
        EpiInfoUILabel *stratumHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, 313, 40)];
        [stratumHeader setBackgroundColor:[UIColor clearColor]];
        [stratumHeader setTextColor:epiInfoLightBlue];
        [stratumHeader setText:[NSString stringWithFormat:@"%@ = %@", stratVar, stratValue]];
        [stratumHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [stratumHeader setTextAlignment:NSTextAlignmentCenter];
        dispatch_async(dispatch_get_main_queue(), ^{
          [outputV addSubview:stratumHeader];
        });
    }
    else
        stratificationOffset = contentSizeHeight;

    //Get the dimensions of the table and the size of the outputTableView
    float numberOfOutcomeValues = (float)to.outcomeValues.count;
    float numberOfExposureValues = (float)to.exposureValues.count;
    float cellWidth = 76;
    outputTableViewWidth = 81.0 + (numberOfOutcomeValues + 1.0) * cellWidth + numberOfOutcomeValues * 2.0;
    outputTableViewHeight = 44 + (numberOfExposureValues + 1.0) * 40.0 + numberOfExposureValues * 2.0;
    
    //Set initial font sizes
    float outcomeVariableLabelFontSize = 16.0;
    float exposureVariableLabelFontSize = 16.0;
    float outcomeValueFontSize = 16.0;
    float exposureValueFontSize = 16.0;
    
    //Add outputTableView with above dimensions
    outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, outputTableViewWidth, outputTableViewHeight)];
    [outputTableView setBackgroundColor:epiInfoLightBlue];
    [outputTableView.layer setCornerRadius:10.0];
    dispatch_async(dispatch_get_main_queue(), ^{
      [outputV addSubview:outputTableView];
    });
  
    //Set dimensions for variable labels
    float outcomeVariableLabelWidth = (numberOfOutcomeValues + 1) * cellWidth + numberOfOutcomeValues * 2.0;
    float exposureVariableLabelWidth = (numberOfExposureValues + 1) * 40.0 + numberOfExposureValues * 2.0;
    float exposureVariableLabelX = 15.0 - exposureVariableLabelWidth / 2.0;
    float exposureVariableLabelY = 40 + exposureVariableLabelWidth / 2.0 - 10.0;
    
    //Reduce font sizes until they fit
//    while ([to.outcomeVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]].width > outcomeVariableLabelWidth)
    // Deprecation replacement
    while ([to.outcomeVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]}].width > outcomeVariableLabelWidth)
        outcomeVariableLabelFontSize -= 0.1;
//    while ([to.exposureVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]].width > exposureVariableLabelWidth)
    // Deprecation replacement
    while ([to.exposureVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]}].width > exposureVariableLabelWidth)
        exposureVariableLabelFontSize -= 0.1;
    float outcomeValueWidthWithFont = 0.0;
    for (int i = 0; i < to.outcomeValues.count; i++)
    {
        NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
        if ([[to.outcomeValues objectAtIndex:i] isKindOfClass:[NSNull class]])
            tempStr = @"Missing";
        else if ([[to.outcomeValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.outcomeValues objectAtIndex:i] isEqualToString:@"(null)"])
            tempStr = @"Missing";
//        outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
        // Deprecation replacement
        outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
    }
    float exposureValueWidthWithFont = 0.0;
    for (int i = 0; i < to.exposureValues.count; i++)
    {
        NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
        if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSNull class]])
            tempStr = @"Missing";
        else if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.exposureValues objectAtIndex:i] isEqualToString:@"(null)"])
            tempStr = @"Missing";
//        exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
        // Deprecation replacement
        exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
    }
    while (outcomeValueWidthWithFont > cellWidth)
    {
        outcomeValueFontSize -= 0.1;
        outcomeValueWidthWithFont = 0.0;
        for (int i = 0; i < to.outcomeValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
            if ([[to.outcomeValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                tempStr = @"Missing";
            else if ([[to.outcomeValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.outcomeValues objectAtIndex:i] isEqualToString:@"(null)"])
                tempStr = @"Missing";
            outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
        }
    }
    while (exposureValueWidthWithFont > 50)
    {
        exposureValueFontSize -= 0.1;
        exposureValueWidthWithFont = 0.0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
            if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                tempStr = @"Missing";
            else if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.exposureValues objectAtIndex:i] isEqualToString:@"(null)"])
                tempStr = @"Missing";
            exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
        }
    }
    
    EpiInfoUILabel *outcomeVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79, 0, outcomeVariableLabelWidth, 20)];
    [outcomeVariableLabel setText:to.outcomeVariable];
    [outcomeVariableLabel setTextAlignment:NSTextAlignmentLeft];
    [outcomeVariableLabel setTextColor:[UIColor whiteColor]];
    [outcomeVariableLabel setBackgroundColor:[UIColor clearColor]];
    [outcomeVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]];
    dispatch_async(dispatch_get_main_queue(), ^{
      [outputTableView addSubview:outcomeVariableLabel];
    });
    EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(exposureVariableLabelX, exposureVariableLabelY, exposureVariableLabelWidth, 20)];
    [exposureVariableLabel setText:to.exposureVariable];
    [exposureVariableLabel setTextAlignment:NSTextAlignmentRight];
    [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
    [exposureVariableLabel setTextColor:[UIColor whiteColor]];
    [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
    [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [outputTableView addSubview:exposureVariableLabel];
    });

    int rowTotals[(int)numberOfExposureValues];
    int columnTotals[(int)numberOfOutcomeValues];
    for (int i = 0; i < numberOfExposureValues; i++)
        rowTotals[i] = 0;
    for (int j = 0; j < numberOfOutcomeValues; j++)
        columnTotals[j] = 0;
    int k = 0;
    for (int i = 0; i < to.exposureValues.count; i++)
        for (int j = 0; j < to.outcomeValues.count; j++)
    {
        rowTotals[i] += [(NSNumber *)[to.cellCounts objectAtIndex:k] intValue];
        columnTotals[j] += [(NSNumber *)[to.cellCounts objectAtIndex:k] intValue];
        k++;
    }
    
    NSMutableArray *fisherTestArray = [[NSMutableArray alloc] init];
    k = 0;
    for (int i = 0; i < to.exposureValues.count; i++)
    {
        NSMutableArray *fisherRowArray = [[NSMutableArray alloc] init];
        EpiInfoUILabel *exposureValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(27, 42 + i * 42, 50, 40)];
        [exposureValueLabel setBackgroundColor:[UIColor clearColor]];
        [exposureValueLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureValueLabel setTextColor:[UIColor whiteColor]];
        [exposureValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]];
        if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSNull class]])
            [exposureValueLabel setText:@"Missing"];
        else if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.exposureValues objectAtIndex:i] isEqualToString:@"(null)"])
            [exposureValueLabel setText:@"Missing"];
        else
            [exposureValueLabel setText:[NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]]];
        [fisherRowArray addObject:[exposureValueLabel text]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:exposureValueLabel];
        });
        for (int j = 0; j < to.outcomeValues.count; j++)
        {
            if (i == 0)
            {
                EpiInfoUILabel *outcomeValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 20, cellWidth, 20)];
                [outcomeValueLabel setBackgroundColor:[UIColor clearColor]];
                [outcomeValueLabel setTextAlignment:NSTextAlignmentCenter];
                [outcomeValueLabel setTextColor:[UIColor whiteColor]];
                [outcomeValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]];
                if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSNull class]])
                    [outcomeValueLabel setText:@"Missing"];
                else if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSString class]] && [[to.outcomeValues objectAtIndex:j] isEqualToString:@"(null)"])
                    [outcomeValueLabel setText:@"Missing"];
                else
                    [outcomeValueLabel setText:[NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:j]]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [outputTableView addSubview:outcomeValueLabel];
                });
            }
            UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 42 + i * 42, cellWidth, 40)];
            [countView setBackgroundColor:[UIColor whiteColor]];
            [countView.layer setCornerRadius:10.0];
            EpiInfoUILabel *countLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
            [countLabel setText:[NSString stringWithFormat:@"%@", [to.cellCounts objectAtIndex:k]]];
            [countLabel setTextAlignment:NSTextAlignmentCenter];
            [countLabel setBackgroundColor:[UIColor clearColor]];
            [countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [fisherRowArray addObject:[countLabel text]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [countView addSubview:countLabel];
            });
            EpiInfoUILabel *rowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
            [rowPctLabel setTextAlignment:NSTextAlignmentRight];
            [rowPctLabel setBackgroundColor:[UIColor clearColor]];
            [rowPctLabel setTextColor:[UIColor lightGrayColor]];
            [rowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * [(NSNumber *)[to.cellCounts objectAtIndex:k] floatValue] / (float)rowTotals[i]]];
            [countView addSubview:rowPctLabel];
            EpiInfoUILabel *colPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
            [colPctLabel setTextAlignment:NSTextAlignmentRight];
            [colPctLabel setBackgroundColor:[UIColor clearColor]];
            [colPctLabel setTextColor:[UIColor lightGrayColor]];
            [colPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * [(NSNumber *)[to.cellCounts objectAtIndex:k] floatValue] / (float)columnTotals[j]]];
            [countView addSubview:colPctLabel];
            dispatch_async(dispatch_get_main_queue(), ^{
                [outputTableView addSubview:countView];
            });
            k++;
        }
        [fisherTestArray addObject:fisherRowArray];
    }
    int grandTotal = 0;
    for (int i = 0; i < to.exposureValues.count; i++)
        grandTotal += rowTotals[i];
    for (int i = 0; i < to.exposureValues.count; i++)
    {
        UIView *rowView = [[UIView alloc] initWithFrame:CGRectMake(79 + numberOfOutcomeValues * (cellWidth + 2), 42 + (float)i * 42.0, cellWidth, 40)];
        [rowView setBackgroundColor:[UIColor whiteColor]];
        [rowView.layer setCornerRadius:10.0];
        EpiInfoUILabel *rowTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [rowTotal setTextAlignment:NSTextAlignmentCenter];
        [rowTotal setText:[NSString stringWithFormat:@"%d", rowTotals[i]]];
        [rowTotal setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [rowTotal setBackgroundColor:[UIColor clearColor]];
        [rowView addSubview:rowTotal];
        EpiInfoUILabel *rowRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [rowRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowRowPctLabel setText:@"100%"];
        [rowView addSubview:rowRowPctLabel];
        EpiInfoUILabel *rowColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)rowTotals[i] / (float)grandTotal]];
        [rowView addSubview:rowColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:rowView];
        });
    }
    for (int j = 0; j < to.outcomeValues.count; j++)
    {
        UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake(79 + (float)j * (cellWidth + 2.0), (numberOfExposureValues + 1.0) * 42.0, cellWidth, 40)];
        [columnView setBackgroundColor:[UIColor whiteColor]];
        [columnView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnTotal setTextAlignment:NSTextAlignmentCenter];
        [columnTotal setText:[NSString stringWithFormat:@"%d", columnTotals[j]]];
        [columnTotal setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [columnTotal setBackgroundColor:[UIColor clearColor]];
        [columnView addSubview:columnTotal];
        EpiInfoUILabel *colRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [colRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [colRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [colRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [colRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)columnTotals[j] / (float)grandTotal]];
        [columnView addSubview:colRowPctLabel];
        EpiInfoUILabel *colColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colColPctLabel setText:@"100%"];
        [columnView addSubview:colColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:columnView];
        });
    }
    
    UIView *totalTotalView = [[UIView alloc] initWithFrame:CGRectMake(79 + numberOfOutcomeValues * (cellWidth + 2), (numberOfExposureValues + 1.0) * 42.0, cellWidth, 40)];
    [totalTotalView setBackgroundColor:[UIColor whiteColor]];
    [totalTotalView.layer setCornerRadius:10.0];
    EpiInfoUILabel *totalTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
    [totalTotal setTextAlignment:NSTextAlignmentCenter];
    [totalTotal setText:[NSString stringWithFormat:@"%d", grandTotal]];
    [totalTotal setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [totalTotal setBackgroundColor:[UIColor clearColor]];
    [totalTotalView addSubview:totalTotal];
    EpiInfoUILabel *totalRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
    [totalRowPctLabel setTextAlignment:NSTextAlignmentRight];
    [totalRowPctLabel setBackgroundColor:[UIColor clearColor]];
    [totalRowPctLabel setTextColor:[UIColor lightGrayColor]];
    [totalRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
    [totalRowPctLabel setText:@"100%"];
    [totalTotalView addSubview:totalRowPctLabel];
    EpiInfoUILabel *totalColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
    [totalColPctLabel setTextAlignment:NSTextAlignmentRight];
    [totalColPctLabel setBackgroundColor:[UIColor clearColor]];
    [totalColPctLabel setTextColor:[UIColor lightGrayColor]];
    [totalColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
    [totalColPctLabel setText:@"100%"];
    [totalTotalView addSubview:totalColPctLabel];
    dispatch_async(dispatch_get_main_queue(), ^{
        [outputTableView addSubview:totalTotalView];
    });
    
    //Compute the chi square for the table
    if (to.exposureValues.count > 1 && to.outcomeValues.count > 1)
    {
        double chiSq = 0.0;
        BOOL lowExpectation = NO;
        double totals[to.outcomeValues.count + 1];
        totals[to.outcomeValues.count] = 0.0;
        double rowtotals[to.exposureValues.count];
        k = 0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            rowtotals[i] = 0.0;
            for (int j = 0; j < to.outcomeValues.count; j++)
            {
                if (i == 0)
                    totals[j] = 0.0;
                totals[j] += [[to.cellCounts objectAtIndex:k] doubleValue];
                totals[to.outcomeValues.count] += [[to.cellCounts objectAtIndex:k] doubleValue];
                rowtotals[i] += [[to.cellCounts objectAtIndex:k++] doubleValue];
            }
        }
        double ps[to.outcomeValues.count];
        for (int i = 0; i < to.outcomeValues.count; i++)
        {
            ps[i] = totals[i] / totals[to.outcomeValues.count];
        }
        k = 0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            for (int j = 0; j < to.outcomeValues.count; j++)
            {
                double observed = [[to.cellCounts objectAtIndex:k++] doubleValue];
                double expected = rowtotals[i] * ps[j];
                double OminusESqOverE = pow(observed - expected, 2.0) / expected;
                chiSq += OminusESqOverE;
                if (expected < 5.0)
                    lowExpectation = YES;
            }
        }
        double chiSqP = [SharedResources PValFromChiSq:chiSq PVFCSdf:(double)((to.exposureValues.count - 1) * (to.outcomeValues.count - 1))];
        float fExact = 1.0;
        @try {
            fExact = [FEXACT FEXACT:[NSArray arrayWithArray:fisherTestArray]];
        } @catch (NSException *exception) {
            NSLog(@"Exception in FEXACT: %@", exception);
            fExact = -INFINITY;
        } @finally {
            //
        }
        EpiInfoUILabel *chiSqLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(outputTableView.frame.origin.x, outputTableView.frame.origin.y + outputTableView.frame.size.height, outputTableView.frame.size.width, 20)];
        [chiSqLabel setBackgroundColor:[UIColor clearColor]];
        [chiSqLabel setText:[NSString stringWithFormat:@"Chi Square: %.2f, df: %lu, p-value: %.3f", chiSq, (to.exposureValues.count - 1) * (to.outcomeValues.count - 1), chiSqP]];
        [chiSqLabel setAccessibilityLabel:[NSString stringWithFormat:@"Ky Square: %.2f, degrees of freedom: %lu, p-value: %.3f", chiSq, (to.exposureValues.count - 1) * (to.outcomeValues.count - 1), chiSqP]];
        [chiSqLabel setTextAlignment:NSTextAlignmentCenter];
        [chiSqLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        
        EpiInfoUILabel *fisherLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(outputTableView.frame.origin.x, outputTableView.frame.origin.y + outputTableView.frame.size.height + 20, outputTableView.frame.size.width, 20)];
        [fisherLabel setBackgroundColor:[UIColor clearColor]];
        [fisherLabel setText:[NSString stringWithFormat:@"Fisher's Exact: %.4f", fExact]];
        [fisherLabel setAccessibilityLabel:[NSString stringWithFormat:@"Fisher's Exact: %.4f", fExact]];
        if (fExact == -INFINITY)
        {
            [fisherLabel setText:@"Cannot compute Fisher's Exact; too many iterations."];
            [fisherLabel setAccessibilityLabel:@"Cannot compute Fisher's Exact; too many iterations."];
        }
        [fisherLabel setTextAlignment:NSTextAlignmentCenter];
        [fisherLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview: chiSqLabel];
            if (fExact < 1.0)
                [outputV addSubview:fisherLabel];
        });
        outputTableViewHeight += chiSqLabel.frame.size.height;
        outputTableViewHeight += fisherLabel.frame.size.height;
        if (lowExpectation)
        {
            EpiInfoUILabel *lowExpectationLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, fisherLabel.frame.origin.y + 20.0, chiSqLabel.frame.size.width, 20)];
            [lowExpectationLabel setBackgroundColor:[UIColor clearColor]];
            [lowExpectationLabel setText:@"An expected cell count is <5. Chi squared may not be valid."];
            [lowExpectationLabel setAccessibilityLabel:@"An expected cell count is <5. Ky squared may not be valid."];
            [lowExpectationLabel setTextAlignment:NSTextAlignmentCenter];
            [lowExpectationLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [outputV addSubview:lowExpectationLabel];
            });
            outputTableViewHeight += lowExpectationLabel.frame.size.height;
        }
    }
    
    //Set the parent view controller's content size for scrolling
//    [avc setContentSize:CGSizeMake(MAX(self.frame.size.width, outputTableViewWidth + 4.0), MAX(self.frame.size.height, outputTableViewHeight + 110.0))];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [outputV setFrame:CGRectMake(outputV.frame.origin.x, outputV.frame.origin.y, MAX(outputV.frame.size.width, outputTableViewWidth), outputTableViewHeight + outputTableView.frame.origin.y)];
    });
    if (stratVar)
        return CGSizeMake(MAX(self.frame.size.width, outputTableViewWidth + 4.0), outputTableViewHeight + outputTableView.frame.origin.y + 110.0);

    return CGSizeMake(MAX(self.frame.size.width, outputTableViewWidth + 4.0), outputTableViewHeight + 16.0);// + outputTableView.frame.origin.y + 150.0);
}

- (void)doTwoByTwo:(TablesObject *)to OnOutputView:(UIView *)outputV StratificationVariable:(NSString *)stratVar StratificationValue:(NSString *)stratValue
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        twoByTwoDisplayed = YES;
        
        //Offset for stratum labels if stratified
        float stratificationOffset = 0.0;
        if (stratVar)
        {
            stratificationOffset = 40.0;
            EpiInfoUILabel *stratumHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, outputV.frame.size.width, 40)];
            [stratumHeader setBackgroundColor:[UIColor clearColor]];
            [stratumHeader setTextColor:epiInfoLightBlue];
            [stratumHeader setText:[NSString stringWithFormat:@"%@ = %@", stratVar, stratValue]];
            [stratumHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [stratumHeader setTextAlignment:NSTextAlignmentCenter];
            dispatch_async(dispatch_get_main_queue(), ^{
                [outputV addSubview:stratumHeader];
            });
        }
        else
            stratificationOffset = contentSizeHeight;
//            stratificationOffset = 550 * workingExposure + 20.0 * (numberOfExposures + 1) + 2;
        
        //Make the view for the actual 2x2 table
        outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 168)];
        [outputTableView setBackgroundColor:epiInfoLightBlue];
        [outputTableView.layer setCornerRadius:10.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:outputTableView];
        });

        double cellWidth = 76;
        
        //Set initial font sizes
        float outcomeVariableLabelFontSize = 16.0;
        float exposureVariableLabelFontSize = 16.0;
        float outcomeValueFontSize = 16.0;
        float exposureValueFontSize = 16.0;
        
        //Reduce font sizes until they fit
        //        while ([to.outcomeVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]].width > 120)
        // Deprecation replacement
        while ([to.outcomeVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]}].width > 120)
            outcomeVariableLabelFontSize -= 0.1;
        //        while ([to.exposureVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]].width > 120)
        // Deprecation replacement
        while ([to.exposureVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]}].width > 120)
            exposureVariableLabelFontSize -= 0.1;
        float outcomeValueWidthWithFont = 0.0;
        for (int i = 0; i < to.outcomeValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
            outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
        }
        float exposureValueWidthWithFont = 0.0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
            exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
        }
        while (outcomeValueWidthWithFont > cellWidth)
        {
            outcomeValueFontSize -= 0.1;
            outcomeValueWidthWithFont = 0.0;
            for (int i = 0; i < to.outcomeValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
                outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
            }
        }
        while (exposureValueWidthWithFont > 50)
        {
            exposureValueFontSize -= 0.1;
            exposureValueWidthWithFont = 0.0;
            for (int i = 0; i < to.exposureValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
                exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
            }
        }
        
        EpiInfoUILabel *outcomeVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79, 0, 2 * cellWidth + 2, 20)];
        [outcomeVariableLabel setText:to.outcomeVariable];
        [outcomeVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [outcomeVariableLabel setTextColor:[UIColor whiteColor]];
        [outcomeVariableLabel setBackgroundColor:[UIColor clearColor]];
        [outcomeVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:outcomeVariableLabel];
        });
        EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(-45, 70, 120, 20)];
        [exposureVariableLabel setText:to.exposureVariable];
        [exposureVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        [exposureVariableLabel setTextColor:[UIColor whiteColor]];
        [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
        [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:exposureVariableLabel];
        });

        int yy = [(NSNumber *)[to.cellCounts objectAtIndex:0] intValue];
        int yn = [(NSNumber *)[to.cellCounts objectAtIndex:1] intValue];
        int ny = [(NSNumber *)[to.cellCounts objectAtIndex:2] intValue];
        int nn = [(NSNumber *)[to.cellCounts objectAtIndex:3] intValue];
        
        int k = 0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            EpiInfoUILabel *exposureValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(27, 42 + i * 42, 50, 40)];
            [exposureValueLabel setBackgroundColor:[UIColor clearColor]];
            [exposureValueLabel setTextAlignment:NSTextAlignmentCenter];
            [exposureValueLabel setTextColor:[UIColor whiteColor]];
            [exposureValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]];
            if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                [exposureValueLabel setText:@"Missing"];
            else if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.exposureValues objectAtIndex:i] isEqualToString:@"(null)"])
                [exposureValueLabel setText:@"Missing"];
            else
                [exposureValueLabel setText:[NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [outputTableView addSubview:exposureValueLabel];
            });
            for (int j = 0; j < to.outcomeValues.count; j++)
            {
                if (i == 0)
                {
                    EpiInfoUILabel *outcomeValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 20, cellWidth, 20)];
                    [outcomeValueLabel setBackgroundColor:[UIColor clearColor]];
                    [outcomeValueLabel setTextAlignment:NSTextAlignmentCenter];
                    [outcomeValueLabel setTextColor:[UIColor whiteColor]];
                    [outcomeValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]];
                    if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSNull class]])
                        [outcomeValueLabel setText:@"Missing"];
                    else if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSString class]] && [[to.outcomeValues objectAtIndex:j] isEqualToString:@"(null)"])
                        [outcomeValueLabel setText:@"Missing"];
                    else
                        [outcomeValueLabel setText:[NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:j]]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [outputTableView addSubview:outcomeValueLabel];
                    });
                }
                UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 42 + i * 42, cellWidth, 40)];
                [countView setBackgroundColor:[UIColor whiteColor]];
                [countView.layer setCornerRadius:10.0];
                EpiInfoUILabel *countLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
                [countLabel setText:[NSString stringWithFormat:@"%@", [to.cellCounts objectAtIndex:k]]];
                [countLabel setTextAlignment:NSTextAlignmentCenter];
                [countLabel setBackgroundColor:[UIColor clearColor]];
                [countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [countView addSubview:countLabel];
                EpiInfoUILabel *rowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
                [rowPctLabel setTextAlignment:NSTextAlignmentRight];
                [rowPctLabel setBackgroundColor:[UIColor clearColor]];
                [rowPctLabel setTextColor:[UIColor lightGrayColor]];
                [rowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
                [countView addSubview:rowPctLabel];
                EpiInfoUILabel *colPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
                [colPctLabel setTextAlignment:NSTextAlignmentRight];
                [colPctLabel setBackgroundColor:[UIColor clearColor]];
                [colPctLabel setTextColor:[UIColor lightGrayColor]];
                [colPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
                [countView addSubview:colPctLabel];
                if (i == 0)
                {
                    if (j == 0)
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yy / (float)(yy + yn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yy / (float)(yy + ny)]];
                    }
                    else
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yn / (float)(yy + yn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yn / (float)(yn + nn)]];
                    }
                }
                else
                {
                    if (j == 0)
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)ny / (float)(ny + nn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)ny / (float)(yy + ny)]];
                    }
                    else
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)nn / (float)(ny + nn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)nn / (float)(yn + nn)]];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [outputTableView addSubview:countView];
                });
                k++;
            }
        }
        
        UIView *rowOneView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 42, cellWidth, 40)];
        [rowOneView setBackgroundColor:[UIColor whiteColor]];
        [rowOneView.layer setCornerRadius:10.0];
        EpiInfoUILabel *rowOneTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [rowOneTotal setTextAlignment:NSTextAlignmentCenter];
        [rowOneTotal setText:[NSString stringWithFormat:@"%d", yy + yn]];
        [rowOneTotal setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [rowOneTotal setBackgroundColor:[UIColor clearColor]];
        [rowOneView addSubview:rowOneTotal];
        EpiInfoUILabel *rowOneRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [rowOneRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowOneRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowOneRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowOneRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowOneRowPctLabel setText:@"100%"];
        [rowOneView addSubview:rowOneRowPctLabel];
        EpiInfoUILabel *rowOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowOneColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowOneColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + yn) / (float)(yy + yn + ny + nn)]];
        [rowOneView addSubview:rowOneColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:rowOneView];
        });
        UIView *rowTwoView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 84, cellWidth, 40)];
        [rowTwoView setBackgroundColor:[UIColor whiteColor]];
        [rowTwoView.layer setCornerRadius:10.0];
        EpiInfoUILabel *rowTwoTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [rowTwoTotal setTextAlignment:NSTextAlignmentCenter];
        [rowTwoTotal setText:[NSString stringWithFormat:@"%d", ny + nn]];
        [rowTwoTotal setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [rowTwoTotal setBackgroundColor:[UIColor clearColor]];
        [rowTwoView addSubview:rowTwoTotal];
        EpiInfoUILabel *rowTwoRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [rowTwoRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowTwoRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowTwoRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowTwoRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowTwoRowPctLabel setText:@"100%"];
        [rowTwoView addSubview:rowTwoRowPctLabel];
        EpiInfoUILabel *rowTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowTwoColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowTwoColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(ny + nn) / (float)(yy + yn + ny + nn)]];
        [rowTwoView addSubview:rowTwoColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:rowTwoView];
        });

        UIView *columnOneView = [[UIView alloc] initWithFrame:CGRectMake(79, 126, cellWidth, 40)];
        [columnOneView setBackgroundColor:[UIColor whiteColor]];
        [columnOneView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnOneTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnOneTotal setTextAlignment:NSTextAlignmentCenter];
        [columnOneTotal setText:[NSString stringWithFormat:@"%d", yy + ny]];
        [columnOneTotal setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [columnOneTotal setBackgroundColor:[UIColor clearColor]];
        [columnOneView addSubview:columnOneTotal];
        EpiInfoUILabel *colOneRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [colOneRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [colOneRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [colOneRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [colOneRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colOneRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + ny) / (float)(yy + yn + ny + nn)]];
        [columnOneView addSubview:colOneRowPctLabel];
        EpiInfoUILabel *colOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colOneColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colOneColPctLabel setText:@"100%"];
        [columnOneView addSubview:colOneColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:columnOneView];
        });
        UIView *columnTwoView = [[UIView alloc] initWithFrame:CGRectMake(79 + cellWidth + 2, 126, cellWidth, 40)];
        [columnTwoView setBackgroundColor:[UIColor whiteColor]];
        [columnTwoView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnTwoTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnTwoTotal setTextAlignment:NSTextAlignmentCenter];
        [columnTwoTotal setText:[NSString stringWithFormat:@"%d", yn + nn]];
        [columnTwoTotal setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [columnTwoTotal setBackgroundColor:[UIColor clearColor]];
        [columnTwoView addSubview:columnTwoTotal];
        EpiInfoUILabel *colTwoRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [colTwoRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [colTwoRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [colTwoRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [colTwoRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colTwoRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yn + nn) / (float)(yy + yn + ny + nn)]];
        [columnTwoView addSubview:colTwoRowPctLabel];
        EpiInfoUILabel *colTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colTwoColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colTwoColPctLabel setText:@"100%"];
        [columnTwoView addSubview:colTwoColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:columnTwoView];
        });

        UIView *totalTotalView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 126, cellWidth, 40)];
        [totalTotalView setBackgroundColor:[UIColor whiteColor]];
        [totalTotalView.layer setCornerRadius:10.0];
        EpiInfoUILabel *totalTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [totalTotal setTextAlignment:NSTextAlignmentCenter];
        [totalTotal setText:[NSString stringWithFormat:@"%d", yy + yn + ny + nn]];
        [totalTotal setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [totalTotal setBackgroundColor:[UIColor clearColor]];
        [totalTotalView addSubview:totalTotal];
        EpiInfoUILabel *totalRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [totalRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [totalRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [totalRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [totalRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [totalRowPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalRowPctLabel];
        EpiInfoUILabel *totalColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [totalColPctLabel setTextAlignment:NSTextAlignmentRight];
        [totalColPctLabel setBackgroundColor:[UIColor clearColor]];
        [totalColPctLabel setTextColor:[UIColor lightGrayColor]];
        [totalColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [totalColPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:totalTotalView];
        });

        //Compute and display the statistics
        Twox2Compute *computer = [[Twox2Compute alloc] init];
        double oddsRatio = [computer OddsRatioEstimate:yy cellb:yn cellc:ny celld:nn];
        double oddsRatioLower = [computer OddsRatioLower:yy cellb:yn cellc:ny celld:nn];
        double oddsRatioUpper = [computer OddsRatioUpper:yy cellb:yn cellc:ny celld:nn];
        double ExactResults[4];
        [computer CalcPoly:yy CPyn:yn CPny:ny CPnn:nn CPExactResults:ExactResults];
        double lowerMidP = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:NO];
        double upperMidP = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:NO];
        double lowerFisher = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:YES];
        double upperFisher = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:YES];
        double RRstats[12];
        [computer RRStats:yy RRSb:yn RRSc:ny RRSd:nn RRSstats:RRstats];
        
        //Add the views for each section of statistics
        oddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 172 + stratificationOffset, 313, 110)];
        [oddsBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [oddsBasedParametersView.layer setCornerRadius:10.0];

        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 284 + stratificationOffset, 313, 88)];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [riskBasedParametersView.layer setCornerRadius:10.0];

        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 374 + stratificationOffset, 313, 176)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
        [statisticalTestsView.layer setCornerRadius:10.0];

        //Add labels to each of the views
        float fourWidth0 = 78;
        float fourWidth1 = 75;
        float threeWidth0 = 105;
        float threewidth1 = 100;
        
        EpiInfoUILabel *gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, oddsBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Odds-based Parameters"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Estimate"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Lower"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Upper"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Odds Ratio"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatio]];
        [oddsBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSString stringWithString:to.exposureVariable]];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:oddsRatio]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatioLower]];
        [oddsBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:oddsRatioLower]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatioUpper]];
        [oddsBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:oddsRatioUpper]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" MLE OR"];
        [gridBox setAccessibilityLabel:@"M.L.E. Odds Ratio"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", ExactResults[0]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", lowerMidP]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", upperMidP]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, fourWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Fisher Exact"];
        [oddsBasedParametersView addSubview:gridBox];
        UIView *ew = [[UIView alloc] initWithFrame:CGRectMake(2 + fourWidth0 / 2.0, 88, fourWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 88, fourWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:nil];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", lowerFisher]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 88, fourWidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", upperFisher]];
        [oddsBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 88, fourWidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 88, fourWidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, riskBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Risk-based Parameters"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Estimate"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Lower"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Upper"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
        [gridBox setText:@" Relative Risk"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[0]]];
        [riskBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:RRstats[0]]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[1]]];
        [riskBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:RRstats[1]]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[2]]];
        [riskBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:RRstats[2]]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
        [gridBox setText:@" Risk Difference"];
        [riskBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + fourWidth0 / 2.0, 66, fourWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[3]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[4]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[5]]];
        [riskBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, statisticalTestsView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Statistical Tests"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"X2"];
        [gridBox setAccessibilityLabel:@"Ky Square"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"2 Tailed P"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Uncorrected"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[6]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[7]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Mantel-Haenszel"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[8]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[9]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Corrected"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 88, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[10]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 88, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[11]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 110, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 110, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"1 Tailed P"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 110, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"2 Tailed P"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 132, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Mid P Exact"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 132, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", ExactResults[1]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 132, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:nil];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 154, threeWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Fisher Exact"];
        [statisticalTestsView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + threeWidth0 / 2.0, 154, threeWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 154, threeWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 154, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", ExactResults[2]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 154, threewidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", ExactResults[3]]];
        [statisticalTestsView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 154, threewidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 154, threewidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];

        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:oddsBasedParametersView];
            [outputV addSubview:riskBasedParametersView];
            [outputV addSubview:statisticalTestsView];
        });
    }
    else
    {
        twoByTwoDisplayed = YES;
        
        //Offset for stratum labels if stratified
        float stratificationOffset = 0.0;
        if (stratVar)
        {
            stratificationOffset = 40.0;
            EpiInfoUILabel *stratumHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, 313, 40)];
            [stratumHeader setBackgroundColor:[UIColor clearColor]];
            [stratumHeader setTextColor:epiInfoLightBlue];
            [stratumHeader setText:[NSString stringWithFormat:@"%@ = %@", stratVar, stratValue]];
            [stratumHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [stratumHeader setTextAlignment:NSTextAlignmentCenter];
            dispatch_async(dispatch_get_main_queue(), ^{
                [outputV addSubview:stratumHeader];
            });
        }
        else
            stratificationOffset = contentSizeHeight;

        //Make the view for the actual 2x2 table
        outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 168)];
        [outputTableView setBackgroundColor:epiInfoLightBlue];
        [outputTableView.layer setCornerRadius:10.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:outputTableView];
        });

        double cellWidth = 76;
        
        //Set initial font sizes
        float outcomeVariableLabelFontSize = 16.0;
        float exposureVariableLabelFontSize = 16.0;
        float outcomeValueFontSize = 16.0;
        float exposureValueFontSize = 16.0;
        
        //Reduce font sizes until they fit
        //        while ([to.outcomeVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]].width > 120)
        // Deprecation replacement
        while ([to.outcomeVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]}].width > 120)
            outcomeVariableLabelFontSize -= 0.1;
        //        while ([to.exposureVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]].width > 120)
        // Deprecation replacement
        while ([to.exposureVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]}].width > 120)
            exposureVariableLabelFontSize -= 0.1;
        float outcomeValueWidthWithFont = 0.0;
        for (int i = 0; i < to.outcomeValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
            outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
        }
        float exposureValueWidthWithFont = 0.0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
            exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
        }
        while (outcomeValueWidthWithFont > cellWidth)
        {
            outcomeValueFontSize -= 0.1;
            outcomeValueWidthWithFont = 0.0;
            for (int i = 0; i < to.outcomeValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
                outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
            }
        }
        while (exposureValueWidthWithFont > 50)
        {
            exposureValueFontSize -= 0.1;
            exposureValueWidthWithFont = 0.0;
            for (int i = 0; i < to.exposureValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
                exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
            }
        }
        
        EpiInfoUILabel *outcomeVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79, 0, 2 * cellWidth + 2, 20)];
        [outcomeVariableLabel setText:to.outcomeVariable];
        [outcomeVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [outcomeVariableLabel setTextColor:[UIColor whiteColor]];
        [outcomeVariableLabel setBackgroundColor:[UIColor clearColor]];
        [outcomeVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:outcomeVariableLabel];
        });
        EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(-45, 70, 120, 20)];
        [exposureVariableLabel setText:to.exposureVariable];
        [exposureVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        [exposureVariableLabel setTextColor:[UIColor whiteColor]];
        [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
        [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:exposureVariableLabel];
        });

        int yy = [(NSNumber *)[to.cellCounts objectAtIndex:0] intValue];
        int yn = [(NSNumber *)[to.cellCounts objectAtIndex:1] intValue];
        int ny = [(NSNumber *)[to.cellCounts objectAtIndex:2] intValue];
        int nn = [(NSNumber *)[to.cellCounts objectAtIndex:3] intValue];
        
        int k = 0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            EpiInfoUILabel *exposureValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(27, 42 + i * 42, 50, 40)];
            [exposureValueLabel setBackgroundColor:[UIColor clearColor]];
            [exposureValueLabel setTextAlignment:NSTextAlignmentCenter];
            [exposureValueLabel setTextColor:[UIColor whiteColor]];
            [exposureValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]];
            if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                [exposureValueLabel setText:@"Missing"];
            else if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.exposureValues objectAtIndex:i] isEqualToString:@"(null)"])
                [exposureValueLabel setText:@"Missing"];
            else
                [exposureValueLabel setText:[NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [outputTableView addSubview:exposureValueLabel];
            });
            for (int j = 0; j < to.outcomeValues.count; j++)
            {
                if (i == 0)
                {
                    EpiInfoUILabel *outcomeValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 20, cellWidth, 20)];
                    [outcomeValueLabel setBackgroundColor:[UIColor clearColor]];
                    [outcomeValueLabel setTextAlignment:NSTextAlignmentCenter];
                    [outcomeValueLabel setTextColor:[UIColor whiteColor]];
                    [outcomeValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]];
                    if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSNull class]])
                        [outcomeValueLabel setText:@"Missing"];
                    else if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSString class]] && [[to.outcomeValues objectAtIndex:j] isEqualToString:@"(null)"])
                        [outcomeValueLabel setText:@"Missing"];
                    else
                        [outcomeValueLabel setText:[NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:j]]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [outputTableView addSubview:outcomeValueLabel];
                    });
                }
                UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 42 + i * 42, cellWidth, 40)];
                [countView setBackgroundColor:[UIColor whiteColor]];
                [countView.layer setCornerRadius:10.0];
                EpiInfoUILabel *countLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
                [countLabel setText:[NSString stringWithFormat:@"%@", [to.cellCounts objectAtIndex:k]]];
                [countLabel setTextAlignment:NSTextAlignmentCenter];
                [countLabel setBackgroundColor:[UIColor clearColor]];
                [countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [countView addSubview:countLabel];
                EpiInfoUILabel *rowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
                [rowPctLabel setTextAlignment:NSTextAlignmentRight];
                [rowPctLabel setBackgroundColor:[UIColor clearColor]];
                [rowPctLabel setTextColor:[UIColor lightGrayColor]];
                [rowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
                [countView addSubview:rowPctLabel];
                EpiInfoUILabel *colPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
                [colPctLabel setTextAlignment:NSTextAlignmentRight];
                [colPctLabel setBackgroundColor:[UIColor clearColor]];
                [colPctLabel setTextColor:[UIColor lightGrayColor]];
                [colPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
                [countView addSubview:colPctLabel];
                if (i == 0)
                {
                    if (j == 0)
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yy / (float)(yy + yn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yy / (float)(yy + ny)]];
                    }
                    else
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yn / (float)(yy + yn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yn / (float)(yn + nn)]];
                    }
                }
                else
                {
                    if (j == 0)
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)ny / (float)(ny + nn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)ny / (float)(yy + ny)]];
                    }
                    else
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)nn / (float)(ny + nn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)nn / (float)(yn + nn)]];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [outputTableView addSubview:countView];
                });
                k++;
            }
        }
        
        UIView *rowOneView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 42, cellWidth, 40)];
        [rowOneView setBackgroundColor:[UIColor whiteColor]];
        [rowOneView.layer setCornerRadius:10.0];
        EpiInfoUILabel *rowOneTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [rowOneTotal setTextAlignment:NSTextAlignmentCenter];
        [rowOneTotal setText:[NSString stringWithFormat:@"%d", yy + yn]];
        [rowOneTotal setBackgroundColor:[UIColor clearColor]];
        [rowOneView addSubview:rowOneTotal];
        EpiInfoUILabel *rowOneRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [rowOneRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowOneRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowOneRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowOneRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowOneRowPctLabel setText:@"100%"];
        [rowOneView addSubview:rowOneRowPctLabel];
        EpiInfoUILabel *rowOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowOneColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowOneColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + yn) / (float)(yy + yn + ny + nn)]];
        [rowOneView addSubview:rowOneColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:rowOneView];
        });
        UIView *rowTwoView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 84, cellWidth, 40)];
        [rowTwoView setBackgroundColor:[UIColor whiteColor]];
        [rowTwoView.layer setCornerRadius:10.0];
        EpiInfoUILabel *rowTwoTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [rowTwoTotal setTextAlignment:NSTextAlignmentCenter];
        [rowTwoTotal setText:[NSString stringWithFormat:@"%d", ny + nn]];
        [rowTwoTotal setBackgroundColor:[UIColor clearColor]];
        [rowTwoView addSubview:rowTwoTotal];
        EpiInfoUILabel *rowTwoRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [rowTwoRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowTwoRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowTwoRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowTwoRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowTwoRowPctLabel setText:@"100%"];
        [rowTwoView addSubview:rowTwoRowPctLabel];
        EpiInfoUILabel *rowTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowTwoColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowTwoColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(ny + nn) / (float)(yy + yn + ny + nn)]];
        [rowTwoView addSubview:rowTwoColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:rowTwoView];
        });

        UIView *columnOneView = [[UIView alloc] initWithFrame:CGRectMake(79, 126, cellWidth, 40)];
        [columnOneView setBackgroundColor:[UIColor whiteColor]];
        [columnOneView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnOneTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnOneTotal setTextAlignment:NSTextAlignmentCenter];
        [columnOneTotal setText:[NSString stringWithFormat:@"%d", yy + ny]];
        [columnOneTotal setBackgroundColor:[UIColor clearColor]];
        [columnOneView addSubview:columnOneTotal];
        EpiInfoUILabel *colOneRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [colOneRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [colOneRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [colOneRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [colOneRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colOneRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + ny) / (float)(yy + yn + ny + nn)]];
        [columnOneView addSubview:colOneRowPctLabel];
        EpiInfoUILabel *colOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colOneColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colOneColPctLabel setText:@"100%"];
        [columnOneView addSubview:colOneColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:columnOneView];
        });
        UIView *columnTwoView = [[UIView alloc] initWithFrame:CGRectMake(79 + cellWidth + 2, 126, cellWidth, 40)];
        [columnTwoView setBackgroundColor:[UIColor whiteColor]];
        [columnTwoView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnTwoTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnTwoTotal setTextAlignment:NSTextAlignmentCenter];
        [columnTwoTotal setText:[NSString stringWithFormat:@"%d", yn + nn]];
        [columnTwoTotal setBackgroundColor:[UIColor clearColor]];
        [columnTwoView addSubview:columnTwoTotal];
        EpiInfoUILabel *colTwoRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [colTwoRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [colTwoRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [colTwoRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [colTwoRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colTwoRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yn + nn) / (float)(yy + yn + ny + nn)]];
        [columnTwoView addSubview:colTwoRowPctLabel];
        EpiInfoUILabel *colTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colTwoColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colTwoColPctLabel setText:@"100%"];
        [columnTwoView addSubview:colTwoColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:columnTwoView];
        });

        UIView *totalTotalView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 126, cellWidth, 40)];
        [totalTotalView setBackgroundColor:[UIColor whiteColor]];
        [totalTotalView.layer setCornerRadius:10.0];
        EpiInfoUILabel *totalTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [totalTotal setTextAlignment:NSTextAlignmentCenter];
        [totalTotal setText:[NSString stringWithFormat:@"%d", yy + yn + ny + nn]];
        [totalTotal setBackgroundColor:[UIColor clearColor]];
        [totalTotalView addSubview:totalTotal];
        EpiInfoUILabel *totalRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [totalRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [totalRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [totalRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [totalRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [totalRowPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalRowPctLabel];
        EpiInfoUILabel *totalColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [totalColPctLabel setTextAlignment:NSTextAlignmentRight];
        [totalColPctLabel setBackgroundColor:[UIColor clearColor]];
        [totalColPctLabel setTextColor:[UIColor lightGrayColor]];
        [totalColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [totalColPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:totalTotalView];
        });

        //Compute and display the statistics
        Twox2Compute *computer = [[Twox2Compute alloc] init];
        double oddsRatio = [computer OddsRatioEstimate:yy cellb:yn cellc:ny celld:nn];
        double oddsRatioLower = [computer OddsRatioLower:yy cellb:yn cellc:ny celld:nn];
        double oddsRatioUpper = [computer OddsRatioUpper:yy cellb:yn cellc:ny celld:nn];
        double ExactResults[4];
        [computer CalcPoly:yy CPyn:yn CPny:ny CPnn:nn CPExactResults:ExactResults];
        double lowerMidP = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:NO];
        double upperMidP = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:NO];
        double lowerFisher = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:0 one:0 minus:1 PBLowerVariable:YES PBFisherVariable:YES];
        double upperFisher = [computer FishOR:yy cellb:yn cellc:ny celld:nn alpha:0.05 initialOR:ExactResults[0] plusA:1 one:1 minus:-1 PBLowerVariable:NO PBFisherVariable:YES];
        double RRstats[12];
        [computer RRStats:yy RRSb:yn RRSc:ny RRSd:nn RRSstats:RRstats];
        
        //Add the views for each section of statistics
        oddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 172 + stratificationOffset, 313, 110)];
        [oddsBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [oddsBasedParametersView.layer setCornerRadius:10.0];

        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 284 + stratificationOffset, 313, 88)];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [riskBasedParametersView.layer setCornerRadius:10.0];

        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 374 + stratificationOffset, 313, 176)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
        [statisticalTestsView.layer setCornerRadius:10.0];

        //Add labels to each of the views
        float fourWidth0 = 78;
        float fourWidth1 = 75;
        float threeWidth0 = 105;
        float threewidth1 = 100;
        
        EpiInfoUILabel *gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, oddsBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Odds-based Parameters"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Estimate"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Lower"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Upper"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Odds Ratio"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatio]];
        [oddsBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSString stringWithString:to.exposureVariable]];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:oddsRatio]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatioLower]];
        [oddsBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:oddsRatioLower]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatioUpper]];
        [oddsBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:oddsRatioUpper]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" MLE OR"];
        [gridBox setAccessibilityLabel:@"M.L.E. Odds Ratio"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", ExactResults[0]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", lowerMidP]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", upperMidP]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, fourWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Fisher Exact"];
        [oddsBasedParametersView addSubview:gridBox];
        UIView *ew = [[UIView alloc] initWithFrame:CGRectMake(2 + fourWidth0 / 2.0, 88, fourWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 88, fourWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:nil];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", lowerFisher]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 88, fourWidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", upperFisher]];
        [oddsBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 88, fourWidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 88, fourWidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, riskBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Risk-based Parameters"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Estimate"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Lower"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Upper"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
        [gridBox setText:@" Relative Risk"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[0]]];
        [riskBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:RRstats[0]]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[1]]];
        [riskBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:RRstats[1]]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[2]]];
        [riskBasedParametersView addSubview:gridBox];
        [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:RRstats[2]]];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
        [gridBox setText:@" Risk Difference"];
        [riskBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + fourWidth0 / 2.0, 66, fourWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[3]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[4]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[5]]];
        [riskBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, statisticalTestsView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Statistical Tests"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"X2"];
        [gridBox setAccessibilityLabel:@"Ky Square"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"2 Tailed P"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Uncorrected"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[6]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[7]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Mantel-Haenszel"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[8]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[9]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Corrected"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 88, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[10]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 88, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[11]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 110, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 110, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"1 Tailed P"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 110, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"2 Tailed P"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 132, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Mid P Exact"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 132, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", ExactResults[1]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 132, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:nil];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 154, threeWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Fisher Exact"];
        [statisticalTestsView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + threeWidth0 / 2.0, 154, threeWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 154, threeWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 154, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", ExactResults[2]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 154, threewidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", ExactResults[3]]];
        [statisticalTestsView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 154, threewidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 154, threewidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:oddsBasedParametersView];
            [outputV addSubview:riskBasedParametersView];
            [outputV addSubview:statisticalTestsView];
        });
    }
}

- (void)doSummary:(NSArray *)strataData OutputView:(UIView *)outputV TablesObject:(TablesObject *)to
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        Twox2SummaryData *summaryData = [[Twox2SummaryData alloc] init];
        double summaryResultsArray[31];
        [summaryData compute:strataData summaryResults:summaryResultsArray];
        [summaryData computeSlowStuff:strataData summaryResults:summaryResultsArray];
        double exactResultsArray[3];
        exactResultsArray[0] = 0.0;
        exactResultsArray[1] = 0.0;
        exactResultsArray[2] = 0.0;
        [summaryData computeExactOR:strataData summaryResults:exactResultsArray];

        EpiInfoUILabel *stratumHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, outputV.frame.size.width, 40)];
        [stratumHeader setBackgroundColor:[UIColor clearColor]];
        [stratumHeader setTextColor:epiInfoLightBlue];
        [stratumHeader setText:@"Summary Results"];
        [stratumHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [stratumHeader setTextAlignment:NSTextAlignmentCenter];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:stratumHeader];
        });

        //Make the view for the actual 2x2 table
        float stratificationOffset = 40.0;
        outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 168)];
        [outputTableView setBackgroundColor:epiInfoLightBlue];
        [outputTableView.layer setCornerRadius:10.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:outputTableView];
        });

        double cellWidth = 76;
        
        //Set initial font sizes
        float outcomeVariableLabelFontSize = 16.0;
        float exposureVariableLabelFontSize = 16.0;
        float outcomeValueFontSize = 16.0;
        float exposureValueFontSize = 16.0;
        
        //Reduce font sizes until they fit
//        while ([to.outcomeVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]].width > 120)
            // Deprecation replacement
        while ([to.outcomeVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]}].width > 120)
            outcomeVariableLabelFontSize -= 0.1;
//        while ([to.exposureVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]].width > 120)
            // Deprecation replacement
        while ([to.exposureVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]}].width > 120)
            exposureVariableLabelFontSize -= 0.1;
        float outcomeValueWidthWithFont = 0.0;
        for (int i = 0; i < to.outcomeValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
            outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
        }
        float exposureValueWidthWithFont = 0.0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
            exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
        }
        while (outcomeValueWidthWithFont > cellWidth)
        {
            outcomeValueFontSize -= 0.1;
            outcomeValueWidthWithFont = 0.0;
            for (int i = 0; i < to.outcomeValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
                outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
            }
        }
        while (exposureValueWidthWithFont > 50)
        {
            exposureValueFontSize -= 0.1;
            exposureValueWidthWithFont = 0.0;
            for (int i = 0; i < to.exposureValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
                exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
            }
        }
        
        EpiInfoUILabel *outcomeVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79, 0, 2 * cellWidth + 2, 20)];
        [outcomeVariableLabel setText:to.outcomeVariable];
        [outcomeVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [outcomeVariableLabel setTextColor:[UIColor whiteColor]];
        [outcomeVariableLabel setBackgroundColor:[UIColor clearColor]];
        [outcomeVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:outcomeVariableLabel];
        });
        EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(-45, 70, 120, 20)];
        [exposureVariableLabel setText:to.exposureVariable];
        [exposureVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        [exposureVariableLabel setTextColor:[UIColor whiteColor]];
        [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
        [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:exposureVariableLabel];
        });

        int yy = summaryResultsArray[0];
        int yn = summaryResultsArray[1];
        int ny = summaryResultsArray[2];
        int nn = summaryResultsArray[3];
        
        int k = 0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            EpiInfoUILabel *exposureValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(27, 42 + i * 42, 50, 40)];
            [exposureValueLabel setBackgroundColor:[UIColor clearColor]];
            [exposureValueLabel setTextAlignment:NSTextAlignmentCenter];
            [exposureValueLabel setTextColor:[UIColor whiteColor]];
            [exposureValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]];
            if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                [exposureValueLabel setText:@"Missing"];
            else if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.exposureValues objectAtIndex:i] isEqualToString:@"(null)"])
                [exposureValueLabel setText:@"Missing"];
            else
                [exposureValueLabel setText:[NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [outputTableView addSubview:exposureValueLabel];
            });
            for (int j = 0; j < to.outcomeValues.count; j++)
            {
                if (i == 0)
                {
                    EpiInfoUILabel *outcomeValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 20, cellWidth, 20)];
                    [outcomeValueLabel setBackgroundColor:[UIColor clearColor]];
                    [outcomeValueLabel setTextAlignment:NSTextAlignmentCenter];
                    [outcomeValueLabel setTextColor:[UIColor whiteColor]];
                    [outcomeValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]];
                    if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSNull class]])
                        [outcomeValueLabel setText:@"Missing"];
                    else if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSString class]] && [[to.outcomeValues objectAtIndex:j] isEqualToString:@"(null)"])
                        [outcomeValueLabel setText:@"Missing"];
                    else
                        [outcomeValueLabel setText:[NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:j]]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [outputTableView addSubview:outcomeValueLabel];
                    });
                }
                UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 42 + i * 42, cellWidth, 40)];
                [countView setBackgroundColor:[UIColor whiteColor]];
                [countView.layer setCornerRadius:10.0];
                EpiInfoUILabel *countLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
                [countLabel setText:[NSString stringWithFormat:@"%@", [to.cellCounts objectAtIndex:k]]];
                [countLabel setTextAlignment:NSTextAlignmentCenter];
                [countLabel setBackgroundColor:[UIColor clearColor]];
                [countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [countView addSubview:countLabel];
                EpiInfoUILabel *rowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
                [rowPctLabel setTextAlignment:NSTextAlignmentRight];
                [rowPctLabel setBackgroundColor:[UIColor clearColor]];
                [rowPctLabel setTextColor:[UIColor lightGrayColor]];
                [rowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
                [countView addSubview:rowPctLabel];
                EpiInfoUILabel *colPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
                [colPctLabel setTextAlignment:NSTextAlignmentRight];
                [colPctLabel setBackgroundColor:[UIColor clearColor]];
                [colPctLabel setTextColor:[UIColor lightGrayColor]];
                [colPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
                [countView addSubview:colPctLabel];
                if (i == 0)
                {
                    if (j == 0)
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yy / (float)(yy + yn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yy / (float)(yy + ny)]];
                    }
                    else
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yn / (float)(yy + yn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yn / (float)(yn + nn)]];
                    }
                }
                else
                {
                    if (j == 0)
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)ny / (float)(ny + nn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)ny / (float)(yy + ny)]];
                    }
                    else
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)nn / (float)(ny + nn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)nn / (float)(yn + nn)]];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [outputTableView addSubview:countView];
                });
                k++;
            }
        }
        
        UIView *rowOneView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 42, cellWidth, 40)];
        [rowOneView setBackgroundColor:[UIColor whiteColor]];
        [rowOneView.layer setCornerRadius:10.0];
        EpiInfoUILabel *rowOneTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [rowOneTotal setTextAlignment:NSTextAlignmentCenter];
        [rowOneTotal setText:[NSString stringWithFormat:@"%d", yy + yn]];
        [rowOneTotal setBackgroundColor:[UIColor clearColor]];
        [rowOneView addSubview:rowOneTotal];
        EpiInfoUILabel *rowOneRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [rowOneRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowOneRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowOneRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowOneRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowOneRowPctLabel setText:@"100%"];
        [rowOneView addSubview:rowOneRowPctLabel];
        EpiInfoUILabel *rowOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowOneColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowOneColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + yn) / (float)(yy + yn + ny + nn)]];
        [rowOneView addSubview:rowOneColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:rowOneView];
        });
        UIView *rowTwoView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 84, cellWidth, 40)];
        [rowTwoView setBackgroundColor:[UIColor whiteColor]];
        [rowTwoView.layer setCornerRadius:10.0];
        EpiInfoUILabel *rowTwoTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [rowTwoTotal setTextAlignment:NSTextAlignmentCenter];
        [rowTwoTotal setText:[NSString stringWithFormat:@"%d", ny + nn]];
        [rowTwoTotal setBackgroundColor:[UIColor clearColor]];
        [rowTwoView addSubview:rowTwoTotal];
        EpiInfoUILabel *rowTwoRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [rowTwoRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowTwoRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowTwoRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowTwoRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowTwoRowPctLabel setText:@"100%"];
        [rowTwoView addSubview:rowTwoRowPctLabel];
        EpiInfoUILabel *rowTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowTwoColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowTwoColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(ny + nn) / (float)(yy + yn + ny + nn)]];
        [rowTwoView addSubview:rowTwoColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:rowTwoView];
        });

        UIView *columnOneView = [[UIView alloc] initWithFrame:CGRectMake(79, 126, cellWidth, 40)];
        [columnOneView setBackgroundColor:[UIColor whiteColor]];
        [columnOneView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnOneTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnOneTotal setTextAlignment:NSTextAlignmentCenter];
        [columnOneTotal setText:[NSString stringWithFormat:@"%d", yy + ny]];
        [columnOneTotal setBackgroundColor:[UIColor clearColor]];
        [columnOneView addSubview:columnOneTotal];
        EpiInfoUILabel *colOneRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [colOneRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [colOneRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [colOneRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [colOneRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colOneRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + ny) / (float)(yy + yn + ny + nn)]];
        [columnOneView addSubview:colOneRowPctLabel];
        EpiInfoUILabel *colOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colOneColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colOneColPctLabel setText:@"100%"];
        [columnOneView addSubview:colOneColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:columnOneView];
        });
        UIView *columnTwoView = [[UIView alloc] initWithFrame:CGRectMake(79 + cellWidth + 2, 126, cellWidth, 40)];
        [columnTwoView setBackgroundColor:[UIColor whiteColor]];
        [columnTwoView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnTwoTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnTwoTotal setTextAlignment:NSTextAlignmentCenter];
        [columnTwoTotal setText:[NSString stringWithFormat:@"%d", yn + nn]];
        [columnTwoTotal setBackgroundColor:[UIColor clearColor]];
        [columnTwoView addSubview:columnTwoTotal];
        EpiInfoUILabel *colTwoRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [colTwoRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [colTwoRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [colTwoRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [colTwoRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colTwoRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yn + nn) / (float)(yy + yn + ny + nn)]];
        [columnTwoView addSubview:colTwoRowPctLabel];
        EpiInfoUILabel *colTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colTwoColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colTwoColPctLabel setText:@"100%"];
        [columnTwoView addSubview:colTwoColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:columnTwoView];
        });

        UIView *totalTotalView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 126, cellWidth, 40)];
        [totalTotalView setBackgroundColor:[UIColor whiteColor]];
        [totalTotalView.layer setCornerRadius:10.0];
        EpiInfoUILabel *totalTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [totalTotal setTextAlignment:NSTextAlignmentCenter];
        [totalTotal setText:[NSString stringWithFormat:@"%d", yy + yn + ny + nn]];
        [totalTotal setBackgroundColor:[UIColor clearColor]];
        [totalTotalView addSubview:totalTotal];
        EpiInfoUILabel *totalRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [totalRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [totalRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [totalRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [totalRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [totalRowPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalRowPctLabel];
        EpiInfoUILabel *totalColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [totalColPctLabel setTextAlignment:NSTextAlignmentRight];
        [totalColPctLabel setBackgroundColor:[UIColor clearColor]];
        [totalColPctLabel setTextColor:[UIColor lightGrayColor]];
        [totalColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [totalColPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:totalTotalView];
        });

        //Add the views for each section of statistics
        oddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 172 + stratificationOffset, 313, 154)];
        [oddsBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [oddsBasedParametersView.layer setCornerRadius:10.0];

        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 328 + stratificationOffset, 313, 88)];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [riskBasedParametersView.layer setCornerRadius:10.0];

        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 418 + stratificationOffset, 313, 88)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
        [statisticalTestsView.layer setCornerRadius:10.0];

        UIView *homogeneityTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 508 + stratificationOffset, 313, 110)];
        [homogeneityTestsView setBackgroundColor:epiInfoLightBlue];
        [homogeneityTestsView.layer setCornerRadius:10.0];

        //Add labels to each of the views
        float fourWidth0 = 78;
        float fourWidth1 = 75;
        float threeWidth0 = 105;
        float threewidth1 = 100;
        
        EpiInfoUILabel *gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, oddsBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Odds-based Parameters"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@"  Odds Ratio"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Estimate"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Lower"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Upper"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Crude"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[4]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[5]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[6]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" MLE"];
        [gridBox setAccessibilityLabel:@"M.L.E."];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[7]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[8]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[9]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Fisher Exact"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:nil];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[10]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[11]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 110, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0]];
        [gridBox setText:@" Adjusted (MH)"];
        [gridBox setAccessibilityLabel:@"Adjusted, M.H."];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[12]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[13]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[14]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 132, fourWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
        [gridBox setText:@" Adjusted (MLE)"];
        [gridBox setAccessibilityLabel:@"Adjusted, M.L.E."];
        [oddsBasedParametersView addSubview:gridBox];
        UIView *ew = [[UIView alloc] initWithFrame:CGRectMake(2 + fourWidth0 / 2.0, 132, fourWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 132, fourWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", exactResultsArray[0]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", exactResultsArray[1]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 132, fourWidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", exactResultsArray[2]]];
        [oddsBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 132, fourWidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 132, fourWidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, riskBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Risk-based Parameters"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@"  Risk Ratio"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Estimate"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Lower"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Upper"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Crude"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[18]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[19]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[20]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Adjusted"];
        [riskBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + fourWidth0 / 2.0, 66, fourWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[15]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[16]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[17]]];
        [riskBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, statisticalTestsView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Chi Square"];
        [gridBox setAccessibilityLabel:@"Ky Square"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"X2"];
        [gridBox setAccessibilityLabel:@"Ky Square"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"2 Tailed P"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0]];
        [gridBox setText:@" Uncorrected (MH)"];
        [gridBox setAccessibilityLabel:@"Uncorrected, M.H."];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[21]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[22]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, threeWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Corrected (MH)"];
        [gridBox setAccessibilityLabel:@"Corrected, M.H."];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[23]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[24]]];
        [statisticalTestsView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + threeWidth0 / 2.0, 66, threeWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 66, threeWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, statisticalTestsView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Homogeneity Tests"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"X2"];
        [gridBox setAccessibilityLabel:@"Ky Square"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"2 Tailed P"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
        [gridBox setText:@" Breslow-Day-Tarone"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[25]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[26]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Breslow-Day OR"];
        [gridBox setAccessibilityLabel:@"Breslow-Day Odds Ratio"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[27]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[28]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, threeWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Breslow-Day RR"];
        [gridBox setAccessibilityLabel:@"Breslow-Day Risk Ratio"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 88, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[29]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 88, threewidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[30]]];
        [homogeneityTestsView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + threeWidth0 / 2.0, 88, threeWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [homogeneityTestsView addSubview:ew];
        [homogeneityTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 88, threeWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [homogeneityTestsView addSubview:ew];
        [homogeneityTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 88, threewidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [homogeneityTestsView addSubview:ew];
        [homogeneityTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 88, threewidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [homogeneityTestsView addSubview:ew];
        [homogeneityTestsView sendSubviewToBack:ew];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:oddsBasedParametersView];
            [outputV addSubview:riskBasedParametersView];
            [outputV addSubview:statisticalTestsView];
            [outputV addSubview:homogeneityTestsView];
        });
    }
    else
    {
        Twox2SummaryData *summaryData = [[Twox2SummaryData alloc] init];
        double summaryResultsArray[31];
        [summaryData compute:strataData summaryResults:summaryResultsArray];
        [summaryData computeSlowStuff:strataData summaryResults:summaryResultsArray];
        double exactResultsArray[3];
        exactResultsArray[0] = 0.0;
        exactResultsArray[1] = 0.0;
        exactResultsArray[2] = 0.0;
        [summaryData computeExactOR:strataData summaryResults:exactResultsArray];
        
        EpiInfoUILabel *stratumHeader = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, 313, 40)];
        [stratumHeader setBackgroundColor:[UIColor clearColor]];
        [stratumHeader setTextColor:epiInfoLightBlue];
        [stratumHeader setText:@"Summary Results"];
        [stratumHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [stratumHeader setTextAlignment:NSTextAlignmentCenter];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:stratumHeader];
        });

        //Make the view for the actual 2x2 table
        float stratificationOffset = 40.0;
        outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 168)];
        [outputTableView setBackgroundColor:epiInfoLightBlue];
        [outputTableView.layer setCornerRadius:10.0];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:outputTableView];
        });

        double cellWidth = 76;
        
        //Set initial font sizes
        float outcomeVariableLabelFontSize = 16.0;
        float exposureVariableLabelFontSize = 16.0;
        float outcomeValueFontSize = 16.0;
        float exposureValueFontSize = 16.0;
        
        //Reduce font sizes until they fit
        //        while ([to.outcomeVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]].width > 120)
        // Deprecation replacement
        while ([to.outcomeVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]}].width > 120)
            outcomeVariableLabelFontSize -= 0.1;
        //        while ([to.exposureVariable sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]].width > 120)
        // Deprecation replacement
        while ([to.exposureVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]}].width > 120)
            exposureVariableLabelFontSize -= 0.1;
        float outcomeValueWidthWithFont = 0.0;
        for (int i = 0; i < to.outcomeValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
            outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
        }
        float exposureValueWidthWithFont = 0.0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
            exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
        }
        while (outcomeValueWidthWithFont > cellWidth)
        {
            outcomeValueFontSize -= 0.1;
            outcomeValueWidthWithFont = 0.0;
            for (int i = 0; i < to.outcomeValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
                outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]}].width);
            }
        }
        while (exposureValueWidthWithFont > 50)
        {
            exposureValueFontSize -= 0.1;
            exposureValueWidthWithFont = 0.0;
            for (int i = 0; i < to.exposureValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
                exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]}].width);
            }
        }
        
        EpiInfoUILabel *outcomeVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79, 0, 2 * cellWidth + 2, 20)];
        [outcomeVariableLabel setText:to.outcomeVariable];
        [outcomeVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [outcomeVariableLabel setTextColor:[UIColor whiteColor]];
        [outcomeVariableLabel setBackgroundColor:[UIColor clearColor]];
        [outcomeVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeVariableLabelFontSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:outcomeVariableLabel];
        });
        EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(-45, 70, 120, 20)];
        [exposureVariableLabel setText:to.exposureVariable];
        [exposureVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        [exposureVariableLabel setTextColor:[UIColor whiteColor]];
        [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
        [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:exposureVariableLabel];
        });

        int yy = summaryResultsArray[0];
        int yn = summaryResultsArray[1];
        int ny = summaryResultsArray[2];
        int nn = summaryResultsArray[3];
        
        int k = 0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            EpiInfoUILabel *exposureValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(27, 42 + i * 42, 50, 40)];
            [exposureValueLabel setBackgroundColor:[UIColor clearColor]];
            [exposureValueLabel setTextAlignment:NSTextAlignmentCenter];
            [exposureValueLabel setTextColor:[UIColor whiteColor]];
            [exposureValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]];
            if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                [exposureValueLabel setText:@"Missing"];
            else if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.exposureValues objectAtIndex:i] isEqualToString:@"(null)"])
                [exposureValueLabel setText:@"Missing"];
            else
                [exposureValueLabel setText:[NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [outputTableView addSubview:exposureValueLabel];
            });
            for (int j = 0; j < to.outcomeValues.count; j++)
            {
                if (i == 0)
                {
                    EpiInfoUILabel *outcomeValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 20, cellWidth, 20)];
                    [outcomeValueLabel setBackgroundColor:[UIColor clearColor]];
                    [outcomeValueLabel setTextAlignment:NSTextAlignmentCenter];
                    [outcomeValueLabel setTextColor:[UIColor whiteColor]];
                    [outcomeValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]];
                    if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSNull class]])
                        [outcomeValueLabel setText:@"Missing"];
                    else if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSString class]] && [[to.outcomeValues objectAtIndex:j] isEqualToString:@"(null)"])
                        [outcomeValueLabel setText:@"Missing"];
                    else
                        [outcomeValueLabel setText:[NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:j]]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [outputTableView addSubview:outcomeValueLabel];
                    });
                }
                UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 42 + i * 42, cellWidth, 40)];
                [countView setBackgroundColor:[UIColor whiteColor]];
                [countView.layer setCornerRadius:10.0];
                EpiInfoUILabel *countLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
                [countLabel setText:[NSString stringWithFormat:@"%@", [to.cellCounts objectAtIndex:k]]];
                [countLabel setTextAlignment:NSTextAlignmentCenter];
                [countLabel setBackgroundColor:[UIColor clearColor]];
                [countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [countView addSubview:countLabel];
                EpiInfoUILabel *rowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
                [rowPctLabel setTextAlignment:NSTextAlignmentRight];
                [rowPctLabel setBackgroundColor:[UIColor clearColor]];
                [rowPctLabel setTextColor:[UIColor lightGrayColor]];
                [rowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
                [countView addSubview:rowPctLabel];
                EpiInfoUILabel *colPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
                [colPctLabel setTextAlignment:NSTextAlignmentRight];
                [colPctLabel setBackgroundColor:[UIColor clearColor]];
                [colPctLabel setTextColor:[UIColor lightGrayColor]];
                [colPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
                [countView addSubview:colPctLabel];
                if (i == 0)
                {
                    if (j == 0)
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yy / (float)(yy + yn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yy / (float)(yy + ny)]];
                    }
                    else
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yn / (float)(yy + yn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)yn / (float)(yn + nn)]];
                    }
                }
                else
                {
                    if (j == 0)
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)ny / (float)(ny + nn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)ny / (float)(yy + ny)]];
                    }
                    else
                    {
                        [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)nn / (float)(ny + nn)]];
                        [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)nn / (float)(yn + nn)]];
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [outputTableView addSubview:countView];
                });
                k++;
            }
        }
        
        UIView *rowOneView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 42, cellWidth, 40)];
        [rowOneView setBackgroundColor:[UIColor whiteColor]];
        [rowOneView.layer setCornerRadius:10.0];
        EpiInfoUILabel *rowOneTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [rowOneTotal setTextAlignment:NSTextAlignmentCenter];
        [rowOneTotal setText:[NSString stringWithFormat:@"%d", yy + yn]];
        [rowOneTotal setBackgroundColor:[UIColor clearColor]];
        [rowOneView addSubview:rowOneTotal];
        EpiInfoUILabel *rowOneRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [rowOneRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowOneRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowOneRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowOneRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowOneRowPctLabel setText:@"100%"];
        [rowOneView addSubview:rowOneRowPctLabel];
        EpiInfoUILabel *rowOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowOneColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowOneColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + yn) / (float)(yy + yn + ny + nn)]];
        [rowOneView addSubview:rowOneColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:rowOneView];
        });
        UIView *rowTwoView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 84, cellWidth, 40)];
        [rowTwoView setBackgroundColor:[UIColor whiteColor]];
        [rowTwoView.layer setCornerRadius:10.0];
        EpiInfoUILabel *rowTwoTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [rowTwoTotal setTextAlignment:NSTextAlignmentCenter];
        [rowTwoTotal setText:[NSString stringWithFormat:@"%d", ny + nn]];
        [rowTwoTotal setBackgroundColor:[UIColor clearColor]];
        [rowTwoView addSubview:rowTwoTotal];
        EpiInfoUILabel *rowTwoRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [rowTwoRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowTwoRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowTwoRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowTwoRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowTwoRowPctLabel setText:@"100%"];
        [rowTwoView addSubview:rowTwoRowPctLabel];
        EpiInfoUILabel *rowTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowTwoColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [rowTwoColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(ny + nn) / (float)(yy + yn + ny + nn)]];
        [rowTwoView addSubview:rowTwoColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:rowTwoView];
        });

        UIView *columnOneView = [[UIView alloc] initWithFrame:CGRectMake(79, 126, cellWidth, 40)];
        [columnOneView setBackgroundColor:[UIColor whiteColor]];
        [columnOneView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnOneTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnOneTotal setTextAlignment:NSTextAlignmentCenter];
        [columnOneTotal setText:[NSString stringWithFormat:@"%d", yy + ny]];
        [columnOneTotal setBackgroundColor:[UIColor clearColor]];
        [columnOneView addSubview:columnOneTotal];
        EpiInfoUILabel *colOneRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [colOneRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [colOneRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [colOneRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [colOneRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colOneRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + ny) / (float)(yy + yn + ny + nn)]];
        [columnOneView addSubview:colOneRowPctLabel];
        EpiInfoUILabel *colOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colOneColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colOneColPctLabel setText:@"100%"];
        [columnOneView addSubview:colOneColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:columnOneView];
        });
        UIView *columnTwoView = [[UIView alloc] initWithFrame:CGRectMake(79 + cellWidth + 2, 126, cellWidth, 40)];
        [columnTwoView setBackgroundColor:[UIColor whiteColor]];
        [columnTwoView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnTwoTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnTwoTotal setTextAlignment:NSTextAlignmentCenter];
        [columnTwoTotal setText:[NSString stringWithFormat:@"%d", yn + nn]];
        [columnTwoTotal setBackgroundColor:[UIColor clearColor]];
        [columnTwoView addSubview:columnTwoTotal];
        EpiInfoUILabel *colTwoRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [colTwoRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [colTwoRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [colTwoRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [colTwoRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colTwoRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yn + nn) / (float)(yy + yn + ny + nn)]];
        [columnTwoView addSubview:colTwoRowPctLabel];
        EpiInfoUILabel *colTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colTwoColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [colTwoColPctLabel setText:@"100%"];
        [columnTwoView addSubview:colTwoColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:columnTwoView];
        });

        UIView *totalTotalView = [[UIView alloc] initWithFrame:CGRectMake(79 + 2 * (cellWidth + 2), 126, cellWidth, 40)];
        [totalTotalView setBackgroundColor:[UIColor whiteColor]];
        [totalTotalView.layer setCornerRadius:10.0];
        EpiInfoUILabel *totalTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [totalTotal setTextAlignment:NSTextAlignmentCenter];
        [totalTotal setText:[NSString stringWithFormat:@"%d", yy + yn + ny + nn]];
        [totalTotal setBackgroundColor:[UIColor clearColor]];
        [totalTotalView addSubview:totalTotal];
        EpiInfoUILabel *totalRowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
        [totalRowPctLabel setTextAlignment:NSTextAlignmentRight];
        [totalRowPctLabel setBackgroundColor:[UIColor clearColor]];
        [totalRowPctLabel setTextColor:[UIColor lightGrayColor]];
        [totalRowPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [totalRowPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalRowPctLabel];
        EpiInfoUILabel *totalColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [totalColPctLabel setTextAlignment:NSTextAlignmentRight];
        [totalColPctLabel setBackgroundColor:[UIColor clearColor]];
        [totalColPctLabel setTextColor:[UIColor lightGrayColor]];
        [totalColPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [totalColPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalColPctLabel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputTableView addSubview:totalTotalView];
        });

        //Add the views for each section of statistics
        oddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 172 + stratificationOffset, 313, 154)];
        [oddsBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [oddsBasedParametersView.layer setCornerRadius:10.0];

        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 328 + stratificationOffset, 313, 88)];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [riskBasedParametersView.layer setCornerRadius:10.0];

        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 418 + stratificationOffset, 313, 88)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
        [statisticalTestsView.layer setCornerRadius:10.0];

        UIView *homogeneityTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 508 + stratificationOffset, 313, 110)];
        [homogeneityTestsView setBackgroundColor:epiInfoLightBlue];
        [homogeneityTestsView.layer setCornerRadius:10.0];

        //Add labels to each of the views
        float fourWidth0 = 78;
        float fourWidth1 = 75;
        float threeWidth0 = 105;
        float threewidth1 = 100;
        
        EpiInfoUILabel *gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, oddsBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Odds-based Parameters"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@"  Odds Ratio"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Estimate"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Lower"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Upper"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Crude"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[4]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[5]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[6]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" MLE"];
        [gridBox setAccessibilityLabel:@"M.L.E."];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[7]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[8]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[9]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Fisher Exact"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:nil];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[10]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[11]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 110, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0]];
        [gridBox setText:@" Adjusted (MH)"];
        [gridBox setAccessibilityLabel:@"Adjusted, M.H."];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[12]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[13]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[14]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 132, fourWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
        [gridBox setText:@" Adjusted (MLE)"];
        [gridBox setAccessibilityLabel:@"Adjusted, M.L.E."];
        [oddsBasedParametersView addSubview:gridBox];
        UIView *ew = [[UIView alloc] initWithFrame:CGRectMake(2 + fourWidth0 / 2.0, 132, fourWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 132, fourWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", exactResultsArray[0]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", exactResultsArray[1]]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 132, fourWidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", exactResultsArray[2]]];
        [oddsBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 132, fourWidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 132, fourWidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [oddsBasedParametersView addSubview:ew];
        [oddsBasedParametersView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, riskBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Risk-based Parameters"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@"  Risk Ratio"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Estimate"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Lower"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Upper"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Crude"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[18]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[19]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[20]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Adjusted"];
        [riskBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + fourWidth0 / 2.0, 66, fourWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[15]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[16]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[17]]];
        [riskBasedParametersView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 66, fourWidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [riskBasedParametersView addSubview:ew];
        [riskBasedParametersView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, statisticalTestsView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Chi Square"];
        [gridBox setAccessibilityLabel:@"Ky Square"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"X2"];
        [gridBox setAccessibilityLabel:@"Ky Square"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"2 Tailed P"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0]];
        [gridBox setText:@" Uncorrected (MH)"];
        [gridBox setAccessibilityLabel:@"Uncorrected, M.H."];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[21]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[22]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, threeWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Corrected (MH)"];
        [gridBox setAccessibilityLabel:@"Corrected, M.H."];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[23]]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[24]]];
        [statisticalTestsView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + threeWidth0 / 2.0, 66, threeWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 66, threeWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [statisticalTestsView addSubview:ew];
        [statisticalTestsView sendSubviewToBack:ew];
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, statisticalTestsView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Homogeneity Tests"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:nil];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"X2"];
        [gridBox setAccessibilityLabel:@"Ky Square"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 22, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"2 Tailed P"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0]];
        [gridBox setText:@" Breslow-Day-Tarone"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[25]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 44, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[26]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, threeWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Breslow-Day OR"];
        [gridBox setAccessibilityLabel:@"Breslow-Day Odds Ratio"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[27]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 66, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[28]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, threeWidth0, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Breslow-Day RR"];
        [gridBox setAccessibilityLabel:@"Breslow-Day Risk Ratio"];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + threeWidth0, 88, threewidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[29]]];
        [homogeneityTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 88, threewidth1, 20)];
        [gridBox.layer setCornerRadius:8.0];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", summaryResultsArray[30]]];
        [homogeneityTestsView addSubview:gridBox];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2 + threeWidth0 / 2.0, 88, threeWidth0 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [homogeneityTestsView addSubview:ew];
        [homogeneityTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(2, 88, threeWidth0, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [homogeneityTestsView addSubview:ew];
        [homogeneityTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 88, threewidth1 / 2.0, 20)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [homogeneityTestsView addSubview:ew];
        [homogeneityTestsView sendSubviewToBack:ew];
        ew = [[UIView alloc] initWithFrame:CGRectMake(6 + threeWidth0 + threewidth1, 88, threewidth1, 10)];
        [ew setBackgroundColor:[UIColor whiteColor]];
        [homogeneityTestsView addSubview:ew];
        [homogeneityTestsView sendSubviewToBack:ew];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputV addSubview:oddsBasedParametersView];
            [outputV addSubview:riskBasedParametersView];
            [outputV addSubview:statisticalTestsView];
            [outputV addSubview:homogeneityTestsView];
        });
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
