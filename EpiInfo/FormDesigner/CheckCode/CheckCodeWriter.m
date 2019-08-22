//
//  CheckCodeWriter.m
//  EpiInfo
//
//  Created by John Copeland on 4/29/19.
//

#import "CheckCodeWriter.h"
#import "Years.h"
#import "Months.h"
#import "Days.h"
#import "EnableDisableClear.h"
#import "Enable.h"


@implementation CheckCodeWriter

- (NSString *)beginFieldString
{
    return beginFieldString;
}
- (void)setBeginFieldString:(NSString *)bfs
{
    beginFieldString = bfs;
}

- (NSString *)endFieldString
{
    return endFieldString;
}
- (void)setEndFieldString:(NSString *)efs
{
    endFieldString = efs;
}

- (void)setFormDesignerCheckCodeStrings:(NSMutableArray *)fdccs
{
    formDesignerCheckCodeStrings = fdccs;
}

- (void)setDeletedIfBlocks:(NSMutableArray *)dib
{
    deletedIfBlocks = dib;
}

- (NSMutableArray *)beforeFunctions
{
    return beforeFunctions;
}

- (NSMutableArray *)afterFunctions
{
    return afterFunctions;
}

- (NSMutableArray *)clickFunctions
{
    return clickFunctions;
}

