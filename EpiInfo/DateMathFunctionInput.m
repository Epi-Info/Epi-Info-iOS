//
//  DateMathFunctionInput.m
//  EpiInfo
//
//  Created by John Copeland on 10/10/19.
//

#import "DateMathFunctionInput.h"

@implementation DateMathFunctionInput
- (void)setAVC:(UIViewController *)uivc
{
    [super setAVC:uivc];
    NSArray *unsortedVariableNames = [(AnalysisViewController *)avc getSQLiteColumnNames];
    NSDictionary *columnNames = [(AnalysisViewController *)avc getWorkingColumnNames];
    NSDictionary *isDate = [(AnalysisViewController *)avc getWorkingDates];
    NSMutableArray *variableNamesNSMA = [[NSMutableArray alloc] init];
    [variableNamesNSMA addObject:@""];
    [variableNamesNSMA addObject:@"Literal Date"];
    [variableNamesNSMA addObject:@"Today's Date"];
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
        NSLog(@"Save button pressed");
    }
    else
    {
        NSLog(@"Cancel button pressed");
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
        else
        {
            [endDateLiteral reset];
            [endDateLiteral setIsEnabled:NO];
        }
    }
}
@end
