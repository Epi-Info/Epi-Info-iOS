//
//  FrequencyView.m
//  EpiInfo
//
//  Created by John Copeland on 7/8/13.
//  Copyright (c) 2013 John Copeland. All rights reserved.
//

#import "FrequencyView.h"
#import "AnalysisViewController.h"

@implementation FrequencyView
{
    AnalysisViewController *avc;
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
            inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [inputView setBackgroundColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0]];
            [inputView.layer setCornerRadius:10.0];
            chosenFrequencyVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 10, frame.size.width - 40, 44)];
            [chosenFrequencyVariable setBackgroundColor:epiInfoLightBlue];
            [chosenFrequencyVariable.layer setCornerRadius:10.0];
            [chosenFrequencyVariable setTitle:@"Select Frequency Variable" forState:UIControlStateNormal];
            [chosenFrequencyVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenFrequencyVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenFrequencyVariable addTarget:self action:@selector(chosenFrequencyVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenFrequencyVariable];
            chooseVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 300, 162)];
            selectedVariableNumber = 0;
            frequencyVariableChosen = NO;
            [chooseVariable setDelegate:self];
            [chooseVariable setDataSource:self];
            [chooseVariable setShowsSelectionIndicator:YES];
            [chooseVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseVariableTapped:)]];
//            [inputView addSubview:chooseVariable];
            includeMissing = NO;
            includeMissingButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 104, 22, 22)];
            [includeMissingButton.layer setCornerRadius:6];
            [includeMissingButton.layer setBorderColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0].CGColor];
            [includeMissingButton.layer setBorderWidth:2.0];
            [includeMissingButton addTarget:self action:@selector(includeMissingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [inputView addSubview:includeMissingButton];
            [inputView sendSubviewToBack:includeMissingButton];
            includeMissingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 104, frame.size.width / 2.0 - 22, 22)];
            [includeMissingLabel setTextAlignment:NSTextAlignmentLeft];
            [includeMissingLabel setTextColor:epiInfoLightBlue];
            [includeMissingLabel setText:@"Include missing"];
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
//            [inputView sendSubviewToBack:chosenStratificationVariable];

            chooseStratificationVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 296, 162)];
            [chooseStratificationVariable setTag:2];
            stratificationVariableChosen = NO;
            selectedStratificationVariableNumber = 0;
            [chooseStratificationVariable setDelegate:self];
            [chooseStratificationVariable setDataSource:self];
            [chooseStratificationVariable setShowsSelectionIndicator:YES];
            [chooseStratificationVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseStratificationVariableTapped:)]];
//            [inputView addSubview:chooseStratificationVariable];
            
            // Hide the stratification inputs until wired up.
//            [chooseStratificationVariable setHidden:YES];
//            [chosenStratificationVariable setHidden:YES];

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
            gadgetTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
            [gadgetTitle setText:@"Frequency"];
            [gadgetTitle setTextColor:epiInfoLightBlue];
            [gadgetTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [titleBar addSubview:gadgetTitle];
            
            //Add the quit button
            xButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 44, 0, 44, 44)];
            [xButton setBackgroundColor:[UIColor whiteColor]];
            [xButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
            [xButton.layer setCornerRadius:10.0];
            [xButton.layer setBorderColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0].CGColor];
            [xButton.layer setBorderWidth:2.0];
            [xButton addTarget:self action:@selector(xButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [titleBar addSubview:xButton];
            
            //Add the gear button
            gearButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 88, 0, 44, 44)];
            [gearButton setBackgroundColor:[UIColor whiteColor]];
            [gearButton setImage:[UIImage imageNamed:@"gear-button.png"] forState:UIControlStateNormal];
            [gearButton.layer setCornerRadius:10.0];
            [gearButton.layer setBorderColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0].CGColor];
            [gearButton.layer setBorderWidth:2.0];
            [gearButton addTarget:self action:@selector(gearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [titleBar addSubview:gearButton];
            
            inputViewDisplayed = YES;
        }
        else
        {
            //Add the output view
            outputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [outputView setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:outputView];
            
            //Add the input view
            inputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [inputView setBackgroundColor:epiInfoLightBlue];
            [inputView.layer setCornerRadius:10.0];
            chosenFrequencyVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 10, frame.size.width - 40, 44)];
            [chosenFrequencyVariable setBackgroundColor:epiInfoLightBlue];
            [chosenFrequencyVariable.layer setCornerRadius:10.0];
            [chosenFrequencyVariable setTitle:@"Select Frequency Variable" forState:UIControlStateNormal];
            [chosenFrequencyVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenFrequencyVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenFrequencyVariable addTarget:self action:@selector(chosenFrequencyVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenFrequencyVariable];
            chooseVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 748, 162)];
            selectedVariableNumber = 0;
            frequencyVariableChosen = NO;
            [chooseVariable setDelegate:self];
            [chooseVariable setDataSource:self];
            [chooseVariable setShowsSelectionIndicator:YES];
            [chooseVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseVariableTapped:)]];
