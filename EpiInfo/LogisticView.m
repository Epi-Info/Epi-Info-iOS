//
//  LogisticView.m
//  EpiInfo
//
//  Created by John Copeland on 11/9/18.
//

#import "LogisticView.h"
#import "AnalysisViewController.h"
#import "Twox2Compute.h"
#import "Twox2StrataData.h"
#import "Twox2SummaryData.h"
#import "SharedResources.h"


@implementation LogisticView
{
    AnalysisViewController *avc;
    
    UIActivityIndicatorView *spinner;
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
//            [inputView addSubview:includeMissingButton];
//            [inputView sendSubviewToBack:includeMissingButton];
            includeMissingLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(20, 104, frame.size.width / 2.0 - 22, 22)];
            [includeMissingLabel setTextAlignment:NSTextAlignmentLeft];
            [includeMissingLabel setTextColor:epiInfoLightBlue];
            [includeMissingLabel setText:@"Include missing"];
            [includeMissingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
//            [inputView addSubview:includeMissingLabel];
//            [inputView sendSubviewToBack:includeMissingLabel];
            
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
            [gadgetTitle setText:@"Logistic Regression"];
            [gadgetTitle setTextColor:epiInfoLightBlue];
            [gadgetTitle setFont:[UIFont boldSystemFontOfSize:18.0]];
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
//            [inputView addSubview:includeMissingButton];
//            [inputView sendSubviewToBack:includeMissingButton];
            includeMissingLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(20, 104, frame.size.width / 2.0 - 22, 22)];
            [includeMissingLabel setTextAlignment:NSTextAlignmentLeft];
            [includeMissingLabel setTextColor:epiInfoLightBlue];
            [includeMissingLabel setText:@"Include missing"];
            [includeMissingLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
//            [inputView addSubview:includeMissingLabel];
//            [inputView sendSubviewToBack:includeMissingLabel];
            
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
            [gadgetTitle setText:@"Logistic Regression"];
            [gadgetTitle setTextColor:epiInfoLightBlue];
            [gadgetTitle setFont:[UIFont boldSystemFontOfSize:18.0]];
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
    [exposureVariableString setDelegate:self];
    [exposureVariableString addTarget:self action:@selector(textFieldAction) forControlEvents:UIControlEventValueChanged];
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
    [inputView addSubview:outcomeLVE];
    NSMutableArray *exposureNSMA = [NSMutableArray arrayWithArray:outcomeNSMA];
    NSArray *groupArray = [sqliteData groups];
    for (int groupindex = 0; groupindex < [groupArray count]; groupindex ++)
        [exposureNSMA addObject:[groupArray objectAtIndex:groupindex]];
    availableExposureVariables = [NSMutableArray arrayWithArray:exposureNSMA];
    exposureLVE = [[LegalValuesEnter alloc] initWithFrame:chosenExposureVariable.frame AndListOfValues:exposureNSMA AndTextFieldToUpdate:exposureVariableString];
    [exposureLVE.picker selectRow:0 inComponent:0 animated:YES];
    [exposureLVE analysisStyle];
    [inputView addSubview:exposureLVE];
    [chosenOutcomeVariable setTitle:[outcomeVariableString text] forState:UIControlStateNormal];
    [inputView addSubview:outcomeVariableLabel];
    [inputView addSubview:exposureVariableLabel];
    
    exposuresNSMA = [[NSMutableArray alloc] init];
    exposuresUITV = [[UITableView alloc] initWithFrame:exposureLVE.frame style:UITableViewStylePlain];
    [exposuresUITV setDelegate:self];
    [exposuresUITV setDataSource:self];
    [exposuresUITV setTag:11000];
    [inputView addSubview:exposuresUITV];
    
    makeDummyButton = [[UIButton alloc] initWithFrame:CGRectMake(exposureLVE.frame.origin.x, exposuresUITV.frame.origin.y + exposuresUITV.frame.size.height + 4.0, exposureLVE.frame.size.width, exposureLVE.frame.size.height)];
    [makeDummyButton setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
    [makeDummyButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [makeDummyButton setTitle:@"Make Dummy" forState:UIControlStateNormal];
    [makeDummyButton addTarget:self action:@selector(makeDummyButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [inputView addSubview:makeDummyButton];

    dummiesNSMA = [[NSMutableArray alloc] init];
    dummiesUITV = [[UITableView alloc] initWithFrame:makeDummyButton.frame style:UITableViewStylePlain];
    [dummiesUITV setDelegate:self];
    [dummiesUITV setDataSource:self];
    [dummiesUITV setTag:11001];
    [inputView addSubview:dummiesUITV];
    
    groupVariableLabel = [[UILabel alloc] initWithFrame:dummiesUITV.frame];
    [groupVariableLabel setBackgroundColor:[UIColor whiteColor]];
    [groupVariableLabel setTextColor:epiInfoLightBlue];
    [groupVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [groupVariableLabel setText:@"Match Variable"];
    groupVariableLVE = [[LegalValuesEnter alloc] initWithFrame:dummiesUITV.frame AndListOfValues:outcomeNSMA AndTextFieldToUpdate:outcomeVariableString];
    [groupVariableLVE.picker selectRow:0 inComponent:0 animated:YES];
    [groupVariableLVE analysisStyle];
    [inputView addSubview:groupVariableLabel];
    [inputView addSubview:groupVariableLVE];

    avc = (AnalysisViewController *)vc;
    avDefaultContentSize = [avc getInitialContentSize];
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
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
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, frame.size.height + 168)];
                    [avc setInitialContentSize:CGSizeMake(320, self.frame.origin.y + 2.0 + inputView.frame.origin.y + inputView.frame.size.height)];
                    [chosenOutcomeVariable setFrame:CGRectMake(20, 8, 276, 44)];
                    [outcomeVariableLabel setFrame:CGRectMake(16, 8, 284, 20)];
                    [outcomeLVE setFrame:CGRectMake(10, 28, 300, 44)];
                    [chosenExposureVariable setFrame:CGRectMake(20, 56, 276, 44)];
                    [exposureVariableLabel setFrame:CGRectMake(16, 92, 284, 20)];
                    [exposureLVE setFrame:CGRectMake(10, 112, 300, 44)];
                    [exposuresUITV setFrame:CGRectMake(12, 168, 276, 132)];
                    [makeDummyButton setFrame:CGRectMake(14, exposuresUITV.frame.origin.y + exposuresUITV.frame.size.height + 4.0, inputView.frame.size.width - 28.0, exposureLVE.frame.size.height)];
                    [self setMakeDummyButtonEnabled:NO];
                    [dummiesUITV setFrame:CGRectMake(12, makeDummyButton.frame.origin.y + makeDummyButton.frame.size.height + 4.0, 276, 132)];
                    [groupVariableLabel setFrame:CGRectMake(15, dummiesUITV.frame.origin.y + dummiesUITV.frame.size.height + 4.0, 284, 20)];
                    [groupVariableLVE setFrame:CGRectMake(10, groupVariableLabel.frame.origin.y + 20 - 0, 300, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 135, 276, 44)];
                    [chooseOutcomeVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseExposureVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseStratificationVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                    [includeMissingButton setFrame:CGRectMake(170, 104, 22, 22)];
                    [includeMissingLabel setFrame:CGRectMake(20, 104, 140, 22)];
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
            if (inputViewDisplayed)
            {
                if ([avc portraitOrientation])
                {
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, 432)];
                    [chosenOutcomeVariable setFrame:CGRectMake(20, 8, 276, 44)];
                    [outcomeVariableLabel setFrame:CGRectMake(16, 8, 284, 20)];
                    [outcomeLVE setFrame:CGRectMake(10, 28, 276, 44)];
                    [chosenExposureVariable setFrame:CGRectMake(frame.size.width - 296.0, 8, 276, 44)];
                    [exposureVariableLabel setFrame:CGRectMake(frame.size.width - 300.0, 8, 284, 20)];
                    [exposureLVE setFrame:CGRectMake(frame.size.width - 306.0, 28, 276, 44)];
                    [exposuresUITV setFrame:CGRectMake(frame.size.width - 304.0, 84, 276, 132)];
                    [makeDummyButton setFrame:CGRectMake(frame.size.width - 300.0, exposuresUITV.frame.origin.y + exposuresUITV.frame.size.height + 4.0, exposureLVE.frame.size.width, exposureLVE.frame.size.height)];
                    [self setMakeDummyButtonEnabled:NO];
                    [dummiesUITV setFrame:CGRectMake(frame.size.width - 300.0, makeDummyButton.frame.origin.y + makeDummyButton.frame.size.height + 4.0, 276, 132)];
                    [groupVariableLabel setFrame:CGRectMake(16, outcomeLVE.frame.origin.y + outcomeLVE.frame.size.height + 64.0, 284, 20)];
                    [groupVariableLVE setFrame:CGRectMake(10, groupVariableLabel.frame.origin.y + 20 - 0, 276, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 220, 276, 44)];
                    [chooseOutcomeVariable setFrame:CGRectMake(10, 54, 296, 162)];
                    [chooseExposureVariable setFrame:CGRectMake(chosenExposureVariable.frame.origin.x - 10.0, 54, 296, 162)];
                    [chooseStratificationVariable setFrame:CGRectMake(10, 266, 296, 162)];
                    [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                    [includeMissingLabel setFrame:CGRectMake(chosenExposureVariable.frame.origin.x, 231, 140, 22)];
                    [includeMissingButton setFrame:CGRectMake(includeMissingLabel.frame.origin.x + 150, 231, 22, 22)];
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
}

- (void)setMakeDummyButtonEnabled:(BOOL)isEnabled
{
    [makeDummyButton setEnabled:isEnabled];
    if (isEnabled)
    {
        [makeDummyButton setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
        [makeDummyButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    else
    {
        [makeDummyButton setBackgroundColor:[UIColor colorWithRed:248/255.0 green:249/255.0 blue:251/255.0 alpha:1.0]];
        [makeDummyButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateNormal];
        exposureVariableSelected = nil;
    }
}

- (void)textFieldAction
{
    NSLog(@"exposureVariableString field value set to %@.", exposureVariableString.text);
    // REMOVE THIS WHEN READY FOR MULTIPLE REGRESSION WITH GROUP(S)
    BOOL addingAGroup = NO;
    if ([[exposureVariableString text] containsString:@" = GROUP("] || ([exposuresNSMA count] == 1 && [(NSString *)[exposuresNSMA objectAtIndex:0] containsString:@" = GROUP("]))
    {
        [exposuresNSMA removeAllObjects];
        [dummiesNSMA removeAllObjects];
        [dummiesUITV reloadData];
        if ([[exposureVariableString text] containsString:@" = GROUP("])
            addingAGroup = YES;
    }
    // REMOVE TO HERE
    if ([exposureVariableString.text length] > 0 && ![exposuresNSMA containsObject:exposureVariableString.text])
    {
        [exposuresNSMA addObject:exposureVariableString.text];
        [exposuresUITV reloadData];
        if (addingAGroup)
            [[exposuresUITV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setSelectionStyle:UITableViewCellSelectionStyleNone];
        else
            [[exposuresUITV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    [self setMakeDummyButtonEnabled:NO];
}
- (void)doubleTapAction:(UITapGestureRecognizer *)tap
{
    UITableViewCell *sender = (UITableViewCell *)[tap view];
    id superview = [sender superview];
    while (superview && [superview isKindOfClass:[UITableView class]] == NO)
        superview = [superview superview];
    UITableView *senderTV = (UITableView *)superview;

    if ([senderTV tag] == 11000)
    {
        [exposuresNSMA removeObjectAtIndex:[exposuresNSMA indexOfObject:sender.textLabel.text]];
        [exposuresUITV reloadData];
        [self setMakeDummyButtonEnabled:NO];
    }
    else if ([senderTV tag] == 11001)
    {
        [exposuresNSMA addObject:sender.textLabel.text];
        [exposuresUITV reloadData];
        [dummiesNSMA removeObjectAtIndex:[dummiesNSMA indexOfObject:sender.textLabel.text]];
        [dummiesUITV reloadData];
    }
}
- (void)singleTapAction:(UITapGestureRecognizer *)tap
{
    UITableViewCell *sender = (UITableViewCell *)[tap view];
    id superview = [sender superview];
    while (superview && [superview isKindOfClass:[UITableView class]] == NO)
        superview = [superview superview];
    UITableView *senderTV = (UITableView *)superview;
    
    if ([senderTV tag] == 11000)
    {
        if ([sender.textLabel.text isEqualToString:exposureVariableSelected])
        {
            [sender setSelected:NO];
            [self setMakeDummyButtonEnabled:NO];
        }
        else
        {
            if ([sender.textLabel.text containsString:@" GROUP("])
            {
                return;
            }
            [self setMakeDummyButtonEnabled:YES];
            exposureVariableSelected = [NSString stringWithString:sender.textLabel.text];
        }
    }
}

- (void)makeDummyButtonPressed
{
    for (int i = 0; i < [exposuresUITV numberOfRowsInSection:0]; i++)
    {
        if ([(UITableViewCell *)[exposuresUITV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]] isSelected])
        {
            [dummiesNSMA addObject:[exposuresNSMA objectAtIndex:i]];
            [dummiesUITV reloadData];
            [exposuresNSMA removeObjectAtIndex:i];
            [exposuresUITV reloadData];
        }
    }
    [self setMakeDummyButtonEnabled:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableIdentifier = @"dataline";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableIdentifier];
        [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height)];
        [cell setIndentationLevel:1];
        [cell setIndentationWidth:4];
    }
    
    if ([tableView tag] == 11000)
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", [exposuresNSMA objectAtIndex:indexPath.row]]];
    else if ([tableView tag] == 11001)
        [cell.textLabel setText:[NSString stringWithFormat:@"%@", [dummiesNSMA objectAtIndex:indexPath.row]]];
    [cell.textLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    UIView *cellBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [cellBackgroundView setBackgroundColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0]];
    [cell setSelectedBackgroundView:cellBackgroundView];
    [cell.textLabel setNumberOfLines:0];
    
    float fontSize = 16.0;
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    [doubleTap setNumberOfTapsRequired:2];
//    [doubleTap setNumberOfTouchesRequired:1];
    [cell addGestureRecognizer:doubleTap];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [cell addGestureRecognizer:singleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    unsigned long returnvalue = 0;
    if ([tableView tag] == 11000)
        returnvalue = [exposuresNSMA count];
    else if ([tableView tag] == 11001)
        returnvalue = [dummiesNSMA count];
    return returnvalue;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    [avc setInitialContentSize:avDefaultContentSize];
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
}

- (void)gearButtonPressed
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [gearButton setEnabled:NO];
        [xButton setEnabled:NO];
        [avc setDataSourceEnabled:NO];
        [avc putViewOnZoomingView:self];
        if (inputView.frame.size.height > 0)
        {
            inputViewDisplayed = NO;
            [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
                [chosenOutcomeVariable setFrame:CGRectMake(20, chosenOutcomeVariable.frame.origin.y - 170, chosenOutcomeVariable.frame.size.width, 44)];
                [chosenExposureVariable setFrame:CGRectMake(20, chosenExposureVariable.frame.origin.y - 170, chosenExposureVariable.frame.size.width, 44)];
                [outcomeLVE setFrame:CGRectMake(10, chosenOutcomeVariable.frame.origin.y - 170, chosenOutcomeVariable.frame.size.width, 44)];
                [exposureLVE setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 170, chosenExposureVariable.frame.size.width, 44)];
                [outcomeVariableLabel setFrame:CGRectMake(10, chosenOutcomeVariable.frame.origin.y - 190, chosenOutcomeVariable.frame.size.width, 44)];
                [exposureVariableLabel setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 190, chosenExposureVariable.frame.size.width, 44)];
                [exposuresUITV setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 140, chosenExposureVariable.frame.size.width, 44)];
                [makeDummyButton setFrame:CGRectMake(exposureLVE.frame.origin.x, exposuresUITV.frame.origin.y + exposuresUITV.frame.size.height, exposureLVE.frame.size.width, exposureLVE.frame.size.height)];
                [dummiesUITV setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 100, chosenExposureVariable.frame.size.width, 44)];
                [groupVariableLabel setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 80, chosenExposureVariable.frame.size.width, 20)];
                [groupVariableLVE setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 80, chosenExposureVariable.frame.size.width, 44)];
                [chosenStratificationVariable setFrame:CGRectMake(20, chosenExposureVariable.frame.origin.y - 170, chosenExposureVariable.frame.size.width, 44)];
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
            if (outputViewsNSMA && [outputViewsNSMA count] > 0)
            {
                outputView = [outputViewsNSMA objectAtIndex:0];
                for (int ovi = 1; ovi < [outputViewsNSMA count]; ovi++)
                {
                    [(UIView *)[outputViewsNSMA objectAtIndex:ovi] removeFromSuperview];
                }
                [outputViewsNSMA removeAllObjects];
            }
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
            [self setFrame:CGRectMake(0, 50, avc.view.frame.size.width, avc.view.frame.size.height - 52)];
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
            if (outputViewsNSMA)
            {
                outputView = [outputViewsNSMA objectAtIndex:0];
                for (int ovi = 1; ovi < [outputViewsNSMA count]; ovi++)
                {
                    [(UIView *)[outputViewsNSMA objectAtIndex:ovi] removeFromSuperview];
                }
                [outputViewsNSMA removeAllObjects];
            }
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
        }
        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:CGRectMake(0, 50, avc.view.frame.size.width, avc.view.frame.size.height)];
        }completion:nil];
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
    float cellWidth = 79.0;
    oddsTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, MIN(7.0 * (cellWidth + 1.0), outputV.frame.size.width - 4.0), 20.0 * ([oddsAndRisk count] + 1))];
    [oddsTableView setBackgroundColor:epiInfoLightBlue];
    [outputV addSubview:oddsTableView];
    
    UIView *underTheFirstColumnView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, cellWidth + 1, 20.0 * ([oddsAndRisk count] + 1))];
    [underTheFirstColumnView setBackgroundColor:epiInfoLightBlue];
    [outputV addSubview:underTheFirstColumnView];
    
    UIView *rightBorderView = [[UIView alloc] initWithFrame:CGRectMake(outputV.frame.size.width - 3.0, 2, 1, 20.0 * ([oddsAndRisk count] + 1))];
    [rightBorderView setBackgroundColor:epiInfoLightBlue];
    [outputV addSubview:rightBorderView];
    
    UIView *rightOfTheTableView = [[UIView alloc] initWithFrame:CGRectMake(outputV.frame.size.width - 2.0, 2, 2, 20.0 * ([oddsAndRisk count] + 1))];
    [rightOfTheTableView setBackgroundColor:[UIColor whiteColor]];
    [outputV addSubview:rightOfTheTableView];
    
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
    [oddsTableView addSubview:columnHeader];
    
    cellPositionAdjustment = 2.0;
    columnHeader = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, 1, cellWidth, 18)];
    [columnHeader setBackgroundColor:[UIColor whiteColor]];
    [columnHeader setTextColor:[UIColor blackColor]];
    [columnHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
    [columnHeader setTextAlignment:NSTextAlignmentCenter];
    [columnHeader setText:@"OR LL"];
    [oddsTableView addSubview:columnHeader];
    
    cellPositionAdjustment = 3.0;
    columnHeader = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, 1, cellWidth, 18)];
    [columnHeader setBackgroundColor:[UIColor whiteColor]];
    [columnHeader setTextColor:[UIColor blackColor]];
    [columnHeader setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
    [columnHeader setTextAlignment:NSTextAlignmentCenter];
    [columnHeader setText:@"OR UL"];
    [oddsTableView addSubview:columnHeader];
    
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
        [oddsTableView addSubview:statValue];
        
        cellPositionAdjustment = 2.0;
        statValue = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, yPos, cellWidth, 19)];
        [statValue setBackgroundColor:[UIColor whiteColor]];
        [statValue setTextColor:[UIColor blackColor]];
        [statValue setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [statValue setTextAlignment:NSTextAlignmentCenter];
        [statValue setText:[NSString stringWithFormat:@"%.2f", [[[oddsAndRisk objectAtIndex:orindex] objectAtIndex:2] floatValue]]];
        [oddsTableView addSubview:statValue];
        
        cellPositionAdjustment = 3.0;
        statValue = [[UILabel alloc] initWithFrame:CGRectMake(cellPositionAdjustment + cellPositionAdjustment * cellWidth, yPos, cellWidth, 19)];
        [statValue setBackgroundColor:[UIColor whiteColor]];
        [statValue setTextColor:[UIColor blackColor]];
        [statValue setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [statValue setTextAlignment:NSTextAlignmentCenter];
        [statValue setText:[NSString stringWithFormat:@"%.2f", [[[oddsAndRisk objectAtIndex:orindex] objectAtIndex:3] floatValue]]];
        [oddsTableView addSubview:statValue];
    }
}

