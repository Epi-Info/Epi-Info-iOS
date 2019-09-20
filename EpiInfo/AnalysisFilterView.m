//
//  AnalysisFilterView.m
//  EpiInfo
//
//  Created by John Copeland on 8/8/13.
//

#import "AnalysisFilterView.h"
#import "AnalysisViewController.h"

@implementation AnalysisFilterView
{
    AnalysisViewController *avc;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.size.width, frame.origin.y, frame.size.width, frame.size.height)];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //Add blueView and whiteView to create thin blue border line
        //Add all other views to whiteView
        UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, frame.size.width - 4, frame.size.height - 4)];
        [blueView setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [blueView.layer setCornerRadius:10.0];
        [self addSubview:blueView];
        UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, blueView.frame.size.width - 4, blueView.frame.size.height - 4)];
        [whiteView setBackgroundColor:[UIColor whiteColor]];
        [whiteView.layer setCornerRadius:8];
        [blueView addSubview:whiteView];
        
        UILabel *selectVariableLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 4, 256, 32)];
        [selectVariableLabel setText:@"Filter Variable:"];
        [selectVariableLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectVariableLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bolx" size:16.0]];
        [selectVariableLabel setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:selectVariableLabel];
        selectVariable = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 36, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectVariable setTag:3401];
        [selectVariable analysisStyle];
        [whiteView addSubview:selectVariable];
        
        UILabel *selectOperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 100, 256, 32)];
        [selectOperatorLabel setText:@"Operator:"];
        [selectOperatorLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectOperatorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bolx" size:16.0]];
        [selectOperatorLabel setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:selectOperatorLabel];
        selectOperator = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 132, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectOperator setTag:3402];
        [selectOperator analysisStyle];
        [whiteView addSubview:selectOperator];
        [selectOperator setIsEnabled:NO];
        
        UILabel *selectValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 204, 256, 32)];
        [selectValueLabel setText:@"Value:"];
        [selectValueLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [selectValueLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bolx" size:16.0]];
        [selectValueLabel setTextAlignment:NSTextAlignmentLeft];
        [whiteView addSubview:selectValueLabel];
        selectValue = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(4, 236, 300, 180) AndListOfValues:[[NSMutableArray alloc] init]];
        [selectValue setTag:3403];
        [selectValue analysisStyle];
        typeTextValue = [[EpiInfoTextField alloc] initWithFrame:CGRectMake(4, 236, 300, 180)];
        [typeTextValue setBorderStyle:UITextBorderStyleRoundedRect];
        [typeTextValue setDelegate:self];
        [typeTextValue setReturnKeyType:UIReturnKeyDone];
        [typeTextValue setTag:3403];
        typeNumberValue = [[NumberField alloc] initWithFrame:CGRectMake(4, 236, 300, 180)];
        [typeNumberValue setTag:3403];
        [whiteView addSubview:typeTextValue];
        [typeTextValue setIsEnabled:NO];

        float side = 40;
        UIButton *hideSelfButton = [[UIButton alloc] initWithFrame:CGRectMake(whiteView.frame.size.width - side - 4, whiteView.frame.size.height - side - 4, side, side)];
        [hideSelfButton setBackgroundColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [hideSelfButton.layer setCornerRadius:10];
        [hideSelfButton setTitle:@">>>" forState:UIControlStateNormal];
        [hideSelfButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [hideSelfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [hideSelfButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateHighlighted];
        [hideSelfButton addTarget:self action:@selector(hideSelf) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:hideSelfButton];
        
        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:frame];
        }completion:nil];
    }
    return self;
}

- (id)initWithViewController:(UIViewController *)vc
{
    self = [self initWithFrame:CGRectMake(0, 50, vc.view.frame.size.width, vc.view.frame.size.height - 50)];
    avc = (AnalysisViewController *)vc;
    
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
    [operatorsNSMA addObject:@"is missing"];
    [operatorsNSMA addObject:@"is not missing"];
    [operatorsNSMA addObject:@"equals"];
    [operatorsNSMA addObject:@"is not equal to"];
    [operatorsNSMA addObject:@"is less than"];
    [operatorsNSMA addObject:@"is less than or equal to"];
    [operatorsNSMA addObject:@"is greater than"];
    [operatorsNSMA addObject:@"is greater than or equal to"];
    [selectOperator setListOfValues:operatorsNSMA];

    return self;
}

- (void)hideSelf
{
    [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
        [self setFrame:CGRectMake(self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
    }completion:^(BOOL finished){[self removeSelfFromSuperview];}];
}

- (BOOL)removeSelfFromSuperview
{
    [self removeFromSuperview];
    return YES;
}

- (void)fieldResignedFirstResponder:(id)field
{
    if ([field tag] == 3401)
    {
        if ([[(LegalValuesEnter *)field selectedIndex] intValue] == variablesLVESelectedIndex)
            return;
        
        variablesLVESelectedIndex = [[(LegalValuesEnter *)field selectedIndex] intValue];
        [selectOperator reset];

        if ([[(LegalValuesEnter *)field selectedIndex] intValue] == 0)
        {
            [selectOperator setIsEnabled:NO];
            return;
        }
        
        NSString *selectedVariable = [(LegalValuesEnter *)field epiInfoControlValue];
//        int selectedVariableType = [[unsortedVariableTypes objectAtIndex:[unsortedVariableNames indexOfObject:selectedVariable]] intValue];
        NSNumber *indexNSN = (NSNumber *)[[avc getWorkingColumnNames] objectForKey:selectedVariable];
        NSNumber *isYesNo = (NSNumber *)[[avc getWorkingYesNo] objectForKey:indexNSN];
        if ([isYesNo boolValue])
        {
            NSMutableArray *operatorsNSMA = [[NSMutableArray alloc] init];
            [operatorsNSMA addObject:@""];
            [operatorsNSMA addObject:@"is missing"];
            [operatorsNSMA addObject:@"is not missing"];
            [operatorsNSMA addObject:@"equals"];
            [operatorsNSMA addObject:@"is not equal to"];
            [selectOperator setListOfValues:operatorsNSMA];
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
        }
        [selectOperator setIsEnabled:YES];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
//        [self setContentSize:CGSizeMake(self.contentSize.width, self.contentSize.height - 200.0)];
    } completion:^(BOOL finished){
//        hasAFirstResponder = NO;
    }];
    return YES;
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
