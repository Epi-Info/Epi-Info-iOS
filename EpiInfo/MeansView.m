//
//  MeansView.m
//  EpiInfo
//
//  Created by John Copeland on 8/21/14.
//  Copyright (c) 2014 John Copeland. All rights reserved.
//

#import "MeansView.h"
#import "AnalysisViewController.h"
#import "Twox2Compute.h"
#import "Twox2StrataData.h"
#import "Twox2SummaryData.h"
#import "SharedResources.h"

@implementation MeansView
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
            
            //Add Means Variable button and picker
            chosenMeansVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 8, frame.size.width - 40, 44)];
            [chosenMeansVariable setBackgroundColor:epiInfoLightBlue];
            [chosenMeansVariable.layer setCornerRadius:10.0];
            [chosenMeansVariable setTitle:@"Select Means Variable" forState:UIControlStateNormal];
            [chosenMeansVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenMeansVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenMeansVariable addTarget:self action:@selector(chosenMeansVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenMeansVariable];
            chooseMeansVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseMeansVariable.layer setCornerRadius:10.0];
            [chooseMeansVariable setTag:0];
            selectedMeansVariableNumber = 0;
            meansVariableChosen = NO;
            [chooseMeansVariable setDelegate:self];
            [chooseMeansVariable setDataSource:self];
            [chooseMeansVariable setShowsSelectionIndicator:YES];
            [chooseMeansVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseMeansVariableTapped:)]];
            
            //Add Crosstab Variable button and picker
            chosenCrosstabVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 56, frame.size.width - 40, 44)];
            [chosenCrosstabVariable setBackgroundColor:epiInfoLightBlue];
            [chosenCrosstabVariable.layer setCornerRadius:10.0];
            [chosenCrosstabVariable setTitle:@"Select Crosstab Variable" forState:UIControlStateNormal];
            [chosenCrosstabVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenCrosstabVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenCrosstabVariable addTarget:self action:@selector(chosenCrosstabVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenCrosstabVariable];
            chooseCrosstabVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseCrosstabVariable setTag:1];
            crosstabVariableChosen = NO;
            selectedCrosstabVariableNumber = 0;
            [chooseCrosstabVariable setDelegate:self];
            [chooseCrosstabVariable setDataSource:self];
            [chooseCrosstabVariable setShowsSelectionIndicator:YES];
            [chooseCrosstabVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCrosstabVariableTapped:)]];
            
            //Add Inclued Missing box and label
            //            includeMissing = NO;
            //            includeMissingButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 104, 22, 22)];
            //            [includeMissingButton.layer setCornerRadius:6];
            //            [includeMissingButton.layer setBorderColor:epiInfoLightBlue.CGColor];
            //            [includeMissingButton.layer setBorderWidth:2.0];
            //            [includeMissingButton addTarget:self action:@selector(includeMissingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            //            [inputView addSubview:includeMissingButton];
            //            [inputView sendSubviewToBack:includeMissingButton];
            //            includeMissingLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(20, 104, frame.size.width / 2.0 - 22, 22)];
            //            [includeMissingLabel setTextAlignment:NSTextAlignmentLeft];
            //            [includeMissingLabel setTextColor:epiInfoLightBlue];
            //            [includeMissingLabel setText:@"Include missing"];
            //            [inputView addSubview:includeMissingLabel];
            //            [inputView sendSubviewToBack:includeMissingLabel];
            
            //Add Stratification Variable button and picker
            //            chosenStratificationVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 135, frame.size.width - 40, 44)];
            //            [chosenStratificationVariable setBackgroundColor:epiInfoLightBlue];
            //            [chosenStratificationVariable.layer setCornerRadius:10.0];
            //            [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
            //            [chosenStratificationVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            //            [chosenStratificationVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            //            [chosenStratificationVariable addTarget:self action:@selector(chosenStratificationVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            //            [inputView addSubview:chosenStratificationVariable];
//            [inputView bringSubviewToFront:chooseMeansVariable];
//            [inputView bringSubviewToFront:chooseCrosstabVariable];
            //            chooseStratificationVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            //            [chooseStratificationVariable setTag:2];
            stratificationVariableChosen = NO;
            selectedStratificationVariableNumber = 0;
            //            [chooseStratificationVariable setDelegate:self];
            //            [chooseStratificationVariable setDataSource:self];
            //            [chooseStratificationVariable setShowsSelectionIndicator:YES];
            //            [chooseStratificationVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseStratificationVariableTapped:)]];
//            [inputView addSubview:chooseMeansVariable];
//            [inputView addSubview:chooseCrosstabVariable];
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
            [gadgetTitle setText:@"Means"];
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
            
            //Add Means Variable button and picker
            chosenMeansVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 8, frame.size.width - 40, 44)];
            [chosenMeansVariable setBackgroundColor:epiInfoLightBlue];
            [chosenMeansVariable.layer setCornerRadius:10.0];
            [chosenMeansVariable setTitle:@"Select Means Variable" forState:UIControlStateNormal];
            [chosenMeansVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenMeansVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenMeansVariable addTarget:self action:@selector(chosenMeansVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenMeansVariable];
            chooseMeansVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseMeansVariable.layer setCornerRadius:10.0];
            [chooseMeansVariable setTag:0];
            selectedMeansVariableNumber = 0;
            meansVariableChosen = NO;
            [chooseMeansVariable setDelegate:self];
            [chooseMeansVariable setDataSource:self];
            [chooseMeansVariable setShowsSelectionIndicator:YES];
            [chooseMeansVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseMeansVariableTapped:)]];
            
            //Add Crosstab Variable button and picker
            chosenCrosstabVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(306, 8, frame.size.width - 40, 44)];
            [chosenCrosstabVariable setBackgroundColor:epiInfoLightBlue];
            [chosenCrosstabVariable.layer setCornerRadius:10.0];
            [chosenCrosstabVariable setTitle:@"Select Crosstab Variable" forState:UIControlStateNormal];
            [chosenCrosstabVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenCrosstabVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenCrosstabVariable addTarget:self action:@selector(chosenCrosstabVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenCrosstabVariable];
            chooseCrosstabVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseCrosstabVariable setTag:1];
            crosstabVariableChosen = NO;
            selectedCrosstabVariableNumber = 0;
            [chooseCrosstabVariable setDelegate:self];
            [chooseCrosstabVariable setDataSource:self];
            [chooseCrosstabVariable setShowsSelectionIndicator:YES];
            [chooseCrosstabVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCrosstabVariableTapped:)]];
            
            //Add Inclued Missing box and label
            //            includeMissing = NO;
            //            includeMissingButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 104, 22, 22)];
            //            [includeMissingButton.layer setCornerRadius:6];
            //            [includeMissingButton.layer setBorderColor:epiInfoLightBlue.CGColor];
            //            [includeMissingButton.layer setBorderWidth:2.0];
            //            [includeMissingButton addTarget:self action:@selector(includeMissingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            //            [inputView addSubview:includeMissingButton];
            //            [inputView sendSubviewToBack:includeMissingButton];
            //            includeMissingLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(20, 104, frame.size.width / 2.0 - 22, 22)];
            //            [includeMissingLabel setTextAlignment:NSTextAlignmentLeft];
            //            [includeMissingLabel setTextColor:epiInfoLightBlue];
            //            [includeMissingLabel setText:@"Include missing"];
            //            [inputView addSubview:includeMissingLabel];
            //            [inputView sendSubviewToBack:includeMissingLabel];
            
            //Add Stratification Variable button and picker
            //            chosenStratificationVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 135, frame.size.width - 40, 44)];
            //            [chosenStratificationVariable setBackgroundColor:epiInfoLightBlue];
            //            [chosenStratificationVariable.layer setCornerRadius:10.0];
            //            [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
            //            [chosenStratificationVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            //            [chosenStratificationVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            //            [chosenStratificationVariable addTarget:self action:@selector(chosenStratificationVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            //            [inputView addSubview:chosenStratificationVariable];
//            [inputView bringSubviewToFront:chooseMeansVariable];
//            [inputView bringSubviewToFront:chooseCrosstabVariable];
            //            chooseStratificationVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            //            [chooseStratificationVariable setTag:2];
            stratificationVariableChosen = NO;
            selectedStratificationVariableNumber = 0;
            //            [chooseStratificationVariable setDelegate:self];
            //            [chooseStratificationVariable setDataSource:self];
            //            [chooseStratificationVariable setShowsSelectionIndicator:YES];
            //            [chooseStratificationVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseStratificationVariableTapped:)]];
