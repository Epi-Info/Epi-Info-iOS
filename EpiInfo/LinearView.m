//
//  LinearView.m
//  EpiInfo
//
//  Created by John Copeland on 2/4/19.
//

#import "LinearView.h"
#import "AnalysisViewController.h"
#import "SharedResources.h"

@implementation LinearView
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
            [gadgetTitle setText:@"Linear Regression"];
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
            [gadgetTitle setText:@"Linear Regression"];
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
    exposureLVE = [[LegalValuesEnter alloc] initWithFrame:chosenExposureVariable.frame AndListOfValues:outcomeNSMA AndTextFieldToUpdate:exposureVariableString];
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
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, frame.size.height + 108)];
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
    if ([exposureVariableString.text length] > 0 && ![exposuresNSMA containsObject:exposureVariableString.text])
    {
        [exposuresNSMA addObject:exposureVariableString.text];
        [exposuresUITV reloadData];
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
    [avc putViewOnEpiInfoScrollView:self];
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
                [outcomeLVE setFrame:CGRectMake(10, chosenOutcomeVariable.frame.origin.y - 170, chosenOutcomeVariable.frame.size.width, 44)];
                [exposureLVE setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 170, chosenExposureVariable.frame.size.width, 44)];
                [outcomeVariableLabel setFrame:CGRectMake(10, chosenOutcomeVariable.frame.origin.y - 190, chosenOutcomeVariable.frame.size.width, 44)];
                [exposureVariableLabel setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 190, chosenExposureVariable.frame.size.width, 44)];
                [exposuresUITV setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 140, chosenExposureVariable.frame.size.width, 44)];
                [makeDummyButton setFrame:CGRectMake(exposureLVE.frame.origin.x, exposuresUITV.frame.origin.y + exposuresUITV.frame.size.height, exposureLVE.frame.size.width, exposureLVE.frame.size.height)];
                [dummiesUITV setFrame:CGRectMake(10, chosenExposureVariable.frame.origin.y - 100, chosenExposureVariable.frame.size.width, 44)];
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
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return oddsAndRiskTableView;
}

- (void)doInBackground
{
    leftSide = 1.0;
    
    if ((outcomeVariableChosen || outcomeLVE.selectedIndex > 0) && ([exposuresNSMA count] > 0 || [dummiesNSMA count] > 0) && !stratificationVariableChosen)
    {
        outputViewDisplayed = YES;
        stratum = 0;
        int outcomeSelectedIndex = [outcomeLVE.selectedIndex intValue];
        NSMutableArray *allExposures = [NSMutableArray arrayWithArray:exposuresNSMA];
        for (int i = 0; i < [dummiesNSMA count]; i++)
            [allExposures addObject:[dummiesNSMA objectAtIndex:i]];
        to = [[LinearObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndOutcomeVariable:[availableOutcomeVariables objectAtIndex:outcomeSelectedIndex] AndExposureVariables:allExposures AndIncludeMissing:includeMissing];
        
        if (to.outcomeValues.count > 1)
        {
            [self doLinear:to OnOutputView:outputView StratificationVariable:nil StratificationValue:nil];
        }
        else
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [spinner setHidden:YES];
                [spinner stopAnimating];
                [gearButton setEnabled:YES];
                [xButton setEnabled:YES];
                [avc setDataSourceEnabled:YES];
            });
            return;
        }
        to = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [spinner setHidden:YES];
        [spinner stopAnimating];
        [gearButton setEnabled:YES];
        [xButton setEnabled:YES];
        [avc setDataSourceEnabled:YES];
    });
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
    [self checkIndependentVariables:mutableCurrentTable VariableNames:independentVariables];
    currentTable = [NSArray arrayWithArray:mutableCurrentTable];
    
    return YES;
}