- (void)doInBackground
{
    leftSide = 1.0;
    
    if ((outcomeVariableChosen || outcomeLVE.selectedIndex > 0) && ([exposuresNSMA count] > 0 || [dummiesNSMA count] > 0) && !stratificationVariableChosen)
    {
        NSString *groupOfExposures;
        NSString *stringWithVariablesAndCommas;
        NSMutableArray *arrayOfExposuresNSMAs = [[NSMutableArray alloc] init];
        BOOL groupOfDummies = NO;
        for (NSString *exposureVariableString in exposuresNSMA)
        {
            if ([exposureVariableString containsString:@" = GROUP("])
            {
                groupOfExposures = exposureVariableString;
                break;
            }
        }
        for (NSString *exposureVariableString in dummiesNSMA)
        {
            if ([exposureVariableString containsString:@" = GROUP("])
            {
                groupOfExposures = exposureVariableString;
                groupOfDummies = YES;
                break;
            }
        }
        if (groupOfExposures)
        {
            if ([exposuresNSMA containsObject:groupOfExposures])
                [exposuresNSMA removeObject:groupOfExposures];
            else if ([dummiesNSMA containsObject:groupOfExposures])
                [dummiesNSMA removeObject:groupOfExposures];
            NSRange GROUPrange = [groupOfExposures rangeOfString:@" = GROUP("];
            int lastPosition = (int)[groupOfExposures length] - 1;
            stringWithVariablesAndCommas = [[groupOfExposures substringToIndex:lastPosition] substringFromIndex:GROUPrange.location + GROUPrange.length];
            NSArray *exposureVariablesNSA = [stringWithVariablesAndCommas componentsSeparatedByString:@", "];
            for (int exposuregroupindex = 0; exposuregroupindex < [exposureVariablesNSA count]; exposuregroupindex++)
            {
                if (![availableExposureVariables containsObject:[exposureVariablesNSA objectAtIndex:exposuregroupindex]])
                    continue;
                NSMutableArray *remainingExposures = [NSMutableArray arrayWithArray:exposuresNSMA];
                [remainingExposures insertObject:[exposureVariablesNSA objectAtIndex:exposuregroupindex] atIndex:0];
                [arrayOfExposuresNSMAs addObject:remainingExposures];
            }
        }
        else
        {
            [arrayOfExposuresNSMAs addObject:exposuresNSMA];
        }
        outputViewDisplayed = YES;
        stratum = 0;
        int outcomeSelectedIndex = [outcomeLVE.selectedIndex intValue];
        
        NSMutableArray *toNSMA = [[NSMutableArray alloc] init];
        for (int exposuresetindex = 0; exposuresetindex < [arrayOfExposuresNSMAs count]; exposuresetindex++)
        {
            NSMutableArray *allExposures = [NSMutableArray arrayWithArray:(NSMutableArray *)[arrayOfExposuresNSMAs objectAtIndex:exposuresetindex]];
            for (int i = 0; i < [dummiesNSMA count]; i++)
                [allExposures addObject:[dummiesNSMA objectAtIndex:i]];
            if ([[groupVariableLVE selectedIndex] intValue] > 0)
                [allExposures insertObject:[availableOutcomeVariables objectAtIndex:[[groupVariableLVE selectedIndex] intValue]] atIndex:0];
            to = [[LogisticObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndOutcomeVariable:[availableOutcomeVariables objectAtIndex:outcomeSelectedIndex] AndExposureVariables:allExposures AndIncludeMissing:includeMissing];
            if ([[groupVariableLVE selectedIndex] intValue] > 0)
                [to setMatchVariable:[availableOutcomeVariables objectAtIndex:[[groupVariableLVE selectedIndex] intValue] - 1]];
            [toNSMA addObject:to];
        }

        if (to.outcomeValues.count == 2)
        {
            if (!outputViewsNSMA)
                outputViewsNSMA = [[NSMutableArray alloc] init];
            if (groupOfDummies && stringWithVariablesAndCommas)
                dummiesNSMA = [NSMutableArray arrayWithArray:[stringWithVariablesAndCommas componentsSeparatedByString:@", "]];
            to = [toNSMA objectAtIndex:0];
            summaryTable = [[NSMutableArray alloc] init];
            [summaryTable addObject:[[NSMutableArray alloc] init]];
            UIView *outputViewZero;
            if ([toNSMA count] > 1)
            {
                float initialOutputViewX = outputView.frame.origin.x;
                initialOutputViewY = outputView.frame.origin.y;
                float initialOutputViewWidth = outputView.frame.size.width;
                float initialOutputViewHeight = outputView.frame.size.height;
                float newOutputViewY = initialOutputViewY + 20.0 * (1.0 + (float)[toNSMA count]) + 4;
                [outputView setFrame:CGRectMake(initialOutputViewX, newOutputViewY, initialOutputViewWidth, initialOutputViewHeight)];
                outputViewZero = [[UIView alloc] initWithFrame:CGRectMake(initialOutputViewX, initialOutputViewY, initialOutputViewWidth, 20.0 * (1.0 + (float)[toNSMA count]))];
                [self addSubview:outputViewZero];
            }
            [self doLogistic:to OnOutputView:outputView StratificationVariable:nil StratificationValue:nil];
            [outputViewsNSMA addObject:outputView];
            for (int toindex = 1; toindex < [toNSMA count]; toindex++)
            {
                float ovX = outputView.frame.origin.x;
                float ovWidth = outputView.frame.size.width;
                float ovHeight = outputView.frame.size.height;
                float ovY = outputView.frame.origin.y + ovHeight + 4.0;
                outputView = [[UIView alloc] initWithFrame:CGRectMake(ovX, ovY, ovWidth, ovHeight)];
                [outputView setBackgroundColor:[UIColor whiteColor]];
                [self addSubview:outputView];
                to = [toNSMA objectAtIndex:toindex];
                [summaryTable addObject:[[NSMutableArray alloc] init]];
                [self doLogistic:to OnOutputView:outputView StratificationVariable:nil StratificationValue:[NSString stringWithFormat:@"%d", toindex]];
                [outputViewsNSMA addObject:outputView];
            }
            if ([summaryTable count] > 1)
                [self doGroupVariableSummaries:summaryTable OnOutputView:outputViewZero];
            if (groupOfDummies)
                [dummiesNSMA removeAllObjects];
//            if ([toNSMA count] > 1)
//                [avc putViewOnEpiInfoScrollView:self];
        }
        else
        {
            UILabel *feedbackLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, outputView.frame.size.width - 16, 32)];
            [feedbackLabel setTextColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0]];
            [feedbackLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [feedbackLabel setText:@"Dependent variable must have 2 values."];
            [outputView addSubview:feedbackLabel];
            [spinner setHidden:YES];
            [spinner stopAnimating];
            [gearButton setEnabled:YES];
            [xButton setEnabled:YES];
            [avc setDataSourceEnabled:YES];
            return;
        }
        to = nil;
        if (groupOfExposures && !groupOfDummies && ![exposuresNSMA containsObject:groupOfExposures])
            [exposuresNSMA insertObject:groupOfExposures atIndex:0];
        else if (groupOfExposures && groupOfDummies && ![dummiesNSMA containsObject:groupOfExposures])
            [dummiesNSMA insertObject:groupOfExposures atIndex:0];
    }
    
    [spinner setHidden:YES];
    [spinner stopAnimating];
    [gearButton setEnabled:YES];
    [xButton setEnabled:YES];
    [avc setDataSourceEnabled:YES];
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
        if (NO) // Don't do this anymore
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

