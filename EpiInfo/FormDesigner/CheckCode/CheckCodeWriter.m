//
//  CheckCodeWriter.m
//  EpiInfo
//
//  Created by John Copeland on 4/29/19.
//

#import "CheckCodeWriter.h"
#import "Years.h"

@implementation CheckCodeWriter

- (id)initWithFrame:(CGRect)frame AndFieldName:(nonnull NSString *)fn AndFieldType:(nonnull NSString *)ft AndSenderSuperview:(nonnull UIView *)sv
{
    self = [super initWithFrame:frame];
    if (self)
    {
        senderSuperview = sv;
        beginFieldString = [NSString stringWithFormat:@"Field %@", fn];
        endFieldString = @"\nEnd-Field";
        beforeFunctions = [[NSMutableArray alloc] init];
        afterFunctions = [[NSMutableArray alloc] init];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 32)];
        [firstLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0]];
        [firstLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [firstLabel setTextAlignment:NSTextAlignmentCenter];
        [firstLabel setText:@"Check Code Builder"];
        [self addSubview:firstLabel];
        
        UILabel *secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 32, frame.size.width / 2.0 - 4, 32)];
        [secondLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [secondLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [secondLabel setTextAlignment:NSTextAlignmentRight];
        [secondLabel setText:@"Field Name:"];
        [self addSubview:secondLabel];
        
        UILabel *thirdLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 + 4, 32, frame.size.width / 2.0 - 4, 32)];
        [thirdLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [thirdLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [thirdLabel setTextAlignment:NSTextAlignmentLeft];
        [thirdLabel setText:[NSString stringWithFormat:@"%@", fn]];
        [self addSubview:thirdLabel];

        UILabel *fourthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, frame.size.width / 2.0 - 4, 32)];
        [fourthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [fourthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [fourthLabel setTextAlignment:NSTextAlignmentRight];
        [fourthLabel setText:@"Field Type:"];
        [self addSubview:fourthLabel];
        
        UILabel *fifthLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width / 2.0 + 4, 64, frame.size.width / 2.0 - 4, 32)];
        [fifthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16.0]];
        [fifthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [fifthLabel setTextAlignment:NSTextAlignmentLeft];
        [fifthLabel setText:[NSString stringWithFormat:@"%@", ft]];
        [self addSubview:fifthLabel];

        UILabel *sixthLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 96, frame.size.width - 16, 32)];
        [sixthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
        [sixthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
        [sixthLabel setTextAlignment:NSTextAlignmentLeft];
        [sixthLabel setText:@"Select when execution will occur:"];
        [self addSubview:sixthLabel];

        UIButton *beforeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 128, frame.size.width / 2.0, 32)];
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
        
        UIButton *afterButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width / 2.0, 128, frame.size.width / 2.0, 32)];
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
    }
    return self;
}

- (void)beforeOrAfterButtonPressed:(UIButton *)sender
{
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
    
    UILabel *sixthLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 96, self.frame.size.width - 16, 32)];
    [sixthLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0]];
    [sixthLabel setTextColor:[UIColor colorWithRed:88/255.0 green:89/255.0 blue:91/255.0 alpha:1.0]];
    [sixthLabel setTextAlignment:NSTextAlignmentLeft];
    [sixthLabel setText:@"Select a function to execute:"];
    [selectFunctionView addSubview:sixthLabel];

    if ([[[sender titleLabel] text] isEqualToString:@"After"])
    {
        if ([[sender.layer valueForKey:@"FieldType"] isEqualToString:@"Date"])
        {
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
        }
    }
    else
    {
        NSLog(@"Before button pressed");
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
    if ([[[sender titleLabel] text] isEqualToString:@"Years"])
    {
        Years *years = [[Years alloc] initWithFrame:CGRectMake([sender superview].frame.origin.x,
                                                               -[sender superview].frame.size.height,
                                                               [sender superview].frame.size.width,
                                                               [sender superview].frame.size.height)
                        AndCallingButton:sender];
        [[sender superview] addSubview:years];
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            [years setFrame:CGRectMake(0, 0, [sender superview].frame.size.width, [sender superview].frame.size.height)];
        } completion:^(BOOL finished){
        }];
    }
    else
    {
        NSLog(@"%@", [[sender titleLabel] text]);
        if ([[sender.layer valueForKey:@"BeforeAfter"] isEqualToString:@"Before"])
        {
        }
        if ([[sender.layer valueForKey:@"BeforeAfter"] isEqualToString:@"After"])
        {
            if (![afterFunctions containsObject:[[sender titleLabel] text]])
                [afterFunctions addObject:[[sender titleLabel] text]];
        }
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
                [checkCodeMutableString appendString:@"\n\tBefore"];
                for (int i = 0; i < [beforeFunctions count]; i++)
                {
                    [checkCodeMutableString appendFormat:@"\n\t\t%@", [beforeFunctions objectAtIndex:i]];
                }
                [checkCodeMutableString appendString:@"\n\tEnd-Before"];
            }
            if ([afterFunctions count] > 0)
            {
                [checkCodeMutableString appendString:@"\n\tAfter"];
                for (int i = 0; i < [afterFunctions count]; i++)
                {
                    [checkCodeMutableString appendFormat:@"\n\t\t%@", [afterFunctions objectAtIndex:i]];
                }
                [checkCodeMutableString appendString:@"\n\tEnd-After"];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