- (void)addAfterFunction:(NSString *)function
{
    NSString *fixedFunction = [[[[[[[function stringByReplacingOccurrencesOfString:@" & " withString:@" &amp; "]
                                    stringByReplacingOccurrencesOfString:@"\t" withString:@"&#x9;"]
                                   stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]
                                  stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
                                 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]
                                stringByReplacingOccurrencesOfString:@"\r" withString:@"&#xD;"]
                               stringByReplacingOccurrencesOfString:@"\n" withString:@"&#xA;"];
    if (![afterFunctions containsObject:fixedFunction])
        [afterFunctions addObject:fixedFunction];
}
- (void)addBeforeFunction:(NSString *)function
{
    NSString *fixedFunction = [[[[[[[function stringByReplacingOccurrencesOfString:@" & " withString:@" &amp; "]
                                    stringByReplacingOccurrencesOfString:@"\t" withString:@"&#x9;"]
                                   stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]
                                  stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
                                 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]
                                stringByReplacingOccurrencesOfString:@"\r" withString:@"&#xD;"]
                               stringByReplacingOccurrencesOfString:@"\n" withString:@"&#xA;"];
    if (![beforeFunctions containsObject:fixedFunction])
        [beforeFunctions addObject:fixedFunction];
}
- (void)addClickFunction:(NSString *)function
{
    NSString *fixedFunction = [[[[[[[function stringByReplacingOccurrencesOfString:@" & " withString:@" &amp; "]
                                    stringByReplacingOccurrencesOfString:@"\t" withString:@"&#x9;"]
                                   stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]
                                  stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
                                 stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]
                                stringByReplacingOccurrencesOfString:@"\r" withString:@"&#xD;"]
                               stringByReplacingOccurrencesOfString:@"\n" withString:@"&#xA;"];
    if (![clickFunctions containsObject:fixedFunction])
        [clickFunctions addObject:fixedFunction];
}

- (id)initWithFrame:(CGRect)frame AndFieldName:(nonnull NSString *)fn AndFieldType:(nonnull NSString *)ft AndSenderSuperview:(nonnull UIView *)sv
{
    self = [super initWithFrame:frame];
    if (self)
    {
        senderSuperview = sv;
        beginFieldString = [NSString stringWithFormat:@"Field %@", fn];
        endFieldString = @"&#xA;End-Field";
        beforeFunctions = [[NSMutableArray alloc] init];
        afterFunctions = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 32)];
        [firstLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [firstLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [firstLabel setTextAlignment:NSTextAlignmentCenter];
        [firstLabel setText:@"Check Code Builder"];
        [self addSubview:firstLabel];
        
        secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, frame.size.width / 2.0 - 4, 32)];
        [secondLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [secondLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [secondLabel setTextAlignment:NSTextAlignmentRight];
        [secondLabel setText:@"Field Name:"];
        [self addSubview:secondLabel];
        
        thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 + 4, 32, frame.size.width / 2.0 - 4, 32)];
        [thirdLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [thirdLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [thirdLabel setTextAlignment:NSTextAlignmentLeft];
        [thirdLabel setText:[NSString stringWithFormat:@"%@", fn]];
        [self addSubview:thirdLabel];

        fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, frame.size.width / 2.0 - 4, 32)];
        [fourthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [fourthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [fourthLabel setTextAlignment:NSTextAlignmentRight];
        [fourthLabel setText:@"Field Type:"];
        [self addSubview:fourthLabel];
        
        fifthLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 + 4, 64, frame.size.width / 2.0 - 4, 32)];
        [fifthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [fifthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [fifthLabel setTextAlignment:NSTextAlignmentLeft];
        [fifthLabel setText:[NSString stringWithFormat:@"%@", ft]];
        [self addSubview:fifthLabel];

        sixthLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 96, frame.size.width - 16, 32)];
        [sixthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [sixthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [sixthLabel setTextAlignment:NSTextAlignmentLeft];
        [sixthLabel setText:@"Select when execution will occur:"];
        [self addSubview:sixthLabel];

        beforeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 128, frame.size.width / 2.0, 32)];
        [beforeButton setBackgroundColor:[UIColor whiteColor]];
        [beforeButton setTitle:@"Before" forState:UIControlStateNormal];
        [beforeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [beforeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [beforeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [beforeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [beforeButton.layer setValue:fn forKey:@"FieldName"];
        [beforeButton.layer setValue:ft forKey:@"FieldType"];
        [beforeButton addTarget:self action:@selector(beforeOrAfterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [beforeButton setEnabled:NO];
        [self addSubview:beforeButton];
        
        afterButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 128, frame.size.width / 2.0, 32)];
        [afterButton setBackgroundColor:[UIColor whiteColor]];
        [afterButton setTitle:@"After" forState:UIControlStateNormal];
        [afterButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [afterButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [afterButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [afterButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [afterButton.layer setValue:fn forKey:@"FieldName"];
        [afterButton.layer setValue:ft forKey:@"FieldType"];
        [afterButton addTarget:self action:@selector(beforeOrAfterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:afterButton];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, frame.size.height - 48.0, frame.size.width / 2.0, 32)];
        [closeButton setBackgroundColor:[UIColor whiteColor]];
        [closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
        [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
        [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
        
        if ([[sv.layer valueForKey:@"CheckCode"] length] > 0)
        {
            NSString *rawCheckCode = [NSString stringWithString:[sv.layer valueForKey:@"CheckCode"]];
            [self.layer setValue:[sv.layer valueForKey:@"CheckCode"] forKey:@"CheckCode"];
            NSString *afterString = @"";
            int afterLocation = (int)[[rawCheckCode lowercaseString] rangeOfString:@"after"].location;
            int endAfterEndLocation = -1;
            if (afterLocation > 0)
            {
                endAfterEndLocation = (int)[[[rawCheckCode lowercaseString] substringFromIndex:afterLocation] rangeOfString:@"end-after"].location + 9;
                if (endAfterEndLocation > 0)
                {
                    afterString = [rawCheckCode substringWithRange:NSMakeRange(afterLocation, endAfterEndLocation)];
                    rawCheckCode = [rawCheckCode stringByReplacingCharactersInRange:NSMakeRange(afterLocation, endAfterEndLocation) withString:@""];
                }
            }
            
            if ([afterString length] > 0)
            {
                while ([[afterString lowercaseString] containsString:@"&#x9;if "])
                {
                    int ifLocation = (int)[[afterString lowercaseString] rangeOfString:@"&#x9;if "].location + 5;
                    int lineFeedLocation = (int)[[[afterString lowercaseString] substringFromIndex:ifLocation] rangeOfString:@"end-if&#xa;"].location + 6;
                    [afterFunctions addObject:[afterString substringWithRange:NSMakeRange(ifLocation, lineFeedLocation)]];
                    afterString = [afterString stringByReplacingCharactersInRange:NSMakeRange(ifLocation, lineFeedLocation) withString:@""];
                }
                while ([[afterString lowercaseString] containsString:@"&#x9;assign "])
                {
                    int assignLocation = (int)[[afterString lowercaseString] rangeOfString:@"&#x9;assign "].location + 5;
                    int lineFeedLocation = (int)[[[afterString lowercaseString] substringFromIndex:assignLocation] rangeOfString:@"&#xa;"].location;
                    [afterFunctions addObject:[afterString substringWithRange:NSMakeRange(assignLocation, lineFeedLocation)]];
                    afterString = [afterString stringByReplacingCharactersInRange:NSMakeRange(assignLocation, lineFeedLocation) withString:@""];
                }
                while ([[afterString lowercaseString] containsString:@"&#x9;clear "])
                {
                    int assignLocation = (int)[[afterString lowercaseString] rangeOfString:@"&#x9;clear "].location + 5;
                    int lineFeedLocation = (int)[[[afterString lowercaseString] substringFromIndex:assignLocation] rangeOfString:@"&#xa;"].location;
                    [afterFunctions addObject:[afterString substringWithRange:NSMakeRange(assignLocation, lineFeedLocation)]];
                    afterString = [afterString stringByReplacingCharactersInRange:NSMakeRange(assignLocation, lineFeedLocation) withString:@""];
                }
                while ([[afterString lowercaseString] containsString:@"&#x9;enable "])
                {
                    int assignLocation = (int)[[afterString lowercaseString] rangeOfString:@"&#x9;enable "].location + 5;
                    int lineFeedLocation = (int)[[[afterString lowercaseString] substringFromIndex:assignLocation] rangeOfString:@"&#xa;"].location;
                    [afterFunctions addObject:[afterString substringWithRange:NSMakeRange(assignLocation, lineFeedLocation)]];
                    afterString = [afterString stringByReplacingCharactersInRange:NSMakeRange(assignLocation, lineFeedLocation) withString:@""];
                }
                while ([[afterString lowercaseString] containsString:@"&#x9;disable "])
                {
                    int assignLocation = (int)[[afterString lowercaseString] rangeOfString:@"&#x9;disable "].location + 5;
                    int lineFeedLocation = (int)[[[afterString lowercaseString] substringFromIndex:assignLocation] rangeOfString:@"&#xa;"].location;
                    [afterFunctions addObject:[afterString substringWithRange:NSMakeRange(assignLocation, lineFeedLocation)]];
                    afterString = [afterString stringByReplacingCharactersInRange:NSMakeRange(assignLocation, lineFeedLocation) withString:@""];
                }
            }
        }
    }
    return self;
}

- (void)beforeOrAfterButtonPressed:(UIButton *)sender
{
    for (int i = 0; i < [formDesignerCheckCodeStrings count]; i++)
    {
        NSLog(@"Checking checkCodeStrings object for %@", [sender.layer valueForKey:@"FieldName"]);
        if ([[[[formDesignerCheckCodeStrings objectAtIndex:i] componentsSeparatedByString:@" "] objectAtIndex:1] containsString:[sender.layer valueForKey:@"FieldName"]])
        {
            [self.layer setValue:[formDesignerCheckCodeStrings objectAtIndex:i] forKey:@"CheckCode"];
            [formDesignerCheckCodeStrings removeObjectAtIndex:i];
            break;
        }
    }
    if ([[self.layer valueForKey:@"CheckCode"] length] > 0)
    {
        NSString *rawCheckCode = [NSString stringWithString:[self.layer valueForKey:@"CheckCode"]];
        NSString *beforeString = @"";
        int beforeLocation = (int)[[rawCheckCode lowercaseString] rangeOfString:@"before"].location;
        int endBeforeEndLocation = -1;
        if (beforeLocation != NSNotFound)
        {
            endBeforeEndLocation = (int)[[[rawCheckCode lowercaseString] substringFromIndex:beforeLocation] rangeOfString:@"end-before"].location + 10;
            if (endBeforeEndLocation > 0)
            {
                beforeString = [rawCheckCode substringWithRange:NSMakeRange(beforeLocation, endBeforeEndLocation)];
                rawCheckCode = [rawCheckCode stringByReplacingCharactersInRange:NSMakeRange(beforeLocation, endBeforeEndLocation) withString:@""];
            }
        }
        
        if ([beforeString length] > 0)
        {
            while ([[beforeString lowercaseString] containsString:@"&#x9;if "])
            {
                int ifLocation = (int)[[beforeString lowercaseString] rangeOfString:@"&#x9;if "].location + 5;
                int lineFeedLocation = (int)[[[beforeString lowercaseString] substringFromIndex:ifLocation] rangeOfString:@"end-if&#xa;"].location + 6;
                [beforeFunctions addObject:[beforeString substringWithRange:NSMakeRange(ifLocation, lineFeedLocation)]];
                beforeString = [beforeString stringByReplacingCharactersInRange:NSMakeRange(ifLocation, lineFeedLocation) withString:@""];
            }
        }
    }
    
    UIView *selectFunctionView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height)];
    [selectFunctionView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:selectFunctionView];
    
    UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 32)];
    [firstLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
    [firstLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [firstLabel setTextAlignment:NSTextAlignmentCenter];
    [firstLabel setText:@"Check Code Builder"];
    [selectFunctionView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, self.frame.size.width / 2.0 - 4, 32)];
    [secondLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [secondLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [secondLabel setTextAlignment:NSTextAlignmentRight];
    [secondLabel setText:@"Field Name:"];
    [selectFunctionView addSubview:secondLabel];
    
    UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 + 4, 32, self.frame.size.width / 2.0 - 4, 32)];
    [thirdLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [thirdLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [thirdLabel setTextAlignment:NSTextAlignmentLeft];
    [thirdLabel setText:[sender.layer valueForKey:@"FieldName"]];
    [selectFunctionView addSubview:thirdLabel];
    
    UILabel *fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.frame.size.width / 2.0 - 4, 32)];
    [fourthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [fourthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [fourthLabel setTextAlignment:NSTextAlignmentRight];
    [fourthLabel setText:@"Field Type:"];
    [selectFunctionView addSubview:fourthLabel];
    
    UILabel *fifthLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2.0 + 4, 64, self.frame.size.width / 2.0 - 4, 32)];
    [fifthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
    [fifthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [fifthLabel setTextAlignment:NSTextAlignmentLeft];
    [fifthLabel setText:[sender.layer valueForKey:@"FieldType"]];
    [selectFunctionView addSubview:fifthLabel];
    
    if ([[[sender titleLabel] text] isEqualToString:@"After"])
    {
        if ([[sender.layer valueForKey:@"FieldType"] isEqualToString:@"Date"])
        {
            UILabel *sixthLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 96, self.frame.size.width - 16, 32)];
            [sixthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [sixthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [sixthLabel setTextAlignment:NSTextAlignmentLeft];
            [sixthLabel setText:[NSString stringWithFormat:@"Select a function to execute %@:", [[sender titleLabel] text]]];
            [selectFunctionView addSubview:sixthLabel];
            
            UIButton *differenceInYearsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 128, selectFunctionView.frame.size.width / 2.0, 32)];
            [differenceInYearsButton setBackgroundColor:[UIColor whiteColor]];
            [differenceInYearsButton setTitle:@"Years" forState:UIControlStateNormal];
            [differenceInYearsButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [differenceInYearsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [differenceInYearsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [differenceInYearsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [differenceInYearsButton addTarget:self action:@selector(functionSelectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [differenceInYearsButton.layer setValue:@"After" forKey:@"BeforeAfter"];
            [selectFunctionView addSubview:differenceInYearsButton];
            
            UIButton *differenceInMonthsButton = [[UIButton alloc] initWithFrame:CGRectMake(selectFunctionView.frame.size.width / 2.0, 128, selectFunctionView.frame.size.width / 2.0, 32)];
            [differenceInMonthsButton setBackgroundColor:[UIColor whiteColor]];
            [differenceInMonthsButton setTitle:@"Months" forState:UIControlStateNormal];
            [differenceInMonthsButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [differenceInMonthsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [differenceInMonthsButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [differenceInMonthsButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [differenceInMonthsButton addTarget:self action:@selector(functionSelectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [differenceInMonthsButton.layer setValue:@"After" forKey:@"BeforeAfter"];
            [selectFunctionView addSubview:differenceInMonthsButton];
            
            UIButton *differenceInDaysButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 160, selectFunctionView.frame.size.width / 2.0, 32)];
            [differenceInDaysButton setBackgroundColor:[UIColor whiteColor]];
            [differenceInDaysButton setTitle:@"Days" forState:UIControlStateNormal];
            [differenceInDaysButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [differenceInDaysButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [differenceInDaysButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [differenceInDaysButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [differenceInDaysButton addTarget:self action:@selector(functionSelectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [differenceInDaysButton.layer setValue:@"After" forKey:@"BeforeAfter"];
            [selectFunctionView addSubview:differenceInDaysButton];
            
            UILabel *ifButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 200, self.frame.size.width - 16, 32)];
            [ifButtonLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [ifButtonLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [ifButtonLabel setTextAlignment:NSTextAlignmentLeft];
            [ifButtonLabel setText:[NSString stringWithFormat:@"Build IF statement to evaluate %@:", [[sender titleLabel] text]]];
            [selectFunctionView addSubview:ifButtonLabel];

            UIButton *ifButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 232, selectFunctionView.frame.size.width, 32)];
            [ifButton setBackgroundColor:[UIColor whiteColor]];
            [ifButton setTitle:@"IF-THEN-ELSE Statement" forState:UIControlStateNormal];
            [ifButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [ifButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [ifButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [ifButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [ifButton addTarget:self action:@selector(ifButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [ifButton.layer setValue:@"After" forKey:@"BeforeAfter"];
            [selectFunctionView addSubview:ifButton];
        }
        else
        {
            UILabel *ifButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 96, self.frame.size.width - 16, 32)];
            [ifButtonLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [ifButtonLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
            [ifButtonLabel setTextAlignment:NSTextAlignmentLeft];
            [ifButtonLabel setText:[NSString stringWithFormat:@"Build IF statement to evaluate %@:", [[sender titleLabel] text]]];
            [selectFunctionView addSubview:ifButtonLabel];
            
            UIButton *ifButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 128, selectFunctionView.frame.size.width, 32)];
            [ifButton setBackgroundColor:[UIColor whiteColor]];
            [ifButton setTitle:@"IF-THEN-ELSE Statement" forState:UIControlStateNormal];
            [ifButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [ifButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [ifButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [ifButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [ifButton addTarget:self action:@selector(ifButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [ifButton.layer setValue:@"After" forKey:@"BeforeAfter"];
            [selectFunctionView addSubview:ifButton];
        }
    }
    else
    {
        if ([[sender.layer valueForKey:@"FieldType"] isEqualToString:@"Page"])
        {
            UIButton *enableButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 128, selectFunctionView.frame.size.width / 2.0, 32)];
            [enableButton setBackgroundColor:[UIColor whiteColor]];
            [enableButton setTitle:@"Enable" forState:UIControlStateNormal];
            [enableButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [enableButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [enableButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [enableButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [enableButton addTarget:self action:@selector(functionSelectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [enableButton.layer setValue:@"Before" forKey:@"BeforeAfter"];
            [selectFunctionView addSubview:enableButton];

            UIButton *disableButton = [[UIButton alloc] initWithFrame:CGRectMake(selectFunctionView.frame.size.width / 2.0, 128, selectFunctionView.frame.size.width / 2.0, 32)];
            [disableButton setBackgroundColor:[UIColor whiteColor]];
            [disableButton setTitle:@"Disable" forState:UIControlStateNormal];
            [disableButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [disableButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [disableButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [disableButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [disableButton addTarget:self action:@selector(functionSelectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [disableButton.layer setValue:@"Before" forKey:@"BeforeAfter"];
            [selectFunctionView addSubview:disableButton];

            UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 160, selectFunctionView.frame.size.width / 2.0, 32)];
            [clearButton setBackgroundColor:[UIColor whiteColor]];
            [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
            [clearButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
            [clearButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
            [clearButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
            [clearButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
            [clearButton addTarget:self action:@selector(functionSelectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [clearButton.layer setValue:@"Before" forKey:@"BeforeAfter"];
            [selectFunctionView addSubview:clearButton];
        }
    }
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(selectFunctionView.frame.size.width / 2.0, selectFunctionView.frame.size.height - 48, selectFunctionView.frame.size.width / 2.0, 32)];
    [closeButton setBackgroundColor:[UIColor whiteColor]];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [closeButton setTitleColor:[UIColor colorWithRed:188/255.0 green:190/255.0 blue:192/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [closeButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [closeButton addTarget:self action:@selector(closeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [selectFunctionView addSubview:closeButton];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [selectFunctionView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

- (void)functionSelectionButtonPressed:(UIButton *)sender
{
    UIView *span = [[UIView alloc] init];
    if ([[[sender titleLabel] text] isEqualToString:@"Years"])
    {
        span = [[Years alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                               -[sender superview].frame.size.height,
                                                               [sender superview].frame.size.width,
                                                               [sender superview].frame.size.height)
                        AndCallingButton:sender];
        [[sender superview] addSubview:span];
    }
    if ([[[sender titleLabel] text] isEqualToString:@"Months"])
    {
        span = [[Months alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                               -[sender superview].frame.size.height,
                                                               [sender superview].frame.size.width,
                                                               [sender superview].frame.size.height)
                                   AndCallingButton:sender];
        [[sender superview] addSubview:span];
    }
    if ([[[sender titleLabel] text] isEqualToString:@"Days"])
    {
        span = [[Days alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                               -[sender superview].frame.size.height,
                                                               [sender superview].frame.size.width,
                                                               [sender superview].frame.size.height)
                                   AndCallingButton:sender];
        [[sender superview] addSubview:span];
    }
    if ([[[sender titleLabel] text] isEqualToString:@"Enable"])
    {
        span = [[Enable alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                      -[sender superview].frame.size.height,
                                                      [sender superview].frame.size.width,
                                                      [sender superview].frame.size.height)
                          AndCallingButton:sender];
        [[sender superview] addSubview:span];
    }
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [span setFrame:CGRectMake(0, 0, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
    }];
    {
//       NSLog(@"%@", [[sender titleLabel] text]);
//       if ([[sender.layer valueForKey:@"BeforeAfter"] isEqualToString:@"Before"])
//       {
//       }
//       if ([[sender.layer valueForKey:@"BeforeAfter"] isEqualToString:@"After"])
//       {
//            if (![afterFunctions containsObject:[[sender titleLabel] text]])
//                [afterFunctions addObject:[[sender titleLabel] text]];
//        }
    }
}

- (void)closeButtonPressed:(UIButton *)sender
{
    if ([sender superview] == self)
    {
        NSMutableString *checkCodeMutableString = [[NSMutableString alloc] init];
        if ([beforeFunctions count] > 0 || [afterFunctions count] > 0)
        {
            [checkCodeMutableString appendString:beginFieldString];
            if ([beforeFunctions count] > 0)
            {
                [checkCodeMutableString appendString:@"&#xA;&#x9;Before"];
                for (int i = 0; i < [beforeFunctions count]; i++)
                {
                    [checkCodeMutableString appendFormat:@"&#xA;&#x9;&#x9;%@", [beforeFunctions objectAtIndex:i]];
                }
                [checkCodeMutableString appendString:@"&#xA;&#x9;End-Before"];
            }
            if ([afterFunctions count] > 0)
            {
                [checkCodeMutableString appendString:@"&#xA;&#x9;After"];
                for (int i = 0; i < [afterFunctions count]; i++)
                {
                    [checkCodeMutableString appendFormat:@"&#xA;&#x9;&#x9;%@", [afterFunctions objectAtIndex:i]];
                }
                [checkCodeMutableString appendString:@"&#xA;&#x9;End-After"];
            }
            [checkCodeMutableString appendString:endFieldString];
            [senderSuperview.layer setValue:[NSString stringWithString:checkCodeMutableString] forKey:@"CheckCode"];
        }
    }
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [[sender superview] setFrame:CGRectMake([sender superview].frame.origin.x, -[sender superview].frame.size.height, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
        [[sender superview] removeFromSuperview];
    }];
}

- (void)ifButtonPressed:(UIButton *)sender
{
    UIView *span = [[UIView alloc] init];
    span = [[IfBuilder alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                       -[sender superview].frame.size.height,
                                                       [sender superview].frame.size.width,
                                                       [sender superview].frame.size.height)
                           AndCallingButton:sender];
    [(IfBuilder *)span setFormDesignerCheckCodeStrings:formDesignerCheckCodeStrings];
    if (!deletedIfBlocks)
        deletedIfBlocks = [[NSMutableArray alloc] init];
    [(IfBuilder *)span setDeletedIfBlocks:deletedIfBlocks];
    [[sender superview] addSubview:span];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [span setFrame:CGRectMake(0, 0, [sender superview].frame.size.width, [sender superview].frame.size.height)];
    } completion:^(BOOL finished){
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