- (void)createSettings:(NSDictionary *)inputVariableList outcomesAndValues:(NSArray *)outcomeValues
{
    mstrC = @"95";
    mdblC = 0.05;
    mdblP = [SharedResources zFromP:mdblC * 0.5];
    mlngIter = 15;
    mdblConv = 0.00001;
    mdblToler = 0.000001;
    mboolIntercept = NO;
    mstraBoolean = @[@"No", @"Yes", @"Missing"];
    mstrMatchVar = @"";
    mstrWeightVar = @"";
    mstrDependVar = @"";
    mstraTerms = [[NSMutableArray alloc] init];
    mStrADiscrete = [[NSMutableArray alloc] init];
    terms = 0, discrete = 0;
    
    for (id key in inputVariableList)
    {
        if ([[(NSString *)[inputVariableList objectForKey:key] lowercaseString] isEqualToString:@"term"])
        {
            [mstraTerms setObject:(NSString *)key atIndexedSubscript:terms];
            terms++;
        }
        if ([[(NSString *)[inputVariableList objectForKey:key] lowercaseString] isEqualToString:@"discrete"])
        {
            [mStrADiscrete setObject:(NSString *)key atIndexedSubscript:discrete];
            discrete++;
            
            [mstraTerms setObject:(NSString *)key atIndexedSubscript:terms];
            terms++;
        }
        if ([[(NSString *)[inputVariableList objectForKey:key] lowercaseString] isEqualToString:@"matchvar"])
        {
            mstrMatchVar = (NSString *)key;
        }
        if ([[(NSString *)[inputVariableList objectForKey:key] lowercaseString] isEqualToString:@"weightvar"])
        {
            mstrWeightVar = (NSString *)key;
        }
        if ([[(NSString *)[inputVariableList objectForKey:key] lowercaseString] isEqualToString:@"dependvar"])
        {
            mstrDependVar = (NSString *)key;
        }
        if ([[(NSString *)key lowercaseString] isEqualToString:@"intercept"])
        {
            mboolIntercept = [(NSString *)[inputVariableList objectForKey:key] boolValue];
        }
        if ([[(NSString *)key lowercaseString] isEqualToString:@"p"])
        {
            mdblP = [(NSString *)[inputVariableList objectForKey:key] doubleValue];
            mdblC = 1.0 - mdblP;
            mstrC = [NSString stringWithFormat:@"%f", mdblP * 100.0];
            mdblP = [SharedResources zFromP:mdblC * 0.5];
        }
        if ([[(NSString *)[inputVariableList objectForKey:key] lowercaseString] isEqualToString:@"unsorted"])
        {
            if (YES) // check for not more than 2 values
            {
                [mStrADiscrete setObject:key atIndexedSubscript:discrete];
                discrete++;
            }
            [mstraTerms setObject:key atIndexedSubscript:terms];
            terms++;
        }
    }
}