//            [inputView addSubview:chooseVariable];
            includeMissing = NO;
            includeMissingButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 104, 22, 22)];
            [includeMissingButton.layer setCornerRadius:6];
            [includeMissingButton.layer setBorderColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0].CGColor];
            [includeMissingButton.layer setBorderWidth:2.0];
            [includeMissingButton addTarget:self action:@selector(includeMissingButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [inputView addSubview:includeMissingButton];
            [inputView sendSubviewToBack:includeMissingButton];
            includeMissingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 104, frame.size.width / 2.0 - 22, 22)];
            [includeMissingLabel setTextAlignment:NSTextAlignmentLeft];
            [includeMissingLabel setTextColor:epiInfoLightBlue];
            [includeMissingLabel setText:@"Include missing"];
            [inputView addSubview:includeMissingLabel];
            [inputView sendSubviewToBack:includeMissingLabel];
            inputViewWhiteBox = [[UIView alloc] initWithFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
            [inputViewWhiteBox setBackgroundColor:[UIColor whiteColor]];
            [inputViewWhiteBox.layer setCornerRadius:8.0];
            [inputView addSubview:inputViewWhiteBox];
            [inputView sendSubviewToBack:inputViewWhiteBox];
            
            //Add Stratification Variable button and picker
            chosenStratificationVariable = [[ShinyButton alloc] initWithFrame:CGRectMake(20, 135, frame.size.width - 40, 44)];
            [chosenStratificationVariable setBackgroundColor:epiInfoLightBlue];
            [chosenStratificationVariable.layer setCornerRadius:10.0];
            [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
            [chosenStratificationVariable.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [chosenStratificationVariable setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
            [chosenStratificationVariable addTarget:self action:@selector(chosenStratificationVariableButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//            [inputView addSubview:chosenStratificationVariable];
//            [inputView sendSubviewToBack:chosenStratificationVariable];
            
            chooseStratificationVariable = [[UIPickerViewWithBlurryBackground alloc] initWithFrame:CGRectMake(10, 1000, 748, 162)];
            [chooseStratificationVariable setTag:2];
            stratificationVariableChosen = NO;
            selectedStratificationVariableNumber = 0;
            [chooseStratificationVariable setDelegate:self];
            [chooseStratificationVariable setDataSource:self];
            [chooseStratificationVariable setShowsSelectionIndicator:YES];
            [chooseStratificationVariable addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseStratificationVariableTapped:)]];
//            [inputView addSubview:chooseStratificationVariable];

            [self addSubview:inputView];
            
            //Add title bar
            titleBar = [[UIView alloc] initWithFrame:CGRectMake(0, -114, frame.size.width, 162)];
            [titleBar setBackgroundColor:[UIColor whiteColor]];
            [self addSubview:titleBar];
            
            //Add the gadget title
            gadgetTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
            [gadgetTitle setText:@"Frequency"];
            [gadgetTitle setTextColor:epiInfoLightBlue];
            [gadgetTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
            [titleBar addSubview:gadgetTitle];
            
            //Add the quit button
            xButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 44, 0, 44, 44)];
            [xButton setBackgroundColor:[UIColor whiteColor]];
            [xButton setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
            [xButton.layer setCornerRadius:10.0];
            [xButton.layer setBorderColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0].CGColor];
            [xButton.layer setBorderWidth:2.0];
            [xButton addTarget:self action:@selector(xButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [titleBar addSubview:xButton];
            
            //Add the gear button
            gearButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 88, 0, 44, 44)];
            [gearButton setBackgroundColor:[UIColor whiteColor]];
            [gearButton setImage:[UIImage imageNamed:@"gear-button.png"] forState:UIControlStateNormal];
            [gearButton.layer setCornerRadius:10.0];
            [gearButton.layer setBorderColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0].CGColor];
            [gearButton.layer setBorderWidth:2.0];
            [gearButton addTarget:self action:@selector(gearButtonPressed) forControlEvents:UIControlEventTouchUpInside];
            [titleBar addSubview:gearButton];
            
            inputViewDisplayed = YES;
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
    frequencyVariableLabel = [[UILabel alloc] initWithFrame:chosenFrequencyVariable.frame];
    [frequencyVariableLabel setBackgroundColor:[UIColor whiteColor]];
    [frequencyVariableLabel setTextColor:epiInfoLightBlue];
    [frequencyVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [frequencyVariableLabel setText:@"Frequency Variable"];
    frequencyVariableString = [[UITextField alloc] init];
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
    availableVariables = [NSMutableArray arrayWithArray:outcomeNSMA];
    frequencyLVE = [[LegalValuesEnter alloc] initWithFrame:chosenFrequencyVariable.frame AndListOfValues:outcomeNSMA AndTextFieldToUpdate:frequencyVariableString];
    [frequencyLVE.picker selectRow:0 inComponent:0 animated:YES];
    [frequencyLVE analysisStyle];
    [inputView addSubview:frequencyLVE];
    stratificationLVE = [[LegalValuesEnter alloc] initWithFrame:chosenStratificationVariable.frame AndListOfValues:outcomeNSMA AndTextFieldToUpdate:stratificationVariableString];
    [stratificationLVE.picker selectRow:0 inComponent:0 animated:YES];
    [stratificationLVE analysisStyle];
    [inputView addSubview:stratificationLVE];
    [chosenFrequencyVariable setTitle:[frequencyVariableString text] forState:UIControlStateNormal];
    [inputView addSubview:frequencyVariableLabel];
    [inputView addSubview:stratificationVariableLabel];
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
                [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, 302)];
                [chosenFrequencyVariable setFrame:CGRectMake(20, 10, frame.size.width - 40, 44)];
                [chooseVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
                [chosenStratificationVariable setFrame:CGRectMake(20, 124, 276, 44)];
                [chooseStratificationVariable setFrame:CGRectMake(10, 1000, 296, 162)];
                [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                [frequencyVariableLabel setFrame:CGRectMake(16, 10, 284, 20)];
                [frequencyLVE setFrame:CGRectMake(10, 30, 300, 44)];
                [includeMissingButton setFrame:CGRectMake(170, 124, 22, 22)];
                [includeMissingLabel setFrame:CGRectMake(20, 124, 140, 22)];
                [stratificationVariableLabel setFrame:CGRectMake(16, includeMissingLabel.frame.origin.y + includeMissingLabel.frame.size.height + 16, 284, 20)];
                [stratificationLVE setFrame:CGRectMake(10, stratificationVariableLabel.frame.origin.y + stratificationVariableLabel.frame.size.height, 300, 44)];
            }
            else
            {
                if ([avc portraitOrientation])
                {
                    [avc setContentSize:CGSizeMake(self.frame.size.width, 100 + outputTableView.frame.size.height)];
                }
                else
                {
                    [avc setContentSize:CGSizeMake(self.frame.size.width, 100 + outputTableView.frame.size.height)];
                }
            }
        }
    }
    else
    {
        if (frame.size.width > 0.0 && frame.size.height > 0.0)
        {
            [titleBar setFrame:CGRectMake(0, 0, frame.size.width, 48)];
            [gadgetTitle setFrame:CGRectMake(2, 8, 316 - 96, 44)];
            [xButton setFrame:CGRectMake(frame.size.width - 4.0 - 46, 2, 44, 44)];
            [gearButton setFrame:CGRectMake(frame.size.width - 4.0 - 92, 2, 44, 44)];
            [outputView setFrame:CGRectMake(0, 46, frame.size.width, 10.0 * frame.size.height - 46)];
            if (inputViewDisplayed)
            {
                [inputView setFrame:CGRectMake(2, 48, frame.size.width - 4, MIN(860.0, frame.size.height - 50))];
                [chosenFrequencyVariable setFrame:CGRectMake(20, 10, frame.size.width - 40, 44)];
                [chooseVariable setFrame:CGRectMake(10, 60, frame.size.width - 20, 162)];
                [chosenStratificationVariable setFrame:CGRectMake(20, 260, frame.size.width - 40, 44)];
                [chooseStratificationVariable setFrame:CGRectMake(10, 310, frame.size.width - 20, 162)];
                [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, inputView.frame.size.height - 4)];
                [includeMissingButton setFrame:CGRectMake(170, 228, 22, 22)];
                [includeMissingLabel setFrame:CGRectMake(20, 228, 140, 22)];
                [frequencyVariableLabel setFrame:CGRectMake(chosenFrequencyVariable.frame.origin.x, chosenFrequencyVariable.frame.origin.y, 284, 20)];
                [frequencyLVE setFrame:CGRectMake(frequencyVariableLabel.frame.origin.x - 6, frequencyVariableLabel.frame.origin.y + 20, 276, 44)];
                [stratificationVariableLabel setFrame:CGRectMake(chosenStratificationVariable.frame.origin.x, chosenStratificationVariable.frame.origin.y, 284, 20)];
                [stratificationLVE setFrame:CGRectMake(stratificationVariableLabel.frame.origin.x - 6, stratificationVariableLabel.frame.origin.y + 20, 276, 44)];
            }
            else
            {
                if ([avc portraitOrientation])
                {
                    [avc setContentSize:CGSizeMake(self.frame.size.width, 100 + outputTableView.frame.size.height)];
                }
                else
                {
                    [avc setContentSize:CGSizeMake(self.frame.size.width, 100 + outputTableView.frame.size.height)];
                }
            }
        }
    }
}

