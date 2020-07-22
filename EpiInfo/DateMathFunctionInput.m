//
//  DateMathFunctionInput.m
//  EpiInfo
//
//  Created by John Copeland on 10/10/19.
//

#import "DateMathFunctionInput.h"
#import "NewVariablesView.h"

@implementation DateMathFunctionInput
- (void)setAVC:(UIViewController *)uivc
{
    [super setAVC:uivc];
    NSArray *unsortedVariableNames = [(AnalysisViewController *)avc getSQLiteColumnNames];
    NSDictionary *columnNames = [(AnalysisViewController *)avc getWorkingColumnNames];
    NSDictionary *isDate = [(AnalysisViewController *)avc getWorkingDates];
    NSMutableArray *variableNamesNSMA = [[NSMutableArray alloc] init];
    [variableNamesNSMA addObject:@""];
    for (NSString *variable in unsortedVariableNames)
    {
        NSNumber *isADate = [isDate objectForKey:[columnNames objectForKey:variable]];
        if ([isADate boolValue])
            [variableNamesNSMA addObject:variable];
    }
    [variableNamesNSMA sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [variableNamesNSMA insertObject:@"Today's Date" atIndex:1];
    [variableNamesNSMA insertObject:@"Literal Date" atIndex:1];
    [beginDateLVE setListOfValues:variableNamesNSMA];
    [endDateLVE setListOfValues:variableNamesNSMA];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        beginDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
        [beginDateLabel setText:@"Beginning Date:"];
        [beginDateLabel setBackgroundColor:[UIColor whiteColor]];
        [beginDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [beginDateLabel setTextAlignment:NSTextAlignmentLeft];
        [beginDateLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [self addSubview:beginDateLabel];
        beginDateLVE = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(0, 0, 2, 2) AndListOfValues:[[NSMutableArray alloc] init]];
        [beginDateLVE setTag:201];
        [beginDateLVE analysisStyle];
        [self addSubview:beginDateLVE];
        beginDateLiteral = [[DateField alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
        [beginDateLiteral setBorderStyle:UITextBorderStyleRoundedRect];
        [self addSubview:beginDateLiteral];
        [beginDateLiteral setIsEnabled:NO];

        endDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
        [endDateLabel setText:@"Ending Date:"];
        [endDateLabel setBackgroundColor:[UIColor whiteColor]];
        [endDateLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [endDateLabel setTextAlignment:NSTextAlignmentLeft];
        [endDateLabel setTextColor:[UIColor colorWithRed:59/255.0 green:106/255.0 blue:173/255.0 alpha:1.0]];
        [self addSubview:endDateLabel];
        endDateLVE = [[LegalValuesEnter alloc] initWithFrame:CGRectMake(0, 0, 2, 2) AndListOfValues:[[NSMutableArray alloc] init]];
        [endDateLVE setTag:202];
        [endDateLVE analysisStyle];
        [self addSubview:endDateLVE];
        endDateLiteral = [[DateField alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
        [endDateLiteral setBorderStyle:UITextBorderStyleRoundedRect];
        [self addSubview:endDateLiteral];
        [endDateLiteral setIsEnabled:NO];

        [UIView animateWithDuration:0.3 delay:0.0 options:nil animations:^{
            [self setFrame:frame];
        }completion:nil];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [beginDateLabel setFrame:CGRectMake(4, 36, frame.size.width - 8, 28)];
    [beginDateLVE setFrame:CGRectMake(4, 64, 300, 180)];
    [beginDateLiteral setFrame:CGRectMake(4, 128, 300, 40)];
    [endDateLabel setFrame:CGRectMake(4, 192, frame.size.width - 8, 28)];
    [endDateLVE setFrame:CGRectMake(4, 220, 300, 180)];
    [endDateLiteral setFrame:CGRectMake(4, 296, 300, 40)];
}

- (void)removeSelf:(UIButton *)sender
{
    [super removeSelf:sender];
    if ([[[sender titleLabel] text] isEqualToString:@"Save"])
    {
        NSString *dateMathFunction = [[[function text] componentsSeparatedByString:@" "] objectAtIndex:0];
        NSString *firstArgument = [beginDateLiteral text];
        if ([firstArgument length] == 0)
            firstArgument = [beginDateLVE epiInfoControlValue];
        NSString *secondArgument = [endDateLiteral text];
        if ([secondArgument length] == 0)
            secondArgument = [endDateLVE epiInfoControlValue];
        if ([firstArgument length] == 0 || [firstArgument isEqualToString:@"NULL"] || [firstArgument isEqualToString:@"Literal Date"] || [secondArgument length] == 0 || [secondArgument isEqualToString:@"NULL"] || [secondArgument isEqualToString:@"Literal Date"])
            return;
        NSString *functionWithArguments = [NSString stringWithFormat:@"%@ = %@(%@, %@) |~| %@", newVariableName, dateMathFunction, firstArgument, secondArgument, newVariableType];
        [listOfNewVariables addObject:functionWithArguments];
        [newVariableList reloadData];
        [(NewVariablesView *)[[[newVariableList superview] superview] superview] addToListOfAllVariables:newVariableName];
    }
    else
    {
    }
}

- (void)fieldResignedFirstResponder:(id)field
{
    if ([field tag] == 201)
    {
        if ([[(LegalValuesEnter *)field epiInfoControlValue] isEqualToString:@"Literal Date"])
        {
            [beginDateLiteral setIsEnabled:YES];
        }
        else if ([[(LegalValuesEnter *)field epiInfoControlValue] isEqualToString:@"Today's Date"])
        {
            [beginDateLiteral reset];
            [beginDateLiteral setIsEnabled:NO];
            NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
            [nsdf setDateFormat:@"MM/dd/yyyy"];
            BOOL dmy = ([[[[NSDate date] descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[[NSDate date] descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
            if (dmy)
                [nsdf setDateFormat:@"dd/MM/yyyy"];
            [beginDateLiteral setText:[nsdf stringFromDate:[NSDate date]]];
        }
        else
        {
            [beginDateLiteral reset];
            [beginDateLiteral setIsEnabled:NO];
        }
    }
    else if ([field tag] == 202)
    {
        if ([[(LegalValuesEnter *)field epiInfoControlValue] isEqualToString:@"Literal Date"])
        {
            [endDateLiteral setIsEnabled:YES];
        }
        else if ([[(LegalValuesEnter *)field epiInfoControlValue] isEqualToString:@"Today's Date"])
        {
            [endDateLiteral reset];
            [endDateLiteral setIsEnabled:NO];
            NSDateFormatter *nsdf = [[NSDateFormatter alloc] init];
            [nsdf setDateFormat:@"MM/dd/yyyy"];
            BOOL dmy = ([[[[NSDate date] descriptionWithLocale:[NSLocale currentLocale]] substringWithRange:NSMakeRange([[[NSDate date] descriptionWithLocale:[NSLocale currentLocale]] rangeOfString:@" "].location + 1, 1)] intValue] > 0);
            if (dmy)
                [nsdf setDateFormat:@"dd/MM/yyyy"];
            [endDateLiteral setText:[nsdf stringFromDate:[NSDate date]]];
        }
        else
        {
            [endDateLiteral reset];
            [endDateLiteral setIsEnabled:NO];
        }
    }
}
@end
