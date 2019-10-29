//
//  ConditionalAssignmentView.m
//  EpiInfo
//
//  Created by John Copeland on 10/28/19.
//

#import "ConditionalAssignmentView.h"
#import "AnalysisViewController.h"

@implementation ConditionalAssignmentView
{
    AnalysisViewController *avc;
}

- (void)setAnalysisViewController:(UIViewController *)uivc
{
    avc = (AnalysisViewController *)uivc;
    
    unsortedVariableNames = [avc getSQLiteColumnNames];
    unsortedVariableTypes = [avc getSQLiteColumnTypes];
    
    NSMutableArray *variableNamesNSMA = [[NSMutableArray alloc] init];
    [variableNamesNSMA addObject:@""];
    for (NSString *variable in unsortedVariableNames)
    {
        [variableNamesNSMA addObject:variable];
    }
    [variableNamesNSMA sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [selectVariable setListOfValues:variableNamesNSMA];
    variablesLVESelectedIndex = 0;
    
    NSMutableArray *operatorsNSMA = [[NSMutableArray alloc] init];
    [operatorsNSMA addObject:@""];
    [selectOperator setListOfValues:operatorsNSMA];
    
    NSMutableArray *valuesNSMA = [[NSMutableArray alloc] init];
    [valuesNSMA addObject:@""];
    [selectValue setListOfValues:valuesNSMA];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrameForSubclass:CGRectMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2.0, 4, 4)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //Add blueView (that isn't actually blue here and whiteView to create thin blue border line
        //Add all other views to whiteView
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 3, 3)];
        [blueView setBackgroundColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]];
        [self addSubview:blueView];
        UIScrollView *whiteView = [[UIScrollView alloc] initWithFrame:CGRectMake(2, 2, 2, 2)];
        [whiteView setBackgroundColor:[UIColor whiteColor]];
        [blueView addSubview:whiteView];

        UILabel *selectVariableLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 256, 28)];
        [selectVariableLabel setText:@"Filter Variable:"];
        [selectVariableLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [selectVariableLabel setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:selectVariableLabel];
        selectVariable = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 32, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectVariable setTag:3401];
        [selectVariable analysisStyle];
        [whiteView addSubview:selectVariable];
        
        UILabel *selectOperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 96, 256, 28)];
        [selectOperatorLabel setText:@"Operator:"];
        [selectOperatorLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectOperatorLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [selectOperatorLabel setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:selectOperatorLabel];
        selectOperator = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 124, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectOperator setTag:3402];
        [selectOperator analysisStyle];
        [whiteView addSubview:selectOperator];
        [selectOperator setIsEnabled:NO];
        
        UILabel *selectValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 188, 256, 28)];
        [selectValueLabel setText:@"Value:"];
        [selectValueLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [selectValueLabel setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:selectValueLabel];
        selectValue = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 216, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectValue setTag:3403];
        [selectValue analysisStyle];
        typeTextValue = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(4, 216, 300, 40)];
        [typeTextValue setBorderStyle:UITextBorderStyleRoundedRect];
        [typeTextValue setDelegate:self];
        [typeTextValue setReturnKeyType:UIReturnKeyDone];
        [typeTextValue setTag:3404];
        typeNumberValue = [[NumberField alloc] initWithFrame:CGRectMake(4, 216, 300, 40)];
        [typeNumberValue setBorderStyle:UITextBorderStyleRoundedRect];
        [typeNumberValue setDelegate:self];
        [typeNumberValue setReturnKeyType:UIReturnKeyDone];
        [typeNumberValue setTag:3405];
        [whiteView addSubview:typeTextValue];
        [typeTextValue setIsEnabled:NO];
        
        listOfValues = [[NSMutableArray alloc] init];
        [listOfValues addObject:@""];
        filterList = [[UITableView alloc] initWithFrame:CGRectMake(typeNumberValue.frame.origin.x, typeNumberValue.frame.origin.y + 2.0 * typeNumberValue.frame.size.height + 4.0, typeNumberValue.frame.size.width, 2.4 * typeNumberValue.frame.size.height)];
        [filterList setDelegate:self];
        [filterList setDataSource:self];
        [whiteView addSubview:filterList];

        float side = 40;
        UIButton *hideSelfButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - side - 4, self.frame.size.height - side - 4, 1, 1)];
        [hideSelfButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [hideSelfButton.layer setCornerRadius:2];
        [hideSelfButton setTitle:@">>>" forState:UIControlStateNormal];
        [hideSelfButton setAccessibilityLabel:@"Save filters and return to analysis screen"];
        [hideSelfButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [hideSelfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [hideSelfButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [hideSelfButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:hideSelfButton];
        
        addFilterButton = [[UIButton alloc] initWithFrame:CGRectMake(4, hideSelfButton.frame.origin.y, 2.5 * 1, 1)];
        [addFilterButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [addFilterButton.layer setCornerRadius:2];
        [addFilterButton setTitle:@"Add Filter" forState:UIControlStateNormal];
        [addFilterButton setAccessibilityLabel:@"Add, filter"];
        [addFilterButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14.0]];
        [addFilterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addFilterButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [addFilterButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:addFilterButton];
        [addFilterButton setEnabled:NO];
        [addFilterButton setAlpha:0.5];
        
        addWithAndButton = [[UIButton alloc] initWithFrame:addFilterButton.frame];
        [addWithAndButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [addWithAndButton.layer setCornerRadius:2];
        [addWithAndButton setTitle:@"Add With AND" forState:UIControlStateNormal];
        [addWithAndButton setAccessibilityLabel:@"Add, with, and"];
        [addWithAndButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [addWithAndButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addWithAndButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [addWithAndButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
        [addWithAndButton setEnabled:NO];
        [addWithAndButton setAlpha:0.5];

        addWithOrButton = [[UIButton alloc] initWithFrame:CGRectMake(4 + 2.5 * side + 2, hideSelfButton.frame.origin.y, 2.5 * side, side)];
        [addWithOrButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [addWithOrButton.layer setCornerRadius:2];
        [addWithOrButton setTitle:@"Add With OR" forState:UIControlStateNormal];
        [addWithOrButton setAccessibilityLabel:@"Add, with, or"];
        [addWithOrButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [addWithOrButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addWithOrButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [addWithOrButton addTarget:self action:@selector(addFilter:) forControlEvents:UIControlEventTouchUpInside];
        [addWithOrButton setEnabled:NO];
        [addWithOrButton setAlpha:0.5];

        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:frame];
            [blueView setFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
            [whiteView setFrame:CGRectMake(2, 2, blueView.frame.size.width - 4, blueView.frame.size.height - 4)];
            [hideSelfButton setFrame:CGRectMake(self.frame.size.width - side - 4, self.frame.size.height - side - 4, side, side)];
            [addFilterButton setFrame:CGRectMake(4, hideSelfButton.frame.origin.y, 2.5 * side, side)];
            [addWithAndButton setFrame:addFilterButton.frame];
            [addWithOrButton setFrame:CGRectMake(4 + 2.5 * side + 2, hideSelfButton.frame.origin.y, 2.5 * side, side)];
        }completion:nil];
    }
    return self;
}

- (void)fieldResignedFirstResponder:(id)field
{
    if ([field tag] == 3401)
    {
        if ([[(LegalValuesEnter *)field selectedIndex] intValue] == variablesLVESelectedIndex)
            return;
        
        variablesLVESelectedIndex = [[(LegalValuesEnter *)field selectedIndex] intValue];
        [selectOperator reset];
        [selectValue reset];
        [typeNumberValue reset];
        [selectValue setIsEnabled:NO];
        [typeNumberValue setIsEnabled:NO];
        [selectValue removeFromSuperview];
        [typeNumberValue removeFromSuperview];
        [[selectVariable superview] addSubview:typeTextValue];
        [addFilterButton setEnabled:NO];
        [addFilterButton setAlpha:0.5];
        [addWithAndButton setEnabled:NO];
        [addWithAndButton setAlpha:0.5];
        [addWithOrButton setEnabled:NO];
        [addWithOrButton setAlpha:0.5];

        if ([[(LegalValuesEnter *)field selectedIndex] intValue] == 0)
        {
            [selectOperator setIsEnabled:NO];
            return;
        }
        
        NSString *selectedVariable = [(LegalValuesEnter *)field epiInfoControlValue];
//        int selectedVariableType = [[unsortedVariableTypes objectAtIndex:[unsortedVariableNames indexOfObject:selectedVariable]] intValue];
        NSNumber *indexNSN = (NSNumber *)[[avc getWorkingColumnNames] objectForKey:selectedVariable];
        NSNumber *isYesNo = (NSNumber *)[[avc getWorkingYesNo] objectForKey:indexNSN];
        NSNumber *isBinary = (NSNumber *)[[avc getWorkingBinary] objectForKey:indexNSN];
        NSNumber *isOneZero = (NSNumber *)[[avc getWorkingOneZero] objectForKey:indexNSN];
        NSNumber *isTrueFalse = (NSNumber *)[[avc getWorkingTrueFalse] objectForKey:indexNSN];
        NSNumber *columnType = (NSNumber *)[[avc getWorkingColumnTypes] objectForKey:indexNSN];
        if ([columnType intValue] == 2 || [isYesNo boolValue] || [isOneZero boolValue] || [isTrueFalse boolValue] || [isBinary boolValue])
        {
            NSMutableArray *operatorsNSMA = [[NSMutableArray alloc] init];
            [operatorsNSMA addObject:@""];
            [operatorsNSMA addObject:@"is missing"];
            [operatorsNSMA addObject:@"is not missing"];
            [operatorsNSMA addObject:@"equals"];
            [operatorsNSMA addObject:@"is not equal to"];
            [selectOperator setListOfValues:operatorsNSMA];
            [typeTextValue removeFromSuperview];
            [typeNumberValue removeFromSuperview];
            [[selectVariable superview] addSubview:selectValue];
            
            FrequencyObject *fo = [avc getFrequencyObjectForVariable:selectedVariable];
            NSMutableArray *valuesNSMA = [NSMutableArray arrayWithArray:fo.variableValues];
            [valuesNSMA insertObject:@"" atIndex:0];
            [selectValue setListOfValues:valuesNSMA];
        }
        else
        {
            NSMutableArray *operatorsNSMA = [[NSMutableArray alloc] init];
            [operatorsNSMA addObject:@""];
            [operatorsNSMA addObject:@"is missing"];
            [operatorsNSMA addObject:@"is not missing"];
            [operatorsNSMA addObject:@"equals"];
            [operatorsNSMA addObject:@"is not equal to"];
            [operatorsNSMA addObject:@"is less than"];
            [operatorsNSMA addObject:@"is less than or equal to"];
            [operatorsNSMA addObject:@"is greater than"];
            [operatorsNSMA addObject:@"is greater than or equal to"];
            [selectOperator setListOfValues:operatorsNSMA];
            [typeTextValue removeFromSuperview];
            [selectValue removeFromSuperview];
            [[selectVariable superview] addSubview:typeNumberValue];
        }
        [selectOperator setIsEnabled:YES];
    }
    else if ([field tag] == 3402)
    {
        NSString *selectedOperator = [(LegalValuesEnter *)field epiInfoControlValue];
        if ([selectedOperator containsString:@"missing"] || [selectedOperator length] == 0 || [selectedOperator isEqualToString:@"NULL"])
        {
            [selectValue reset];
            [typeNumberValue reset];
            [selectValue setIsEnabled:NO];
            [typeNumberValue setIsEnabled:NO];
            if ([selectedOperator containsString:@"missing"])
            {
                [addFilterButton setEnabled:YES];
                [addFilterButton setAlpha:1.0];
                [addWithAndButton setEnabled:YES];
                [addWithAndButton setAlpha:1.0];
                [addWithOrButton setEnabled:YES];
                [addWithOrButton setAlpha:1.0];
            }
            else
            {
                [addFilterButton setEnabled:NO];
                [addFilterButton setAlpha:0.5];
                [addWithAndButton setEnabled:NO];
                [addWithAndButton setAlpha:0.5];
                [addWithOrButton setEnabled:NO];
                [addWithOrButton setAlpha:0.5];
            }
        }
        else
        {
            [selectValue reset];
            [typeNumberValue reset];
            [selectValue setIsEnabled:YES];
            [typeNumberValue setIsEnabled:YES];
            [addFilterButton setEnabled:NO];
            [addFilterButton setAlpha:0.5];
            [addWithAndButton setEnabled:NO];
            [addWithAndButton setAlpha:0.5];
            [addWithOrButton setEnabled:NO];
            [addWithOrButton setAlpha:0.5];
        }
    }
    else if ([field tag] > 3402)
    {
        [addFilterButton setEnabled:YES];
        [addFilterButton setAlpha:1.0];
        [addWithAndButton setEnabled:YES];
        [addWithAndButton setAlpha:1.0];
        [addWithOrButton setEnabled:YES];
        [addWithOrButton setAlpha:1.0];
        if ([field tag] > 3403)
        {
            if ([[[(UITextField *)field text] stringByReplacingOccurrencesOfString:@"." withString:@""] length] == 0)
            {
                [addFilterButton setEnabled:NO];
                [addFilterButton setAlpha:0.5];
                [addWithAndButton setEnabled:NO];
                [addWithAndButton setAlpha:0.5];
                [addWithOrButton setEnabled:NO];
                [addWithOrButton setAlpha:0.5];
            }
        }
    }
}

@end