- (void)chosenFrequencyVariableButtonPressed
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    
    frequencyVariableChosen = YES;
    [UIView animateWithDuration:0.6 animations:^{
        [chooseVariable setFrame:CGRectMake(10, 6, inputView.frame.size.width - 20, 162)];
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

- (void)chooseVariableTapped:(UITapGestureRecognizer *)tap
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    float fontSize = 18.0;
//    while ([[NSString stringWithFormat:@"Frequency Variable: %@", [availableVariables objectAtIndex:selectedVariableNumber.integerValue]] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]].width > chosenFrequencyVariable.frame.size.width - 10.0)
    // Deprecation replacement
    while ([[NSString stringWithFormat:@"Frequency Variable: %@", [availableVariables objectAtIndex:selectedVariableNumber.integerValue]] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > chosenFrequencyVariable.frame.size.width - 10.0)
        fontSize -= 0.1;
    [chosenFrequencyVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
    [chosenFrequencyVariable setTitle:[NSString stringWithFormat:@"Frequency Variable: %@", [availableVariables objectAtIndex:selectedVariableNumber.integerValue]] forState:UIControlStateNormal];
    [UIView animateWithDuration:0.9 animations:^{
        [chooseVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)chooseStratificationVariableTapped:(UITapGestureRecognizer *)tap
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return;
    [UIView animateWithDuration:0.9 animations:^{
        if (stratificationVariableChosen)
            [chosenStratificationVariable setTitle:[NSString stringWithFormat:@"Stratify By:  %@", [availableVariables objectAtIndex:selectedStratificationVariableNumber.integerValue]] forState:UIControlStateNormal];
        else
            [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
        [chooseStratificationVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
    }];
}

- (void)xButtonPressed
{
    [avc resetContentSize];
    [avc putViewOnEpiInfoScrollView:self];
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
}

- (void)gearButtonPressed
{
    [avc putViewOnZoomingView:self];
    [avc resetContentSize];
    if (inputView.frame.size.height > 0)
    {
        inputViewDisplayed = NO;
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [chosenFrequencyVariable setFrame:CGRectMake(20, chosenFrequencyVariable.frame.origin.y - 170, chosenFrequencyVariable.frame.size.width, 44)];
            [chosenStratificationVariable setFrame:CGRectMake(20, chosenFrequencyVariable.frame.origin.y - 170, chosenFrequencyVariable.frame.size.width, 44)];
            [frequencyLVE setFrame:CGRectMake(10, chosenFrequencyVariable.frame.origin.y, chosenFrequencyVariable.frame.size.width, 44)];
            [stratificationLVE setFrame:CGRectMake(10, chosenStratificationVariable.frame.origin.y, chosenStratificationVariable.frame.size.width, 44)];
            [frequencyVariableLabel setFrame:CGRectMake(10, chosenFrequencyVariable.frame.origin.y - 20, chosenFrequencyVariable.frame.size.width, 44)];
            [stratificationVariableLabel setFrame:CGRectMake(10, chosenStratificationVariable.frame.origin.y - 20, chosenStratificationVariable.frame.size.width, 44)];
            if (chooseVariable.frame.origin.y < 500)
            {
                float fontSize = 18.0;
//                while ([[NSString stringWithFormat:@"Frequency Variable: %@", [availableVariables objectAtIndex:selectedVariableNumber.integerValue]] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]].width > chosenFrequencyVariable.frame.size.width - 10.0)
                // Deprecation replacement
                while ([[NSString stringWithFormat:@"Frequency Variable: %@", [availableVariables objectAtIndex:selectedVariableNumber.integerValue]] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > chosenFrequencyVariable.frame.size.width - 10.0)
                    fontSize -= 0.1;
                [chosenFrequencyVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
                [chosenFrequencyVariable setTitle:[NSString stringWithFormat:@"Frequency Variable: %@", [availableVariables objectAtIndex:selectedVariableNumber.integerValue]] forState:UIControlStateNormal];
                [chooseVariable setFrame:CGRectMake(0, -162, chooseVariable.frame.size.width, 162)];
            }
            if (chooseStratificationVariable.frame.origin.y < 500)
            {
                float fontSize = 18.0;
                //                while ([[NSString stringWithFormat:@"Frequency Variable: %@", [availableVariables objectAtIndex:selectedVariableNumber.integerValue]] sizeWithFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]].width > chosenFrequencyVariable.frame.size.width - 10.0)
                // Deprecation replacement
                if (selectedStratificationVariableNumber && selectedStratificationVariableNumber.integerValue > -1)
                {
                    int padInt = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
                    while ([[NSString stringWithFormat:@"Stratification Variable: %@", [availableVariables objectAtIndex:selectedStratificationVariableNumber.integerValue + padInt]] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > chosenStratificationVariable.frame.size.width - 10.0)
                        fontSize -= 0.1;
                    [chosenStratificationVariable setTitle:[NSString stringWithFormat:@"Stratification Variable: %@", [availableVariables objectAtIndex:selectedStratificationVariableNumber.integerValue + padInt]] forState:UIControlStateNormal];
                }
                else
                    [chosenStratificationVariable setTitle:@"Select Stratification Variable" forState:UIControlStateNormal];
                [chosenStratificationVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
                [chooseStratificationVariable setFrame:CGRectMake(0, -162, chooseStratificationVariable.frame.size.width, 162)];
            }
            [inputView setFrame:CGRectMake(2, 48, self.frame.size.width - 4, 0)];
            [inputViewWhiteBox setFrame:CGRectMake(2, 2, inputView.frame.size.width - 4, 0)];
            [includeMissingButton setFrame:CGRectMake(includeMissingButton.frame.origin.x, -22, 22, 22)];
            [includeMissingLabel setFrame:CGRectMake(20, -22, includeMissingLabel.frame.size.width, 22)];
        } completion:^(BOOL finished){
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            {
                [chooseVariable setHidden:YES];
                [chooseStratificationVariable setHidden:YES];
            }
        }];
        
        if ([[frequencyLVE selectedIndex] intValue] > 0)
        {
            int strata = 1;
            float outputY = 2.0;
            NSString *whereClause = nil;
            UILabel *stratumLabel;
            FrequencyObject *sfo;
            
            if ([[stratificationLVE selectedIndex] intValue] > 0)
            {
                int sfoNumber = [[stratificationLVE selectedIndex] intValue];
                if (NO) // Not after changing to Legal Values controls (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    sfoNumber++;
                sfo = [[FrequencyObject alloc] initWithSQLiteData:sqliteData AndWhereClause:nil AndVariable:[availableVariables objectAtIndex:sfoNumber] AndIncludeMissing:includeMissing];
                strata = (int)sfo.variableValues.count;
                outputY += 22.0;
            }
            
            for (int i = 0; i < strata; i++)
            {
                if (sfo)
                {
                    stratumLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, outputY - 22, outputView.frame.size.width - 20, 20)];
                    [stratumLabel setTextColor:epiInfoLightBlue];
                    [stratumLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
                    [stratumLabel setText:[NSString stringWithFormat:@"%@ = %@", sfo.variableName, [sfo.variableValues objectAtIndex:i]]];
                    [outputView addSubview:stratumLabel];
                    if ([(NSNumber *)[sqliteData.dataTypesWorking objectAtIndex:[sqliteData.columnNamesWorking indexOfObject:sfo.variableName]] intValue] == 2)
                    {
                        if ([[sfo.variableValues objectAtIndex:i] isKindOfClass:[NSNull class]] || [[sfo.variableValues objectAtIndex:i] isEqualToString:@"(null)"])
                            whereClause = [NSString stringWithFormat:@"WHERE %@ = '(null)'", sfo.variableName];
                        else
                            whereClause = [NSString stringWithFormat:@"WHERE %@ = '%@'", sfo.variableName, [sfo.variableValues objectAtIndex:i]];
                    }
                    else
                        whereClause = [NSString stringWithFormat:@"WHERE %@ = %@", sfo.variableName, [sfo.variableValues objectAtIndex:i]];
                }

                FrequencyObject *fo = [[FrequencyObject alloc] initWithSQLiteData:sqliteData AndWhereClause:whereClause AndVariable:[availableVariables objectAtIndex:[[frequencyLVE selectedIndex] intValue]] AndIncludeMissing:includeMissing];
                
                //Old code from when AnalysisDataObject was used to temporarily store data locally
                //            FrequencyObject *fo = [[FrequencyObject alloc] initWithAnalysisDataObject:dataObject AndVariable:[availableVariables objectAtIndex:selectedVariableNumber.integerValue] AndIncludeMissing:includeMissing];
                
                float cellWidth = 104.0;
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                    cellWidth = (self.frame.size.width - 8.0) / 3.0;
                
                outputTableView = [[UIView alloc] initWithFrame:CGRectMake(2, outputY, outputView.frame.size.width - 4, 22.0 + 22 * (fo.variableValues.count + 1))];
                outputY += outputTableView.frame.size.height + 24.0;
                [outputTableView setBackgroundColor:epiInfoLightBlue];
                [outputTableView.layer setCornerRadius:10.0];
                [outputView addSubview:outputTableView];
                
                UILabel *variableLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, cellWidth - 4.0, 20)];
                [variableLabel setText:fo.variableName];
                [variableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
                [variableLabel setBackgroundColor:[UIColor clearColor]];
                [variableLabel setTextColor:[UIColor whiteColor]];
                [outputTableView addSubview:variableLabel];
                
                UILabel *countHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth, 2, cellWidth - 4, 20)];
                [countHeaderLabel setText:@"Count"];
                [countHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
                [countHeaderLabel setBackgroundColor:[UIColor clearColor]];
                [countHeaderLabel setTextColor:[UIColor whiteColor]];
                [countHeaderLabel setTextAlignment:NSTextAlignmentCenter];
                [outputTableView addSubview:countHeaderLabel];
                
                UILabel *percentHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth + cellWidth + 2, 2, cellWidth, 20)];
                [percentHeaderLabel setText:@"Percent"];
                [percentHeaderLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16]];
                [percentHeaderLabel setBackgroundColor:[UIColor clearColor]];
                [percentHeaderLabel setTextColor:[UIColor whiteColor]];
                [percentHeaderLabel setTextAlignment:NSTextAlignmentCenter];
                [outputTableView addSubview:percentHeaderLabel];
                
                float labelFontSize = 16.0;
                float labelWidthWithFont = 0.0;
                for (int i = 0; i < fo.variableValues.count; i++)
                {
                    NSString *tempStr = [NSString stringWithFormat:@"%@", [fo.variableValues objectAtIndex:i]];
                    if ([[fo.variableValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                        tempStr = @"Missing";
                    else if ([[fo.variableValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[fo.variableValues objectAtIndex:i] isEqualToString:@"(null)"])
                        tempStr = @"Missing";
                    //                labelWidthWithFont = MAX(labelWidthWithFont, [tempStr sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:labelFontSize]].width);
                    // Deprecation replacement
                    labelWidthWithFont = MAX(labelWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:labelFontSize]}].width);
                }
                while (labelWidthWithFont > cellWidth - 10.0)
                {
                    labelFontSize -= 0.1;
                    labelWidthWithFont = 0.0;
                    for (int i = 0; i < fo.variableValues.count; i++)
                    {
                        NSString *tempStr = [NSString stringWithFormat:@"%@", [fo.variableValues objectAtIndex:i]];
                        if ([[fo.variableValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                            tempStr = @"Missing";
                        else if ([[fo.variableValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[fo.variableValues objectAtIndex:i] isEqualToString:@"(null)"])
                            tempStr = @"Missing";
                        //                    labelWidthWithFont = MAX(labelWidthWithFont, [tempStr sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:labelFontSize]].width);
                        // Deprecation replacement
                        labelWidthWithFont = MAX(labelWidthWithFont, [tempStr sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:labelFontSize]}].width);
                    }
                }
                
                int totalCount = 0;
                UILabel *valueLabel;
                UILabel *countLabel;
                for (int i = 0; i < fo.variableValues.count; i++)
                {
                    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 22 + 22 * i, cellWidth - 4.0, 20)];
                    [valueLabel setBackgroundColor:[UIColor clearColor]];
                    [valueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:labelFontSize]];
                    [valueLabel setTextColor:[UIColor whiteColor]];
                    countLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth, 22 + 22 * i, cellWidth - 4, 20)];
                    [countLabel setTextAlignment:NSTextAlignmentCenter];
                    [countLabel.layer setCornerRadius:6];
                    if ([[fo.variableValues objectAtIndex:i] isKindOfClass:[NSNull class]])
                        [valueLabel setText:@"Missing"];
                    else if ([[fo.variableValues objectAtIndex:i] isKindOfClass:[NSString class]] && [[fo.variableValues objectAtIndex:i] isEqualToString:@"(null)"])
                        [valueLabel setText:@"Missing"];
                    else
                        [valueLabel setText:[NSString stringWithFormat:@"%@", [fo.variableValues objectAtIndex:i]]];
                    [countLabel setText:[NSString stringWithFormat:@"%@", [fo.cellCounts objectAtIndex:i]]];
                    [countLabel setTextColor:[UIColor whiteColor]];
                    [outputTableView addSubview:valueLabel];
                    [outputTableView addSubview:countLabel];
                    totalCount += [(NSNumber *)[fo.cellCounts objectAtIndex:i] intValue];
                }
                valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 22 + 22 * fo.variableValues.count, cellWidth - 4.0, 20)];
                [valueLabel setBackgroundColor:[UIColor clearColor]];
                [valueLabel setTextColor:[UIColor whiteColor]];
                countLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth, 22 + 22 * fo.variableValues.count, cellWidth, 20)];
                [countLabel setTextAlignment:NSTextAlignmentCenter];
                [countLabel.layer setCornerRadius:6];
                [valueLabel setText:@"Total"];
                [countLabel setText:[NSString stringWithFormat:@"%d", totalCount]];
                [countLabel setTextColor:[UIColor whiteColor]];
                UILabel *percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth + cellWidth + 2, 22 + 22 * fo.variableValues.count, cellWidth, 20)];
                [percentLabel setTextAlignment:NSTextAlignmentCenter];
                [percentLabel.layer setCornerRadius:6];
                [percentLabel setText:@"100%"];
                [percentLabel setTextColor:[UIColor whiteColor]];
                [outputTableView addSubview:valueLabel];
                [outputTableView addSubview:countLabel];
                [outputTableView addSubview:percentLabel];
                for (int i = 0; i < fo.variableValues.count; i++)
                {
                    percentLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellWidth + cellWidth + 2, 22 + 22 * i, cellWidth, 20)];
                    [percentLabel setTextAlignment:NSTextAlignmentCenter];
                    [percentLabel.layer setCornerRadius:6];
                    [percentLabel setText:[NSString stringWithFormat:@"%.2f%%", 100 * [(NSNumber *)[fo.cellCounts objectAtIndex:i] floatValue] / (float)totalCount]];
                    [percentLabel setTextColor:[UIColor whiteColor]];
                    [outputTableView addSubview:percentLabel];
                }
                [avc setContentSize:CGSizeMake(outputView.frame.size.width, 100 + outputTableView.frame.origin.y + outputTableView.frame.size.height)];
            }
        }
    }
    else
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [chooseVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
            [chooseStratificationVariable setFrame:CGRectMake(10, 1000, inputView.frame.size.width - 20, 162)];
            [chooseVariable setHidden:NO];
            [chooseStratificationVariable setHidden:NO];
        }
        
        inputViewDisplayed = YES;
        for (UIView *v in [outputView subviews])
        {
            [v removeFromSuperview];
        }
        [avc resetContentSize];
        
        [avc putViewOnEpiInfoScrollView:self];
        [UIView animateWithDuration:0.3 animations:^{
            [self setFrame:CGRectMake(0, 50, avc.view.frame.size.width, avc.view.frame.size.height)];
        }];
    }
}