- (BOOL)getCurrentTableOfOutcomeVariable:(NSString *)outcomeVariable AndIndependentVariables:(NSArray *)independentVariables
{
    NSMutableArray *mutableCurrentTable = [[NSMutableArray alloc] init];
    
    lStrAVarNames = [NSArray arrayWithArray:independentVariables];
    
    int columnsQueried = 1 + (int)[independentVariables count] + 1;
    
    //Get the path to the sqlite database
    NSString *databasePath = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingString:@"EpiInfo.db"]];
    
    //If the database exists, query the WORKING_DATASET
    if ([[NSFileManager defaultManager] fileExistsAtPath:databasePath])
    {
        //Convert the databasePath to a char array
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt *statement;
        
        //Open the database
        if (sqlite3_open(dbpath, &analysisDB) == SQLITE_OK)
        {
            //Build the SELECT statement
            NSMutableString *selectStatement = [[NSMutableString alloc] initWithString:
                                                [NSString stringWithFormat:@"SELECT %@, %@", outcomeVariable, [independentVariables objectAtIndex:0]]];
            for (int i = 1; i < independentVariables.count; i++)
                [selectStatement appendString:[NSString stringWithFormat:@", %@", [independentVariables objectAtIndex:i]]];
            [selectStatement appendFormat:@", 1 as RecStatus FROM WORKING_DATASET"];
            //Convert the SELECT statement to a char array
            const char *query_stmt = [selectStatement UTF8String];
            //Execute the SELECT statement
            if (sqlite3_prepare_v2(analysisDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
            {
                //While the statement returns rows, read the column queried and put the values in the outcomeArray and exposureArray
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    NSMutableArray *outcomeArray = [[NSMutableArray alloc] init];
                    for (int i = 0; i < columnsQueried; i++)
                    {
                        if (!sqlite3_column_text(statement, i))
                        {
                            [outcomeArray addObject:[NSNull null]];
                        }
                        else
                        {
                            NSString *rslt0 = [NSString stringWithUTF8String:[[NSString stringWithFormat:@"%s", sqlite3_column_text(statement, i)] cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                            NSString *rslt = [NSString stringWithUTF8String:[rslt0 cStringUsingEncoding:NSMacOSRomanStringEncoding]];
                            [outcomeArray addObject:rslt];
                        }
                    }
                    [mutableCurrentTable addObject:[NSArray arrayWithArray:outcomeArray]];
                }
            }
        }
    }
    
    [self removeRecordsWithNulls:mutableCurrentTable];
    if (![self outcomeOneZero:mutableCurrentTable])
        return NO;
    [self checkIndependentVariables:mutableCurrentTable VariableNames:independentVariables];
    currentTable = [NSArray arrayWithArray:mutableCurrentTable];
    
    return YES;
}

- (void)getRawData
{
    if ([mstrMatchVar length] > 0)
        mboolIntercept = NO;
    if (mboolIntercept == YES)
        lintIntercept = 1;
    else
        lintIntercept = 0;
    if ([mstrWeightVar length] > 0)
        lintweight = 1;
    else
        lintweight = 0;
    
    int k = 0;
    k = 0;
    NSDate *d = [NSDate date];
    d = [NSDate date];
    NumRows = (int)[currentTable count];
    NumColumns = (int)[(NSArray *)[currentTable firstObject] count];
    
    if (NumRows == 0)
        return;
    
    int lIntIsMatch = 0;
    lIntIsMatch = 0;
    
    if ([mstrMatchVar length] > 0)
    {
        // Match Variable Matching write this later
        int i = 0;
        i = 0;
        int lintnull = 0;
        lintnull = 0;
    }
    
    NSMutableArray *mVarArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [lStrAVarNames count]; i++)
    {
        [mVarArray setObject:@"" atIndexedSubscript:i];
    }
}

- (void)removeRecordsWithNulls:(NSMutableArray *)currentTableMA
{
    for (int i = (int)[currentTableMA count] - 1; i >= 0; i--)
    {
        NSArray *rowArrayCopy = [NSArray arrayWithArray:(NSArray*)[currentTableMA objectAtIndex:i]];
        for (int j = 0; j < [rowArrayCopy count]; j++)
        {
            NSString *cellvalue = (NSString *)[rowArrayCopy objectAtIndex:j];
            if ([cellvalue isEqualToString:@"(null)"])
            {
                [currentTableMA removeObjectAtIndex:i];
                break;
            }
        }
    }
}
- (BOOL)outcomeOneZero:(NSMutableArray *)currentTableMA
{
    BOOL isOneZero = YES;
    BOOL isYesNo = YES;
    BOOL isOneTwo = YES;
    for (int i = 0; i < [currentTableMA count]; i++)
    {
        NSArray *lnsa = (NSArray *)[currentTableMA objectAtIndex:i];
        NSString *loutcome = (NSString *)[lnsa objectAtIndex:0];
        if (isOneZero)
            if (!([loutcome isEqualToString:@"1"] || [loutcome isEqualToString:@"0"]))
                isOneZero = NO;
        if (isOneTwo)
            if (!([loutcome isEqualToString:@"1"] || [loutcome isEqualToString:@"2"]))
                isOneTwo = NO;
        if (isYesNo)
            if (!([loutcome caseInsensitiveCompare:@"yes"] == NSOrderedSame || [loutcome caseInsensitiveCompare:@"no"] == NSOrderedSame))
                isYesNo = NO;
        if (!(isOneZero || isOneTwo || isYesNo))
            return NO;
    }
    if (isOneTwo)
    {
        for (int i = 0; i < [currentTableMA count]; i++)
        {
            if ([(NSString *)[(NSArray *)[currentTableMA objectAtIndex:i] objectAtIndex:0] isEqualToString:@"2"])
            {
                NSMutableArray *lnsmai = [NSMutableArray arrayWithArray:[currentTableMA objectAtIndex:i]];
                [lnsmai setObject:@"0" atIndexedSubscript:0];
                [currentTableMA setObject:[NSArray arrayWithArray:lnsmai] atIndexedSubscript:i];
            }
            
        }
    }
    if (isYesNo)
    {
        for (int i = 0; i < [currentTableMA count]; i++)
        {
            if ([(NSString *)[(NSArray *)[currentTableMA objectAtIndex:i] objectAtIndex:0] caseInsensitiveCompare:@"yes"] == NSOrderedSame)
            {
                NSMutableArray *lnsmai = [NSMutableArray arrayWithArray:[currentTableMA objectAtIndex:i]];
                [lnsmai setObject:@"1" atIndexedSubscript:0];
                [currentTableMA setObject:[NSArray arrayWithArray:lnsmai] atIndexedSubscript:i];
            }
            else if ([(NSString *)[(NSArray *)[currentTableMA objectAtIndex:i] objectAtIndex:0] caseInsensitiveCompare:@"no"] == NSOrderedSame)
            {
                NSMutableArray *lnsmai = [NSMutableArray arrayWithArray:[currentTableMA objectAtIndex:i]];
                [lnsmai setObject:@"0" atIndexedSubscript:0];
                [currentTableMA setObject:[NSArray arrayWithArray:lnsmai] atIndexedSubscript:i];
            }

        }
    }
    return YES;
}
- (void)checkIndependentVariables:(NSMutableArray *)currentTableMA VariableNames:(NSArray *)independentVariables
{
    NSMutableArray *variablesNeedingDummies = [[NSMutableArray alloc] init];
    NSMutableArray *valuesForDummies = [[NSMutableArray alloc] init];
    NSArray *rowOne = (NSArray *)[currentTableMA objectAtIndex:0];
    for (int j = 1; j < [rowOne count] - 1; j++)
    {
        BOOL isOneZero = YES;
        BOOL isYesNo = YES;
        BOOL isOneTwo = YES;
        BOOL isNumeric = YES;
        NSCharacterSet *numberSet = [NSCharacterSet decimalDigitCharacterSet];
        for (int i = 0; i < [currentTableMA count]; i++)
        {
            NSArray *lnsa = (NSArray *)[currentTableMA objectAtIndex:i];
            NSString *loutcome = (NSString *)[lnsa objectAtIndex:j];
            if (isOneZero)
                if (!([loutcome isEqualToString:@"1"] || [loutcome isEqualToString:@"0"]))
                    isOneZero = NO;
            if (isOneTwo)
                if (!([loutcome isEqualToString:@"1"] || [loutcome isEqualToString:@"2"]))
                    isOneTwo = NO;
            if (isYesNo)
                if (!([loutcome caseInsensitiveCompare:@"yes"] == NSOrderedSame || [loutcome caseInsensitiveCompare:@"no"] == NSOrderedSame))
                    isYesNo = NO;
            if (isNumeric)
            {
                if ([loutcome characterAtIndex:0] == '-')
                    loutcome = [loutcome substringFromIndex:1];
                if ([[loutcome stringByTrimmingCharactersInSet:numberSet] length] > 0)
                {
                    loutcome = [loutcome stringByTrimmingCharactersInSet:numberSet];
                    if (![loutcome isEqualToString:@"."])
                        isNumeric = NO;
                }
            }
        }
        if (isOneTwo)
        {
            for (int i = 0; i < [currentTableMA count]; i++)
            {
                if ([(NSString *)[(NSArray *)[currentTableMA objectAtIndex:i] objectAtIndex:j] isEqualToString:@"2"])
                {
                    NSMutableArray *lnsmai = [NSMutableArray arrayWithArray:[currentTableMA objectAtIndex:i]];
                    [lnsmai setObject:@"0" atIndexedSubscript:j];
                    [currentTableMA setObject:[NSArray arrayWithArray:lnsmai] atIndexedSubscript:i];
                }
                
            }
        }
        if (isYesNo)
        {
            for (int i = 0; i < [currentTableMA count]; i++)
            {
                if ([(NSString *)[(NSArray *)[currentTableMA objectAtIndex:i] objectAtIndex:j] caseInsensitiveCompare:@"yes"] == NSOrderedSame)
                {
                    NSMutableArray *lnsmai = [NSMutableArray arrayWithArray:[currentTableMA objectAtIndex:i]];
                    [lnsmai setObject:@"1" atIndexedSubscript:j];
                    [currentTableMA setObject:[NSArray arrayWithArray:lnsmai] atIndexedSubscript:i];
                }
                else if ([(NSString *)[(NSArray *)[currentTableMA objectAtIndex:i] objectAtIndex:j] caseInsensitiveCompare:@"no"] == NSOrderedSame)
                {
                    NSMutableArray *lnsmai = [NSMutableArray arrayWithArray:[currentTableMA objectAtIndex:i]];
                    [lnsmai setObject:@"0" atIndexedSubscript:j];
                    [currentTableMA setObject:[NSArray arrayWithArray:lnsmai] atIndexedSubscript:i];
                }
                
            }
        }
        else if (!isNumeric || [dummiesNSMA containsObject:[independentVariables objectAtIndex:j - 1]])
        {
            [variablesNeedingDummies addObject:[NSNumber numberWithInt:j]];
            NSMutableArray *valuesForThisJ = [[NSMutableArray alloc] init];
            for (int i = 0; i < [currentTableMA count]; i++)
            {
                NSMutableArray *lnsmai = [NSMutableArray arrayWithArray:[currentTableMA objectAtIndex:i]];
                NSString *lnsmaij = (NSString *)[lnsmai objectAtIndex:j];
                if (![valuesForThisJ containsObject:lnsmaij])
                    [valuesForThisJ addObject:lnsmaij];
            }
            [valuesForThisJ sortUsingSelector:@selector(localizedStandardCompare:)];
            [valuesForThisJ removeObjectAtIndex:0];
            [valuesForDummies addObject:valuesForThisJ];
        }
    }
    if ([variablesNeedingDummies count] > 0)
    {
        [self makeDummies:currentTableMA OfVariableIndexes:variablesNeedingDummies ForValues:valuesForDummies VariableNames:independentVariables];
    }
}
-(void)makeDummies:(NSMutableArray *)currentTableMA OfVariableIndexes:(NSMutableArray *)variablesNeedingDummies ForValues:(NSArray *)valuesForDummies VariableNames:(NSArray *)independentVariables
{
    if ([variablesNeedingDummies count] != [valuesForDummies count])
        return;
    NSMutableArray *newIndependentVariables = [NSMutableArray arrayWithArray:to.exposureVariables];
    for (int i = 0; i < [variablesNeedingDummies count]; i++)
    {
        int indexOfVariable = [(NSNumber *)[variablesNeedingDummies objectAtIndex:i] intValue];
        NSArray *valuesi = (NSArray *)[valuesForDummies objectAtIndex:i];
        for (int j = 0; j < [currentTableMA count]; j++)
        {
            NSMutableArray *nsmaij = [NSMutableArray arrayWithArray:[currentTableMA objectAtIndex:j]];
            for (int k = (int)[valuesi count] - 1; k > 0; k--)
            {
                [nsmaij insertObject:@"" atIndex:indexOfVariable + 1];
                if (j == 0)
                {
                    if (indexOfVariable - 1 < [newIndependentVariables count])
                        [newIndependentVariables insertObject:@"" atIndex:indexOfVariable];
                    else
                        [newIndependentVariables addObject:@""];
                }
            }
            for (int k = (int)[valuesi count] - 1; k >= 0; k--)
            {
                if ([(NSString *)[nsmaij objectAtIndex:indexOfVariable] isEqualToString:[valuesi objectAtIndex:k]])
                    [nsmaij setObject:@"1" atIndexedSubscript:indexOfVariable + k];
                else
                    [nsmaij setObject:@"0" atIndexedSubscript:indexOfVariable + k];
                if (j == 0)
                    [newIndependentVariables setObject:[valuesi objectAtIndex:k] atIndexedSubscript:indexOfVariable - 1 + k];
            }
            [currentTableMA replaceObjectAtIndex:j withObject:nsmaij];
        }
    }
    [to setExposureVariables:[NSArray arrayWithArray:newIndependentVariables]];
}

- (void)doLogistic:(LogisticObject *)to OnOutputView:(UIView *)outputV StratificationVariable:(NSString *)stratVar StratificationValue:(NSString *)stratValue
{
    NSLog(@"Beginning Logistic method");
    NSMutableDictionary *inputVariableList = [[NSMutableDictionary alloc] init];
    [inputVariableList setObject:@"dependvar" forKey:to.outcomeVariable];
    [inputVariableList setObject:@"YES" forKey:@"intercept"];
    [inputVariableList setObject:@"false" forKey:@"includemissing"];
    [inputVariableList setObject:@"0.95" forKey:@"P"];
    [inputVariableList setObject:@"unsorted" forKey:to.exposureVariable];
    if ([groupVariableLVE.selectedIndex intValue] > 0)
        [inputVariableList setObject:@"matchvar" forKey:[availableOutcomeVariables objectAtIndex:[groupVariableLVE.selectedIndex intValue] - 1]];
    [self createSettings:[NSDictionary dictionaryWithDictionary:inputVariableList] outcomesAndValues:to.outcomeValues];
    
    LogisticRegressionResults *regressionResults = [[LogisticRegressionResults alloc] init];
    
    if (![self getCurrentTableOfOutcomeVariable:to.outcomeVariable AndIndependentVariables:to.exposureVariables])
        return;
    [self getRawData];
    
    int lintConditional = 0;
    int lintweight = 0;
    double ldblFirstLikelihood = 0.0;
    ldblFirstLikelihood = 0.0;
    double ldblScore = 0.0;
    
    mboolFirst = YES;
    mMatrixLikelihood = [[EIMatrix alloc] initWithFirst:mboolFirst AndIntercept:mboolIntercept];
    if ([groupVariableLVE.selectedIndex intValue] > 0)
    {
        [mMatrixLikelihood setMstrMatchVar:[availableOutcomeVariables objectAtIndex:[groupVariableLVE.selectedIndex intValue] - 1]];
        lintConditional = 1;
        NumColumns--;
        // Count the number of groups
        NSMutableArray *groupValues = [[NSMutableArray alloc] init];
        for (int i = 0; i < [currentTable count]; i++)
        {
            NSString *groupValue = [(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:1];
            if (![groupValues containsObject:groupValue])
                [groupValues addObject:groupValue];
        }
        [mMatrixLikelihood setMatchGroupValues:(int)[groupValues count]];
    }
    else
        [mMatrixLikelihood setMstrMatchVar:@""];
    [mMatrixLikelihood MaximizeLikelihood:NumRows NCols:NumColumns DataArray:currentTable LintOffset:lintweight + lintConditional + 1 LintMatrixSize:NumColumns - (lintweight + lintConditional + 1) LlngIters:&(mlngIter) LdblToler:&(mdblToler) LdblConv:&(mdblConv) BooStartAtZero:NO];
    
    // Beta coefficients are in mMatixLikelihood.mdblaB
    // Beta variances are in mMatrixLikelihood.mdblaInv
    
    if (!mMatrixLikelihood.mboolConverge)
    {
        regressionResults.errorMessage = mMatrixLikelihood.lstrError;
        regressionResults.convergence = @"Did not converge";
        return;
    }
    else
    {
        regressionResults.convergence = @"Converged";
    }
    
    // Compute SEs and MoEs and ORs and LCLs and UCLs and Zs and Ps
    double mdblP = [SharedResources zFromP:0.025];
    NSMutableArray *seArray = [[NSMutableArray alloc] init];
    NSMutableArray *moeArray = [[NSMutableArray alloc] init];
    NSMutableArray *orArray = [[NSMutableArray alloc] init];
    NSMutableArray *lclArray = [[NSMutableArray alloc] init];
    NSMutableArray *uclArray = [[NSMutableArray alloc] init];
    NSMutableArray *zArray = [[NSMutableArray alloc] init];
    NSMutableArray *pArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [mMatrixLikelihood.mdblaB count]; i++)
    {
        [orArray setObject:[NSNumber numberWithDouble:exp([(NSNumber *)[mMatrixLikelihood.mdblaB objectAtIndex:i] doubleValue])] atIndexedSubscript:i];
        [seArray setObject:[NSNumber numberWithDouble:sqrt(fabs([(NSNumber *)[(NSArray *)[mMatrixLikelihood.mdblaInv objectAtIndex:i] objectAtIndex:i] doubleValue]))] atIndexedSubscript:i];
        [moeArray setObject:[NSNumber numberWithDouble:mdblP * [(NSNumber *)[seArray objectAtIndex:i] doubleValue]] atIndexedSubscript:i];
        [lclArray setObject:[NSNumber numberWithDouble:exp([(NSNumber *)[mMatrixLikelihood.mdblaB objectAtIndex:i] doubleValue] - [(NSNumber *)[moeArray objectAtIndex:i] doubleValue])] atIndexedSubscript:i];
        [uclArray setObject:[NSNumber numberWithDouble:exp([(NSNumber *)[mMatrixLikelihood.mdblaB objectAtIndex:i] doubleValue] + [(NSNumber *)[moeArray objectAtIndex:i] doubleValue])] atIndexedSubscript:i];
        [zArray setObject:[NSNumber numberWithDouble:[(NSNumber *)[mMatrixLikelihood.mdblaB objectAtIndex:i] doubleValue] / [(NSNumber *)[seArray objectAtIndex:i] doubleValue]] atIndexedSubscript:i];
        [pArray setObject:[NSNumber numberWithDouble:2.0 * [SharedResources pFromZ:fabs([(NSNumber *)[zArray objectAtIndex:i] doubleValue])]] atIndexedSubscript:i];
    }
    
    ldblScore = mMatrixLikelihood.mdblScore;
    double lldblDF = [mMatrixLikelihood.mdblaB count];
    if (mboolIntercept)
        lldblDF--;
    double scoreP = [SharedResources PValFromChiSq:ldblScore PVFCSdf:lldblDF];
    
    double lllr = 2.0 * (mMatrixLikelihood.mdbllllast - mMatrixLikelihood.mdblllfst);
    double lrP = [SharedResources PValFromChiSq:lllr PVFCSdf:lldblDF];
    
    double minusTwoLogLikelihood = -2.0 * mMatrixLikelihood.mdbllllast;
    
    [regressionResults setVariables:[NSMutableArray arrayWithArray:to.exposureVariables]];
    int ismatchedanalysis = 0;
    if ([groupVariableLVE.selectedIndex intValue] == 0)
    {
        [regressionResults.variables addObject:@"CONSTANT"];
    }
    else
    {
        [regressionResults.variables removeObjectAtIndex:0];
        ismatchedanalysis = 1;
    }
    [regressionResults setBetas:[NSArray arrayWithArray:mMatrixLikelihood.mdblaB]];
    [regressionResults setStandardErrors:[NSArray arrayWithArray:seArray]];
    [regressionResults setOddsRatios:[NSArray arrayWithArray:orArray]];
    [regressionResults setLcls:[NSArray arrayWithArray:lclArray]];
    [regressionResults setUcls:[NSArray arrayWithArray:uclArray]];
    [regressionResults setZStatistics:[NSArray arrayWithArray:zArray]];
    [regressionResults setPValues:[NSArray arrayWithArray:pArray]];
    [regressionResults setScoreStatistic:ldblScore];
    [regressionResults setScoreDF:lldblDF];
    [regressionResults setScoreP:scoreP];
    [regressionResults setLRStatistic:lllr];
    [regressionResults setLRDF:lldblDF];
    [regressionResults setLRP:lrP];
    [regressionResults setFinalLikelihood:minusTwoLogLikelihood];
    [regressionResults setIterations:mMatrixLikelihood.mintIterations];
    NSLog(@"Ending Logistic method");
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone || UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
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
            [stratumHeader setFont:[UIFont boldSystemFontOfSize:18.0]];
            [stratumHeader setTextAlignment:NSTextAlignmentCenter];
            [outputV addSubview:stratumHeader];
        }
        
        //Make the view for the actual 2x2 table
        outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 168)];
        [outputTableView setBackgroundColor:epiInfoLightBlue];
        [outputTableView.layer setCornerRadius:10.0];