- (void)getRawData
{
    if (mboolIntercept == YES)
        lintIntercept = 1;
    else
        lintIntercept = 0;
    if ([mstrWeightVar length] > 0)
        lintweight = 1;
    else
        lintweight = 0;
    
    NumRows = (int)[currentTable count];
    NumColumns = (int)[(NSArray *)[currentTable firstObject] count];
    
    if (NumRows == 0)
        return;
    
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
            if ([[rowArrayCopy objectAtIndex:j] isKindOfClass:[NSNull class]])
            {
                [currentTableMA removeObjectAtIndex:i];
                break;
            }
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

void trans(int aRows, int aCols, double a[aRows][aCols], double b[aCols][aRows])
{
    for (int i = 0; i < aRows; i++)
    {
        for (int j = 0; j < aCols; j++)
        {
            b[j][i] = a[i][j];
        }
    }
}
void mul(int rowA, int colA, int rowB, int colB, double a[rowA][rowB], double b[rowB][colB], double c[rowA][colB])
{
    if (colA != rowB)
        return;
    for (int i = 0; i < rowA; i++)
    {
        for (int k = 0; k < colB; k++)
        {
            c[i][k] = 0;
            for (int j = 0; j < colA; j++)
            {
                c[i][k] = c[i][k] + a[i][j] * b[j][k];
            }
        }
    }
}
void ludcmp(int n, double d, double a[n][n], int indx[n])
{
    int imax = 0;
    double dum = 0.0, big = 0.0, sum = 0.0;
    double vv[n + 2];
    
    d = 1.0;
    for (int i = 0; i < n; i++)
    {
        big = 0.0;
        for (int j = 0; j < n; j++)
        {
            if (fabs(a[i][j]) > big)
                big = fabs(a[i][j]);
        }
        if (big == 0.0)
            return;
        vv[i] = 1.0 / big;
    }
    for (int j = 0; j < n; j++)
    {
        for (int i = 0; i < j; i++)
        {
            sum = a[i][j];
            for (int k = 0; k < i; k++)
            {
                sum = sum - a[i][k] * a[k][j];
            }
            a[i][j] = sum;
        }
        big = 0.0;
        for (int i = j; i < n; i++)
        {
            sum = a[i][j];
            for (int k = 0; k < j; k++)
            {
                sum = sum - a[i][k] * a[k][j];
            }
            a[i][j] = sum;
            dum = vv[i] * fabs(sum);
            if (dum >= big)
            {
                big = dum;
                imax = i;
            }
        }
        if (j != imax)
        {
            for (int k = 0; k < n; k++)
            {
                dum = a[imax][k];
                a[imax][k] = a[j][k];
                a[j][k] = dum;
            }
            d *= -1.0;
            vv[imax] = vv[j];
        }
        indx[j] = imax + 1;
        if (a[j][j] == 0.0)
            a[j][j] = 1.0e-20;
        if (j != n)
        {
            dum = 1.0 / a[j][j];
            for (int i = j + 1; i < n; i++)
            {
                a[i][j] *= dum;
            }
        }
    }
}
void lubksb(int n, double a[n][n], int indx[n + 2], double B[n + 2])
{
    int ii = 0, ip = 0;
    double sum = 0.0;
    for (int i = 0; i < n; i++)
    {
        ip = indx[i + 1];
        sum = B[ip];
        B[ip] = B[i + 1];
        if (ii > 0)
        {
            for (int j = ii; j <= i; j++)
            {
                sum = sum - a[i][j - 1] * B[j];
            }
        }
        else if (sum != 0.0)
        {
            ii = i + 1;
        }
        B[i + 1] = sum;
    }
    for (int i = n - 1; i >= 0; i--)
    {
        sum = B[i + 1];
        for (int j = i + 1; j < n; j++)
        {
            sum = sum - a[i][j] * B[j + 1];
        }
        B[i + 1] = sum / a[i][i];
    }
}
void inv(int n, double a[n][n], double invA[n][n])
{
    int indx[n + 2];
    double col[n + 2];
    double d = 0.0;
    ludcmp(n, d, a, indx);
    
    for (int j = 0; j < n; j++)
    {
        for (int i = 0; i < n; i++)
            col[i] = 0;
        col[j] = 1;
        
        int indxShifted[n + 2];
        double colShifted[n + 2];
        
        for (int k = 0; k < n + 1; k++)
        {
            indxShifted[k + 1] = indx[k];
            colShifted[k + 1] = col[k];
        }
        
        lubksb(n, a, indxShifted, colShifted);
        for (int i = 0; i < n; i++)
            invA[i][j] = colShifted[i + 1];
    }
}

- (void)doLinear:(LinearObject *)to OnOutputView:(UIView *)outputV StratificationVariable:(NSString *)stratVar StratificationValue:(NSString *)stratValue
{
    NSLog(@"Beginning Linear method");
    NSMutableDictionary *inputVariableList = [[NSMutableDictionary alloc] init];
    [inputVariableList setObject:@"dependvar" forKey:to.outcomeVariable];
    [inputVariableList setObject:@"YES" forKey:@"intercept"];
    [inputVariableList setObject:@"false" forKey:@"includemissing"];
    [inputVariableList setObject:@"0.95" forKey:@"P"];
    [inputVariableList setObject:@"unsorted" forKey:to.exposureVariable];
    [self createSettings:[NSDictionary dictionaryWithDictionary:inputVariableList] outcomesAndValues:to.outcomeValues];
    
    NSString *errorMessage = @"";
    LinearRegressionResults *regressionResults = [[LinearRegressionResults alloc] init];
    [regressionResults setErrorMessage:@""];
    
    if (![self getCurrentTableOfOutcomeVariable:to.outcomeVariable AndIndependentVariables:to.exposureVariables])
        return;
    [self getRawData];
    [regressionResults setErrorMessage:errorMessage];

    int j, i, df = 0;
    int lintWRows = 0;
    int lintweight = 0;
    BOOL ldblweight = NO;
    ldblweight = NO;
    int lintrowCount = 0;
    double ldblMagic = 0.0;
    if (NO) // Change this to [mstrWeightVar length] if weighted analysis added later
        lintweight = 1;
    for (i = 0; i < NumRows; i++)
    {
        if (lintweight == 1)
        {
            lintWRows++;
            lintrowCount += [(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:1] doubleValue];
        }
        else
        {
            lintWRows++;
            lintrowCount = lintWRows;
        }
    }

    double y[NumRows][1];
    double x[NumRows][NumColumns - 1 - lintweight];
    double xx[NumColumns - 1 - lintweight][NumColumns - 1 - lintweight];
    double invxx[NumColumns - 1 - lintweight][NumColumns - 1 - lintweight];
    double xy[NumColumns - 1 - lintweight][1];
    double tx[NumColumns - 1 - lintweight][NumRows];
    double B[NumColumns - 1 - lintweight][1];
    double yhat[NumRows][1];
    double resid[NumRows];
    double sse, mse = 0.0;
    double rmse = 0;
    int indx[NumColumns - 1 - lintweight];
    double d = 0.0;
    double fvalue[NumColumns - 1 - lintweight];
    double covb[NumColumns - 1 - lintweight][NumColumns - 1 - lintweight];
    double probf[NumColumns - 1 - lintweight];
    double stdb[NumColumns - 1 - lintweight];
    double coeff[4][NumColumns - 1 - lintweight];
    coeff[0][0] = 0.0;
    double meanY = 0.0;
    double ra2 = 0.0;
    double r2 = 0.0;
    double ssy = 0.0;
    double ftest = 0.0;
    int p = 0;
    p = 0;
    int k = 0;
    
    for (i = 0; i < NumRows; i++)
    {
        if (lintweight == 1)
        {
            y[k][0] = [(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:0] doubleValue] * sqrt([(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:1] doubleValue]);
            for (j = 1 + lintweight; j < NumColumns; j++)
            {
                x[k][j - 1 - lintweight] = [(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:j] doubleValue] * sqrt([(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:1] doubleValue]);
            }
            k++;
        }
        else
        {
            y[k][0] = [(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:0] doubleValue];
            for (j = lintweight; j < NumColumns - 1; j++)
            {
                x[k][j - lintweight] = [(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:j + 1] doubleValue] ;
            }
            k++;
        }
    }
    
    mboolFirst = YES;
    mboolIntercept = YES;
    trans(NumRows, NumColumns - 1 - lintweight, x, tx);
    mul(NumColumns - 1 - lintweight, NumRows, NumRows, NumColumns - 1 - lintweight, tx, x, xx);
    mul(NumColumns - 1 - lintweight, NumRows, NumRows, 1, tx, y, xy);
    
    for (int e = 0; e < NumColumns - 1 - lintweight; e++)
        for (int c = 0; c < NumColumns - 1 - lintweight; c++)
            invxx[e][c] = xx[e][c];
    ludcmp(NumColumns - 1 - lintweight, d, invxx, indx);
    d = 1;
    for (i = 0; i < NumColumns - 1 - lintweight; i++)
    {
        d *= invxx[i][i];
        if (d == 0)
        {
            [regressionResults setErrorMessage:@"Error: Colinear Data"];
            return;
        }
    }
    if (fabs(d) < mdblToler)
    {
        [regressionResults setErrorMessage:@"Error: Matrix Tolerance Exceeded"];
        return;
    }
    inv(NumColumns - 1 - lintweight, xx, invxx);
    mul(NumColumns - 1 - lintweight, NumColumns - 1 - lintweight, NumColumns - 1 - lintweight, 1, invxx, xy, B);
    mul(NumRows, NumColumns - 1 - lintweight, NumColumns - 1 - lintweight, 1, x, B, yhat);
    sse = 0.0;
    meanY = 0.0;
    for (i = 0; i < lintWRows; i++)
    {
        if (lintweight > 0)
        {
            ldblMagic = sqrt([(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:1] doubleValue]);
            resid[i] = y[i][0] - yhat[i][0];
            meanY = meanY + y[i][0] * ldblMagic;
            sse = sse + resid[i] * resid[i];
        }
        else
        {
            resid[i] = y[i][0] - yhat[i][0];
            meanY = meanY + y[i][0];
            sse = sse + resid[i] * resid[i];
        }
    }
    meanY = meanY / lintrowCount;
    ssy = 0.0;
    for (i = 0; i < lintWRows; i++)
    {
        if (lintweight > 0)
        {
            if ([(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:1] doubleValue] != 0)
            {
                ssy = ssy + pow(y[i][0] * sqrt([(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:1] doubleValue]) - meanY * abs((int)mboolIntercept), 2.0) * [(NSNumber *)[(NSArray *)[currentTable objectAtIndex:i] objectAtIndex:1] doubleValue];
            }
        }
        else
        {
            ssy = ssy + pow(y[i][0]  - meanY * abs((int)mboolIntercept), 2.0);
        }
    }
    r2 = (ssy - sse) / ssy;
    
    df = lintWRows - (NumColumns - lintweight - (int)mboolIntercept * 0 - 1);
    ra2 = 1 - (int)(lintrowCount - (int)mboolIntercept) * sse / (df * ssy);
    mse = sse / df;
    
    ftest = (ssy - sse) / (NumColumns - lintweight - 1 - (int)mboolIntercept);
    ftest = ftest / mse;
    rmse = sqrt(mse);
    for (i = 0; i < NumColumns - lintweight - 1; i++)
    {
        for (j = 0; j < NumColumns - lintweight - 1; j++)
        {
            covb[i][j] = invxx[i][j] * mse;
        }
        stdb[i] = sqrt(fabs(covb[i][i]));
        fvalue[i] = pow(B[i][0] / stdb[i], 2.0);
        probf[i] = 0.0;
        probf[i] = [SharedResources pFromF:fvalue[i] DegreesOfFreedom1:1 DegreesOfFreedom2:df];
    }
    
    [regressionResults setCorrelationCoefficient:r2];
    [regressionResults setRegressionDf:(int)(lintWRows - (int)mboolIntercept) - df];
    [regressionResults setRegressionSumOfSquares:ssy - sse];
    [regressionResults setRegressionMeanSquare:(ssy - sse) / (int)(NumColumns - lintweight - 1 - (int)mboolIntercept)];
    [regressionResults setRegressionF:ftest];
    [regressionResults setResidualsDf:df];
    [regressionResults setResidualsSumOfSquares:sse];
    [regressionResults setResidualsMeanSquare:mse];
    [regressionResults setTotalDf:lintrowCount - (int)mboolIntercept];
    [regressionResults setTotalSumOfSquares:ssy];
    [regressionResults setRegressionFP:[SharedResources pFromF:regressionResults.regressionF DegreesOfFreedom1:regressionResults.regressionDf DegreesOfFreedom2:regressionResults.residualsDf]];
    
    [regressionResults setVariables:[NSMutableArray arrayWithArray:to.exposureVariables]];
    [regressionResults.variables addObject:@"CONSTANT"];
    
    NSMutableArray *betas = [[NSMutableArray alloc] init];
    NSMutableArray *betases = [[NSMutableArray alloc] init];
    NSMutableArray *betafs = [[NSMutableArray alloc] init];
    NSMutableArray *betafps = [[NSMutableArray alloc] init];
    for (i = 0; i < NumColumns - 1 - lintweight; i++)
    {
        [betas addObject:[NSNumber numberWithDouble:B[i][0]]];
        [betases addObject:[NSNumber numberWithDouble:stdb[i]]];
        [betafs addObject:[NSNumber numberWithDouble:fvalue[i]]];
        [betafps addObject:[NSNumber numberWithDouble:probf[i]]];
    }
    [regressionResults setBetas:[NSArray arrayWithArray:betas]];
    [regressionResults setStandardErrors:[NSArray arrayWithArray:betases]];
    [regressionResults setBetaFs:[NSArray arrayWithArray:betafs]];
    [regressionResults setBetaFPs:[NSArray arrayWithArray:betafps]];
    
    NSMutableArray *betalcls = [[NSMutableArray alloc] init];
    NSMutableArray *betaucls = [[NSMutableArray alloc] init];
    double tscore = 1.9;
    while ([SharedResources pFromT:tscore DegreesOfFreedom:regressionResults.residualsDf] > 0.025)
    {
        tscore += 0.000001;
    }
    for (i = 0; i < [regressionResults.betas count]; i++)
    {
        [betalcls addObject:[NSNumber numberWithDouble:B[i][0] - tscore * stdb[i]]];
        [betaucls addObject:[NSNumber numberWithDouble:B[i][0] + tscore * stdb[i]]];
    }
    [regressionResults setBetaLCLs:[NSArray arrayWithArray:betalcls]];
    [regressionResults setBetaUCLs:[NSArray arrayWithArray:betaucls]];
    NSLog(@"Ending Linear method");

    float stratificationOffset = 0.0;
    dispatch_sync(dispatch_get_main_queue(), ^{
        oddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 44 + 22.0 * (double)([regressionResults.variables count]))];
        [oddsBasedParametersView setBackgroundColor:epiInfoLightBlue];
        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, oddsBasedParametersView.frame.origin.y + oddsBasedParametersView.frame.size.height + 4.0, 313, 44 + 22.0 * (double)[regressionResults.variables count])];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, riskBasedParametersView.frame.origin.y + riskBasedParametersView.frame.size.height + 4.0, 313, 176)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
    });
    [avc setContentSize:CGSizeMake(self.frame.size.width, [outputV superview].frame.origin.y + outputV.frame.origin.y + statisticalTestsView.frame.origin.y + statisticalTestsView.frame.size.height + 2.0)];
   //Add labels to each of the views
    float fourWidth0 = 78;
    float fourWidth1 = 75;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        EpiInfoUILabel *gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, oddsBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Model Coefficients"];
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
        for (int i = 0; i < [regressionResults.variables count]; i++)
        {
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44 + 22.0 * i, fourWidth0, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentLeft];
            [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
            [gridBox setText:[regressionResults.variables objectAtIndex:i]];
            [oddsBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.betas objectAtIndex:i] doubleValue]]];
            [oddsBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.betaLCLs objectAtIndex:i] doubleValue]]];
            [oddsBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.betaUCLs objectAtIndex:i] doubleValue]]];
            [oddsBasedParametersView addSubview:gridBox];
        }
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, riskBasedParametersView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Standard Errors and Significance Tests"];
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
        [gridBox setText:@"SE"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"F"];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 22, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"P"];
        [riskBasedParametersView addSubview:gridBox];
        for (int i = 0; i < [regressionResults.variables count]; i++)
        {
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44 + 22.0 * i, fourWidth0, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentLeft];
            [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
            [gridBox setText:[regressionResults.variables objectAtIndex:i]];
            [riskBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.standardErrors objectAtIndex:i] doubleValue]]];
            [riskBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.betaFs objectAtIndex:i] doubleValue]]];
            [riskBasedParametersView addSubview:gridBox];
            gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44 + 22.0 * i, fourWidth1, 20)];
            [gridBox setBackgroundColor:[UIColor whiteColor]];
            [gridBox setTextColor:[UIColor blackColor]];
            [gridBox setTextAlignment:NSTextAlignmentCenter];
            [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            [gridBox setText:[NSString stringWithFormat:@"%.4f", [(NSNumber *)[regressionResults.betaFPs objectAtIndex:i] doubleValue]]];
            [riskBasedParametersView addSubview:gridBox];
        }
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, statisticalTestsView.frame.size.width, 20)];
        [gridBox setBackgroundColor:[UIColor clearColor]];
        [gridBox setTextColor:[UIColor whiteColor]];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setText:@"Model Statistics"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 22, fourWidth0 + fourWidth1 + 2.0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@"  Correlation Coefficient"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 22, 2.0 + 2.0 * fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"  r^2 = %.2f", regressionResults.correlationCoefficient]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 44, fourWidth0 + fourWidth1 + 2.0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@"  Regression F Statistic"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, 2.0 + 2.0 * fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"  %.4f", regressionResults.regressionF]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0 + fourWidth1 + 2.0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@"  Regression F P-Value"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 66, 2.0 + 2.0 * fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"  %.4f", regressionResults.regressionFP]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 88, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"Source"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"df"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"SS"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + fourWidth1 + fourWidth1, 88, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0]];
        [gridBox setText:@"MS"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 110, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Regression"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%d", regressionResults.regressionDf]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", regressionResults.regressionSumOfSquares]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + fourWidth1 + fourWidth1, 110, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", regressionResults.regressionMeanSquare]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 132, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Residuals"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%d", regressionResults.residualsDf]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", regressionResults.residualsSumOfSquares]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + fourWidth1 + fourWidth1, 132, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", regressionResults.residualsMeanSquare]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 154, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" Total"];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(4 + fourWidth0, 154, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%d", regressionResults.totalDf]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 154, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", regressionResults.totalSumOfSquares]];
        [statisticalTestsView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + fourWidth1 + fourWidth1, 154, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:@""];
        [statisticalTestsView addSubview:gridBox];

        [outputV addSubview:oddsBasedParametersView];
        [outputV addSubview:riskBasedParametersView];
        [outputV addSubview:statisticalTestsView];
    });
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