- (void)includeMissingButtonPressed
{
    if (includeMissing)
    {
        includeMissing = NO;
        [includeMissingButton setBackgroundColor:[UIColor whiteColor]];
        [includeMissingButton.layer setBorderColor:[UIColor colorWithRed:99/255.0 green:166/255.0 blue:223/255.0 alpha:1.0].CGColor];
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
    if ([pickerView tag] == 2)
    {
        NSString *variableForRow;
        availableStratificationVariables = [[NSMutableArray alloc] init];
        [availableStratificationVariables addObject:@""];
        for (NSString *variable in sqliteData.columnNamesWorking)
        {
            [availableStratificationVariables addObject:variable];
        }
        [availableStratificationVariables sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        variableForRow = [availableStratificationVariables objectAtIndex:row];
        return  variableForRow;
    }
    
    availableVariables = [[NSMutableArray alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [availableVariables addObject:@""];
    for (NSString *variable in sqliteData.columnNamesWorking)
    {
        [availableVariables addObject:variable];
    }
    [availableVariables sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return [availableVariables objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pickerView tag] == 2)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            selectedStratificationVariableNumber = [NSNumber numberWithInteger:row - 1];
        else
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
        return;
    }
    selectedVariableNumber = [NSNumber numberWithInteger:row];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [UIView animateWithDuration:0.3 animations:^{
            if (selectedVariableNumber.intValue == 0)
            {
                frequencyVariableChosen = NO;
                [chosenFrequencyVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
                [chosenFrequencyVariable setTitle:@"Select Frequency Variable" forState:UIControlStateNormal];
                return;
            }
            if (chooseVariable.frame.origin.y < 500)
            {
                float fontSize = 18.0;
                while ([[NSString stringWithFormat:@"Frequency Variable: %@", [availableVariables objectAtIndex:selectedVariableNumber.integerValue]] sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]}].width > chosenFrequencyVariable.frame.size.width - 10.0)
                    fontSize -= 0.1;
                frequencyVariableChosen = YES;
                [chosenFrequencyVariable.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:fontSize]];
                [chosenFrequencyVariable setTitle:[NSString stringWithFormat:@"Frequency Variable: %@", [availableVariables objectAtIndex:selectedVariableNumber.integerValue]] forState:UIControlStateNormal];
            }
        }];
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