//        [outputV addSubview:outputTableView];
        
        double cellWidth = 76;
        
        //Set initial font sizes
        float outcomeVariableLabelFontSize = 16.0;
        float exposureVariableLabelFontSize = 16.0;
        float outcomeValueFontSize = 16.0;
        float exposureValueFontSize = 16.0;
        
        //Reduce font sizes until they fit
        //        while ([to.outcomeVariable sizeWithFont:[UIFont boldSystemFontOfSize:outcomeVariableLabelFontSize]].width > 120)
        // Deprecation replacement
        while ([to.outcomeVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:outcomeVariableLabelFontSize]}].width > 120)
            outcomeVariableLabelFontSize -= 0.1;
        //        while ([to.exposureVariable sizeWithFont:[UIFont boldSystemFontOfSize:exposureVariableLabelFontSize]].width > 120)
        // Deprecation replacement
        while ([to.exposureVariable sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:exposureVariableLabelFontSize]}].width > 120)
            exposureVariableLabelFontSize -= 0.1;
        float outcomeValueWidthWithFont = 0.0;
        for (int i = 0; i < to.outcomeValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
            outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:outcomeValueFontSize]}].width);
        }
        float exposureValueWidthWithFont = 0.0;
        for (int i = 0; i < to.exposureValues.count; i++)
        {
            NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
            exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:exposureValueFontSize]}].width);
        }
        while (outcomeValueWidthWithFont > cellWidth)
        {
            outcomeValueFontSize -= 0.1;
            outcomeValueWidthWithFont = 0.0;
            for (int i = 0; i < to.outcomeValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:i]];
                outcomeValueWidthWithFont = MAX(outcomeValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:outcomeValueFontSize]}].width);
            }
        }
        while (exposureValueWidthWithFont > 50)
        {
            exposureValueFontSize -= 0.1;
            exposureValueWidthWithFont = 0.0;
            for (int i = 0; i < to.exposureValues.count; i++)
            {
                NSString *tempStr = [NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]];
                exposureValueWidthWithFont = MAX(exposureValueWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:exposureValueFontSize]}].width);
            }
        }
        
        EpiInfoUILabel *outcomeVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79, 0, 2 * cellWidth + 2, 20)];
        [outcomeVariableLabel setText:to.outcomeVariable];
        [outcomeVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [outcomeVariableLabel setTextColor:[UIColor whiteColor]];
        [outcomeVariableLabel setBackgroundColor:[UIColor clearColor]];
        [outcomeVariableLabel setFont:[UIFont boldSystemFontOfSize:outcomeVariableLabelFontSize]];
        [outputTableView addSubview:outcomeVariableLabel];
        EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(-45, 70, 120, 20)];
        [exposureVariableLabel setText:to.exposureVariable];
        [exposureVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        [exposureVariableLabel setTextColor:[UIColor whiteColor]];
        [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
        [exposureVariableLabel setFont:[UIFont boldSystemFontOfSize:exposureVariableLabelFontSize]];
        [outputTableView addSubview:exposureVariableLabel];
        
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
            [exposureValueLabel setFont:[UIFont boldSystemFontOfSize:exposureValueFontSize]];
            if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                [exposureValueLabel setText:@"Missing"];
            else if ([[to.exposureValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[to.exposureValues objectAtIndex:i] isEqualToString:@"(null)"])
                [exposureValueLabel setText:@"Missing"];
            else
                [exposureValueLabel setText:[NSString stringWithFormat:@"%@", [to.exposureValues objectAtIndex:i]]];
            [outputTableView addSubview:exposureValueLabel];
            for (int j = 0; j < to.outcomeValues.count; j++)
            {
                if (i == 0)
                {
                    EpiInfoUILabel *outcomeValueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 20, cellWidth, 20)];
                    [outcomeValueLabel setBackgroundColor:[UIColor clearColor]];
                    [outcomeValueLabel setTextAlignment:NSTextAlignmentCenter];
                    [outcomeValueLabel setTextColor:[UIColor whiteColor]];
                    [outcomeValueLabel setFont:[UIFont boldSystemFontOfSize:outcomeValueFontSize]];
                    if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSNull class]])
                        [outcomeValueLabel setText:@"Missing"];
                    else if ([[to.outcomeValues objectAtIndex:j] isKindOfClass:[NSString class]] && [[to.outcomeValues objectAtIndex:j] isEqualToString:@"(null)"])
                        [outcomeValueLabel setText:@"Missing"];
                    else
                        [outcomeValueLabel setText:[NSString stringWithFormat:@"%@", [to.outcomeValues objectAtIndex:j]]];
                    [outputTableView addSubview:outcomeValueLabel];
                }
                UIView *countView = [[UIView alloc] initWithFrame:CGRectMake(79 + j * (cellWidth + 2), 42 + i * 42, cellWidth, 40)];
                [countView setBackgroundColor:[UIColor whiteColor]];
                [countView.layer setCornerRadius:10.0];
                EpiInfoUILabel *countLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
                [countLabel setText:[NSString stringWithFormat:@"%@", [to.cellCounts objectAtIndex:k]]];
                [countLabel setTextAlignment:NSTextAlignmentCenter];
                [countLabel setBackgroundColor:[UIColor clearColor]];
                [countLabel setFont:[UIFont systemFontOfSize:16.0]];
                [countView addSubview:countLabel];
                EpiInfoUILabel *rowPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 16, cellWidth - 1, 12)];
                [rowPctLabel setTextAlignment:NSTextAlignmentRight];
                [rowPctLabel setBackgroundColor:[UIColor clearColor]];
                [rowPctLabel setTextColor:[UIColor lightGrayColor]];
                [rowPctLabel setFont:[UIFont systemFontOfSize:12.0]];
                [countView addSubview:rowPctLabel];
                EpiInfoUILabel *colPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
                [colPctLabel setTextAlignment:NSTextAlignmentRight];
                [colPctLabel setBackgroundColor:[UIColor clearColor]];
                [colPctLabel setTextColor:[UIColor lightGrayColor]];
                [colPctLabel setFont:[UIFont systemFontOfSize:12.0]];
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
                [outputTableView addSubview:countView];
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
        [rowOneRowPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [rowOneRowPctLabel setText:@"100%"];
        [rowOneView addSubview:rowOneRowPctLabel];
        EpiInfoUILabel *rowOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowOneColPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [rowOneColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + yn) / (float)(yy + yn + ny + nn)]];
        [rowOneView addSubview:rowOneColPctLabel];
        [outputTableView addSubview:rowOneView];
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
        [rowTwoRowPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [rowTwoRowPctLabel setText:@"100%"];
        [rowTwoView addSubview:rowTwoRowPctLabel];
        EpiInfoUILabel *rowTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [rowTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [rowTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [rowTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [rowTwoColPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [rowTwoColPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(ny + nn) / (float)(yy + yn + ny + nn)]];
        [rowTwoView addSubview:rowTwoColPctLabel];
        [outputTableView addSubview:rowTwoView];
        
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
        [colOneRowPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [colOneRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yy + ny) / (float)(yy + yn + ny + nn)]];
        [columnOneView addSubview:colOneRowPctLabel];
        EpiInfoUILabel *colOneColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colOneColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colOneColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colOneColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colOneColPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [colOneColPctLabel setText:@"100%"];
        [columnOneView addSubview:colOneColPctLabel];
        [outputTableView addSubview:columnOneView];
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
        [colTwoRowPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [colTwoRowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * (float)(yn + nn) / (float)(yy + yn + ny + nn)]];
        [columnTwoView addSubview:colTwoRowPctLabel];
        EpiInfoUILabel *colTwoColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [colTwoColPctLabel setTextAlignment:NSTextAlignmentRight];
        [colTwoColPctLabel setBackgroundColor:[UIColor clearColor]];
        [colTwoColPctLabel setTextColor:[UIColor lightGrayColor]];
        [colTwoColPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [colTwoColPctLabel setText:@"100%"];
        [columnTwoView addSubview:colTwoColPctLabel];
        [outputTableView addSubview:columnTwoView];
        
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
        [totalRowPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [totalRowPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalRowPctLabel];
        EpiInfoUILabel *totalColPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
        [totalColPctLabel setTextAlignment:NSTextAlignmentRight];
        [totalColPctLabel setBackgroundColor:[UIColor clearColor]];
        [totalColPctLabel setTextColor:[UIColor lightGrayColor]];
        [totalColPctLabel setFont:[UIFont systemFontOfSize:12.0]];
        [totalColPctLabel setText:@"100%"];
        [totalTotalView addSubview:totalColPctLabel];
        [outputTableView addSubview:totalTotalView];
        
        //Compute and display the statistics
        Twox2Compute *computer = [[Twox2Compute alloc] init];
        double ExactResults[4];
        [computer CalcPoly:yy CPyn:yn CPny:ny CPnn:nn CPExactResults:ExactResults];
        double RRstats[12];
        [computer RRStats:yy RRSb:yn RRSc:ny RRSd:nn RRSstats:RRstats];
        
        //Add the views for each section of statistics
        oddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 44 + 22.0 * (double)([regressionResults.variables count] - 1 + ismatchedanalysis))];
        [oddsBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [outputV addSubview:oddsBasedParametersView];
        
        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, oddsBasedParametersView.frame.origin.y + oddsBasedParametersView.frame.size.height + 4.0, 313, 44 + 22.0 * (double)[regressionResults.variables count])];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [outputV addSubview:riskBasedParametersView];
        
        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, riskBasedParametersView.frame.origin.y + riskBasedParametersView.frame.size.height + 4.0, 313, 176)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
        [outputV addSubview:statisticalTestsView];
        
        [avc setContentSize:CGSizeMake(self.frame.size.width, [outputV superview].frame.origin.y + outputV.frame.origin.y + statisticalTestsView.frame.origin.y + statisticalTestsView.frame.size.height + 2.0)];

        //Add labels to each of the views
        float fourWidth0 = 78;
        float fourWidth1 = 75;
        
        EpiInfoUILabel *gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, oddsBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Adjusted Odds Ratios"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:nil];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"Estimate"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"Lower"];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"Upper"];
        [oddsBasedParametersView addSubview:gridBox];
        for (int i = 0; i < [regressionResults.variables count] - 1 + ismatchedanalysis; i++)
        {
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44 + 22.0 * i, fourWidth0, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentLeft];
            [gridBox setFont:[UIFont boldSystemFontOfSize:12.0]];
            [gridBox setText:[regressionResults.variables objectAtIndex:i]];
            [oddsBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont systemFontOfSize:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.oddsRatios objectAtIndex:i] doubleValue]]];
            [oddsBasedParametersView addSubview:gridBox];
            [(NSMutableArray *)[summaryTable lastObject] addObject:[NSString stringWithString:[regressionResults.variables objectAtIndex:i]]];
            [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:[(NSNumber *)[regressionResults.oddsRatios objectAtIndex:i] floatValue]]];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont systemFontOfSize:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.lcls objectAtIndex:i] doubleValue]]];
            [oddsBasedParametersView addSubview:gridBox];
            [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:[(NSNumber *)[regressionResults.lcls objectAtIndex:i] floatValue]]];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont systemFontOfSize:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.ucls objectAtIndex:i] doubleValue]]];
            [oddsBasedParametersView addSubview:gridBox];
            [(NSMutableArray *)[summaryTable lastObject] addObject:[NSNumber numberWithFloat:[(NSNumber *)[regressionResults.ucls objectAtIndex:i] floatValue]]];
        }
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, riskBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Coefficients and Significance Test"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:nil];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"Coefficient"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"SE"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"Z (P)"];
        [riskBasedParametersView addSubview:gridBox];
        for (int i = 0; i < [regressionResults.variables count]; i++)
        {
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44 + 22.0 * i, fourWidth0, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentLeft];
            [gridBox setFont:[UIFont boldSystemFontOfSize:12.0]];
            [gridBox setText:[regressionResults.variables objectAtIndex:i]];
            [riskBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont systemFontOfSize:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.betas objectAtIndex:i] doubleValue]]];
            [riskBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont systemFontOfSize:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.standardErrors objectAtIndex:i] doubleValue]]];
            [riskBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont systemFontOfSize:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.2f (%.3f)", [(NSNumber *)[regressionResults.zStatistics objectAtIndex:i] doubleValue], [(NSNumber *)[regressionResults.pValues objectAtIndex:i] doubleValue]]];
            [riskBasedParametersView addSubview:gridBox];
        }
        
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, statisticalTestsView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Fit Statistics"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0 + fourWidth1 + 2.0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont boldSystemFontOfSize:12.0]];
        [gridBox setText:@"  Convergence"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, 2.0 + 2.0 * fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont boldSystemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"  %@", regressionResults.convergence]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0 + fourWidth1 + 2.0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont boldSystemFontOfSize:12.0]];
        [gridBox setText:@" Iterations"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, 2.0 + 2.0 * fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont systemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"  %d", regressionResults.iterations]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0 + fourWidth1 + 2.0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont boldSystemFontOfSize:12.0]];
        [gridBox setText:@" Final -2*Log-Likelihood"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, 2.0 + 2.0 * fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont systemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"  %.4f", regressionResults.finalLikelihood]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, fourWidth0 + fourWidth1 + 2.0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont boldSystemFontOfSize:12.0]];
        [gridBox setText:@" Cases Included"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 88, 2.0 + 2.0 * fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont systemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"  %d", NumRows]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 110, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"Test"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"Statistic"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"DF"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + fourWidth1 + fourWidth1, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont boldSystemFontOfSize:14.0]];
        [gridBox setText:@"P-Value"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 132, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont boldSystemFontOfSize:12.0]];
        [gridBox setText:@" Score"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont systemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", regressionResults.scoreStatistic]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont systemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.0f", regressionResults.scoreDF]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + fourWidth1 + fourWidth1, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont systemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", regressionResults.scoreP]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 154, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont boldSystemFontOfSize:12.0]];
        [gridBox setText:@" Likelihood Ratio"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 154, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont systemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", regressionResults.LRStatistic]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 154, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont systemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.0f", regressionResults.LRDF]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + fourWidth1 + fourWidth1, 154, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont systemFontOfSize:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", regressionResults.LRP]];
        [statisticalTestsView addSubview:gridBox];
    }
    float outputVX = outputV.frame.origin.x;
    float outputVY = outputV.frame.origin.y;
    float outputVWidth = outputV.frame.size.width;
    float newOutputVHeight = statisticalTestsView.frame.origin.y + statisticalTestsView.frame.size.height;
    [outputV setFrame:CGRectMake(outputVX, outputVY, outputVWidth, newOutputVHeight)];
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