//            [inputView addSubview:chooseMeansVariable];
//            [inputView addSubview:chooseCrosstabVariable];
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
            [gadgetTitle setText:@"Means"];
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
    meansVariableLabel = [[UILabel alloc] initWithFrame:chosenMeansVariable.frame];
    [meansVariableLabel setBackgroundColor:[UIColor whiteColor]];
    [meansVariableLabel setTextColor:epiInfoLightBlue];
    [meansVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [meansVariableLabel setText:@"Means Variable"];
    meansVariableString = [[UITextField alloc] init];
    crosstabVariableLabel = [[UILabel alloc] initWithFrame:chosenCrosstabVariable.frame];
    [crosstabVariableLabel setBackgroundColor:[UIColor whiteColor]];
    [crosstabVariableLabel setTextColor:epiInfoLightBlue];
    [crosstabVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [crosstabVariableLabel setText:@"Crosstab Variable"];
    crosstabVariableString = [[UITextField alloc] init];
    NSMutableArray *outcomeNSMA = [[NSMutableArray alloc] init];
    [outcomeNSMA addObject:@""];
    for (NSString *variable in sqliteData.columnNamesWorking)
    {
        [outcomeNSMA addObject:variable];
    }
    [outcomeNSMA sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    availableOutcomeVariables = [NSMutableArray arrayWithArray:outcomeNSMA];
    meansLVE = [[LegalValuesEnter alloc] initWithFrame:chosenMeansVariable.frame AndListOfValues:outcomeNSMA AndTextFieldToUpdate:meansVariableString];
    [meansLVE.picker selectRow:0 inComponent:0 animated:YES];
    [meansLVE analysisStyle];
    [inputView addSubview:meansLVE];
    crosstabLVE = [[LegalValuesEnter alloc] initWithFrame:chosenCrosstabVariable.frame AndListOfValues:outcomeNSMA AndTextFieldToUpdate:crosstabVariableString];
    [crosstabLVE.picker selectRow:0 inComponent:0 animated:YES];
    [crosstabLVE analysisStyle];
    [inputView addSubview:crosstabLVE];
    [chosenMeansVariable setTitle:[meansVariableString text] forState:UIControlStateNormal];
    [inputView addSubview:meansVariableLabel];
    [inputView addSubview:crosstabVariableLabel];
    avc = (AnalysisViewController *)vc;
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 4.0 * frame.size.height)];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (frame.size.width > 0.0 && frame.size.height > 0.0)
        {
            [titleBar setFrame:CGRectMake(0, -114, 317, 162)];
            [gadgetTitle setFrame:CGRectMake(2, 116, 316 - 96, 44)];
            [xButton setFrame:CGRectMake(316 - 46, 116, 44, 44)];
            [gearButton setFrame:CGRectMake(316 - 92, 116, 44, 44)];
            [outputView setFrame:CGRectMake(0, 46, frame.size.width, 4.0 * frame.size.height - 46)];
            if (inputViewDisplayed)
            {
                if ([avc portraitOrientation])
                {
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, 204)];
                    [chosenMeansVariable setFrame:CGRectMake(20, 8, 276, 44)];
                    [chosenCrosstabVariable setFrame:CGRectMake(20, 56, 276, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 135, 276, 44)];
                    [chooseMeansVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseCrosstabVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseStratificationVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                    [meansVariableLabel setFrame:CGRectMake(16, 8, 284, 20)];
                    [meansLVE setFrame:CGRectMake(10, 28, 300, 44)];
                    [includeMissingButton setFrame:CGRectMake(170, 124, 22, 22)];
                    [includeMissingLabel setFrame:CGRectMake(20, 124, 140, 22)];
                    [crosstabVariableLabel setFrame:CGRectMake(16, 94, 284, 20)];
                    [crosstabLVE setFrame:CGRectMake(10, 114, 300, 44)];
                    [spinner setFrame:CGRectMake(frame.size.width / 2.0 - 20, 118, 40, 40)];
                }
                else
                {
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, frame.size.height - 100)];
                    [chosenMeansVariable setFrame:CGRectMake(20, 8, (inputView.frame.size.width - 60) / 2.0, 44)];
                    [chosenCrosstabVariable setFrame:CGRectMake(inputView.frame.size.width / 2.0 + 10, 8, (inputView.frame.size.width - 60) / 2.0, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 87, 276, 44)];
                    [chooseMeansVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseCrosstabVariable setFrame:CGRectMake(10, 1000, 296, 162)];
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
            [outputView setFrame:CGRectMake(0, 46, frame.size.width, 4.0 * frame.size.height - 46)];
            if (inputViewDisplayed)
            {
                if ([avc portraitOrientation])
                {
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, 432)];
                    [chosenMeansVariable setFrame:CGRectMake(20, 8, 276, 44)];
                    [chosenCrosstabVariable setFrame:CGRectMake(frame.size.width - 296.0, 8, 276, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 220, 276, 44)];
                    [chooseMeansVariable setFrame:CGRectMake(10, 54, 296, 162)];
                    [chooseCrosstabVariable setFrame:CGRectMake(chosenCrosstabVariable.frame.origin.x - 10.0, 54, 296, 162)];
                    [chooseStratificationVariable setFrame:CGRectMake(10, 266, 296, 162)];
                    [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                    [includeMissingLabel setFrame:CGRectMake(chosenCrosstabVariable.frame.origin.x, 231, 140, 22)];
                    [includeMissingButton setFrame:CGRectMake(includeMissingLabel.frame.origin.x + 150, 231, 22, 22)];
                    [meansVariableLabel setFrame:CGRectMake(chosenMeansVariable.frame.origin.x, chosenMeansVariable.frame.origin.y, 284, 20)];
                    [meansLVE setFrame:CGRectMake(meansVariableLabel.frame.origin.x - 6, meansVariableLabel.frame.origin.y + 20, 276, 44)];
                    [crosstabVariableLabel setFrame:CGRectMake(chosenCrosstabVariable.frame.origin.x - 32, chosenCrosstabVariable.frame.origin.y, 284, 20)];
                    [crosstabLVE setFrame:CGRectMake(crosstabVariableLabel.frame.origin.x - 6, crosstabVariableLabel.frame.origin.y + 20, 276, 44)];
                    [spinner setFrame:CGRectMake(frame.size.width / 2.0 - 20, 118, 40, 40)];
                }
                else
                {
                    [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, frame.size.height - 100)];
                    [chosenMeansVariable setFrame:CGRectMake(20, 8, (inputView.frame.size.width - 60) / 2.0, 44)];
                    [chosenCrosstabVariable setFrame:CGRectMake(inputView.frame.size.width / 2.0 + 10, 8, (inputView.frame.size.width - 60) / 2.0, 44)];
                    [chosenStratificationVariable setFrame:CGRectMake(20, 87, 276, 44)];
                    [chooseMeansVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                    [chooseCrosstabVariable setFrame:CGRectMake(10, 1000, 296, 162)];
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

- (void)chosenMeansVariableButtonPressed
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    meansVariableChosen = YES;
    [UIView animateWithDuration:0.6 animations:^{
        [chooseMeansVariable setFrame:CGRectMake(10, 6, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)chosenCrosstabVariableButtonPressed
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    [UIView animateWithDuration:0.6 animations:^{
        [chooseCrosstabVariable setFrame:CGRectMake(10, 6, inputView.frame.size.width - 20, 162)];
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

- (void)chooseMeansVariableTapped:(UITapGestureRecognizer *)tap
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    [UIView animateWithDuration:0.9 animations:^{
        [chosenMeansVariable setTitle:[NSString stringWithFormat:@"Outcome:  %@", [availableOutcomeVariables objectAtIndex:selectedMeansVariableNumber.integerValue]] forState:UIControlStateNormal];
        [chooseMeansVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)chooseCrosstabVariableTapped:(UITapGestureRecognizer *)tap
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    [UIView animateWithDuration:0.9 animations:^{
        if (crosstabVariableChosen && [selectedCrosstabVariableNumber intValue] >= 0)
            [chosenCrosstabVariable setTitle:[NSString stringWithFormat:@"Crosstab:  %@", [availableOutcomeVariables objectAtIndex:selectedCrosstabVariableNumber.integerValue]] forState:UIControlStateNormal];
        else
        {
            [chosenCrosstabVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [chosenCrosstabVariable setTitle:@"Select Crosstab Variable" forState:UIControlStateNormal];
        }
        [chooseCrosstabVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
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
                [chosenMeansVariable setFrame:CGRectMake(20, chosenMeansVariable.frame.origin.y - 170, chosenMeansVariable.frame.size.width, 44)];
                [chosenCrosstabVariable setFrame:CGRectMake(20, chosenCrosstabVariable.frame.origin.y - 170, chosenCrosstabVariable.frame.size.width, 44)];
                [chosenStratificationVariable setFrame:CGRectMake(20, chosenCrosstabVariable.frame.origin.y - 170, chosenCrosstabVariable.frame.size.width, 44)];
                [meansLVE setFrame:CGRectMake(10, chosenMeansVariable.frame.origin.y, chosenMeansVariable.frame.size.width, 44)];
                [crosstabLVE setFrame:CGRectMake(10, chosenCrosstabVariable.frame.origin.y, chosenCrosstabVariable.frame.size.width, 44)];
                [meansVariableLabel setFrame:CGRectMake(10, chosenMeansVariable.frame.origin.y - 20, chosenMeansVariable.frame.size.width, 44)];
                [crosstabVariableLabel setFrame:CGRectMake(10, chosenCrosstabVariable.frame.origin.y - 20, chosenCrosstabVariable.frame.size.width, 44)];
                //Move the pickers up if they are in view, otherwise they need to be hidden in case the
                //ContentSize increases to >1000
                if (chooseMeansVariable.frame.origin.y < 500)
                {
                    [chosenMeansVariable setTitle:[NSString stringWithFormat:@"Outcome:  %@", [availableOutcomeVariables objectAtIndex:selectedMeansVariableNumber.integerValue]] forState:UIControlStateNormal];
                    [chooseMeansVariable setFrame:CGRectMake(0, -162, 314, 162)];
                }
                else
                    [chooseMeansVariable setHidden:YES];
                if (chooseCrosstabVariable.frame.origin.y < 500)
                {
                    if (crosstabVariableChosen && [selectedCrosstabVariableNumber intValue] >= 0)
                        [chosenCrosstabVariable setTitle:[NSString stringWithFormat:@"Crosstab:  %@", [availableOutcomeVariables objectAtIndex:selectedCrosstabVariableNumber.integerValue]] forState:UIControlStateNormal];
                    else
                    {
                        [chosenCrosstabVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                        [chosenCrosstabVariable setTitle:@"Select Crosstab Variable" forState:UIControlStateNormal];
                    }
                    [chooseCrosstabVariable setFrame:CGRectMake(0, -162, 314, 162)];
                }
                else
                    [chooseCrosstabVariable setHidden:YES];
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
            [chooseMeansVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
            [chooseCrosstabVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
            [chooseStratificationVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
            [chooseMeansVariable setHidden:NO];
            [chooseCrosstabVariable setHidden:NO];
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
                [chosenMeansVariable setFrame:CGRectMake(20, chosenMeansVariable.frame.origin.y - 220, chosenMeansVariable.frame.size.width, 44)];
                [chosenCrosstabVariable setFrame:CGRectMake(chosenCrosstabVariable.frame.origin.x, chosenCrosstabVariable.frame.origin.y - 220, chosenCrosstabVariable.frame.size.width, 44)];
                [chosenStratificationVariable setFrame:CGRectMake(20, chosenCrosstabVariable.frame.origin.y - 220, chosenCrosstabVariable.frame.size.width, 44)];
                //Move the pickers up if they are in view, otherwise they need to be hidden in case the
                //ContentSize increases to >1000
                if (chooseMeansVariable.frame.origin.y < 500)
                {
                    [chosenMeansVariable setTitle:[NSString stringWithFormat:@"Outcome:  %@", [availableOutcomeVariables objectAtIndex:selectedMeansVariableNumber.integerValue]] forState:UIControlStateNormal];
                    [chooseMeansVariable setFrame:CGRectMake(0, -212, 314, 162)];
                }
                else
                    [chooseMeansVariable setHidden:YES];
                if (chooseCrosstabVariable.frame.origin.y < 500)
                {
                    //                    [chosenCrosstabVariable setTitle:[NSString stringWithFormat:@"Crosstab:  %@", [availableOutcomeVariables objectAtIndex:selectedCrosstabVariableNumber.integerValue]] forState:UIControlStateNormal];
                    [chooseCrosstabVariable setFrame:CGRectMake(chooseCrosstabVariable.frame.origin.x, -212, 314, 162)];
                }
                else
                    [chooseCrosstabVariable setHidden:YES];
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
            [chooseMeansVariable setHidden:NO];
            [chooseCrosstabVariable setHidden:NO];
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

- (void)doInBackground
{
    leftSide = 1.0;
    float rightSide = 0.0;
    
    // Do calculations and display results
    // No crosstabulation or stratification
    if ([[meansLVE selectedIndex] intValue] > 0 && [[crosstabLVE selectedIndex] intValue] == 0)
    {
        outputViewDisplayed = YES;
        stratum = 0;
        MeansObject *mo = [[MeansObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndMeansVariable:[availableOutcomeVariables objectAtIndex:[[meansLVE selectedIndex] intValue]] AndIncludeMissing:includeMissing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, outputView.frame.size.width - 4.0, outputView.frame.size.height - 4.0)];
            [outputTableView setBackgroundColor:epiInfoLightBlue];
            [outputTableView setClipsToBounds:YES];
            [outputTableView.layer setCornerRadius:10.0];
            
            EpiInfoUILabel *meansVariableNameLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, outputTableView.frame.size.width, 40)];
            [meansVariableNameLabel setTextAlignment:NSTextAlignmentCenter];
            [meansVariableNameLabel setTextColor:[UIColor whiteColor]];
            [meansVariableNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [meansVariableNameLabel setText:mo.meansVariable];
            [outputTableView addSubview:meansVariableNameLabel];
            
            NSArray *labelsArray = @[@"Observations",
                                     @"Total",
                                     @"Mean",
                                     @"Variance",
                                     @"Standard Deviation",
                                     @"Minimum",
                                     @"25%",
                                     @"Median",
                                     @"75%",
                                     @"Maximum"];
            float yValue = 0.0;
            for (int i = 0; i < labelsArray.count; i++)
            {
                UIView *statView = [[UIView alloc] initWithFrame:CGRectMake(2, 40.0 + yValue, outputTableView.frame.size.width / 2.0 - 3.0, 20)];
                [statView setBackgroundColor:[UIColor whiteColor]];
                EpiInfoUILabel *statLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8, 0, statView.frame.size.width - 8.0, 20)];
                [statLabel setBackgroundColor:[UIColor clearColor]];
                [statLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [statLabel setText:[labelsArray objectAtIndex:i]];
                [statView addSubview:statLabel];
                if (i == labelsArray.count - 1)
                {
                    [statView.layer setCornerRadius:8.0];
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(statView.frame.origin.x, statView.frame.origin.y, 40, 10)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(statView.frame.size.width / 2.0 + 2.0, statView.frame.origin.y, statView.frame.size.width / 2.0, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [outputTableView addSubview:white0];
                    [outputTableView addSubview:white1];
                }
                [outputTableView addSubview:statView];
                
                UIView *valueView = [[UIView alloc] initWithFrame:CGRectMake(outputTableView.frame.size.width / 2.0 + 1.0, 40.0 + yValue, statView.frame.size.width, 20)];
                [valueView setBackgroundColor:[UIColor whiteColor]];
                EpiInfoUILabel *valueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8, 0, valueView.frame.size.width - 8.0, 20)];
                [valueLabel setBackgroundColor:[UIColor clearColor]];
                [valueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [valueLabel setText:[mo.meansVariableValues objectAtIndex:i]];
                [valueView addSubview:valueLabel];
                if (i == labelsArray.count - 1)
                {
                    [valueView.layer setCornerRadius:8.0];
                    UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(outputTableView.frame.size.width - 42, valueView.frame.origin.y, 40, 10)];
                    UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(valueView.frame.origin.x, valueView.frame.origin.y, 40, 20)];
                    [white0 setBackgroundColor:[UIColor whiteColor]];
                    [white1 setBackgroundColor:[UIColor whiteColor]];
                    [outputTableView addSubview:white0];
                    [outputTableView addSubview:white1];
                }
                [outputTableView addSubview:valueView];

                yValue += 22.0;
            }
            
            [outputTableView setFrame:CGRectMake(outputTableView.frame.origin.x, outputTableView.frame.origin.y, outputTableView.frame.size.width, 40.0 + yValue)];
            [outputView addSubview:outputTableView];
        });

        mo = nil;

 //       dispatch_async(dispatch_get_main_queue(), ^{
 //           [outputView addSubview:outputTableView];
 //       });
    }
    // With crosstabulation without stratification
    if ([[meansLVE selectedIndex] intValue] > 0 && [[crosstabLVE selectedIndex] intValue] > 0)
    {
        NSMutableArray *statisticsInputsArray = [[NSMutableArray alloc] init];

        NSString *crosstabVariableName = [availableOutcomeVariables objectAtIndex:[[crosstabLVE selectedIndex] intValue]];
        FrequencyObject *fo = [[FrequencyObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndVariable:crosstabVariableName AndIncludeMissing:includeMissing];
        
        outputViewDisplayed = YES;
        stratum = 0;
//        for (int i=0; i < 1; i++)
        float otvyValue = 2.0;
        for (int i=0; i < fo.variableValues.count; i++)
        {
            float yValue = 0.0;
            leftSide = 1.0;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad && i % 2 > 0)
                leftSide = 0.0;
            rightSide = 1.0 - leftSide;
            stratum = i;
            NSString *whereClause;
            if ([(NSNumber *)[sqliteData.dataTypesWorking objectAtIndex:[sqliteData.columnNamesWorking indexOfObject:crosstabVariableName]] intValue] == 2)
            {
                if ([[fo.variableValues objectAtIndex:i] isKindOfClass:[NSNull class]] || [[fo.variableValues objectAtIndex:i] isEqualToString:@"(null)"])
                    whereClause = [NSString stringWithFormat:@"WHERE %@ = '(null)'", crosstabVariableName];
                else
                    whereClause = [NSString stringWithFormat:@"WHERE %@ = '%@'", crosstabVariableName, [fo.variableValues objectAtIndex:i]];
            }
            else
                whereClause = [NSString stringWithFormat:@"WHERE %@ = %@", crosstabVariableName, [fo.variableValues objectAtIndex:i]];
            
            MeansObject *mo = [[MeansObject alloc] initWithSQLiteData:sqliteData AndWhereClause:whereClause AndMeansVariable:[availableOutcomeVariables objectAtIndex:[[meansLVE selectedIndex] intValue]] AndIncludeMissing:includeMissing];
            
            if (i == 0)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, otvyValue, outputView.frame.size.width - 4.0, outputView.frame.size.height - 4.0)];
                    [outputTableView setBackgroundColor:epiInfoLightBlue];
                    [outputTableView setClipsToBounds:YES];
                    [outputTableView.layer setCornerRadius:10.0];
                    
                    EpiInfoUILabel *meansVariableNameLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, outputTableView.frame.size.width, 40)];
                    [meansVariableNameLabel setTextAlignment:NSTextAlignmentCenter];
                    [meansVariableNameLabel setTextColor:[UIColor whiteColor]];
                    [meansVariableNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
                    [meansVariableNameLabel setText:[NSString stringWithFormat:@"%@ (%@ = %@)", mo.meansVariable, crosstabVariableName, [fo.variableValues objectAtIndex:i]]];
                    [outputTableView addSubview:meansVariableNameLabel];
                });
                
                NSArray *labelsArray = @[@"Observations",
                                         @"Total",
                                         @"Mean",
                                         @"Variance",
                                         @"Standard Deviation",
                                         @"Minimum",
                                         @"25%",
                                         @"Median",
                                         @"75%",
                                         @"Maximum"];
                for (int i = 0; i < labelsArray.count; i++)
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        UIView *statView = [[UIView alloc] initWithFrame:CGRectMake(2, 40.0 + yValue, outputTableView.frame.size.width / 2.0 - 3.0, 20)];
                        [statView setBackgroundColor:[UIColor whiteColor]];
                        EpiInfoUILabel *statLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8, 0, statView.frame.size.width - 8.0, 20)];
                        [statLabel setBackgroundColor:[UIColor clearColor]];
                        [statLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                        [statLabel setText:[labelsArray objectAtIndex:i]];
                        [statView addSubview:statLabel];
                        if (i == labelsArray.count - 1)
                        {
                            [statView.layer setCornerRadius:8.0];
                            UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(statView.frame.origin.x, statView.frame.origin.y, 40, 10)];
                            UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(statView.frame.size.width / 2.0 + 2.0, statView.frame.origin.y, statView.frame.size.width / 2.0, 20)];
                            [white0 setBackgroundColor:[UIColor whiteColor]];
                            [white1 setBackgroundColor:[UIColor whiteColor]];
                            [outputTableView addSubview:white0];
                            [outputTableView addSubview:white1];
                        }
                        [outputTableView addSubview:statView];
                        
                        UIView *valueView = [[UIView alloc] initWithFrame:CGRectMake(outputTableView.frame.size.width / 2.0 + 1.0, 40.0 + yValue, statView.frame.size.width, 20)];
                        [valueView setBackgroundColor:[UIColor whiteColor]];
                        EpiInfoUILabel *valueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8, 0, valueView.frame.size.width - 8.0, 20)];
                        [valueLabel setBackgroundColor:[UIColor clearColor]];
                        [valueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                        [valueLabel setText:[mo.meansVariableValues objectAtIndex:i]];
                        [valueView addSubview:valueLabel];
                        if (i == labelsArray.count - 1)
                        {
                            [valueView.layer setCornerRadius:8.0];
                            UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(outputTableView.frame.size.width - 42, valueView.frame.origin.y, 40, 10)];
                            UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(valueView.frame.origin.x, valueView.frame.origin.y, 40, 20)];
                            [white0 setBackgroundColor:[UIColor whiteColor]];
                            [white1 setBackgroundColor:[UIColor whiteColor]];
                            [outputTableView addSubview:white0];
                            [outputTableView addSubview:white1];
                        }
                        [outputTableView addSubview:valueView];
                    });
                    
                    yValue += 22.0;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                [outputTableView setFrame:CGRectMake(outputTableView.frame.origin.x, outputTableView.frame.origin.y, outputTableView.frame.size.width, 40.0 + yValue)];
                });
                otvyValue += 42.0 + yValue;

                dispatch_sync(dispatch_get_main_queue(), ^{
                    [outputView addSubview:outputTableView];
                });
            }
            else
            {
                __block UIView *outputTableView2 = nil;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    outputTableView2 = [[UIView alloc] initWithFrame:CGRectMake(2, otvyValue, outputView.frame.size.width - 4.0, outputView.frame.size.height - 4.0)];
                    [outputTableView2 setBackgroundColor:epiInfoLightBlue];
                    [outputTableView2 setClipsToBounds:YES];
                    [outputTableView2.layer setCornerRadius:10.0];
                    
                    EpiInfoUILabel *meansVariableNameLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, outputTableView2.frame.size.width, 40)];
                    [meansVariableNameLabel setTextAlignment:NSTextAlignmentCenter];
                    [meansVariableNameLabel setTextColor:[UIColor whiteColor]];
                    [meansVariableNameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
                    [meansVariableNameLabel setText:[NSString stringWithFormat:@"%@ (%@ = %@)", mo.meansVariable, crosstabVariableName, [fo.variableValues objectAtIndex:i]]];
                    [outputTableView2 addSubview:meansVariableNameLabel];
                });
                
                NSArray *labelsArray = @[@"Observations",
                                         @"Total",
                                         @"Mean",
                                         @"Variance",
                                         @"Standard Deviation",
                                         @"Minimum",
                                         @"25%",
                                         @"Median",
                                         @"75%",
                                         @"Maximum"];
                for (int i = 0; i < labelsArray.count; i++)
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        UIView *statView = [[UIView alloc] initWithFrame:CGRectMake(2, 40.0 + yValue, outputTableView2.frame.size.width / 2.0 - 3.0, 20)];
                        [statView setBackgroundColor:[UIColor whiteColor]];
                        EpiInfoUILabel *statLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8, 0, statView.frame.size.width - 8.0, 20)];
                        [statLabel setBackgroundColor:[UIColor clearColor]];
                        [statLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                        [statLabel setText:[labelsArray objectAtIndex:i]];
                        [statView addSubview:statLabel];
                        if (i == labelsArray.count - 1)
                        {
                            [statView.layer setCornerRadius:8.0];
                            UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(statView.frame.origin.x, statView.frame.origin.y, 40, 10)];
                            UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(statView.frame.size.width / 2.0 + 2.0, statView.frame.origin.y, statView.frame.size.width / 2.0, 20)];
                            [white0 setBackgroundColor:[UIColor whiteColor]];
                            [white1 setBackgroundColor:[UIColor whiteColor]];
                            [outputTableView2 addSubview:white0];
                            [outputTableView2 addSubview:white1];
                        }
                        [outputTableView2 addSubview:statView];
                        
                        UIView *valueView = [[UIView alloc] initWithFrame:CGRectMake(outputTableView2.frame.size.width / 2.0 + 1.0, 40.0 + yValue, statView.frame.size.width, 20)];
                        [valueView setBackgroundColor:[UIColor whiteColor]];
                        EpiInfoUILabel *valueLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8, 0, valueView.frame.size.width - 8.0, 20)];
                        [valueLabel setBackgroundColor:[UIColor clearColor]];
                        [valueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                        [valueLabel setText:[mo.meansVariableValues objectAtIndex:i]];
                        [valueView addSubview:valueLabel];
                        if (i == labelsArray.count - 1)
                        {
                            [valueView.layer setCornerRadius:8.0];
                            UIView *white0 = [[UIView alloc] initWithFrame:CGRectMake(outputTableView2.frame.size.width - 42, valueView.frame.origin.y, 40, 10)];
                            UIView *white1 = [[UIView alloc] initWithFrame:CGRectMake(valueView.frame.origin.x, valueView.frame.origin.y, 40, 20)];
                            [white0 setBackgroundColor:[UIColor whiteColor]];
                            [white1 setBackgroundColor:[UIColor whiteColor]];
                            [outputTableView2 addSubview:white0];
                            [outputTableView2 addSubview:white1];
                        }
                        [outputTableView2 addSubview:valueView];
                    });
                    yValue += 22.0;
                }
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [outputTableView2 setFrame:CGRectMake(outputTableView.frame.origin.x, outputTableView2.frame.origin.y, outputTableView2.frame.size.width, 40.0 + yValue)];
                });
                otvyValue += 42.0 + yValue;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [outputView addSubview:outputTableView2];
                });
            }
            
            [statisticsInputsArray addObject:[NSArray arrayWithArray:mo.meansVariableFloatValues]];
            mo = nil;
        }
        
        // Do crosstab statistics
        __block float statsTableY = otvyValue;
        
        // Build arrays for Kruskal-Wallis
        // verticalFrequencies
        NSMutableArray *verticalFrequencies = [[NSMutableArray alloc] init];
        for (int z = 0; z < statisticsInputsArray.count; z++)
             [verticalFrequencies addObject:[NSNumber numberWithInt:[(NSNumber *)[(NSArray *)[statisticsInputsArray objectAtIndex:z] objectAtIndex:0] intValue]]];
        
        // allLocalFrequencies
        FrequencyObject *meansVariableFrequency = [[FrequencyObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndVariable:[availableOutcomeVariables objectAtIndex:[[meansLVE selectedIndex] intValue]] AndIncludeMissing:includeMissing];
        NSArray *vFreqValues = [NSArray arrayWithArray:meansVariableFrequency.variableValues];
        NSArray *sortedArray = [vFreqValues sortedArrayUsingComparator:^NSComparisonResult(NSString *a, NSString *b) {
            NSNumber *first = [NSNumber numberWithFloat:[a floatValue]];
            NSNumber *second = [NSNumber numberWithFloat:[b floatValue]];
            return [first compare:second];
        }];
        NSMutableArray *frequencyDictionaries = [[NSMutableArray alloc] init];
        for (int z = 0; z < fo.variableValues.count; z++)
        {
            NSString *whereClause;
            if ([(NSNumber *)[sqliteData.dataTypesWorking objectAtIndex:[sqliteData.columnNamesWorking indexOfObject:crosstabVariableName]] intValue] == 2)
            {
                if ([[fo.variableValues objectAtIndex:z] isKindOfClass:[NSNull class]] || [[fo.variableValues objectAtIndex:z] isEqualToString:@"(null)"])
                    whereClause = [NSString stringWithFormat:@"WHERE %@ = '(null)'", crosstabVariableName];
                else
                    whereClause = [NSString stringWithFormat:@"WHERE %@ = '%@'", crosstabVariableName, [fo.variableValues objectAtIndex:z]];
            }
            else
                whereClause = [NSString stringWithFormat:@"WHERE %@ = %@", crosstabVariableName, [fo.variableValues objectAtIndex:z]];
            FrequencyObject *meansVariableFrequencyStratum = [[FrequencyObject alloc] initWithSQLiteData:sqliteData AndWhereClause:whereClause AndVariable:[availableOutcomeVariables objectAtIndex:[[meansLVE selectedIndex] intValue]] AndIncludeMissing:includeMissing];
            NSMutableDictionary *nsmd = [[NSMutableDictionary alloc] init];
            for (int y = 0; y < meansVariableFrequencyStratum.cellCounts.count; y++)
            {
                [nsmd setObject:[meansVariableFrequencyStratum.cellCounts objectAtIndexedSubscript:y] forKey:[NSNumber numberWithFloat:[[meansVariableFrequencyStratum.variableValues objectAtIndex:y] floatValue]]];
            }
            [frequencyDictionaries addObject:nsmd];
        }
        NSMutableArray *allLocalFrequencies = [[NSMutableArray alloc] init];
        for (int z = 0; z < sortedArray.count; z++)
        {
            NSMutableArray *nsma = [[NSMutableArray alloc] init];
            NSNumber *key = [sortedArray objectAtIndex:z];
            key = [NSNumber numberWithFloat:[(NSNumber *)[sortedArray objectAtIndex:z] floatValue]];
            for (int y = 0; y < frequencyDictionaries.count; y++)
            {
                if ([(NSDictionary *)[frequencyDictionaries objectAtIndex:y] objectForKey:key])
                    [nsma addObject:(NSNumber *)[(NSDictionary *)[frequencyDictionaries objectAtIndex:y] objectForKey:key]];
                else
                    [nsma addObject:[NSNumber numberWithFloat:0.0]];
            }
            [allLocalFrequencies addObject:nsma];
        }
        
        // horizontalFrequencies and recoudCount
        float recordCount = 0.0;
        NSMutableArray *horizontalFrequencies = [[NSMutableArray alloc] init];
        for (int z = 0; z < allLocalFrequencies.count; z++)
        {
            float hFreq = 0.0;
            NSArray *localZ = (NSArray *)[allLocalFrequencies objectAtIndex:z];
            for (int y = 0; y < localZ.count; y++)
                hFreq += [(NSNumber *)[localZ objectAtIndex:y] floatValue];
            [horizontalFrequencies addObject:[NSNumber numberWithFloat:hFreq]];
            recordCount += hFreq;
        }
        
        // Now perform the tests
        // If 2 values forcrosstab variable, do t-test
        if ([fo.variableValues count] == 2)
        {
            NSArray *tTestResults = [MeansCrosstabCompute doT:statisticsInputsArray];

            float outputRowsT = 11.0;
            
            __block UIView *tTestView = nil;
            dispatch_sync(dispatch_get_main_queue(), ^{
                tTestView = [[UIView alloc] initWithFrame:CGRectMake(2, statsTableY, outputView.frame.size.width - 4.0, 48.0 + outputRowsT * 22.0)];
                [tTestView setBackgroundColor:epiInfoLightBlue];
                [tTestView setClipsToBounds:YES];
                [tTestView.layer setCornerRadius:10.0];
                
                EpiInfoUILabel *tTestHeaderLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, tTestView.frame.size.width, 40)];
                [tTestHeaderLabel setTextAlignment:NSTextAlignmentCenter];
                [tTestHeaderLabel setTextColor:[UIColor whiteColor]];
                [tTestHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
                [tTestHeaderLabel setText:[NSString stringWithFormat:@"T-Test"]];
                [tTestView addSubview:tTestHeaderLabel];
                
                UIView *whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 40, tTestView.frame.size.width - 4, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"Difference (Group 1 - Group 2)"];
                [sectionLabel setAccessibilityLabel:@"Difference (Group 1 minus Group 2)"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 62, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2, 62, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"Pooled"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2), 62, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"Satterwaite"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 84, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentRight];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"Mean"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2, 84, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:0]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2), 84, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:4]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 106, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentRight];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"95% LCL"];
                [sectionLabel setAccessibilityLabel:@"95% Lower Confidence Limit"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2, 106, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:1]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2), 106, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:5]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 128, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentRight];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"UCL"];
                [sectionLabel setAccessibilityLabel:@"Upper Confidence Limit"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2, 128, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:2]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2), 128, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:6]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 150, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentRight];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"Std Dev"];
                [sectionLabel setAccessibilityLabel:@"Standard Deviation"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2, 150, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:3]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2), 150, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 180, tTestView.frame.size.width - 4, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"Results for Equal and Unequal Variances"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 202, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2, 202, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"Equal"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2), 202, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"Unequal"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 224, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentRight];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"DF"];
                [sectionLabel setAccessibilityLabel:@"Degrees of Freedom"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2, 224, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:7]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2), 224, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:10]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 246, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentRight];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"t Value"];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2, 246, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:8]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((tTestView.frame.size.width - 5) / 3.0 - 1.0) + 2), 246, (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:11]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                EpiInfoViewForRounding *roundedBox = [[EpiInfoViewForRounding alloc] initWithFrame:CGRectMake(2, 48 + 22 * (outputRowsT - 1), (tTestView.frame.size.width - 5) / 3.0 - 1.0, 20) AndIsSquareLeft:NO AndIsSquareRight:YES];
                [roundedBox setBackgroundColor:[UIColor whiteColor]];
                [roundedBox.layer setCornerRadius:8.0];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, roundedBox.frame.size.width - 8, roundedBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentRight];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                [sectionLabel setText:@"P(>|t|)"];
                [sectionLabel setAccessibilityLabel:@"Probability (greater than absolute value of t)"];
                [roundedBox addSubview:sectionLabel];
                [tTestView addSubview:roundedBox];
                
                whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + roundedBox.frame.size.width + 2, roundedBox.frame.origin.y, roundedBox.frame.size.width, 20)];
                [whiteBox setBackgroundColor:[UIColor whiteColor]];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:9]];
                [whiteBox addSubview:sectionLabel];
                [tTestView addSubview:whiteBox];
                
                roundedBox = [[EpiInfoViewForRounding alloc] initWithFrame:CGRectMake(whiteBox.frame.origin.x + whiteBox.frame.size.width + 2, whiteBox.frame.origin.y, whiteBox.frame.size.width, 20) AndIsSquareLeft:YES AndIsSquareRight:NO];
                [roundedBox setBackgroundColor:[UIColor whiteColor]];
                [roundedBox.layer setCornerRadius:8.0];
                sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, roundedBox.frame.size.width, roundedBox.frame.size.height)];
                [sectionLabel setTextAlignment:NSTextAlignmentCenter];
                [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
                [sectionLabel setText:[tTestResults objectAtIndex:12]];
                [roundedBox addSubview:sectionLabel];
                [tTestView addSubview:roundedBox];
            
                statsTableY += tTestView.frame.size.height + 2.0;

                [outputView addSubview:tTestView];
            });
        }
        
        // Do ANOVA
        NSArray *anovaResults = [MeansCrosstabCompute doANOVA:statisticsInputsArray andKruakalWallisWithHorizontalFrequencies:horizontalFrequencies AndVerticalFrequencies:verticalFrequencies AndLocalFrequencies:allLocalFrequencies AndRecordCount:recordCount];
        
        float outputRowsANOVA = 6.0;
        
        __block UIView *anovaView = nil;
        __block UIView *bartlettView = nil;
        __block UIView *wilcoxonView = nil;

        dispatch_sync(dispatch_get_main_queue(), ^{
            anovaView = [[UIView alloc] initWithFrame:CGRectMake(2, statsTableY, outputView.frame.size.width - 4.0, 40 + 22 * outputRowsANOVA)];
            [anovaView setBackgroundColor:epiInfoLightBlue];
            [anovaView setClipsToBounds:YES];
            [anovaView.layer setCornerRadius:10.0];
            
            EpiInfoUILabel *anovaHeaderLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, anovaView.frame.size.width, 40)];
            [anovaHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [anovaHeaderLabel setTextColor:[UIColor whiteColor]];
            [anovaHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [anovaHeaderLabel setText:[NSString stringWithFormat:@"ANOVA"]];
            [anovaView addSubview:anovaHeaderLabel];
            
            UIView *whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 40, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2, 40, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:@"Between"];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 40, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:@"Within"];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 3.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 40, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:@"Total"];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 62, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentRight];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:@"SS"];
            [sectionLabel setAccessibilityLabel:@"Sum of Squares"];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2, 62, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:0]];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 62, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:4]];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 3.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 62, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:7]];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 84, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentRight];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:@"df"];
            [sectionLabel setAccessibilityLabel:@"Degrees of Freedom"];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2, 84, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:1]];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 84, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:5]];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 3.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 84, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:8]];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 106, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentRight];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:@"MS"];
            [sectionLabel setAccessibilityLabel:@"Mean Square"];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2, 106, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:2]];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 106, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:6]];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 3.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 106, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 128, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width - 8, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentRight];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:@"F"];
            [sectionLabel setAccessibilityLabel:@"F Statistic"];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + ((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2, 128, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:3]];
            [whiteBox addSubview:sectionLabel];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 2.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 128, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            [anovaView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + 3.0 * (((anovaView.frame.size.width - 6) / 4.0 - 1.0) + 2), 128, (anovaView.frame.size.width - 6) / 4.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            [anovaView addSubview:whiteBox];
            
            EpiInfoViewForRounding *roundedBox = [[EpiInfoViewForRounding alloc] initWithFrame:CGRectMake(2, 40 + 22 * (outputRowsANOVA - 1), anovaView.frame.size.width - 4, 20) AndIsSquareLeft:NO AndIsSquareRight:NO];
            [roundedBox setBackgroundColor:[UIColor whiteColor]];
            [roundedBox.layer setCornerRadius:8.0];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, roundedBox.frame.size.width, roundedBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:[NSString stringWithFormat:@"P-value = %@", [anovaResults objectAtIndex:9]]];
            [roundedBox addSubview:sectionLabel];
            [anovaView addSubview:roundedBox];
            
            statsTableY += anovaView.frame.size.height + 2.0;
            
            // Do Bartlett Test
            float outputRowsBartlet = 2.0;
            
            bartlettView = [[UIView alloc] initWithFrame:CGRectMake(2, statsTableY, outputView.frame.size.width - 4.0, 40 + 22 * outputRowsBartlet)];
            [bartlettView setBackgroundColor:epiInfoLightBlue];
            [bartlettView setClipsToBounds:YES];
            [bartlettView.layer setCornerRadius:10.0];
            
            EpiInfoUILabel *bartlettHeaderLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, bartlettView.frame.size.width, 40)];
            [bartlettHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [bartlettHeaderLabel setTextColor:[UIColor whiteColor]];
            [bartlettHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17.5]];
            [bartlettHeaderLabel setText:[NSString stringWithFormat:@"Bartlett's Test for Variance Inequality"]];
            [bartlettView addSubview:bartlettHeaderLabel];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 40, (bartlettView.frame.size.width - 4) / 2.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:[NSString stringWithFormat:@"Bartlett's X%@", @"\u00B2"]];
            [sectionLabel setAccessibilityLabel:@"Bartlett's Ky Square"];
            [whiteBox addSubview:sectionLabel];
            [bartlettView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + (bartlettView.frame.size.width - 4) / 2.0 + 1, 40, (bartlettView.frame.size.width - 4) / 2.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:@"P-value"];
            [whiteBox addSubview:sectionLabel];
            [bartlettView addSubview:whiteBox];
            
            roundedBox = [[EpiInfoViewForRounding alloc] initWithFrame:CGRectMake(2, 40 + 22 * (outputRowsBartlet - 1), (bartlettView.frame.size.width - 4) / 2.0 - 1.0, 20) AndIsSquareLeft:NO AndIsSquareRight:YES];
            [roundedBox setBackgroundColor:[UIColor whiteColor]];
            [roundedBox.layer setCornerRadius:8.0];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, roundedBox.frame.size.width, roundedBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:10]];
            [roundedBox addSubview:sectionLabel];
            [bartlettView addSubview:roundedBox];

            roundedBox = [[EpiInfoViewForRounding alloc] initWithFrame:CGRectMake(2 + (bartlettView.frame.size.width - 4) / 2.0 + 1, 40 + 22 * (outputRowsBartlet - 1), (bartlettView.frame.size.width - 4) / 2.0 - 1.0, 20) AndIsSquareLeft:YES AndIsSquareRight:NO];
            [roundedBox setBackgroundColor:[UIColor whiteColor]];
            [roundedBox.layer setCornerRadius:8.0];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, roundedBox.frame.size.width, roundedBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:12]];
            [roundedBox addSubview:sectionLabel];
            [bartlettView addSubview:roundedBox];
            
            statsTableY += bartlettView.frame.size.height + 2.0;
            
            // Do Wilcoxon Kruskal Wallis Test
            float outputRowsKW = 2.0;
            
            wilcoxonView = [[UIView alloc] initWithFrame:CGRectMake(2, statsTableY, outputView.frame.size.width - 4.0, 40 + 22 * outputRowsKW)];
            [wilcoxonView setBackgroundColor:epiInfoLightBlue];
            [wilcoxonView setClipsToBounds:YES];
            [wilcoxonView.layer setCornerRadius:10.0];
            
            EpiInfoUILabel *wilcoxonHeaderLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, wilcoxonView.frame.size.width, 40)];
            [wilcoxonHeaderLabel setTextAlignment:NSTextAlignmentCenter];
            [wilcoxonHeaderLabel setTextColor:[UIColor whiteColor]];
            [wilcoxonHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
            [wilcoxonHeaderLabel setText:[NSString stringWithFormat:@"Wilcoxon Two-Sample Test (Kruskal-Wallis)"]];
            [wilcoxonView addSubview:wilcoxonHeaderLabel];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 40, (wilcoxonView.frame.size.width - 4) / 2.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:[NSString stringWithFormat:@"Kruskal-Wallis X%@", @"\u00B2"]];
            [sectionLabel setAccessibilityLabel:@"Kruskal-Wallis Ky Square"];
            [whiteBox addSubview:sectionLabel];
            [wilcoxonView addSubview:whiteBox];
            
            whiteBox = [[UIView alloc] initWithFrame:CGRectMake(2 + (wilcoxonView.frame.size.width - 4) / 2.0 + 1, 40, (wilcoxonView.frame.size.width - 4) / 2.0 - 1.0, 20)];
            [whiteBox setBackgroundColor:[UIColor whiteColor]];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteBox.frame.size.width, whiteBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
            [sectionLabel setText:@"P-value"];
            [whiteBox addSubview:sectionLabel];
            [wilcoxonView addSubview:whiteBox];
            
            roundedBox = [[EpiInfoViewForRounding alloc] initWithFrame:CGRectMake(2, 40 + 22 * (outputRowsKW - 1), (wilcoxonView.frame.size.width - 4) / 2.0 - 1.0, 20) AndIsSquareLeft:NO AndIsSquareRight:YES];
            [roundedBox setBackgroundColor:[UIColor whiteColor]];
            [roundedBox.layer setCornerRadius:8.0];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, roundedBox.frame.size.width, roundedBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:13]];
            [roundedBox addSubview:sectionLabel];
            [wilcoxonView addSubview:roundedBox];
            
            roundedBox = [[EpiInfoViewForRounding alloc] initWithFrame:CGRectMake(2 + (wilcoxonView.frame.size.width - 4) / 2.0 + 1, 40 + 22 * (outputRowsKW - 1), (wilcoxonView.frame.size.width - 4) / 2.0 - 1.0, 20) AndIsSquareLeft:YES AndIsSquareRight:NO];
            [roundedBox setBackgroundColor:[UIColor whiteColor]];
            [roundedBox.layer setCornerRadius:8.0];
            sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, roundedBox.frame.size.width, roundedBox.frame.size.height)];
            [sectionLabel setTextAlignment:NSTextAlignmentCenter];
            [sectionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
            [sectionLabel setText:[anovaResults objectAtIndex:15]];
            [roundedBox addSubview:sectionLabel];
            [wilcoxonView addSubview:roundedBox];
            
            statsTableY += wilcoxonView.frame.size.height + 2.0;

            [avc setContentSize:CGSizeMake(self.frame.size.width, statsTableY + 96.0)];
        });
        
        horizontalFrequencies = nil;
        verticalFrequencies = nil;
        allLocalFrequencies = nil;
        recordCount = 0.0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [outputView addSubview:anovaView];
            [outputView addSubview:bartlettView];
            [outputView addSubview:wilcoxonView];
        });
    }
    if (NO) // No stratification available (yet?) (meansVariableChosen && crosstabVariableChosen && stratificationVariableChosen)
    {
        NSString *stratificationVariableName = [availableStratificationVariables objectAtIndex:[selectedStratificationVariableNumber intValue] + 1];
        NSString *outcomeVariableName = [availableOutcomeVariables objectAtIndex:selectedMeansVariableNumber.integerValue];
        NSString *exposureVariableName = [availableExposureVariables objectAtIndex:selectedCrosstabVariableNumber.integerValue];
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
            
            TablesObject *to = [[TablesObject alloc] initWithSQLiteData:sqliteData AndWhereClause:whereClause AndOutcomeVariable:outcomeVariableName AndExposureVariable:exposureVariableName AndIncludeMissing:includeMissing];
            
            if (to.exposureValues.count == 2 && to.outcomeValues.count == 2)
            {
                [twoByTwoStrata addObject:to.cellCounts];
                
                if (stratum == 0)
                    [self doTwoByTwo:to OnOutputView:outputView StratificationVariable:stratificationVariableName StratificationValue:[fo.variableValues objectAtIndex:i]];
                else
                {
                    //Add another output view
                    UIView *outputView2 = [[UIView alloc] initWithFrame:CGRectMake(0 + 420.0 * rightSide, contentSizeHeight - amountToSubtract * rightSide, outputView.frame.size.width, outputView.frame.size.height)];
                    [outputView2 setBackgroundColor:[UIColor whiteColor]];
                    [self addSubview:outputView2];
                    [self doTwoByTwo:to OnOutputView:outputView2 StratificationVariable:stratificationVariableName StratificationValue:[fo.variableValues objectAtIndex:i]];
                }
                if (stratum > 0)
                    contentSizeHeight += 652.0 * leftSide;
                amountToSubtract = 604.0;
            }
            else
            {
                allTwoByTwo = NO;
                CGSize rSize;
                if (stratum == 0)
                {
                    rSize = [self doMxN:to OnOutputView:outputView StratificationVariable:stratificationVariableName StratificationValue:[fo.variableValues objectAtIndex:i]];
                    contentSizeHeight = rSize.height;
                }
                else
                {
                    //Add another output view
                    UIView *outputView2 = [[UIView alloc] initWithFrame:CGRectMake(0, contentSizeHeight - amountToSubtract * rightSide, outputView.frame.size.width, outputView.frame.size.height)];
                    [outputView2 setBackgroundColor:[UIColor whiteColor]];
                    [self addSubview:outputView2];
                    rSize = [self doMxN:to OnOutputView:outputView2 StratificationVariable:stratificationVariableName StratificationValue:[fo.variableValues objectAtIndex:i]];
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
            [self addSubview:outputView2];
            TablesObject *to = [[TablesObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndOutcomeVariable:outcomeVariableName AndExposureVariable:exposureVariableName AndIncludeMissing:includeMissing];
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
    if ([pickerView tag] > 0)
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
        selectedMeansVariableNumber = [NSNumber numberWithInteger:row];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [UIView animateWithDuration:0.3 animations:^{
                if (selectedMeansVariableNumber.intValue == 0)
                {
                    meansVariableChosen = NO;
                    [chosenMeansVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                    [chosenMeansVariable setTitle:@"Select Means Variable" forState:UIControlStateNormal];
                    return;
                }
                if (chooseMeansVariable.frame.origin.y < 500)
                {
                    float fontSize = 18.0;
                    while ([[NSString stringWithFormat:@"Means Variable: %@", [availableOutcomeVariables objectAtIndex:selectedMeansVariableNumber.integerValue]] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > chosenMeansVariable.frame.size.width - 10.0)
                        fontSize -= 0.1;
                    meansVariableChosen = YES;
                    [chosenMeansVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
                    [chosenMeansVariable setTitle:[NSString stringWithFormat:@"Means Variable: %@", [availableOutcomeVariables objectAtIndex:selectedMeansVariableNumber.integerValue]] forState:UIControlStateNormal];
                }
            }];
        }
    }
    else if ([pickerView tag] == 1)
    {
        selectedCrosstabVariableNumber = [NSNumber numberWithInteger:row - 1];
        if (row == 0)
            crosstabVariableChosen = NO;
        else
            crosstabVariableChosen = YES;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            selectedCrosstabVariableNumber = [NSNumber numberWithInteger:row];
            [UIView animateWithDuration:0.3 animations:^{
                if (selectedCrosstabVariableNumber.intValue <= 0)
                {
                    [chosenCrosstabVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                    [chosenCrosstabVariable setTitle:@"Select Crosstab Variable" forState:UIControlStateNormal];
                    return;
                }
                if (chooseCrosstabVariable.frame.origin.y < 500)
                {
                    float fontSize = 18.0;
                    while ([[NSString stringWithFormat:@"Crosstab Variable: %@", [availableExposureVariables objectAtIndex:selectedCrosstabVariableNumber.integerValue]] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > chosenCrosstabVariable.frame.size.width - 10.0)
                        fontSize -= 0.1;
                    [chosenCrosstabVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
                    [chosenCrosstabVariable setTitle:[NSString stringWithFormat:@"Crosstab Variable: %@", [availableExposureVariables objectAtIndex:selectedCrosstabVariableNumber.integerValue]] forState:UIControlStateNormal];
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
        [outputV addSubview:stratumHeader];
    }
    
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
    [outputV addSubview:outputTableView];
    
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
    [outputTableView addSubview:outcomeVariableLabel];
    EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(exposureVariableLabelX, exposureVariableLabelY, exposureVariableLabelWidth, 20)];
    [exposureVariableLabel setText:to.exposureVariable];
    [exposureVariableLabel setTextAlignment:NSTextAlignmentRight];
    [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
    [exposureVariableLabel setTextColor:[UIColor whiteColor]];
    [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
    [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
    [outputTableView addSubview:exposureVariableLabel];
    
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
    
    k = 0;
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
        [outputTableView addSubview:exposureValueLabel];
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
                [outputTableView addSubview:outcomeValueLabel];
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
            [rowPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * [(NSNumber *)[to.cellCounts objectAtIndex:k] floatValue] / (float)rowTotals[i]]];
            [countView addSubview:rowPctLabel];
            EpiInfoUILabel *colPctLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 27, cellWidth - 1, 12)];
            [colPctLabel setTextAlignment:NSTextAlignmentRight];
            [colPctLabel setBackgroundColor:[UIColor clearColor]];
            [colPctLabel setTextColor:[UIColor lightGrayColor]];
            [colPctLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
            [colPctLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * [(NSNumber *)[to.cellCounts objectAtIndex:k] floatValue] / (float)columnTotals[j]]];
            [countView addSubview:colPctLabel];
            [outputTableView addSubview:countView];
            k++;
        }
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
        [outputTableView addSubview:rowView];
    }
    for (int j = 0; j < to.outcomeValues.count; j++)
    {
        UIView *columnView = [[UIView alloc] initWithFrame:CGRectMake(79 + (float)j * (cellWidth + 2.0), (numberOfExposureValues + 1.0) * 42.0, cellWidth, 40)];
        [columnView setBackgroundColor:[UIColor whiteColor]];
        [columnView.layer setCornerRadius:10.0];
        EpiInfoUILabel *columnTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
        [columnTotal setTextAlignment:NSTextAlignmentCenter];
        [columnTotal setText:[NSString stringWithFormat:@"%d", columnTotals[j]]];
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
        [outputTableView addSubview:columnView];
    }
    
    UIView *totalTotalView = [[UIView alloc] initWithFrame:CGRectMake(79 + numberOfOutcomeValues * (cellWidth + 2), (numberOfExposureValues + 1.0) * 42.0, cellWidth, 40)];
    [totalTotalView setBackgroundColor:[UIColor whiteColor]];
    [totalTotalView.layer setCornerRadius:10.0];
    EpiInfoUILabel *totalTotal = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 16)];
    [totalTotal setTextAlignment:NSTextAlignmentCenter];
    [totalTotal setText:[NSString stringWithFormat:@"%d", grandTotal]];
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
    [outputTableView addSubview:totalTotalView];
    
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
        EpiInfoUILabel *chiSqLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, outputTableView.frame.origin.y + outputTableView.frame.size.height, outputV.frame.size.width, 20)];
        [chiSqLabel setBackgroundColor:[UIColor clearColor]];
        [chiSqLabel setText:[NSString stringWithFormat:@"Chi Square: %.2f, df: %u, p-value: %.3f", chiSq, (int)(to.exposureValues.count - 1) * (int)(to.outcomeValues.count - 1), chiSqP]];
        [chiSqLabel setTextAlignment:NSTextAlignmentCenter];
        [outputV addSubview: chiSqLabel];
        if (lowExpectation)
        {
            EpiInfoUILabel *lowExpectationLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(0, chiSqLabel.frame.origin.y + 20.0, chiSqLabel.frame.size.width, 20)];
            [lowExpectationLabel setBackgroundColor:[UIColor clearColor]];
            [lowExpectationLabel setText:@"An expected cell count is <5. Chi squared may not be valid."];
            [lowExpectationLabel setTextAlignment:NSTextAlignmentCenter];
            [lowExpectationLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
            [outputV addSubview:lowExpectationLabel];
        }
    }
    
    //Set the parent view controller's content size for scrolling
    //    [avc setContentSize:CGSizeMake(MAX(self.frame.size.width, outputTableViewWidth + 4.0), MAX(self.frame.size.height, outputTableViewHeight + 110.0))];
    
    [outputV setFrame:CGRectMake(outputV.frame.origin.x, outputV.frame.origin.y, outputV.frame.size.width, outputTableViewHeight + outputTableView.frame.origin.y)];
    if (stratVar)
        return CGSizeMake(MAX(self.frame.size.width, outputTableViewWidth + 4.0), outputTableViewHeight + outputTableView.frame.origin.y + 110.0);
    
    return CGSizeMake(MAX(self.frame.size.width, outputTableViewWidth + 4.0), outputTableViewHeight + outputTableView.frame.origin.y + 150.0);
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
            [outputV addSubview:stratumHeader];
        }
        
        //Make the view for the actual 2x2 table
        outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 168)];
        [outputTableView setBackgroundColor:epiInfoLightBlue];
        [outputTableView.layer setCornerRadius:10.0];
        [outputV addSubview:outputTableView];
        
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
        [outputTableView addSubview:outcomeVariableLabel];
        EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(-45, 70, 120, 20)];
        [exposureVariableLabel setText:to.exposureVariable];
        [exposureVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        [exposureVariableLabel setTextColor:[UIColor whiteColor]];
        [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
        [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
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
            [exposureValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]];
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
                    [outcomeValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]];
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
        [outputTableView addSubview:totalTotalView];
        
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
        [outputV addSubview:oddsBasedParametersView];
        
        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 284 + stratificationOffset, 313, 88)];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [riskBasedParametersView.layer setCornerRadius:10.0];
        [outputV addSubview:riskBasedParametersView];
        
        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 374 + stratificationOffset, 313, 176)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
        [statisticalTestsView.layer setCornerRadius:10.0];
        [outputV addSubview:statisticalTestsView];
        
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
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatioLower]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatioUpper]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" MLE OR"];
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
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[1]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[2]]];
        [riskBasedParametersView addSubview:gridBox];
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
            [outputV addSubview:stratumHeader];
        }
        
        //Make the view for the actual 2x2 table
        outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 168)];
        [outputTableView setBackgroundColor:epiInfoLightBlue];
        [outputTableView.layer setCornerRadius:10.0];
        [outputV addSubview:outputTableView];
        
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
        [outputTableView addSubview:outcomeVariableLabel];
        EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(-45, 70, 120, 20)];
        [exposureVariableLabel setText:to.exposureVariable];
        [exposureVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        [exposureVariableLabel setTextColor:[UIColor whiteColor]];
        [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
        [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
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
            [exposureValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureValueFontSize]];
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
                    [outcomeValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:outcomeValueFontSize]];
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
        [outputTableView addSubview:totalTotalView];
        
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
        [outputV addSubview:oddsBasedParametersView];
        
        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 284 + stratificationOffset, 313, 88)];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [riskBasedParametersView.layer setCornerRadius:10.0];
        [outputV addSubview:riskBasedParametersView];
        
        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 374 + stratificationOffset, 313, 176)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
        [statisticalTestsView.layer setCornerRadius:10.0];
        [outputV addSubview:statisticalTestsView];
        
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
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatioLower]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", oddsRatioUpper]];
        [oddsBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(2, 66, fourWidth0, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentLeft];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]];
        [gridBox setText:@" MLE OR"];
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
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(6 + fourWidth0 + fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[1]]];
        [riskBasedParametersView addSubview:gridBox];
        gridBox = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(8 + fourWidth0 + 2 * fourWidth1, 44, fourWidth1, 20)];
        [gridBox setBackgroundColor:[UIColor whiteColor]];
        [gridBox setTextColor:[UIColor blackColor]];
        [gridBox setTextAlignment:NSTextAlignmentCenter];
        [gridBox setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0]];
        [gridBox setText:[NSString stringWithFormat:@"%.4f", RRstats[2]]];
        [riskBasedParametersView addSubview:gridBox];
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
        [outputV addSubview:stratumHeader];
        
        //Make the view for the actual 2x2 table
        float stratificationOffset = 40.0;
        outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 168)];
        [outputTableView setBackgroundColor:epiInfoLightBlue];
        [outputTableView.layer setCornerRadius:10.0];
        [outputV addSubview:outputTableView];
        
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
        [outputTableView addSubview:outcomeVariableLabel];
        EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(-45, 70, 120, 20)];
        [exposureVariableLabel setText:to.exposureVariable];
        [exposureVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        [exposureVariableLabel setTextColor:[UIColor whiteColor]];
        [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
        [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
        [outputTableView addSubview:exposureVariableLabel];
        
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
            [outputTableView addSubview:exposureValueLabel];
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
                    [outputTableView addSubview:outcomeValueLabel];
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
        [outputTableView addSubview:totalTotalView];
        
        //Add the views for each section of statistics
        oddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 172 + stratificationOffset, 313, 154)];
        [oddsBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [oddsBasedParametersView.layer setCornerRadius:10.0];
        [outputV addSubview:oddsBasedParametersView];
        
        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 328 + stratificationOffset, 313, 88)];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [riskBasedParametersView.layer setCornerRadius:10.0];
        [outputV addSubview:riskBasedParametersView];
        
        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 418 + stratificationOffset, 313, 88)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
        [statisticalTestsView.layer setCornerRadius:10.0];
        [outputV addSubview:statisticalTestsView];
        
        UIView *homogeneityTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 508 + stratificationOffset, 313, 110)];
        [homogeneityTestsView setBackgroundColor:epiInfoLightBlue];
        [homogeneityTestsView.layer setCornerRadius:10.0];
        [outputV addSubview:homogeneityTestsView];
        
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
        [outputV addSubview:stratumHeader];
        
        //Make the view for the actual 2x2 table
        float stratificationOffset = 40.0;
        outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, 2 + stratificationOffset, 313, 168)];
        [outputTableView setBackgroundColor:epiInfoLightBlue];
        [outputTableView.layer setCornerRadius:10.0];
        [outputV addSubview:outputTableView];
        
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
        [outputTableView addSubview:outcomeVariableLabel];
        EpiInfoUILabel *exposureVariableLabel = [[EpiInfoUILabel alloc] initWithFrame:CGRectMake(-45, 70, 120, 20)];
        [exposureVariableLabel setText:to.exposureVariable];
        [exposureVariableLabel setTextAlignment:NSTextAlignmentCenter];
        [exposureVariableLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2.0)];
        [exposureVariableLabel setTextColor:[UIColor whiteColor]];
        [exposureVariableLabel setBackgroundColor:[UIColor clearColor]];
        [exposureVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:exposureVariableLabelFontSize]];
        [outputTableView addSubview:exposureVariableLabel];
        
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
            [outputTableView addSubview:exposureValueLabel];
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
                    [outputTableView addSubview:outcomeValueLabel];
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
        [outputTableView addSubview:totalTotalView];
        
        //Add the views for each section of statistics
        oddsBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 172 + stratificationOffset, 313, 154)];
        [oddsBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [oddsBasedParametersView.layer setCornerRadius:10.0];
        [outputV addSubview:oddsBasedParametersView];
        
        riskBasedParametersView = [[UIView alloc] initWithFrame:CGRectMake(2, 328 + stratificationOffset, 313, 88)];
        [riskBasedParametersView setBackgroundColor:epiInfoLightBlue];
        [riskBasedParametersView.layer setCornerRadius:10.0];
        [outputV addSubview:riskBasedParametersView];
        
        statisticalTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 418 + stratificationOffset, 313, 88)];
        [statisticalTestsView setBackgroundColor:epiInfoLightBlue];
        [statisticalTestsView.layer setCornerRadius:10.0];
        [outputV addSubview:statisticalTestsView];
        
        UIView *homogeneityTestsView = [[UIView alloc] initWithFrame:CGRectMake(2, 508 + stratificationOffset, 313, 110)];
        [homogeneityTestsView setBackgroundColor:epiInfoLightBlue];
        [homogeneityTestsView.layer setCornerRadius:10.0];
        [outputV addSubview:homogeneityTestsView];
        
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
